# Phase 2 — Market Data Ingestion

> **Status:** ⬜ Pending. Requires Phase 1 complete.
> **Goal:** Ingest live + historical market data and serve it via REST + WebSocket.

## Scope

✅ In scope: asset CRUD/listing, OHLCV endpoints, live WebSocket gateway, heatmap, correlation matrix, economic-calendar sync, ETF flow ingestion.
❌ Out of scope: technical indicator computation (Phase 3), news (Phase 5), tests (Phase 10).

## Tasks

- [ ] **P2-T01** — Provider adapter interface (`MarketDataProvider`) + Polygon implementation + Alpha Vantage fallback.
- [ ] **P2-T02** — `price-ingestion.job.ts` (BullMQ, runs every 1-3s, writes to `price_data`).
- [ ] **P2-T03** — `etf-flow-ingestion.job.ts` (daily 18:00 UTC).
- [ ] **P2-T04** — `econ-calendar-sync.job.ts` (daily 06:00 UTC).
- [ ] **P2-T05** — Routes: `GET /market/assets`, `GET /market/assets/:symbol`.
- [ ] **P2-T06** — Route: `GET /market/prices/:symbol?timeframe=1d&from=...&to=...`.
- [ ] **P2-T07** — Route: `GET /market/heatmap` (asset_class filter).
- [ ] **P2-T08** — Route: `GET /market/correlation?symbols=...`.
- [ ] **P2-T09** — Route: `GET /market/economic-calendar`.
- [ ] **P2-T10** — Route: `GET /market/etf-flows/:symbol`.
- [ ] **P2-T11** — WebSocket gateway at `/market/prices/live` — subscribe by symbol, push from Redis pub/sub `live_price:{symbol}` key.
- [ ] **P2-T12** — Cache layer: 5-second TTL on `live_price:{symbol}` Redis keys.
- [ ] **P2-T13** — Update `.env.example` with `POLYGON_API_KEY`, `ALPHA_VANTAGE_API_KEY`.

## Manual Smoke-Check

1. `GET /market/assets` returns the seeded list.
2. Run ingestion for 1 minute → `price_data` accumulates rows for `XAU/USD`.
3. `GET /market/prices/XAU/USD?timeframe=1m` returns candles.
4. Connect WebSocket → receive live ticks within ~3 seconds.
5. `GET /market/heatmap` returns % changes for all assets.

## 🛑 Phase Gate
> *"Phase 2 complete. Proceed to Phase 3 — Technical Analysis Engine?"*
