SELECT * FROM usage.mendeley.ac_mc_delivery_logs LIMIT 100;


SELECT max(rt_event_date) FROM usage.mendeley.ac_mc_delivery_logs LIMIT 100;


SELECT * FROM usage.mendeley.ac_mc_delivery_logs where lower(delivery_label) like '%career%' limit 100

SELECT * FROM usage.mendeley.ac_mc_delivery_logs where lower(delivery_internal_name) like '%career%' limit 100

template_subject, 
delivery_internal_name, 

SELECT * FROM usage.mendeley.ac_delivery_logs LIMIT 100;

SELECT * FROM usage.mendeley.ac_deliveries LIMIT 100;

SELECT * FROM usage.mendeley.ac_deliveries
where lower(campaign_label) like '%career%' 
and contact_date>='2018-02-15'
limit 100



SELECT * FROM usage.mendeley.ac_deliveries
where --lower(campaign_label) like '%career%' and
 contact_date>='2018-02-15'
limit 100


SELECT * FROM usage.mendeley.ac_deliveries
where lower(delivery_label) like '%career%' and
 contact_date>='2018-02-15'
limit 100


SELECT delivery_label, count(*) FROM usage.mendeley.ac_deliveries
where --lower(delivery_label) like '%career%' and
contact_date>='2018-02-10'
group by 1
order by 2 desc
limit 100


SELECT delivery_id, count(*)
FROM usage.mendeley.ac_mc_delivery_logs
where --lower(delivery_label) like '%career%' and
rt_event_date>='2018-02-15'
group by 1
order by 2 desc


