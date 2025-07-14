from typing import TYPE_CHECKING
from sqlalchemy import ForeignKey, delete, select
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import db

if TYPE_CHECKING:
    from document_type import DocumentType


class Keyword(db.Model):
    __tablename__ = 'keywords'
    id: Mapped[int] = mapped_column(primary_key=True)
    tag: Mapped[str] = mapped_column(unique=True)
    content: Mapped[str]

    document_type_id: Mapped[int] = mapped_column(ForeignKey('document_types.id'))
    document_type: Mapped['DocumentType'] = relationship(back_populates='keywords')

    def __repr__(self) -> str:
        return f"Keyword(id={self.id!r}, document_type_id={self.document_type_id!r}, tag={self.tag!r}, content={self.content!r})"

    def as_dict(self):
        return {"id": self.id,
                "document_type_id": self.document_type_id,
                "tag": self.tag,
                "content": self.content}


def create_keyword(document_type_id: int, tag: str, content: str):
    new_keyword = Keyword(document_type_id=document_type_id, tag=tag, content=content)
    db.session.add(new_keyword)
    db.session.commit()
    return new_keyword.as_dict()


def delete_keyword(id: int):
    stmt = delete(Keyword).where(Keyword.id == id)
    db.session.execute(stmt)
    db.session.commit()


def update_keyword(id: int, document_type_id: int, tag: str, content: str):
    stmt = select(Keyword).where(Keyword.id == id)
    keyword = db.session.scalars(stmt).one()
    keyword.document_type_id = document_type_id
    keyword.tag = tag
    keyword.content = content
    db.session.commit()
    return keyword.as_dict()


def get_keywords_by_doc_type(doc_type_id: int):
    stmt = select(Keyword).where(Keyword.document_type_id == doc_type_id)
    res = []
    for keyword in db.session.scalars(stmt).all():
        res.append(keyword.as_dict())
    return res


def get_all_keywords():
    result = []
    for keyword in db.session.scalars(select(Keyword)).all():
        result.append(keyword.as_dict())
    return result


def get_keyword(id: int):
    stmt = select(Keyword).where(Keyword.id == id)
    keyword = db.session.scalars(stmt).one()
    return keyword.as_dict()
