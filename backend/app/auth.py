from flask import Flask
from flask_oidc import OpenIDConnect
from keycloak import KeycloakAdmin
from keycloak import KeycloakOpenIDConnection
from typing import Optional

from models.user_role import has_role, add_admin_role
from config import ROLE_NAMES

oidc: Optional[OpenIDConnect] = None
keycloak_admin: Optional[KeycloakAdmin] = None


def _init_oidc(app: Flask) -> OpenIDConnect:
    global oidc
    if oidc:
        raise Exception("The OpenIDConnect has already been initialized")

    oidc = OpenIDConnect(app)
    return oidc


def _init_keycloak(oidc: OpenIDConnect) -> KeycloakAdmin:
    global keycloak_admin
    if keycloak_admin:
        raise Exception("The KeycloakAdmin instance has already been initialized")

    server_url, realm_name = oidc.client_secrets['issuer'].split(r'realms/')
    keycloak_connection = KeycloakOpenIDConnection(
        server_url=server_url,
        realm_name=realm_name,
        user_realm_name=realm_name,
        client_id=oidc.client_secrets['client_id'],
        client_secret_key=oidc.client_secrets['client_secret'],
        verify=True)
    keycloak_admin = KeycloakAdmin(connection=keycloak_connection)

    return keycloak_admin


def _init_root_user(keycloak_admin: KeycloakAdmin) -> str:
    user_id_keycloak = keycloak_admin.get_user_id("root")
    if not user_id_keycloak:
        user_id_keycloak = keycloak_admin.create_user({"username": "root",
                                                       "enabled": True,
                                                       "credentials": [{"value": "root", "type": "password", }]},
                                                      exist_ok=False)
    if not has_role(user_id_keycloak, ROLE_NAMES['ADMIN']):
        add_admin_role(user_id_keycloak)
    return user_id_keycloak


def init_auth(app: Flask) -> None:
    oidc = _init_oidc(app)
    keycloak_admin = _init_keycloak(oidc)
    with app.app_context():
        _init_root_user(keycloak_admin)
