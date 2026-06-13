-- Dionysus — Schéma de partage co-parent (Supabase / Postgres)
-- ----------------------------------------------------------------------------
-- À exécuter dans le SQL editor du projet Supabase.
-- Prérequis dashboard : Auth > Providers > activer « Anonymous sign-ins ».
-- Après exécution : Database > Replication > activer Realtime sur `shared_entries`.
--
-- Modèle : chaque parent = un utilisateur (auth anonyme). Le partage est limité,
-- par le RLS, au seul co-parent appairé. On ne stocke qu'un projeté dénormalisé
-- des saisies (assez pour le bocal + la dernière émotion), aucun détail sensible.

-- ===========================================================================
-- Tables
-- ===========================================================================

create table if not exists public.profiles (
  id           uuid primary key references auth.users (id) on delete cascade,
  first_name   text not null default '',
  -- Code d'appairage aléatoire, encodé dans le QR avec l'id. Rotable.
  pairing_code text not null default encode(gen_random_bytes(8), 'hex'),
  coparent_id  uuid references public.profiles (id) on delete set null,
  created_at   timestamptz not null default now()
);

create table if not exists public.shared_entries (
  id              uuid primary key default gen_random_uuid(),
  owner_id        uuid not null references public.profiles (id) on delete cascade,
  -- Id de la saisie locale (SQLite) : rend la synchro idempotente (upsert).
  client_entry_id integer not null,
  emotion_name    text not null,
  quadrant_label  text not null,
  intensity       integer not null check (intensity between 1 and 5),
  created_at      timestamptz not null,
  unique (owner_id, client_entry_id)
);

create index if not exists shared_entries_owner_created_idx
  on public.shared_entries (owner_id, created_at desc);

-- ===========================================================================
-- RPC d'appairage (symétrique, validé par le code, transactionnel)
-- ===========================================================================

create or replace function public.link_coparent(target_id uuid, target_code text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
begin
  if me is null then
    raise exception 'not authenticated';
  end if;
  if target_id = me then
    raise exception 'cannot pair with yourself';
  end if;

  -- Vérifie que la cible existe et que le code correspond.
  if not exists (
    select 1 from public.profiles
    where id = target_id and pairing_code = target_code
  ) then
    raise exception 'invalid pairing code';
  end if;

  -- Refuse si l'un des deux est déjà appairé à quelqu'un d'autre.
  if exists (
    select 1 from public.profiles
    where id in (me, target_id)
      and coparent_id is not null
      and coparent_id <> case when id = me then target_id else me end
  ) then
    raise exception 'already paired';
  end if;

  update public.profiles set coparent_id = target_id where id = me;
  update public.profiles set coparent_id = me        where id = target_id;
end;
$$;

create or replace function public.unlink_coparent()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me    uuid := auth.uid();
  other uuid;
begin
  select coparent_id into other from public.profiles where id = me;
  update public.profiles set coparent_id = null where id = me;
  if other is not null then
    update public.profiles set coparent_id = null where id = other;
  end if;
end;
$$;

-- ===========================================================================
-- Row Level Security
-- ===========================================================================

alter table public.profiles      enable row level security;
alter table public.shared_entries enable row level security;

-- Helper : id du co-parent de l'utilisateur courant.
create or replace function public.my_coparent_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select coparent_id from public.profiles where id = auth.uid();
$$;

-- profiles ---------------------------------------------------------------
drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select using (
    id = auth.uid() or id = public.my_coparent_id()
  );

drop policy if exists profiles_insert on public.profiles;
create policy profiles_insert on public.profiles
  for insert with check (id = auth.uid());

drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

-- shared_entries ---------------------------------------------------------
drop policy if exists shared_entries_select on public.shared_entries;
create policy shared_entries_select on public.shared_entries
  for select using (
    owner_id = auth.uid() or owner_id = public.my_coparent_id()
  );

drop policy if exists shared_entries_write on public.shared_entries;
create policy shared_entries_write on public.shared_entries
  for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());
