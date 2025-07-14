from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import select
from typing import TYPE_CHECKING, List

from config import DOCUMENT_STATUSES
from .database import db

if TYPE_CHECKING:
    from .document import Document


class DocumentStatus(db.Model):
    __tablename__ = 'document_statuses'
    id: Mapped[int] = mapped_column(primary_key=True)
    status: Mapped[str] = mapped_column(unique=True)

    documents: Mapped[List['Document']] = relationship(back_populates='status')

    def __repr__(self) -> str:
        return f"DocumentStatus(id={self.id!r}, status={self.status!r})"


def init_document_statuses():
    for status in DOCUMENT_STATUSES:
        db.session.add(DocumentStatus(status=status))
    db.session.commit()


def is_empty():
    return not bool(DocumentStatus.query.first())


def get_all_statuses():
    result = []
    for row in db.session.scalars(select(DocumentStatus)).all():
        result.append({"id": row.id, "status": row.status})
    return result
