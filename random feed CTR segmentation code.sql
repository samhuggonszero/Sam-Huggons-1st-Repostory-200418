
select index_ts, 
item_type, 
seniority,
user_role,
subject_area,
client_id,
case when scopus_claimed is null then 0 else 1 end as scopus_claimed,
case when datediff('day',joined,index_ts)=0 then '1st Day' 
when datediff('day',joined,index_ts) >=2 and datediff('day',joined,index_ts)<=7 then '2-7 Days' 
when datediff('day',joined,index_ts) >=8 and datediff('day',joined,index_ts)<=30 then '8-30 Days' 
when datediff('day',joined,index_ts) >=31 and datediff('day',joined,index_ts)<=365 then '31-365 Days'
when datediff('day',joined,index_ts) >=366 then '>365 Days'
else 'error' end as user_tenure,
sum(case when event_name='FeedItemViewed                ' then 1 else 0 end) as FeedItemViewed,
sum(case when event_name='FeedItemClicked               ' then 1 else 0 end) as FeedItemClicked

from mendeley.ros_social_feed_events a 
left join (select uu_profile_id,
a.user_role,
subject_area,
joined, 
seniority

from mendeley.profiles a
left join mendeley.user_role_to_seniority_map b
on a.user_role=b.user_role) b
on a.profile_id=b.uu_profile_id
left join (select distinct profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors where claim_status='active') c
on a.profile_id=c.profile_id
group by 1,2,3,4,5,6,7,8


select * from mendeley.ros_social_feed_events limit 10