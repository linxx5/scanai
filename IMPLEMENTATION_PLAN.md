# Scanai — Implementation Plan (Free-First, Offline-First)

Source of truth: [`SCANAI.md`](./SCANAI.md). This file is the **build order**: what to do, in what order, with what free tools, and what file/screen/API proves it's done.

Principles: **guest-first** (no login for free), **offline-first** (local works, LAN syncs), **free-first** ($0 local), **local-first** (Docker + Postgres on your device, no Supabase), **NDPR-clean** (PII stays local by default), **PRD-tied** (every task maps to a SCANAI.md §).

> LOCKED DECISIONS (user): 1) Flutter (app+desktop) + Next.js (web). 2) SQLite inside app. 3) ML Kit Text v2 + Scanner API on app. 4) Postgres + Better Auth + MinIO locally (R2-compatible) + edge functions. 5) No Supabase. 6) Privacy order below. 7) Code-first tokens (already scaffolded). 8) Actions + Codemagic; Docker local → Netlify later. 9) Analytics local-only. 10) Better Auth + Mailpit→ZeptoMail + FCM/local. Payments: Paystack.

## Recommended stack (locked, free-first)

| Layer | Pick (free, local) | Why |
|---|---|---|
| App + Desktop | Flutter 3 + Material 3 | 1 codebase Android+iOS+Windows/macOS/Linux, best offline camera + ML Kit, $0 OSS |
| Web (forms/links only) | Next.js thin | Public form-fill `/f/:id`, QR, SEO. Same Postgres. Ships local Docker → Netlify later |
| Local DB | SQLite inside app (Drift/Isar) + files | Offline docs, queue, usage counters. Syncs to local Postgres on LAN |
| On-device AI (app) | Google ML Kit Text v2 + Document Scanner API | Free on-device OCR + edge/crop/enhance, offline, no server |
| Backend (local) | Docker + Postgres 16-alpine + Better Auth + MinIO + FastAPI edge functions | Postgres on your device ($0). Better Auth anon→link (guest migration). MinIO = R2 API locally, flip 1 env to R2 later. No Supabase. |
| OCR fallback (shared) | Docker-local RapidOCR-ONNX + Tesseract `POST /ocr` + Postgres cache | Free, private LAN, 1-2s. Both Flutter + Next.js call same endpoint. No HF Spaces prod, no ML Kit Cloud billing |
| LLM | Local Ollama (qwen2.5-7b / llama3.1-8b) primary for sensitive + Groq fast + Gemini long-context, all cached + redacted | $0 local private by default (see Privacy). Groq only for public/non-sensitive with consent. No OpenAI credits dependency |
| Privacy (order) | 1) Stay local 2) Redact before cloud 3) Classify+route 4) Contracts/settings | PII never leaves unless explicit tap + consent log; `DELETE /me` wipes `ai_cache`; lawyer review before real-PII beta |
| Design | Code-first `design/tokens.json` + `py tools/generate_themes.py` → `app/lib/theme/theme.dart` + `web/tokens.css` | $0 unlimited, offline, no Figma cap. Already scaffolded. Edit 1 JSON, run 1 command |
| CI/CD | GitHub Actions (checks, free) + Codemagic free / manual (mobile release) | Actions PR lint/test/web build; local `flutter build` $0 unlimited; Codemagic 500m free for iOS-only |
| Hosting | Docker local now → Netlify later | `docker compose up web` on LAN now; same `web/` build deploys to Netlify prod later |
| Analytics/crash | Local-only: Postgres `events` + Umami + GlitchTip in Docker | NDPR-clean Day 1, $0 unlimited. No PostHog/Sentry cloud by default (opt-in later with redaction) |
| Push/email | Better Auth + Mailpit local → ZeptoMail prod + FCM + `flutter_local_notifications` | Mailpit `localhost:8025` $0 dev; ZeptoMail for real OTPs; FCM online alerts + local offline nudges |
| Payments | Paystack (test mode free, ~1.5% on revenue) | Cards + transfer + USSD + Momo NG, webhooks → Postgres `entitlements`, Flutterwave fallback env only |

Cost guardrail: on-device first, Docker-local second, cloud only after account + explicit tap + quota. Enforce per-device + per-account quotas locally, reconcile on sync (§60–61). No Supabase bills.

---

## Phase 0 — Decisions & Repo Setup (Week 0–1)

**Goal:** no coding without ADRs and cost caps.

Tasks:
- [ ] Freeze MVP slice: single scan → on-device OCR → review/edit → local export + guest + offline queue (§52, §60–61)
- [ ] Write ADRs (see outputs)
- [ ] Set up mono-structure, branching, free CI

