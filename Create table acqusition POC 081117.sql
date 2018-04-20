--drop TABLE  mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31;
create table mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31(
date VARCHAR(30) ENCODE LZO,
Visitor_ID VARCHAR(108)  ENCODE LZO,
user_entitling_id_p12_prop12 VARCHAR(107)  ENCODE LZO,
Visit_Number integer ENCODE LZO,
conversion_driver_v103_evar103 VARCHAR(100)  ENCODE LZO,
GeoSegmentation_Countries VARCHAR(101) ENCODE LZO,
GeoSegmentation_States VARCHAR(103) ENCODE LZO,
Tracking_Code VARCHAR(104) ENCODE LZO,
Entry_Pages VARCHAR(105) ENCODE LZO,
Referrer_Type VARCHAR(20) ENCODE LZO,	
Referring_Domains VARCHAR(106) ENCODE LZO,
Registrations_e2_event2 integer ENCODE LZO,
Visits integer ENCODE LZO

)DISTKEY(Visitor_ID) SORTKEY(Visitor_ID);
GRANT SELECT ON mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31 TO GROUP mendeley_reader;


select * from  mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31 limit 10;

select folder, count(*) from mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31 group by 1 having count(*)>1;

select  count(*) from mendeley.sh_temp_Acquisition_driver_tree_POC_2017_10_25__2017_10_31


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
