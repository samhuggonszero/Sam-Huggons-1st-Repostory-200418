select 
date_trunc('month',event_date) as month,
'Adobe Campaign' as type,
count(*) as emails_sent

from mendeley.ac_delivery_logs
where event_date>'2015-01-01'
group by 1,2

union all

select date_trunc('month',sent_ts) as month,
'Mandrill' as type,
count(*) as email_sent
from mendeley.mandrill_history 
group by 1,2

union all

select date_trunc('month',ts) as month,
'Raven Feed Digest' as type,
count(distinct(profile_id||date_trunc('day',ts))) as email_sent

from mendeley.live_events_201610_to_present a
where event_name in ('FeedDigestItemSent')
and client_id in (4107)
and ts>='2017-05-01'
group by 1,2

union all

select date_trunc('month',index_ts) as month,
'Raven Suggest'  as type,
count(distinct case when action_name = 'Recommendation Sent' then pageloadid end) as email_sent

from mendeley.raven_suggest_users_per_day
where ref = 'raven'
group by 1,2

union all

select date_trunc('month',ts) as month,
'Stats Monthly Update'  as type,
count(distinct profile_id) as email_sent

from mendeley.live_events_201610_to_present a
where event_name in ('StatsMonthlyUpdate')
group by 1,2


--- weird mandrill possible proxy
select 
date_trunc('day',ts) as date,
JSON_EXTRACT_PATH_TEXT(properties, 'data_1'),
JSON_EXTRACT_PATH_TEXT(properties, 'data_0'),
JSON_EXTRACT_PATH_TEXT(properties, 'event'),
count(*)

from mendeley.live_events_latest 
where event_name ='log.email' 
group by 1,2,3,4



-----Mandrill emails do not contain UU_ID it is rubbish so using log.email

with main as (

select uuid as profile_id,
date_trunc('day',event_date) as date,
'Adobe Campaign' as type,
count(*) as emails_sent

from mendeley.ac_delivery_logs
where event_date>'2017-08-01'
group by 1,2

union all

select profile_id,
date_trunc('day',ts) as date,
'Raven Feed Digest' as type,
count(distinct(profile_id||date_trunc('day',ts))) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name in ('FeedDigestItemSent')
and client_id in (4107)
and ts>='2017-08-01'
group by 1,2,3

union all

select profile_id,
date_trunc('day',index_ts) as date,
'Raven Suggest'  as type,
count(distinct case when action_name = 'Recommendation Sent' then pageloadid end) as emails_sent

from mendeley.raven_suggest_users_per_day
where ref = 'raven'
and index_ts>='2017-08-01'
group by 1,2,3

union all

select profile_id,
date_trunc('day',ts) as date,
'Mandrill'  as type,
count(*) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name ='log.email' 
and JSON_EXTRACT_PATH_TEXT(properties, 'data_0')='mandrill'
and ts>='2017-08-01'
group by 1,2,3

union all

select profile_id, 
date_trunc('day',ts) as date,
'Stats Monthly Update'  as type,
count(distinct profile_id) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name in ('StatsMonthlyUpdate')
and ts>='2017-08-01'
group by 1,2,3
)

--select * from main limit 100   11,222,526 this only gives me emails per person per day not how many users in each cohort are contacted
--select count(*) from (
select days_since_join,
count(distinct(profile_id)) as users_sent_email,
sum(emails_sent) as emails_sent
from (

select a.profile_id,
b.joined,
a.Date,
datediff('day',joined,Date) as days_since_join,
sum(a.emails_sent) as emails_sent


from main a
left join mendeley.profiles b
on a.profile_id=uu_profile_id 
group by 1,2,3,4
)
where days_since_join>=0
group by 1 
order by 1



-----distribution in month
with main as (

select uuid as profile_id,
date_trunc('day',event_date) as date,
'Adobe Campaign' as type,
count(*) as emails_sent

from mendeley.ac_delivery_logs
where event_date>'2017-08-01'
group by 1,2

union all

select profile_id,
date_trunc('day',ts) as date,
'Raven Feed Digest' as type,
count(distinct(profile_id||date_trunc('day',ts))) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name in ('FeedDigestItemSent')
and client_id in (4107)
and ts>='2017-08-01'
group by 1,2,3

union all

select profile_id,
date_trunc('day',index_ts) as date,
'Raven Suggest'  as type,
count(distinct case when action_name = 'Recommendation Sent' then pageloadid end) as emails_sent

from mendeley.raven_suggest_users_per_day
where ref = 'raven'
and index_ts>='2017-08-01'
group by 1,2,3

union all

select profile_id,
date_trunc('day',ts) as date,
'Mandrill'  as type,
count(*) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name ='log.email' 
and JSON_EXTRACT_PATH_TEXT(properties, 'data_0')='mandrill'
and ts>='2017-08-01'
group by 1,2,3

union all

select profile_id, 
date_trunc('day',ts) as date,
'Stats Monthly Update'  as type,
count(distinct profile_id) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name in ('StatsMonthlyUpdate')
and ts>='2017-08-01'
group by 1,2,3
)


select emails_sent,
month,
count(distinct(profile_id)) as users

from (
select profile_id,
date_trunc('month',a.Date) as month,
sum(a.emails_sent) as emails_sent

from main a
group by 1,2
)
group by 1,2
order by 1
