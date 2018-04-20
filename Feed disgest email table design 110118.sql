select 
a.profile_Id,
event_name,
country,
date_trunc('day',ts) as date,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemType,
JSON_EXTRACT_PATH_TEXT(properties, 'itemId') as itemId

from mendeley.live_events_201610_to_present a
left join mendeley.profile_countries b
on a. profile_id=b.profile_id
where event_name in ('FeedDigestItemSent','FeedDigestItemClicked')
and client_id in (2364,4107)
and ts>='2017-05-01'