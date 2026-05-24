# Патч: skills/morning_init.py

**Файл:** `skills/morning_init.py` (новый)
**Дата:** 2026-05-24
**DevPlan:** [[2026-05-23-morning-init-and-day-plan]]

Создать файл `/srv/telegram-obsidian-agent/skills/morning_init.py` с содержимым ниже.

После создания добавить в `.claude/settings.json` в allowedTools:
```json
"Bash(python skills/morning_init.py)"
```

И обновить AGENT.md (секции Календарь + Задачи Singularity на старте + Wiki):
```
На старте: `.venv/bin/python skills/morning_init.py` → прочитай `System/Today/morning-brief.md` + вызови `singularity.dump_agenda_to_vault()` → прочитай путь из поля `path`
```

---

```python
"""
morning_init.py — собирает утренний бриф в System/Today/morning-brief.md.

Запускать на старте разговора вместо отдельных скриптов.
Singularity dump вызывается агентом отдельно (MCP недоступен из скрипта).
"""

import json
import subprocess
import sys
import time
from datetime import date, timedelta
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from skills._common import (
    VAULT_ROOT,
    get_now,
    git_atomic_commit,
    log_skill,
    safe_join,
    skill_output,
)

BRIEF_PATH = ("System", "Today", "morning-brief.md")
DAILY_DIR = "Daily"
DEVPLANS_DIR = ("System", "DevPlans")
MAX_DAILY_LINES = 60

WEEKDAYS_RU = ["понедельник", "вторник", "среда", "четверг", "пятница", "суббота", "воскресенье"]
SKILLS_DIR = Path(__file__).parent


def _run_skill(script: str, args: list[str] | None = None) -> dict:
    cmd = [sys.executable, str(SKILLS_DIR / script)] + (args or [])
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=40)
    try:
        return json.loads(result.stdout)
    except Exception:
        return {"ok": False, "error": result.stderr.strip() or "no output"}


def _read_schedule_today_tomorrow(vault_root: Path) -> str:
    path = safe_join(vault_root, "System", "Today", "schedule.md")
    if not path.exists():
        return ""
    lines = path.read_text(encoding="utf-8").splitlines()
    result: list[str] = []
    capturing = False
    sections_captured = 0
    for line in lines:
        if line.startswith("## Сегодня") or line.startswith("## Завтра"):
            capturing = True
            sections_captured += 1
            result.append(line)
            continue
        if line.startswith("## ") and capturing:
            if sections_captured >= 2:
                break
            capturing = True
            sections_captured += 1
            result.append(line)
            continue
        if capturing:
            result.append(line)
    return "\n".join(result).strip()


def _read_yesterday_capture(vault_root: Path, today: date) -> str:
    yesterday = today - timedelta(days=1)
    path = vault_root / DAILY_DIR / f"{yesterday.isoformat()}.md"
    if not path.exists():
        return ""
    lines = path.read_text(encoding="utf-8").splitlines()
    capture_start = None
    for i, line in enumerate(lines):
        if line.strip().startswith("## Capture"):
            capture_start = i + 1
            break
    if capture_start is None:
        return "\n".join(lines[:MAX_DAILY_LINES])
    result: list[str] = []
    for line in lines[capture_start:]:
        if line.startswith("## ") and result:
            break
        result.append(line)
    return "\n".join(result[:MAX_DAILY_LINES]).strip()


def _read_open_devplans(vault_root: Path) -> list[str]:
    devplans_dir = safe_join(vault_root, *DEVPLANS_DIR)
    if not devplans_dir.exists():
        return []
    plans: list[str] = []
    for md_file in sorted(devplans_dir.glob("*.md"), reverse=True)[:30]:
        content = md_file.read_text(encoding="utf-8")
        for line in content.splitlines()[:12]:
            lower = line.lower()
            if "status:" in lower:
                if any(s in lower for s in ["todo", "in-progress", "in progress"]):
                    title = md_file.stem
                    for l in content.splitlines():
                        if l.startswith("# "):
                            title = l[2:].strip()
                            break
                    plans.append(f"- [[{md_file.stem}]] — {title}")
                break
    return plans


def _strip_frontmatter(content: str) -> str:
    lines = content.splitlines()
    if not lines or lines[0].strip() != "---":
        return content
    end = next((i for i in range(1, len(lines)) if lines[i].strip() == "---"), None)
    if end is None:
        return content
    return "\n".join(lines[end + 1:]).strip()


def _build_brief(
    today: date,
    focus_content: str,
    schedule_snippet: str,
    yesterday_content: str,
    devplans: list[str],
) -> str:
    weekday = WEEKDAYS_RU[today.weekday()]
    lines = [
        "---",
        f"date: {today.isoformat()}",
        f"generated: {get_now().isoformat()}",
        "---",
        "",
        f"# Бриф на {today.isoformat()} ({weekday})",
        "",
        "---",
        "",
        "## Фокус недели",
        "",
        _strip_frontmatter(focus_content) if focus_content else "_Файл фокуса недели не найден._",
        "",
        "---",
        "",
        "## Расписание (сегодня и завтра)",
        "",
        schedule_snippet if schedule_snippet else "_Расписание не загружено._",
        "",
        "---",
        "",
        "## Вчера (выжимка capture)",
        "",
        yesterday_content if yesterday_content.strip() else "_Вчерашних записей нет._",
        "",
        "---",
        "",
        "## Открытые DevPlans",
        "",
    ]
    lines += devplans if devplans else ["_Нет открытых планов._"]
    lines.append("")
    return "\n".join(lines)


def main() -> None:
    t0 = time.monotonic()
    today = get_now().date()
    errors: list[str] = []

    # 1. Обновить календарь
    cal_result = _run_skill("fetch_calendar.py", ["--current-window"])
    if not cal_result.get("ok"):
        errors.append(f"calendar: {cal_result.get('message') or cal_result.get('error')}")

    # 2. Получить фокус недели
    focus_content = ""
    focus_result = _run_skill("fetch_weekly_focus.py")
    if focus_result.get("ok"):
        focus_content = focus_result.get("content", "")
    else:
        errors.append(f"weekly_focus: {focus_result.get('message') or focus_result.get('error')}")

    # 3. Расписание на сегодня/завтра
    schedule_snippet = _read_schedule_today_tomorrow(VAULT_ROOT)

    # 4. Вчерашний Daily (capture)
    yesterday_content = ""
    try:
        yesterday_content = _read_yesterday_capture(VAULT_ROOT, today)
    except Exception as e:
        errors.append(f"yesterday: {e}")

    # 5. Открытые DevPlans
    devplans: list[str] = []
    try:
        devplans = _read_open_devplans(VAULT_ROOT)
    except Exception as e:
        errors.append(f"devplans: {e}")

    # 6. Собрать и сохранить бриф
    brief = _build_brief(today, focus_content, schedule_snippet, yesterday_content, devplans)
    brief_path = safe_join(VAULT_ROOT, *BRIEF_PATH)
    brief_path.parent.mkdir(parents=True, exist_ok=True)

    if brief_path.exists() and brief_path.read_text(encoding="utf-8") == brief:
        latency_ms = int((time.monotonic() - t0) * 1000)
        log_skill("morning_init", {"date": today.isoformat()}, ok=True, latency_ms=latency_ms, idempotent=True)
        skill_output(True, path="System/Today/morning-brief.md", commit=None, idempotent=True, errors=errors)
        return

    brief_path.write_text(brief, encoding="utf-8", newline="\n")

    commit = None
    try:
        commit = git_atomic_commit(VAULT_ROOT, [brief_path], f"bot: morning brief {today.isoformat()}")
    except Exception as e:
        errors.append(f"git: {e}")

    latency_ms = int((time.monotonic() - t0) * 1000)
    log_skill("morning_init", {"date": today.isoformat()}, ok=True, latency_ms=latency_ms, commit=commit)
    skill_output(True, path="System/Today/morning-brief.md", commit=commit, errors=errors)


if __name__ == "__main__":
    main()
```
