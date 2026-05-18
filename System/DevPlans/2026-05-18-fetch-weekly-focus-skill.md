---
created: 2026-05-18
status: idea
tags:
  - dev-plan
  - skills
  - weekly-focus
---

# Dev Plan: skills/fetch_weekly_focus.py

## Задача

Скрипт, который находит файл фокуса текущей недели и возвращает его содержимое агенту.
Агент не должен вручную вычислять «ближайший понедельник» — скрипт делает это сам.

## Соглашение о файлах

```
System/WeeklyFocus/YYYY-MM-DD.md   ← дата понедельника недели
```

Файл создаётся вручную каждый понедельник (или в конце предыдущей недели).
Пример: `System/WeeklyFocus/2026-05-18.md`.

## Логика скрипта

```python
from datetime import date, timedelta

def current_week_monday(today: date) -> date:
    return today - timedelta(days=today.weekday())  # weekday(): пн=0, вс=6
```

Алгоритм поиска:
1. Вычислить дату понедельника текущей недели
2. Попробовать открыть `System/WeeklyFocus/{monday}.md`
3. Если файл не найден — попробовать предыдущий понедельник (на случай, если файл не создали в этот пн)
4. Вернуть содержимое или `ok=false` с понятной ошибкой

## Интерфейс

```bash
.venv/bin/python skills/fetch_weekly_focus.py
```

### JSON-ответ (успех)
```json
{
  "ok": true,
  "path": "System/WeeklyFocus/2026-05-18.md",
  "week_start": "2026-05-18",
  "content": "..."
}
```

### JSON-ответ (файл не найден)
```json
{
  "ok": false,
  "error": "FileNotFoundError",
  "message": "No weekly focus file found for week 2026-05-18"
}
```

## Код (полный)

```python
import sys
import time
from datetime import date, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))
from skills._common import VAULT_ROOT, skill_output, log_skill

WEEKLY_FOCUS_DIR = ("System", "WeeklyFocus")

def current_week_monday(today: date) -> date:
    return today - timedelta(days=today.weekday())

def find_focus_file(vault_root: Path, today: date) -> tuple[Path, date] | None:
    monday = current_week_monday(today)
    for delta in (0, 7):  # текущая неделя, потом предыдущая
        candidate_date = monday - timedelta(weeks=delta // 7)
        path = vault_root.joinpath(*WEEKLY_FOCUS_DIR) / f"{candidate_date.isoformat()}.md"
        if path.exists():
            return path, candidate_date
    return None

def main() -> None:
    t0 = time.monotonic()
    today = date.today()
    result = find_focus_file(VAULT_ROOT, today)

    if result is None:
        monday = current_week_monday(today)
        log_skill("fetch_weekly_focus", {"today": today.isoformat()},
                  ok=False, latency_ms=int((time.monotonic()-t0)*1000),
                  error_type="FileNotFoundError")
        skill_output(False, error="FileNotFoundError",
                     message=f"No weekly focus file found for week {monday.isoformat()}")
        return

    path, week_start = result
    content = path.read_text(encoding="utf-8")
    latency_ms = int((time.monotonic() - t0) * 1000)
    log_skill("fetch_weekly_focus", {"today": today.isoformat()},
              ok=True, latency_ms=latency_ms)
    skill_output(True,
                 path=str(path.relative_to(VAULT_ROOT)),
                 week_start=week_start.isoformat(),
                 content=content)

if __name__ == "__main__":
    main()
```

## Шаги реализации

1. Создать `skills/fetch_weekly_focus.py` по коду выше
2. Протестировать: `.venv/bin/python skills/fetch_weekly_focus.py`
3. Добавить в `AGENT.md` в секцию старта: вызывать скрипт, читать `content` из JSON
4. Добавить в allow в `.claude/settings.json`:
   `"Bash(skills/fetch_weekly_focus.py)"`
5. В [[2026-05-17-morning-brief-script]] — использовать как источник секции «Фокус недели»

## Затронутые файлы

| Файл | Изменение |
|---|---|
| `skills/fetch_weekly_focus.py` | Новый скрипт |
| `AGENT.md` | Добавить вызов скрипта в стартовую последовательность |
| `.claude/settings.json` | Добавить в allow |

## Риски

| Риск | Митигация |
|---|---|
| Файл не создан на текущей неделе | Фоллбэк на прошлую неделю + `ok=false` если и та не найдена |
| Агент вызывает в воскресенье — файл следующей недели ещё не создан | Фоллбэк работает корректно |
