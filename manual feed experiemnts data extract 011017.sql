----non elsevier journals
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


--Elsevier journals
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


------------------------------EXP1 - EDITOR'S PICK experiment Catalysis------------------
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

------------------------------EXP2 - EDITOR'S PICK experiment biological conservation------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('0006-3207','0378-1127','0960-3115','1755-263X','1354-1013',
  '0888-8892','1367-9430','1470-160X')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (00063207,03781127,09603115,13541013,08888892,13679430)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%biological conservation%'
or research_interests like '%natural resource management%'
or research_interests like '%conservation%'
	
--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('0006-3207','0378-1127','0960-3115','1755-263X','1354-1013',
  '0888-8892','1367-9430','1470-160X')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Agricultural and Biological sciences')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (00063207,03781127,09603115,13541013,08888892,13679430)
and a.cluster_centre like '%scopus%'




------------------------------EXP3 - Reading list experiment Infectious Diseases------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('2352-7714','25425196','0167-5877','0147-9571','0021-9975','2210-6006','1477-8939')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (23527714,25425196,01675877,01479571,00219975,22106006,14778939)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%health%'
or research_interests like '%one health%'
or research_interests like '%global  health%'
	
--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('2352-7714','25425196','0167-5877','0147-9571','0021-9975','2210-6006','1477-8939')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Nursing and Health Professions','Medicine and Dentistry')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (23527714,25425196,01675877,01479571,00219975,22106006,14778939)
and a.cluster_centre like '%scopus%'

------------------------------EXP4 - reading list Do Humans Suffer a Psychological Low in Midlife? experiment ------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('1388-1981','0925-4439','0168-8227','1550-7289','0026-0495','0021-9150','0006-291X','1871-4021','1262-3636','1056-8727')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (13881981,09254439,01688227,15507289,00260495,00219150,18714021,12623636,10568727)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%obesity%'
or research_interests like '%diabetes%'

	
--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('1388-1981','0925-4439','0168-8227','1550-7289','0026-0495','0021-9150','0006-291X','1871-4021','1262-3636','1056-8727')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Nursing and Health Professions','Medicine and Dentistry')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (13881981,09254439,01688227,15507289,00260495,00219150,18714021,12623636,10568727)
and a.cluster_centre like '%scopus%'


------------------------------EXP5 - preprint experiment ------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050','1728-4457','1618-7601','2212-828X')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (14321475,01676296,10991050,17284457,16187601)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%economics%'
or research_interests like '%health economics%'
or research_interests like '%ageing'
	
--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('1432-1475','0167-6296','1099-1050',' 1728-4457','1618-7601','2212-828X')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Nursing and Health Professions','Medicine and Dentistry')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (14321475,01676296,10991050, 17284457,16187601)
and a.cluster_centre like '%scopus%'

Gender Bias in Teaching Evaluations


------------------------------EXP6 - preprint experiment ------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('0272-7757','1432-1475')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (02727757,14321475)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%economics%'
or research_interests like '%population economics%'
or research_interests like '%education'
	
--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('0272-7757','1432-1475')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4	

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Nursing and Health Professions','Medicine and Dentistry')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (02727757,14321475)
and a.cluster_centre like '%scopus%'
