# Scanai infra (local, $0) — start here
# No Supabase. Postgres + Better Auth API + MinIO(R2 API) + Mailpit default.
# AI (ollama+ocr) + observability (umami+glitchtip+redis) are opt-in profiles.

## Prereqs
- Docker Desktop (free personal) running
- Copy env: `cp infra/.env.example infra/.env` (bash) then edit passwords (32 chars)

## Run (light, laptop-safe)
```
cd infra
docker compose up -d
docker compose ps
curl http://localhost:3001/health
```
MinIO console: http://localhost:9001 | Mailpit: http://localhost:8025

## Full (AI + dashboards)
```
docker compose --profile ai --profile observability up -d
docker exec scanai-ollama-1 ollama pull qwen2.5:7b
```

## Buckets
`minio-init` creates private `originals/` + `exports/` (R2-compatible API).
Later R2 = same S3 code, flip `S3_ENDPOINT` to `$R2_ENDPOINT`.

## Backup / move to cloud later
```
docker exec scanai-postgres-1 pg_dump -U scanai scanai > backup.sql
# restore: psql $CLOUD_URL < backup.sql
```

## Tables
See `postgres/init/001_init.sql`: users, documents, usage_counters, events, ai_cache, entitlements, forms.
