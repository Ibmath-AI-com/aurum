# Phase 5 — News & Sentiment

> **Status:** ⬜ Pending. Requires Phase 4 complete.
> **Goal:** Continuously ingest financial news, score sentiment, tag to assets, and serve a searchable feed.

## Scope

✅ In scope: RSS / API news ingestion, dedup, sentiment scoring, entity extraction, asset tagging, trending topics, full-text search (Postgres FTS + optional Elasticsearch), AI summary generation.
❌ Out of scope: alerts based on news (Phase 6), AI chat (Phase 7), tests (Phase 10).

## Tasks

- [ ] **P5-T01** — Add Elasticsearch service to `docker-compose.yml`.
- [ ] **P5-T02** — News provider adapter interface + Reuters/Bloomberg/Kitco/RSS implementations.
- [ ] **P5-T03** — `news-ingestion.job.ts` (every 5 min). Dedup by `external_id`.
- [ ] **P5-T04** — `sentiment-analysis.job.ts` (on ingest) — calls a model to produce `sentiment_score [-1,1]`, `sentiment_label`, `impact_score`, `topics[]`, `entities[]`, `ai_summary`.
- [ ] **P5-T05** — Asset tagger: NER + symbol matching → `news_assets` rows with relevance score.
- [ ] **P5-T06** — Mirror new articles into Elasticsearch index `news` with text + facets.
- [ ] **P5-T07** — Routes: `GET /news` (paginated, filter by source/sentiment/asset/topic/date), `GET /news/:id`.
- [ ] **P5-T08** — Route: `GET /news/trending` — top topics in last 24h.
- [ ] **P5-T09** — Route: `GET /news/sentiment` — aggregate sentiment overview by asset class.

## Manual Smoke-Check

1. After 1 ingestion cycle, `news_articles` has ≥ 10 rows.
2. Every row has `sentiment_label`, `ai_summary`, and at least one `news_assets` link.
3. `GET /news?sentiment=bullish&asset=XAU/USD` filters correctly.
4. Elasticsearch query for a known keyword returns the matching article.

## 🛑 Phase Gate
> *"Phase 5 complete. Proceed to Phase 6 — Alerts & Notifications?"*
