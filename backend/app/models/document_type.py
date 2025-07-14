from sqlalchemy import select, delete
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing import TYPE_CHECKING, List

from config import DOCUMENT_TYPES
from .database import db

if TYPE_CHECKING:
    from .document import Document
    from .keywords import Keyword


class DocumentType(db.Model):
    __tablename__ = 'document_types'
    id: Mapped[int] = mapped_column(primary_key=True)
    code: Mapped[str] = mapped_column(unique=True)
    type_name: Mapped[str]
    url: Mapped[str]

    documents: Mapped[List['Document']] = relationship(back_populates='type')
    keywords: Mapped[List['Keyword']] = relationship(back_populates='document_type')

    def __repr__(self) -> str:
        return f"DocumentType(id={self.id!r}, type={self.type!r})"

    def as_dict(self):
        return {"id": self.id,
                "code": self.code,
                "type_name": self.type_name,
                "url": self.url}


def init_document_types():
    for code, type_name, url in DOCUMENT_TYPES:
        db.session.add(DocumentType(code=code, type_name=type_name, url=url))
    db.session.commit()


def get_all_types():
    result = []
    for row in db.session.scalars(select(DocumentType)).all():
        result.append({"id": row.id, "code": row.code, "typeName": row.type_name, "url": row.url})
    return result


def is_empty():
    return not bool(DocumentType.query.first())


def create_document_type(code: str, type_name: str):
    new_doc_type = DocumentType(code=code, type_name=type_name)
    db.session.add(new_doc_type)
    db.session.commit()
    return new_doc_type.as_dict()


def delete_document_type(id: int):
    stmt = delete(DocumentType).where(DocumentType.id == id)
    db.session.execute(stmt)
    db.session.commit()


def update_document_type(id: int, code: str, type_name: str):
    stmt = select(DocumentType).where(DocumentType.id == id)
    doc_type = db.session.scalars(stmt).one()
    doc_type.code = code
    doc_type.type_name = type_name
    db.session.commit()
    return doc_type.as_dict()
