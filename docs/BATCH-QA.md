# Batch QA — 50 papers test

Make 50 demo items. Mark some weak, 1 failed.

## Pass rules
- Top shows: `ready / needs_review / failed` (like 46/3/1).
- Check list shows ONLY weak ones.
- Retry 1 failed -> it moves to check, rest untouched.
- Export CSV: 1 row per paper, weak fixed first.

## Steps
1. Scan/import 50 (or tap demo 50x).
2. See counts.
3. Fix weak 3, retry failed 1.
4. Export. All 50 rows present.
