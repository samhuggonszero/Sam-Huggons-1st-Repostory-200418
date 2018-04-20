select * from mendeley.ros_social_feed_events limit 10


select * from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2017-11-01')


17,482,867 

16,994,078



select count(*) from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2018-01-12' and index_ts<'2018-01-18')


select * from mendeley.ros_social_feed_events 
where page_load_id in (
select distinct page_load_id from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2018-01-12' and index_ts<'2018-01-18')


---------429,438,615

select count(*) from mendeley.ros_social_feed_events 
where page_load_id  not in (
select distinct page_load_id from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2018-01-12' and index_ts<'2018-01-18')


----------------

select * from mendeley.ros_social_feed_events a

inner join (select distinct page_load_id, random() as rand from mendeley.ros_social_feed_events 
where page_load_id  not in (
select distinct page_load_id from mendeley.ros_social_feed_events 
where item_type like '%chem%'
and index_ts>='2018-01-12' and index_ts<'2018-01-18')) b

on a.page_load_id=b.page_load_id
and rand>0.99










