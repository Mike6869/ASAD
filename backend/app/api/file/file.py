import tempfile
import time
from typing import Dict, TypedDict
import warnings
import psutil
from collections import OrderedDict as odict
import json
import os
from os.path import join
from sqlalchemy.orm.exc import NoResultFound

from docx import Document

from models.document import Document as Tempate
from flask import Blueprint, request, jsonify, send_file
from werkzeug.exceptions import BadRequest, Forbidden, InternalServerError
from authlib.integrations.flask_oauth2 import current_token
import textdistance

from models.document_status import get_all_statuses
from models.document_type import get_all_types
from models.file import delete_files, create_folder, get_file_type_id, \
    rename as rename_file, get_project_list, get_path, get_name, is_project, get_file_by_id
from models.project import update_project
from models.ver_file import create_ver_file, delete_ver_file, get_versioned_files_by_head_id, get_branch_id, \
    rename_branch, compare_files, get_versioned_files_by_branch_id, get_ver_file_stat, get_head_id
from models.abbreviation import get_abbreviations_by_ids
from models.document import get_document_info, get_wordcloud_path, get_document_tables, \
    find_docs_contains_substr
from models.user_role import add_roles_to_project_creator, has_role_to_create_project, get_allowed_project_list
from models.common.get_files import get_children_files, get_abbr_files, get_nested_files_with_relpath, \
    get_nested_docs_with_relpath
from models.common.create_project_from_template import create_project_from_template
from ..utils import get_file_from_request, get_img_list, get_user_id
from ..utils import user as user_auth
from ..utils.download_from_mail_disk import download_file_from_url
from ..utils.get_file_without_bracket import clear_brackets
from ..utils.standardcontrol import analyze_non_breaking, analyze_indent, analyze_margins, analyze_count_abbreviations
from config import FILE_TYPE_ID, TEMPLATE_FOLDER, MIN_SIMILARITY, DOCUMENT_COMPLETION_PERCENTAGES, CONTEXT_LENGTH, DOCUMENT_TYPES
from auth import oidc
from models.file import File
from models.database import db
from difflib import SequenceMatcher
from models.common.parse_docx import get_text, get_metadata, parse_tables
from utils.chunk import create_re_chunk, get_left_shift_ind
import logging
from logging import NullHandler

# Настройка "тихого" логгера для модуля docx
docx_logger = logging.getLogger('docx')
docx_logger.addHandler(NullHandler())
docx_logger.propagate = False

# Настройка основного логгера
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Фильтр для подавления конкретных сообщений
class TableErrorFilter(logging.Filter):
    def filter(self, record):
        return not record.getMessage().startswith('Error processing table')

# Применение фильтра
logging.getLogger().addFilter(TableErrorFilter())

files_app = Blueprint("files_app", __name__)


@files_app.get("/test_oidc")
@oidc.accept_token()
def test_oidc():
    print(current_token)
    return jsonify(f'Welcome {current_token["username"]}')


@files_app.post("/")
@oidc.accept_token()
def create_new_project():
    user_id = get_user_id()
    if not has_role_to_create_project(user_id):
        raise Forbidden('No rights to create projects')

    name = request.json["name"]
    documents_count = request.json["documentsCount"]
    template_path = join(TEMPLATE_FOLDER, request.json["templatePath"])
    project = create_project_from_template(
        template_path, name, documents_count)
    add_roles_to_project_creator(user_id, project['project_id'])
    return jsonify(project)


@files_app.delete("/<int:file_id>")
@oidc.accept_token()
def delete_entity(file_id):
    user_auth.check_delete_role(file_id)
    if get_file_type_id(file_id) in [FILE_TYPE_ID["VerFile"], FILE_TYPE_ID["Document"]]:
        deleted_entity = delete_ver_file(file_id)
    else:
        deleted_entity = delete_files(file_id)
    return jsonify(deleted_entity)


