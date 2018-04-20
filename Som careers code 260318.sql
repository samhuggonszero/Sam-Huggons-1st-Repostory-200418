SELECT
	DISTINCT
        DATE_TRUNC('month', cdlj.index_ts) AS index_ts,
	cdlj.job_id,
        ce.nr_applications,
        ce.nr_views,
        ce.nr_shortlist
FROM
	mendeley.careers_daily_live_jobs cdlj
LEFT JOIN
	(SELECT
		DATE_TRUNC('month', ts) AS index_ts,
		job_id,
                SUM(CASE WHEN event_name = 'Application' THEN 1 ELSE 0 END) AS nr_applications,
                SUM(CASE WHEN event_name = 'View' THEN 1 ELSE 0 END) AS nr_views,
                SUM(CASE WHEN event_name = 'Shortlist' THEN 1 ELSE 0 END) AS nr_shortlist
	FROM
		mendeley.careers_events
	GROUP BY
		1,2) ce ON cdlj.job_id = ce.job_id AND DATE_TRUNC('month', cdlj.index_ts) = ce.index_ts
		
		
	SELECT
       COUNT(*) AS nr_active_days
FROM
    mendeley.careers_daily_live_jobs

select * from mendeley.careers_daily_live_jobs


24151882
		
select * from mendeley.careers_daily_live_jobs limit 100
select * from mendeley.careers_jobs limit 100

select count(*) from ( --649583
select job_id, job_title, location_description, salary_description, discipline, city_latitude, city_longitude, country
from mendeley.careers_jobs 
where start_date>='2018-01-01')

city, city, 
city_latitude, city_longitude, county, county_latitude, county_longitude, country, country_latitude, country_longitude, postcode, location_description, 

select count(*) from mendeley.careers_jobs 
where start_date>='2016-01-01'

1,914,136

1914127

limit 100


select a.visitor_id, a.event_name, b.GeoSegmentation_Countries from mendeley.careers_events a
left join mendeley.sh_temp_visitor_id_to_country_map_feb18 b
on a.visitor_id=b.visitor_id
where ts>='2018-01-01' and ts<'2018-01-02'
and event_name='Application'
limit 100
			
						
select a.mcvisid, b.visitor_id, b.GeoSegmentation_Countries from mendeley.sv_aa_datafeed_md a
left join mendeley.sh_temp_visitor_id_to_country_map_feb18 b
on trim(a.mcvisid)=trim(replace(b.visitor_id,'_',''))
where post_cust_hit_time_gmt>='2018-02-01' and post_cust_hit_time_gmt<'2018-02-02'
limit 100						

select * from mendeley.sv_aa_datafeed_md where mcvisid='1000081056020162388772434958864602768' limit 100

select mcvisid, len(mcvisid) from mendeley.sv_aa_datafeed_md 
limit 100

'13840703079174727872070328759017316375'

'77074094010432841812286092157394264857'

select visitor_id, replace(b.visitor_id,'_','') , len(replace(b.visitor_id,'_','') )

from  mendeley.sh_temp_visitor_id_to_country_map_feb18 b limit 10;

'1000081056020162388772434958864602768'
'100008105602016238_8772434958864602768'