**Concrete outputs:**
- `docs/ADR-001-flutter-nextjs.md` (LOCKED: Flutter app+desktop + Next.js thin web, why, cost $0)
- `docs/ADR-002-postgres-docker-no-supabase.md` (LOCKED: Docker Postgres 16 + Better Auth + MinIO→R2 + FastAPI, no Supabase, backup + Netlify path)
- `docs/ADR-003-mlkit-ollama-privacy.md` (LOCKED: ML Kit on-device + Ollama local primary, redact-before-cloud, classify+route)
- `infra/docker-compose.yml` (postgres:16-alpine + api (Better Auth) + minio + ollama + umami + glitchtip + mailpit, named volume `pgdata`)
- `infra/.env.example` (POSTGRES_PASSWORD, MINIO keys, BETTER_AUTH_SECRET, PAYSTACK keys — never commit real `.env`)
- `docs/COST-MODEL.md` (free quota: 5 conversions, $0 local, Paystack rev-share only on paid)
- `/.github/workflows/ci.yml` (flutter analyze + test, free minutes only)
- `app/` skeleton builds to APK in CI

**Done when:** `docker compose up -d` green on your laptop, ADRs merged, `COST-MODEL.md` caps approved.

Free tools: GitHub Free, Docker Desktop (free personal) + Postgres 16 + MinIO + Ollama images (free OSS). No Figma, no Supabase.

## Phase 1 — Design System (Week 1) — code-first, DONE scaffolded

**Goal:** task-focused UI, offline/guest states first (§39–41, §44–45). No Figma.

Tasks:
- [x] `design/tokens.json` ONE file (already created) — primary/surface/error/warning + ✓/⚠️/✕ states
- [x] `py tools/generate_themes.py` → `app/lib/theme/theme.dart` + `web/tokens.css` (already generates)
- [ ] Components in code only: capture button, doc card, batch row, confidence chip, upgrade wall, offline banner, empty/error states
- [ ] Accessibility: 4.5:1 contrast, 44px targets, screen-reader labels

**Concrete outputs:**
- `design/tokens.json`, `tools/generate_themes.py`, `app/lib/theme/theme.dart`, `web/tokens.css` (done)
- `docs/UX-COPY.md` (offline strings, quota strings, error strings per §45)

**Done when:** edit 1 hex → run 1 command → app+web update; 1 user completes first scan ≤3 min, no login.

Free tools: $0, offline, no accounts. Excalidraw quick sketches only if needed.

## Phase 2 — App Shell + Local-First Data + Guest Model (Week 2–3)

**Goal:** app launches offline, guest works, no backend needed (§42, §60–61).

Tasks:
- [ ] Flutter shell: Home (Scan/Import/Forms/Docs/Sign/AI), `My Documents`, `Scan History`, Settings (Wi-Fi-only, clear cache, delete local)
- [ ] Local schema: `documents`, `pages`, `extractions`, `queue`, `usage_counters` (Isar/Drift)
- [ ] Guest logic: UUID per install, free counter locally, no auth call
- [ ] Offline banner + `Online/Offline/Syncing/Failed` states (connectivity_plus, free)

**Concrete outputs:**
- `app/lib/features/home/`, `app/lib/data/local/` (models + DAOs)
- `app/lib/core/connectivity/` (status stream + banner widget)
- E2E (free, integration_test): launch airplane-mode → scan sample → history shows doc
- `docs/DATA-MODEL-LOCAL.md` (ER diagram as Mermaid)

**Done when:** airplane-mode launch → import 1 image → saved locally + counter = 1.

## Phase 3 — Scan & On-Device Intelligence (Week 3–5)

**Goal:** `SCAN → UNDERSTAND` offline (§13–16, §33, §40, §46).

Tasks:
- [ ] Camera (camera pkg, free) + gallery/file picker + multi-page (reorder/add/remove)
- [ ] ML Kit Document Scanner / edge detect + crop/perspective/enhance (brightness/contrast/shadow)
- [ ] ML Kit Text Recognition v2: typed + basic handwriting + numbers; language auto-detect + manual fallback
- [ ] Smart Scan classifier (rule-based first, free): receipt → receipt flow, table → Excel, form → form flow
- [ ] Preserve originals; failed page never fails doc

**Concrete outputs:**
- `app/lib/features/scan/` (capture, enhance, multipage widgets)
- `app/lib/features/understand/` (ocr_service.dart, classify_service.dart with unit tests on 20 sample docs)
- `assets/samples/` (5 typed, 5 handwritten, 5 receipts, 5 tables — MIT-licensed)
- Accuracy log: `docs/RECOGNITION-BENCH.md` (printed vs handwriting vs numbers)

