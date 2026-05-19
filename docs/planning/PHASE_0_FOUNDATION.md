# Phase 0 — Foundation & Database

> **Goal:** Stand up the repo, dev environment, and the full database schema on the **existing remote `aurumdb`** Postgres server. No business logic, no tests, no frontend. Just a solid base.
>
> **Do not start Phase 1 until the user explicitly approves.** At the end of this phase, stop and ask:
> > *"Phase 0 complete. All tasks checked off. Proceed to Phase 1 — Authentication & Users? (yes/no)"*

---

## Environment Facts (read carefully)

- **Database host:** `15.135.254.123` (remote Postgres 16, standard build — **no TimescaleDB**)
- **Database name:** `aurumdb` (already exists, currently empty)
- **Available extensions on the remote:** `pgcrypto`, `uuid-ossp`
- **Not available:** `timescaledb`
- **Decision:** time-series tables (`price_data`, `indicator_data`) use **native PostgreSQL `PARTITION BY RANGE (time)`** instead of TimescaleDB hypertables.
- See `docs/planning/SCHEMA_DEVIATIONS.md` for the full list of spec deviations.

---

## Scope of this Phase

✅ In scope:
- Monorepo skeleton (Turborepo + pnpm workspaces)
- TypeScript base config
- `.env.example`, `.gitignore`, `README.md`
- Connection to the **existing remote `aurumdb`** (no Docker for Postgres — it's remote)
- Local Redis via Docker (Redis is still needed and is local-only for now)
- All schema migrations applied to remote `aurumdb` (with native partitioning where spec called for hypertables)
- Seed data for the `assets` table
- A single `/health` endpoint that confirms DB connectivity
- ESLint + Prettier configs

❌ Out of scope (later phases):
- Authentication, JWT, OAuth → Phase 1
- Any business endpoints beyond `/health` → Phase 2+
- React / frontend → Phase 9
- Unit tests, integration tests, CI → Phase 10
- Production Dockerfiles, deploy configs → Phase 10
- Installing TimescaleDB — explicitly **not** doing this; see deviations doc

---

## Tasks

> Tick each box (`- [ ]` → `- [x]`) as you finish it. Commit per task with the task id.

### Repo & Tooling

- [x] **P0-T01** — Initialize git repo, add `.gitignore` (Node, IDE, env, build artifacts), add `LICENSE` placeholder.
- [x] **P0-T02** — Set up `pnpm` workspaces + Turborepo. Root `package.json`, `pnpm-workspace.yaml`, `turbo.json` with `build`, `lint`, `typecheck`, `dev` pipelines.
- [x] **P0-T03** — Add root `tsconfig.base.json` (strict, ES2022, Node module resolution). Each package extends it.
- [x] **P0-T04** — Add root ESLint config (`@typescript-eslint`, import sort, prettier-compatible) and Prettier config. Add `lint` script.
- [x] **P0-T05** — Create `.env.example`. Phase 0 variables:
    ```
    # Remote Postgres
    DATABASE_URL=postgres://USER:PASSWORD@15.135.254.123:5432/aurumdb
    DB_HOST=15.135.254.123
    DB_PORT=5432
    DB_NAME=aurumdb
    DB_USER=
    DB_PASSWORD=
    DB_SSL=true            # set false only if the server lacks TLS

    # Local Redis (Docker)
    REDIS_URL=redis://localhost:6379

    # API
    API_PORT=3000
    NODE_ENV=development
    ```
    Note: do not commit `.env`.
- [x] **P0-T06** — Write root `README.md`: quick-start (`pnpm install`, `docker compose up redis -d`, `pnpm migrate`, `pnpm dev`), link to `docs/planning/ROADMAP.md`, and **explicit warning** that migrations run against the live remote `aurumdb` — never run destructive ops casually.

### Packages Skeleton

- [x] **P0-T07** — Create `packages/common/` with `package.json`, `tsconfig.json`, `src/index.ts`. Empty but compilable.
- [x] **P0-T08** — Create `packages/api/` with `package.json` (deps: `fastify`, `pg`, `drizzle-orm`, `drizzle-kit`, `dotenv`, `pino`), `tsconfig.json`, `src/index.ts` with a Fastify boot stub.

### Local Infrastructure (Docker — Redis only)

- [x] **P0-T09** — Create `infra/docker/docker-compose.yml` with **only Redis** (Postgres is remote, not in compose):
    - `redis` — image `redis:7-alpine`, port `6379`, volume `aurum_redis_data`, healthcheck `redis-cli ping`.
- [x] **P0-T10** — Verify remote DB connectivity & extensions:
    - `pgcrypto` and `uuid-ossp` installed and confirmed.
    - Environment documented in `docs/planning/SCHEMA_DEVIATIONS.md`.

### Database Migrations

> Spec reference: `AURUM_Application_Structure_and_Database_Schema.md` section 4.2.
> Deviations: `docs/planning/SCHEMA_DEVIATIONS.md` — **read first**.
> Migrations are plain SQL in `packages/api/src/database/migrations/`. One file per logical table group, numbered.

- [x] **P0-T11** — Migration runner: `packages/api/src/database/migrate.ts` reads files in `migrations/` in numeric order and applies any not yet recorded in a `schema_migrations(id text primary key, applied_at timestamptz default now(), checksum text)` table. Wrap each migration in a transaction. Fail loudly on checksum mismatch (someone edited a committed migration).
- [x] **P0-T12** — Migration `001_create_users.sql` — `users` table + indexes `idx_users_email`, `idx_users_oauth`.
- [x] **P0-T13** — Migration `002_create_assets.sql` — `assets` table + indexes `idx_assets_symbol`, `idx_assets_class`, `idx_assets_category`.
- [x] **P0-T14** — Migration `003_create_price_data.sql` — **native partitioned table** `PARTITION BY RANGE (time)`. Initial monthly partitions + default catch-all. Index `idx_price_asset_tf`.
- [x] **P0-T15** — Migration `004_create_indicator_data.sql` — same treatment as `003`: native `PARTITION BY RANGE (time)`, initial monthly partitions, catch-all, `idx_indicator_lookup`.
- [x] **P0-T16** — Migration `005_create_portfolios.sql` — `portfolios`, `holdings`, `transactions` (3 tables, all FKs, all indexes).
- [x] **P0-T17** — Migration `006_create_watchlists.sql` — `watchlists`, `watchlist_assets` + index `idx_watchlist_user`.
- [x] **P0-T18** — Migration `007_create_alerts.sql` — `alerts`, `alert_history` + indexes (`idx_alerts_user`, partial `idx_alerts_asset`, `idx_alert_hist_user`, partial `idx_alert_hist_unread`).
- [x] **P0-T19** — Migration `008_create_news.sql` — `news_articles`, `news_assets` + indexes including GIN full-text on `title`.
- [x] **P0-T20** — Migration `009_create_ai_conversations.sql` — `ai_conversations`, `ai_messages` + indexes.
- [x] **P0-T21** — Migration `010_create_reports.sql` — `reports` table + indexes.
- [x] **P0-T22** — Migration `011_create_economic_events.sql` — `economic_events` table + indexes.
- [x] **P0-T23** — Migration `012_create_etf_flows.sql` — `etf_flows` table + index.
- [x] **P0-T24** — Migration `013_create_audit_log.sql` — `audit_log` table + indexes. (Plain table; partitioning deferred to Phase 10.)
- [x] **P0-T25** — All migrations applied to remote `aurumdb`. All 27 tables confirmed. Partitions on `price_data` and `indicator_data` verified.

### Seed Data

- [x] **P0-T26** — Create `packages/api/src/database/seeds/assets.seed.ts`. Seed core assets: `XAU/USD`, `XAG/USD`, `XPT/USD`, `XPD/USD`, `SPY`, `GLD`, `SLV`, `NEM`, `GDX`, `DXY`.
- [x] **P0-T27** — `pnpm seed` runs successfully. 10 rows confirmed in remote `aurumdb`.

### Minimal API

- [x] **P0-T28** — Fastify boots on `API_PORT` with pino logger. `pg.Pool` sized to `DB_MAX`, SSL respecting `DB_SSL` env.
- [x] **P0-T29** — `GET /health` returns `{ status: "ok", db: "connected", db_name: "aurumdb", timestamp }`.
- [x] **P0-T30** — `pnpm dev` runs via `tsx watch`. Health endpoint returns `db: connected, db_name: aurumdb`. ✅

### Wrap-up

- [x] **P0-T31** — `pnpm lint` and `pnpm typecheck` both exit 0. Zero errors.
- [ ] **P0-T32** — Commit: `chore: complete Phase 0 — foundation & db (remote aurumdb, native partitioning)`.
- [ ] **P0-T33** — Update `docs/planning/ROADMAP.md`: change Phase 0 status to ✅ Complete (only after user approval — see manual gate below).

---

## Manual Smoke-Check

Before marking the phase complete, run all of these by hand and confirm:

1. `docker compose up redis -d` → Redis container healthy.
2. `psql "$DATABASE_URL" -c "\dt"` lists at minimum: `users`, `assets`, `price_data`, `indicator_data`, `portfolios`, `holdings`, `transactions`, `watchlists`, `watchlist_assets`, `alerts`, `alert_history`, `news_articles`, `news_assets`, `ai_conversations`, `ai_messages`, `reports`, `economic_events`, `etf_flows`, `audit_log`, `schema_migrations`.
3. `psql "$DATABASE_URL" -c "SELECT extname FROM pg_extension WHERE extname IN ('pgcrypto','uuid-ossp');"` returns both rows.
4. `psql "$DATABASE_URL" -c "SELECT parent.relname AS table, child.relname AS partition FROM pg_inherits JOIN pg_class parent ON pg_inherits.inhparent = parent.oid JOIN pg_class child ON pg_inherits.inhrelid = child.oid WHERE parent.relname IN ('price_data','indicator_data') ORDER BY 1,2;"` lists at least 4 partitions per parent (3 monthly + 1 default).
5. `psql "$DATABASE_URL" -c "SELECT count(*) FROM assets;"` ≥ 10.
6. `curl -s http://localhost:3000/health | jq` returns `{"status":"ok","db":"connected","db_name":"aurumdb", ...}`.
7. `pnpm typecheck && pnpm lint` exits 0.

---

## 🛑 Phase Gate

When every box above is `- [x]` and the smoke-check passes:

> **Stop. Ask the user:**
> *"Phase 0 complete — remote `aurumdb` is fully migrated with native partitioned time-series tables and seeded. Health endpoint green. Proceed to Phase 1 (Authentication & Users)? (yes/no)"*

Do not begin any Phase 1 work until the user replies `yes`.
