from flask import Blueprint, jsonify, request
from werkzeug.exceptions import BadRequest
from authlib.integrations.flask_oauth2 import current_token

from auth import oidc, keycloak_admin
from ..utils import user as user_auth
from models import user_role

admin_app = Blueprint('admin_app', __name__)


@admin_app.get("/test_oidc")
@oidc.accept_token()
def test_oidc():
    print(current_token)
    return jsonify(f'Welcome {current_token["username"]}')


@admin_app.get('/users')
@oidc.accept_token()
def get_users():
    user_auth.check_admin_role()
    users = [user_auth.UserInfo(user).as_dict() for user in keycloak_admin.get_users()]
    return jsonify(users=users)


@admin_app.post('/users')
@oidc.accept_token()
def create_user():
    user_auth.check_admin_role()
    username = request.json['username']
    password = request.json['password']
    first_name = request.json['firstName']
    last_name = request.json['lastName']
    email = request.json['email']
    new_user = keycloak_admin.create_user({"email": email,
                                           "username": username,
                                           "enabled": True,
                                           "firstName": first_name,
                                           "lastName": last_name,
                                           "credentials": [{"value": password, "type": "password"}]},
                                          exist_ok=False)
    return jsonify({'id': new_user})


@admin_app.get("/users/<user_id>/role_info")
@oidc.accept_token()
def get_user_roles(user_id: str):
    user_auth.check_admin_role()
    return jsonify({'user_id': user_id, **user_role.get_user_role_info(user_id)})


@admin_app.put("/users/<user_id>/role_info")
@oidc.accept_token()
def set_roles(user_id: str):
    user_auth.check_admin_role()
    data = request.json
    if 'roles' not in data:
        raise BadRequest('Json structure is incorrect')
    user_role.set_roles(user_id, data['roles'])
    return jsonify(message='Success'), 200


@admin_app.get('/test_token/<token>')
def test_token(token: str):
    from keycloak import KeycloakOpenID

    keycloak_openid = KeycloakOpenID(server_url="http://keycloak:8080",
                                     client_id="flask-client",
                                     realm_name="doc-analysis",
                                     client_secret_key="ZsmvdYqx52ghSYKoqVAbnFH3xZkN2IYz")
    token_info = keycloak_openid.introspect(token)
    return jsonify(token_info)
