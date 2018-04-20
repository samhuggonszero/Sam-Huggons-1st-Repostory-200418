



select client_id,
Profile_id,
ts,
event_name,
group_id,
JSON_EXTRACT_PATH_TEXT(properties, 'itemId') as Item_Id,
JSON_EXTRACT_PATH_TEXT(properties, 'itemType') as Item_Type,
JSON_EXTRACT_PATH_TEXT(properties, 'section') as Section,
JSON_EXTRACT_PATH_TEXT(properties, 'pageLoadId') as Page_Load_Id,
JSON_EXTRACT_PATH_TEXT(properties, 'filter') as Filter,
JSON_EXTRACT_PATH_TEXT(properties, 'index') as Position_Index

from mendeley.live_events
where client_id in (2364,3181,7,808)
and event_name in ('FeedItemClicked','FeedItemDisplayed','FeedItemViewed')
and ts>='2016-02-16'





select * from mendeley.live_events_latest where event_name='FeedItemClicked' and ts>getdate()-4  limit 10
'{"pageLoadId":"3647e57331.586e","filter":"group","itemId":"46e354d7-8b59-4a94-9de6-a780f4a3d289","text":"Official Design Report from the DUNE collaboration on the LBNF beamline characteristics. Use this for LBNF neutrino flux.","itemType":"group-doc-added","commentIndex":"1"}'
select * from mendeley.live_events_latest where event_name='FeedCommentAdded' and ts>getdate()-4 limit 10
'{"pageLoadId":"2c0a317bea.fdd","filter":"all","itemId":"aae98857-c506-4517-b4d2-61a61a238de7","text":"No me deja descargar tus documentos para verlos. Tú puedes acceder a los míos?","itemType":"group-status-posted","commentIndex":"1"}'
select * from mendeley.live_events_latest where event_name='FeedFilterSelected' and ts>getdate()-4 limit 10
'{"filter":"group","accessLevel":"private"}'

select * from mendeley.live_events_latest where event_name='FeedItemDisplayed' and ts>getdate()-4  limit 10
'{"pageLoadId":"20a7f78f.75a13a","filter":"all","itemId":"ec2023be-eb5f-4cba-8343-90df4927b915","itemType":"document-recommendation"}''{"pageLoadId":"20a7f78f.75a13a","filter":"all","itemId":"6abe2b17-b904-4cb0-943f-28ff55ba8bc0","itemType":"document-recommendation"}'
'{"pageLoadId":"3fa7366f35.afee","filter":"all","itemId":"ccd441af-40ce-4cb1-964f-0f1ffae7db97","itemType":"group-doc-added"}'

select * from mendeley.live_events_latest where event_name='FeedItemViewed' and ts>getdate()-4 and client_id=2364 limit 10
'{"index":"3","itemType":"document-recommendation"}'
select * from mendeley.live_events_latest where event_name='FeedItemDisplayed' and ts>getdate()-4 and client_id=2364 limit 10
'{"pageLoadId":"8a53be093f.bd5","filter":"all","itemId":"05e617d4-6420-46c9-9677-b359bff7e1b8","itemType":"document-recommendation"}'
'{"pageLoadId":"8a53be093f.bd5","filter":"all","itemId":"6a552ce8-7028-4df8-9dff-99f5e4437abd","itemType":"document-recommendation"}''{"filter":"all","itemType":"people-recommendation"}'

'{"pageLoadId":"8a53be093f.bd5","filter":"all","itemId":"abe7ccc5-b4ee-46d2-bd3e-eb0837730c8a","itemType":"document-recommendation"}'

'{"index":"6","itemType":"document-recommendation"}'