**Done when:** 20 samples: printed ≥95% char accuracy, handwriting best-effort + low-confidence flagged.

Free tools: ML Kit (free), sample docs (free), on-device only — $0 cloud.

## Phase 4 — Review / Edit / Convert / Organize — Local Only (Week 5–6)

**Goal:** `REVIEW → EDIT → CONVERT → ORGANIZE` without account (§17–18, §20–21, §23–25, §34–36).

Tasks:
- [ ] Exception review UI: field list with ✓/⚠️, tap-to-correct, approve/reject
- [ ] Editor: text, table cells/rows/cols, add image, signatures (draw/type)
- [ ] Local export: TXT/CSV/Image always; PDF via pdf pkg (free); Word/Excel via minimal XML gen (free, no paid SDK) — layout best-effort
- [ ] Organize: folders/tags, local full-text search, smart naming (`INV-2045_2026-10-02`)

**Concrete outputs:**
- `app/lib/features/review/`, `editor/`, `export/`, `organize/`
- `docs/EXPORT-MATRIX.md` (what preserves layout offline vs needs cloud)
- Test: edit 1 field → export Excel → re-open values match

**Done when:** guest offline completes Scan → Export to device in ≤3 min.

## Phase 5 — Local Backend + Account Gate + Sync (Week 6–8) — Docker + Postgres

**Goal:** paid/advanced requires account; guest migrates; SQLite ↔ local Postgres syncs on your device (§42, §47–48, §60.4). No cloud yet.

Tasks:
- [ ] Docker Compose up: `postgres:16-alpine` + API (FastAPI + Better Auth, free) + MinIO buckets `originals/`, `exports/` (free, R2-compatible)
- [ ] Local Auth: Better Auth email + guest UUID → link on upgrade. No Supabase, ever. Same Postgres schema if you later add managed Postgres.
- [ ] Upgrade wall trigger map (§61.4): Batch>limit, AI, Sync, Publish Form → wall → after login return to pending action
- [ ] Sync engine: SQLite-first, auto-queue, retry/cancel, delta push to `localhost:5432`, reconcile `usage_counters` (prevent double free quota)
- [ ] Quota: SQL function `check_quota()` in Postgres (free device + account), paywall copy
- [ ] Payments: Paystack test mode → webhook `/pay/webhook` → `entitlements` table (plan, quota_docs, quota_ai). Flutterwave keys as env fallback only.

**Concrete outputs:**
- `infra/docker-compose.yml` running, `infra/postgres/migrations/*.sql`, `infra/minio/` buckets
- `app/lib/features/auth/` (guest→account migration), `app/lib/core/sync/` (queue, worker, UI)
- `docs/SYNC-RULES.md` + test: offline 3 docs → LAN/online → 3 in Postgres, counter merged
- Security: Postgres per-user RLS/policies on, MinIO private by default, `.env` never committed

**Done when:** guest with 2 local docs signs in locally → docs in Postgres + MinIO, quota = max(local, server), not sum.

Free/local: $0 — limits = your disk. Backup: `docker exec pg_dump > backup.sql`. Cloud move later = `pg_dump | psql $CLOUD_URL`, no rewrite.

## Phase 6 — Batch + Exception Review (Week 8–10)

**Goal:** `Scan Once. Process Many.` (§19–20, high-volume journey).

Tasks:
- [ ] Batch capture (multi-pick, batch camera), auto page-group + doc separation (heuristic first, free)
- [ ] On-device batch queue with progress; local-Postgres batch job only if account + on LAN (later: cloud queue with same SQL)
- [ ] Dashboard: `486 Ready / 11 Need Review / 3 Failed` pattern; retry/rescan single without failing batch
- [ ] Batch export: combined Excel/CSV + ZIP of PDFs (account-gated if over free)

**Concrete outputs:**
- `app/lib/features/batch/` + `infra/postgres/jobs/batch_process.sql` (stub, on-device first)
- `docs/BATCH-QA.md` (300-doc synthetic test: completion %, review time)
- Metric events: `batch_started/completed/exception_reviewed/exported`

**Done when:** 50-doc batch: 1 failure doesn't block 49; review list shows only low-confidence.

## Phase 7 — Smart Forms MVP (Week 10–12)

**Goal:** Create → Collect (digital + paper) → Validate → Export (§27–28).

Tasks:
- [ ] Builder: short/long text, number, MCQ, checkbox, dropdown, date, photo, signature, GPS, Yes/No, required, preview
- [ ] Share: link + QR (qr_flutter, free); digital submit (no login for respondent); paper: print → batch scan → field map
- [ ] Validation: missing/invalid phone/date/age/duplicates → flag, never silently fix
- [ ] Response table + Excel/CSV export (account required to publish)

