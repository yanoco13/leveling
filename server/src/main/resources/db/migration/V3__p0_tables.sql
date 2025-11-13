-- P0 tables: avatars / attributes / activity_logs
CREATE TABLE IF NOT EXISTS avatars (
  id UUID PRIMARY KEY,
  display_name TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS attributes (
  user_id UUID PRIMARY KEY REFERENCES avatars(id) ON DELETE CASCADE,
  str INT NOT NULL DEFAULT 0,
  int_ INT NOT NULL DEFAULT 0,
  vit INT NOT NULL DEFAULT 0,
  updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS activity_logs (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES avatars(id) ON DELETE CASCADE,
  kind TEXT NOT NULL,
  minutes INT NOT NULL,
  intensity TEXT NOT NULL,
  delta_str INT NOT NULL DEFAULT 0,
  delta_int INT NOT NULL DEFAULT 0,
  delta_vit INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);