@files_app.post("/<int:parent_id>")
@oidc.accept_token()
def create_file(parent_id):
    if parent_id <= 0:
        raise BadRequest(f"Id is incorrect ({parent_id=})")
    user_auth.check_write_role(parent_id)

    name = request.form["name"]
    if not name:
        raise BadRequest("name is required")
    
    file_type_id = request.form.get('typeId', type=int)

    if file_type_id in [FILE_TYPE_ID["VerFile"], FILE_TYPE_ID["Document"]]:
        file = get_file_from_request(request, "file")
        prev_ver_id = request.form.get('prevVerId', None)
        status_id = request.form.get('statusId', 1)
        document_type_id = request.form.get('documentTypeId', 1)
        completion_percentage = request.form.get('completionPercentage', 10)
        need_analytic = request.form.get('needAnalytic', 'True').lower() in {'true', '1'}
        created_file = create_ver_file(
            parent_id=parent_id,
            file_type_id=file_type_id,
            name=name,
            prev_ver_id=prev_ver_id,
            file_storage=file,
            status_id=status_id,
            document_type_id=document_type_id,
            completion_percentage=completion_percentage,
            need_analytic=need_analytic
        )
    else:
        raise BadRequest(f"typeId is required ({file_type_id=})")

    return jsonify(created_file)

@files_app.post("/folder/<int:parent_id>")
@oidc.accept_token()
def create_fold(parent_id):
    if parent_id <= 0:
        raise BadRequest(f"Id is incorrect ({parent_id=})")
    user_auth.check_write_role(parent_id)

    data = request.get_json()
    if not data or "name" not in data:
        raise BadRequest("name is required")
    
    file_type_id = data.get('typeId', None)
    if file_type_id is not None:
        file_type_id = int(file_type_id)

    if file_type_id == FILE_TYPE_ID["Folder"]:
        name = data["name"]
        created_folder = create_folder(parent_id, name)

    return jsonify(created_folder)


@files_app.post("/<int:parent_id>/sorting")
@oidc.accept_token()
def sorting_folder(parent_id: int):
    if parent_id <= 0:
        raise BadRequest(f"Id is incorrect ({parent_id=})")
    user_auth.check_write_role(parent_id)
    file_ids = request.form.getlist('fileIds')
    files = File.query.filter(File.id.in_(
        file_ids), File.parent_id == parent_id).all()
    if len(files) != len(file_ids) or not file_ids:
        return BadRequest("Some ids in filesIds not exist or not unique in given array")

    class FileWithMetadata(TypedDict):
        file: File
        metadata: Dict

    # Быстрая группировка по авторам и датам создания файла
    other_files = []
    metadata_dict = {}
    for file in files:
        if any(file.name.endswith(filetype) for filetype in {'.docx', '.doc'}):
            metadata = get_metadata(file.path)
            metadata_dict.setdefault(f"{metadata['author']}\t{metadata['created']}", []).append(
                FileWithMetadata(
                    file=file,
                    metadata=metadata
                )
            )
        else:
            other_files.append(file)
    for number, (key, files) in enumerate(metadata_dict.items()):
        files.sort(key=lambda x: x['metadata']['modified'], reverse=True)
        count = len(files)
        last_ver_file_id = None
        for number, file in enumerate(files):
            created_file = create_ver_file(
                parent_id=parent_id,
                prev_ver_id=last_ver_file_id,
                completion_percentage=int(50 * (number + 1) / count),
                file=file['file'],
                ignore_same_files=True
            )
            last_ver_file_id = created_file['id']
    for file in other_files:
        create_ver_file(
            parent_id=parent_id,
            file=file
        )
    db.session.commit()
    return jsonify('Ok')


@files_app.patch("/<int:file_id>")
@oidc.accept_token()
def edit_file(file_id):
    user_auth.check_write_role(file_id)

    new_name = request.json["name"]
    updated_file = None
    if new_name:
        if get_file_type_id(file_id) == FILE_TYPE_ID["Folder"]:
            updated_file = rename_file(file_id, new_name)
        else:
            branch_id = get_branch_id(file_id)
            updated_file = rename_branch(branch_id, new_name)
        return updated_file
    documents_count = request.json['documents_count']
    if documents_count:
        updated_file = update_project(file_id, documents_count)
    if not updated_file:
        raise InternalServerError("The file wasn't updated")
    return jsonify(updated_file)


