	-----Alternative ROS Social and groups definitions under consideration									
select index_ts,										
count(distinct(profile_id)) as MDLY_USERS,										
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when feed2_views>=1 then 1 else 0 end) as feed_viewers,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,										
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,										
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,										
sum(case when group_views>=1 then 1 else 0 end) as group_users,										
sum(case when select_group_views>=1 then 1 else 0 end) as select_group_users,		
sum(case when community_less>=1 then 1 else 0 end) as community_less,		
sum(case when community_views_any>=1 then 1 else 0 end) as community_views_any,		
sum(case when mobile_suggest_views>=1 then 1 else 0 end) as mobile_suggest_views,	
sum(case when jobs_views>=1 then 1 else 0 end) as jobs_views,	
sum(case when data_views>=1 then 1 else 0 end) as data_views,	
sum(case when select_group_views>=1 or group_views>=1 or community_views_any>=1 then 1 else 0 end) as new_def_group_users_all,	
sum(case when select_group_views>=1 or group_views>=1 or community_less>=1 then 1 else 0 end) as new_def_group_users_DK_proposed,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 then 1 else 0 end) as ROS_SOCIAL_users_sept16,		
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or community_views_any>=1 or mobile_suggest_views>=1 then 1 else 0 end) as ROS_SOCIAL_users_Oct16,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or select_group_views>=1  or community_views_any>=1 or mobile_suggest_views>=1 then 1 else 0 end) as ROS_SOCIAL_Nov_16	
										
from (										
	select  profile_id,									
			date_trunc('month', ts) as index_ts,							
			sum(case when le.client_id = 2364 and 							
					(le.event_name in ('FeedItemClicked', 'followed', 'unfollowed', 'RecommendationAddToLibrary', 'RecommendationADDTOLIBRARY'))					
					or					
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 6 and ts<'2016-10-01')				
					or
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 2 and ts>='2016-10-01')			
					then 1 else 0 end) as feed_views,					
			sum(case when le.client_id = 1127 and le.event_name='login' then 1 else 0 end) as profile_views,	
			sum(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,	
			sum(case when le.client_id = 2054 and le.event_name='StatsOverviewViewed' then 1 else 0 end) as stats_views,							
			sum(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
			sum(case when le.client_id = 3181 then 1 else 0 end) as community_views_any,
			sum(case when le.client_id = 3181 and le.event_name not in ('authFailed','login') then 1 else 0 end) as community_less,	
			sum(case when le.event_name in ('group-admin-joined',							
									'group-follower-joined',	
									'group-member-joined',	
									'group-owner-joined',	
									'GroupSearchExecuted',	
									'invite-group-invite-sent',	
									'log.group-document-add',	
									'log.group-status-update') then 1 else 0 end) as group_views,	
			sum(case when le.event_name = 'SelectGroup' and le.client_id = 6 and json_extract_path_text(le.properties, 'GroupRemoteId') in 
			(select uu_group_id from mendeley.groups) then 1 else 0 end) as select_group_views,
			sum(case when le.client_id in (7,808) and le.event_name='RecommendationDisplayed' then 1 else 0 end) as mobile_suggest_views,
			sum(case when le.client_id =3518 then 1 else 0 end) as jobs_views,
			sum(case when le.client_id =1025 then 1 else 0 end) as data_views
			
from mendeley.live_events_201610_to_present le										
inner join mendeley.usage_events x										
on le.event_name=x.event_name										
and le.client_id=x.client_id 										
	where le.ts >= '2017-01-01' and le.ts < date_trunc('month',getdate())									
	group by 1,2								
	order by 1,2									
  ) c										
  group by 1										
  order by 1	