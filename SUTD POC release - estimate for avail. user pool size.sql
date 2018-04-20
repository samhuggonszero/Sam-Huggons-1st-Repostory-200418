select user_role, Subject_area, c.country, count(distinct(b.uu_profile_id)) as users 

from mendeley.profiles b
left join mendeley.profile_countries c
on b.uu_profile_id=c.profile_id
left join mendeley.institutions i
on b.institution_id=i.id
group by 1,2,3


select Subject_area, 
count(distinct(b.uu_profile_id)) as users 

from mendeley.profiles b
left join mendeley.profile_countries c
on b.uu_profile_id=c.profile_id
left join mendeley.institutions i
on b.institution_id=i.id
group by 1
order by 2 desc



'Medicine and Dentistry''Agricultural and Biological Sciences'

'Biochemistry, Genetics and Molecular Biology' -233,858




select Subject_area, 
--c.country,
scopus_claimed,
SD_last_30_days,
count(distinct(b.uu_profile_id)) as users 

from mendeley.profiles b
left join mendeley.profile_countries c	
on b.uu_profile_id=c.profile_id
left join mendeley.institutions i
on b.institution_id=i.id
left join (select profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors where claim_status='active' group by 1) d
on b.uu_profile_id=d.profile_id
left join (select distinct web_user_id, 1 as SD_last_30_days from mendeley.sv_aa_datafeed_sd
 where post_cust_hit_time_gmt>getdate()-32 and web_user_id>0) e
on b.web_user_id=e.web_user_id

group by 1,2,3
order by 4 desc








select distinct web_user_id, 1 as SD_last_30_days from mendeley.sv_aa_datafeed_sd
where post_cust_hit_time_gmt>getdate()-32 and web_user_id>0


select * from spectrum_aa.aa_datafeed_sd limit 100

select * from mendeley.sv_aa_datafeed_sd limit 100
user_id_entitling_p12, user_id_entitling_v29, 


select max(post_cust_hit_time_gmt) from mendeley.sv_aa_datafeed_sd limit 100 --'2018-02-25 04:59:59'
select count(distinct(web_user_id)) from mendeley.sv_aa_datafeed_sd where post_cust_hit_time_gmt>getdate()-32 and web_user_id>0 --562096


select count(distinct(web_user_id)) from mendeley.sv_aa_datafeed_sd 
where post_cust_hit_time_gmt>'2017-12-31' and post_cust_hit_time_gmt<'2018-02-01' and web_user_id>0 -- 


post_cust_hit_time_gmt, mcvisid, web_user_id, 




select Subject_area, 
scopus_claimed,
Platform,
SD_last_30_days,
index_ts,
count(distinct(a.web_user_id)) as users 

from mendeley.ros_kmau a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id
left join (select profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors where claim_status='active' group by 1) d
on b.uu_profile_id=d.profile_id
left join (select distinct web_user_id, 1 as SD_last_30_days from mendeley.sv_aa_datafeed_sd
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' and web_user_id>0) e
on a.web_user_id=e.web_user_id
where a.index_ts='2018-01-01'
group by 1,2,3,4,5
order by 6 desc


