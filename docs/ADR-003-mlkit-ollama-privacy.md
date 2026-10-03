# ADR-003: ML Kit on phone + Ollama local first

Date: 2026-10-03. Status: Locked.

## Choice
1. First: ML Kit Text v2 + Scanner on the phone. Free, offline, fast.
2. Next: Docker OCR (RapidOCR + Tesseract) on office WiFi. Free, private.
3. Last: Groq fast / Gemini long text, only with clear tap + consent. Hide phone numbers first.

## Why
- 500 forms must work with no internet. Cloud cannot do that.
- Private papers stay home by default.
- Cache in Postgres: same question twice = instant, $0.

## Rule
- Guest + no tap = never call cloud.
- Sensitive (ID, money, beneficiary) = local only unless user says "use cloud anyway".
