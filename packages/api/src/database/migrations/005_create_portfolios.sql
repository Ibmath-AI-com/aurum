-- 005: portfolios, holdings, transactions
CREATE TABLE portfolios (
  id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  currency    VARCHAR(10)  NOT NULL DEFAULT 'USD',
  is_default  BOOLEAN      NOT NULL DEFAULT false,
  metadata    JSONB        NOT NULL DEFAULT '{}',
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_portfolios_user ON portfolios (user_id);

CREATE TABLE holdings (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id  UUID          NOT NULL REFERENCES portfolios (id) ON DELETE CASCADE,
  asset_id      UUID          NOT NULL REFERENCES assets (id),
  quantity      DECIMAL(24,8) NOT NULL DEFAULT 0,
  average_cost  DECIMAL(18,8),
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (portfolio_id, asset_id)
);

CREATE INDEX idx_holdings_portfolio ON holdings (portfolio_id);
CREATE INDEX idx_holdings_asset     ON holdings (asset_id);

CREATE TABLE transactions (
  id            UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  portfolio_id  UUID          NOT NULL REFERENCES portfolios (id) ON DELETE CASCADE,
  asset_id      UUID          NOT NULL REFERENCES assets (id),
  type          VARCHAR(10)   NOT NULL,
  quantity      DECIMAL(24,8) NOT NULL,
  price         DECIMAL(18,8) NOT NULL,
  fee           DECIMAL(18,8)  DEFAULT 0,
  currency      VARCHAR(10)   NOT NULL DEFAULT 'USD',
  notes         TEXT,
  transacted_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transactions_portfolio ON transactions (portfolio_id);
CREATE INDEX idx_transactions_asset     ON transactions (asset_id);
CREATE INDEX idx_transactions_time      ON transactions (transacted_at DESC);
