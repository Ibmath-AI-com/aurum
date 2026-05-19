# Schema Deviations from Spec

> Tracks every place the **implemented** schema diverges from `AURUM_Application_Structure_and_Database_Schema.md`. Read this **before** writing or reviewing migrations.
>
> Rule: never silently deviate from the spec. If you find a divergence not listed here, add it before merging.

---

## Verified Environment

**Remote Postgres server:** `15.135.254.123:5432`
**Database:** `aurumdb` (pre-existing, was empty at project start)
**Postgres version:** 16 (standard build)
**Available extensions:** `pgcrypto`, `uuid-ossp`
**Unavailable extensions:** `timescaledb`

---

## Deviation 1 — `price_data` uses native partitioning, not TimescaleDB

**Spec says:**
```sql
SELECT create_hypertable('price_data', 'time');
ALTER TABLE price_data SET (timescaledb.compress, ...);
SELECT add_compression_policy('price_data', INTERVAL '7 days');
SELECT add_retention_policy('price_data', INTERVAL '90 days', if_not_exists => TRUE);
```

**Implemented:**
```sql
CREATE TABLE price_data (
    time              TIMESTAMPTZ NOT NULL,
    asset_id          UUID NOT NULL REFERENCES assets(id),
    timeframe         VARCHAR(5) NOT NULL,
    open              DECIMAL(18,8) NOT NULL,
    high              DECIMAL(18,8) NOT NULL,
    low               DECIMAL(18,8) NOT NULL,
    close             DECIMAL(18,8) NOT NULL,
    volume            DECIMAL(24,4) DEFAULT 0,
    vwap              DECIMAL(18,8),
    trade_count       INTEGER,
    PRIMARY KEY (asset_id, timeframe, time)
) PARTITION BY RANGE (time);

-- Monthly partitions, created ahead of time:
CREATE TABLE price_data_2026_05 PARTITION OF price_data
    FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
-- ... 2026_06, 2026_07 ...
CREATE TABLE price_data_default PARTITION OF price_data DEFAULT;

CREATE INDEX idx_price_asset_tf ON price_data (asset_id, timeframe, time DESC);
```

**Why:** Server lacks TimescaleDB. Native PG partitioning gives partition pruning, smaller indexes, and faster vacuum at our current scale (MVP / <1k users) — TimescaleDB's edge (auto chunk management, native compression, continuous aggregates) matters at 10M+ rows/day, not yet.

**Operational implications:**
- A **partition manager job** must create future monthly partitions ahead of time. Track in Phase 2 (`P2-T*`).
- Compression: deferred. If size becomes an issue, options are:
  - Move to `bigint` epoch instead of `TIMESTAMPTZ` (saves 8 bytes/row).
  - Periodic `pg_dump` of old partitions to cold storage + `DROP PARTITION`.
- Retention: handled by a Phase 10 nightly job that runs `DROP TABLE price_data_<YYYY_MM>` for partitions older than 90 days.

**Upgrade path to TimescaleDB (future):**
1. Install `timescaledb` extension on the server.
2. `SELECT create_hypertable('price_data', 'time', migrate_data => TRUE);` — works on existing partitioned tables.
3. Drop the manual partition-management job.
4. Apply the spec's compression and retention policies.

---

## Deviation 2 — `indicator_data` uses native partitioning, not TimescaleDB

Same treatment as Deviation 1. Native `PARTITION BY RANGE (time)`. Monthly partitions. Same upgrade path.

---

## Deviation 3 — `audit_log` not partitioned in Phase 0

**Spec says:** monthly range partitions on `audit_log`.

**Implemented in Phase 0:** plain (non-partitioned) `BIGSERIAL` table.

**Why:** Volume in early phases will be low. Premature partitioning adds operational complexity (partition manager) for no measurable benefit.

**When to revisit:** Phase 10 hardening — convert to partitioned table once write volume justifies it. Migration will be straightforward because `audit_log` is append-only.

---

## Deviation 4 — Elasticsearch deferred

**Spec says:** Elasticsearch mirrors of `news_articles` and `assets` for full-text search and autocomplete.

**Implemented in Phase 0:** none. Only Postgres GIN full-text index on `news_articles.title`.

**When added:** Phase 5 (News & Sentiment) introduces Elasticsearch via Docker.

---

## Deviation 5 — UUID generation function

**Spec uses:** `gen_random_uuid()` (pgcrypto).

**Implemented:** same — `gen_random_uuid()` from `pgcrypto`. `uuid-ossp` is also installed as a fallback / for any future need (`uuid_generate_v4()`), but not used in migrations.

---

## Deviation Log Format

When adding a new deviation, use this template:

```
## Deviation N — <short title>

**Spec says:** <quote or summary>

**Implemented:** <what we actually did>

**Why:** <reason>

**Operational implications:** <ongoing impact>

**Upgrade path (if applicable):** <how to get back to spec later>
```

---

*This document is authoritative for the running schema. If `AURUM_Application_Structure_and_Database_Schema.md` says one thing and this file says another, **this file wins** — but the spec file is never edited; we only add deviations here.*
