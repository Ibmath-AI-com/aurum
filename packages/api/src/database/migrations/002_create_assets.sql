-- 002: assets table
CREATE TABLE assets (
  id          UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol      VARCHAR(20)  NOT NULL,
  name        VARCHAR(255) NOT NULL,
  asset_class VARCHAR(50)  NOT NULL,
  category    VARCHAR(100),
  description TEXT,
  exchange    VARCHAR(50),
  currency    VARCHAR(10)  NOT NULL DEFAULT 'USD',
  is_active   BOOLEAN      NOT NULL DEFAULT true,
  metadata    JSONB        NOT NULL DEFAULT '{}',
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_assets_symbol ON assets (symbol);
CREATE INDEX idx_assets_class    ON assets (asset_class);
CREATE INDEX idx_assets_category ON assets (category);
