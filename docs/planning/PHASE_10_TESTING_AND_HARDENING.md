# Phase 10 — Testing, Hardening & Deploy

> **Status:** ⬜ Pending. Requires Phase 9 complete.
> **Goal:** First phase where **test units** are introduced. Bring the system to production-readiness.

## Scope

✅ In scope:
- Unit tests (Vitest) for every package
- Integration tests for API routes
- E2E tests (Playwright) for critical user journeys
- Load testing (k6) on hot endpoints
- Security audit (OWASP Top 10, dependency scan, secret scan)
- Production Dockerfiles for `api` and `web`
- CI pipeline (GitHub Actions): lint → typecheck → test → build → deploy
- Staging + production deploy
- Monitoring (Grafana + Prometheus), logging (ELK), error tracking (Sentry)
- Operational runbook + onboarding doc

## Tasks

### Testing

- [ ] **P10-T01** — Add Vitest to `packages/common`, `packages/api`, `packages/web`. Root `pnpm test` runs all.
- [ ] **P10-T02** — Unit tests: indicator library (RSI/MACD/SMA/EMA/BB/VWAP/ATR) — golden values.
- [ ] **P10-T03** — Unit tests: cost-basis recalculation, P&L math, allocation math.
- [ ] **P10-T04** — Unit tests: alert condition evaluators (all alert_type variants).
- [ ] **P10-T05** — Integration tests: auth flow (register → login → refresh → logout).
- [ ] **P10-T06** — Integration tests: portfolio flow (create → buy → sell → analytics).
- [ ] **P10-T07** — Integration tests: alert lifecycle (create → trigger → history → mark-read).
- [ ] **P10-T08** — Playwright E2E: full new-user journey (register → add watchlist → create alert → ask AI).
- [ ] **P10-T09** — Playwright E2E: portfolio + report generation.
- [ ] **P10-T10** — k6 load test: `/market/prices/:symbol` at 1000 RPS, WebSocket with 5000 concurrent connections.

### Security & Hardening

- [ ] **P10-T11** — Enable Postgres row-level security on multi-tenant tables.
- [ ] **P10-T12** — Add CSP, HSTS, X-Frame-Options headers.
- [ ] **P10-T13** — Add CSRF tokens for cookie-based flows.
- [ ] **P10-T14** — Run `npm audit` / `pnpm audit` — resolve all high/critical.
- [ ] **P10-T15** — Run secret scan (Gitleaks).
- [ ] **P10-T16** — Verify all financial data is TLS 1.3 in transit, AES-256 at rest.
- [ ] **P10-T17** — Confirm Argon2id params match spec.

### Deploy

- [ ] **P10-T18** — Production Dockerfile for `packages/api` (multi-stage, distroless).
- [ ] **P10-T19** — Production Dockerfile for `packages/web` (static build, served via nginx or CDN).
- [ ] **P10-T20** — Terraform: RDS (PG + TimescaleDB), ElastiCache (Redis), ECS/Fargate, CloudFront, S3.
- [ ] **P10-T21** — GitHub Actions: `ci.yml`, `cd-staging.yml`, `cd-production.yml`.
- [ ] **P10-T22** — Sentry, Grafana dashboards, Prometheus exporters, structured logs to ELK.
- [ ] **P10-T23** — `docs/deployment.md` runbook and `docs/onboarding.md`.
- [ ] **P10-T24** — Smoke-test in staging, then promote to production.

## Manual Smoke-Check

1. `pnpm test` runs the full suite — green.
2. Playwright report shows all E2E scenarios passing.
3. k6 hot-endpoint report shows p95 latency within target.
4. `docker compose -f docker-compose.prod.yml up` boots without errors locally.
5. Staging URL responds to `/health` and serves the web app.
6. Sentry receives a test error; Grafana shows API metrics.

## 🎉 Project Complete

When this phase is done, AURUM v1.0 is shippable. Update `ROADMAP.md` — every phase ✅.
