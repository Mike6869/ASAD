from flask import Flask, jsonify, Response, json
from werkzeug.exceptions import HTTPException
from sqlalchemy.orm.exc import NoResultFound
from authlib.integrations.flask_oauth2.errors import _HTTPException
from keycloak.exceptions import KeycloakError
from typing import Tuple

_is_initialized = False


def create_error_response(e: Exception, status_code: int) -> Tuple[Response, int]:
    return jsonify({'error': e.__class__.__name__, 'error_description': str(e)}), status_code


def init_errorhandler(app: Flask) -> None:
    global _is_initialized
    if _is_initialized:
        return

    @app.errorhandler(HTTPException)
    def handle_exception(e: HTTPException):
        response = e.get_response()
        response.data = json.dumps({
            "error": e.name,
            "error_description": e.description,
        })
        response.content_type = "application/json"
        return response

    @app.errorhandler(_HTTPException)
    def handle_auth_exception(e: _HTTPException):
        response = e.get_response()
        response.data = e.get_body()
        response.content_type = "application/json"
        return response

    @app.errorhandler(NoResultFound)
    def handle_no_result_found_sql(e: NoResultFound):  # noqa: F811
        return create_error_response(e, 404)

    @app.errorhandler(KeycloakError)
    def handle_no_result_found_sql(e: KeycloakError):  # noqa: F811
        message = json.loads(e.error_message).get('error', 'Failed to read Keycloak error')
        return jsonify({'error': e.__class__.__name__, 'error_description': message}), e.response_code or 500

    @app.errorhandler(Exception)
    def handle_exception(e: Exception):  # noqa: F811
        return create_error_response(e, 500)

    _is_initialized = True
