import os
import shutil
from uuid import uuid1
from werkzeug.datastructures.file_storage import FileStorage
from typing import TYPE_CHECKING, Optional, List
from werkzeug.exceptions import BadRequest
from pathlib import Path
from sqlalchemy import Column, Integer, String, DateTime, select
from sqlalchemy.orm import relationship, Mapped, mapped_column
from datetime import datetime

from .database import db
from config import TEMPLATE_PATH, TEMPLATE_TYPE_ID
from .document import delete_document

if TYPE_CHECKING:
    from flask_sqlalchemy.query import Query
    from .project_template import ProjectTemplate


class Template(db.Model):
    __tablename__ = "templates"

    id = Column(Integer, primary_key=True)
    parent_id = Column(Integer, nullable=False)
    project_template_id: Mapped[Optional[int]] = mapped_column()
    name = Column(String, nullable=False, unique=False)
    path = Column(String, nullable=False, unique=True)
    file_type_id = Column(Integer, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    project_template: Mapped[Optional['ProjectTemplate']] = relationship(back_populates='template', cascade="all, delete-orphan")

    def __repr__(self):
        return (f"Template(id={self.id}, parent_id={self.parent_id}, project_template_id={self.project_template_id!r}, "
                f"file_type_id={self.file_type_id}, name={self.name!r}, path={self.path!r}, "
                f"created_at={self.created_at!r})")

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns if c.name != "path"}

    if TYPE_CHECKING:
        query: Query


def delete_children(id):
    children = Template.query.filter_by(parent_id=id).all()
    for child in children:
        delete_document(child.id)
        db.session.delete(child)
        delete_children(child.id)


def get_template_type_id(template_id):
    return Template.query.filter_by(id=template_id).one().file_type_id


def get_name(file_id):
    return Template.query.filter_by(id=file_id).one().name


def delete_templates(file_id):
    entity = Template.query.filter_by(id=file_id).one()
    path = Path(entity.path)

    if path.is_dir():
        shutil.rmtree(path)
    elif path.is_file():
        path.unlink()
    else:
        raise FileNotFoundError(f"Файл или директория по пути {path} не существует")

    delete_children(file_id)
    db.session.delete(entity)
    db.session.commit()
    
    return entity.as_dict()

def create_template_folder(parent_id, name):
    parent_folder = Template.query.filter_by(id=parent_id).first()
    if parent_id != 0:
        parent_folder_path = parent_folder.path
    else:
        parent_folder_path = TEMPLATE_PATH
    new_path = os.path.join(parent_folder_path, name)
    Path(new_path).mkdir()

    new_folder = Template(parent_id=parent_id, name=name, path=new_path, file_type_id=TEMPLATE_TYPE_ID["Folder"])
    db.session.add(new_folder)
    db.session.commit()
    if parent_id != 0:
        new_folder.project_template_id = parent_folder.project_template_id
        db.session.commit()

    return new_folder.as_dict()


def get_project_template_list(project_template_ids: List[int] = None):
    if project_template_ids is None:
        projects_template: List[Template] = Template.query.filter_by(parent_id=0).all()
    elif len(project_template_ids) == 0:
        return []
    else:
        stmt = select(Template).where(Template.parent_id == 0).where(Template.project_template_id.in_(project_template_ids))
        projects_template = db.session.execute(stmt).scalars().all()
    return [project_template.as_dict() for project_template in projects_template] or projects_template


def change_children_path(parent_id):
    children = Template.query.filter_by(parent_id=parent_id).all()
    if not children:
        return
    parent_folder = Template.query.filter_by(id=parent_id).one()
    for child in children:
        child.path = os.path.join(parent_folder.path, child.name)
        change_children_path(child.id)


def rename(file_id, new_name):
    file = Template.query.filter_by(id=file_id).one()
    parent_id = file.parent_id
    if not parent_id:
        new_path = os.path.join(TEMPLATE_PATH, new_name)
    else:
        parent_folder = Template.query.filter_by(id=parent_id).one()
        new_path = os.path.join(parent_folder.path, new_name)

    old_path = file.path
    file.name = new_name
    file.path = new_path
    change_children_path(file.id)
    db.session.commit()
    os.rename(old_path, new_path)
    return file.as_dict()



def add_template(parent_id, file_type_id=None, name=None, file_storage=None, template: Template = None):
    # Создание файла
    if not template:
        parent_file = Template.query.filter_by(id=parent_id, file_type_id=TEMPLATE_TYPE_ID["Folder"]).one()
        new_path = os.path.join(parent_file.path, name)
        file_storage.save(new_path)
        template = Template(parent_id=parent_id, name=name, path=new_path, file_type_id=file_type_id,
                    project_template_id=parent_file.project_template_id)
    else:
        name = template.name
        file_type_id = template.file_type_id
        new_path = template.path
        file_storage = FileStorage(open(new_path, 'rb'))

    db.session.add(template)
    db.session.commit()
    return template.as_dict()


def get_path(template_id):
    template = Template.query.filter_by(id=template_id).one()
    return template.path, template.name


def is_project(file_id):
    file = Template.query.filter_by(id=file_id).one()
    return file.parent_id == 0


def get_template_by_id(template_id: int) -> Template:
    template = Template.query.filter_by(id=template_id).one_or_none()
    return template


def get_project_id(file_id: int) -> Optional[int]:
    stmt = select(Template.project_id).where(Template.id == file_id)
    return db.session.execute(stmt).scalar_one()
