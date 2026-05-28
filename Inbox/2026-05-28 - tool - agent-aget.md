---
type: tool
source: https://github.com/izzzzzi/agent-aget
created: 2026-05-28
tags:
  - source/tool
  - ai
  - browser-automation
  - cli
---

# agent-aget v0.2.1

CLI для браузерных задач агентами: Codex, Claude Code, OpenCode и другими LLM-agent workflow.

## Суть

Обычные решения (Playwright, MCP-браузеры) упираются в реальные сайты с защитой. За основу взят **CloakBrowser** — stealth Chromium с source-level fingerprint patches.

## Что умеет

- Открывать страницы из CLI
- Отдавать агенту JSON вместо человеко-ориентированного help
- `aget -h` возвращает agent-friendly workflow
- Page snapshot с refs вроде `@e1`, `@i1`
- Кликать и заполнять формы через refs (не CSS-селекторы)
- Читать страницу, ждать текст/URL, скроллить, делать скриншоты
- Многошаговые сценарии через `aget batch --stdin`
- Проверка окружения: `aget doctor`

## Пример

```bash
npm i -g agent-aget

aget open https://example.com -n research
aget page snapshot -s SID
aget page click -s SID --ref @e1
aget page read -s SID --limit 80
aget session close -s SID
```

## Ссылки

- npm: https://www.npmjs.com/package/agent-aget
- GitHub: https://github.com/izzzzzi/agent-aget
