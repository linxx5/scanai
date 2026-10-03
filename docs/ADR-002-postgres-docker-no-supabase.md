# ADR-002: Docker Postgres on your machine, no Supabase

Date: 2026-10-03. Status: Locked.

## Choice
- Docker holds: Postgres 16 + API (Better Auth) + MinIO files + Mailpit mail.
- Extra later with one flag: Ollama AI, OCR, Umami stats, GlitchTip crashes.
- Files use S3 code. Same code flips MinIO local -> R2 or Netlify cloud later.

## Why
- $0. Your disk is the limit. No monthly bill.
- Private. Names and IDs stay in Nigeria on your laptop.
- Works on office WiFi with no internet.
- Same SQL moves to cloud later with `pg_dump`. No rewrite.

## Not chosen
- Supabase cloud: monthly fee + data leaves Ausbildung + needs internet always.
