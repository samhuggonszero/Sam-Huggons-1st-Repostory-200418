select * from mendeley.profiles limit 10

is_advisor, 





select *

from  mendeley.active_users_by_client_per_day  a
left join mendeley.profiles  b
on a.profile_id=uu_profile_id
where is_advisor=1
and index_ts>getdate()-30



select sum(is_advisor)

from  mendeley.profiles  b