@files_app.get("/<int:entity_id>")
@oidc.accept_token()
def get_files(entity_id):
    print("Loading files for entity_id:", entity_id)
    try:
        user_auth.check_read_role(entity_id)

        type_id = get_file_type_id(entity_id)
        files = None
        if type_id == FILE_TYPE_ID["Folder"]:
            files = get_children_files(entity_id)
        elif type_id in [FILE_TYPE_ID["VerFile"], FILE_TYPE_ID["Document"]]:
            files = get_versioned_files_by_head_id(entity_id)
        else:
            raise BadRequest(
                f"{entity_id} must be a folder or head of versioned file")
    except NoResultFound as e:
        print("NoResultFound for entity_id:", entity_id)
        raise
    return jsonify(files)


@files_app.get("/<int:entity_id>/download")
@oidc.accept_token()
def download_file(entity_id):
    user_auth.check_read_role(entity_id)

    type_id = get_file_type_id(entity_id)
    if type_id == FILE_TYPE_ID["Folder"]:
        raise BadRequest(f"{entity_id} must be a Document or VerFile ")
    path, name = get_path(entity_id)
    return send_file(path, as_attachment=True, download_name=name)


@files_app.get("/")
@oidc.accept_token()
def get_projects():
    user_id = user_auth.get_user_id()
    projects_ids = get_allowed_project_list(user_id)
    projects = get_project_list(projects_ids)
    return jsonify(projects)


@files_app.get("/<int:file_id>/abbreviations")
@oidc.accept_token()
def get_file_abbreviations(file_id):
    if file_id == 0:
        return jsonify({"abbreviations": [], "files": []})

    user_auth.check_read_role(file_id)
    files = get_abbr_files(file_id)
    res = dict()
    res["abbreviations"] = get_abbreviations_by_ids(
        [file.id for file in files])
    res["files"] = {file.id: file.name for file in files}
    return jsonify(res)


@files_app.get("/<int:file_id>/stats")
@oidc.accept_token()
def get_file_stats(file_id):
    user_auth.check_read_role(file_id)

    if file_id == 0:
        return jsonify({"fileTypeId": FILE_TYPE_ID["Folder"],
                        "stats": []})
    type_id = get_file_type_id(file_id)
    if type_id == FILE_TYPE_ID["Folder"]:
        if is_project(file_id):
            file = get_file_by_id(file_id)
            docs_with_relpath = get_nested_docs_with_relpath(file_id)
            document_list = []
            for document, _ in docs_with_relpath:
                document_list.append(
                    document.documents[0].as_dict(camel_case=True))
            return jsonify({"fileTypeId": FILE_TYPE_ID["Folder"], "isProject": True,
                            "stats": {"id": file_id, "name": file.name, "createdAt": file.created_at,
                                      "expectedNumberOfDocuments": file.project.documents_count,
                                      "documentsList": document_list}})
        return jsonify({"fileTypeId": FILE_TYPE_ID["Folder"], "isProject": False,
                        "stats": get_nested_files_with_relpath(file_id)})
    elif type_id == FILE_TYPE_ID["VerFile"]:
        return jsonify({"fileTypeId": type_id, "stats": get_ver_file_stat(file_id)})
    elif type_id == FILE_TYPE_ID["Document"]:
        stat = get_document_info(file_id)
        if stat:
            stat["name"] = get_name(file_id)
            return jsonify({"fileTypeId": type_id, "stats": stat})
        return []
    raise BadRequest(f"Unknown file type({type_id=})")


@files_app.get("/<int:file_id>/word-cloud")
@oidc.accept_token()
def get_word_cloud(file_id):
    user_auth.check_read_role(file_id)

    path = get_wordcloud_path(file_id)
    if path:
        return send_file(path, mimetype='image/png')
    else:
        raise BadRequest(f"There is no word-cloud for this file({file_id=})")


@files_app.get("/<int:file_id>/media")
@oidc.accept_token()
def get_media(file_id):
    user_auth.check_read_role(file_id)

    if file_id == 0:
        return jsonify({'imgList': []})

    file_path, _ = get_path(file_id)
    if not file_path.endswith('.docx'):
        return jsonify({'imgList': []})
    return jsonify({'imgList': get_img_list(file_path)})


