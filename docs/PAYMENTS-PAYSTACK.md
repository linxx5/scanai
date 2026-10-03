# Pay test — Paystack, $0 until you earn

1. API has `POST /pay/webhook`. Test mode: no real money.
2. Webhook checks sign, then sets plan in `entitlements` table.
3. Plans: free (5 scans) / basic / pro / business.
4. Offline? "Connect to pay" — queued wish, free scan still works.
5. Flutterwave keys stay as backup env only.

## Try
- Paystack dashboard -> test keys -> put in `infra/.env` (not git).
- Send test webhook -> check `entitlements` row changes.
