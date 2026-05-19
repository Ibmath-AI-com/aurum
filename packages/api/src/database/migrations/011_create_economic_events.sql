-- 011: economic_events
CREATE TABLE economic_events (
  id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  title      VARCHAR(255) NOT NULL,
  country    VARCHAR(10)  NOT NULL,
  currency   VARCHAR(10),
  impact     VARCHAR(10)  NOT NULL DEFAULT 'low',
  actual     DECIMAL(18,4),
  forecast   DECIMAL(18,4),
  previous   DECIMAL(18,4),
  unit       VARCHAR(50),
  event_at   TIMESTAMPTZ  NOT NULL,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_econ_events_time   ON economic_events (event_at);
CREATE INDEX idx_econ_events_impact ON economic_events (impact, event_at);
