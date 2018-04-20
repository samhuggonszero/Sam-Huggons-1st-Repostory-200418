With main as
(select distinct(b.profile_id), b.client_id, b.version
from mendeley.live_events_latest b
inner join
(select profile_id, client_id , max(ts) as ts_max
from mendeley.live_events_latest
where client_id=6
group by 1,2) a
on b.profile_id = a.profile_id
and b.client_id = a.client_id
and b.ts = a.ts_max
)
select a.version, count(distinct(a.profile_id)), a.profile_id, a.client_id, min(a.ts) as first_use_ts , country, city , b.version as latest_version
from mendeley.live_events_latest a
join (select city, country, uu_profile_id from mendeley.profiles)
on profile_id = uu_profile_id
left join main b
on a.profile_id = b.profile_id
where a.client_id = 6 and not a.version = 'unknown' and a.ts>='2018-01-01' and a.version like '%dev%'
group by a.version,a.profile_id, a.client_id,country, city , latest_version
order by a.version desc


select * from mendeley.tmp_dev_desktop_users limit 10
user_request_start_time, 


With main as
(select distinct(b.profile_id), b.version
from mendeley.tmp_dev_desktop_users b
inner join
(select profile_id,  max(user_request_start_time) as ts_max
from mendeley.tmp_dev_desktop_users
where version not in ('unknown')
and user_request_start_time>='2017-01-01' and user_request_start_time<'2018-01-01'
group by 1) a
on b.profile_id = a.profile_id
and b.user_request_start_time = a.ts_max
where version not in ('unknown')
)
select a.version, a.profile_id, 6 as client_id, country, city , b.version as latest_version, min(a.user_request_start_time) as first_use_ts 
from mendeley.tmp_dev_desktop_users a
join (select city, country, uu_profile_id from mendeley.profiles)
on profile_id = uu_profile_id
left join main b
on a.profile_id = b.profile_id
where  a.version not in ('unknown') and a.user_request_start_time>='2017-01-01' and user_request_start_time<'2018-01-01' and a.version like '%dev%'
group by 1,2,3,4,5,6
order by a.version desc

