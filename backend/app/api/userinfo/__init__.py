from flask import Blueprint, jsonify

from models.user_role import get_user_roles
from api.utils.user import get_user_id, get_username
from auth import oidc

userinfo_app = Blueprint("userinfo_app", __name__)


@userinfo_app.get("/")
@oidc.accept_token()
def get_userinfo():
    user_id = get_user_id()
    return jsonify({'username': get_username(), 'roles': get_user_roles(user_id)})
