# Phase 6 — Alerts & Notifications

> **Status:** ⬜ Pending. Requires Phase 5 complete.
> **Goal:** User-defined alerts evaluated against live data, delivered across multiple channels.

## Scope

✅ In scope: alert rule CRUD, evaluator worker, channel adapters (in-app via WebSocket, email via SendGrid, SMS via Twilio, Telegram bot, FCM push), alert history, cooldown logic, mark-read endpoints.
❌ Out of scope: AI chat (Phase 7), tests (Phase 10).

## Tasks

- [ ] **P6-T01** — Routes: `GET/POST /alerts`, `PUT/DELETE /alerts/:id`.
- [ ] **P6-T02** — Routes: `GET /alerts/history`, `PATCH /alerts/history/:id/read`, `PATCH /alerts/history/read-all`.
- [ ] **P6-T03** — `alert-evaluation.job.ts` — every 5s, fetch all active alerts, evaluate against live prices / indicators / news, respect `cooldown_minutes`, write to `alert_history`.
- [ ] **P6-T04** — Notification service interface + channel implementations:
    - `in_app` (Redis pub/sub → WebSocket)
    - `email` (SendGrid)
    - `sms` (Twilio)
    - `telegram` (Bot API)
    - `push` (FCM)
- [ ] **P6-T05** — Update `users.settings.notifications` to store channel prefs + Telegram chat id.
- [ ] **P6-T06** — Update `.env.example`: `SENDGRID_API_KEY`, `TWILIO_*`, `TELEGRAM_BOT_TOKEN`, `FCM_*`.
- [ ] **P6-T07** — Audit-log every `alert_triggered`.

## Manual Smoke-Check

1. Create alert: `price_above` `XAU/USD` `2450` with channels `[in_app, email]`.
2. Simulate price ≥ 2450 → within 5s `alert_history` has a row, in-app notification arrives on WebSocket, email is sent (or stubbed to console in dev).
3. Trigger again immediately → suppressed by cooldown.
4. `GET /alerts/history?is_read=false` shows the unread alert; `PATCH .../read` flips it.

## 🛑 Phase Gate
> *"Phase 6 complete. Proceed to Phase 7 — AI Assistant?"*
