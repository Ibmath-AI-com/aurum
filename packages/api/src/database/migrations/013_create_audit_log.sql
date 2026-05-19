-- 013: audit_log (plain table; see SCHEMA_DEVIATIONS.md Deviation 3)
-- TODO(P10): partition by month once write volume justifies it
CREATE TABLE audit_log (
  id            BIGSERIAL   PRIMARY KEY,
  user_id       UUID        REFERENCES users (id),
  action        VARCHAR(100) NOT NULL,
  resource_type VARCHAR(50),
  resource_id   TEXT,
  ip_address    INET,
  user_agent    TEXT,
  metadata      JSONB       NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_user   ON audit_log (user_id, created_at DESC);
CREATE INDEX idx_audit_action ON audit_log (action, created_at DESC);
