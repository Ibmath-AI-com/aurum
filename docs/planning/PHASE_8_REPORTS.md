# Phase 8 — Reports & Exports

> **Status:** ⬜ Pending. Requires Phase 7 complete.
> **Goal:** Generate institutional-grade reports on demand or on schedule, exportable as PDF/Excel/PPTX.

## Scope

✅ In scope: report templates (daily summary, weekly outlook, metals deep-dive, portfolio, technical recap, cross-market), HTML rendering, PDF/Excel/PPTX export, S3/R2 storage, scheduled generation, dashboard sharing links.
❌ Out of scope: frontend rendering (Phase 9), tests (Phase 10).

## Tasks

- [ ] **P8-T01** — Template engine setup (Handlebars or React-PDF for HTML; PptxGenJS for PPTX; ExcelJS for XLSX).
- [ ] **P8-T02** — Template: Daily Market Summary (yesterday's movers, key indicators, news headlines).
- [ ] **P8-T03** — Template: Weekly Outlook (week ahead — economic events, technical levels, AI commentary).
- [ ] **P8-T04** — Template: Precious Metals Deep Dive (fundamentals + technicals for XAU/XAG/XPT/XPD + ETF flows + correlations).
- [ ] **P8-T05** — Template: Portfolio Report (holdings, allocation, P&L, risk metrics, AI-generated commentary).
- [ ] **P8-T06** — Template: Technical Recap (multi-asset signal summary).
- [ ] **P8-T07** — Template: Cross-Market Report (asset class comparison).
- [ ] **P8-T08** — `report-generation.job.ts` (BullMQ `low` queue) — renders template, exports to requested format, uploads to S3, updates `reports.file_url`.
- [ ] **P8-T09** — Routes: `GET /reports`, `POST /reports/generate`, `GET /reports/:id`, `GET /reports/:id/download`, `DELETE /reports/:id`.
- [ ] **P8-T10** — S3/R2 client + signed URL helper.
- [ ] **P8-T11** — Scheduler: cron-based scheduled reports per user pref.

## Manual Smoke-Check

1. `POST /reports/generate {type:"daily_summary",format:"pdf"}` → 202 + report id.
2. Within 30s, `GET /reports/:id` returns `status:"ready"` with `file_url`.
3. Download the PDF → it renders with logo, charts, and AI commentary section.
4. Generate the same as `xlsx` and `pptx` → both download and open correctly.

## 🛑 Phase Gate
> *"Phase 8 complete. Proceed to Phase 9 — Frontend?"*
