select * from 
mendeley.live_events_latest
where event_name='UserRegistration'
limit 100


'{"os.family":"Windows","joined_timestamp":"2017-06-01T22:35:14.000Z",
"referrer_url":"https://www.mendeley.com/join/?trackingUrl=/join/formreg/client/onboarding","os.version":"10",
"ip_address":"200.37.55.61","os.architecture":"64",
"profile_id":"0cb3ca0f-f248-3c80-9ba4-13e9738a112e","utt":"c9d5-87791906c51a1ef203-bfbf00ce79c198f1",
"registration_url":"https://www.mendeley.com/newsfeed",
"browser":"Microsoft Edge"}'








select index_ts,
c.country, 
d.city,
count(distinct(case when index_ts=date_trunc('month',joined) then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('month',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='United States'
and d.city in ('West Lafayette','Washington','Urbana','Tucson','Tempe','State College','Stanford','St Louis','Seattle','San Jose','San Francisco','San Diego','Salt Lake City','Rochester','Richmond','Raleigh','Portland','Pittsburgh','Philadelphia','New York','Nashville','Minneapolis','Miami','Madison','Los Angeles','La Jolla','Ithaca','Houston','Gainesville','Fremont','Eugene','Durham','Denver','Dallas','Columbus','Columbia','Chicago','Chapel Hill','Cambridge','Brooklyn','Boulder','Boston','Blacksburg','Berkeley','Baltimore','Austin','Atlanta','Ashburn','Ann Arbor')
group by 1,2,3

--getting cities to order it by

select c.country, 
d.city,
count(distinct(case when index_ts=date_trunc('month',joined) then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('month',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='United States'
group by 1,2
order by 3 desc
limit 50


select distinct JSON_EXTRACT_PATH_TEXT(properties, 'registration_url')

from mendeley.live_events_latest
where event_name='UserRegistration'
limit 100


with main as (
select 
profile_id,
primary_path,
JSON_EXTRACT_PATH_TEXT(primary_path, 'AccountID') as  AccountID,
JSON_EXTRACT_PATH_TEXT(primary_path, 'DeptID') as DeptID,
JSON_EXTRACT_PATH_TEXT(primary_path, 'UserID') as UserID

from mendeley.fact_request_201612
where --primary_path is not null and
 user_request_start_time>='2016-12-01' and user_request_start_time<'2017-01-01'






with main as (
select 
profile_id,
primary_path,
JSON_EXTRACT_PATH_TEXT(primary_path, 'AccountID') as  AccountID,
JSON_EXTRACT_PATH_TEXT(primary_path, 'DeptID') as DeptID,
JSON_EXTRACT_PATH_TEXT(primary_path, 'UserID') as UserID

from mendeley.fact_request_201612
where user_request_start_time>='2016-12-01' and user_request_start_time<'2017-01-01'
)

select 
index_ts,
account_name,
account_organization_type, 
account_city, 
account_country, 
account_un_region, 
account_un_territory,
count(distinct(case when index_ts=date_trunc('month',joined) then z.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('month',joined) then z.profile_id end)) as Repeat_users,
count(distinct(z.profile_id)) as MDLY_MAU

from mendeley.active_users z
left join main a
on z.profile_id=a.profile_id
left join common.dim_account b
on a.AccountID=b.account_id
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
left join mendeley.profile_features d
on z.profile_id=d.profile_id
where z.index_ts='2016-12-01'
and account_country='United States'
group by 1,2,3,4,5,6,7 
order by 7 desc




----China downtime



select index_ts,
c.country, 
count(distinct(case when index_ts=date_trunc('day',joined)  then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('day',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='China'
and a.index_ts>='2017-07-01'
group by 1,2
order by 1






select index_ts,
c.country, 
count(distinct(case when index_ts=date_trunc('day',joined)  then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('day',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='China'
and a.index_ts>='2017-07-01'
group by 1,2
order by 1


--14 -19 june uniwue chines users
select c.country, 
count(distinct(case when index_ts=date_trunc('day',joined)  then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('day',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='China'
and (a.index_ts>='2017-06-01' and a.index_ts<'2017-07-01')
--and (a.index_ts<'2017-06-14' and a.index_ts>='2017-07-20')
group by 1
order by 1

select c.country, 
count(distinct(case when index_ts=date_trunc('day',joined)  then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('day',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where c.country ='China'
--and (a.index_ts>='2017-06-01' and a.index_ts<'2017-07-01')
and (a.index_ts>='2017-06-14' and a.index_ts<'2017-06-20')
group by 1
order by 1






select c.country, 
count(distinct(case when index_ts=date_trunc('day',joined)  then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('day',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
where c.country ='China'
and a.index_ts>='2017-06-01' and a.index_ts<'2017-07-01'
and a.profile_id not in (select a.profile_id
from mendeley.active_users_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
where c.country ='China'
and a.index_ts>='2017-06-14' and a.index_ts<'2017-06-20'  ) 
group by 1
order by 1





select index_ts,
c.country,
count(distinct(case when index_ts=date_trunc('month',joined) then a.profile_id end)) as New_users,
count(distinct(case when index_ts>date_trunc('month',joined) then a.profile_id end)) as Repeat_users,
count(distinct(a.profile_id)) as MDLY_MAU

from mendeley.active_users a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
left join mendeley.profile_cities d
on a.profile_id=d.profile_id
where index_ts>='2014-01-01'
and c.country in (select country from (
select c.country,
count(distinct(profile_id)) as New_users

from mendeley.profiles b
left join mendeley.profile_countries c
on b.uu_profile_id=c.profile_id
group by 1
order by 2 desc
limit 25
)) group by 1,2


select country from (
select c.country,
count(distinct(profile_id)) as New_users

from mendeley.profiles b
left join mendeley.profile_countries c
on b.uu_profile_id=c.profile_id
group by 1
order by 2 desc
limit 25
)
