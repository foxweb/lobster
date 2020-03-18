# Lobster

Lobster — это бэкэнд-сервис для проекта ЛКЗ ТКБ. Работает по принципу REST API; принимает JSON, отдаёт JSON. Данные хранит в PostgreSQL.

## Установка (macOS)

``` sh
$ brew install postgres
$ brew services start postgres
$ createdb lobster
$ createdb lobster_test
$ git clone git@github.com:foxweb/lobster.git
$ cd lobster
$ bundle lobster
```

В `development`-окружении автоматически создаётся пользователь с почтой `admin@example.com` и паролем `secret`.

## Использование

### Запуск тестов и rubocop:

``` sh
$ bundle exec guard
```

### Запуск консоли:

``` sh
$ bundle exec hanami console
```

### Запуск development-сервера:

``` sh
$ bundle exec hanami server
```

### Проверка связи:

Требуется установка `httpie`.

```
$ http :2300/healthcheck
```

## Конфигурация

| Переменная              | Назначение                        |
| ----------------------- | --------------------------------- |
| `DATABASE_URL`          | Полный урл подключения к postgres |
| `HMAC_SECRET`           | Ключ для генерации JWT            |
| `JWT_TTL`               | Срок жизни JWT                    |
| `CORS_ALLOWED_ORIGIN`   | Разрешённые в CORS хосты          |
