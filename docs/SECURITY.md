# Safety rules

## Secrets
- Real `.env` never in git. Only `.env.example`.
- Keys: Better Auth, MinIO, Paystack, AI — server env only.

## Data
- Postgres: one user sees own rows (policies on).
- MinIO buckets private. Share = signed link with expiry.
- Phone: lock screen + `flutter_secure_storage` for tokens.

## Report a hole
- Open a private issue or mail owner. No public names/photos.
- Fix in 7 days, tell testers what changed.
