from ..template import Template
from config import TEMPLATE_PATH, TEMPLATE_TYPE_ID
import os
from pathlib import Path
from ..database import db


def create_folder(parent_id, name):
    parent_folder = Template.query.filter_by(id=parent_id).first()
    if parent_id != 0:
        parent_folder_path = parent_folder.path
    else:
        parent_folder_path = TEMPLATE_PATH
    new_path = os.path.join(parent_folder_path, name)
    Path(new_path).mkdir()

    new_folder = Template(parent_id=parent_id, name=name, path=new_path, file_type_id=TEMPLATE_TYPE_ID["Folder"])
    db.session.add(new_folder)
    db.session.commit()
    if parent_id != 0:
        new_folder.project_id = parent_folder.project_id
        db.session.commit()

    return new_folder.as_dict()