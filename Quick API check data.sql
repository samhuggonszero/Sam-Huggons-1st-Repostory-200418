SELECT client_id, name_ana, count(distinct(profile_id)) as users 
FROM usage.mendeley.active_users_by_client_per_day a
left join  mendeley.oauth2map b
on a.client_id=b.id
where  index_ts>='2017-01-01' and index_ts<'2017-08-01'
group by 1,2 order by 3 desc