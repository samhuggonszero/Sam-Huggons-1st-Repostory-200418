
SELECT * FROM usage.mendeley.profiles_scopus_authors LIMIT 100;

SELECT * FROM usage.mendeley.profiles_ae LIMIT 100;
SELECT * FROM usage.mendeley.profile_stats_claim_per_day LIMIT 100;  -- actual def


select distinct profile_id, issn, is_author, publisher, index_ts as month_active_on_feed

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,8,100))=b.serial_detail_scopus_eid
left join (select date_trunc('month',index_ts) as index_ts , profile_id, client_id from mendeley.active_users_by_client_per_day where client_id=2364 group by 1,2,3) c
on a.uu_profile_id=c.profile_id
where publisher='ELSEVIER' and is_author=1
--and issn in ('928674','24519456','8966273','15345807','10972765','19313128','15504131','22111247','19345909','24054712','9609822','25424351','9692126')
and (index_ts<=date_trunc('month',getdate()) or index_ts is null)





select  case when scopus_claimed is null then 0 else scopus_claimed end as scopus_claimed,
is_author,
publisher,
count(distinct(a.profile_id)) as users

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,8,100))=b.serial_detail_scopus_eid
left join (select distinct profile_id, 1 as scopus_claimed from mendeley.profile_stats_claim_per_day) c
on a.profile_id=c.profile_id
where publisher='ELSEVIER' and is_author=1
group by 1,2,3



select  case when scopus_claimed is null then 0 else scopus_claimed end as scopus_claimed,
is_author,
publisher,
count(distinct(a.profile_id)) as users

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,8,100))=b.serial_detail_scopus_eid
left join (select distinct profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors) c
on a.profile_id=c.profile_id
where publisher='ELSEVIER' and is_author=1
group by 1,2,3


select count(distinct(profile_id)) from mendeley.profiles_scopus_authors-- actual total scopus Claims
442173



272504




select distinct a.profile_id, serial_detail_issn as issn, is_author, publisher, index_ts as month_active_on_feed

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
left join (select date_trunc('month',index_ts) as index_ts , profile_id, client_id from mendeley.active_users_by_client_per_day where client_id=2364 group by 1,2,3) c
on a.profile_id=c.profile_id
where  is_author=1
and  serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
and (index_ts<=date_trunc('month',getdate()) or index_ts is null)
and a.cluster_centre like '%scopus%'








select * from scidir.dim_serial_detail where serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
select distinct serial_detail_formatted_issn  from scidir.dim_serial_detail  where serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
select distinct serial_detail_formatted_issn  from scidir.dim_serial_detail  where serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
select distinct serial_detail_formatted_issn,  serial_detail_issn from scidir.dim_serial_detail  where trim(serial_detail_issn)  in ('14321475','01676296','10991050','17284457','16187601')





select * from mendeley.documents limit 100 
select * from scidir.dim_serial_detail limit 100 
select trim(substring(cluster_centre,8,100)) from mendeley.documents limit 100 
select publisher, count(*) from mendeley.documents group by 1 order by 2 desc

serial_detail_eid, '1-s2.0-0001616078900202'
cluster_centre, 'iscopus!2-s2.0-84902649677'
 trim(substring(cluster_centre,8,100)) '!2-s2.0-33846354137'

select count(*) from usage.mendeley.documents a
inner join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=trim(b.serial_detail_scopus_eid)
where serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')

serial_detail_issn, 
Springer

select publisher, count(*)

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1
--and  serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
and a.cluster_centre like '%scopus%'
group by 1
order by 2 desc



select publisher, serial_detail_issn,  serial_detail_formatted_issn, count(*)

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1
--and  serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601')
and a.cluster_centre like '%scopus%'
and publisher='SPRINGER NATURE'
group by 1,2,3
order by 4 desc



select publisher, document_issn, count(*)
from mendeley.documents a
left join scopus.dim_document b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where publisher='SPRINGER NATURE'
group by 1,2
order by 3 desc


select document_issn, count(*) from scopus.dim_document  where document_issn in (14321475,01676296,10991050,17284457,16187601)
group by 1

select document_issn, count(*) from scopus.dim_document  
group by 1
order by 2 desc









-----preprint
select distinct a.profile_id, document_issn as issn, is_author, publisher, index_ts as month_active_on_feed

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
left join (select date_trunc('month',index_ts) as index_ts , profile_id, client_id from mendeley.active_users_by_client_per_day where client_id=2364 group by 1,2,3) c
on a.profile_id=c.profile_id
where  is_author=1
and  document_issn in (14321475,01676296,10991050,17284457,16187601)
and (index_ts<=date_trunc('month',getdate()) or index_ts is null)
and a.cluster_centre like '%scopus%'



----catlysis
select distinct a.profile_id, document_issn as issn, is_author, publisher, index_ts as month_active_on_feed

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
left join (select date_trunc('month',index_ts) as index_ts , profile_id, client_id from mendeley.active_users_by_client_per_day where client_id=2364 group by 1,2,3) c
on a.profile_id=c.profile_id
where  is_author=1
and  document_issn in (00219517)
and (index_ts<=date_trunc('month',getdate()) or index_ts is null)
and a.cluster_centre like '%scopus%'




select a.profile_id, serial_detail_issn as issn, is_author, publisher, index_ts as month_active_on_feed, max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
left join (select date_trunc('month',index_ts) as index_ts , profile_id, client_id from mendeley.active_users_by_client_per_day where client_id=2364 group by 1,2,3) c
on a.profile_id=c.profile_id
where  is_author=1
and  serial_detail_formatted_issn  in ('0021-9517')
and (index_ts<=date_trunc('month',getdate()) or index_ts is null)
and a.cluster_centre like '%scopus%'
group by 1,2,3,4,5





select * from mendeley.profiles limit 100

select distinct subject_area

from mendeley.profiles
limit 100

subject_area
Energy
Design
Linguistics
Sports and Recreations
Arts and Humanities
Engineering
Nursing and Health Professions
Business, Management and Accounting
Decision Sciences
Unspecified
Philosophy
Environmental Science
Materials Science
Social Sciences
Chemical Engineering
Economics, Econometrics and Finance
Computer Science
Medicine and Dentistry
Earth and Planetary Sciences
Veterinary Science and Veterinary Medicine
Mathematics
Biochemistry, Genetics and Molecular Biology

Neuroscience
Immunology and Microbiology
Chemistry
Agricultural and Biological Sciences
Physics and Astronomy
Psychology
Pharmacology, Toxicology and Pharmaceutical Science
#


---is in chemaistry subject area 354,763
select count(*) from  mendeley.profiles
where subject_area in ('Chemical Engineering','Chemistry')


--is in  research interests chemistry 7263
select count(*) from  mendeley.profiles
where research_interests like '%chemistry%'


--is in  research interests catalysis 929
select uu_profile_id from  mendeley.profiles
where research_interests like '%catalysis%'

--has document in library form catalysis 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('0021-9517')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4



----26835
select count(distinct(a.profile_id)) 

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('0021-9517')
and a.cluster_centre like '%scopus%'
