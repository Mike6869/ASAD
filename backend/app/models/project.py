from typing import TYPE_CHECKING, List
from werkzeug.exceptions import BadRequest
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped
from sqlalchemy.orm import mapped_column
from sqlalchemy.orm import relationship

from .database import db
from .file import File, create_folder

if TYPE_CHECKING:
    from .user_role import UserRole


class Project(db.Model):
    __tablename__ = 'projects'

    id: Mapped[int] = mapped_column(primary_key=True)
    documents_count: Mapped[int]
    file_id: Mapped[int] = mapped_column(ForeignKey('files.id'))

    file: Mapped['File'] = relationship(back_populates='project')
    user_roles: Mapped[List['UserRole']] = relationship(back_populates='project', cascade="all, delete-orphan")

    def as_dict(self):
        return dict(self.file.as_dict(), documents_count=self.documents_count)

    def __repr__(self):
        return f'Project(id={self.id!r}, documents_count={self.documents_count!r}, file_id={self.file_id!r})'


def create_project(name, documents_count):
    # Проверяем, существует ли уже проект с таким именем
    existing_file = File.query.filter_by(name=name, parent_id=0).first()
    if existing_file:
        raise BadRequest(f"Проект с именем '{name}' уже существует")

    # Создаём корневую папку проекта
    new_folder = create_folder(parent_id=0, name=name)
    file_id = new_folder["id"]

    # Создаём запись в таблице Project, привязанную к этой папке
    project = Project(file_id=file_id, documents_count=documents_count)
    db.session.add(project)
    db.session.commit()

    return {
        "id": new_folder["id"],
        "file_id": file_id,
        "name": new_folder["name"],
        "project_id": project.id,
        "documents_count": project.documents_count,
        "file_type_id": new_folder["file_type_id"]
    }


def update_project(file_id: int, documents_count: int):
    project = Project.query.filter_by(file_id=file_id).one()
    project.documents_count = documents_count
    db.session.commit()
    return project.as_dict()
