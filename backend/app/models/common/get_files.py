from collections import namedtuple
from typing import List

from ..file import File
from ..ver_file import VerFile
from config import FILE_TYPE_ID


def get_children_files(parent_id, as_dict=True):
    children = File.query.join(VerFile, isouter=True).filter(File.parent_id == parent_id,
                                                             VerFile.next_ver_id == None).all()  # noqa: E711
    result = []
    if as_dict:
        for child in children:
            if child.ver_file:
                result.append(child.ver_file[0].as_dict())
            else:
                result.append(child.as_dict())
    else:
        for child in children:
            result.append(child)

    return result


def get_nested_abbr_files(parent_id):
    children = File.query.join(VerFile, isouter=True).filter(File.parent_id == parent_id,
                                                             VerFile.next_ver_id == None).all()  # noqa: E711
    if not children:
        return []

    ids = []
    for child in children:
        if child.file_type_id == FILE_TYPE_ID["Folder"]:
            ids.extend(get_nested_abbr_files(child.id))
        elif child.has_abbreviations:
            ids.append(child)
    return ids


def get_abbr_files(id):
    file = File.query.filter_by(id=id).one()
    if file.file_type_id == FILE_TYPE_ID["Folder"]:
        return get_nested_abbr_files(id)
    return [file]


def make_dict_file_with_rel_path(file, rel_path):
    if file["file_type_id"] == FILE_TYPE_ID["Folder"]:
        return {"id": file["id"], "name": file["name"], "relPath": rel_path + file["name"] + "\\"}
    return {"id": file["id"], "name": file["name"], "relPath": rel_path + file["name"]}


def get_nested_files_with_relpath(folder_id):
    root_folder = File.query.filter_by(id=folder_id).one()
    nested_files = []

    def add_nested_files(parend_folder_id, rel_path):
        children_files = get_children_files(parend_folder_id)
        folders = []
        for child_file in children_files:
            if child_file["file_type_id"] == FILE_TYPE_ID["Folder"]:
                folders.append(child_file)
            else:
                nested_files.append(make_dict_file_with_rel_path(child_file, rel_path))
        for folder in folders:
            nested_files.append(make_dict_file_with_rel_path(folder, rel_path))
            add_nested_files(folder["id"], rel_path + folder["name"] + "\\")

    add_nested_files(root_folder.id, "")
    return nested_files


VerFileAndRelPath = namedtuple("VerFileAndRelPath", ['file', 'rel_path'])


def get_nested_docs_with_relpath(folder_id: int) -> List[VerFileAndRelPath]:
    root_folder = File.query.filter_by(id=folder_id).one()
    nested_docs: List[VerFileAndRelPath] = []

    def add_nested_docs(parend_folder_id, rel_path):
        children_files = get_children_files(parend_folder_id, as_dict=False)
        folders = []
        for child_file in children_files:
            if child_file.file_type_id == FILE_TYPE_ID["Folder"]:
                folders.append(child_file)
            else:
                if child_file.file_type_id == FILE_TYPE_ID["Document"]:
                    nested_docs.append(VerFileAndRelPath(child_file, rel_path))
        for folder in folders:
            add_nested_docs(folder.id, rel_path + folder.name + "\\")

    add_nested_docs(root_folder.id, "")
    return nested_docs
