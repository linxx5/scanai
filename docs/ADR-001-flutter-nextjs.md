# ADR-001: Flutter (app + desktop) + thin Next.js (web)

Date: 2026-10-03. Status: Locked.

## Choice
- App + desktop: Flutter 3 + Material 3.
- Web only for links: thin Next.js (form fill, QR, landing).

## Why
- Scan needs camera + offline OCR + 500-batch on cheap phones. Flutter does this fast, free, offline.
- Next.js is best for share links + SEO. Flutter web is slow for that.
- One phone code + one small web code = less work, $0.

## Not chosen
- Expo + Next.js everywhere: weak scanner, crashes on big batches, build fees.
- Next.js alone: cannot make a real Play Store app.
