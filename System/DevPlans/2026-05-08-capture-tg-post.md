---
type: dev-plan
feature: capture_tg_post
created: 2026-05-08
status: ready
tags:
  - bot
  - dev
---

# Dev Plan: capture_tg_post — сохранение пересланных постов

## Что уже известно

- cc-connect передаёт **полный текст** пересланного поста — не обрезанный
- Изображения сохраняются локально в `.cc-connect/attachments/` и путь приходит в сообщении
- Metadata Telegram (channel_username, message_id) **не передаётся** — только текст
- `channel_username` в конце поста — это привычка конкретных авторов, не стандарт. Парсинг ненадёжен, не использовать
- Никакого внешнего fetching не нужно — весь контент уже есть

---

## Новый skill: `skills/capture_tg_post.py`

### CLI

```
.venv/bin/python skills/capture_tg_post.py \
  --text "текст поста" \
  --channel-title "Название канала" \
  --channel-username "channel_username" \   # опционально, только если известен
  --image-path "/srv/.../.cc-connect/attachments/img_xxx.jpg" \  # опционально
  --comment "мой комментарий"               # опционально
```

### Логика

1. Принять аргументы; `--channel-username` опционален — если не передан, поле `source` в заметке остаётся пустым
2. Сформировать slug из первых слов текста
3. Если передан `--image-path` — скопировать файл в `Attachments/{today}-{slug}.jpg` и вставить в заметку как `![[...]]`
4. Создать `Inbox/{today} - post - {slug[:80]}.md`
5. Добавить bullet в дейли: `[[Inbox/...]] — Канал: первые 100 символов...`
6. Один `git_atomic_commit` для всех изменённых файлов (заметка + картинка + дейли)

### Формат заметки в Inbox

```markdown
---
type: post
source: https://t.me/{channel_username}   # если username известен
channel: "Название канала"
created: {datetime}
status: inbox
tags:
  - source/telegram
---

# Название канала — первые слова поста

![[Attachments/{today}-{slug}.jpg]]   # если есть изображение

## Мой комментарий

{comment}

## Текст поста

{text}
```

---

## Изменения в репо

```diff
 skills/
+  capture_tg_post.py      # ~100 строк, аналогична capture_article.py

 AGENT.md
+  | Пересланный пост (текст канала / скриншот поста) | capture_tg_post.py --text ... --channel-title ... --image-path ... |
```

Внешних зависимостей не нужно — только стандартный `shutil.copy2` для изображений.

---

## Про копирование изображений

`cp` через Bash заблокирован в текущих настройках агента. Решения:
- Использовать `shutil.copy2()` внутри самого Python-скилла — это разрешено
- Или добавить `cp /srv/telegram-obsidian-agent/.cc-connect/attachments/* /srv/ObsidianVault/Attachments/*` в whitelist Bash-команд агента

Рекомендуется первый вариант — копирование внутри skill, без изменения настроек безопасности.

---

## TODO

- [ ] Написать `capture_tg_post.py`
- [ ] Добавить строку в таблицу маршрутизации AGENT.md
- [ ] Протестировать на реальном пересланном посте с картинкой
