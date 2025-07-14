from typing import Optional, TYPE_CHECKING, Sequence, TypedDict, List
from sqlalchemy import String, ForeignKey, select, and_, delete
from sqlalchemy.orm import Mapped, mapped_column, relationship

from .database import db
from .file import get_project_id, get_project_list
from .project import Project
from config import ROLE_NAMES

if TYPE_CHECKING:
    from .role import Role


def get_role_ids_by_names(names: Sequence[str]) -> List[int]:
    return [id for role_name, id in ROLE_NAMES.items() if role_name in names]


class _RoleInfo(TypedDict):
    role_id: int
    project_id: Optional[int]
    label: str


class _UserRoleInfo(TypedDict):
    current_roles: List[_RoleInfo]
    available_roles: List[_RoleInfo]


def create_role_label(role_name: str, project_name: Optional[str]) -> str:
    if project_name:
        return f'{project_name}({role_name})'
    return role_name


# GENERAL ROLES
ROLE_IDS_ON_PROJECT = get_role_ids_by_names(['READ', 'WRITE', 'DELETE'])
ROLE_IDS_ON_CREATION_PROJECT = get_role_ids_by_names(['ADMIN', 'CREATE_PROJECTS'])
ROLE_IDS_ON_DELETE = get_role_ids_by_names(['ADMIN', 'DELETE_ALL'])
ROLE_IDS_ON_CREATE_FILE = get_role_ids_by_names(['ADMIN', 'WRITE_ALL'])
ROLE_IDS_ON_READ_FILE = get_role_ids_by_names(['ADMIN', 'READ_ALL'])
GENERAL_ROLES_INFO: List[_RoleInfo] = [
    {'role_id': 1, 'project_id': None, 'label': 'ADMIN'},
    {'role_id': 2, 'project_id': None, 'label': 'READ_ALL'},
    {'role_id': 3, 'project_id': None, 'label': 'WRITE_ALL'},
    {'role_id': 4, 'project_id': None, 'label': 'DELETE_ALL'},
    {'role_id': 5, 'project_id': None, 'label': 'CREATE_PROJECTS'},
]


class UserRole(db.Model):
    __tablename__ = 'user_roles'

    id: Mapped[int] = mapped_column(primary_key=True)
    project_id: Mapped[Optional[int]] = mapped_column(ForeignKey('projects.id'))
    user_id: Mapped[str] = mapped_column(String(36), index=True)
    role_id: Mapped[int] = mapped_column(ForeignKey('role_names.id'))

    project: Mapped[Optional['Project']] = relationship(back_populates='user_roles')
    role: Mapped['Role'] = relationship(back_populates='user_roles')

    def __repr__(self) -> str:
        return (f"UserRole(id={self.id!r}, project_id={self.project_id!r}, user_id={self.user_id!r}, "
                f"role_id={self.role_id!r})")


def add_admin_role(user_id: str) -> UserRole:
    new_role = UserRole(user_id=user_id, role_id=ROLE_NAMES['ADMIN'])
    db.session.add(new_role)
    db.session.commit()
    return new_role


def has_role(user_id: str, role_id: int, project_id: int = None) -> bool:
    stmt = select(UserRole).where(
        and_(UserRole.user_id == user_id, UserRole.role_id == role_id, UserRole.project_id == project_id))
    res = db.session.execute(stmt).scalar()
    return bool(res)


def add_roles_to_project_creator(user_id: str, project_id: int) -> None:
    for role_id in ROLE_IDS_ON_PROJECT:
        new_role = UserRole(project_id=project_id, user_id=user_id, role_id=role_id)
        db.session.add(new_role)
    db.session.commit()


def has_role_to_create_project(user_id: str) -> bool:
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id.in_(ROLE_IDS_ON_CREATION_PROJECT)))
    result = db.session.execute(stmt).first()
    return bool(result)


def has_role_to_delete_file(user_id: str, entity_id: int) -> bool:
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id.in_(ROLE_IDS_ON_DELETE)))
    result = db.session.execute(stmt).first()
    if result:
        return True

    project_id = get_project_id(entity_id)
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id == ROLE_NAMES['DELETE'],
                                       UserRole.project_id == project_id))
    result = db.session.execute(stmt).first()
    return bool(result)


def has_role_to_write_file(user_id: str, entity_id: int) -> bool:
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id.in_(ROLE_IDS_ON_CREATE_FILE)))
    result = db.session.execute(stmt).first()
    if result:
        return True

    project_id = get_project_id(entity_id)
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id == ROLE_NAMES['WRITE'],
                                       UserRole.project_id == project_id))
    result = db.session.execute(stmt).first()
    return bool(result)


def has_role_to_read_file(user_id: str, file_id: int) -> bool:
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id.in_(ROLE_IDS_ON_READ_FILE)))
    result = db.session.execute(stmt).first()
    if result:
        return True

    project_id = get_project_id(file_id)
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id == ROLE_NAMES['READ'],
                                       UserRole.project_id == project_id))
    result = db.session.execute(stmt).first()
    return bool(result)


def get_allowed_project_list(user_id: str) -> Optional[List[int]]:
    """Has access to all projects if returns None"""
    stmt = select(UserRole).where(and_(UserRole.user_id == user_id, UserRole.role_id.in_(ROLE_IDS_ON_READ_FILE)))
    result = db.session.execute(stmt).first()
    if result:
        return

    stmt = select(UserRole.project_id).where(UserRole.user_id == user_id).where(UserRole.role_id == ROLE_NAMES['READ'])
    return db.session.execute(stmt).scalars().all()


def has_admin_role(user_id: str) -> bool:
    stmt = select(UserRole).where(UserRole.user_id == user_id).where(UserRole.role_id == ROLE_NAMES['ADMIN'])
    res = db.session.scalars(stmt).first()
    return bool(res)


def get_user_roles(user_id: str) -> List[_RoleInfo]:
    stmt = select(UserRole).where(UserRole.user_id == user_id)
    return [
        {
            'role_id': user_role.role_id, 'project_id': user_role.project_id,
            'label': user_role.role.name if not user_role.project_id else (f'{user_role.project.file.name}'
                                                                           f'({user_role.role.name})')
        }
        for user_role in db.session.scalars(stmt).all()
    ]


def get_all_roles() -> List[_RoleInfo]:
    roles = GENERAL_ROLES_INFO.copy()
    projects = get_project_list()
    for project in projects:
        roles.append({'role_id': ROLE_NAMES['READ'], 'project_id': project['project_id'],
                      'label': create_role_label('READ', project['name'])})
        roles.append({'role_id': ROLE_NAMES['WRITE'], 'project_id': project['project_id'],
                      'label': create_role_label('WRITE', project['name'])})
        roles.append({'role_id': ROLE_NAMES['DELETE'], 'project_id': project['project_id'],
                      'label': create_role_label('DELETE', project['name'])})
    return roles


def get_user_role_info(user_id: str) -> _UserRoleInfo:
    user_roles = get_user_roles(user_id)
    all_roles = get_all_roles()
    available_roles = list(filter(lambda role: role not in user_roles, all_roles))
    return {'current_roles': user_roles, 'available_roles': available_roles}


def set_roles(user_id: str, roles: List[_RoleInfo]) -> None:
    stmt = delete(UserRole).where(UserRole.user_id == user_id)
    db.session.execute(stmt)
    for role in roles:
        new_role = UserRole(user_id=user_id, role_id=role['role_id'], project_id=role['project_id'])
        db.session.add(new_role)
    db.session.commit()
