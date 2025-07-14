from sqlalchemy import Column, Integer, String, ForeignKey, select
from typing import TYPE_CHECKING

from .database import db
from .common.parse_docx import parse_abbreviations

if TYPE_CHECKING:
    from flask_sqlalchemy.query import Query


class Abbreviation(db.Model):
    __tablename__ = "abbreviations"

    id = Column(Integer, primary_key=True)
    file_id = Column(Integer, ForeignKey("files.id"), nullable=False)
    abbreviation = Column(String, nullable=False)
    description = Column(String, nullable=False)

    def __repr__(self):
        return (f"Abbreviation(id={self.id}, file_id={self.file_id}, "
                f"abbreviation={self.abbreviation}, description={self.description})")

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns if c.name != "path"}

    if TYPE_CHECKING:
        query: Query


def create_abbreviations(file_storage, file_instance):
    abbreviations = parse_abbreviations(file_storage)
    if abbreviations:
        file_instance.has_abbreviations = True
        for abbr, desc in abbreviations:
            abbreviation = Abbreviation(file=file_instance, abbreviation=abbr, description=desc)
            db.session.add(abbreviation)


def delete_abbreviations_by_file_id(file_id):
    abbreviations = Abbreviation.query.filter_by(file_id=file_id).all()
    for row in abbreviations:
        db.session.delete(row)


def get_abbreviations_by_ids(ids):
    stmt = select(Abbreviation).where(Abbreviation.file_id.in_(ids))
    abbreviations = db.session.scalars(stmt).all()
    return [abbr.as_dict() for abbr in abbreviations]


def get_abbreviations_by_file_id(file_id: int):
    stmt = select(Abbreviation).where(Abbreviation.file_id == file_id)
    result = {}
    for abb in db.session.scalars(stmt).all():
        result[abb.abbreviation] = abb.description
    return result
