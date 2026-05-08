---
type: post
source: https://github.com/CodeAlive-AI/ai-driven-development/tree/main/hooks/balanced-safety-hooks
channel: "AI-Driven Development (@ai_driven)"
created: 2026-05-08
status: inbox
tags:
  - source/telegram
  - claude-code
  - ai-tools
  - dev
---

# Safety Hooks для coding-агентов — balanced-safety-hooks

Канал: [AI-Driven Development](https://t.me/ai_driven)
Репо: [CodeAlive-AI/ai-driven-development](https://github.com/CodeAlive-AI/ai-driven-development/tree/main/hooks/balanced-safety-hooks)

## Суть

Хуки для Claude Code и других coding-агентов, которые ловят деструктивные действия без false-positive. Принцип: не блокировать слишком много (иначе привыкаешь тыкать Enter не читая), а закрывать только действительно необратимые операции.

**Ключевое решение:** использовать `ask`-хуки вместо блокирующих — умный агент найдёт обход блокировки, а ask заставляет остановиться и спросить.

## Что покрывают хуки

1. **rm** — `rm/unlink/shred` вне cwd, по `/etc`, `$HOME`; через `sudo`, `xargs`, `find -delete`
2. **infra** — `kubectl`, `docker`, `terraform`, `helm`, `gcp`
3. **db** — `DROP/TRUNCATE/DELETE` через `psql/mysql`; `redis-cli FLUSHALL/SHUTDOWN`, `supabase`
4. **paas** — Railway, Fly, Heroku, Vercel, Netlify с destructive-глаголами
5. **git** — `reset --hard`, `clean -fd`, `checkout .`, `branch -D`, `stash drop/clear`, `push -f`, `push --delete`

## Технические детали

- Написаны на **Go** → несколько мс на выполнение
- Парсинг **AST** вместо regex → практически нулевой false-positive
- Покрыты тестами
- Поддерживают Claude Code, Codex, OpenCode

## Быстрая установка

```sh
curl -fsSL https://raw.githubusercontent.com/CodeAlive-AI/ai-driven-development/main/hooks/balanced-safety-hooks/install-prebuilt.sh | sh
```

## Связь с моим ботом

Частично пересекается с тем, что уже настроено у меня (ограничения в AGENT.md). Стоит посмотреть, нет ли готовых хуков для Obsidian-специфичных операций.
