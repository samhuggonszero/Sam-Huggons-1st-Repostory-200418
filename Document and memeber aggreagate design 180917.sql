select group_id, date_added from mendeley.documents 

select profile_id, 
b.uu_group_id as group_id,
joined,
b.name
from mendeley.group_members a
inner join mendeley.groups b
on a.group_id =b.id





--docs added per day
select group_id, 
date_trunc('day',date_added) as date,
count(*) as doc_count

from mendeley.documents 
where group_id is not null
group by 1,2 
order by 3 desc

--members on each day

select a.group_id,
date_trunc('day',joined) as date_joins,
count(distinct(b.profile_id)) as members_on_that_day

from mendeley.group_members a
inner join (
select distinct group_id,
profile_id,
date_trunc('day',joined) as date_joins
from mendeley.group_members
) b
on b.date_joins<=date_trunc('day',a.joined)
and a.group_id=b.group_id
group by 1,2
order by 1,2



--coomm dashb wquery 1
select index_ts, b.group_id, members, 
visibility, invite_only,
count(*) as Events

from mendeley.groups a
inner join mendeley.group_events_per_day b
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
group by 1,2,3,4,5





-------------------------------------------FINAL--------------------------------------------------------
--adding docs + members
select index_ts, 
b.group_id,
members as current_memebers, 
doc_count as doc_count_added_that_day,
visibility, 
invite_only,
a.name,
max(members_on_that_day) as members_on_that_day,
count(*) as Events

from mendeley.groups a
inner join mendeley.group_events_per_day b
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
left join (

select a.group_id,
date_trunc('day',joined) as date_joins,
count(*) as members_on_that_day
from mendeley.group_members a
inner join (
select distinct group_id,
profile_id,
date_trunc('day',joined) as date_joins
from mendeley.group_members

) b
on b.date_joins=date_trunc('day',a.joined)
and a.group_id=b.group_id
group by 1,2
order by 1,2) d
on b.index_ts=d.date_joins
and a.id=d.group_id
left join (select group_id, 
date_trunc('day',date_added) as date,
count(*) as doc_count

from mendeley.documents 
where group_id is not null
group by 1,2 
order by 3 desc) e
on b.group_id=e.group_id
and b.index_ts=e.date
group by 1,2,3,4,5,6,7
order by 2,1


'7accbb9e-2b77-39a4-bd68-f44c6d72f1bd'

---members only

select c.uu_group_id,
date_trunc('day',joined) as date_joins,
visibility, 
invite_only,
name,
count(distinct(b.profile_id)) as members_on_that_day

from mendeley.group_members a
inner join (
select distinct group_id,
profile_id,
date_trunc('day',joined) as date_joins
from mendeley.group_members
) b
on b.date_joins<=date_trunc('day',a.joined)
and a.group_id=b.group_id
left join mendeley.groups c
on a.group_id=c.id
group by 1,2,3,4,5
order by 1,2