@files_app.get("/<int:file_id>/tables")
@oidc.accept_token()
def get_tables(file_id):
    user_auth.check_read_role(file_id)

    if file_id == 0:
        return jsonify({'tables': []})

    tables = get_document_tables(file_id)
    if not tables:
        return jsonify({'tables': []})
    return jsonify({"tables": tables})


@files_app.get("/compare")
@oidc.accept_token()
def compare_ver_files():
    first_version_id = request.args.get("firstVersion", type=int)
    second_version_id = request.args.get("secondVersion", type=int)
    if not (isinstance(first_version_id, int) and isinstance(second_version_id, int)):
        raise BadRequest(
            f"Invalid request({first_version_id=}, {second_version_id=})")
    user_auth.check_read_role(first_version_id)
    user_auth.check_read_role(second_version_id)
    return jsonify(compare_files(first_version_id, second_version_id))

@files_app.get("/compare-files")
@oidc.accept_token()
def compare_with_template():
    first_version_id = request.args.get("firstVersion", type=int)
    user_auth.check_read_role(first_version_id)
    """Сравнивает файл с заданным ID с жёстко заданным шаблоном"""
    doc1 = Tempate.query.filter_by(file_id=first_version_id).one()

    #наш шаблон
    mail_drive_file_content = download_file_from_url(
        'https://cloud.mail.ru/public/PEVz/NzJG7cN1u')

    doc2 = clear_brackets(mail_drive_file_content)
    s = SequenceMatcher(None, doc1.text, doc2)
    result = []
    for tag, i1, i2, j1, j2 in s.get_opcodes():
        if tag != 'equal':
            first_chunk = create_re_chunk(doc1.text[get_left_shift_ind(i1, CONTEXT_LENGTH):i1], doc1.text[i1:i2],
                                          doc1.text[i2:i2 + CONTEXT_LENGTH])
            second_chunk = create_re_chunk(doc2[get_left_shift_ind(j1, CONTEXT_LENGTH):j1], doc2[j1:j2],
                                           doc2[j2:j2 + CONTEXT_LENGTH])
            result.append({"tag": tag, "firstSequence": first_chunk, "secondSequence": second_chunk})
    return jsonify(result)

@files_app.get("/branch/<int:branch_id>")
@oidc.accept_token()
def get_branch_files(branch_id):
    head_id = get_head_id(branch_id)
    user_auth.check_read_role(head_id)
    return jsonify(get_versioned_files_by_branch_id(branch_id))


@files_app.post("/<int:file_id>/similarity")
@oidc.accept_token()
def find_doc_similarity(file_id):
    try:
        user_auth.check_read_role(file_id)
    except Exception as e:
        return jsonify({"error": str(e)}), 403

    try:
        file = get_file_from_request(request, "file")
        doc_text_1 = get_text(file)
    except Exception as e:
        return jsonify({"error": f"Failed to process the uploaded file: {str(e)}"}), 400

    try:
        documents = get_nested_docs_with_relpath(file_id)
    except Exception as e:
        return jsonify({"error": f"Failed to retrieve nested documents: {str(e)}"}), 500

    if not documents:
        return jsonify({"message": "No nested documents found."}), 200

    result = []
    for document, rel_path in documents:
        try:
            doc_text_2 = document.documents[0].text
        except IndexError as e:
            print(f"Warning: Document with id {document.id} has no documents.")
            continue

        try:
            similarity = textdistance.jaccard.normalized_similarity(doc_text_1, doc_text_2)
        except Exception as e:
            print(f"Warning: Failed to calculate similarity for document {document.id}: {str(e)}. Skipping...")
            continue

        if similarity > MIN_SIMILARITY:
            try:
                result.append({
                    **document.ver_file[0].as_dict(),
                    'rel_path': rel_path,
                    'similarity': round(similarity, 3)
                })
            except IndexError as e:
                print(f"Warning: Document with id {document.id} has no ver_files.")
                continue

    return jsonify(result)


