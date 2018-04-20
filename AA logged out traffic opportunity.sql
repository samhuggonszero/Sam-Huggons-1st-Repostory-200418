SELECT * FROM usage.mendeley.aa_datafeed_mendeley LIMIT 100;


user_access_type_v33, 'md:guest' web_user_id, mcvisid as AAcookieID, 

user_access_type_v33 in ('md:guest')

select distinct 


----checks on traffic
select date_trunc('month',post_cust_hit_time_gmt) as month,
user_access_type_v33,
case when web_user_id = '' then 0 else 1 end as web_user_id,
count(distinct(mcvisid)) as AAcookieID

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
and post_pagename not in ('Web-Importer')
group by 1,2,3





----logged out traffic cookie ID opportunity
select ref_type,
referer,
count(distinct( mcvisid)) as AA_cookies

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')
group by 1


select ref_type,
case when ref_type=6 then 'Type/Bookmarked' 
when ref_type=1 then 'Other web sites'
when ref_type=3 then 'Serach engines'
when ref_type=2 then 'Social networks'
when ref_type=9 then 'None' end as ref_type_decode,

count(distinct( mcvisid)) as AA_cookies

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')
group by 1,2

ref_type	aa_cookies	
6	1081560	case when ref_type=6 then 'Type/Bookmarked' 
1	892778	Other web sites
3	622084	Serach engines
2	564997	Scoial networks
9	33237	????



----
select count(distinct( mcvisid)) as AA_cookies

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')



---opportunity by ref type
select ref_type,
case when ref_type=6 then 'Type/Bookmarked' 
when ref_type=1 then 'Other web sites'
when ref_type=3 then 'Serach engines'
when ref_type=2 then 'Social networks'
when ref_type=9 then 'None' end as ref_type_decode,
count(distinct( mcvisid)) as AA_cookies

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')
group by 1,2

---% entering reg flow - needs to be only those that had opportunity to reg but then entered flow
select ref_type,
case when ref_type=6 then 'Type/Bookmarked' 
when ref_type=1 then 'Other web sites'
when ref_type=3 then 'Serach engines'
when ref_type=2 then 'Social networks'
when ref_type=9 then 'None' end as ref_type_decode,
count(distinct(mcvisid)) as AA_cookies_entering_reg_flow

from mendeley.aa_datafeed_mendeley
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
--and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')
and post_pagename in ('md:join','md:join:import')
group by 1,2


--dsitinct page names
select post_pagename,
count(*)

from mendeley.aa_datafeed_mendeley
group by 1 order by 2 desc


--Opportunity logged out pages
md:paper
md:profile
md:papers:individual-entry
md:homepage
md:download/windows-instructions
md:download/mac-instructions
md:download/main
md:profile:overview
md:cms-downloads
md:jobs:browse-jobs
md:jobs:search
md:jobs:job
md:jobs
md:search:papers:search-query
md:sneak-peek:cellpress:papers
md:cms-reference-manager


----checj436
select
mcvisid,
a.web_user_id,
uu_profile_id as profile_id,
joined,
max(case when user_access_type_v33='md:registered-user' then 1 else 0 end) as ever_md_registered_user,
count(*),
count(distinct(mcvisid)) as mcvisid_count

from mendeley.aa_datafeed_mendeley a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id 
where post_cust_hit_time_gmt>='2017-03-01' and post_cust_hit_time_gmt<'2017-04-01'
--and mcvisid not in (select mcvisid from mendeley.aa_datafeed_mendeley where user_access_type_v33='md:registered-user')
group by 1,2,3,4
order by 6 desc


--identity table -- once you have this table split by --post_pagename,ref type,country and others etc.
--max	min
--2017-08-21 03:59:59	2016-05-27 13:51:38
-- daily data with from '2016-05-27' till yesterday so 15+ months currently and 18m cookie ID's so potential 16m ish row table maybe?
---awesome base coe for metrics which can later be split by dimensions
with id_table as (
select 
a.web_user_id,
mcvisid,
uu_profile_id as profile_id,
joined,
max(case when user_access_type_v33='md:registered-user' then 1 else 0 end) as ever_md_registered_user

from mendeley.aa_datafeed_mendeley a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id 
group by 1,2,3,4
)

