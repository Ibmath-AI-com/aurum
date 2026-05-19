-- 001: users table
CREATE TABLE users (
  id                UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  email             VARCHAR(255) NOT NULL,
  password_hash     TEXT,
  name              VARCHAR(255),
  avatar_url        TEXT,
  role              VARCHAR(20)  NOT NULL DEFAULT 'user',
  subscription_tier VARCHAR(20)  NOT NULL DEFAULT 'free',
  oauth_provider    VARCHAR(50),
  oauth_id          TEXT,
  email_verified    BOOLEAN      NOT NULL DEFAULT false,
  settings          JSONB        NOT NULL DEFAULT '{}',
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_users_email ON users (email);
CREATE INDEX idx_users_oauth ON users (oauth_provider, oauth_id) WHERE oauth_provider IS NOT NULL;
