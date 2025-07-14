from typing import List, TYPE_CHECKING
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import db
from config import ROLE_NAMES

if TYPE_CHECKING:
    from .user_role import UserRole


class Role(db.Model):
    __tablename__ = 'role_names'

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(30), unique=True)

    user_roles: Mapped[List['UserRole']] = relationship(back_populates='role', cascade="all, delete-orphan")

    def __repr__(self) -> str:
        return f"Role(id={self.id!r}, name={self.name!r})"


def init_roles():
    for role_name, role_id in ROLE_NAMES.items():
        db.session.add(Role(id=role_id, name=role_name))
    db.session.commit()


def is_empty() -> bool:
    return not bool(Role.query.first())
