from werkzeug.datastructures import FileStorage
from pathlib import Path
from io import BytesIO
from shutil import rmtree
from sqlalchemy import select

from models.file import File

from ..file import create_folder, get_path
from ..project import create_project
from ..ver_file import create_ver_file, File
from .get_files import get_nested_files_with_relpath
from ..database import db


def recursive_path_creation(parent_id, path):
    name = path.name
    if name == ".gitkeep":
        return

    if not path.is_dir():
        # Читаем содержимое файла в буфер
        with open(path, 'rb') as f:
            file_data = f.read()

        # Создаём временный файл в памяти
        file_like = BytesIO(file_data)
        file_storage = FileStorage(file_like, filename=name, content_type='application/octet-stream')

        create_ver_file(
            parent_id=parent_id,
            file_type_id=3,
            name=name,
            prev_ver_id=None,
            file_storage=file_storage,
            status_id=1,
            document_type_id=1,
            completion_percentage=10,
            need_analytic=True,
        )
        return

    # Это директория — создаём папку
    folder = create_folder(parent_id, name)
    for child in path.iterdir():
        recursive_path_creation(folder["id"], child)


def create_project_from_template(template_path: str, project_name: str, documents_count: int):
    project_data = None
    try:
        project_data = create_project(project_name, documents_count)
        root_folder_id = project_data["file_id"]

        template_dir = Path(template_path)
        for item in template_dir.iterdir():
            recursive_path_creation(root_folder_id, item)

    except Exception as e:
        if project_data:
            project_id = project_data["id"]
            rmtree(get_path(project_data["file_id"])[0])
            nested_file_ids = [str(file["id"]) for file in get_nested_files_with_relpath(project_id)] + [str(project_id)]
            files = select(File).where(File.id.in_(nested_file_ids))
            for file in db.session.scalars(files):
                db.session.delete(file)
            db.session.commit()
        raise e

    return project_data