
select event_name,
date_trunc('day',ts),
c.members,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section,
count(*)

from mendeley.live_events_201610_to_present b
left join mendeley.groups a
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where event_name='FeedItemClicked' 
and ts>'2017-03-07' and ts<getdate()
and client_id=3181
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='post-a-status'
group by 1,2,3,4,5


select sum(group_members), count(distinct(group_id)) from (
select distinct group_members, group_id
from mendeley.group_product_cube_per_day
where index_ts>='2017-03-01' and index_ts<'2017-04-01'
and group_id is not null
--and group_members is not null
and event_name in ('GroupViewed','SelectGroup'))


select *
from mendeley.group_product_cube_per_day
where index_ts>='2017-03-01' and index_ts<'2017-04-01'
and group_id is not null
--and group_members is not null
and event_name in ('GroupViewed','SelectGroup')
limit 1000



select sum(members), count(distinct(group_id)) from (
select distinct b.group_id, c.members

from mendeley.group_events_per_day b
left join mendeley.groups a
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where event_name in ('GroupViewed','SelectGroup')
and index_ts>='2017-03-01' and index_ts<'2017-04-01'
)





select event_name,
date_trunc('day',ts),
c.members,
group_id,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section,
count(*)

from mendeley.live_events_latest b
left join mendeley.groups a
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where event_name='FeedItemClicked' 
and ts>'2017-03-07' and ts<getdate()
and client_id=2364
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='post-a-status'
group by 1,2,3,4,5



select * from mendeley.live_events_latest where client_id=2364
and date_trunc('day',ts)='2017-09-01'
and event_name= 'FeedItemClicked' and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='post-a-status' 
and JSON_EXTRACT_PATH_TEXT(properties, 'section')='post_button' 
and group_id is not null
limit 100

'{"pageLoadId":"1066dcf4465.7fe","section":"post_button","filter":"all","itemId":"post-a-status","itemType":"post-a-status"}'

'{"pageLoadId":"11b11b9aa26.9a2","section":"textarea","filter":"all","itemId":"post-a-status","groupType":"private","itemType":"post-a-status"}'


c.members,
b.group_id,

date_trunc('day',ts),







select event_name,
JSON_EXTRACT_PATH_TEXT(properties, 'groupType') as groupType,
JSON_EXTRACT_PATH_TEXT(properties, 'filter') as filter,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section,
count(*)

from mendeley.live_events_latest b
left join mendeley.groups a
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where event_name='FeedItemClicked' 
and ts>'2017-03-07' and ts<getdate()
and client_id=2364
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='post-a-status'
and JSON_EXTRACT_PATH_TEXT(properties, 'section')='post_button'
group by 1,2,3,4,5



select event_name,
date_trunc('day',ts),
client_id,
JSON_EXTRACT_PATH_TEXT(properties, 'groupType') as groupType,
JSON_EXTRACT_PATH_TEXT(properties, 'filter') as filter,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section,
count(*)

from mendeley.live_events_201610_to_present b
left join mendeley.groups a
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
where event_name='FeedItemClicked' 
and ts>'2017-03-07' and ts<getdate()
and client_id in (2364,3181)
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='post-a-status'
and JSON_EXTRACT_PATH_TEXT(properties, 'section')='post_button'
group by 1,2,3,4,5,6,7







JSON_EXTRACT_PATH_TEXT(properties, 'groupType') as groupType
JSON_EXTRACT_PATH_TEXT(properties, 'filter') as filter


select * from newsfeed_status_post_events_per_day