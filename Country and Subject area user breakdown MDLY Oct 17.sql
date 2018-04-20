select b.country,
a.subject_area,
count(distinct(uu_profile_id)) as users_registered_mdly_all_time

from mendeley.profiles a
left join mendeley.profile_countries b
on a.uu_profile_id=b.profile_id
group by 1,2



select b.country,
a.subject_area,
count(distinct(uu_profile_id)) as users_active_oct17

from mendeley.profiles a
left join mendeley.profile_countries b
on a.uu_profile_id=b.profile_id
where uu_profile_id in (select profile_id from mendeley.active_users where index_ts='2017-10-01)
group by 1,2