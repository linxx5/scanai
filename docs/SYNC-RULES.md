# Sync rules — phone first, Docker second

1. Phone copy wins until server says "saved".
2. Send oldest first. Show count: "Sending 3…".
3. Fail 1? Keep it, tries + 1, move to next. Never block batch.
4. Free count merge: use max(phone, server). Never add them.
5. Guest logs in? Move 2 local papers to account, keep edits.
6. `.env` never in git. Backup: `pg_dump > backup.sql`.
