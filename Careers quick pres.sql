SELECT * FROM usage.mendeley.careers_jobs LIMIT 100;

select
job_id,
job_title,
country,
location_description,
salary_band,
start_date

from mendeley.careers_jobs

select country,
date_trunc('month',start_date) as month_job_added,
count(*)

from mendeley.careers_jobs
where start_date>='2016-01-01'
group by 1,2