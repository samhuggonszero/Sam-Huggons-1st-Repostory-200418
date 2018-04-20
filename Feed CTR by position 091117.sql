select * from mendeley.ros_social_feed_events limit 1000

select date_trunc('month',index_ts),event_name, client_id, item_type, count(*) from mendeley.ros_social_feed_events group by 1,2,3,4

select * from  mendeley.newsfeed_events_per_day limit 100

select date_trunc('month',index_ts), client_id, item_type,  sum(clicked_items), sum(viewed_items) from  mendeley.newsfeed_events_per_day group by 1,2,3




select z.client_id, z.index_ts, z.item_type, z.views, z.average_position_when_viewed, case when x.clicks  is null then 0 else  x.clicks end as clicks

from (
select client_id, 
index_ts, 
item_type, 
sum(views) as views, 
sum(cast(sumproduct as decimal(10,4)))/sum(cast(views as decimal(10,4))) as average_position_when_viewed

from (
select client_id,
index_ts,
item_type, 
position_integer,
views,
position_integer*views as sumproduct

from (
select client_id,
date_trunc('month',index_ts) as index_ts,
item_type, 
cast(position_index as integer) as position_integer,
count(*) as views

from mendeley.ros_social_feed_events 
where event_name='FeedItemViewed                '
and position_index not in ('')
and date_trunc('month',index_ts) < date_trunc('month',getdate())
group by 1,2,3,4
)) a
group by 1,2,3 ) z
left join (select client_id, 
date_trunc('month',index_ts) as index_ts,
item_type, 
count(*) as clicks

from mendeley.ros_social_feed_events where event_name='FeedItemClicked               ' group by 1,2,3) x
on z.client_id=x.client_id 
and z.index_ts=x.index_ts
and z.item_type=x.item_type




-------------------------------
select z.client_id,
z.index_ts,
z.item_type, 
position_integer,
views,
position_integer*views as sumproduct,
clicks

from (
select client_id,
date_trunc('month',index_ts) as index_ts,
item_type, 
cast(position_index as integer) as position_integer,
count(*) as views

from mendeley.ros_social_feed_events 
where event_name='FeedItemViewed                '
and position_index not in ('')
and date_trunc('month',index_ts) < date_trunc('month',getdate())
group by 1,2,3,4
) z
left join (select client_id, 
date_trunc('month',index_ts) as index_ts,
item_type, 
count(*) as clicks

from mendeley.ros_social_feed_events where event_name='FeedItemClicked               ' group by 1,2,3) x
on z.client_id=x.client_id 
and z.index_ts=x.index_ts
and z.item_type=x.item_type







select * from mendeley.ros_social_feed_events limit 1000

select item_type, event_name, client_id, date_trunc('month',index_ts) as index_ts, 
case when item_id ='' then 0 else 1 end as item_id, 
count(*) 

from mendeley.ros_social_feed_events 
group by 1,2,3,4,5





