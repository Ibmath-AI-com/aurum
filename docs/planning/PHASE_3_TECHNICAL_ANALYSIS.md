# Phase 3 — Technical Analysis Engine

> **Status:** ⬜ Pending. Requires Phase 2 complete.
> **Goal:** Compute and serve technical indicators with AI-friendly interpretation tags.

## Scope

✅ In scope: RSI, MACD, SMA, EMA, Bollinger Bands, VWAP, ATR, Fibonacci levels, support/resistance, divergence detection, signal aggregator.
❌ Out of scope: AI explanations (Phase 7), tests (Phase 10).

## Tasks

- [ ] **P3-T01** — Indicator library in `packages/common/src/indicators/` (pure functions, no DB).
- [ ] **P3-T02** — `indicator-calc.job.ts` — recompute every 60s for active assets/timeframes, write to `indicator_data` with `interpretation` (`bullish`/`bearish`/`neutral`).
- [ ] **P3-T03** — Support/resistance detector (pivot-point + swing-high/low).
- [ ] **P3-T04** — Divergence detector (price vs RSI/MACD).
- [ ] **P3-T05** — Signal aggregator that returns `{bullish_count, bearish_count, neutral_count, top_signals[]}`.
- [ ] **P3-T06** — Route: `GET /ta/:symbol/indicators?timeframe=...`.
- [ ] **P3-T07** — Route: `GET /ta/:symbol/indicators/:name`.
- [ ] **P3-T08** — Route: `GET /ta/:symbol/levels`.
- [ ] **P3-T09** — Route: `GET /ta/:symbol/signals`.
- [ ] **P3-T10** — Cache: `cache:indicators:{asset_id}:{timeframe}` Redis key, 60s TTL.

## Manual Smoke-Check

1. After 5 min of ingestion + indicator job runs, `indicator_data` has RSI/MACD/SMA rows for `XAU/USD`.
2. `GET /ta/XAU/USD/indicators` returns at least 6 indicators with `value` and `interpretation`.
3. `GET /ta/XAU/USD/signals` returns counts that sum to the total indicator count.

## 🛑 Phase Gate
> *"Phase 3 complete. Proceed to Phase 4 — Portfolio & Watchlists?"*
