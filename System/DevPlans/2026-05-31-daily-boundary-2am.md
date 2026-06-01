---
created: 2026-05-31
status: ready
tags:
  - dev
  - daily
  - fix
---

# Сдвинуть границу дейли-заметки на 02:00

## Задача

Записи после полуночи до 02:00 должны попадать в дейли **предыдущего** дня, а не нового.

## Контекст

`append_daily.py` использует текущую дату как имя файла. После полуночи новая запись уходит в `Daily/YYYY-MM-DD+1.md`, хотя пользователь ещё не ложился спать и воспринимает это как часть прошлого дня. Приходится вручную переносить.

## Файлы

- `skills/append_daily.py` — строки 107–110

## Изменение

```python
# было
now = get_now()
today = now.strftime("%Y-%m-%d")
timestamp = now.strftime("%H:%M")

# стало
from datetime import timedelta

now = get_now()
logical_now = now - timedelta(hours=2)   # сдвиг границы на 02:00
today = logical_now.strftime("%Y-%m-%d")
timestamp = now.strftime("%H:%M")        # реальное время в тексте не меняем
```

## Шаги

1. Добавить `from datetime import timedelta` в импорты (или использовать уже импортированный `datetime`)
2. Заменить `today = now.strftime(...)` на `today = (now - timedelta(hours=2)).strftime(...)`
3. Проверить: запись в 00:30 → попадает в файл предыдущего дня, timestamp остаётся `00:30`

## Риски

Минимальные. Изменение в одну строку, не затрагивает другие скрипты.
