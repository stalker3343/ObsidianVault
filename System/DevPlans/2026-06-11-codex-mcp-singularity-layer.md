---
type: dev_plan
created: 2026-06-11
tags:
  - codex
  - mcp
  - singularity
  - cc-connect
---

# Dev Plan: добавить MCP слой Singularity в Codex runtime

## Задача

Сделать так, чтобы в Codex-сессиях проекта `/srv/telegram-obsidian-agent` Singularity был доступен как нормальный MCP server/tool layer, а не только через прямой импорт `skills._singularity_agenda`.

Целевое поведение:

- при старте Codex в этом проекте поднимается локальный stdio MCP server `singularity`;
- в Codex доступны tools уровня `mcp__singularity__list_projects`, `mcp__singularity__create_task`, `mcp__singularity__get_agenda` и т.д.;
- команда пользователя «поставь задачу» идёт через MCP, как описано в `AGENT.md`;
- если MCP недоступен, остаётся явный fallback на прямой API через shared skill-модуль.

## Контекст

Сегодня при попытке поставить задачу выяснилось:

- `tool_search` не показал callable MCP tools Singularity в текущей Codex-сессии;
- файл MCP server существует: `mcp-servers/singularity-py/server.py`;
- прямой импорт сервера упал на `ModuleNotFoundError: No module named 'mcp'`;
- прямой API через `skills._singularity_agenda` работает, задача в Singularity успешно создана;
- `docker-compose.yml` уже прокидывает `SINGULARITY_ACCESS_TOKEN` в контейнер;
- `.claude/settings.json` уже содержит allow-list для `mcp__singularity__*`, но это настройки Claude runtime, не Codex;
- `.codex/config.toml` в проекте отсутствует;
- в `requirements.txt` нет зависимости `mcp`.

По актуальной документации Codex:

- Codex поддерживает MCP servers в CLI и IDE extension;
- MCP servers задаются в `~/.codex/config.toml` или project-scoped `.codex/config.toml` для trusted projects;
- stdio server описывается через `[mcp_servers.<name>]`, `command`, `args`, `env`/`env_vars`, `cwd`;
- CLI и IDE extension используют общий Codex config;
- в TUI активные MCP servers проверяются через `/mcp`.

Источники:

- https://developers.openai.com/codex/mcp
- https://developers.openai.com/codex/config-basic
- https://developers.openai.com/codex/config-advanced
- https://developers.openai.com/codex/permissions

## Предлагаемая архитектура

Сделать project-scoped конфиг:

```toml
[mcp_servers.singularity]
command = "/srv/telegram-obsidian-agent/.venv/bin/python"
args = ["/srv/telegram-obsidian-agent/mcp-servers/singularity-py/server.py"]
cwd = "/srv/telegram-obsidian-agent"
env_vars = ["SINGULARITY_ACCESS_TOKEN", "OBSIDIAN_VAULT_PATH", "TIMEZONE"]
startup_timeout_sec = 20
tool_timeout_sec = 60
enabled = true
default_tools_approval_mode = "auto"
```

Почему project-scoped:

- это поведение нужно именно этому runtime-проекту;
- секреты не хардкодятся в repo, только forward через `env_vars`;
- конфиг будет рядом с `AGENT.md`, `mcp-servers/` и skills;
- для другого Codex-проекта Singularity не будет случайно включаться.

Условие: проект должен быть trusted для Codex, иначе `.codex/config.toml` будет проигнорирован.

## Шаги

1. Добавить зависимость MCP runtime.

   Варианты:

   - добавить `mcp>=1.x` в `requirements.txt`;
   - проверить, что `pip install -r requirements.txt` ставит `mcp.server.fastmcp`;
   - если пакет или импорт изменился, адаптировать `server.py` под текущую версию MCP SDK.

