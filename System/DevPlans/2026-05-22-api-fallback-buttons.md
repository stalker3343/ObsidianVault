# Dev Plan: fallback-бот с кнопками при недоступности Claude API

**Дата:** 2026-05-22
**Статус:** объединён → [[2026-05-22-bot-resilience-and-commands]]

---

## Задача

Когда Anthropic API недоступен, весь бот падает — cc-connect не может передать сообщение Claude Code, пользователь остаётся без инструмента на неизвестное время. Нужен fallback, который работает **независимо от Claude API**.

## Контекст

**Инцидент:** 22 мая 2026, ~8:00 МСК — API Claude отвалился на ~1 час. Весь routing на боте, ручных кнопок нет, план дня пропал.

**Текущая цепочка:**
```
Telegram → cc-connect → Claude Code → Anthropic API → Python skills → vault
```
Единая точка отказа: Anthropic API. Если он недоступен — цепочка обрывается на шаге 2.

**Предыдущий план** `2026-05-21-bot-deterministic-commands.md` решает скорость, но не resilience: он всё равно идёт через cc-connect → LLM.

---

## Предлагаемое решение: отдельный fallback-бот

Отдельный лёгкий Python-бот на **отдельном Telegram-токене** (FallbackBot). Не зависит от cc-connect и Anthropic API — напрямую вызывает Python skills.

```
Telegram (FallbackBot token)
→ fallback-bot/main.py (python-telegram-bot)
→ Python skills / singularity API
→ vault
```

### Почему отдельный токен, а не тот же

Telegram не допускает двух polling-клиентов на один токен. cc-connect занимает основной токен.

---

## Функциональность MVP

При старте диалога или команде `/help` — inline-клавиатура:

```
[📝 Мысль в Daily]  [🔗 Ссылка / YouTube]
[📋 Задача]         [📅 Повестка]
```

| Действие | Реализация |
|---|---|
| Текст → Daily | `append_daily.py --kind thought` |
| URL → capture | `capture_article.py` или `capture_youtube.py` (по домену) |
| Создать задачу | Singularity REST API напрямую (без MCP) |
| Повестка | Singularity REST API `get_agenda` |
| `/status` | `status.py` |

Ответы — минимальные: `Записал ✓` или текст ошибки.

---

## Шаги реализации

1. **Создать Telegram-бота через BotFather** → получить `FALLBACK_BOT_TOKEN`

2. **`fallback-bot/main.py`**
   - `python-telegram-bot` (asyncio, polling)
   - ConversationHandler: стартовый экран с кнопками → ввод текста/URL → вызов skill
   - Прямой вызов `subprocess` для Python skills

3. **Singularity без MCP**
   - Для `create_task` и `get_agenda` — прямые HTTP-запросы к Singularity API (те же env vars `SINGULARITY_*`)
   - Не нужен MCP-сервер

4. **Docker-сервис `fallback-bot`**
   - Добавить в `docker-compose.yml` новый сервис
   - Монтировать тот же `/srv/ObsidianVault` и `.venv`
   - Env: `FALLBACK_BOT_TOKEN`, `ALLOWED_TELEGRAM_IDS`

5. **Уведомление при деградации (опционально)**
   - Основной бот при старте пингует `/health` fallback-бота
   - Если основной не отвечает 2+ мин → fallback сам шлёт в чат: `⚠️ Основной бот недоступен. Используй меня для базовых действий.`

6. **BotFather: `setcommands`** — зарегистрировать команды для автодополнения

---

## Затронутые файлы

| Файл | Действие |
|---|---|
| `fallback-bot/main.py` | Создать (новый сервис) |
| `fallback-bot/requirements.txt` | `python-telegram-bot>=21`, `httpx` |
| `fallback-bot/Dockerfile` | Минимальный образ (или общий) |
| `docker-compose.yml` | Добавить сервис `fallback-bot` |
| `.env.example` | Добавить `FALLBACK_BOT_TOKEN`, `FALLBACK_ALLOWED_IDS` |

---

## Риски

| Риск | Митигация |
|---|---|
| Два бота шлют одновременно — дубли в vault | Fallback не перехватывает сообщения основного бота (разные токены) — конфликтов нет |
| Singularity API недоступен одновременно с Claude | Показать ошибку, предложить записать текстом в Daily |
| Поддержка второго бота = двойная поверхность | MVP минимален (200–300 строк), нет LLM, нет сложной логики |
| git push из двух контейнеров одновременно | Фиксить через lock-файл в vault или просто принять (конфликты маловероятны при разных пользователях) |

---

## Оценка трудозатрат

- Создать бота + ConversationHandler: ~2–3ч
- Docker-сервис: ~1ч
- Singularity REST напрямую: ~1ч
- Тест + деплой: ~1ч

**Итого: ~5–6 часов**
