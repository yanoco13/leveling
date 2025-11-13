create index if not exists idx_activity_logs_user_created on activity_logs(user_id, created_at desc);
create index if not exists idx_attribute_daily_user_date on attribute_daily(user_id, date);
