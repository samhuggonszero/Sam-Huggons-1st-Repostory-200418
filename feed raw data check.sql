select a.*,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section

from mendeley.live_events_201610_to_present a where client_id=2364 and event_name='FeedItemClicked' and ts>='2015-05-01'
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType')='new-status'

;''


"FeedItemDisplayed, posted-catalogue-pub”
--;

select a.*,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as itemtype,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as section

from mendeley.live_events_201610_to_present a where client_id=2364 and event_name='FeedItemDisplayed' and ts>='2017-05-01' and ts<getdate()
and JSON_EXTRACT_PATH_TEXT(properties, 'itemType') in ('posted-catalogue-pub','posted-pub')
