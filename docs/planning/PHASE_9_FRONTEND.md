# Phase 9 — Frontend (Web App)

> **Status:** ⬜ Pending. Requires Phase 8 complete.
> **Goal:** Ship the React web app wired to every API from Phases 1-8. Design follows `AURUM_Prototype__4_.html`.

## Scope

✅ In scope: React 18 + Vite + Tailwind, routing, auth flow, dashboard, market view, AI chat, portfolio, watchlists, alerts, news, reports, settings, dark/light theme, responsive (mobile + tablet + desktop), real-time prices via WebSocket.
❌ Out of scope: native mobile apps, browser extension, tests (Phase 10).

## Tasks

- [ ] **P9-T01** — Scaffold `packages/web` with Vite + React 18 + TS + Tailwind. Tailwind config maps the prototype's CSS variables to design tokens.
- [ ] **P9-T02** — Providers: `AuthProvider`, `ThemeProvider`, `QueryProvider` (TanStack Query), `WebSocketProvider`.
- [ ] **P9-T03** — Router with route guards (public, authed).
- [ ] **P9-T04** — Auth pages: Login, Register, Forgot Password, OAuth callback.
- [ ] **P9-T05** — Dashboard page: ticker strip, main chart (Lightweight Charts), AI assistant panel, indicators panel, news ticker.
- [ ] **P9-T06** — Market page: heatmap, correlation matrix, economic calendar, ETF flows.
- [ ] **P9-T07** — Analysis page: per-asset technical breakdown with signal summary.
- [ ] **P9-T08** — Portfolio page: holdings table, allocation donut, performance chart, transaction log, add-transaction modal.
- [ ] **P9-T09** — Watchlists page: drag-to-reorder, multi-watchlist tabs.
- [ ] **P9-T10** — News page: list + filters + article modal with AI impact analysis.
- [ ] **P9-T11** — Alerts page: list, create modal, history, mark-read.
- [ ] **P9-T12** — Reports page: list, generate modal, download.
- [ ] **P9-T13** — Settings page: profile, notifications, AI prefs, password, danger zone.
- [ ] **P9-T14** — Layout: collapsible sidebar (desktop), bottom nav (mobile), top header with search + alerts bell + market-status pill.
- [ ] **P9-T15** — Toast system, modal system, skeleton loaders.
- [ ] **P9-T16** — WebSocket client subscribes to live prices on visible symbols.

## Manual Smoke-Check

1. Visit `/`, register, get redirected to dashboard with live ticker animating.
2. Open AI assistant, ask a question, see streamed tokens render.
3. Add a transaction → portfolio page updates value within 30s.
4. Create an alert → triggered alert appears in the bell within ~5s of simulated condition.
5. Toggle theme → persists across reload.
6. Resize to mobile width → layout adapts, bottom nav appears.

## 🛑 Phase Gate
> *"Phase 9 complete. Proceed to Phase 10 — Testing, Hardening & Deploy?"*
