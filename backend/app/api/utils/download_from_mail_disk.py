"""
доп функции для api сompare-files в (file/file.py)
, которые скачивают файлы с облака mail.ru
"""
import requests
import re
from io import BytesIO



def download_file_from_url(link):
    """
    Извлекает прямую ссылку на файл из публичной ссылки на облако Mail.ru.

    :param link: Публичная ссылка на облако Mail.ru.
    :return: Прямая ссылка на файл или None, если ссылку извлечь не удалось.
    """
    response = requests.get(link)
    page_content = response.text

    # Регулярное выражение для извлечения URL из JSON-ответа
    re_pattern = r'dispatcher.*?weblink_get.*?url":"(.*?)"'
    match = re.search(re_pattern, page_content)

    if match:
        url = match.group(1)
        # Извлекаем части ссылки (например, 'PEVz' и 'NzJG5cN1u')
        parts = link.split('/')[-2:]
        # Формируем прямую ссылку
        url = f'{url}/{parts[0]}/{parts[1]}'
        # загружаем в битовом формате
        response = requests.get(url)
        if response.status_code != 200:
            raise Exception(f"Ошибка загрузки файла (код {response.status_code})")
        return BytesIO(response.content)
    return None