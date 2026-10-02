# Scanai — Scan it. Understand it. Convert it. Edit it.

> “Other apps scan your documents. Scanai understands what is inside them and helps you do something with that information.”

Scanai is an AI-powered **document intelligence and smart data collection platform** for individuals, businesses, government agencies, NGOs, students and professionals. It turns paper documents, images and digital files into usable, editable, structured information.

Full spec: [`SCANAI.md`](./SCANAI.md) (PRD, v1 with offline + guest access model).

## Core promise

**Scan it. Understand it. Convert it. Edit it.**

**Transformation:** `DOCUMENTS → INFORMATION → ACTION`

## Product flows

**Individual:**
`SCAN → UNDERSTAND → REVIEW → EDIT → CONVERT → ORGANIZE → ANALYZE`

**Batch (high-volume):**
`CAPTURE → ORGANIZE → PROCESS → FLAG EXCEPTIONS → REVIEW → EXPORT`

> “Scan Once. Process Many. Review Only What Needs Your Attention.”

**Smart Forms:**
`CREATE → COLLECT → UNDERSTAND → VALIDATE → REVIEW → EXPORT → ANALYZE`

> “Create a form, collect information digitally or on paper, and let Scanai turn responses into usable data.”

## What Scanai does

- **Capture:** camera, gallery, multi-image, PDF / Word / Excel, screenshots, multi-page, edge detect, crop, perspective fix, enhance
- **Recognize:** typed + handwriting, tables, receipts, invoices, forms, signatures (detect, not verify), IDs, numbers, checkboxes, QR/barcodes
- **Understand:** document type + field extraction (name, phone, date, invoice no, total, LGA, etc.)
- **Review:** confidence-based exception review — check only what needs attention, not all 500 docs
- **Edit:** text, tables, add/move/delete elements, signatures
- **Convert:** Text, Word, Excel, CSV, PDF, Image, editable tables + reverse (Word/Excel/Image → PDF)
- **Batch:** multi-select, auto page organize, document separation, background processing, progress, retry failed, batch export
- **Smart Forms:** builder + AI draft generator, link/QR share, digital + paper-scan responses, validation, Excel/CSV export
- **AI:** summaries, Q&A over docs/batches, comparison, translation (where feasible)
- **Organize:** folders, tags, search (name, text, fields), Sign, Share, PDF tools (merge/split/compress/OCR/protect)

## Access model

**Free features: no account, online or offline.**

Install and immediately: single scan → OCR → review/edit → export (within free limits, e.g. 5 picture conversions).

**Advanced/paid: account required.**

Paid plans, over-limit / high-volume batch, cloud processing, advanced AI, sync/backup/cross-device, sharing/teams, Smart Forms publish/manage, billing.

Login wall appears only at point of need, preserves your work, and migrates guest data into your account.

## Online and offline

**Offline-capable:** launch, history, camera/import, enhance, on-device OCR, review/edit, local organize/search/save/export, local limit counting.

**Online-required:** cloud AI, sync/backup, sharing/teams, Forms publish/collect, subscriptions/billing, large cloud batches.

Local-first: offline work queues and auto-syncs on reconnect. Offline docs stay on-device until you sign in and consent to upload.

## MVP scope (Phase 1)

- Camera/import, multi-page, basic batch, enhancement
- OCR, basic handwriting, tables, forms, receipts/invoices, numbers
- Text/Word/Excel/CSV/PDF conversion
- `Scan → Understand → Review → Edit → Export`
- Guest access, offline single-scan, queue/sync foundation
- Simple Smart Forms + paper-scan + Excel/CSV export

See `SCANAI.md` §52–54 for persona MVP and roadmap (P1 Core → P2 Intelligent → P3 Business/Org → P4 Advanced Intelligence).

## Repo structure

```
scanai/
├── SCANAI.md   # Full PRD (source of truth)
├── README.md   # This file
└── .gitignore  # Do-not-commit list
```

Code (`app/`, `api/`, etc.) will be added as implementation starts and documented here.

## Getting started (docs for now)

1. Read [`SCANAI.md`](./SCANAI.md) §6 journeys and §52 MVP
2. Pick a Phase 1 slice (e.g. single scan → OCR → export offline)
3. Propose stack + data flow in a PR/issue before coding

```bash
git clone https://github.com/linxx5/scanai.git
cd scanai
```

## Success bar

- ≥70% complete first scan without account, ≤3 min to first conversion
- ≥99% of completed conversions usable; 1 failed doc never fails a batch
- Batch: track % needing review, rescan rate, review time
- AI: ≥80% positive for summary/Q&A/extraction
- Zero serious privacy/security incidents

North Star: **Successful Documents Completed per Active User.**

## Contributing

PRs/issues welcome. Keep every feature tied to: does it make document work easier, cut manual entry, save time, and strengthen `Scan → Understand → Use`?

## License

TBD — add a `LICENSE` file before public code contributions (e.g. MIT / Apache-2.0 / proprietary).
