from flask import abort, Request


def get_file_from_request(request: Request, file_name: str):
    if file_name not in request.files:
        abort(400, "File is required")
    return request.files[file_name]
