SELECT * FROM usage.mendeley.live_events_latest where event_name='NewsItemViewCreated' limit 10

select distinct event_name from usage.mendeley.live_events_latest


select item_type, section, count(*) as feed_clicks, count(distinct(profile_id)) as users
from mendeley.ros_social_feed_events
where item_type ='post-a-status' 
and  date_trunc('month',index_ts)='2017-10-01'
--and section ='attach_document'
group by 1,2
	

'FeedDocSelected' when modal document added

'detach_document' when deleted pre posting

Order of data to establish how many docs are on a post			
	Event	Item Type	section
1)	FeedItemClicked	post-a-status	textarea
2)	FeedItemClicked	post-a-status	attach_document
3)	FeedDocSelected		
4)	FeedItemClicked	post-a-status	detach_document
5)	FeedItemClicked	post-a-status	post_button



'{"timestamp":"2017-10-01T21:08:05.990Z","type":"first-document-ever-added","audience":"080ed9d7-5a73-3f79-af33-11b7ff5d4476"}'

select * from mendeley.ros_social_feed_events 
where item_type ='post-a-status' 
and  date_trunc('month',index_ts)='2017-10-01' 
and event_name='FeedItemClicked'
and section in ('attach_document','detach_document','post_button')


select * from mendeley.live_events_latest
where date_trunc('month',ts)='2017-10-01' 
and event_name='FeedDocSelected'



select a.*, JSON_EXTRACT_PATH_TEXT(properties, 'count') as doc_count
from mendeley.live_events_latest a
where date_trunc('month',ts)='2017-10-01' 
and event_name='FeedDocSelected'







