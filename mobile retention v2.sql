---original

with main as (
select	
profile_id,
date_trunc('week',ts) as week, 
client_id,
max(case when client_id in (7,808) and event_name in ('RecommendationServed') then 1 else 0 end) mobile_suggest_views,
max(case when client_id in (7,808) and event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views
					
from mendeley.live_events_201610_to_present
where client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') and ts<date_trunc('week',getdate()) and ts>=date_trunc('week',getdate()-180)
group by 1,2,3
)

select a.*,
b.week_first_on_product,
datediff('week',week_first_on_product,week) as tenure_weeks


from main a
left join (
select 
profile_id,
client_id,
mobile_suggest_views,
mobile_feed_views,
min(week) as week_first_on_product
from main group by 1,2,3,4
) b
on a.profile_id=b.profile_id
and a.client_id=b.client_id
and a.mobile_suggest_views=b.mobile_suggest_views
and a.mobile_feed_views=b.mobile_feed_views




----just original month number

with main as (
select	
profile_id,
date_trunc('week',ts) as week, 
client_id,
max(case when client_id in (7,808) and event_name in ('RecommendationServed') then 1 else 0 end) mobile_suggest_views,
max(case when client_id in (7,808) and event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views
					
from mendeley.live_events_201610_to_present
where client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') and ts<date_trunc('week',getdate()) and ts>=date_trunc('week',getdate()-180)
group by 1,2,3
)

select 
profile_id,
client_ID,
mobile_suggest_views,
mobile_feed_views,
min(week) as cohort_week

from main 
group by 1,2,3,4


---step 2
with main as (
select	
profile_id,
date_trunc('week',ts) as week, 
client_id,
max(case when client_id in (7,808) and event_name in ('RecommendationServed') then 1 else 0 end) mobile_suggest_views,
max(case when client_id in (7,808) and event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views
					
from mendeley.live_events_201610_to_present
where client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') and ts<date_trunc('week',getdate()) and ts>=date_trunc('week',getdate()-180)
group by 1,2,3
)


select client_ID,
mobile_suggest_views,
mobile_feed_views,
cohort_week,
count(distinct(profile_id)) as users_in_original_week
from (

select 
profile_id,
client_ID,
mobile_suggest_views,
mobile_feed_views,
min(week) as cohort_week

from main 
  group by 1,2,3,4
) group by 1,2,3,4


--- now combine

with main as (
select	
profile_id,
date_trunc('week',ts) as week, 
client_id,
max(case when client_id in (7,808) and event_name in ('RecommendationServed') then 1 else 0 end) mobile_suggest_views,
max(case when client_id in (7,808) and event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views
					
from mendeley.live_events_201610_to_present
where client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') and ts<date_trunc('week',getdate()) and ts>=date_trunc('week',getdate()-180)
group by 1,2,3
)

select a.profile_id,
a.week,
a.client_id,
a.mobile_suggest_views,
a.mobile_feed_views,
b.week_first_on_product,
datediff('week',week_first_on_product,week) as tenure_weeks,
max(users_in_original_week) as users_in_original_week


from main a
left join (
select 
profile_id,
client_id,
mobile_suggest_views,
mobile_feed_views,
min(week) as week_first_on_product
from main group by 1,2,3,4
) b
on a.profile_id=b.profile_id
and a.client_id=b.client_id
and a.mobile_suggest_views=b.mobile_suggest_views
and a.mobile_feed_views=b.mobile_feed_views
left join (select client_ID,
mobile_suggest_views,
mobile_feed_views,
cohort_week,
count(distinct(profile_id)) as users_in_original_week
from (

select 
profile_id,
client_ID,
mobile_suggest_views,
mobile_feed_views,
min(week) as cohort_week

from main 
  group by 1,2,3,4
) group by 1,2,3,4) c
on  a.client_id=c.client_id
and a.mobile_suggest_views=c.mobile_suggest_views
and a.mobile_feed_views=c.mobile_feed_views
and b.week_first_on_product=c.cohort_week
group by 1,2,3,4,5,6,7


--and again but just by client


with main as (
select	
profile_id,
date_trunc('week',ts) as week, 
client_id,
max(case when client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') then 1 else 0 end) mobile_social_views
					
from mendeley.live_events_201610_to_present
where client_id in (7,808) and event_name in ('RecommendationServed','FeedItemViewed') and ts<date_trunc('week',getdate()) and ts>=date_trunc('week',getdate()-180)
group by 1,2,3
)

select a.profile_id,
a.week,
a.client_id,
b.week_first_on_product,
datediff('week',week_first_on_product,week) as tenure_weeks,
max(users_in_original_week) as users_in_original_week


from main a
left join (
select 
profile_id,
client_id,
min(week) as week_first_on_product
from main group by 1,2
) b
on a.profile_id=b.profile_id
and a.client_id=b.client_id
left join (select client_ID,
cohort_week,
count(distinct(profile_id)) as users_in_original_week
from (

select 
profile_id,
client_ID,
min(week) as cohort_week

from main 
  group by 1,2
) group by 1,2) c
on  a.client_id=c.client_id
and b.week_first_on_product=c.cohort_week
group by 1,2,3,4,5