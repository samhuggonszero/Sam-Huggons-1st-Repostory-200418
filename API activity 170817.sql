SELECT * FROM analytics.public.oauth2_clients LIMIT 100;

select 
date_trunc('month',ts) as index_ts,
id,
le.event_name,
uri, 
"owner", 
description, 
name, 
created, 
count(*) as events,
count(distinct(profile_id)) as users

from public.live_events_filtered le
inner join usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
inner join analytics.public.oauth2_clients c
on le.client_id=c.id
where id not in (select id from public.oauth2map)
and id not in (3379)
and ts>='2016-01-01'
group by 1,2,3,4,5,6,7,8



select 
date_trunc('day',ts) as index_ts,
id,
le.event_name,
uri, 
"owner", 
description, 
name, 
created, 
count(*) as events,
count(distinct(profile_id)) as users

from public.live_events_filtered le
inner join usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
inner join analytics.public.oauth2_clients c
on le.client_id=c.id
where id not in (select id from public.oauth2map)
and id not in (3379)
and ts>='2016-01-01'
group by 1,2,3,4,5,6,7,8


select 
date_trunc('month',ts) as index_ts,
id,
uri, 
"owner", 
description, 
name, 
created,
count(distinct(profile_id)) as users,
count(*) as events

from public.live_events_filtered le
inner join usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
inner join analytics.public.oauth2_clients c
on le.client_id=c.id
where id not in (select id from public.oauth2map)
and id not in (3379)
and ts>='2016-01-01'
group by 1,2,3,4,5,6,7




-----new server code


select 
date_trunc('month',ts) as index_ts,
id,
uri, 
"owner", 
description, 
name, 
created,
count(distinct(profile_id)) as users,
count(*) as events

from mendeley.live_events_filtered le
inner join mendeley.usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
inner join mendeley.oauth2_clients c
on le.client_id=c.id
where id not in (select id from mendeley.oauth2map)
and id not in (3379)
and ts>='2016-01-01'
group by 1,2,3,4,5,6,7



select 
date_trunc('month',ts) as index_ts,
id,
uri, 
"owner", 
description, 
name, 
created,
count(distinct(profile_id)) as users,
count(*) as events

from mendeley.live_events_201610_to_present le
inner join mendeley.oauth2_clients c
on le.client_id=c.id
where id not in (select id from mendeley.oauth2map)
and id not in (3379)
and ts>='2016-10-01' and ts<date_trunc('month',getdate())
group by 1,2,3,4,5,6,7





----event name data
select 
date_trunc('month',ts) as index_ts,
event_name,
id,
uri, 
"owner", 
description, 
name, 
created,
count(distinct(profile_id)) as users,
count(*) as events

from mendeley.live_events_201610_to_present le
inner join mendeley.oauth2_clients c
on le.client_id=c.id
where id not in (select id from mendeley.oauth2map)
and id not in (3379)
and ts>='2016-10-01' and ts<date_trunc('month',getdate())
group by 1,2,3,4,5,6,7,8


