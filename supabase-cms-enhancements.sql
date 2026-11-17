-- ON Designs CMS enhancement: atomic project ordering + editable profile image.
create table if not exists public.site_settings (
  setting_key text primary key,
  setting_value text not null default '',
  updated_at timestamptz not null default now()
);
alter table public.site_settings enable row level security;
drop policy if exists "Public can read site settings" on public.site_settings;
create policy "Public can read site settings" on public.site_settings
for select to anon, authenticated using (true);
drop policy if exists "Admins can manage site settings" on public.site_settings;
create policy "Admins can manage site settings" on public.site_settings
for all to authenticated
using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));

create or replace function public.reorder_projects(project_ids uuid[])
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  expected_count integer;
  supplied_count integer;
begin
  if not exists (select 1 from public.admins a where a.user_id = auth.uid()) then
    raise exception 'Administrator access required';
  end if;
  select count(*) into expected_count from public.projects;
  select count(distinct x) into supplied_count from unnest(project_ids) as x;
  if supplied_count <> expected_count or coalesce(array_length(project_ids,1),0) <> expected_count then
    raise exception 'The project list changed. Reload and try again.';
  end if;
  if exists (
    select 1 from unnest(project_ids) as requested(id)
    left join public.projects p on p.id = requested.id
    where p.id is null
  ) then
    raise exception 'One or more projects no longer exist. Reload and try again.';
  end if;
  update public.projects p
  set sort_order = ordered.position - 1,
      updated_at = now()
  from unnest(project_ids) with ordinality as ordered(id, position)
  where p.id = ordered.id;
end;
$$;
revoke all on function public.reorder_projects(uuid[]) from public;
grant execute on function public.reorder_projects(uuid[]) to authenticated;
