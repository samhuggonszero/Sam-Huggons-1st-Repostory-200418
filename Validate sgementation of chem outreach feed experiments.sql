4876
select count(distinct(profile_id)) from mendeley.ros_social_feed_events where item_type like '%chem%'

972
select count(distinct(profile_id)) 

from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2017-11-01' and index_ts<'2017-12-01'



select index_ts,
a.profile_id

from mendeley.active_users a
inner join (select distinct profile_id

from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b
on a.profile_id=b.profile_id

where a.index_ts>='2017-11-01' and a.index_ts<'2017-12-01'


--66.2% retention for nov17 chem card viewers 

select index_ts,
count(distinct(a.profile_id)) as users

from mendeley.active_users a
inner join (select distinct profile_id

from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b
on a.profile_id=b.profile_id

where a.index_ts>='2017-11-01' and a.index_ts<'2017-12-31'
group by 1

-------so segment that by tenure and user role, also do feed to feed retention, daily retention, frequency active, 



select index_ts,
a.profile_id,
user_role,
datediff('month',joined,index_ts) as tenure_months,
joined

from mendeley.active_users a
inner join (select distinct profile_id

from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b
on a.profile_id=b.profile_id
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
where a.index_ts>='2017-11-01' and a.index_ts<'2017-12-31'


---product usage segemntation
select distinct date_trunc('month',index_ts) as month,
a.profile_id,
client_id,
name_ana

from mendeley.active_users_by_client_per_day a
inner join (select distinct profile_id

from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b
on a.profile_id=b.profile_id
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
inner join mendeley.oauth2map d
on a.client_id=d.id
where a.index_ts>='2017-11-01' and a.index_ts<'2017-12-31'



----------daily activity trends -- how do you make this relevent to how mnay people could have a view on that day so active /potential that could be active
---how do you compare this to a user base which is similar
select index_ts,
datediff('day',first_card_viewed,index_ts) as days_since_first_card_view,
count(distinct(a.profile_id)) as active_users

from mendeley.active_users_by_client_per_day a
inner join (select distinct profile_id
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b

on a.profile_id=b.profile_id
left join mendeley.profiles c

on a.profile_id=c.uu_profile_id
inner join mendeley.oauth2map d
on a.client_id=d.id

left join (select profile_id, min(index_ts) as first_card_viewed
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01' group by 1
) e
on a.profile_id=e.profile_id

where a.index_ts>='2017-10-01' and a.index_ts<'2017-12-31'
group by 1,2
order by 1


--------------getting closer
select index_ts,
date_trunc('day',first_card_viewed) as first_card_viewed_date,
case when joined<='2017-10-01' then 1 else 0 end as joined_pre_oct17_flag,
datediff('month',joined,index_ts) as tenure_month,
datediff('year',joined,index_ts) as tenure_year,
datediff('day',first_card_viewed,index_ts) as days_since_first_card_view,
count(distinct(a.profile_id)) as active_users

from mendeley.active_users_by_client_per_day a
inner join (select distinct profile_id
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b

on a.profile_id=b.profile_id
left join mendeley.profiles c

on a.profile_id=c.uu_profile_id
inner join mendeley.oauth2map d
on a.client_id=d.id

left join (select profile_id, min(index_ts) as first_card_viewed
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01' group by 1
) e
on a.profile_id=e.profile_id

where a.index_ts>='2017-10-01' and a.index_ts<'2018-01-15'
group by 1,2,3,4,5,6
order by 1


-----CTR on Feed pre and post seeing a card
select index_ts,
date_trunc('day',first_card_viewed) as first_card_viewed_date,
case when joined<='2017-10-01' then 1 else 0 end as joined_pre_oct17_flag,
--datediff('month',joined,index_ts) as tenure_month,
--datediff('year',joined,index_ts) as tenure_year,
datediff('day',first_card_viewed,index_ts) as days_since_first_card_view,
count(distinct(a.profile_id)) as active_feed_users,
sum(case when event_name='FeedItemViewed' then 1 else 0 end) as cards_viewed,
sum(case when event_name='FeedItemClicked' then 1 else 0 end) as clicks

from mendeley.ros_social_feed_events a
inner join (select distinct profile_id
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01') b

on a.profile_id=b.profile_id
left join mendeley.profiles c

on a.profile_id=c.uu_profile_id
inner join mendeley.oauth2map d
on a.client_id=d.id

inner join (select profile_id, min(index_ts) as first_card_viewed
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-11-01' and index_ts<'2017-12-01' group by 1
) e
on a.profile_id=e.profile_id

where a.index_ts>='2017-10-01' and a.index_ts<'2018-01-15'
group by 1,2,3,4
order by 1

----active analysis for dec 17 cohort

select index_ts,
date_trunc('day',first_card_viewed) as first_card_viewed_date,
case when joined<='2017-10-01' then 1 else 0 end as joined_pre_oct17_flag,
datediff('month',joined,index_ts) as tenure_month,
datediff('year',joined,index_ts) as tenure_year,
datediff('day',first_card_viewed,index_ts) as days_since_first_card_view,
count(distinct(a.profile_id)) as active_users

from mendeley.active_users_by_client_per_day a
inner join (select distinct profile_id
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-12-01' and index_ts<'2018-01-01') b

on a.profile_id=b.profile_id
left join mendeley.profiles c

on a.profile_id=c.uu_profile_id
inner join mendeley.oauth2map d
on a.client_id=d.id

left join (select profile_id, min(index_ts) as first_card_viewed
from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and event_name='FeedItemViewed'
and index_ts>='2017-12-01' and index_ts<'2018-01-01' group by 1
) e
on a.profile_id=e.profile_id

where a.index_ts>='2017-10-01' and a.index_ts<'2018-01-23'
group by 1,2,3,4,5,6
order by 1


