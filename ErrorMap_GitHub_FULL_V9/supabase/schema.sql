-- ErrorMap GitHub Pages edition. Run once in a new Supabase project.
begin;
create table public.em_teachers (
 user_id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default '', report_email text not null default '',
 created_at timestamptz not null default now()
);
create table public.em_classes (
 id uuid primary key default gen_random_uuid(),
 teacher_id uuid not null references public.em_teachers(user_id),
 name text not null check(length(trim(name)) between 1 and 60),
 code text not null unique default replace(gen_random_uuid()::text,'-',''),
 archived boolean not null default false, created_at timestamptz not null default now()
);
create table public.em_tasks (
 id uuid primary key default gen_random_uuid(),
 teacher_id uuid not null references public.em_teachers(user_id),
 class_id uuid not null references public.em_classes(id),
 title text not null check(length(trim(title)) between 1 and 120),
 instructions text not null default '' check(length(instructions)<=2000),
 code text not null unique default replace(gen_random_uuid()::text,'-',''),
 questions jsonb not null, is_open boolean not null default false,
 published_at timestamptz, due_at timestamptz,
 created_at timestamptz not null default now()
);
create table public.em_results (
 id uuid primary key default gen_random_uuid(),
 task_id uuid not null references public.em_tasks(id), attempt_id uuid not null,
 student_name text not null check(length(trim(student_name)) between 1 and 100),
 class_name text not null, answers jsonb not null, score integer not null,
 total integer not null, result jsonb not null, writing text not null default '',
 teacher_feedback text not null default '' check(length(teacher_feedback)<=5000),
 reviewed boolean not null default false, submitted_at timestamptz not null default now(),
 unique(task_id,attempt_id)
);
create table public.em_mail_queue (
 id uuid primary key default gen_random_uuid(),
 result_id uuid not null unique references public.em_results(id),
 teacher_id uuid not null references public.em_teachers(user_id),
 recipient text not null, status text not null default 'pending'
 check(status in ('pending','sent','failed')),
 attempts integer not null default 0, last_error text not null default '',
 created_at timestamptz not null default now(), sent_at timestamptz
);
create index on public.em_classes(teacher_id);
create index on public.em_tasks(teacher_id,class_id);
create index on public.em_results(task_id,submitted_at);
create index on public.em_mail_queue(status,created_at);

alter table public.em_teachers enable row level security;
alter table public.em_classes enable row level security;
alter table public.em_tasks enable row level security;
alter table public.em_results enable row level security;
alter table public.em_mail_queue enable row level security;
revoke all on public.em_teachers,public.em_classes,public.em_tasks,
 public.em_results,public.em_mail_queue from anon,authenticated;
grant select on public.em_teachers,public.em_classes,public.em_tasks,
 public.em_results,public.em_mail_queue to authenticated;
grant update(display_name,report_email) on public.em_teachers to authenticated;
grant insert on public.em_classes,public.em_tasks to authenticated;
grant update(name,archived) on public.em_classes to authenticated;
grant update(title,instructions,class_id,questions,is_open,published_at,due_at)
 on public.em_tasks to authenticated;
grant update(teacher_feedback,reviewed) on public.em_results to authenticated;
create policy teacher_self on public.em_teachers for select to authenticated
 using(user_id=(select auth.uid()));
create policy teacher_settings on public.em_teachers for update to authenticated
 using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create policy classes_own on public.em_classes for select to authenticated
 using(teacher_id=(select auth.uid()));
create policy classes_insert on public.em_classes for insert to authenticated
 with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_teachers where user_id=(select auth.uid())));
create policy classes_update on public.em_classes for update to authenticated
 using(teacher_id=(select auth.uid())) with check(teacher_id=(select auth.uid()));
create policy tasks_own on public.em_tasks for select to authenticated
 using(teacher_id=(select auth.uid()));
create policy tasks_insert on public.em_tasks for insert to authenticated
 with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_classes c where c.id=class_id and c.teacher_id=(select auth.uid())));
create policy tasks_update on public.em_tasks for update to authenticated
 using(teacher_id=(select auth.uid())) with check(teacher_id=(select auth.uid()) and exists(
 select 1 from public.em_classes c where c.id=class_id and c.teacher_id=(select auth.uid())));
create policy results_own on public.em_results for select to authenticated
 using(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())));
create policy results_review on public.em_results for update to authenticated
 using(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())))
 with check(exists(select 1 from public.em_tasks t where t.id=task_id and t.teacher_id=(select auth.uid())));
create policy mail_own on public.em_mail_queue for select to authenticated
 using(teacher_id=(select auth.uid()));

