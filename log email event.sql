select 
date_trunc('day',ts) as date,
JSON_EXTRACT_PATH_TEXT(properties, 'data_1'),
JSON_EXTRACT_PATH_TEXT(properties, 'data_0'),
JSON_EXTRACT_PATH_TEXT(properties, 'event'),
count(*)

from mendeley.live_events_latest 
where event_name ='log.email' 
group by 1,2,3,4

