SELECT * FROM usage.mendeley.mie_signups_mau LIMIT 100;

mie_signups, 

select * from mendeley.profiles limit 10

select * from mendeley.profiles where mie_user not in (0) 


select date_trunc('month',joined) as index_ts,
count(distinct(case when mie_user =1 or b.is_mie=1 then uu_profile_id end)) as mie_sign_ups,
count(distinct(case when institution_id >0 then uu_profile_id end)) as institutional_sign_ups,
count(distinct(uu_profile_id)) as signups

from mendeley.profiles a
left join mendeley.institutions b
on b.id=a.institution_id
group by 1
order by 1 desc

--when from an institution with MIE or in MIE group or ?


is_mie
institution_id, 

select * from spectrum_docs.documents limit 10
doi, 

10.1016/j.biocel.2016.07.019 

select * from spectrum_docs.documents where doi='10.1016/j.biocel.2016.07.019'


select distinct uuid, doi from spectrum_docs.documents where doi='10.1016/j.biocel.2016.07.019' and uuid not in ('')  

select count(*) from spectrum_docs.documents


select distinct client_id, event_name, count(*) from mendeley.active_users_by_client_by_event_non_whitelisted_per_day limit 100


select client_id, event_name, count(*) from mendeley.active_users_by_client_by_event_non_whitelisted_per_day 
where index_ts>='2017-01-01'

group by 1,2 order by 3 desc

