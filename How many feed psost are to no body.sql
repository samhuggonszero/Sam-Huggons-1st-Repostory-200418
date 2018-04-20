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




select * from mendeley.profile_followers limit 10


select a.*,
case when followers is null then 0 else followers end as followers,
case when following is null then 0 else following end as following,
case when group_id is null then 0 else 1 end as group_post_flag,
case when group_members is null then 0 else group_members end as group_members

from mendeley.ros_social_feed_events a 
left join (select followee_id, count(distinct(follower_id)) as followers from mendeley.profile_followers group by 1) b
on a.profile_id=b.followee_id
left join (select follower_id, count(distinct(followee_id)) as following from mendeley.profile_followers group by 1) d
on a.profile_id=d.follower_id
left join (select uu_group_id, count(distinct(profile_id)) as group_members from mendeley.group_members a
left join mendeley.groups b
on a.group_id=b.id group by 1) c
on a.group_id=c.uu_group_id
where client_id in (2364,3181)
and item_type = 'post-a-status'
and section = 'post_button'


select followers, count(*) from (select followee_id, count(*) as followers from mendeley.profile_followers group by 1) group by 1 order by 2 desc
select followers, count(*) from (select followee_id, count(distinct(follower_id))  as followers from mendeley.profile_followers group by 1) group by 1 order by 2 desc

select following, count(*) from (select follower_id,  count(*) as following from mendeley.profile_followers group by 1) group by 1 order by 2 desc
select following, count(*) from (select follower_id,  count(distinct(followee_id)) as following from mendeley.profile_followers group by 1) group by 1 order by 2 desc




select * from  mendeley.ros_social_feed_events




select a.*,
case when followers is null then 0 else followers end as followers,
case when following is null then 0 else following end as following,
case when group_id is null then 0 else 1 end as group_post_flag,
case when group_members is null then 0 else group_members end as group_members

from mendeley.ros_social_feed_events a 
left join (select followee_id, count(distinct(follower_id)) as followers from mendeley.profile_followers group by 1) b
on a.profile_id=b.followee_id
left join (select follower_id, count(distinct(followee_id)) as following from mendeley.profile_followers group by 1) d
on a.profile_id=d.follower_id
left join (select uu_group_id, count(distinct(profile_id)) as group_members from mendeley.group_members a
left join mendeley.groups b
on a.group_id=b.id group by 1) c
on a.group_id=c.uu_group_id
where client_id in (2364,3181)
and item_type = 'new-status'	



---how much new news does the user see each time they return
--% of news they see each viist which is new
--% of visits which contine no new news???
---distribution of news items and how often theya are seen

select item_id_times_seen,
count(distinct(item_id)) as item_id_distinct_count

from (
select item_id, 
sum(news_seen_for_gt1_time) as item_id_times_seen
from

(select index_ts, 
item_id,
lag(item_id,1) over (partition by item_id order by index_ts) as item_id_lag1,
lag(index_ts,1) over (partition by item_id order by index_ts) as index_ts_lag1,
case when lag(item_id,1) over (partition by item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events 
where event_name='FeedItemViewed'
and item_id not in ('')
order by 2,1
) group by 1
) group by 1
order by 1 

select * from mendeley.ros_social_feed_events  where item_id='0000089e-332c-45f4-b0c8-ef95c7a95e03'


----------------------------------Profile ID	Index_ts	item_ID	itemid||profile_id


select item_id_times_seen,
count(distinct(item_id)) as item_id_distinct_count

from (
select item_id, 
sum(news_seen_for_gt1_time) as item_id_times_seen
from

(select index_ts, 
item_id,
lag(item_id,1) over (partition by item_id order by index_ts) as item_id_lag1,
lag(index_ts,1) over (partition by item_id order by index_ts) as index_ts_lag1,
case when lag(item_id,1) over (partition by item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events 
where event_name='FeedItemViewed'
and item_id not in ('')
order by 2,1
) group by 1
) group by 1
order by 1 



mendeley.ros_social_feed_events 




select
date_diff,
count(*)
from
(select profile_id, document_id, datediff(day, min(ts), max(ts))
from ()
where event_name = 'SwitchToPdfInternalViewer' and client_id = 6
group by 1, 2)
group by 1






with main as (
select * from spectrum.fact_request_201401 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201402 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201403 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201404 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201405 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201406 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201407 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201408 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201409 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201410 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201411 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201412 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201501 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201502 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201503 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201504 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201505 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201506 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201507 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201508 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201509 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201510 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201511 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201512 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201601 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201602 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201603 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201604 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201605 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201606 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201607 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201608 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201609 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201610 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201611 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201612 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201701 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201702 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201703 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201704 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201705 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201706 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201707 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201708 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 union all
select * from spectrum.fact_request_201709 where event_name = 'SwitchToPdfInternalViewer' and client_id = 6 
)


select
date_diff,
count(*) as doc_people,
count(distinct(document_id)) as document_id_distinct,
count(distinct(profile_id)) as profile_id_distinct
from
(select profile_id, document_id, datediff(day, min(request_start_time), max(request_start_time))
from main
where event_name = 'SwitchToPdfInternalViewer' and client_id = 6
group by 1,2
having min(request_start_time) <'2017-04-01' )
group by 1



(select document_id, min(request_start_time) as first_doc_read_ate
from main
where event_name = 'SwitchToPdfInternalViewer' and client_id = 6
group by 1)



select * from spectrum_doc.documents limit 10