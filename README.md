# AURUM

AI-Powered Market Intelligence & Analysis Assistant with a precious-metals focus.

## Quick Start

### Prerequisites
- Node.js 20+
- pnpm 9+
- Docker & Docker Compose

### Setup

```bash
# 1. Install dependencies
pnpm install

# 2. Copy env file and fill in values
cp .env.example .env

# 3. Start local infrastructure (Postgres/TimescaleDB + Redis)
docker compose -f infra/docker/docker-compose.yml up -d

# 4. Run database migrations
pnpm migrate

# 5. Seed initial asset data
pnpm seed

# 6. Start development server
pnpm dev
```

### Verify

```bash
curl http://localhost:3000/health
# → {"status":"ok","db":"connected","timestamp":"..."}
```

## Project Structure

```
aurum/
├── docs/planning/      # Roadmap and per-phase task files
├── packages/
│   ├── common/         # Shared types and utilities
│   ├── api/            # Fastify backend (Node.js)
│   └── web/            # React frontend (Phase 9)
└── infra/docker/       # Docker Compose for local dev
```

See [docs/planning/ROADMAP.md](./docs/planning/ROADMAP.md) for the full development plan.
