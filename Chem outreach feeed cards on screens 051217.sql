select * from mendeley.ros_social_feed_events limit 10

select distinct item_type from mendeley.ros_social_feed_events


select distinct profile_id from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')



select * from mendeley.ros_social_feed_events 
where profile_id in (
select distinct profile_id from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
)




select * from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
)




select * from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
)



select * from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
)





---- how mnay page loads had at least 1 card on them in chem that had no cards viewed? - 42.7%


select count(distinct(page_load_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemViewed                '


1847

select count(distinct(page_load_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemDisplayed             '


4329

select count(distinct(page_load_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemClicked             '

126

---------same again but on user basis

select count(distinct(profile_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemViewed                '

767

select count(distinct(profile_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemDisplayed             '

990

select count(distinct(profile_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemClicked             '

88

---------same again but on item basis

select count(distinct(item_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemViewed                '

4103

select count(distinct(item_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemDisplayed             '

12096

select count(distinct(item_id)) from mendeley.ros_social_feed_events 

where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and event_name='FeedItemClicked             '

127

--- of those pushed a card how many saw a card?


select * from mendeley.sh_temp_gaia_editors_021117 limit 10

select count(distinct(folder)) from mendeley.sh_temp_gaia_editors_021117



-----all together now

select event_name, 
date_trunc('month',index_ts) as month,
count(distinct(item_id)) as items ,
count(distinct(page_load_id)) as page_loads,
count(distinct(profile_id)) as users

from mendeley.ros_social_feed_events 
where item_type in ('third-party-rosx-chem-CON-Els','third-party-rosx-chem-CON-MT','third-party-rosx-chem-RL-DOW','third-party-rosx-chem-RL-EP-group',
'third-party-rosx-chem-RL-EP-jhp','third-party-rosx-chem-RL-TOC','third-party-rosx-gunter-chem-CON-Els',
'third-party-rosx-gunter-chem-FUN','third-party-rosx-gunter-chem-RL-CIT','third-party-rosx-gunter-chem-RL-DOW','third-party-rosx-gunter-chem-RL-EP-group',
'third-party-rosx-gunter-chem-RL-EP-jhp','third-party-rosx-gunter-chem-RL-SI','third-party-rosx-gunter-chem-RL-TOC')
and index_ts<'2018-01-01'

