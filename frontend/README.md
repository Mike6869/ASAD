# Запуск в режиме разработки

`npm i`

`npm run dev`

Приложение запустится в режиме разработки на [http://localhost:8081](http://localhost:8081/)

Порт лучше не менять, т.к. в keycloak для фронта настроен именно этот порт. Если запускаете на другом порту - не забудьте поправить клиент в keycloak.

Рутовый логин в систему по умолчанию _root:root_
Логин в keycloak _admin:admin_

### Настройка окружения .env.development

Содержимое .env.development:

```
VITE_API_URL=http://localhost:5001/
VITE_KC_BASE_PATH=http://localhost:8080/
VITE_KC_REALM=doc-analysis
VITE_KC_CLIENT_ID=react-client
```

_VITE_API_URL_ - адрес бэка

_VITE_KC_BASE_PATH_ - адрес keycloak

_VITE_KC_REALM_ - реалм в keycloak

_VITE_KC_CLIENT_ID_ - id клиента в keycloak

# Деплой

Сборка осуществляется командой:

`npm run build`
