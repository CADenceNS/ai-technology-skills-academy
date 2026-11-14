-- AITS Academy isolated student data schema. Run ONLY in a new AITS Supabase project.
create table if not exists public.student_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null default '{"done":{},"quiz":{},"notes":{},"links":{}}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint progress_object check (jsonb_typeof(progress) = 'object')
);
alter table public.student_progress enable row level security;
revoke all on public.student_progress from anon;
grant select, insert, update, delete on public.student_progress to authenticated;
create policy "students read own progress" on public.student_progress for select to authenticated using ((select auth.uid()) = user_id);
create policy "students create own progress" on public.student_progress for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "students update own progress" on public.student_progress for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "students delete own progress" on public.student_progress for delete to authenticated using ((select auth.uid()) = user_id);
-- Do not put service_role keys in frontend code. Use only public publishable key.
