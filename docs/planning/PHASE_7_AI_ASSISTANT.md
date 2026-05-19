# Phase 7 — AI Assistant (Claude API)

> **Status:** ⬜ Pending. Requires Phase 6 complete.
> **Goal:** Conversational AI grounded in live market data, with confidence/source/risk scaffolding.

## Scope

✅ In scope: conversation + message storage, streaming responses (SSE), tool/function-calling for live data lookups, context injection (active asset, portfolio, watchlist), confidence indicators, source attribution, risk warnings, prompt templates.
❌ Out of scope: report generation (Phase 8), tests (Phase 10).

## Tasks

- [ ] **P7-T01** — Add Anthropic SDK to `packages/api`. Add `ANTHROPIC_API_KEY` to `.env.example`.
- [ ] **P7-T02** — Routes: `GET/POST /ai/conversations`, `DELETE /ai/conversations/:id`.
- [ ] **P7-T03** — Routes: `GET /ai/conversations/:id/messages`, `POST /ai/conversations/:id/messages` (SSE stream).
- [ ] **P7-T04** — System prompt template that enforces: confidence label, source list, risk caveats, no guaranteed predictions, contradicting-signal callout.
- [ ] **P7-T05** — Tool definitions for the model: `get_price`, `get_indicator`, `get_news`, `get_portfolio_summary`, `get_economic_calendar`.
- [ ] **P7-T06** — Tool executor that resolves each tool call against internal endpoints.
- [ ] **P7-T07** — Persist every user + assistant message with `confidence`, `sources[]`, `tokens_used`, `latency_ms`, `model_version`.
- [ ] **P7-T08** — Auto-title conversations from the first user message.
- [ ] **P7-T09** — Per-tier rate limits on AI calls (free vs pro vs enterprise).

## Manual Smoke-Check

1. Start a new conversation with: *"Why is gold rising today?"* → SSE stream emits tokens, ends with a structured response that includes a confidence label and at least one source citation.
2. `ai_messages` table has both the user message and the assistant message.
3. Follow-up: *"Compare it to silver."* → model uses prior context (gold) and calls `get_price` for both symbols.
4. Free-tier user hits AI rate limit after configured threshold.

## 🛑 Phase Gate
> *"Phase 7 complete. Proceed to Phase 8 — Reports & Exports?"*
