-- 006: watchlists and watchlist_assets
CREATE TABLE watchlists (
  id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
  name       VARCHAR(255) NOT NULL,
  is_default BOOLEAN      NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_watchlist_user ON watchlists (user_id);

CREATE TABLE watchlist_assets (
  watchlist_id  UUID        NOT NULL REFERENCES watchlists (id) ON DELETE CASCADE,
  asset_id      UUID        NOT NULL REFERENCES assets (id),
  display_order INTEGER     NOT NULL DEFAULT 0,
  added_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (watchlist_id, asset_id)
);

CREATE INDEX idx_watchlist_assets_asset ON watchlist_assets (asset_id);
