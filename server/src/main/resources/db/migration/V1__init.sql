CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  display_name TEXT,
  portrait_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS attributes (
  user_id TEXT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  str INT NOT NULL DEFAULT 0,
  int_ INT NOT NULL DEFAULT 0,
  vit INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TYPE intensity AS ENUM ('low','mid','high');

CREATE TABLE IF NOT EXISTS activity_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category TEXT NOT NULL,         -- strength|intelligence|vitality
  minutes INT NOT NULL,
  intensity intensity NOT NULL,
  gained_attr TEXT NOT NULL,      -- STR|INT|VIT
  gained_pt INT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS attribute_daily (
  user_id TEXT NOT NULL,
  date DATE NOT NULL,
  attr TEXT NOT NULL,             -- STR|INT|VIT
  rounds INT NOT NULL DEFAULT 0,
  gained INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, date, attr)
);

CREATE TABLE IF NOT EXISTS battles (
  id BIGSERIAL PRIMARY KEY,
  attacker_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  defender_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  winner_id TEXT NOT NULL,
  log_json JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_activity_logs_user_time ON activity_logs(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_battles_attacker_time ON battles(attacker_id, created_at DESC);
