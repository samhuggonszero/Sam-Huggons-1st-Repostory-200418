select index_ts, 
case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
or Sneak_peak_views>=1 then 1 else 0 end as ROS_SOCIAL_FLAG,
max(max_date) as max_date,
count(distinct(profile_id)) as MDLY_USERS,
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when group_views>=1 then 1 else 0 end) as group_users,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,
sum(case when feed2_views>=1 then 1 else 0 end) as Newsfeed_viewing_users,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
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

select a.*, b.feed_views, b.group_views from (

	select  profile_id,
			date_trunc('month', index_ts) as index_ts,
			max(index_ts) as max_date, 
			sum(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			sum(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			sum(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			sum(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
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


	

from mendeley.dashboard_1m le

	where le.index_ts >= '2015-10-01'
	group by 1,2
	order by 1,2) a
	left join (select profile_id, 
date_trunc('month', index_ts) as index_ts,
max(index_ts) as max_date,
sum(case when product in ('Active Newsfeed') then 1 else 0 end) as feed_views,
sum(case when product in ('Feed Groups Filter Interactor','Community Viewers','Desktop Group Viewers','Group') then 1 else 0 end) as group_views

from mendeley.ros_social_users_per_day
where index_ts >= '2015-10-01' and index_ts<date_trunc('month',getdate()) 
group by 1,2
) b
	on a.profile_id=b.profile_id
	and a.index_ts=b.index_ts
  ) c
  group by 1,2