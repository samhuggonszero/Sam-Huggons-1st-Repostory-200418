--drop TABLE  mendeley.sh_temp_visitor_id_to_country_map_feb18;
create table mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418(

web_user_id VARCHAR(108)  ENCODE LZO


)DISTKEY(web_user_id) SORTKEY(web_user_id);
GRANT SELECT ON mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418 TO GROUP mendeley_reader;


select * from  mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418 limit 10;

select web_user_id, count(*) from mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418 group by 1 having count(*)>1;

select  count(*) from mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418

select  count(distinct(visitor_id)) from mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418


Date From:	2017-10-25 00:00:00
Date To:	2017-10-31 23:59:59

C:\Users\huggonss\Documents\002. Data
Acquisition_driver_tree_POC_081117.csv
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
