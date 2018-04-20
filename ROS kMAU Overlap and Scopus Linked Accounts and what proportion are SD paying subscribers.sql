SELECT * FROM usage.mendeley.ros_kmau LIMIT 100;

select * from mendeley.profiles_scopus_authors limit 100


select web_user_id, platform,  

from  mendeley.ros_kmau
where index_ts='2018-01-01'


select distinct profile_id, 
1 as scopus_claimed 

from mendeley.profiles_scopus_authors 
where claim_status='active'
limit 100


select distinct platform  

from mendeley.ros_kmau
where index_ts='2018-01-01'

platform
md
jb
ev
ez
es
sc
sd
mdy_ke


select a.web_user_id, uu_profile_id, case when scopus_claimed is null then 0 else 1 end as scopus_claimed,
max(case when platform in ('md','mdy_ke') then 1 else 0 end) as mendeley, 
max(case when platform in ('jb') then 1 else 0 end) as JBS, 
max(case when platform in ('ev') then 1 else 0 end) as EngineeringVillage, 
max(case when platform in ('ez') then 1 else 0 end) as ez, 
max(case when platform in ('es') then 1 else 0 end) as es, 
max(case when platform in ('sc') then 1 else 0 end) as Scops, 
max(case when platform in ('sd') then 1 else 0 end) as ScienceDirect

from  mendeley.ros_kmau a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id

left join (select distinct profile_id, 
1 as scopus_claimed from mendeley.profiles_scopus_authors 
where claim_status='active') c
on b.uu_profile_id=c.profile_id

where index_ts='2018-01-01'
group by 1,2,3
limit 1000







select scopus_claimed, mendeley, JBS, EngineeringVillage, ez, es, Scopus, ScienceDirect, count(distinct(web_user_id)) as web_user_id

from (

select a.web_user_id, uu_profile_id, case when scopus_claimed is null then 0 else 1 end as scopus_claimed,
max(case when platform in ('md','mdy_ke') then 1 else 0 end) as mendeley, 
max(case when platform in ('jb') then 1 else 0 end) as JBS, 
max(case when platform in ('ev') then 1 else 0 end) as EngineeringVillage, 
max(case when platform in ('ez') then 1 else 0 end) as ez, 
max(case when platform in ('es') then 1 else 0 end) as es, 
max(case when platform in ('sc') then 1 else 0 end) as Scopus, 
max(case when platform in ('sd') then 1 else 0 end) as ScienceDirect

from  mendeley.ros_kmau a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id

left join (select distinct profile_id, 
1 as scopus_claimed from mendeley.profiles_scopus_authors 
where claim_status='active') c
on b.uu_profile_id=c.profile_id

where index_ts='2018-01-01'
group by 1,2,3
)
group by 1,2,3,4,5,6,7,8







select scopus_claimed, mendeley, JBS, EngineeringVillage, ez, es, Scopus, ScienceDirect, MDLY_registered, count(distinct(web_user_id)) as web_user_id

from (

select a.web_user_id, uu_profile_id, case when scopus_claimed is null then 0 else 1 end as scopus_claimed,
max(case when platform in ('md','mdy_ke') then 1 else 0 end) as mendeley, 
max(case when platform in ('jb') then 1 else 0 end) as JBS, 
max(case when platform in ('ev') then 1 else 0 end) as EngineeringVillage, 
max(case when platform in ('ez') then 1 else 0 end) as ez, 
max(case when platform in ('es') then 1 else 0 end) as es, 
max(case when platform in ('sc') then 1 else 0 end) as Scopus, 
max(case when platform in ('sd') then 1 else 0 end) as ScienceDirect,
max(case when b.web_user_id is not null then 1 else 0 end) as MDLY_registered

from  mendeley.ros_kmau a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id

left join (select distinct profile_id, 
1 as scopus_claimed from mendeley.profiles_scopus_authors 
where claim_status='active') c
on b.uu_profile_id=c.profile_id

where index_ts='2018-01-01'
group by 1,2,3
)
group by 1,2,3,4,5,6,7,8,9











