select * from mendeley.active_users_by_client_by_event_per_day  where event_name='scopusClaimWidgetShown' limit 100

--may need to use the source property
MendeleyScopusClaimAccepted
MendeleyScopusClaimRejecte


select * 
from mendeley.active_users_by_client_by_event_per_day  
where event_name='scopusClaimWidgetShown' 


limit 100


select index_ts, 
event_name,
client_id,
sum(nr_events) as nr_events,
count(distinct(profile_id)) as users

from mendeley.active_users_by_client_by_event_per_day  
where event_name in ('scopusClaimWidgetShown','MendeleyScopusClaimRejecte','MendeleyScopusClaimAccepted') 
group by 1,2,3