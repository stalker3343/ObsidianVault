---
created: 2026-05-17
status: idea
tags:
  - dev-plan
  - singularity
  - mcp
---

# Фича: создание задачи во Входящие (без проекта)

## Задача

Добавить возможность создавать задачу в Singularity без привязки к проекту — она попадает во «Входящие». Пользователь явно говорит «добавь в инбокс» / «во входящие».

## Контекст

**Файл:** `mcp-servers/singularity-py/server.py`

Текущий `create_task` (строка 411) требует `project_id: str` как обязательный параметр — он всегда передаётся в тело запроса (`body["projectId"] = project_id`). Создать задачу без проекта через него невозможно.

API Singularity (`POST /v2/task`) судя по структуре тела принимает опциональный `projectId` — если его не передавать, задача должна попасть во Входящие. Это стандартное поведение GTD-приложений, но нужно проверить на реальном запросе.

Пользователь предпочёл **отдельный метод** вместо того, чтобы делать `project_id` необязательным в `create_task` — это чище: явный интент «в инбокс», меньше путаницы у LLM при маршрутизации.

## Шаги

1. **Проверить API вручную** — сделать `POST /v2/task` без поля `projectId`, убедиться что задача появляется во Входящих в приложении.

2. **Добавить инструмент `create_inbox_task`** в `server.py`:
   ```python
   @mcp.tool()
   async def create_inbox_task(title: str, start: str = "", deadline: str = "") -> str:
       """Создать задачу во Входящих (без проекта).
       Использовать когда пользователь говорит «добавь в инбокс», «во входящие», «без проекта».

       Args:
           title: Название задачи
           start: Дата выполнения YYYY-MM-DD (опционально)
           deadline: Крайний срок YYYY-MM-DD (опционально)
       """
       effective_start = start or _today_msk()
       start_utc, _ = _msk_day_utc(effective_start)
       body: dict = {"title": f"{title} [AI Created]", "start": start_utc}
       if deadline:
           deadline_utc, _ = _msk_day_utc(deadline)
           body["deadline"] = deadline_utc
       async with httpx.AsyncClient(base_url=BASE_URL, headers=_headers(), timeout=15) as c:
           r = await c.post("/v2/task", json=body)
           r.raise_for_status()
           result = r.json()
       task_id = result.get("id", "?")
       return f"Создана задача «{title}» во Входящих (id: {task_id})  start:{effective_start}"
   ```

3. **Добавить инструмент в allow-лист** в `.claude/settings.json`:
   ```json
   "mcp__singularity__create_inbox_task"
   ```

4. **Обновить `AGENT.md`** — добавить строку в таблицу маршрутизации:
   ```
   | «добавь в инбокс», «во входящие», «без проекта» | MCP `singularity.create_inbox_task()` |
   ```

## Затронутые файлы

| Файл | Изменение |
|---|---|
| `mcp-servers/singularity-py/server.py` | Новый инструмент `create_inbox_task` |
| `.claude/settings.json` | Добавить `mcp__singularity__create_inbox_task` в allow |
| `AGENT.md` | Маршрутизация для «в инбокс» / «без проекта» |

## Риски

- **API без `projectId`** — неизвестно точно, поддерживает ли Singularity задачи без проекта. Нужно проверить вручную до написания кода. Если не поддерживает — альтернатива: завести специальный проект «Входящие» и хардкодить его ID.
- **Дублирование логики** с `create_task` — минимально, общий код (`_msk_day_utc`, `_today_msk`) уже вынесен в хелперы.
