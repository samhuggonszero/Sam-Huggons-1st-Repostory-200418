SELECT * FROM usage.mendeley.profiles LIMIT 100;
SELECT * FROM usage.mendeley.profiles_ae LIMIT 100;
SELECT * FROM usage.mendeley.profiles_scopus_authors LIMIT 100;

select * from mendeley.SH_TEMP_Chemistry_outreach_datascience_scopus_universe_181017 limit 10 
 
 --check authors 1
select case when scopus_id is null then 0 else 1 end as profile_table_match,
count(distinct(authorid))
from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors a
left join usage.mendeley.profiles_ae b
on a.authorid=b.scopus_id
group by 1


 --check authors 2 - 118,219
select case when scopus_author_id is null then 0 else 1 end as profile_table_match,
count(distinct(authorid))
from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors a
left join usage.mendeley.profiles_scopus_authors b
on a.authorid=b.scopus_author_id
group by 1

select  count(*) from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors
3715228
SELECT count(*) FROM usage.mendeley.profiles_scopus_authors LIMIT 100;
529527




'2-s2.0-0000022637                                 '
7201855525

trim(substring(a.eid,8,100))

 usage.scopus.dim_document
 
select * from  mendeley.SH_TEMP_Chemistry_outreach_datascience_scopus_universe_181017 a
left join scopus.dim_document b
on a.eid=b.document_eid
limit 100






--has authored doc in library from chemistry docs
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from spectrum_docs.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 
and trim(substring(a.cluster_centre,9,100)) in (select eid from mendeley.SH_TEMP_Chemistry_outreach_datascience_scopus_universe_181017)
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	


select * from spectrum_docs.documents limit 10


--- subject areas

select case when scopus_author_id is null then 0 else 1 end as profile_table_match,
subject_area,
seniority,
case when subject_area in ('Chemistry','Chemical Engineering') then 1 else 0 end as chemistry_or_chemical_eng_mdly_sub_area,
count(distinct(authorid))
from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors a
left join usage.mendeley.profiles_scopus_authors b
on a.authorid=b.scopus_author_id
left join mendeley.profiles c
on b.profile_id=c.uu_profile_id
left join mendeley.user_role_to_seniority_map d
on c.user_role=d.user_role
group by 1,2,3,4


select count(*) from mendeley.profiles where subject_area in ('Chemistry','Chemical Engineering') 

360351



select subject_area,
seniority,
c.user_role,
case when subject_area in ('Chemistry','Chemical Engineering') then 1 else 0 end as chemistry_or_chemical_eng_mdly_sub_area,
count(distinct(a.profile_id))
from mendeley.sh_temp_chemistry_editors_outreach_311017 a
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
left join mendeley.user_role_to_seniority_map d
on c.user_role=d.user_role
group by 1,2,3,4


