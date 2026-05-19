# Phase 1 — Authentication & Users

> **Status:** ⬜ Pending — do not start until Phase 0 is approved.
> **Goal:** Production-ready auth, user identity, and session management.

---

## Scope

✅ In scope:
- Register / login / logout endpoints
- Password hashing with **Argon2id** (memory: 64MB, iterations: 3, parallelism: 4)
- **JWT access tokens** (15-minute expiry, RS256) + **refresh tokens** (30-day, HttpOnly Secure SameSite cookie)
- OAuth scaffold for Google and GitHub (`POST /api/v1/auth/oauth/:provider`)
- `GET /api/v1/auth/me` and `PUT /api/v1/settings`
- Forgot-password email flow (stub the email sender; real provider in Phase 5/6 infra)
- Audit logging on login, logout, password change, OAuth link
- Redis session keys (`session:{id}`) and rate-limit keys (`rate_limit:{user_id}:{endpoint}`)
- Middleware: `auth.middleware.ts`, `rateLimit.middleware.ts`, `error.middleware.ts`, `logger.middleware.ts`

❌ Out of scope:
- Market data, alerts, AI — later phases
- Tests — Phase 10
- SMS / Telegram delivery — Phase 6

---

## Tasks

- [ ] **P1-T01** — Add deps to `packages/api`: `@fastify/jwt`, `@fastify/cookie`, `@fastify/cors`, `argon2`, `zod`, `ioredis`.
- [ ] **P1-T02** — Create `src/services/auth/auth.service.ts` with `register`, `login`, `refresh`, `logout`, `hashPassword`, `verifyPassword`.
- [ ] **P1-T03** — Create `src/services/auth/jwt.service.ts` — RS256 signing, key loading from env (PEM strings or file paths).
- [ ] **P1-T04** — Create `src/services/auth/oauth.service.ts` — Google + GitHub strategies (stub redirect URLs).
- [ ] **P1-T05** — Routes: `POST /auth/register`, `POST /auth/login`, `POST /auth/refresh`, `POST /auth/logout`, `POST /auth/forgot-password`, `POST /auth/oauth/:provider`.
- [ ] **P1-T06** — Route: `GET /auth/me` (requires auth).
- [ ] **P1-T07** — Routes: `GET /settings`, `PUT /settings`, `PUT /settings/password`, `DELETE /settings/account`.
- [ ] **P1-T08** — Middleware: JWT verification, attach `request.user`.
- [ ] **P1-T09** — Middleware: per-user rate limiting via Redis (100 req/min free, 1000 pro, 5000 enterprise).
- [ ] **P1-T10** — Middleware: structured error handler returning `{error: {code, message, details}}`.
- [ ] **P1-T11** — Audit logger helper that writes to `audit_log` on auth events.
- [ ] **P1-T12** — Zod validators for all request bodies.
- [ ] **P1-T13** — Update `.env.example` with `JWT_PRIVATE_KEY`, `JWT_PUBLIC_KEY`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`, `COOKIE_SECRET`.

---

## Manual Smoke-Check

1. Register a user via `curl POST /auth/register` → 201 + tokens.
2. Login with the same creds → 200 + new tokens.
3. `GET /auth/me` with the access token → user record minus password hash.
4. `POST /auth/refresh` with the refresh cookie → new access token.
5. `POST /auth/logout` → refresh cookie cleared; subsequent `/me` with old token still works until expiry; subsequent refresh fails.
6. `audit_log` has rows for `register`, `login`, `logout`.
7. Hit any endpoint 101 times within a minute as a free-tier user → 101st is rate-limited (429).

---

## 🛑 Phase Gate

When all boxes are `- [x]` and the smoke-check passes, stop and ask:
> *"Phase 1 complete. Proceed to Phase 2 — Market Data Ingestion?"*
