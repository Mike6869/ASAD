from flask import Flask
from config import URL_PREFIX


def init_api(app: Flask) -> None:
    from .template import template_app
    from .file import files_app
    from .admin import admin_app
    from .userinfo import userinfo_app
    from .settings import settings_app

    app.register_blueprint(template_app, url_prefix=f"{URL_PREFIX}template")
    app.register_blueprint(files_app, url_prefix=f"{URL_PREFIX}file")
    app.register_blueprint(admin_app, url_prefix=f"{URL_PREFIX}admin")
    app.register_blueprint(userinfo_app, url_prefix=f"{URL_PREFIX}userinfo")
    app.register_blueprint(settings_app, url_prefix=f"{URL_PREFIX}settings")