create function public.em_validate_task() returns trigger language plpgsql
set search_path=pg_catalog,public as $$
declare q jsonb; o jsonb;
begin
 if not exists(select 1 from public.em_classes c where c.id=new.class_id
 and c.teacher_id=new.teacher_id and not c.archived) then
 raise exception 'Choose an active class'; end if;
 if tg_op='UPDATE' and old.published_at is not null then
 if new.questions is distinct from old.questions or new.class_id is distinct from old.class_id
 or new.title is distinct from old.title or new.published_at is distinct from old.published_at
 or new.instructions is distinct from old.instructions then
 raise exception 'Published content is fixed. Duplicate the assignment to edit it.'; end if;
 end if;
 if jsonb_typeof(new.questions) is distinct from 'array' then raise exception 'Invalid questions'; end if;
 if jsonb_array_length(new.questions) not between 1 and 50 then raise exception 'Use 1 to 50 questions'; end if;
 for q in select value from jsonb_array_elements(new.questions) loop
 if jsonb_typeof(q->'prompt') is distinct from 'string'
 or length(trim(q->>'prompt')) not between 1 and 1000 then raise exception 'Invalid question'; end if;
 if jsonb_typeof(q->'options') is distinct from 'array' then raise exception 'Invalid options'; end if;
 if jsonb_array_length(q->'options')<>3 then raise exception 'Use three answer options'; end if;
 for o in select value from jsonb_array_elements(q->'options') loop
 if jsonb_typeof(o) is distinct from 'string' or length(trim(o#>>'{}')) not between 1 and 300
 then raise exception 'Invalid answer option'; end if; end loop;
 if (select count(distinct lower(trim(value))) from jsonb_array_elements_text(q->'options'))<>3
 then raise exception 'Answer options must be different'; end if;
 if jsonb_typeof(q->'answer') is distinct from 'number' or (q->>'answer') not in ('0','1','2')
 then raise exception 'Invalid answer key'; end if;
 if jsonb_typeof(q->'explanation') is distinct from 'string'
 or length(trim(q->>'explanation')) not between 1 and 2000 then raise exception 'Add an explanation'; end if;
 end loop;
 if new.is_open and new.published_at is null then raise exception 'Publish first'; end if;
 return new;
end $$;
create trigger em_task_check before insert or update on public.em_tasks
 for each row execute function public.em_validate_task();

create function public.em_get_class(p_code text) returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare c public.em_classes%rowtype; ts jsonb;
begin
 if p_code is null or length(trim(p_code))<>32 then raise exception 'Invalid class code'; end if;
 select * into c from public.em_classes where code=lower(trim(p_code)) and not archived;
 if not found then raise exception 'Class not found'; end if;
 select coalesce(jsonb_agg(jsonb_build_object('title',title,'code',code,'due_at',due_at)
 order by created_at desc),'[]') into ts from public.em_tasks where class_id=c.id
 and is_open and published_at is not null and (due_at is null or due_at>now());
 return jsonb_build_object('name',c.name,'tasks',ts);
end $$;
create function public.em_get_task(p_code text) returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare t public.em_tasks%rowtype; qs jsonb; cn text;
begin
 if p_code is null or length(trim(p_code))<>32 then raise exception 'Invalid assignment code'; end if;
 select t0.* into t from public.em_tasks t0 join public.em_classes c on c.id=t0.class_id
 where t0.code=lower(trim(p_code)) and t0.is_open and t0.published_at is not null
 and (t0.due_at is null or t0.due_at>now()) and not c.archived;
 if not found then raise exception 'Assignment not found, closed or overdue'; end if;
 select name into cn from public.em_classes where id=t.class_id;
 select jsonb_agg(jsonb_build_object('prompt',value->'prompt','options',value->'options') order by ord)
 into qs from jsonb_array_elements(t.questions) with ordinality as x(value,ord);
 return jsonb_build_object('id',t.id,'code',t.code,'title',t.title,'class_name',cn,
 'instructions',t.instructions,'due_at',t.due_at,'questions',qs);
end $$;
create function public.em_submit_task(p_code text,p_attempt_id uuid,p_student_name text,
 p_answers jsonb,p_writing text default '') returns jsonb language plpgsql
security definer set search_path=pg_catalog,public as $$
declare t public.em_tasks%rowtype; old_result jsonb; details jsonb:='[]'; q jsonb;
 a jsonb; choice integer; expected integer; points integer:=0; total integer;
 i integer; final_result jsonb; cn text;
begin
 if p_code is null or length(trim(p_code))<>32 or p_attempt_id is null then raise exception 'Invalid attempt'; end if;
 if p_student_name is null or length(trim(p_student_name)) not between 1 and 100
 then raise exception 'Enter your name'; end if;
 if length(coalesce(p_writing,''))>5000 then raise exception 'Writing is too long'; end if;
 select * into t from public.em_tasks where code=lower(trim(p_code)) and published_at is not null for update;
 if not found then raise exception 'Assignment not found'; end if;
 select result into old_result from public.em_results where task_id=t.id and attempt_id=p_attempt_id;
 if found then return old_result; end if;
 select name into cn from public.em_classes where id=t.class_id and not archived;
 if not found or not t.is_open or (t.due_at is not null and t.due_at<=now())
 then raise exception 'Assignment closed or overdue'; end if;
 if jsonb_typeof(p_answers) is distinct from 'array' then raise exception 'Invalid answers'; end if;
 total:=jsonb_array_length(t.questions);
 if jsonb_array_length(p_answers)<>total then raise exception 'Answer every question'; end if;
 for i in 0..total-1 loop
 a:=p_answers->i;
 if jsonb_typeof(a) is distinct from 'number' or (a#>>'{}') not in ('0','1','2')
 then raise exception 'Answer every question'; end if;
 q:=t.questions->i; choice:=(a#>>'{}')::integer; expected:=(q->>'answer')::integer;
 if choice=expected then points:=points+1; end if;
 details:=details||jsonb_build_array(jsonb_build_object('prompt',q->>'prompt',
 'unit',coalesce(q->>'unit','custom'),'chosen',q->'options'->>choice,
 'expected',q->'options'->>expected,'correct',choice=expected,'explanation',q->>'explanation'));
 end loop;
 final_result:=jsonb_build_object('student_name',trim(p_student_name),'class_name',cn,
 'title',t.title,'score',points,'total',total,'details',details,'writing',coalesce(p_writing,''));
 insert into public.em_results(task_id,attempt_id,student_name,class_name,answers,score,total,result,writing)
 values(t.id,p_attempt_id,trim(p_student_name),cn,p_answers,points,total,final_result,coalesce(p_writing,''));
 return final_result;
end $$;
create function public.em_queue_report() returns trigger language plpgsql
security definer set search_path=pg_catalog,public as $$
declare owner_id uuid; addr text;
begin
 select t.teacher_id,p.report_email into owner_id,addr from public.em_tasks t
 join public.em_teachers p on p.user_id=t.teacher_id where t.id=new.task_id;
 if coalesce(trim(addr),'')<>'' then
 insert into public.em_mail_queue(result_id,teacher_id,recipient) values(new.id,owner_id,addr);
 end if; return new;
end $$;
create trigger em_report_queue after insert on public.em_results
 for each row execute function public.em_queue_report();
revoke all on function public.em_get_class(text),public.em_get_task(text),
 public.em_submit_task(text,uuid,text,jsonb,text) from public;
grant execute on function public.em_get_class(text),public.em_get_task(text),
 public.em_submit_task(text,uuid,text,jsonb,text) to anon,authenticated;
commit;

-- An attempt UUID acts as the learner's receipt. It is never listed publicly.
create function public.em_get_result(p_code text,p_attempt_id uuid) returns jsonb
language plpgsql security definer set search_path=pg_catalog,public as $$
declare r public.em_results%rowtype;
begin
 if p_code is null or length(trim(p_code))<>32 or p_attempt_id is null then raise exception 'Invalid receipt'; end if;
 select r0.* into r from public.em_results r0 join public.em_tasks t on t.id=r0.task_id
 where t.code=lower(trim(p_code)) and r0.attempt_id=p_attempt_id;
 if not found then raise exception 'Result not found'; end if;
 return jsonb_build_object('teacher_feedback',r.teacher_feedback,'reviewed',r.reviewed);
end $$;
revoke all on function public.em_get_result(text,uuid) from public;
grant execute on function public.em_get_result(text,uuid) to anon,authenticated;

-- Optional mail worker. No browser role can claim or modify mail jobs.
alter table public.em_mail_queue add column lease_until timestamptz;
create function public.em_claim_mail(p_limit integer default 5) returns setof public.em_mail_queue
language sql security definer set search_path=pg_catalog,public as $$
 update public.em_mail_queue q set lease_until=now()+interval '5 minutes',attempts=attempts+1
 where q.id in(select id from public.em_mail_queue where status='pending'
 and (lease_until is null or lease_until<now()) order by created_at
 for update skip locked limit greatest(1,least(coalesce(p_limit,5),10))) returning q.*;
$$;
revoke all on function public.em_claim_mail(integer) from public,anon,authenticated;
grant execute on function public.em_claim_mail(integer) to service_role;
grant select,update on public.em_mail_queue to service_role;
grant select on public.em_results to service_role;
