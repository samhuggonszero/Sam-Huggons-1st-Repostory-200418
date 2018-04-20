SELECT * FROM usage.mendeley.mandrill_history LIMIT 100;
SELECT * FROM usage.mendeley.ac_delivery_logs LIMIT 100;
SELECT * FROM usage.mendeley.ac_mc_delivery_logs LIMIT 100;



select 
date_trunc('month',event_date) as month,
'Adobe Campaign' as type,
count(*) as emails_sent

from mendeley.ac_delivery_logs
where event_date>'2015-01-01'
group by 1,2

union all

select 
date_trunc('month',rt_event_date) as month,
'Raven Suggest' as type,
count(distinct(rt_broadlog_id)) as emails_sent

from mendeley.ac_mc_delivery_logs
group by 1,2

union all

select date_trunc('month',sent_ts) as month,
'Mandrill' as type,
count(*) as email_sent
from mendeley.mandrill_history 
group by 1,2

union all

select date_trunc('month',ts) as month,
'Feed Digest' as type,
count(distinct(profile_id||date_trunc('day',ts))) as emails_sent

from mendeley.live_events_201610_to_present a
where event_name in ('FeedDigestItemSent')
and client_id in (4107)
and ts>='2017-05-01'
group by 1,2

