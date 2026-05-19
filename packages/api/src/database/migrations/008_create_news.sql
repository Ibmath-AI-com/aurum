-- 008: news_articles and news_assets
CREATE TABLE news_articles (
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  source          VARCHAR(100) NOT NULL,
  source_id       TEXT,
  title           TEXT         NOT NULL,
  summary         TEXT,
  content         TEXT,
  url             TEXT         NOT NULL,
  image_url       TEXT,
  author          VARCHAR(255),
  sentiment_score DECIMAL(5,4),
  sentiment_label VARCHAR(20),
  entities        JSONB        NOT NULL DEFAULT '[]',
  published_at    TIMESTAMPTZ  NOT NULL,
  created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  UNIQUE (source, source_id)
);

CREATE INDEX idx_news_published ON news_articles (published_at DESC);
CREATE INDEX idx_news_sentiment  ON news_articles (sentiment_label);
CREATE INDEX idx_news_fulltext   ON news_articles USING GIN (to_tsvector('english', title));

CREATE TABLE news_assets (
  news_id         UUID          NOT NULL REFERENCES news_articles (id) ON DELETE CASCADE,
  asset_id        UUID          NOT NULL REFERENCES assets (id),
  relevance_score DECIMAL(5,4),
  PRIMARY KEY (news_id, asset_id)
);

CREATE INDEX idx_news_assets_asset ON news_assets (asset_id);
