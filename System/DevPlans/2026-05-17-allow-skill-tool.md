# Dev Plan: разрешить Skill tool в Claude Code

## Задача
Добавить `Skill` в список разрешённых инструментов, чтобы вызовы `Skill` (в т.ч. skill `singularity`) не блокировались в режиме `don't ask`.

## Контекст
Claude Code работает в режиме `don't ask` — инструменты без явного разрешения автоматически отклоняются.
При попытке вызвать `Skill("singularity")` получена ошибка:
> "Permission to use Skill has been denied because Claude Code is running in don't ask mode."

Сами MCP-инструменты (`mcp__singularity__*`) работают — заблокирован только мета-инструмент `Skill`.
Skill `singularity` даёт агенту доп. инструкции: часовой пояс МСК (GMT+3), правила работы с API.

## Шаги

1. Открыть файл настроек проекта:
   `/srv/telegram-obsidian-agent/.claude/settings.json`

2. Найти секцию `allowedTools` (или создать её).

3. Добавить `"Skill"` в список:
   ```json
   {
     "allowedTools": ["Skill", ...]
   }
   ```

4. Сохранить файл.

5. Проверить: отправить боту любое сообщение про Singularity — в логах не должно быть ошибки про `don't ask mode`.

## Затронутые файлы
- `/srv/telegram-obsidian-agent/.claude/settings.json`

## Риски
- Низкий: `Skill` — встроенный инструмент Claude Code, не выполняет произвольный код, только загружает инструкции.
- После изменения перезапуск агента не нужен — настройки применяются на лету.
