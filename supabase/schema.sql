-- 最小スキーマ + RLS
create table if not exists avatars (
  user_id uuid primary key references auth.users(id),
  name text not null,
  portrait_url text,
  level int not null default 1,
  created_at timestamptz not null default now()
);

create table if not exists attributes (
  user_id uuid primary key references auth.users(id),
  str int not null default 0,
  int_ int not null default 0,
  vit int not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists activity_logs (
  id bigserial primary key,
  user_id uuid not null references auth.users(id),
  category text not null,
  minutes int not null,
  intensity text not null,
  gained_attr text not null,
  gained_pt int not null,
  created_at timestamptz not null default now()
);

create table if not exists attribute_daily (
  user_id uuid not null references auth.users(id),
  date date not null,
  attr text not null,
  rounds int not null default 0,
  gained int not null default 0,
  primary key (user_id, date, attr)
);

create table if not exists battles (
  id bigserial primary key,
  attacker_id uuid not null references auth.users(id),
  defender_id uuid not null references auth.users(id),
  winner_id uuid,
  log_json jsonb,
  seed bigint,
  created_at timestamptz not null default now()
);

-- RLS
alter table avatars         enable row level security;
alter table attributes      enable row level security;
alter table activity_logs   enable row level security;
alter table attribute_daily enable row level security;
alter table battles         enable row level security;

-- Policies
create policy "own rows" on avatars
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on attributes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on activity_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows" on attribute_daily
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "participants can read" on battles
  for select using (auth.uid() = attacker_id or auth.uid() = defender_id);
create policy "only server inserts" on battles
  for insert with check (true);
