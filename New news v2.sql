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
item_type,
datediff('day',index_ts_min,index_ts_max) as days_between_first_and_last_seen,
count(distinct(item_id)) as item_id_distinct_count

from (
select item_id, item_type, 
max(index_ts) as index_ts_max,
min(index_ts) as index_ts_min,
sum(news_seen_for_gt1_time) as item_id_times_seen
from

(select index_ts, 
item_id, item_type, profile_id,
lag(item_id,1) over (partition by item_id order by index_ts) as item_id_lag1,
lag(index_ts,1) over (partition by item_id order by index_ts) as index_ts_lag1,
case when lag(item_id,1) over (partition by item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events 
where event_name='FeedItemViewed'
and item_id not in ('')
order by 2,1
) group by 1,2
) group by 1,2,3


---how do I get this on a user basis; what proportion of what a user sees on each page load? is new for them?


select * from  mendeley.ros_social_feed_events limit 10
'FeedItemDisplayed             ' --only page load id on displayed events

select distinct item_type, section from mendeley.ros_social_feed_events




--hoe do you get back on apage laod ID basis, how much news is new per page load?
select item_id_times_seen, 
item_type,
datediff('day',index_ts_min,index_ts_max) as days_between_first_and_last_seen,
count(distinct(item_id)) as item_id_distinct_count

from (
select item_id, item_type, 
max(index_ts) as index_ts_max,
min(index_ts) as index_ts_min,
sum(news_seen_for_gt1_time) as item_id_times_seen
from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
lag(item_id,1) over (partition by item_id order by index_ts) as item_id_lag1,
lag(index_ts,1) over (partition by item_id order by index_ts) as index_ts_lag1,
case when lag(item_id,1) over (partition by item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events 
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 2,1
) group by 1,2
) group by 1,2,3




0  = only ever seen once
1  = first time in a sequence
>2 = more than first time in a sequence

--how do I compensate for page load id's


---working query on index_ts basis with above rules
select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1




---rolling count per page load id so you can exclude whee they are seen mor ethan once in same page load, not sure how that is possible but whatever

select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id, page_load_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item_per_pageload

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id, page_load_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1



---mega query that works yay
with A as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events order by 1,2,3 limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1)
, B as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id, page_load_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item_per_pageload

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id, page_load_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events order by 1,2,3 limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1
)


select A.*, b.rolling_sum_per_user_per_item_per_pageload,
case when rolling_sum_per_user_per_item>=2 and rolling_sum_per_user_per_item_per_pageload=0 then 1 else 0 end as item_seen_before

from A
left join B 
on a.index_ts=b.index_ts
and a.item_id=b.item_id
and a.profile_id=b.profile_id
and a.page_load_id=b.page_load_id



---mega query that works yay with limits removed
with A as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events order by 1,2,3 limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1)
, B as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id, page_load_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item_per_pageload

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id, page_load_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from (select * from mendeley.ros_social_feed_events order by 1,2,3 limit 10000)
where event_name='FeedItemDisplayed             '
and item_id not in ('')
order by 4,2) 
order by 2,3,1
)


select profile_id, 
index_ts, 
page_load_id,
sum(item_seen_before) as item_seen_before_sum, 
count(*) as items_displayed, 
cast(sum(item_seen_before) as real) /cast(count(*) as real) as proportion_of_loaded_items_seen_before

from (

select A.*, b.rolling_sum_per_user_per_item_per_pageload,
case when rolling_sum_per_user_per_item>=2 and rolling_sum_per_user_per_item_per_pageload=0 then 1 else 0 end as item_seen_before

from A
left join B 
on a.index_ts=b.index_ts
and a.item_id=b.item_id
and a.profile_id=b.profile_id
and a.page_load_id=b.page_load_id
)
group by 1,2,3



----full extract

with A as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
and index_ts>='2017-10-01' and index_ts<'2017-11-01' 
order by 4,2) 
order by 2,3,1)
, B as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id, page_load_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item_per_pageload

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id, page_load_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
and index_ts>='2017-10-01' and index_ts<'2017-11-01' 
order by 4,2) 
order by 2,3,1
)


select profile_id, 
index_ts, 
page_load_id,
sum(item_seen_before) as item_seen_before_sum, 
count(*) as items_displayed, 
cast(sum(item_seen_before) as real) /cast(count(*) as real) as proportion_of_loaded_items_seen_before

from (

select A.*, b.rolling_sum_per_user_per_item_per_pageload,
case when rolling_sum_per_user_per_item>=2 and rolling_sum_per_user_per_item_per_pageload=0 then 1 else 0 end as item_seen_before

from A
left join B 
on a.index_ts=b.index_ts
and a.item_id=b.item_id
and a.profile_id=b.profile_id
and a.page_load_id=b.page_load_id
)
group by 1,2,3






select count(*) from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
and index_ts>='2017-10-01' and index_ts<'2017-11-01' 

11,728,235

833,894

316,869,755

select * from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
and item_type='new-coauthor-pub'
limit 100
--------------




with A as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
--and index_ts>='2017-10-01' and index_ts<'2017-11-01' 
and item_type not in ('education-update','employment-update','group-doc-added','group-status-posted','new-coauthor-pub','new-document-citations','new-follower','new-pub','new-status','posted-catalogue-pub','posted-pub')
order by 4,2) 
order by 2,3,1)
, B as (select index_ts, item_id, profile_id, page_load_id, item_type,
sum(news_seen_for_gt1_time) over (partition by item_id, profile_id, page_load_id order by index_ts rows unbounded preceding) as rolling_sum_per_user_per_item_per_pageload

from

(select index_ts, 
item_id, item_type, profile_id, page_load_id, 
case when lag(item_id,1) over (partition by profile_id, item_id, page_load_id order by index_ts) is null then 0 else 1 end as news_seen_for_gt1_time

from mendeley.ros_social_feed_events
where event_name='FeedItemDisplayed             '
and item_id not in ('')
--and index_ts>='2017-10-01' and index_ts<'2017-11-01' 
and item_type not in ('education-update','employment-update','group-doc-added','group-status-posted','new-coauthor-pub','new-document-citations','new-follower','new-pub','new-status','posted-catalogue-pub','posted-pub')
order by 4,2) 
order by 2,3,1
)


select profile_id, 
index_ts, 
page_load_id,
sum(item_seen_before) as item_seen_before_sum, 
count(*) as items_displayed, 
cast(sum(item_seen_before) as real) /cast(count(*) as real) as proportion_of_loaded_items_seen_before

from (

select A.*, b.rolling_sum_per_user_per_item_per_pageload,
case when rolling_sum_per_user_per_item>=2 and rolling_sum_per_user_per_item_per_pageload=0 then 1 else 0 end as item_seen_before

from A
left join B 
on a.index_ts=b.index_ts
and a.item_id=b.item_id
and a.profile_id=b.profile_id
and a.page_load_id=b.page_load_id
)
group by 1,2,3



----need to create a user genrated news category and auto generaed news category


