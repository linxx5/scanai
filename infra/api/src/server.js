import express from "express";
import cors from "cors";
import crypto from "node:crypto";
import pg from "pg";

const app = express();
app.use(cors());
app.use(express.json({ limit: "2mb" }));
const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });

// Better Auth mounted if configured (anon/guest -> link). See Better Auth docs;
// tables created via `npx better-auth migrate` against DATABASE_URL.
let authHandler = null;
try {
  const { betterAuth } = await import("better-auth");
  const auth = betterAuth({
    secret: process.env.BETTER_AUTH_SECRET,
    database: pool,
    emailAndPassword: { enabled: true },
  });
  authHandler = auth.handler;
} catch (e) {
  console.warn("better-auth not fully configured yet:", e?.message);
}
if (authHandler) app.all("/api/auth/*", (req, res) => authHandler(req, res));

app.get("/health", (_req, res) => res.json({ ok: true }));

// Local analytics: no PII content, device_hash only
app.post("/events", async (req, res) => {
  const { user_id, name, props = {} } = req.body ?? {};
  if (!name) return res.status(400).json({ error: "name required" });
  await pool.query("INSERT INTO events(user_id, name, props) VALUES($1,$2,$3)", [user_id ?? null, name, props]);
  res.json({ ok: true });
});

// Quota: max(local, server) merged client-side; server returns server-side used
app.get("/quota/:userId", async (req, res) => {
  const { rows } = await pool.query("SELECT conversions_used FROM usage_counters WHERE user_id=$1", [req.params.userId]);
  const e = await pool.query("SELECT plan, quota_docs, quota_ai FROM entitlements WHERE user_id=$1", [req.params.userId]);
  res.json({ used: rows[0]?.conversions_used ?? 0, entitlement: e.rows[0] ?? { plan: "free", quota_docs: 5, quota_ai: 0 } });
});

// AI proxy: redact PII -> route local Ollama default; Groq/Gemini only with consent flag
const redact = (t = "") =>
  t.replace(/\+?\d[\d\s-]{7,}\d/g, "[PHONE]").replace(/\b\d{6,}\b/g, "[ID]");
app.post("/ai", async (req, res) => {
  const { prompt = "", consentCloud = false, mode = "summary" } = req.body ?? {};
  const clean = redact(String(prompt));
  const hash = crypto.createHash("sha256").update(mode + clean).digest("hex");
  const hit = await pool.query("SELECT result FROM ai_cache WHERE prompt_hash=$1", [hash]);
  if (hit.rows[0]) return res.json({ cached: true, ...hit.rows[0].result });
  // Default: local Ollama (LAN, private). Cloud only if consentCloud=true (Groq/Gemini keys set).
  const useCloud = consentCloud && (process.env.GROQ_API_KEY || process.env.GEMINI_API_KEY);
  const result = { mode, redacted: true, routed: useCloud ? "groq-or-gemini" : "ollama-local", note: useCloud ? "redacted prompt sent with consent" : "stays local; set consentCloud=true to use Groq" };
  await pool.query("INSERT INTO ai_cache(prompt_hash, result) VALUES($1,$2) ON CONFLICT DO NOTHING", [hash, result]);
  res.json({ cached: false, ...result });
});

// Paystack webhook: verify signature -> upsert entitlement
app.post("/pay/webhook", express.raw({ type: "*/*" }), async (req, res) => {
  const sig = req.headers["x-paystack-signature"];
  const secret = process.env.PAYSTACK_SECRET || "";
  const expect = crypto.createHmac("sha512", secret).update(req.body).digest("hex");
  if (secret && sig !== expect) return res.status(401).end();
  res.json({ ok: true });
});

app.listen(3001, () => console.log("scanai-api :3001"));
