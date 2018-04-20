--drop TABLE  mendeley.sh_temp_visitor_id_to_country_map_feb18;
create table mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18(

profile_id VARCHAR(108)  ENCODE LZO


)DISTKEY(profile_id) SORTKEY(profile_id);
GRANT SELECT ON mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18 TO GROUP mendeley_reader;


select * from  mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18 limit 10;

select visitor_id, count(*) from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18 group by 1 having count(*)>1;

select  count(*) from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18

select  count(distinct(visitor_id)) from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18


Date From:	2017-10-25 00:00:00
Date To:	2017-10-31 23:59:59

C:\Users\huggonss\Documents\002. Data
Acquisition_driver_tree_POC_081117.csv

select a.profile_id,
sum(case when event_name='FeedItemViewed' then 1 else 0 end) as views,
sum(case when event_name='FeedItemClicked' then 1 else 0 end) as clicks,
sum(case when event_name='FeedItemDisplayed' then 1 else 0 end) as displays

from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18 a
left join mendeley.ros_social_feed_events b
on a.profile_id=b.profile_id
where item_type like '%chem%'
and index_ts>='2017-11-03' and index_ts<='2018-02-28'
group by 1


select a.profile_id,
sum(case when event_name='FeedItemViewed' then 1 else 0 end) as views,
sum(case when event_name='FeedItemClicked' then 1 else 0 end) as clicks,
sum(case when event_name='FeedItemDisplayed' then 1 else 0 end) as displays

from mendeley.ros_social_feed_events b
where item_type like '%chem%'
and index_ts>='2017-11-03' and index_ts<='2018-02-28'
group by 1


select count(*) from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18


select a.profile_id,
case when views is null then 0 else views end as views,
case when clicks is null then 0 else clicks end as clicks,
case when displays is null then 0 else displays end as displays,
case when views>0 and clicks>0 then '3.Chemsitry outreach card viewers who also clicked' 
when views=0 and clicks>0 then '3.Chemsitry outreach card viewers who also clicked' 
when views>0 and (clicks=0 or clicks is null) then '2.Chemsitry outreach card viewers who did not click'
when (views=0 or views is null)  and (clicks=0 or clicks is null)then '1.Chemsitry outreach card non viewers'
else '4.error' 
end as chem_outreach_segment

from mendeley.sh_temp_chem_outreach_profile_ids_nov17_feb18 a
left join (select profile_id,
sum(case when event_name='FeedItemViewed' then 1 else 0 end) as views,
sum(case when event_name='FeedItemClicked' then 1 else 0 end) as clicks,
sum(case when event_name='FeedItemDisplayed' then 1 else 0 end) as displays

from mendeley.ros_social_feed_events b
where item_type like '%chem%'
and index_ts>='2017-11-03' and index_ts<='2018-02-28'
group by 1) b
on a.profile_id=b.profile_id




Hour
Visitor_ID
User_Entitling_ID_p12_prop12
Visit_Number
Conversion_Driver_v103_evar103
GeoSegmentation_Countries
GeoSegmentation_Cities
GeoSegmentation_States
Tracking_Code
Testing_ID_v22_evar22
Entry_Pages
Referrer_Type
Referring_Domains
Referrers
Registrations_e2_event2
Visits
