# AURUM

AI-Powered Market Intelligence & Analysis Assistant with a precious-metals focus.

> ⚠️ **Migrations run against a live remote PostgreSQL database.**
> Never run destructive SQL casually. Always back up before a schema-breaking migration.

## Quick Start

### Prerequisites
- Node.js 20+
- pnpm 9+
- Docker & Docker Compose (for local Redis only — Postgres is remote)

### Setup

```bash
# 1. Install dependencies
pnpm install

# 2. Copy env file and fill in values
cp .env.example .env
# → Edit .env: set DB_USER, DB_PASSWORD, and DATABASE_URL

# 3. Start local Redis
docker compose -f infra/docker/docker-compose.yml up redis -d

# 4. Run database migrations (targets the remote aurumdb)
pnpm migrate

# 5. Seed initial asset data
pnpm seed

# 6. Start development server
pnpm dev
```

### Verify

```bash
curl http://localhost:3000/health
# → {"status":"ok","db":"connected","db_name":"aurumdb","timestamp":"..."}
```

## Project Structure

```
aurum/
├── docs/planning/      # Roadmap, phase task files, SCHEMA_DEVIATIONS.md
├── packages/
│   ├── common/         # Shared types and utilities
│   ├── api/            # Fastify backend (Node.js)
│   └── web/            # React frontend (Phase 9)
└── infra/docker/       # Docker Compose for local Redis
```

See [docs/planning/ROADMAP.md](./docs/planning/ROADMAP.md) for the full development plan.
