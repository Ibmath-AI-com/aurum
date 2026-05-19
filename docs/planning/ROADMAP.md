# AURUM — Development Roadmap

> Master progression file. Each phase has its own detailed task file in this folder.
> **Rule:** finish a phase fully, get user approval, then move to the next.

---

## Phase Overview

| #   | Phase                         | Status        | File                                          |
|-----|-------------------------------|---------------|-----------------------------------------------|
| —   | **Deviations from spec**      | 📌 Reference   | [SCHEMA_DEVIATIONS.md](./SCHEMA_DEVIATIONS.md) |
| 0   | Foundation & Database         | 🟡 In Progress | [PHASE_0_FOUNDATION.md](./PHASE_0_FOUNDATION.md)                     |
| 1   | Authentication & Users        | ⬜ Pending     | [PHASE_1_AUTH_AND_USERS.md](./PHASE_1_AUTH_AND_USERS.md)             |
| 2   | Market Data Ingestion         | ⬜ Pending     | [PHASE_2_MARKET_DATA.md](./PHASE_2_MARKET_DATA.md)                   |
| 3   | Technical Analysis Engine     | ⬜ Pending     | [PHASE_3_TECHNICAL_ANALYSIS.md](./PHASE_3_TECHNICAL_ANALYSIS.md)     |
| 4   | Portfolio & Watchlists        | ⬜ Pending     | [PHASE_4_PORTFOLIO_AND_WATCHLISTS.md](./PHASE_4_PORTFOLIO_AND_WATCHLISTS.md) |
| 5   | News & Sentiment              | ⬜ Pending     | [PHASE_5_NEWS_AND_SENTIMENT.md](./PHASE_5_NEWS_AND_SENTIMENT.md)     |
| 6   | Alerts & Notifications        | ⬜ Pending     | [PHASE_6_ALERTS.md](./PHASE_6_ALERTS.md)                             |
| 7   | AI Assistant (Claude API)     | ⬜ Pending     | [PHASE_7_AI_ASSISTANT.md](./PHASE_7_AI_ASSISTANT.md)                 |
| 8   | Reports & Exports             | ⬜ Pending     | [PHASE_8_REPORTS.md](./PHASE_8_REPORTS.md)                           |
| 9   | Frontend (Web App)            | ⬜ Pending     | [PHASE_9_FRONTEND.md](./PHASE_9_FRONTEND.md)                         |
| 10  | Testing, Hardening, Deploy    | ⬜ Pending     | [PHASE_10_TESTING_AND_HARDENING.md](./PHASE_10_TESTING_AND_HARDENING.md) |

**Status legend:** ⬜ Pending · 🟡 In Progress · ✅ Complete

---

## Progression Rules

1. **One phase at a time.** Do not start Phase N+1 until Phase N is fully complete and the user has approved.
2. **Tests come in Phase 10.** Earlier phases must NOT scaffold test runners, write `.test.ts` files, or add CI test steps. Manual smoke-checks only.
3. **Definition of Done** (per phase):
   - [ ] All task checkboxes in the phase file ticked
   - [ ] `typecheck` and `lint` pass
   - [ ] Manual smoke-check at the bottom of the phase file passes
   - [ ] Git commit `chore: complete Phase N — <title>`
   - [ ] User has been asked: *"Proceed to Phase N+1?"*
4. **If blocked,** stop and ask the user — do not improvise outside the spec.

---

## High-level Phase Summaries

### Phase 0 — Foundation & Database
Repo init, monorepo setup, environment, local **Redis** via Docker, connect to the **existing remote `aurumdb`** at `15.135.254.123`, all schema migrations written and applied (with **native `PARTITION BY RANGE` instead of TimescaleDB hypertables** — see `SCHEMA_DEVIATIONS.md`), seed data for assets, basic health-check endpoint. **No tests.**

### Phase 1 — Authentication & Users
Register/login/logout, JWT access + refresh, password hashing (Argon2id), OAuth scaffold (Google, GitHub), `/me` endpoint, settings CRUD, audit logging on auth events.

### Phase 2 — Market Data Ingestion
Asset CRUD, price ingestion job (Polygon/Alpha Vantage adapter), OHLCV endpoints, WebSocket live-price gateway, heatmap & correlation endpoints, economic-calendar sync.

### Phase 3 — Technical Analysis Engine
RSI, MACD, SMA/EMA, Bollinger Bands, VWAP, ATR computation jobs, `/ta/:symbol/*` endpoints, support/resistance detection, signal aggregator.

### Phase 4 — Portfolio & Watchlists
Portfolio + holding + transaction CRUD, valuation job, P&L calculations, allocation analytics, watchlist endpoints.

### Phase 5 — News & Sentiment
News ingestion job (RSS/APIs), sentiment scoring, entity extraction, news↔asset tagging, full-text search, trending topics.

### Phase 6 — Alerts & Notifications
Alert rule CRUD, evaluation worker, channel adapters (in-app, email, SMS, Telegram, push), alert history, cooldown logic.

### Phase 7 — AI Assistant (Claude API)
Conversation + message storage, streaming responses (SSE), context injection (active asset, portfolio), confidence/source/risk scaffolding, prompt templates.

### Phase 8 — Reports & Exports
Report templates (daily summary, weekly outlook, metals deep-dive, portfolio), HTML rendering, PDF/Excel/PPTX export pipeline, S3 storage, scheduled generation.

### Phase 9 — Frontend (Web App)
React + Vite app, routing, auth flow, dashboard, market view, AI chat panel, portfolio view, alerts UI, reports UI, settings — wired to the Phase 1-8 APIs. Design follows `AURUM_Prototype__4_.html`.

### Phase 10 — Testing, Hardening, Deploy
Unit tests (Vitest), integration tests, e2e (Playwright), load testing, security audit, Dockerfiles, CI pipeline, staging deploy, production runbook.

---

*Last updated: when Phase 0 began.*
