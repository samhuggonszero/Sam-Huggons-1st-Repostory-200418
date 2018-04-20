SELECT * FROM usage.mendeley.active_users_movements LIMIT 100;

select movement, index_ts0, index_ts1, index_ts, count(distinct(profile_id)) as users
from usage.mendeley.active_users_movements
group by 1,2,3,4

select count(distinct(uu_profile_id)) 
from mendeley.profiles
where joined<='2017-07-01'



select  index_ts, counT(distinct(uu_profile_id)) as MDLY_Total_population
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts group by 1


7518669
7653869


select a.*, b.MDLY_Total_population from 
(select movement, index_ts0, index_ts1, index_ts, count(distinct(profile_id)) as users
from usage.mendeley.active_users_movements
group by 1,2,3,4) a
left join (select  index_ts, counT(distinct(uu_profile_id)) as MDLY_Total_population
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts group by 1) b
on a.index_ts=b.index_ts




select movement, index_ts, count(distinct(profile_id)) as users
from usage.mendeley.active_users_movements
group by 1,2
union all
select   'T'  as movement, index_ts, counT(distinct(uu_profile_id)) as users
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts group by 1,2
union all
select 'D'  as movement,
a.index_ts,
users-users1 as users
from ( select index_ts, counT(distinct(uu_profile_id)) as users
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts 
group by 1 ) a
left join (select index_ts, counT(distinct(profile_id)) as users1 from mendeley.active_users group by 1) c
on a.index_ts=c.index_ts





