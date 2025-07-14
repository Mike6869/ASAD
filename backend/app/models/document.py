from datetime import datetime
import json
import os
import re
from typing import TYPE_CHECKING, TypedDict, Dict, List
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text, select, and_, func
from sqlalchemy.orm import relationship, Mapped, mapped_column
from uuid import uuid1

from .database import db
from config import WORDCLOUDS_PATH, CONTEXT_LENGTH
from .common.parse_docx import get_text, parse_tables, get_metadata
from .common.generate_wordcloud import generate_wordcloud

if TYPE_CHECKING:
    from flask_sqlalchemy.query import Query
    from .document_status import DocumentStatus
    from .document_type import DocumentType
    from .ver_file import VerFile


class Document(db.Model):
    __tablename__ = "documents"

    id = Column(Integer, primary_key=True)
    file_id = Column(Integer, ForeignKey("files.id"), nullable=False)
    text = Column(Text, nullable=False)
    tables = Column(Text, nullable=False)
    wordcloud_path = Column(String, unique=True, nullable=False)
    words_count = Column(Integer, nullable=False)
    author = Column(String, nullable=False)
    completion_percentage: Mapped[int]
    created_at = Column(DateTime(timezone=True), nullable=False, server_default=func.now())
    modified_at = Column(DateTime(timezone=True), nullable=False, server_default=func.now())
    last_modified_by = Column(String, nullable=False)

    status_id: Mapped[int] = mapped_column(ForeignKey("document_statuses.id"))
    status: Mapped['DocumentStatus'] = relationship(back_populates='documents')

    type_id: Mapped[int] = mapped_column(ForeignKey("document_types.id"))
    type: Mapped['DocumentType'] = relationship(back_populates='documents')

    ver_file_id: Mapped[int] = mapped_column(ForeignKey("versioned_files.id"))
    ver_file: Mapped['VerFile'] = relationship(back_populates='document', cascade="all, delete-orphan",
                                               single_parent=True)

    def __repr__(self):
        return (f"Document(id={self.id}, file_id={self.file_id}, status_id={self.status_id!r}, "
                f"type_id={self.type_id!r}, words_count={self.words_count!r}, author={self.author!r}, "
                f"wordcloud_path={self.wordcloud_path}, created_at={self.created_at!r}, "
                f"modified_at={self.modified_at!r})")

    def as_dict(self, camel_case=False):
        if camel_case:
            res = dict()
            res["id"] = self.id
            res["fileId"] = self.file_id
            res["statusId"] = self.status_id
            res["completionPercentage"] = self.completion_percentage
            res["typeId"] = self.type_id
            res["wordsCount"] = self.words_count
            res["size"] = self.ver_file.size
            res["author"] = self.author
            res["createdAt"] = self.created_at
            res["modifiedAt"] = self.modified_at
            res["lastModifiedBy"] = self.last_modified_by
            return res
        return dict(self.ver_file.as_dict(), words_count=self.words_count, author=self.author,
                    completion_percentage=self.completion_percentage, status_id=self.status_id, type_id=self.type_id,
                    ver_file_id=self.ver_file_id)

    if TYPE_CHECKING:
        query: Query


def create_document(file_instance, ver_file_instance, file_storage, status_id, type_id, completion_percentage):
    text = get_text(file_storage)
    tables = parse_tables(file_storage)
    metadata = get_metadata(file_storage)
    words_count = len(re.findall(r'\w+', text))
    wordcloud_path = os.path.join(WORDCLOUDS_PATH, uuid1().hex + ".png")
    wordcloud = generate_wordcloud(text)
    new_document = Document(file=file_instance, ver_file=ver_file_instance, wordcloud_path=wordcloud_path,
                            words_count=words_count, author=metadata["author"], created_at=metadata["created"],
                            modified_at=metadata["modified"], last_modified_by=metadata["last_modified_by"], text=text,
                            tables=json.dumps(tables), status_id=status_id, type_id=type_id,
                            completion_percentage=completion_percentage)
    db.session.add(new_document)
    wordcloud.to_file(wordcloud_path)
    return new_document



def delete_document(file_id):
    document = Document.query.filter_by(file_id=file_id).one_or_none()
    if document:
        os.remove(document.wordcloud_path)
        db.session.delete(document)
        db.session.commit()


def get_document_info(file_id):
    document = Document.query.filter_by(file_id=file_id).one_or_none()
    if not document:
        return None
    return document.as_dict(camel_case=True)


def get_document_text(file_id):
    document = Document.query.filter_by(file_id=file_id).one_or_none()
    if not document:
        return None
    return document.text


def get_document_tables(file_id):
    document = Document.query.filter_by(file_id=file_id).one_or_none()
    if not document:
        return None
    return json.loads(document.tables)


def get_wordcloud_path(file_id):
    stat = Document.query.filter_by(file_id=file_id).one_or_none()
    if stat:
        return stat.wordcloud_path
    return None


class Chunk(TypedDict):
    prefix: str
    substr: str
    postfix: str


class DocWithSubstr(TypedDict):
    document: Dict
    chunks: List[Chunk]


def find_docs_contains_substr(file_list: List[int], substr: str) -> List[DocWithSubstr]:
    if not file_list or not substr:
        return []

    stmt = select(Document).where(and_(Document.file_id.in_(file_list), Document.text.ilike(f'%{substr}%')))
    docs = db.session.scalars(stmt).all()
    result = []
    for doc in docs:
        substr_indices = [i.start() for i in re.finditer(substr, doc.text, flags=re.IGNORECASE)]
        chunks: List[Chunk] = []
        for i in substr_indices:
            chunks.append({
                "prefix": doc.text[i - CONTEXT_LENGTH:i],
                "substr": doc.text[i:i + len(substr)],
                "postfix": doc.text[i + len(substr) + 1:i + len(substr) + 1 + CONTEXT_LENGTH]
            })
        result.append({"document": doc.as_dict(), "chunks": chunks})
    return result
