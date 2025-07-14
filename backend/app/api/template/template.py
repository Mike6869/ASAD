from flask import Blueprint, request, jsonify, send_file
from auth import oidc
from ..utils import get_file_from_request
from ..utils import user as user_auth
from werkzeug.exceptions import BadRequest, InternalServerError
from models.template import Template, add_template, create_template_folder, delete_templates, get_path, get_project_template_list, get_template_type_id, \
rename as rename_template
from models.project_template import create_template
from models.user_role import  get_allowed_project_list
from config import TEMPLATE_TYPE_ID


template_app = Blueprint("template_app", __name__)

@template_app.post("/project_template")
@oidc.accept_token()
def create_new_template():
    user_auth.check_admin_role()

    name = request.json["name"]
    template = create_template(name)
    # add_roles_to_project_creator(user_id, project['project_id'])
    return jsonify(template)


@template_app.post("/folder/<int:parent_id>")
@oidc.accept_token()
def create_template_fold(parent_id):
    if parent_id <= 0:
        raise BadRequest(f"Id is incorrect ({parent_id=})")
    user_auth.check_write_role(parent_id)

    data = request.get_json()
    if not data or "name" not in data:
        raise BadRequest("name is required")
    
    file_type_id = data.get('typeId', None)
    if file_type_id is not None:
        file_type_id = int(file_type_id)

    if file_type_id == TEMPLATE_TYPE_ID["Folder"]:
        name = data["name"]
        created_folder = create_template_folder(parent_id, name)

    return jsonify(created_folder)


@template_app.get("/<int:entity_id>")
@oidc.accept_token()
def get_templates(entity_id, as_dict=True):
    user_auth.check_read_role(entity_id)

    type_id = get_template_type_id(entity_id)
    
    if type_id == TEMPLATE_TYPE_ID["Folder"]:
        templates = Template.query.filter(Template.parent_id == entity_id).all()
        if as_dict:
            return [child.as_dict() for child in templates]
        return jsonify(templates)
    elif type_id == TEMPLATE_TYPE_ID["Document"]:
        templates = Template.query.get_or_404(entity_id)
        return jsonify(templates.as_dict())
    else:
        raise BadRequest(f"Unsupported file type for ID { entity_id }")
    
    
@template_app.get("/project_template")
@oidc.accept_token()
def get_projects_templates():
    user_id = user_auth.get_user_id()
    projects_template_ids = get_allowed_project_list(user_id)
    projects_template = get_project_template_list(projects_template_ids)
    return jsonify(projects_template)


@template_app.delete("/<int:file_id>")
@oidc.accept_token()
def delete_entity(file_id):
    user_auth.check_delete_role(file_id)
    deleted_entity = delete_templates(file_id)
    return jsonify(deleted_entity)


@template_app.patch("/<int:file_id>")
@oidc.accept_token()
def edit_file(file_id):
    user_auth.check_write_role(file_id)

    new_name = request.json["name"]
    updated_file = None
    if new_name:
        updated_file = rename_template(file_id, new_name)
        return updated_file
    if not updated_file:
        raise InternalServerError("The file wasn't updated")
    return jsonify(updated_file)


@template_app.post("/<int:parent_id>")
@oidc.accept_token()
def create_file(parent_id):
    if parent_id <= 0:
        raise BadRequest(f"Id is incorrect ({parent_id=})")
    user_auth.check_write_role(parent_id)

    name = request.form["name"]
    if not name:
        raise BadRequest("name is required")
    
    file_type_id = request.form.get('typeId', type=int)

    if file_type_id in [TEMPLATE_TYPE_ID["Document"]]:
        file = get_file_from_request(request, "file")
        created_file = add_template(
            parent_id=parent_id,
            file_type_id=file_type_id,
            name=name,
            file_storage=file,
        )
    else:
        raise BadRequest(f"typeId is required ({file_type_id=})")

    return jsonify(created_file)


@template_app.get("/<int:entity_id>/download")
@oidc.accept_token()
def download_file(entity_id):
    user_auth.check_read_role(entity_id)

    type_id = get_template_type_id(entity_id)
    if type_id == TEMPLATE_TYPE_ID["Folder"]:
        raise BadRequest(f"{entity_id} must be a Document or VerFile ")
    path, name = get_path(entity_id)
    return send_file(path, as_attachment=True, download_name=name)
