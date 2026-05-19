-- 004: indicator_data — native PARTITION BY RANGE (time) instead of TimescaleDB hypertable
-- See docs/planning/SCHEMA_DEVIATIONS.md Deviation 2
CREATE TABLE indicator_data (
  time       TIMESTAMPTZ   NOT NULL,
  asset_id   UUID          NOT NULL REFERENCES assets (id),
  indicator  VARCHAR(50)   NOT NULL,
  timeframe  VARCHAR(5)    NOT NULL,
  value      DECIMAL(18,8),
  metadata   JSONB,
  PRIMARY KEY (asset_id, indicator, timeframe, time)
) PARTITION BY RANGE (time);

-- Initial monthly partitions
CREATE TABLE indicator_data_2026_05 PARTITION OF indicator_data
  FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
CREATE TABLE indicator_data_2026_06 PARTITION OF indicator_data
  FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
CREATE TABLE indicator_data_2026_07 PARTITION OF indicator_data
  FOR VALUES FROM ('2026-07-01') TO ('2026-08-01');

CREATE TABLE indicator_data_default PARTITION OF indicator_data DEFAULT;

CREATE INDEX idx_indicator_lookup ON indicator_data (asset_id, indicator, timeframe, time DESC);
