-- ON Designs CMS: run this once in Supabase SQL Editor.
-- Then create your own user in Authentication > Users and insert that user's UUID
-- into public.admins (instructions are in README-CMS.md).
create extension if not exists pgcrypto;

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null check (category in ('thumbnails','posters','flyers','banners','events')),
  description text not null default '',
  image_url text not null,
  is_published boolean not null default false,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.admins enable row level security;
alter table public.projects enable row level security;

drop policy if exists "Admins can read own admin record" on public.admins;
create policy "Admins can read own admin record" on public.admins
for select to authenticated using (user_id = auth.uid());

drop policy if exists "Public can read published projects" on public.projects;
create policy "Public can read published projects" on public.projects
for select to anon, authenticated using (is_published = true or exists (
  select 1 from public.admins a where a.user_id = auth.uid()
));
drop policy if exists "Admins can insert projects" on public.projects;
create policy "Admins can insert projects" on public.projects
for insert to authenticated with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));
drop policy if exists "Admins can update projects" on public.projects;
create policy "Admins can update projects" on public.projects
for update to authenticated using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete projects" on public.projects;
create policy "Admins can delete projects" on public.projects
for delete to authenticated using (exists (select 1 from public.admins a where a.user_id = auth.uid()));

insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('portfolio','portfolio',true,8388608,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=true,file_size_limit=8388608,allowed_mime_types=array['image/jpeg','image/png','image/webp'];

drop policy if exists "Public can view portfolio artwork" on storage.objects;
create policy "Public can view portfolio artwork" on storage.objects
for select to anon, authenticated using (bucket_id = 'portfolio');
drop policy if exists "Admins can upload portfolio artwork" on storage.objects;
create policy "Admins can upload portfolio artwork" on storage.objects
for insert to authenticated with check (bucket_id = 'portfolio' and exists (
  select 1 from public.admins a where a.user_id = auth.uid()
));
drop policy if exists "Admins can update portfolio artwork" on storage.objects;
create policy "Admins can update portfolio artwork" on storage.objects
for update to authenticated using (bucket_id = 'portfolio' and exists (
  select 1 from public.admins a where a.user_id = auth.uid()
)) with check (bucket_id = 'portfolio' and exists (
  select 1 from public.admins a where a.user_id = auth.uid()
));
drop policy if exists "Admins can delete portfolio artwork" on storage.objects;
create policy "Admins can delete portfolio artwork" on storage.objects
for delete to authenticated using (bucket_id = 'portfolio' and exists (
  select 1 from public.admins a where a.user_id = auth.uid()
));
