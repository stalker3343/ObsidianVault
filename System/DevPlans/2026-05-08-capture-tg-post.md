---
type: dev-plan
feature: capture_tg_post
created: 2026-05-08
status: draft
tags:
  - bot
  - dev
---

# Dev Plan: capture_tg_post — сохранение пересланных Telegram-постов

## Задача

Когда пользователь пересылает пост из публичного Telegram-канала, бот должен:
1. Создать заметку в `Inbox/` с текстом поста и ссылкой на оригинал
2. Добавить в дейли строку `[[ссылка на заметку]] — название канала: краткое описание`

---

## Структура данных: как приходит пересланное сообщение

Через cc-connect мне (Claude) приходит текст сообщения. Telegram Bot API при forwards из публичного канала передаёт в metadata:

```
message.forward_from_chat.type       = "channel"
message.forward_from_chat.title      = "Название канала"
message.forward_from_chat.username   = "channel_username"   # только у публичных
message.forward_from_message_id      = 12345                 # ID оригинального поста
message.text                         = "Текст поста..."
message.caption                      = "Подпись к медиа..."  # если это фото/видео
message.entities                     = [...]                 # форматирование
```

URL оригинального поста: `https://t.me/{username}/{message_id}`
Embed-версия для scraping: `https://t.me/{username}/{message_id}?embed=1`

> **Открытый вопрос:** cc-connect сейчас передаёт мне только текст или весь metadata?
> Нужно протестировать — переслать пост и посмотреть, что именно я вижу.
> Возможно, потребуется доработка cc-connect bridge для передачи `forward_from_chat`.

---

## Новый skill: `skills/capture_tg_post.py`

### CLI-интерфейс

```
.venv/bin/python skills/capture_tg_post.py \
  --text "текст поста" \
  --channel-title "Название канала" \
  --channel-username "channel_username" \
  --message-id 12345 \
  --comment "мой комментарий"   # опционально
```

### Логика

1. Принять аргументы
2. Сформировать URL: `https://t.me/{channel_username}/{message_id}`
3. Попытаться получить полный текст через embed (`?embed=1`) если `--text` < 200 символов — многие посты в Telegram обрезаются при forward
4. Сформировать slug из первых слов заголовка/текста
5. Создать файл `Inbox/{today} - tg-post - {slug[:80]}.md`
6. Добавить bullet в daily через `_write_daily()` из `_common.py`
7. Сделать один `git_atomic_commit` для обоих файлов

### Формат заметки в Inbox

```markdown
---
type: tg-post
source: https://t.me/channel_username/12345
channel: "Название канала"
created: 2026-05-08T14:32:00
status: inbox
tags:
  - source/telegram
---

# Название канала — первые слова поста

[Источник](https://t.me/channel_username/12345)

## Мой комментарий

{comment}

## Текст поста

{text}
```

### Запись в Daily

```
- **14:32** [[Inbox/2026-05-08 - tg-post - slug]] — Название канала: первые 100 символов поста...
```

---

## Изменения в AGENT.md (routing table)

Добавить строку в таблицу маршрутизации:

```diff
+| Пересланный пост из Telegram-канала | `.venv/bin/python skills/capture_tg_post.py --text ... --channel-title ... --channel-username ... --message-id ... --comment ...` |
```

И в раздел **Маршрутизация** добавить условие: если сообщение — forward из канала (видно по метаданным или по паттерну текста с указанием источника).

---

## Псевдо-diff: что добавляется в репо

```diff
 skills/
+  capture_tg_post.py          # новый skill
   capture_article.py          # без изменений
   append_daily.py             # без изменений
   _common.py                  # без изменений (переиспользуем git_atomic_commit, _write_daily logic)

 AGENT.md
+  | Пересланный пост из канала | capture_tg_post.py ... |
```

`capture_tg_post.py` — ~130 строк, структура аналогична `capture_article.py`:
- `_import_runtime_deps()` → нужен `requests`, `beautifulsoup4` для парсинга embed
- `_fetch_full_text(url)` → GET `https://t.me/{u}/{id}?embed=1`, парсинг `<div class="tgme_widget_message_text">`
- `_post_body(...)` → формирует Markdown заметку
- `capture_tg_post(...)` → основная логика
- `main()` → argparse + logging

---

## TODO перед реализацией

- [ ] Проверить: что именно cc-connect передаёт при forward — только `message.text` или весь update dict?
- [ ] Проверить `beautifulsoup4` в `.venv`: `pip show beautifulsoup4`
- [ ] Протестировать embed-парсинг на реальном посте из публичного канала
- [ ] Договориться о формате slug (из текста или из названия канала?)
