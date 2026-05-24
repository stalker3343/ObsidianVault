# Dev Plan: Все непоставленные задачи в «Не влезло» утреннего плана

## Задача

В секцию `Не влезло / перенести` попадают только задачи которые агент сам решил включить — вместо всех непоставленных. Нужно зафиксировать правило в промпте скилла.

## Контекст

Файл скилла: `/srv/telegram-obsidian-agent/.claude/skills/morning/SKILL.md`

Раздел «Day Plan Format», блок Rules. Текущая формулировка расплывчатая:
> "If tasks do not fit, add a final `Не влезло / перенести` section."

Агент интерпретирует это как «добавь несколько по своему усмотрению», а не «добавь все оставшиеся».

## Шаги

1. Открыть `/srv/telegram-obsidian-agent/.claude/skills/morning/SKILL.md`
2. Найти блок Rules в разделе «Day Plan Format»
3. Заменить строку:
   ```
   - If tasks do not fit, add a final `Не влезло / перенести` section.
   ```
   На:
   ```
   - ALL Singularity tasks from the brief (both overdue and today) that were not placed in any time slot MUST appear in `Не влезло / перенести`, without exception. Do not filter or curate — list every unplaced task.
   ```

## Затронутые файлы

- `/srv/telegram-obsidian-agent/.claude/skills/morning/SKILL.md` — единственное изменение

## Риски

Минимальные. Секция «Не влезло» станет длиннее при большом backlog — но это честнее чем скрывать задачи. Пользователь явно хочет видеть всё.
