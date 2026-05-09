---
type: dev-plan
feature: singularity_api_integration
created: 2026-05-09
status: draft
tags:
  - bot
  - dev
  - tasks
  - singularity
---

# Dev Plan: интеграция с Singularity REST API — добавление задач через бота

## Задача

По команде вида `добавь задачу <текст>` бот добавляет задачу в Singularity через REST API.

---

## Контекст

Сейчас бот пишет задачи только в Daily-заметки. Singularity — таск-менеджер Артёма, у которого есть REST API. Интеграция позволит добавлять задачи туда напрямую не выходя из Telegram.

---

## Что нужно выяснить до начала

- [ ] URL и документация Singularity REST API — какой endpoint для создания задачи?
- [ ] Аутентификация — токен? OAuth? Где хранить ключ?
- [ ] Структура задачи: обязательные поля (название, проект, дата, приоритет)?
- [ ] Нужно ли указывать проект/список при добавлении или есть inbox по умолчанию?

---

## Шаг 1 — новый skill `add_task.py`

Создать `skills/add_task.py` по паттерну существующих skills:

```python
# skills/add_task.py
# Добавляет задачу в Singularity через REST API
# Аргументы: --text "текст задачи" [--project "название"] [--due "YYYY-MM-DD"]
```

Использует `skills/_common.py` для `skill_output()` и `log_skill()`.  
Не делает git commit — задачник внешний, vault не затрагивается.

Структура вызова:
```sh
.venv/bin/python skills/add_task.py --text "текст задачи"
```

---

## Шаг 2 — маршрутизация в AGENT.md

Добавить строку в таблицу маршрутизации:

```
| `добавь задачу: ...`, `задача: ...` | `.venv/bin/python skills/add_task.py --text ...` |
```

---

## Шаг 3 — хранение токена

Токен Singularity API добавить в `.env`:
```
SINGULARITY_API_TOKEN=...
SINGULARITY_API_URL=https://...
```

Добавить в `cc-connect/config.toml.example` комментарий, что нужна переменная.

---

## Шаг 4 — тесты

`tests/test_add_task.py` — мокать HTTP-запрос, проверять:
- корректное формирование тела запроса
- обработку ошибки API (401, 500)
- вывод `skill_output()` в правильном формате

---

## Затронутые файлы

```diff
+ skills/add_task.py              # новый skill
  AGENT.md                        # добавить строку маршрутизации
  .env                            # SINGULARITY_API_TOKEN, SINGULARITY_API_URL
  cc-connect/config.toml.example  # упомянуть переменные
  .claude/settings.json           # добавить в allowlist: Bash(... skills/add_task.py *)
+ tests/test_add_task.py          # тесты
```

---

## Риски

- API Singularity может не иметь публичной документации — нужно получить токен и описание эндпоинтов вручную.
- Если проект/список обязателен — придётся либо хардкодить дефолтный inbox, либо парсить из команды.
- Команда `добавь задачу` может конфликтовать с текущим паттерном мыслей — нужна чёткая фраза-триггер.

---

## TODO

- [ ] Получить документацию Singularity REST API и токен
- [ ] Создать `skills/add_task.py`
- [ ] Обновить `AGENT.md`
- [ ] Добавить переменные в `.env` и `.env.example`
- [ ] Написать тесты
- [ ] Проверить на живом окружении
