# Events — no names, no text

| Event | When | Data |
|-------|------|------|
| first_scan | 1st save on phone | device_hash only |
| first_export | 1st TXT/CSV | kind only |
| wall_shown | login wall pops | feature only |
| wall_done | user logs in | feature only |
| batch_done | batch export | counts only |
| sync_ok | queue sent | count only |
| ai_used | summary asked | mode + cached? (no text) |

## Rules
- Local Postgres `events` first. 90 days raw, then totals.
- Cloud dashboards OFF till opt-in. Never log names, phones, doc text.
