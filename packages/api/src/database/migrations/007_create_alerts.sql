-- 007: alerts and alert_history
CREATE TABLE alerts (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  asset_id          UUID        REFERENCES assets (id),
  name              VARCHAR(255) NOT NULL,
  type              VARCHAR(50)  NOT NULL,
  condition         JSONB        NOT NULL,
  channels          JSONB        NOT NULL DEFAULT '["in_app"]',
  is_active         BOOLEAN      NOT NULL DEFAULT true,
  cooldown_minutes  INTEGER      NOT NULL DEFAULT 60,
  last_triggered_at TIMESTAMPTZ,
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_alerts_user  ON alerts (user_id);
CREATE INDEX idx_alerts_asset ON alerts (asset_id) WHERE asset_id IS NOT NULL;

CREATE TABLE alert_history (
  id                  UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_id            UUID          NOT NULL REFERENCES alerts (id) ON DELETE CASCADE,
  user_id             UUID          NOT NULL REFERENCES users (id),
  triggered_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  condition_snapshot  JSONB         NOT NULL,
  market_value        DECIMAL(18,8),
  channels_notified   JSONB         NOT NULL DEFAULT '[]',
  is_read             BOOLEAN       NOT NULL DEFAULT false
);

CREATE INDEX idx_alert_hist_user   ON alert_history (user_id, triggered_at DESC);
CREATE INDEX idx_alert_hist_unread ON alert_history (user_id) WHERE is_read = false;
