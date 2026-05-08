---
type: dev-plan
feature: google_calendar_integration
created: 2026-05-08
status: draft
tags:
  - bot
  - dev
  - google-calendar
---

# Dev Plan: интеграция с Google Calendar

## Задача

Утром бот тянет расписание на день из Google Calendar, сохраняет в vault, держит в контексте и напоминает о событиях по ходу разговора.

---

## Архитектура

### Хранение расписания

Файл `System/Today/schedule.md` — перезаписывается каждое утро. Я читаю его в начале разговора и держу в голове.

```
System/
  Today/
    schedule.md    ← сегодняшние события, перезаписывается ежедневно
```

### Когда тянуть

Крон-задача через `cc-connect cron` в 7:00 — запускает `fetch_calendar.py`, который пишет `schedule.md`.  
Если файл уже есть за сегодня — пропускает (idempotent).

### Как напоминать

В AGENT.md добавить инструкцию: в начале каждого разговора читать `System/Today/schedule.md` и если есть событие в ближайший час — упомянуть коротко.

---

## Новый skill: `skills/fetch_calendar.py`

### CLI

```
.venv/bin/python skills/fetch_calendar.py
```

Без аргументов — всегда тянет на сегодня.

### Логика

1. Авторизоваться через OAuth2 (refresh_token из `.env`)
2. Запросить события на сегодня: `calendars/primary/events` с `timeMin=00:00` и `timeMax=23:59`
3. Отфильтровать: только события с временем (не all-day если не нужны)
4. Записать в `System/Today/schedule.md`
5. `git_atomic_commit`

### Формат `schedule.md`

```markdown
---
date: 2026-05-08
fetched: 2026-05-08T07:00:00
---

# Расписание на 2026-05-08

- 09:00–10:00 Созвон с Валентином
- 14:00–15:00 Английский с преподавателем
- 19:00–19:30 Звонок с Бадди
```

---

## Авторизация Google Calendar API

Нужны:
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_REFRESH_TOKEN`

Хранить в `.env` (уже используется в проекте). Получить refresh_token — один раз через OAuth2 flow вручную.

Зависимость: `google-api-python-client`, `google-auth` — проверить наличие в `.venv`.

---

## Изменения в репо

```diff
 skills/
+  fetch_calendar.py       # ~80 строк

 System/Today/
+  schedule.md             # генерируется автоматически, в .gitignore не добавлять

 AGENT.md
+  # В начале разговора: прочитать System/Today/schedule.md, если есть событие
+  # в ближайший час — упомянуть коротко
```

Крон через cc-connect (не в репо):
```
cc-connect cron add --cron "0 7 * * *" --prompt "Запусти fetch_calendar.py и пришли подтверждение" --desc "Daily calendar fetch"
```

---

## TODO

- [ ] Получить OAuth2 refresh_token для Google Calendar
- [ ] Проверить `google-api-python-client` в `.venv`
- [ ] Написать `fetch_calendar.py`
- [ ] Добавить инструкцию в AGENT.md про чтение schedule.md
- [ ] Настроить крон через cc-connect
- [ ] Протестировать: крон → fetch → schedule.md → бот видит события
