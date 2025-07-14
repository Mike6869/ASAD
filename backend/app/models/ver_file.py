from typing import TYPE_CHECKING, Optional
import os
from uuid import uuid1
from sqlalchemy import Column, Float, Integer, ForeignKey, Sequence, select, func
from sqlalchemy.orm import Mapped, relationship
from difflib import SequenceMatcher

from werkzeug.datastructures.file_storage import FileStorage
from werkzeug.exceptions import BadRequest, NotFound

from utils.chunk import create_re_chunk, get_left_shift_ind
from .database import db
from config import FILE_TYPE_ID
from .file import File
from .abbreviation import create_abbreviations, delete_abbreviations_by_file_id
from .document import create_document, delete_document, Document
from .common.get_file_size import get_file_size
from config import CONTEXT_LENGTH

if TYPE_CHECKING:
    from flask_sqlalchemy.query import Query

branch_id_seq = Sequence("branch_id_seq", metadata=db.metadata, start=1)


class VerFile(db.Model):
    __tablename__ = "versioned_files"

    id = Column(Integer, primary_key=True)
    file_id = Column(Integer, ForeignKey("files.id"), nullable=False)
    next_ver_id = Column(Integer, nullable=True)
    prev_ver_id = Column(Integer, nullable=True)
    ver_num = Column(Integer, nullable=False)
    branch_id = Column(Integer, nullable=False)
    size = Column(Float, nullable=False)

    document: Mapped[Optional[Document]] = relationship(back_populates='ver_file')

    def __repr__(self):
        return (f"VerFile(id={self.id!r}, file_id={self.file_id!r}, next_ver_id={self.next_ver_id!r}, "
                f"prev_ver_id={self.prev_ver_id!r}, branch_id={self.branch_id!r}, ver_num={self.ver_num!r})")

    def as_dict(self):
        return dict(self.file.as_dict(), next_ver_id=self.next_ver_id, prev_ver_id=self.prev_ver_id,
                    branch_id=self.branch_id, ver_num=self.ver_num, size=self.size)

    if TYPE_CHECKING:
        query: Query


def next_branch_id():
    return db.session.execute(branch_id_seq)


def next_ver_num(branch_id):
    stmt = select(func.max(VerFile.ver_num)).where(VerFile.branch_id == branch_id)
    cur_max_ver = db.session.scalars(stmt).one_or_none()
    return 1 if cur_max_ver is None else cur_max_ver + 1


def get_ver_file_stat(file_id):
    ver_file = VerFile.query.filter_by(file_id=file_id).one()
    return {"name": ver_file.file.name, "createdAt": ver_file.file.created_at, "size": ver_file.size}


def create_ver_file(parent_id, file_type_id=None, name=None, prev_ver_id=None, file_storage=None, status_id: int = 1,
                    document_type_id: int = 1, completion_percentage: int = None, file: File = None,
                    need_analytic: bool = True, ignore_same_files: bool = False):
    # Создание файла
    if not file:
        if File.query.join(VerFile).filter(File.parent_id == parent_id, File.name == name, File.id != prev_ver_id,
                                           VerFile.next_ver_id == None,  # noqa: E711
                                           VerFile.file_id == prev_ver_id).one_or_none():
            raise BadRequest(f"Файл с названием {name} уже существует в этой папке")
        parent_file = File.query.filter_by(id=parent_id, file_type_id=FILE_TYPE_ID["Folder"]).one()
        new_path = os.path.join(parent_file.path, name)
        file_storage.save(new_path)
        file = File(parent_id=parent_id, name=name, path=new_path, file_type_id=file_type_id,
                    project_id=parent_file.project_id)
    else:
        name = file.name
        file_type_id = file.file_type_id
        new_path = file.path
        file_storage = FileStorage(open(new_path, 'rb'))
    size = get_file_size(new_path)

    # Нужно ли создавать VerFile
    if not need_analytic:
        # Не нужно
        db.session.add(file)
        db.session.commit()
        return file.as_dict()

    # Создание VerFile
    prev_ver_file = None
    # Создание первой версии
    if not prev_ver_id:
        if not ignore_same_files and File.query.join(VerFile).filter(
                File.parent_id == parent_id, File.name == name, VerFile.next_ver_id == None  # noqa: E711
        ).one_or_none():
            raise Exception(f"Файл с названием {name} уже существует в этой папке")
        ver_file = VerFile(file=file, branch_id=next_branch_id(), ver_num=1, size=size)
    # Создание следующей версии
    else:
        prev_ver_file = VerFile.query.filter_by(file_id=prev_ver_id).one()
        file.name = prev_ver_file.file.name
        ver_file = VerFile(file=file, prev_ver_id=prev_ver_id, next_ver_id=prev_ver_file.next_ver_id,
                           branch_id=prev_ver_file.branch_id, ver_num=next_ver_num(prev_ver_file.branch_id), size=size)
    db.session.add_all([file, ver_file])
    created_file = ver_file
    if name.lower().endswith('docx') and file_type_id == FILE_TYPE_ID["Document"] and not ver_file.next_ver_id:
        try:
            create_abbreviations(file_storage, file)
        except IndexError as e:
            print(f"Error in create_abbreviations: {e}")

        if prev_ver_id:
            try:
                delete_abbreviations_by_file_id(prev_ver_id)
            except IndexError as e:
                print(f"Error in delete_abbreviations_by_file_id: {e}")
        try:
            created_file = create_document(file, ver_file, file_storage, status_id, document_type_id, completion_percentage)
        except IndexError as e:
            print(f"Error in create_document: {e}")

    if prev_ver_file:
        prev_ver_file.next_ver_id = file.id
    db.session.commit()
    return created_file.as_dict()


