with now as (select index_ts,  max(max_date) as max_date,
count(distinct(profile_id)) as MDLY_USERS,
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,
sum(case when group_views>=1 or feed_group_interactors>=1 then 1 else 0 end) as group_users,
sum(case when feed2_views>=1 then 1 else 0 end) as Newsfeed_viewing_users,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or feed_group_interactors>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
or Sneak_peak_views>=1 then 1 else 0 end) as ROS_SOCIAL_users,
sum(case when web_views>=1 then 1 else 0 end) as Web_viewing_users,
sum(case when desktop_views>=1 then 1 else 0 end) as Desktop_users,
sum(case when web_importer_views>=1 then 1 else 0 end) as Web_importer_users,
sum(case when data_views>=1 then 1 else 0 end) as Data_viewing_users,
sum(case when Web_Library_views>=1 then 1 else 0 end) as Web_library_users,
sum(case when Catalogue_views>=1 then 1 else 0 end) as Catalogue_viewing_users,
sum(case when Funding_views>=1 then 1 else 0 end) as Funding_viewing_users,
sum(case when Careers_views>=1 then 1 else 0 end) as Careers_viewing_users,
sum(case when mobile_views>=1 then 1 else 0 end) as Mobile_viewing_users,
sum(case when mobile_suggest_views>=1 then 1 else 0 end) as Mobile_suggest_users,
sum(case when mobile_feed_views>=1 then 1 else 0 end) as Mobile_feed_users,
sum(case when Sneak_peak_views>=1 then 1 else 0 end) as Sneak_peek_users


from (		
	select  profile_id,
		date_trunc('month', ts) as index_ts,
			max(ts) as max_date, 
		sum(case when le.client_id = 2364 and 							
					(le.event_name in ('FeedItemClicked', 'followed', 'unfollowed', 'RecommendationAddToLibrary', 'RecommendationADDTOLIBRARY','FeedNavAllNewsClicked','FeedNavNewPublicationsClicked','FeedNavGroupClicked','FeedFilterSelected','FeedJoinGroupClicked'))					
					or					
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 6 and ts<'2016-10-01')				
					or
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 2 and ts>='2016-10-01' and ts<='2017-05-14')
					or 
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 1 and ts>='2017-05-15' and ts<'2017-06-27')
					or 
					(le.event_name='FeedPageScrolled' and ts>'2017-06-27')
										then 1 else 0 end) as feed_views,

					sum(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			sum(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			sum(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			sum(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
			sum(case when le.client_id = 3181 or le.event_name in ('group-admin-joined',
									'group-follower-joined',
									'group-member-joined',
								'group-owner-joined',
									'GroupSearchExecuted',
									'invite-group-invite-sent',
									'log.group-document-add',
									'log.group-status-update') 
									or  (le.event_name = 'SelectGroup' and le.client_id = 6 and json_extract_path_text(le.properties, 'GroupRemoteId') in (select uu_group_id from mendeley.groups))
									then 1 else 0 end) as group_views,
									sum(case when le.client_id=2364 and le.event_name in ('FeedFilterSelected') and json_extract_path_text(properties, 'filter') in ('group','groups') 
					then 1 else 0 end) as feed_group_interactors,
					sum(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					sum(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					sum(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					sum(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					sum(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					sum(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					sum(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					sum(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as Careers_views


	

from mendeley.live_events_filtered le
inner join mendeley.usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
	where le.ts >= date_trunc('month',getdate()) and le.ts < getdate()
	group by 1,2
	order by 1,2
  ) c
  group by 1
  order by 1), 

 

last_month as (select index_ts, max(max_date) as max_date,
count(distinct(profile_id)) as MDLY_USERS,
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,
sum(case when group_views>=1 or feed_group_interactors>=1 then 1 else 0 end) as group_users,
sum(case when feed2_views>=1 then 1 else 0 end) as Newsfeed_viewing_users,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or feed_group_interactors>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
or Sneak_peak_views>=1 then 1 else 0 end) as ROS_SOCIAL_users,
sum(case when web_views>=1 then 1 else 0 end) as Web_viewing_users,
sum(case when desktop_views>=1 then 1 else 0 end) as Desktop_users,
sum(case when web_importer_views>=1 then 1 else 0 end) as Web_importer_users,
sum(case when data_views>=1 then 1 else 0 end) as Data_viewing_users,
sum(case when Web_Library_views>=1 then 1 else 0 end) as Web_library_users,
sum(case when Catalogue_views>=1 then 1 else 0 end) as Catalogue_viewing_users,
sum(case when Funding_views>=1 then 1 else 0 end) as Funding_viewing_users,
sum(case when Careers_views>=1 then 1 else 0 end) as Careers_viewing_users,
sum(case when mobile_views>=1 then 1 else 0 end) as Mobile_viewing_users,
sum(case when mobile_suggest_views>=1 then 1 else 0 end) as Mobile_suggest_users,
sum(case when mobile_feed_views>=1 then 1 else 0 end) as Mobile_feed_users,
sum(case when Sneak_peak_views>=1 then 1 else 0 end) as Sneak_peek_users

from (		
	select  profile_id,
			date_trunc('month', ts) as index_ts,
			max(ts) as max_date, 
				sum(case when le.client_id = 2364 and 							
					(le.event_name in ('FeedItemClicked', 'followed', 'unfollowed', 'RecommendationAddToLibrary', 'RecommendationADDTOLIBRARY','FeedNavAllNewsClicked','FeedNavNewPublicationsClicked','FeedNavGroupClicked','FeedFilterSelected','FeedJoinGroupClicked'))					
					or					
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 6 and ts<'2016-10-01')				
					or
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 2 and ts>='2016-10-01' and ts<='2017-05-14')
					or 
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 1 and ts>='2017-05-15' and ts<'2017-06-27')
					or 
					(le.event_name='FeedPageScrolled' and ts>'2017-06-27')
										then 1 else 0 end) as feed_views,

					sum(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			sum(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			sum(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			sum(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
			sum(case when le.client_id = 3181 or le.event_name in ('group-admin-joined',
									'group-follower-joined',
									'group-member-joined',
								'group-owner-joined',
									'GroupSearchExecuted',
									'invite-group-invite-sent',
									'log.group-document-add',
									'log.group-status-update') 
									or  (le.event_name = 'SelectGroup' and le.client_id = 6 and json_extract_path_text(le.properties, 'GroupRemoteId') in (select uu_group_id from mendeley.groups))
									then 1 else 0 end) as group_views,
									sum(case when le.client_id=2364 and le.event_name in ('FeedFilterSelected') and json_extract_path_text(properties, 'filter') in ('group','groups') 
					then 1 else 0 end) as feed_group_interactors,
					sum(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					sum(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					sum(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					sum(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					sum(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					sum(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					sum(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					sum(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as Careers_views


	

from mendeley.live_events_filtered le
inner join mendeley.usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
	where le.ts >= DATEADD(month,-12,date_trunc('month',getdate())) and le.ts < DATEADD(month,-12,date_trunc('day',getdate())) 
	group by 1,2
	order by 1,2
  ) c
  group by 1
  order by 1) 
 

  select * from last_month union all select * from now