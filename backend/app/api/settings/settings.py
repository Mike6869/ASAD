from flask import Blueprint, request, jsonify
from auth import oidc
from ..utils import user as user_auth
from models import document_type as dt, keywords as kw

settings_app = Blueprint('settings_app', __name__)


@settings_app.get('/document-types')
@oidc.accept_token()
def get_all_document_types():
    user_auth.check_admin_role()
    return jsonify(dt.get_all_types())


@settings_app.post('/document-types')
@oidc.accept_token()
def create_document_type():
    user_auth.check_admin_role()
    code = request.json['code']
    document_type = request.json['document_type']
    return jsonify(dt.create_document_type(code, document_type))


@settings_app.delete('/document-types/<id>')
@oidc.accept_token()
def delete_document_type(id: int):
    user_auth.check_admin_role()
    dt.delete_document_type(id)
    return 'Ok'


@settings_app.put('/document-types/<id>')
@oidc.accept_token()
def update_document_type(id: int):
    user_auth.check_admin_role()
    code = request.json['code']
    type_name = request.json['document_type']
    return jsonify(dt.update_document_type(id, code, type_name))


@settings_app.post('/keywords/')
@oidc.accept_token()
def add_keyword():
    user_auth.check_admin_role()
    document_type_id = request.json['document_type_id']
    tag = request.json['tag']
    content = request.json['content']
    return jsonify(kw.create_keyword(document_type_id, tag, content))


@settings_app.delete('/keywords/<id>')
@oidc.accept_token()
def delete_keyword(id: int):
    user_auth.check_admin_role()
    kw.delete_keyword(id)
    return 'ok'


@settings_app.put('/keywords/<id>')
@oidc.accept_token()
def update_keyword(id: int):
    user_auth.check_admin_role()
    document_type_id = request.json['document_type_id']
    tag = request.json['tag']
    content = request.json['content']
    return jsonify(kw.update_keyword(id, document_type_id, tag, content))


@settings_app.get('/keywords/')
@oidc.accept_token()
def get_all_keywords():
    user_auth.check_admin_role()
    return jsonify(kw.get_all_keywords())