**Concrete outputs:**
- `app/lib/features/forms/builder/`, `web/forms/` (run locally via Docker first, same build ships to Netlify later) for public fill
- `infra/postgres/migrations/*forms*.sql`
- E2E: create 5-Q form → 10 digital + 5 paper scans → export 15 rows

**Done when:** paper form scanned → fields mapped ≥90% on typed, flagged if handwritten low-conf.

Scope guard: NOT a Google Forms clone (§27).

## Phase 8 — Local-First AI (Gated, Metered) (Week 12–14)

**Goal:** Ask AI, summaries, comparison, translation — account + LAN/online only (§29–32). Local models first, cloud credits only if needed.

Tasks:
- [ ] Local proxy `ai_proxy` (FastAPI in Docker) with per-user monthly cap + Postgres `ai_cache` table. Default Ollama local (qwen2.5-7b / llama3.1-8b) for sensitive; Groq fast for public + Gemini long-context only with consent + redaction (strip phones/IDs → re-insert locally)
- [ ] Prompts versioned in `ai/prompts/*.md`; single-doc first, batch-Q&A later
- [ ] Comparison diff UI; translation with explicit language pick + offline label if unavailable

**Concrete outputs:**
- `infra/api/ai_proxy/` (redact → route: local vs Groq vs Gemini → cache), `ai/prompts/summarize.md`, `qa.md`, `extract.md`
- `docs/AI-COST.md` ($0 local baseline, Groq/Gemini caps for Basic/Pro/Business, 30-day log max, DELETE /me wipes cache)
- Eval: 20 docs, ≥80% positive (thumbs up log)

**Done when:** sensitive doc stays local; free guest tapping AI gets wall; consented public doc gets Groq summary with usage logged.

Free-first: Ollama $0 local primary; Groq/Gemini metered, account-only, redacted.

## Phase 9 — Hardening → Beta → Release (Week 14–16)

**Goal:** trust, metrics, store-ready (§43–45, §55–57).

Tasks:
- [ ] Privacy: local encryption (flutter_secure_storage free), app lock, Postgres RLS/policies + MinIO private, delete-everywhere + export-my-data
- [ ] Testing: unit (OCR, quota, sync merge) + integration (offline→local-Postgres) + 3-device manual (low-end Android priority for NG/Africa)
- [ ] Observability (local-only): Postgres `events` table + Umami + GlitchTip in Docker (`first_scan`, `first_export`, `wall_shown/converted`, `sync_success`). No PostHog/Sentry cloud by default.
- [ ] Push/email: Better Auth + Mailpit `localhost:8025` dev → ZeptoMail prod OTPs + FCM online + `flutter_local_notifications` offline
- [ ] Release: signed AAB/APK via Actions, Play Internal track; `PRIVACY.md`, `TERMS.md`, `SECURITY.md`
- [ ] Cost drill: $0 local Docker during beta (≤100 testers); Netlify + ZeptoMail + Paystack live only after approval

**Concrete outputs:**
- `docs/PRIVACY.md`, `SECURITY.md`, `ANALYTICS-EVENTS.md`
- `app/test/` coverage ≥60% on ocr/quota/sync
- Beta build links + `docs/BETA-FEEDBACK.md` (time-saved question: “Did Scanai save time vs manual?”)

**Done when:** 70% first-scan, 60% first-export, 99% conversions usable, 0 critical leaks in secret scan.

---

## Build order summary (what to demo each Friday)

1. Wk1: tokens.json + theme.dart + tokens.css (done, no login, offline banner in code)
2. Wk3: Offline shell + history (airplane-mode demo)
3. Wk5: Offline scan→ML Kit OCR on 20 samples
4. Wk6: Offline edit→Excel export
5. Wk8: Better Auth sign-in → Postgres sync + quota merge + Paystack test webhook
6. Wk10: 50-doc batch, review-only-exceptions
7. Wk12: Form create → 15 responses → Excel (Docker web → Netlify)
8. Wk14: Ollama local AI + Groq redacted path, gated + metered
9. Wk16: Beta build + local Umami/GlitchTip dashboard

## What NOT to build in MVP

Teams/org workspaces, workflow automation, full offline batch AI, background cloud at scale, full Google Forms parity, signature authenticity verification.

## Next action

Approve stack (LOCKED above) → start Phase 0 compose. `design/tokens.json` already done. If approved, I scaffold `infra/docker-compose.yml` (Postgres + Better Auth API + MinIO + Ollama + OCR + Umami + GlitchTip + Mailpit) next.
