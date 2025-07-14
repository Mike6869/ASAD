import os
import shutil
from typing import TYPE_CHECKING, Optional, List
from pathlib import Path
from sqlalchemy import Column, Integer, String, DateTime, Boolean, select
from sqlalchemy.orm import relationship, Mapped, mapped_column
from datetime import datetime

from .database import db
from config import PROJECT_PATH, FILE_TYPE_ID
from .document import delete_document

if TYPE_CHECKING:
    from flask_sqlalchemy.query import Query
    from .project import Project


class File(db.Model):
    __tablename__ = "files"

    id = Column(Integer, primary_key=True)
    parent_id = Column(Integer, nullable=False)
    project_id: Mapped[Optional[int]] = mapped_column()
    name = Column(String, nullable=False, unique=False)
    path = Column(String, nullable=False, unique=True)
    file_type_id = Column(Integer, nullable=False)
    has_abbreviations = Column(Boolean, nullable=False, default=False)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow, nullable=False)

    ver_file = db.relationship("VerFile", backref="file", cascade="all, delete-orphan")
    abbrs = db.relationship("Abbreviation", backref="file", cascade="all, delete-orphan")
    documents = db.relationship("Document", backref="file", cascade="all, delete-orphan")
    project: Mapped[Optional['Project']] = relationship(back_populates='file', cascade="all, delete-orphan")

    def __repr__(self):
        return (f"File(id={self.id}, parent_id={self.parent_id}, project_id={self.project_id!r}, "
                f"file_type_id={self.file_type_id}, name={self.name!r}, path={self.path!r}, "
                f"created_at={self.created_at!r})")

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns if c.name != "path"}

    if TYPE_CHECKING:
        query: Query


def delete_children(id):
    children = File.query.filter_by(parent_id=id).all()
    for child in children:
        delete_document(child.id)
        db.session.delete(child)
        delete_children(child.id)


def get_file_type_id(file_id):
    return File.query.filter_by(id=file_id).one().file_type_id


def get_name(file_id):
    return File.query.filter_by(id=file_id).one().name


def delete_files(file_id):
    entity = File.query.filter_by(id=file_id).one()
    db.session.delete(entity)
    shutil.rmtree(Path(str(entity.path)))
    delete_children(file_id)
    db.session.commit()
    return entity.as_dict()


def create_folder(parent_id, name):
    parent_folder = File.query.filter_by(id=parent_id).first()
    if parent_id != 0:
        parent_folder_path = parent_folder.path
    else:
        parent_folder_path = PROJECT_PATH
    new_path = os.path.join(parent_folder_path, name)
    Path(new_path).mkdir()

    new_folder = File(parent_id=parent_id, name=name, path=new_path, file_type_id=FILE_TYPE_ID["Folder"])
    db.session.add(new_folder)
    db.session.commit()
    if parent_id != 0:
        new_folder.project_id = parent_folder.project_id
        db.session.commit()

    return new_folder.as_dict()


def get_project_list(project_ids: List[int] = None):
    if project_ids is None:
        projects: List[File] = File.query.filter_by(parent_id=0).all()
    elif len(project_ids) == 0:
        return []
    else:
        stmt = select(File).where(File.parent_id == 0).where(File.project_id.in_(project_ids))
        projects = db.session.execute(stmt).scalars().all()
    return [project.as_dict() for project in projects] or projects


def change_children_path(parent_id):
    children = File.query.filter_by(parent_id=parent_id).all()
    if not children:
        return
    parent_folder = File.query.filter_by(id=parent_id).one()
    for child in children:
        child.path = os.path.join(parent_folder.path, child.name)
        change_children_path(child.id)


def rename(file_id, new_name):
    file = File.query.filter_by(id=file_id).one()
    parent_id = file.parent_id
    if not parent_id:
        new_path = os.path.join(PROJECT_PATH, new_name)
    else:
        parent_folder = File.query.filter_by(id=parent_id).one()
        new_path = os.path.join(parent_folder.path, new_name)

    old_path = file.path
    file.name = new_name
    file.path = new_path
    change_children_path(file.id)
    db.session.commit()
    os.rename(old_path, new_path)
    return file.as_dict()


def get_path(file_id):
    file = File.query.filter_by(id=file_id).one()
    return file.path, file.name


def is_project(file_id):
    file = File.query.filter_by(id=file_id).one()
    return file.parent_id == 0


def get_file_by_id(file_id: int) -> File:
    file = File.query.filter_by(id=file_id).one_or_none()
    return file


def get_project_id(file_id: int) -> Optional[int]:
    stmt = select(File.project_id).where(File.id == file_id)
    return db.session.execute(stmt).scalar_one()
