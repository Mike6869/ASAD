import sys
import os

sys.path.append(os.path.dirname(os.path.realpath(__file__)))

import click
from flask import Flask
from flask_cors import CORS
from flask_migrate import Migrate
import shutil

from models import db
from models.document_status import init_document_statuses, is_empty as is_doc_statuses_empty
from models.document_type import init_document_types, is_empty as is_doc_types_empty
from models.role import init_roles, is_empty as is_roles_empty
from config import DATA_PATH, DEFAULT_DIRS
from api import init_api
from auth import init_auth
from exceptions import init_errorhandler

app = Flask(__name__)
CORS(app)

CONFIG_NAME = os.getenv("CONFIG_NAME", "DevelopmentConfig")
app.config.from_object("config." + CONFIG_NAME)

db.init_app(app)

with app.app_context():
    db.create_all()
    if is_doc_statuses_empty():
        init_document_statuses()
    if is_doc_types_empty():
        init_document_types()
    if is_roles_empty():
        init_roles()

migrate = Migrate(app, db)
migrate.init_app(app, db)

init_auth(app)

init_api(app)

init_errorhandler(app)

if not os.path.exists(DATA_PATH):
    for folder in DEFAULT_DIRS:
        os.makedirs(folder)


@app.cli.command("db-drop-all")
def db_drop_all():
    db.drop_all()
    shutil.rmtree(DATA_PATH)


@app.cli.command("db-init-tables")
def db_init_tables():
    init_document_statuses()
    init_document_types()
    init_roles()


@app.cli.command("db-recreate-all")
@click.pass_context
def db_recreate_all(ctx):
    shutil.rmtree(DATA_PATH)
    db.drop_all()
    db.create_all()
    ctx.invoke(db_init_tables)
