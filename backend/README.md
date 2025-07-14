# Backend

Бэкенд приложения АСАД

## Installation for development

1. Клонируем реп

```
git clone git@gitlab.urpias.ru:asad-intellect/backend.git
```

2. Устанавливаем зависимости *(Python 3.8)*

```
pip install -r requirements.txt
python -m nltk.downloader stopwords punkt
```

3. Копируем преднастроенную базу keycloak.sql [отсюда](https://gitlab.urpias.ru/asad-intellect/old-deployment) и переносим в deploy/postgresql_keycloak

4. Запускаем контейнеры с базами и сервером авторизации

```
docker compose -f docker-compose-dev.yml up -d
```

5. Запускаем бэкенд сервер локально

```
flask --debug run -p 5001
```

6. Учетка для keycloak по умолчанию _admin:admin_. Рутовая учетка для веб приложения АСАД _root:root_