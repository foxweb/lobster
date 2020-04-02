# Документация по Lobster API

Сборка образа:

``` sh
$ docker build -t balance-pl/lobster-docs .
```

Запуск образа:

``` sh
docker run -p 8000:80 balance-pl/lobster-docs
```

Но удобней и быстрее всего:

``` sh
docker build -t balance-pl/lobster-docs . && docker run -p 8000:80 balance-pl/lobster-docs
```