#проверка наличия неразрывного пробела
@files_app.get("/<int:file_id>/standardcontrol")
@oidc.accept_token()
def validate_standardcontrol(file_id: int) -> str:
    user_auth.check_read_role(file_id)

    # Получаем данные из трёх функций
    non_breaking = analyze_non_breaking(
        file_id)  # неразрывные пробелы
    indent = analyze_indent(
        file_id)  # отступы
    margin = analyze_margins(
        file_id)  # поля
    abbreviations = analyze_count_abbreviations(file_id)

    def convert(o):
        if isinstance(o, odict):
            return dict(o)
        return o

    combined_data = {
        "non_breaking": non_breaking,
        "indent": indent,
        "margins": margin,
        'abbreviations': abbreviations,
    }
    return json.dumps(combined_data, indent=2, ensure_ascii=False,
                      default=convert)


@files_app.get("/metadata")
@oidc.accept_token()
def get_metadata_view():
    metadata = dict()
    metadata["completionPercentages"] = DOCUMENT_COMPLETION_PERCENTAGES
    metadata["statuses"] = get_all_statuses()
    metadata["types"] = get_all_types()
    return jsonify(metadata)


@files_app.get('/<int:parent_folder_id>/substr-docs')
@oidc.accept_token()
def get_docs_substr(parent_folder_id: int):
    user_auth.check_read_role(parent_folder_id)
    pattern = request.args.get('pattern', '')
    if len(pattern) < 4 or not parent_folder_id:
        raise BadRequest(f'Incorrect request({pattern=}, {parent_folder_id=})')

    docs = get_nested_docs_with_relpath(parent_folder_id)
    docs_ids = [doc.file.id for doc in docs]
    return jsonify(find_docs_contains_substr(docs_ids, pattern))


@files_app.get("/<int:entity_id>/get-file-path")
@oidc.accept_token()
def view_file(entity_id):
    user_auth.check_read_role(entity_id)
    
    if entity_id == 0:
        return jsonify({'file': []})

    type_id = get_file_type_id(entity_id)
    if not type_id:
        return jsonify({'file': []})

    if type_id == FILE_TYPE_ID["Folder"]:
        return jsonify({'file': []})
    path, name = get_path(entity_id)
    return send_file(path, as_attachment=False, mimetype='application/vnd.openxmlformats-officedocument.wordprocessingml.document')

#поиск типа документа
@files_app.post('/check-document-type')
@oidc.accept_token()
def check_document_type():
    if 'file' not in request.files:
        return json.dumps({"error": "No file provided"}, ensure_ascii=False), 400
    
    file = request.files['file']
    if not file.filename.lower().endswith('.docx'):
        return json.dumps({"error": "Invalid file type"}, ensure_ascii=False), 400
    
    temp_path = os.path.join(tempfile.gettempdir(), file.filename)
    file.save(temp_path)
    
    try:
        doc = Document(temp_path)
        phrases = [doc_type[1].lower() for doc_type in DOCUMENT_TYPES]
        first_match = None
        earliest_position = float('inf')
        full_text = []
        page_break_found = False

        # Сбор текста первой страницы
        for paragraph in doc.paragraphs:
            if page_break_found:
                break

            para_text = []
            for run in paragraph.runs:
                xml = run._element.xml
                if ('lastRenderedPageBreak' in xml or
                        ('w:br' in xml and 'type="page"' in xml) or
                        ('w:sectPr' in xml and 'nextPage' in xml)):
                    page_break_found = True
                    break
                para_text.append(run.text)

            if not page_break_found:
                full_text.append(''.join(para_text))

        full_text = ' '.join(full_text).lower()
        for i, phrase in enumerate(phrases):
            pos = full_text.find(phrase)
            if pos != -1 and pos < earliest_position:
                earliest_position = pos
                first_match = DOCUMENT_TYPES[i][1]

        result = {
            "documentType": first_match,
            "status": "success",
            "matchPosition": earliest_position if first_match else None
        }
        return json.dumps(result, ensure_ascii=False)
    except Exception as e:
        return json.dumps({"error": str(e), "status": "error"}, ensure_ascii=False), 500
    finally:
        if os.path.exists(temp_path):
            try:
                os.remove(temp_path)
            except:
                pass