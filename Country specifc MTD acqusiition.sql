select index_month, 
max(max_date) as max_date,
sum(acquired_user) as acquired_user,
sum(repeat_user) as repeat_user,
count(*) as active_user

from (
   
select uu_profile_id,
date_trunc('month', index_ts) as index_month, max(index_ts) as max_date,
max(case when p.joined >= '2015-07-01' and p.joined < '2015-07-25'  then 1 else 0 end) acquired_user,
max(case when p.joined < date_trunc('month',getdate()-31) then 1 else 0 end) repeat_user
from mendeley.profiles p 
left join mendeley.active_users_per_day a
on p.uu_profile_id=a.profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
where index_ts >='2015-07-01' and index_ts < '2015-07-25'
and c.country='United States'
group by 1,2
)
group by 1

union all

select index_month, 
max(max_date) as max_date,
sum(acquired_user) as acquired_user,
sum(repeat_user) as repeat_user,
count(*) as active_user

from (
   
select uu_profile_id,
date_trunc('month', index_ts) as index_month, 
max(index_ts) as max_date,
max(case when p.joined >= date_trunc('month',getdate()) and p.joined < getdate() then 1 else 0 end) acquired_user,
max(case when p.joined < date_trunc('month',getdate()) then 1 else 0 end) repeat_user
from mendeley.profiles p 
left join mendeley.active_users_per_day a
on p.uu_profile_id=a.profile_id
left join mendeley.profile_countries c
on a.profile_id=c.profile_id
where index_ts >= date_trunc('month',getdate()) and index_ts < DATEADD(day,0,date_trunc('day',getdate()))
and c.country='United States'
group by 1,2
)
group by 1