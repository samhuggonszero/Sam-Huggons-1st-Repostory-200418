------------Recency = most recent active month or average month since active of population in each given month
-------------Frequency = days active per month
-------------Depth = either number of products used or number of platforms used (mobile, dektop, web importer, web)



---------Depth
select a.*, b.feed_views, b.group_views, b.Catalogue_interactor_views  from (

	select  profile_id,
			date_trunc('month', index_ts) as index_ts,
			max(index_ts) as max_date, 
			max(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			max(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			max(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			max(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
					max(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					max(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					max(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					max(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					max(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					max(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					max(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					max(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					max(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					max(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as Careers_views,
					max(case when date_trunc('month',joined)=le.index_ts then 1 else 0 end) as new_user


from mendeley.dashboard_1m le
left join mendeley.profiles d
on le.profile_id=d.uu_profile_id

where le.index_ts >= '2015-10-01'
group by 1,2
order by 1,2) a
left join 
	
	(select profile_id, 
date_trunc('month', index_ts) as index_ts,
max(index_ts) as max_date,
max(case when product in ('Active Newsfeed') then 1 else 0 end) as feed_views,
max(case when product in ('Feed Groups Filter Interactor','Community Viewers','Desktop Group Viewers','Group') then 1 else 0 end) as group_views,
max(case when product in ('Catalog Recommendation Interactors') then 1 else 0 end) as Catalogue_interactor_views

from mendeley.ros_social_users_per_day
where index_ts >= '2015-10-01' and index_ts<date_trunc('month',getdate()) 
group by 1,2
) b
on a.profile_id=b.profile_id
and a.index_ts=b.index_ts



-------------Frequency------------

select profile_id,
date_trunc('month', index_ts) as index_ts,
count(distinct(date_trunc('day', index_ts))) as days_active

from mendeley.active_users_by_client_per_day a
where date_trunc('month', index_ts)='2015-10-01'
group by 1,2


-----------------Recency

select profile_id,
max(index_ts) as date_last_active

from mendeley.active_users_per_day a
where date_trunc('month', index_ts)='2015-10-01'
group by 1

-----------mega_merge

select count(*) from (

select a.profile_id,
a.index_ts,
days_active,
date_last_active,
new_user,
feed2_views+profile_views+stats_views+suggest_views+mobile_views+desktop_views+web_importer_views+data_views+Web_Library_views+
Catalogue_views+Funding_views+Careers_views+group_views as products_used,
mobile_views+web_importer_views+desktop_views+web_views as platforms_used_out_0f_4

from (select profile_id,
date_trunc('month', index_ts) as index_ts,
count(distinct(date_trunc('day', index_ts))) as days_active

from mendeley.active_users_by_client_per_day a
where date_trunc('month', index_ts)>='2015-10-01'
group by 1,2) a
left join (select profile_id,
max(index_ts) as date_last_active

from mendeley.active_users_per_day  a
where date_trunc('month', index_ts)>='2015-10-01'
group by 1) b
on a.profile_id=b.profile_id
left join (select a.*, b.feed_views, b.group_views, b.Catalogue_interactor_views  from (

	select  profile_id,
			date_trunc('month', index_ts) as index_ts,
			max(index_ts) as max_date, 
			max(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			max(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			max(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			max(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
					max(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					max(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					max(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					max(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					max(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					max(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					max(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					max(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					max(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					max(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as Careers_views,
					max(case when date_trunc('month',joined)=le.index_ts then 1 else 0 end) as new_user


from mendeley.dashboard_1m le
left join mendeley.profiles d
on le.profile_id=d.uu_profile_id

where le.index_ts >= '2015-10-01'
group by 1,2
order by 1,2) a
left join 
	
	(select profile_id, 
date_trunc('month', index_ts) as index_ts,
max(index_ts) as max_date,
max(case when product in ('Active Newsfeed') then 1 else 0 end) as feed_views,
max(case when product in ('Feed Groups Filter Interactor','Community Viewers','Desktop Group Viewers','Group') then 1 else 0 end) as group_views,
max(case when product in ('Catalog Recommendation Interactors') then 1 else 0 end) as Catalogue_interactor_views

from mendeley.ros_social_users_per_day
where index_ts >= '2015-10-01' and index_ts<date_trunc('month',getdate()) 
group by 1,2
) b
on a.profile_id=b.profile_id
and a.index_ts=b.index_ts
) c
on a.profile_id=c.profile_id
and a.index_ts=c.index_ts

)


-----------mega_merge FINALLLLLLLLL!!!!!!!!!!!
select count(*) from (

select index_ts,
days_active,
datediff('day',date_last_active,getdate()) as days_since_now_last_active,
new_user,
products_used,
platforms_used_out_0f_4,
count(distinct(profile_id)) as users

from (

select a.profile_id,
a.index_ts,
days_active,
date_last_active,
new_user,
feed2_views+profile_views+stats_views+suggest_views+mobile_views+desktop_views+web_importer_views+data_views+Web_Library_views+
Catalogue_views+Funding_views+Careers_views+group_views as products_used,
mobile_views+web_importer_views+desktop_views+web_views as platforms_used_out_0f_4

from (select profile_id,
date_trunc('month', index_ts) as index_ts,
count(distinct(date_trunc('day', index_ts))) as days_active

from mendeley.active_users_by_client_per_day a
where date_trunc('month', index_ts)>='2015-10-01'
group by 1,2) a

left join (select profile_id,
max(index_ts) as date_last_active

from mendeley.active_users_by_client_per_day a
where date_trunc('month', index_ts)>='2015-10-01'
group by 1) b
on a.profile_id=b.profile_id

left join (select a.*,
case when b.feed_views is null then 0 else b.feed_views end as feed_views,
case when b.group_views is null then 0 else b.group_views end as group_views,
case when b.Catalogue_interactor_views is null then 0 else b.Catalogue_interactor_views end as Catalogue_interactor_views

 from (

	select  profile_id,
			date_trunc('month', index_ts) as index_ts,
			max(index_ts) as max_date, 
			max(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			max(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			max(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			max(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
					max(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					max(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					max(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					max(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					max(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					max(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					max(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					max(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					max(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					max(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					max(case when le.client_id in (3518) then 1 else 0 end) as Careers_views,
					max(case when date_trunc('month',joined)=le.index_ts then 1 else 0 end) as new_user


from mendeley.dashboard_1m le
left join mendeley.profiles d
on le.profile_id=d.uu_profile_id

where le.index_ts >= '2015-10-01'
group by 1,2
order by 1,2) a
left join 
	
	(select profile_id, 
date_trunc('month', index_ts) as index_ts,
max(index_ts) as max_date,
max(case when product in ('Active Newsfeed') then 1 else 0 end) as feed_views,
max(case when product in ('Feed Groups Filter Interactor','Community Viewers','Desktop Group Viewers','Group') then 1 else 0 end) as group_views,
max(case when product in ('Catalog Recommendation Interactors') then 1 else 0 end) as Catalogue_interactor_views

from mendeley.ros_social_users_per_day
where index_ts >= '2015-10-01' and index_ts<date_trunc('month',getdate()) 
group by 1,2
) b
on a.profile_id=b.profile_id
and a.index_ts=b.index_ts
) c
on a.profile_id=c.profile_id
and a.index_ts=c.index_ts

)
group by 1,2,3,4,5,6
)



-----------Sessions on web, desktop, web importer, mobile
-----Web visist per MDLY MAU

select a.index_ts,
count(distinct(a.profile_id)) as users,
max(web_sessions) as web_sessions

from mendeley.active_users a
left join 
(SELECT index_ts, 
count(distinct(profile_id||session_id||ts_start)) as web_sessions

FROM usage.mendeley.sessions_6m_web group by 1) b
on a.index_ts=b.index_ts
group by 1
order by 1 desc

----------------------------------69,718,308
SELECT index_ts, 
count(distinct(profile_id||session_id||ts_start)) as web_sessions

FROM usage.mendeley.sessions_6m 
group by 1 
order by 1 desc

----------------------------------------------
SELECT index_ts, 
count(distinct(profile_id||session_id||ts_start)) as web_sessions,
count(*),
count(distinct(profile_id)) as profile_id,
count(distinct(session_id)) as session_id

FROM usage.mendeley.sessions_6m 
group by 1 
order by 1 desc


---------trying to get visist ou of AA data
SELECT * FROM usage.mendeley.aa_datafeed_mendeley LIMIT 100;

SELECT date_trunc('month',post_cust_hit_time_gmt) as month,
count(distinct(mcvisid)) as mcvisid, 
count(distinct(post_visid_high)) as post_visid_high, 
count(distinct(post_visid_low)) as post_visid_low,
count(distinct(post_visid_high||mcvisid)) as concat_post_visid_high_mcvisid

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) ='2017-10-01'
group by 1
order by 1 desc



SELECT * FROM usage.mendeley.aa_datafeed_mendeley LIMIT 100;



SELECT date_trunc('month',post_cust_hit_time_gmt) as month,
count(distinct(mcvisid)) as unique_visitors, 
count(distinct(post_visid_high)) as post_visid_high, 
count(distinct(post_visid_low)) as post_visid_low,
count(distinct(post_visid_high||mcvisid)) as concat_post_visid_high_mcvisid,
count(*) as occurences

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) ='2017-10-01'
group by 1
order by 1 desc

1,646,397

1,657,065

1,657,231
user_access_type_v33
18,343,332



SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt)

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) ='2017-10-01'
order by 1,2


select a.*,
datediff('s',lag_time,post_cust_hit_time_gmt) as gap
,case when datediff('s',lag_time,post_cust_hit_time_gmt)>1800 or lag_time is null then 1 else 0 end as visit_flag

from (
SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt) as lag_time

FROM mendeley.aa_datafeed_mendeley
where date_trunc('day',post_cust_hit_time_gmt) ='2017-10-01'
and mcvisid not in ('00000000000000000000000000000000000000')
order by 1,2) a


select sum(visit_flag) as visits,
count(distinct(mcvisid)) as unique_visitors,
count(*) as occurences

from (

select a.*,
datediff('s',lag_time,post_cust_hit_time_gmt) as gap
,case when datediff('s',lag_time,post_cust_hit_time_gmt)>1800 or lag_time is null then 1 else 0 end as visit_flag

from (
SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt) as lag_time

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) >'2016-10-01'
order by 1,2) a
)

3,664,496

1,646,397

'2017-05-13 11:09:49'


select date_trunc('month',post_cust_hit_time_gmt) as index_ts,
sum(visit_flag) as visits,
count(distinct(mcvisid)) as unique_visitors,
count(*) as occurences

from (

select a.*,
datediff('s',lag_time,post_cust_hit_time_gmt) as gap
,case when datediff('s',lag_time,post_cust_hit_time_gmt)>1800 or lag_time is null then 1 else 0 end as visit_flag

from (
SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt) as lag_time

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) >='2016-07-01'
order by 1,2) a
)
group by 1
order by 1 desc

-----simple MAU + AA Data 


select a.index_ts,
MAU,
visits,
unique_visitors,
occurences

from (
select index_ts,
count(distinct(profile_id)) as MAU

from mendeley.active_users 
where index_ts>='2016-07-01'
group by 1)  a

left join (select date_trunc('month',post_cust_hit_time_gmt) as index_ts,
sum(visit_flag) as visits,
count(distinct(mcvisid)) as unique_visitors,
count(*) as occurences

from (

select a.*,
datediff('s',lag_time,post_cust_hit_time_gmt) as gap
,case when datediff('s',lag_time,post_cust_hit_time_gmt)>1800 or lag_time is null then 1 else 0 end as visit_flag

from (
SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt) as lag_time

FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) >='2016-07-01'
order by 1,2) a
)
group by 1
order by 1 desc) b
on a.index_ts=b.index_ts


----Complex MAU and AA Data

select a.*,
visits,
unique_visitors,
occurences

from (select index_ts, 
--case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 or Sneak_peak_views>=1 or Catalogue_interactor_views>=1 then 1 else 0 end as ROS_SOCIAL_FLAG,
max(max_date) as max_date,
count(distinct(profile_id)) as MDLY_USERS,
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when group_views>=1 then 1 else 0 end) as group_users,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,
sum(case when feed2_views>=1 then 1 else 0 end) as Newsfeed_viewing_users,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
or Sneak_peak_views>=1 or Catalogue_interactor_views>=1 then 1 else 0 end) as ROS_SOCIAL_users,
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
sum(case when Sneak_peak_views>=1 then 1 else 0 end) as Sneak_peek_users,
sum(case when new_user>=1 then 1 else 0 end) as new_user
	

from (	

select a.*, b.feed_views, b.group_views, b.Catalogue_interactor_views  from (

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
					sum(case when le.client_id in (3518) then 1 else 0 end) as Careers_views,
					sum(case when date_trunc('month',joined)=le.index_ts then 1 else 0 end) as new_user
	

from mendeley.dashboard_1m le
left join mendeley.profiles d
on le.profile_id=d.uu_profile_id

	where le.index_ts >= '2016-07-01'
	group by 1,2
	order by 1,2) a
	left join (select profile_id, 
date_trunc('month', index_ts) as index_ts,
max(index_ts) as max_date,
sum(case when product in ('Active Newsfeed') then 1 else 0 end) as feed_views,
sum(case when product in ('Feed Groups Filter Interactor','Community Viewers','Desktop Group Viewers','Group') then 1 else 0 end) as group_views,
sum(case when product in ('Catalog Recommendation Interactors') then 1 else 0 end) as Catalogue_interactor_views

from mendeley.ros_social_users_per_day
where index_ts >= '2016-07-01' and index_ts<date_trunc('month',getdate()) 
group by 1,2
) b
	on a.profile_id=b.profile_id
	and a.index_ts=b.index_ts
  ) c
  group by 1)  a

left join 
(select date_trunc('month',post_cust_hit_time_gmt) as index_ts,
sum(visit_flag) as visits,
count(distinct(mcvisid)) as unique_visitors,
count(*) as occurences
from (
select a.*,
datediff('s',lag_time,post_cust_hit_time_gmt) as gap
,case when datediff('s',lag_time,post_cust_hit_time_gmt)>1800 or lag_time is null then 1 else 0 end as visit_flag
from (
SELECT mcvisid,
post_cust_hit_time_gmt, 
lag(post_cust_hit_time_gmt,1) over (partition by  mcvisid order by post_cust_hit_time_gmt) as lag_time
FROM mendeley.aa_datafeed_mendeley
where date_trunc('month',post_cust_hit_time_gmt) >='2016-07-01'
order by 1,2) a) group by 1
order by 1 desc) b
on a.index_ts=b.index_ts




select * from mendeley.groups a 
left join mendeley.group_members b
on a.id=b.group_id
where id=6612731

