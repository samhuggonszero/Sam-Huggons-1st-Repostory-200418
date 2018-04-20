SELECT * FROM usage.mendeley.ros_kmau LIMIT 100;




select index_ts,
cohort_month,
datediff('month',cohort_month,index_ts) as tenure_month,
count(distinct(a.web_user_id)) as users

from mendeley.ros_kmau a
left join (select web_user_id, min(index_ts) as cohort_month 
from mendeley.ros_kmau group by 1) b
on a.web_user_id=b.web_user_id
where index_ts<date_trunc('month', getdate())
group by 1,2,3


---------------



select index_ts,
cohort_month,
subject_area,
datediff('month',cohort_month,index_ts) as tenure_month,
count(distinct(a.web_user_id)) as users

from mendeley.ros_kmau a
left join (select web_user_id, min(index_ts) as cohort_month 
from mendeley.ros_kmau group by 1) b
on a.web_user_id=b.web_user_id
left join (select web_user_id, subject_area from mendeley.profiles where web_user_id>0) c
on a.web_user_id=c.web_user_id
where index_ts<date_trunc('month', getdate())
group by 1,2,3,4


-------------automated

select a.*,
b.original_month_users

from (
select index_ts,
cohort_month,
subject_area,
datediff('month',cohort_month,index_ts) as tenure_month,
count(distinct(a.web_user_id)) as users

from mendeley.ros_kmau a
left join (select web_user_id, min(index_ts) as cohort_month 
from mendeley.ros_kmau group by 1) b
on a.web_user_id=b.web_user_id
left join (select web_user_id, subject_area from mendeley.profiles where web_user_id>0) c
on a.web_user_id=c.web_user_id
where index_ts<date_trunc('month', getdate())
group by 1,2,3,4 ) a

left join (
select cohort_month, subject_area, count(distinct(web_user_id)) as original_month_users from
(select a.web_user_id, subject_area, min(index_ts) as cohort_month 
from mendeley.ros_kmau a
left join (select web_user_id, subject_area from mendeley.profiles where web_user_id>0) c
on a.web_user_id=c.web_user_id
group by 1,2)
group by 1,2) b
on a.cohort_month=b.cohort_month
and a.subject_area=b.subject_area






