-- ============================================================
--  Group Calendar - Supabase setup
--  Run this ONCE: Dashboard -> SQL Editor -> New query -> paste -> Run
--  (Safe to re-run; it uses IF NOT EXISTS / DROP IF EXISTS.)
-- ============================================================

-- 1) Events table
create table if not exists public.events (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  description text,
  date        date not null,
  time        text,                    -- 'HH:MM' or null for an all-day event
  color       text not null default '#1a73e8',
  created_by  text,                    -- optional display name of who added it
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists events_date_idx on public.events (date);

-- 2) Base privileges: make sure the anon role can reach the table at all.
--    (Some projects don't auto-grant new tables to anon, so set it explicitly.)
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.events to anon, authenticated;

-- 3) Row Level Security: let anyone with the link (the anon role) read & write.
alter table public.events enable row level security;

drop policy if exists "anon_read"   on public.events;
create policy "anon_read"   on public.events for select to anon using (true);
drop policy if exists "anon_insert" on public.events;
create policy "anon_insert" on public.events for insert to anon with check (true);
drop policy if exists "anon_update" on public.events;
create policy "anon_update" on public.events for update to anon using (true) with check (true);
drop policy if exists "anon_delete" on public.events;
create policy "anon_delete" on public.events for delete to anon using (true);

-- 4) Stream changes over Realtime so every open tab updates live.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'events'
  ) then
    alter publication supabase_realtime add table public.events;
  end if;
end $$;

-- Done. Now copy your URL + anon key from: Project Settings -> API.