2. Добавить `.codex/config.toml`.

   Минимальная версия:

   ```toml
   [mcp_servers.singularity]
   command = "/srv/telegram-obsidian-agent/.venv/bin/python"
   args = ["/srv/telegram-obsidian-agent/mcp-servers/singularity-py/server.py"]
   cwd = "/srv/telegram-obsidian-agent"
   env_vars = ["SINGULARITY_ACCESS_TOKEN", "OBSIDIAN_VAULT_PATH", "TIMEZONE"]
   startup_timeout_sec = 20
   tool_timeout_sec = 60
   enabled = true
   default_tools_approval_mode = "auto"
   ```

3. Проверить, как `cc-connect` запускает Codex.

   Нужно понять:

   - стартует ли Codex с cwd `/srv/telegram-obsidian-agent`;
   - доверяет ли Codex project-local `.codex/config.toml`;
   - не переопределяет ли `cc-connect` `CODEX_HOME`, profile или config;
   - не чистится ли environment так, что `SINGULARITY_ACCESS_TOKEN` не попадает в Codex subprocess.

4. Добавить smoke-test MCP server.

   Проверки:

   - локально: `.venv/bin/python mcp-servers/singularity-py/server.py` хотя бы стартует без `ModuleNotFoundError`;
   - в Codex TUI: `/mcp` показывает `singularity`;
   - tools/list содержит ожидаемые tools;
   - `list_projects` возвращает проекты;
   - `create_task` создаёт тестовую задачу в безопасном проекте или тестовом inbox/project.

5. Добавить тест/документацию для runtime.

   Минимум:

   - обновить `AGENT.md` или отдельный runbook с диагностикой: что делать, если MCP tools не появились;
   - добавить команду проверки зависимости: `.venv/bin/python -c "from mcp.server.fastmcp import FastMCP; print('ok')"`;
   - добавить expected behavior: если MCP отсутствует, не считать Singularity API сломанным, использовать прямой fallback.

6. Опционально: сделать отдельный CLI fallback skill.

   Например `skills/add_singularity_task.py`, чтобы при отсутствии MCP не писать inline Python в runtime.

   Интерфейс:

   ```bash
   .venv/bin/python skills/add_singularity_task.py --title "..." --project-id "..." --start YYYY-MM-DD
   ```

   Это упростит будущую эксплуатацию и позволит оставить fallback в allow-list.

## Затронутые файлы

- `requirements.txt` — добавить `mcp`.
- `.codex/config.toml` — новый project-scoped Codex MCP config.
- `mcp-servers/singularity-py/server.py` — возможно адаптировать импорт/инициализацию под актуальную версию SDK.
- `AGENT.md` — уточнить, что для Codex Singularity должен идти через MCP, а fallback через skill/CLI допустим при недоступности MCP.
- `skills/add_singularity_task.py` — опциональный fallback wrapper.
- `tests/` — опционально добавить smoke/unit test на импорт MCP server и shared API helpers.

## Риски

- Project-scoped `.codex/config.toml` не загрузится, если проект не trusted.
- `env_vars` может не передать `SINGULARITY_ACCESS_TOKEN`, если `cc-connect` запускает Codex с урезанным environment.
- Версия пакета `mcp` может не совпасть с API `FastMCP`.
- `default_tools_approval_mode = "auto"` может быть слишком широким для task-creating tools; если Codex начнёт требовать подтверждения или политика безопасности строже, нужно сделать per-tool policy.
- Тестовая задача может загрязнить реальный Singularity backlog; для smoke-test лучше использовать `list_projects` и read-only tools, а `create_task` проверять только вручную.
- `.claude/settings.json` не помогает Codex runtime: это отдельный слой настроек.

## Acceptance Criteria

- Новая Codex-сессия в `/srv/telegram-obsidian-agent` видит MCP server `singularity`.
- `/mcp` показывает server как active/connected.
- `list_projects` вызывается через MCP и возвращает список проектов.
- `create_task` через MCP создаёт задачу с корректной датой старта.
- При отсутствующем MCP есть документированный fallback без чтения секретов и без ручного inline Python.
- В `AGENT.md` не остаётся двусмысленности: для задач сначала MCP, fallback только при технической недоступности MCP.
