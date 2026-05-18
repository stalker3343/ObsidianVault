# Dev Plan: Fix schedule.md permission error

## Задача
`fetch_calendar.py` падает с `PermissionError` при записи в `System/Today/schedule.md`.

## Контекст
Файл `/srv/ObsidianVault/System/Today/schedule.md` создан от имени `root` (`-rw-r--r-- 1 root root`).
Агент работает как `bot` — прав на запись нет.
Директория `Today/` принадлежит `bot`, поэтому `bot` **может удалить** файл из неё (права на unlink определяет директория, а не файл).

## Диагностика
```
ls -la /srv/ObsidianVault/System/Today/
# -rw-r--r-- 1 root root  520 May 17 13:47 schedule.md   ← проблема
# drwxr-xr-x 3 bot  bot        ...                       ← директория OK
```
Docker Compose не задаёт `user:`, в Dockerfile нужно смотреть кем запускается процесс.
Файл, скорее всего, создан `git clone` или `docker exec` под root в старом контейнере.

## Решения (в порядке приоритета)

### Вариант 1 — Фикс в скилле (быстрый, точечный) ⭐ рекомендуется как первый шаг
**Файл:** `skills/fetch_calendar.py`, строка ~600 перед `schedule_path.write_text(...)`

Добавить перед записью:
```python
if schedule_path.exists() and not os.access(schedule_path, os.W_OK):
    schedule_path.unlink()
```

- `bot` владеет директорией → `unlink()` сработает
- после `unlink()` `write_text()` создаст файл с правильным владельцем `bot`
- идемпотентно: если файл уже writable — ничего не делаем

**Затронутые файлы:** `skills/fetch_calendar.py`
**Риск:** низкий. Потеря старого содержимого schedule — не критично, он всё равно перезаписывается.

---

### Вариант 2 — Docker entrypoint (защита от рецидива)
Добавить startup-скрипт `entrypoint.sh`, который запускается от root, фиксирует права, затем `exec`-ает процесс от `bot`.

```bash
#!/bin/sh
chown -R bot:bot /srv/ObsidianVault/System/Today/ 2>/dev/null || true
exec su-exec bot:bot "$@"
```

В `Dockerfile`:
```dockerfile
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/srv/telegram-obsidian-agent/start.sh"]
```

**Затронутые файлы:** `Dockerfile`, новый `entrypoint.sh`
**Риск:** средний. Требует пересборки образа и проверки, что su-exec установлен или заменить на `gosu`/`runuser`.

---

### Вариант 3 — Volume init-container в Docker Compose
Добавить `init-vault` сервис, который запускается один раз от root и фиксирует права:

```yaml
services:
  init-vault:
    image: alpine
    volumes:
      - vault-working:/srv/ObsidianVault
    command: sh -c "chown -R 1000:1000 /srv/ObsidianVault/System/Today/ || true"
    restart: "no"

  agent:
    depends_on:
      init-vault:
        condition: service_completed_successfully
    ...
```

**Затронутые файлы:** `docker-compose.yml`
**Риск:** низкий, но добавляет зависимость при каждом `docker compose up`.

---

## Рекомендуемый порядок

1. **Сейчас:** применить Вариант 1 (фикс в скилле) — решает проблему без пересборки образа.
2. **При следующем деплое:** добавить Вариант 2 или 3 как защиту от повтора (если снова появится файл от root).

## Шаги для Варианта 1

1. Открыть `skills/fetch_calendar.py`
2. Найти строку `schedule_path.write_text(content, encoding="utf-8", newline="\n")` (~626)
3. Вставить перед ней:
   ```python
   if schedule_path.exists() and not os.access(schedule_path, os.W_OK):
       schedule_path.unlink()
   ```
4. Протестировать: `python skills/fetch_calendar.py --current-window`
5. Убедиться, что файл создался с владельцем `bot`

## Риски

| Риск | Вероятность | Митигация |
|---|---|---|
| Другие файлы vault тоже от root | Низкая | Проверить `ls -la /srv/ObsidianVault/System/Today/` |
| su-exec не установлен в образе | Средняя | Использовать `gosu` или `runuser -u bot` |
| Entrypoint сломает запуск | Низкая | Тест в dev перед деплоем |
