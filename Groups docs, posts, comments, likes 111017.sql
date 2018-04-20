select a.uu_group_id, a.name, a.description, index_ts, event_name, event_count, members,visibility, created, invite_only, is_deleted 

from mendeley.groups a
left join (select * from mendeley.group_events_per_day
union all 
select 
profile_id,
client_id,
json_extract_path_text(properties, 'section') as event_name,
group_id, 
date_trunc('day',ts) as index_ts,
count(*) as event_count

from mendeley.live_events_201610_to_present
where ts>'2017-03-06' and ts<getdate()
and client_id=3181 and event_name in ('FeedItemClicked')
group by 1,2,3,4,5
union all
select 
profile_id,
client_id,
case when json_extract_path_text(properties, 'section') is null then event_name else json_extract_path_text(properties, 'section') end as event_name,
group_id, 
date_trunc('day',ts) as index_ts,
count(*) as event_count

from mendeley.live_events_201610_to_present
where ts>'2017-03-06' and ts<getdate()
and client_id=2364 and event_name in ('FeedItemClicked')
and group_id in (select uu_group_id from mendeley.groups)
group by 1,2,3,4,5

) b
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where index_ts>getdate()-365


-------------Documents

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
on b.date_joins<=date_trunc('day',a.joined)
and a.group_id=b.group_id
group by 1,2
order by 1,2) d
on b.index_ts=d.date_joins
and a.id=d.group_id
left join (select group_id, 
date_trunc('day',date_added) as date,
count(*) as doc_count

from spectrum_docs.documents
where group_id is not null
group by 1,2 
order by 3 desc) e
on b.group_id=e.group_id
and b.index_ts=e.date
group by 1,2,3,4,5,6,7

--------posts

select profile_id,
client_id,
json_extract_path_text(properties, 'section') as event_name,
group_id, 
date_trunc('day',ts) as index_ts,
visibility, 
invite_only,
name,
count(*) as event_count 

from mendeley.live_events_201610_to_present a
left join mendeley.groups b
on a.group_id=b.uu_group_id
where (json_extract_path_text(properties, 'section')='post_button'
and ts>'2017-03-06' and ts<getdate()
and client_id=3181 and event_name in ('FeedItemClicked'))

or 

(json_extract_path_text(properties, 'section')='post_button'
and ts>'2017-03-06' and ts<getdate()
and client_id=2364 and event_name in ('FeedItemClicked')
and group_id in (select uu_group_id from mendeley.groups))

group by 1,2,3,4,5,6,7,8


--------comments

select profile_id,
client_id,
json_extract_path_text(properties, 'section') as event_name,
group_id, 
date_trunc('day',ts) as index_ts,
visibility, 
invite_only,
name,
count(*) as event_count 

from mendeley.live_events_201610_to_present a
left join mendeley.groups b
on a.group_id=b.uu_group_id
where (json_extract_path_text(properties, 'section')='comment_added'
and ts>'2017-03-06' and ts<getdate()
and client_id=3181 and event_name in ('FeedItemClicked'))

or 

(json_extract_path_text(properties, 'section')='comment_added'
and ts>'2017-03-06' and ts<getdate()
and client_id=2364 and event_name in ('FeedItemClicked')
and group_id in (select uu_group_id from mendeley.groups))

group by 1,2,3,4,5,6,7,8


---group Views

GroupViewed



-----members
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







------------------mega combined query -- minimum information - zero if null


select date,
name,
group_id,
Doc_adds,
Posts,
comments,
members_added,
views

