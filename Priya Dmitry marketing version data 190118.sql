/*Requirement - 
We would like to target users who opted in to Experimental Releases as the beta testers for RefMan2. As part of this, I would like to get an idea of how active these users are and be able to identify them in the Marketing DataMart.

Can you extract:
UUID
Date of opt in to Experimental Releases
Current Mendeley Desktop version
Geographic location
Institution (if known)
Part of MIE institution (if known)

Clarifying this with [~Dmitriy.Shlyuger]:
* Select all users who have used a -dev* version in 2017
* Date of first use
* Number of different -dev* versions
* Latest Desktop version
* Geographic Location

JIRA - https://sdfe13.atlassian.net/browse/ANA-4191

*/

/*1.3*/
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


select distinct event_name from mendeley.active_users_by_client_by_event_non_whitelisted_per_day limit 10