select b.*,
date_trunc('month',post_cust_hit_time_gmt) as index_ts,
max(case when post_cust_hit_time_gmt<joined or joined is null then 1 else 0 end) as Opportunity_traffic,
max(case when post_pagename in ('md:join','md:join:import') then 1 else 0 end) as Enter_reg_flow_in_month,
max(case when date_trunc('month',post_cust_hit_time_gmt)=date_trunc('month',joined) then 1 else 0 end) as Complete_reg_flow_in_month

from mendeley.aa_datafeed_mendeley a
left join id_table b
on a.mcvisid=b.mcvisid
group by 1,2,3,4,5,6
limit 1000

--code suitable for tableau summary
with id_table as (
select 
a.web_user_id,
mcvisid,
uu_profile_id as profile_id,
joined,
max(case when user_access_type_v33='md:registered-user' then 1 else 0 end) as ever_md_registered_user

from mendeley.aa_datafeed_mendeley a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id 
group by 1,2,3,4
)

select 
date_trunc('month',joined) as join_month,
index_ts,
count(distinct(case when Opportunity_traffic=1 then mcvisid end)) as Opportunity_traffic,
count(distinct(case when Enter_reg_flow_in_month=1 then mcvisid end)) as Enter_reg_flow_in_month,
count(distinct(case when Complete_reg_flow_in_month=1 then mcvisid end)) as Complete_reg_flow_in_month

from (
select b.*,
date_trunc('month',post_cust_hit_time_gmt) as index_ts,
max(case when post_cust_hit_time_gmt<joined or joined is null then 1 else 0 end) as Opportunity_traffic,
max(case when post_pagename in ('md:join','md:join:import') then 1 else 0 end) as Enter_reg_flow_in_month,
max(case when date_trunc('month',post_cust_hit_time_gmt)=date_trunc('month',joined) then 1 else 0 end) as Complete_reg_flow_in_month

from mendeley.aa_datafeed_mendeley a
left join id_table b
on a.mcvisid=b.mcvisid
group by 1,2,3,4,5,6
)
group by 1,2



--attempt 2 --you can have many cookie ID's to 1 web user ID check that out
with id_table as (
select a.web_user_id,
mcvisid,
uu_profile_id as profile_id,
joined,
max(case when user_access_type_v33='md:registered-user' then 1 else 0 end) as ever_md_registered_user

from mendeley.aa_datafeed_mendeley a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id 
group by 1,2,3,4
limit 10000
)

select 
index_ts,
count(distinct(mcvisid)) as unique_visitors_aa_cookies,
count(distinct(case when Opportunity_traffic=1 then mcvisid end)) as Opportunity_traffic,
count(distinct(case when Enter_reg_flow_in_month=1 then mcvisid end)) as Enter_reg_flow_in_month,
count(distinct(case when Complete_reg_flow_in_month=1 then web_user_id end)) as Complete_reg_flow_in_month

from (
select b.*,
date_trunc('month',post_cust_hit_time_gmt) as index_ts,
max(case when post_cust_hit_time_gmt<joined or joined is null then 1 else 0 end) as Opportunity_traffic,
max(case when post_pagename in ('md:join','md:join:import') then 1 else 0 end) as Enter_reg_flow_in_month,
max(case when date_trunc('month',post_cust_hit_time_gmt)=date_trunc('month',joined) 
and joined is not null then 1 else 0 end) as Complete_reg_flow_in_month

from mendeley.aa_datafeed_mendeley a
left join id_table b
on a.mcvisid=b.mcvisid
group by 1,2,3,4,5,6
)
group by 1



