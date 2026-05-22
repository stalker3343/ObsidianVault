# Dev Plan: детерминированные команды и fallback-бот

**Дата:** 2026-05-22
**Статус:** идея
**Объединяет:** [[2026-05-21-bot-deterministic-commands]], [[2026-05-22-api-fallback-buttons]]

---

## Задача

Снять зависимость бота от Anthropic API как единственной точки отказа. Решить две связанных проблемы:

1. **Скорость и предсказуемость** — сейчас каждое сообщение идёт через LLM даже когда тип очевиден (`/thought Купить хлеб`).
2. **Resilience** — когда Claude API недоступен, бот полностью умирает. Инцидент: 22 мая 2026, ~8:00 МСК, ~1 час простоя.

## Контекст

**Текущая цепочка:**
```
Telegram → cc-connect → Claude Code → Anthropic API → Python skills → vault
```
Единственная точка отказа — Anthropic API. Все маршрутизации на LLM, ручных fallback'ов нет.

---

## Архитектура решения: два уровня

```
Уровень 1 (скорость): детерминированные команды в основном боте
Уровень 2 (resilience): отдельный fallback-бот без LLM
```

Уровни независимы — можно реализовывать по очереди.

---

## Уровень 1 — Детерминированные slash-команды

Перехватывать сообщения начинающиеся с `/` до передачи в LLM. Команда в маппинге → напрямую вызвать skill, не звать Claude.

### Команды

| Команда | Skill | Примечание |
|---|---|---|
| `/thought <текст>` | `append_daily.py --kind thought` | |
| `/plan <текст>` | `append_daily.py --kind plan` | |
| `/note <текст>` | `append_daily.py --kind material_note` | |
| `/url <ссылка>` | `capture_article.py` или `capture_youtube.py` (по домену) | |
| `/task <текст>` | Singularity `create_task` без проекта | |
| `/agenda` | Singularity `get_agenda` → ответ в чат | |
| `/undo` | `undo_last.py` | |
| `/status` | `status.py` | |

Опционально: inline-кнопка `[Отменить]` после каждого успешного сохранения.

### Шаги реализации

1. **Обработчик в cc-connect / pre-LLM хук**
   - Проверить, поддерживает ли cc-connect перехват до LLM
   - Если нет — добавить жёсткое правило в начало `AGENT.md`: «если сообщение начинается с `/thought` — немедленно вызвать skill без рассуждений»

2. **`skills/dispatch.py`** — центральный диспатчер
   - Принимает `--command` и `--args`
   - Маппинг команда → skill + шаблон аргументов
   - Возвращает JSON как остальные skills

3. **BotFather `setcommands`** — зарегистрировать команды для автодополнения в Telegram

### Затронутые файлы (уровень 1)

| Файл | Действие |
|---|---|
| `AGENT.md` | Добавить строки маршрутизации для `/thought`, `/plan`, `/url` и т.д. |
| `skills/dispatch.py` | Создать |
| `cc-connect/config.toml` | Возможно, хук на входящие сообщения |

---

## Уровень 2 — Fallback-бот (без LLM)

Отдельный лёгкий Python-бот на **отдельном Telegram-токене**. Работает всегда, не зависит от cc-connect и Anthropic API.

### Почему отдельный токен

Telegram не допускает двух polling-клиентов на один токен. cc-connect занимает основной.

### Архитектура

```
Telegram (FallbackBot token)
→ fallback-bot/main.py  (python-telegram-bot, asyncio)
→ Python skills / Singularity REST API
→ vault
```

### Функциональность MVP

При `/start` или `/help` — inline-клавиатура:

```
[📝 Мысль в Daily]   [🔗 Ссылка / YouTube]
[📋 Задача]          [📅 Повестка дня]
```

| Кнопка | Реализация |
|---|---|
| Мысль | ConversationHandler → `append_daily.py --kind thought` |
| Ссылка | ConversationHandler → `capture_article.py` / `capture_youtube.py` |
| Задача | HTTP-запрос к Singularity API напрямую (без MCP) |
| Повестка | HTTP-запрос к Singularity `get_agenda` → форматированный ответ |

Ответы минимальные: `Записал ✓` или текст ошибки. Никакого LLM.

### Уведомление при деградации (опционально)

Если основной бот не отвечает 2+ мин → fallback-бот шлёт в чат:
`⚠️ Основной бот недоступен. Используй меня для базовых действий.`

### Шаги реализации

1. **BotFather** → создать второго бота → `FALLBACK_BOT_TOKEN`
2. **`fallback-bot/main.py`** — ConversationHandler с кнопками
3. **Singularity REST** — прямые `httpx`-запросы, те же env vars `SINGULARITY_*`
4. **Docker-сервис `fallback-bot`** в `docker-compose.yml`
   - Монтировать тот же `/srv/ObsidianVault` и `.venv`
   - Env: `FALLBACK_BOT_TOKEN`, `FALLBACK_ALLOWED_IDS`

### Затронутые файлы (уровень 2)

| Файл | Действие |
|---|---|
| `fallback-bot/main.py` | Создать |
| `fallback-bot/requirements.txt` | `python-telegram-bot>=21`, `httpx` |
| `docker-compose.yml` | Добавить сервис `fallback-bot` |
| `.env.example` | Добавить `FALLBACK_BOT_TOKEN`, `FALLBACK_ALLOWED_IDS` |

---

## Риски

| Риск | Митигация |
|---|---|
| cc-connect не поддерживает pre-LLM хуки | Жёсткие правила в `AGENT.md` как fallback для уровня 1 |
| Конфликт `/undo_last`, `/status` (уже в AGENT.md) | Проверить, нет ли дублей, убрать из LLM-роутинга |
| Два контейнера делают git push одновременно | Lock-файл или просто принять — конфликты маловероятны при одном пользователе |
| Singularity API падает вместе с Claude API | Показать ошибку, предложить `/thought` для ручной записи |
| Поддержка второго бота = двойная поверхность | MVP ~200–300 строк, без LLM, без сложной логики |

---

## Оценка трудозатрат

| Этап | Время |
|---|---|
| Уровень 1: `dispatch.py` + правила `AGENT.md` | ~2ч |
| Уровень 1: BotFather setcommands | ~30 мин |
| Уровень 2: fallback-bot + ConversationHandler | ~2–3ч |
| Уровень 2: Docker-сервис + деплой | ~1ч |
| Уровень 2: Singularity REST напрямую | ~1ч |
| Тесты + smoke-test на VPS | ~1ч |

**Итого: ~7–8 часов.** Реализовывать уровнями — уровень 1 быстрее и даёт 80% пользы.
