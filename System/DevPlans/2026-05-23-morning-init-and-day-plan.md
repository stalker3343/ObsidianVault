# Dev Plan: Morning Init + Day Plan System

date: 2026-05-23
status: todo
priority: high

Объединяет:
- [[2026-05-17-morning-brief-script]] — скрипт утреннего брифа
- [[2026-05-23-agent-init-refactor]] — вынос инициализации из AGENT.md
- [[2026-05-22-pdf-daily-plan]] — план дня в PDF
- [[2026-05-23-day-plan-editor]] — редактор плана (side feature, отдельно)

---

## Суть

Сейчас агент на старте делает 4+ операций в контексте, засоряет окно.
План дня генерируется в чат — его неудобно листать, редактировать, печатать.

Нужно два скилла:

1. **`morning_init`** — один скрипт собирает весь контекст дня в один MD-файл. Агент читает один файл вместо 5 операций.
2. **`generate_day_plan`** — скилл генерирует план дня, сохраняет в Obsidian, вставляет ссылку в Daily.

---

## Часть 1: morning_init.py

### Что делает
Запускается на старте разговора (или по cron в 05:55 МСК).
Собирает всё в один файл `System/Today/morning-brief.md`:

```
# Бриф на YYYY-MM-DD (день недели)

## Фокус недели
...из System/WeeklyFocus/YYYY-MM-DD.md...

## Погода
...wttr.in/Rostov-on-Don?format=j1 (try/except — опционально)...

## Календарь
...из schedule.md — сегодня, завтра, послезавтра, ДР...

## Задачи Singularity
...просроченные + сегодня...  ← пока через dump_agenda (MCP), потом через API напрямую

## Вчера (выжимка)
...Daily/YYYY-MM-DD.md — секция Capture, первые 50 строк...

## Открытые DevPlans
...glob System/DevPlans/*.md, status: todo|in-progress...
```

### AGENT.md после рефакторинга
Было: 6 секций инициализации, ~30 строк.
Станет:
```
На старте: run skills/morning_init.py → прочитай System/Today/morning-brief.md + System/Wiki/index.md
```

### Нюанс: Singularity MCP
`dump_agenda_to_vault()` нельзя вызвать из Python-скрипта напрямую.
Варианты:
- А) Агент вызывает MCP отдельно, результат уже в файле — скрипт просто включает ссылку на него
- Б) Реализовать прямой HTTP-запрос к Singularity API в скрипте (если есть эндпоинт)
- В) morning_init.py запускает всё кроме Singularity, агент вызывает dump_agenda — итого 2 действия вместо 5

**Рекомендация: Вариант В** как первый шаг.

### Cron
```
cc-connect cron add --cron "55 5 * * *" --exec "cd /srv/telegram-obsidian-agent && .venv/bin/python skills/morning_init.py" --desc "Morning brief"
```

---

## Часть 2: generate_day_plan (скилл)

### Сценарий
Пользователь пишет «составь план дня» или `/day_plan` (+ опционально добавляет нюансы: «учти что...»).
Агент генерирует план и:
1. Сохраняет в `System/Today/day-plans/YYYY-MM-DD.md`
2. Вставляет ссылку в Daily (даже если файл ещё не создан — Obsidian покажет красную ссылку)
3. Отправляет план в чат текстом

### Файл плана дня
```
System/Today/day-plans/2026-05-23.md
```
Постоянный — каждый день новый файл, не перезаписывается.
Формат: временные блоки с задачами, обед/ужин как якоря, ✅ / ◇ маркеры.

### Ссылка в Daily (автоматически)
При генерации плана — скрипт `append_daily.py` или отдельный вызов дописывает в начало Daily:
```
## План дня
[[System/Today/day-plans/2026-05-23]]
```
Если пользователь ещё не просил план — ссылка не вставляется. Только по факту создания.

### Инструкции для генерации плана (в AGENT.md)
Добавить секцию `## Генерация плана дня`:
- Опираться на фокус недели (брать из брифа)
- Якоря: обед, ужин, события из календаря
- Маркеры: ✅ обязательно, ◇ опционально
- Спросить нюансы если пользователь не указал: «Что учесть сегодня, что не видно из задач?»
- Не пересоздавать если план уже есть — предлагать отредактировать

### PDF (опционально, после MVP)
`/plan_pdf` → `skills/generate_plan_pdf.py` читает `day-plans/YYYY-MM-DD.md` → генерирует PDF → отправляет через `cc-connect send --file`.
Библиотека: `weasyprint` (HTML-шаблон) или `reportlab`.
Формат: A4, ч/б, поля для пометок, 1 лист.

---

## Шаги реализации

### Этап 1 — morning_init.py (MVP)
- [ ] Создать `skills/morning_init.py` (calendar + weekly_focus + вчерашний Daily)
- [ ] Агент вызывает скрипт + отдельно dump_agenda (пока так)
- [ ] Сократить AGENT.md: убрать 4 секции инициализации, заменить одной строкой
- [ ] Добавить в `.claude/settings.json` allow для `skills/morning_init.py`
- [ ] Опционально: cron в 05:55

### Этап 2 — generate_day_plan
- [ ] Создать `skills/save_day_plan.py` — принимает текст плана, сохраняет в `day-plans/YYYY-MM-DD.md`, вставляет ссылку в Daily
- [ ] Добавить маршрут в AGENT.md: «составь план / /day_plan → generate + save_day_plan.py»
- [ ] Добавить секцию инструкций по генерации плана в AGENT.md
- [ ] Добавить в allow

### Этап 3 — PDF (опционально)
- [ ] `skills/generate_plan_pdf.py` + HTML-шаблон
- [ ] `cc-connect send --file`
- [ ] Маршрут `/plan_pdf` в AGENT.md

---

## Затронутые файлы

| Файл | Действие |
|---|---|
| `skills/morning_init.py` | Создать |
| `skills/save_day_plan.py` | Создать |
| `skills/generate_plan_pdf.py` | Создать (этап 3) |
| `skills/templates/daily_plan.html` | Создать (этап 3) |
| `System/Today/day-plans/` | Новая папка |
| `AGENT.md` | Упростить инициализацию, добавить секцию плана |
| `.claude/settings.json` | Добавить allow для новых скриптов |
| `requirements.txt` | Добавить weasyprint/reportlab (этап 3) |

---

## Риски

| Риск | Митигация |
|---|---|
| Singularity MCP не вызвать из скрипта | Вариант В: агент вызывает dump_agenda отдельно |
| wttr.in недоступен | try/except, секция погоды опциональная |
| Бриф слишком большой → контекст раздувается | Лимит на Daily-выжимку (50 строк), краткий формат задач |
| weasyprint тяжёлый | Попробовать reportlab первым |
