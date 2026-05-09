---
wiki_page: log
---

# Wiki Log

## [2026-05-09] ingest | Telegram-пост «Мастера не падают с неба» — рефлексия как цикл
Источники:
- `Inbox/2026-05-09 - article - mastera-ne-padaiut-s-neba.md` (https://t.me/mastera_ne_padayut_s_neba/55)
Фокус: как работать с рефлексией — цикл инсайт→гипотеза→эксперимент→вывод; перечитывание как переосмысление.
Обновлено:
- [[topics/productivity]] — добавлен раздел «Как работать с рефлексией»
- [[insights/decisions]] — добавлено решение «Рефлексия как цикл, а не дневник»

## [2026-05-08] schema | Расширение правил LLM Wiki
Обновлено:
- [[SCHEMA]] — добавлены правила provenance, открытых вопросов, решений, query-save, lint и форматы `index.md`/`log.md`.
- [[index]] — добавлены [[topics/questions]] и [[insights/decisions]].
Создано:
- [[topics/questions]]
- [[insights/decisions]]

## [2026-05-08] ingest | Daily 2026-05-01 — 2026-05-07
Источники: `01. Daily/01-05-26.md`, `01. Daily/02-05-26.md`, `01. Daily/03-05-26.md`, `01. Daily/04-05-26.md`, `01. Daily/2026-05-05.md`, `01. Daily/2026-05-06.md`, `01. Daily/2026-05-07.md`.
Фокус: итоги вверху файлов и жирные смысловые выделения; таймкоды не переносились как отдельные факты.
Обновлено: [[entities/artyom]], [[entities/anya]], [[topics/relationships]], [[topics/health]], [[topics/productivity]], [[topics/learning]], [[topics/work-career]], [[topics/wedding]], [[topics/projects]], [[topics/finance]], [[insights/values]], [[insights/patterns]], [[index]].

## [2026-05-08] ingest | Ценности Черновик
Источник: `D:\artem-new-pc\Дедаи 2026q2\Перепрошивка ценностей и реакций\Ценности Черновик.md`.
Обновлено: [[insights/values]], [[entities/artyom]], [[topics/health]], [[topics/relationships]], [[topics/work-career]], [[topics/projects]].

## [2026-05-08] ingest | Итоги ссоры Осуждение и Поддержка
Источник: `D:\artem-new-pc\Дедаи 2026q2\Отношения с Аней\Итоги ссоры Осуждение и Поддержка.md`.
Обновлено: [[entities/anya]], [[topics/relationships]], [[topics/wedding]], [[insights/patterns]], [[insights/values]].

## [2026-05-08] ingest | Статус проектов 2026Q2
Источники:
- `99. Архив/Проекты и инсайты 2026Q2 на 08-05-2026 - Статус проектов.csv`
Фокус:
- синтез общего текущего статуса проектов по всем 4 неделям из CSV
- переносились только устойчивые статусы, блокеры и общие заметки, а не недельный raw-log
Обновлено:
- [[topics/projects]]
- [[topics/health]]
- [[topics/productivity]]
- [[topics/work-career]]
- [[topics/learning]]
- [[topics/finance]]
- [[topics/relationships]]
- [[topics/wedding]]
- [[insights/patterns]]
- [[topics/questions]]
Открытые вопросы:
- [ ] Как регулярно переводить застрявшие проекты в один физический следующий шаг?
- [ ] Как решать, какие проекты закрыть или поставить на стоп, чтобы карта проектов не раздувалась?

## [2026-05-08] init | Первое создание вики
Источники: AGENT.md, Daily 2026-04-26 — 2026-05-08.
Создано 7 страниц: profile, people, health, habits, work, learning, insights, projects, preferences.

## [2026-05-08] lint | Wiki после статусов проектов
Проверено:
- ошибочная трактовка 4-й недели
- покрытие 47 проектов из CSV в [[topics/projects]]
- распределение статусов 4-й недели
- frontmatter/updated у wiki-страниц
- wiki-ссылки
Результат:
- удалена неверная оговорка про неполный недельный срез; сводка теперь учитывает все 4 недели
- все 47 контрольных проектных направлений представлены в [[topics/projects]]
- найден и исправлен один реальный битый wikilink: имя Валентин оставлено обычным текстом в [[entities/artyom]]
- ссылки в `SCHEMA.md` с примерами не считались ошибками
- git-коммит не выполнялся
