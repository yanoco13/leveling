CREATE TABLE IF NOT EXISTS task_sessions (
  id            BIGSERIAL PRIMARY KEY,
  task_id       INTEGER NOT NULL,
  user_id       VARCHAR(255) NOT NULL,
  started_at    TIMESTAMPTZ NOT NULL,
  ended_at      TIMESTAMPTZ,
  duration_sec  BIGINT NOT NULL DEFAULT 0,
  create_time   TIMESTAMPTZ NOT NULL DEFAULT now(),
  update_time   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_task_sessions_user_id ON task_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_task_sessions_task_id ON task_sessions(task_id);

-- “同時に1つだけ実行中”をDBでも守りたいなら（Postgresの部分インデックス）
CREATE UNIQUE INDEX IF NOT EXISTS uq_running_session_per_user
ON task_sessions(user_id)
WHERE ended_at IS NULL;
