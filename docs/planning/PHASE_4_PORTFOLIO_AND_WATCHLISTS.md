# Phase 4 — Portfolio & Watchlists

> **Status:** ⬜ Pending. Requires Phase 3 complete.
> **Goal:** Users can build portfolios, log transactions, see P&L, and curate watchlists.

## Scope

✅ In scope: portfolio + holding + transaction CRUD, valuation job, P&L (realized & unrealized), allocation analytics, sector concentration, watchlist endpoints.
❌ Out of scope: alerts on portfolios (Phase 6), AI portfolio insights (Phase 7), tests (Phase 10).

## Tasks

- [ ] **P4-T01** — Routes: `GET/POST /portfolios`, `GET/PUT/DELETE /portfolios/:id`.
- [ ] **P4-T02** — Routes: `GET /portfolios/:id/holdings`, `POST /portfolios/:id/transactions`.
- [ ] **P4-T03** — `portfolio-valuation.job.ts` — every 30s recompute `current_value`, `unrealized_pnl`, `unrealized_pnl_pct` per holding using latest `live_price:{symbol}` cache.
- [ ] **P4-T04** — Service: cost-basis recalculation on every new buy/sell transaction (weighted average).
- [ ] **P4-T05** — Route: `GET /portfolios/:id/analytics` (total value, day change, allocation breakdown, sector exposure, beta vs benchmark).
- [ ] **P4-T06** — Route: `GET /portfolios/:id/performance?range=1d|1w|1m|1y|all` (historical equity curve).
- [ ] **P4-T07** — Routes: `GET/POST /watchlists`, `PUT/DELETE /watchlists/:id`.
- [ ] **P4-T08** — Routes: `POST /watchlists/:id/assets`, `DELETE /watchlists/:id/assets/:assetId`.

## Manual Smoke-Check

1. Create portfolio, add 3 transactions (2 buys + 1 sell) → holdings reflect net qty + weighted cost basis.
2. After valuation job runs, `current_value` and `unrealized_pnl` are populated.
3. `GET /portfolios/:id/analytics` returns allocation percentages summing to ~100.
4. Create a watchlist, add 5 assets, reorder, delete one → all persist.

## 🛑 Phase Gate
> *"Phase 4 complete. Proceed to Phase 5 — News & Sentiment?"*
