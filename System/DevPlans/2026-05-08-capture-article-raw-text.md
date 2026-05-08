---
type: dev-plan
feature: capture_article_raw_text
created: 2026-05-08
status: ready
tags:
  - bot
  - dev
---

# Dev Plan: патч capture_article.py — поддержка raw text/markdown URL

## Проблема

`capture_article.py` использует `trafilatura` для извлечения текста. Trafilatura заточен под HTML — при запросе raw `.md` или `.txt` файла (например gist, GitHub raw, pastebin) возвращает `None`, скилл выдаёт `needs_manual_extraction`.

## Решение

Перед вызовом trafilatura проверять `Content-Type` ответа. Если `text/plain` — брать `response.text` напрямую, минуя trafilatura. Заголовок брать из последнего сегмента URL.

## Diff

**Файл:** `skills/capture_article.py`

```diff
 def capture_article(url: str, comment: str = "") -> dict:
     requests, trafilatura, slugify = _import_runtime_deps()
     clean_url = _validate_url(url)
     now = get_now()
     today = now.strftime("%Y-%m-%d")
     created = now.isoformat(timespec="seconds")

-    raw_html = None
+    raw_html = None
+    plain_text = None
     try:
-        raw_html = trafilatura.fetch_url(clean_url)
-        extracted = trafilatura.extract(raw_html, include_comments=False, favor_recall=True) if raw_html else None
-        if not extracted or len(extracted.strip()) < MIN_TEXT_LEN:
-            response = requests.get(clean_url, timeout=15)
-            response.raise_for_status()
-            raw_html = response.text
-            extracted = trafilatura.extract(raw_html, include_comments=False, favor_recall=True)
+        response = requests.get(clean_url, timeout=15)
+        response.raise_for_status()
+        content_type = response.headers.get("Content-Type", "")
+        if "text/plain" in content_type:
+            plain_text = response.text.strip()
+            extracted = plain_text
+        else:
+            raw_html = response.text
+            extracted = trafilatura.extract(raw_html, include_comments=False, favor_recall=True)
+            if not extracted or len(extracted.strip()) < MIN_TEXT_LEN:
+                fetched = trafilatura.fetch_url(clean_url)
+                if fetched:
+                    extracted = trafilatura.extract(fetched, include_comments=False, favor_recall=True)
     except Exception as exc:
         raise RuntimeError(f"network_error: {exc}") from exc

-    title = _title_from_html(raw_html, "Unknown")
+    if plain_text is not None:
+        # Для plain text берём имя файла из URL как заголовок
+        url_path = urlparse(clean_url).path
+        fallback_title = url_path.rstrip("/").split("/")[-1] or "Unknown"
+        title = fallback_title
+    else:
+        title = _title_from_html(raw_html, "Unknown")
     text = (extracted or "").strip()
     extraction_status = "ok" if len(text) >= MIN_TEXT_LEN else "needs_manual_extraction"
```

## Затронутые строки

`capture_article.py`, функция `capture_article()`, строки 125–139. Всё остальное (slug, запись файла, git commit) — без изменений.

## Тест после патча

```sh
.venv/bin/python skills/capture_article.py \
  --url "https://gist.githubusercontent.com/karpathy/442a6bf555914893e9891c11519de94f/raw/ac46de1ad27f92b28ac95459c782c07f6b8c964a/llm-wiki.md"
# Ожидаем: extraction_status: "ok", title: "llm-wiki.md"
```
