import os
from os import getenv
from os.path import join

config_directory = os.path.dirname(os.path.abspath(__file__))

DATA_PATH = getenv("DATA_PATH", join(config_directory, "file_storage"))
WORDCLOUDS_PATH = join(DATA_PATH, "assets", "images", "word-clouds")
PROJECT_PATH = join(DATA_PATH, "projects")
TEMPLATE_PATH = join(config_directory, "template")
DEFAULT_DIRS = [PROJECT_PATH, WORDCLOUDS_PATH]
URL_PREFIX = getenv('URL_PREFIX', '/api/')

ABBREVIATION_TABLE_TEMPLATE = {
    "term": ["ТЕРМИН", "СОКРАЩЕНИЕ", "ТЕРМИНЫ, \nИСПОЛЬЗУЕМЫЕ В ДОКУМЕНТЕ", "СОКРАЩЕНИЕ ИЛИ ОПРЕДЕЛЕНИЕ",
             "СОКРАЩЕНИЕ/ ОБОЗНАЧЕНИЕ"],
    "description": ["ОПРЕДЕЛЕНИЕ", "ПОЛНОЕ НАИМЕНОВАНИЕ", "ПОЯСНЕНИЕ", "ОПРЕДЕЛЕНИЯ", "ОПИСАНИЕ", "РАСШИФРОВКА"]
}

GLOSSARY_PARAGRAPH_TITLES = ['Термины и определения', 'Сокращения']

TEMPLATE_FOLDER = join(config_directory, 'template')

SECRET_KEY = getenv(
    "SECRET_KEY",
    "eb5c3e7185d892e973339543aecbec43354a1464898be206db9e123ada2bef86",
)

SQLALCHEMY_DATABASE_URI = getenv(
    "SQLALCHEMY_DATABASE_URI",
    "postgresql://flask:secretpassword@localhost:5434/flaskdb",
)

FILE_TYPE_ID = {
    "Folder": 1,
    "VerFile": 2,
    "Document": 3
}

TEMPLATE_TYPE_ID = {
    "Folder": 1,
    "Document": 3
}

DOC_MEDIA_PATH = join('word', 'media')

MIN_SIMILARITY = 0.8

CONTEXT_LENGTH = 80

DOCUMENT_TYPES = [
    ("НЗ", "Не задан", ""),
    ("АКТ", "Акт", ""),
    ("БП", "Модель бизнес-процесса", ""),
    ("ИЗМ", "Запрос на изменение объема Проекта", ""),
    ("КНЦ", "Концепция", ""),
    ("ЛСР", "Локальный сметный расчёт", ""),
    ("МЕТ", "Методика", ""),
    ("МПР", "Методологическое проектное решение", ""),
    ("МРД", "Методико-регламентная документация", ""),
    ("ОИ", "Операционные инструкции", ""),
    ("ПЛН", "Календарный план", ""),
    ("ПМИ", "Программа и методика испытаний Системы", ""),
    ("ПОЛ", "Положение", ""),
    ("ТПР", "Техническое проектное решение", ""),
    ("ПР", "Проектные решения", ""),
    ("ПРГ", "Программа", ""),
    ("ПРЗ", "Презентации", ""),
    ("ПРО", "Протокол совещания Оперативного совета", ""),
    ("ПРТ", "Протокол", ""),
    ("ПРУ", "Протокол совещания Управляющего комитета", ""),
    ("ПСМ", "Письмо", ""),
    ("РЕГ", "Регламент", ""),
    ("РСЗ", "Реестр замечаний к документу", ""),
    ("РСК", "Карточка риска", ""),
    ("РСП", "Реестр проблем", ""),
    ("РСР", "Реестр рисков", ""),
    ("РСТ", "Реестр", ""),
    ("СПР", "Спецификации на разработки", ""),
    ("ССР", "Сводный сметный расчет", ""),
    ("СТП", "Отчёт о статусе Проекта", ""),
    ("ТЗ", "Техническое задание", "https://cloud.mail.ru/public/PEVz/NzJG7cN1u"),
    ("ТИ", "Технологическая инструкция", ""),
    ("ТРБ", "Требование", ""),
    ("УСТ", "Устав Проекта", "https://cloud.mail.ru/public/RCHt/MYcijvtyX"),
    ("ЧТЗ", "Частное Техническое задание", ""),
    ("ШОФ", "Шаблон отчётной формы", "")
]

DOCUMENT_COMPLETION_PERCENTAGES = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    100,
]

DOCUMENT_STATUSES = [
    "Не согласован",
    "Оперативный совет",
    "Управляющий совет",
    "Рабочая группа"
]

ROLE_NAMES = {
    'ADMIN': 1,  # полный доступ
    'READ_ALL': 2,  # доступ на чтение ко всем проектам
    'WRITE_ALL': 3,  # вносить изменение (добавлять версии документов) в проекты
    'DELETE_ALL': 4,  # удалять все проекты и их содержимое отдельно
    'CREATE_PROJECTS': 5,  # создавать проекты
    'READ': 6,  # чтение отдельного проекта
    'WRITE': 7,  # изменение отдельного проекта
    'DELETE': 8,  # удаление для отдельного проекта
}


class Config:
    TESTING = False
    DEBUG = False
    ENV = "development"
    SECRET_KEY = SECRET_KEY
    SQLALCHEMY_ECHO = False
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_DATABASE_URI = SQLALCHEMY_DATABASE_URI


class ProductionConfig(Config):
    ENV = "production"
    OIDC_CLIENT_SECRETS = join(config_directory, 'client_secrets_prod.json')


class DevelopmentConfig(Config):
    DEBUG = True
    OIDC_CLIENT_SECRETS = join(config_directory, 'client_secrets_dev.json')


class TestingConfig(Config):
    ENV = "testing"
    TESTING = True
