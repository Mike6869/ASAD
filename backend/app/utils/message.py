from flask import jsonify, Response


def create_message(message_body: str) -> Response:
    return jsonify(message=message_body)
