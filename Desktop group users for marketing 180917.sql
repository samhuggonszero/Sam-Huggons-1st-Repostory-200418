SELECT profile_id, product, max(index_ts) as max_date, min(index_ts)  as min_date 
FROM usage.mendeley.ros_social_users_per_day
where product='Desktop Group Viewers' 
and index_ts>'2017-03-17' and index_ts<getdate()
group by 1,2