def delete_ver_file(file_id):
    ver_file = VerFile.query.filter_by(file_id=file_id).one()
    prev_ver_file = VerFile.query.filter_by(file_id=ver_file.prev_ver_id).one_or_none()
    next_ver_file = VerFile.query.filter_by(file_id=ver_file.next_ver_id).one_or_none()
    if next_ver_file:
        next_ver_file.prev_ver_id = prev_ver_file.file_id if prev_ver_file else None
    if prev_ver_file:
        prev_ver_file.next_ver_id = next_ver_file.file_id if next_ver_file else None
    if ver_file.document:
        delete_document(ver_file.file.id)
        if prev_ver_file and not next_ver_file:
            create_abbreviations(prev_ver_file.file.path, prev_ver_file.file)
    db.session.delete(ver_file.file)
    db.session.commit()
    os.remove(ver_file.file.path)
    return ver_file.as_dict()


def get_versioned_files_by_head_id(head_id):
    if not VerFile.query.filter_by(file_id=head_id, next_ver_id=None).one_or_none():
        raise Exception(f"{head_id} isn't head")

    result = []
    next_id = head_id
    while next_id:
        ver_file = VerFile.query.filter_by(file_id=next_id).one()
        result.append(ver_file.as_dict())
        next_id = ver_file.prev_ver_id if ver_file.prev_ver_id else None

    return result


def rename_branch(branch_id, new_filename):
    ver_files = VerFile.query.filter_by(branch_id=branch_id).all()
    if not ver_files:
        raise Exception(f"No files in the branch={branch_id}")
    if ver_files[0].file.name == new_filename:
        raise Exception("Name must be different")

    parent_folder = File.query.filter_by(id=ver_files[0].file.parent_id).one()
    for ver_file in ver_files:
        old_path = ver_file.file.path
        new_path = os.path.join(parent_folder.path, f'{uuid1().hex}.{new_filename}')
        ver_file.file.name = new_filename
        ver_file.file.path = new_path
        db.session.commit()
        os.rename(old_path, new_path)

    return VerFile.query.filter_by(branch_id=branch_id, next_ver_id=None).one().as_dict()


def get_versioned_files_by_branch_id(branch_id):
    ver_files = VerFile.query.filter_by(branch_id=branch_id).all()
    if not ver_files:
        raise NotFound(f"No files in {branch_id=}")
    return [ver_file.as_dict() for ver_file in ver_files]


def get_head_id(branch_id: int) -> int:
    stmt = select(VerFile).where(VerFile.branch_id == branch_id).where(VerFile.next_ver_id.is_(None))
    ver_file: VerFile = db.session.scalars(stmt).one()
    return ver_file.file_id


def get_branch_id(file_id):
    ver_file = VerFile.query.filter_by(file_id=file_id, next_ver_id=None).one_or_none()
    if not ver_file:
        raise NotFound(f"{file_id=} was not found in ver_files")
    return ver_file.branch_id


def compare_files(first_id, second_id):
    doc1 = Document.query.filter_by(file_id=first_id).one()
    doc2 = Document.query.filter_by(file_id=second_id).one()
    s = SequenceMatcher(None, doc1.text, doc2.text)
    result = []
    for tag, i1, i2, j1, j2 in s.get_opcodes():
        if tag != 'equal':
            first_chunk = create_re_chunk(doc1.text[get_left_shift_ind(i1, CONTEXT_LENGTH):i1], doc1.text[i1:i2],
                                          doc1.text[i2:i2 + CONTEXT_LENGTH])
            second_chunk = create_re_chunk(doc2.text[get_left_shift_ind(j1, CONTEXT_LENGTH):j1], doc2.text[j1:j2],
                                           doc2.text[j2:j2 + CONTEXT_LENGTH])
            result.append({"tag": tag, "firstSequence": first_chunk, "secondSequence": second_chunk})
    return result

