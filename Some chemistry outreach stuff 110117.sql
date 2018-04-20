SELECT * FROM usage.mendeley.active_users_by_client_per_day where client_id=2364 limit 10


mendeley.oauth2map


select subject_area, 
case when client_id=2364 then 1 else 0 end as feed_user, 
count(distinct(profile_id)) as users 

from mendeley.active_users_by_client_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
where date_trunc('month',index_ts)='2017-11-01'
group by 1,2


select subject_area, 
count(distinct(profile_id)) as users 

from mendeley.active_users a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
where date_trunc('month',index_ts)='2017-11-01'
group by 1

select subject_area, 
count(distinct(uu_profile_id)) as users 

from mendeley.profiles b
group by 1



select subject_area, 
client_id,
profile_id,
count(distinct(index_ts)) as days_active_nov_17

from mendeley.active_users_by_client_per_day a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
where date_trunc('month',index_ts)='2017-11-01'
and client_id=2364
and subject_area in ('Chemical Engineering','Chemistry')
group by 1,2,3




