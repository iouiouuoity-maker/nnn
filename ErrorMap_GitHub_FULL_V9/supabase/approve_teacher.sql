-- Replace the address below after creating the teacher in Authentication → Users.
insert into public.em_teachers(user_id,display_name)
select id,'Assel Amanzholova' from auth.users
where lower(email)=lower('REPLACE_WITH_TEACHER_EMAIL')
on conflict(user_id) do nothing;
