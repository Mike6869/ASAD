from pathlib import Path

from .common.folder_service import create_folder
from .template import Template
from config import TEMPLATE_FOLDER
from sqlalchemy import ForeignKey
from sqlalchemy.orm import Mapped
from sqlalchemy.orm import mapped_column
from sqlalchemy.orm import relationship

from .database import db

# if TYPE_CHECKING:
#     from .user_role import UserRole

class ProjectTemplate(db.Model):
    __tablename__ = 'project_templates'

    id: Mapped[int] = mapped_column(primary_key=True)
    template_id: Mapped[int] = mapped_column(ForeignKey('templates.id'))

    template: Mapped['Template'] = relationship(back_populates='project_template')

    def as_dict(self):
        return dict(self.template.as_dict())

    def __repr__(self):
        return f'ProjectTemplate(id={self.id!r}, template_id={self.template_id!r})'


def create_template(name: str):
    # Создаем запись в базе данных
    folder = create_folder(0, name)
    new_project_template = ProjectTemplate(template_id=folder["id"])
    db.session.add(new_project_template)
    db.session.commit()
    
    # Устанавливаем project_id после первого коммита
    new_project_template.template.project_template_id = new_project_template.id
    db.session.commit()
    
    # Создаем физическую папку для шаблона
    template_path = Path(TEMPLATE_FOLDER) / name
    try:
        template_path.mkdir(parents=True, exist_ok=True)
                
    except Exception as e:
        # Если не удалось создать папку, откатываем изменения в БД
        db.session.delete(new_project_template)
        db.session.delete(folder)
        db.session.commit()
        raise Exception(f"Failed to create template directory: {str(e)}")
    
    return new_project_template.as_dict()


def update_template(file_id: int, name: str = None, documents_count: int = None):
    """
    Обновляет шаблон проекта
    
    :param file_id: ID файла-шаблона
    :param name: Новое имя шаблона (необязательно)
    :param documents_count: Новое количество документов (необязательно)
    :return: Обновленные данные шаблона
    """
    try:
        # Находим шаблон в базе данных
        project = ProjectTemplate.query.filter_by(file_id=file_id).one()
        
        # Обновляем данные, если они переданы
        if documents_count is not None:
            project.documents_count = documents_count
            
        if name is not None:
            # Обновляем имя в записи файла
            project.file.name = name
            
            # Переименовываем физическую папку, если она существует
            old_path = Path(TEMPLATE_FOLDER) / project.file.name
            new_path = Path(TEMPLATE_FOLDER) / name
            
            if old_path.exists():
                old_path.rename(new_path)
        
        db.session.commit()
        return project.as_dict()
        
    except Exception as e:
        db.session.rollback()
        raise Exception(f"Failed to update template: {str(e)}")
