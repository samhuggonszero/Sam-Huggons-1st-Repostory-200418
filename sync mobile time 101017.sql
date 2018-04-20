select * from mendeley.live_events_latest where event_name='Sync' and client_id=808 and ts>getdate()-4 limit 100

'
{"finish_condition":"success","duration_milliseconds":"6981","connection_type":"wifi"}

'


json_extract_path_text(le.properties, 'finish_condition') as finish_condition,
json_extract_path_text(le.properties, 'duration_milliseconds') as duration_milliseconds,
json_extract_path_text(le.properties, 'connection_type') as connection_type



select count(*) from (

select 
profile_id,
client_id,
ts,
event_name,
json_extract_path_text(properties, 'finish_condition') as finish_condition,
json_extract_path_text(properties, 'duration_milliseconds') as duration_milliseconds,
json_extract_path_text(properties, 'connection_type') as connection_type


from mendeley.live_events_201610_to_present
where event_name='Sync'
and client_id in (7,808)
and json_extract_path_text(properties, 'duration_milliseconds') not in ('')





select 
a.profile_id,
client_id,
ts,
event_name,
json_extract_path_text(properties, 'finish_condition') as finish_condition,
case when json_extract_path_text(properties, 'duration_milliseconds') = '' then '0' else json_extract_path_text(properties, 'duration_milliseconds') end
as duration_milliseconds,
json_extract_path_text(properties, 'connection_type') as connection_type,
case when date_trunc('day',ts) = first_mobile_sync_date then 1 else 0 end as first_mobile_sync_day,
first_mobile_sync_date


from mendeley.live_events_201610_to_present a
left join (select profile_id, min(index_ts) as first_mobile_sync_date
from mendeley.active_users_by_client_by_event_per_day
where event_name='Sync'
and client_id in (7,808)
group by 1) b
on a.profile_id=b.profile_id
where event_name='Sync'
and client_id in (7,808)













select cast(json_extract_path_text(properties, 'duration_milliseconds') as real) ,
count(*) 

from mendeley.live_events_201610_to_present
where event_name='Sync'
and client_id in (7) 
and json_extract_path_text(properties, 'duration_milliseconds') not in ('')
group by 1
order by 2 desc




select json_extract_path_text(properties, 'duration_milliseconds'),
count(*) 

from mendeley.live_events_201610_to_present
where event_name='Sync'
and client_id in (7) 
--and json_extract_path_text(properties, 'duration_milliseconds') not in ('')
group by 1
order by 2 desc

select distinct event_name from mendeley.live_events_201610_to_present
where client_id in (7) 

select *

from mendeley.live_events_latest
where event_name='Sync'
and client_id in (7) 
and ts>getdate()-10
limit 100



'Sync'


















