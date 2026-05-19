-- 003: price_data — native PARTITION BY RANGE (time) instead of TimescaleDB hypertable
-- See docs/planning/SCHEMA_DEVIATIONS.md Deviation 1
CREATE TABLE price_data (
  time        TIMESTAMPTZ  NOT NULL,
  asset_id    UUID         NOT NULL REFERENCES assets (id),
  timeframe   VARCHAR(5)   NOT NULL,
  open        DECIMAL(18,8) NOT NULL,
  high        DECIMAL(18,8) NOT NULL,
  low         DECIMAL(18,8) NOT NULL,
  close       DECIMAL(18,8) NOT NULL,
  volume      DECIMAL(24,4)  DEFAULT 0,
  vwap        DECIMAL(18,8),
  trade_count INTEGER,
  PRIMARY KEY (asset_id, timeframe, time)
) PARTITION BY RANGE (time);

-- Initial monthly partitions (current month + next 2)
CREATE TABLE price_data_2026_05 PARTITION OF price_data
  FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE price_data_2026_06 PARTITION OF price_data
  FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
CREATE TABLE price_data_2026_07 PARTITION OF price_data
  FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');

-- Catch-all for any out-of-range data
CREATE TABLE price_data_default PARTITION OF price_data DEFAULT;

CREATE INDEX idx_price_asset_tf ON price_data (asset_id, timeframe, time DESC);
