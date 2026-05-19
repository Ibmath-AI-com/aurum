-- 010: reports
CREATE TABLE reports (
  id             UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  type           VARCHAR(50)  NOT NULL,
  title          VARCHAR(255) NOT NULL,
  template_data  JSONB        NOT NULL DEFAULT '{}',
  status         VARCHAR(20)  NOT NULL DEFAULT 'pending',
  storage_key    TEXT,
  formats        JSONB        NOT NULL DEFAULT '[]',
  scheduled_for  TIMESTAMPTZ,
  generated_at   TIMESTAMPTZ,
  created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_reports_user   ON reports (user_id, created_at DESC);
CREATE INDEX idx_reports_status ON reports (status) WHERE status NOT IN ('complete', 'failed');
