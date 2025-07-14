from typing import TypedDict
from authlib.integrations.flask_oauth2 import current_token
from werkzeug.exceptions import Forbidden

from models import user_role as ur


def get_user_id() -> str:
    return current_token['sub']


def get_username() -> str:
    return current_token['username']


def check_read_role(file_id: int) -> None:
    user_id = get_user_id()
    if not ur.has_role_to_read_file(user_id, file_id):
        raise Forbidden(f'No rights to read ({file_id=})')


def check_write_role(file_id: int) -> None:
    user_id = get_user_id()
    if not ur.has_role_to_write_file(user_id, file_id):
        raise Forbidden(f'No rights to write ({file_id=})')


def check_delete_role(file_id: int) -> None:
    user_id = get_user_id()
    if not ur.has_role_to_delete_file(user_id, file_id):
        raise Forbidden(f'No rights to delete ({file_id=})')


def check_admin_role() -> None:
    user_id = get_user_id()
    if not ur.has_admin_role(user_id):
        raise Forbidden("The user doesn't have the admin role")


class _KeycloakUser(TypedDict):
    createdTimestamp: int
    enabled: bool
    id: str
    username: str
    firstName: str
    lastName: str
    email: str


class UserInfo:
    def __init__(self, user: _KeycloakUser):
        self.id = user['id']
        self.username = user['username']
        self.enabled = user['enabled']
        self.created_timestamp = user.get('createdTimestamp', '')
        self.first_name = user.get('firstName', '')
        self.last_name = user.get('lastName', '')
        self.email = user.get('email', '')

    def as_dict(self):
        return vars(self)
