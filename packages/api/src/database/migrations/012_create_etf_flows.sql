-- 012: etf_flows
CREATE TABLE etf_flows (
  id                 UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  asset_id           UUID          NOT NULL REFERENCES assets (id),
  date               DATE          NOT NULL,
  flow_usd           DECIMAL(20,2) NOT NULL,
  aum_usd            DECIMAL(20,2),
  shares_outstanding DECIMAL(20,0),
  created_at         TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  UNIQUE (asset_id, date)
);

CREATE INDEX idx_etf_flows_asset ON etf_flows (asset_id, date DESC);
