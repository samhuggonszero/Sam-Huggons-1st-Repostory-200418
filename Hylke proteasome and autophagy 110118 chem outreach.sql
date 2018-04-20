select * from spectrum_docs.documents limit 10
select * from scopus.dim_document limit 10

--has document in library form last 3 years elsevier journals  55K 
select distinct a.uuid as profile_id,  
doi, 
document_issn,
document_title,
is_author,
publisher,
document_pub_year

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%proteasome%'
or document_title like '%autophagy%'
--and serial_detail_cover_start_date>=getdate()-1095
limit 100




select distinct  a.uuid as profile_id,  
doi, 
document_issn,
document_title,
is_author,
publisher,
document_pub_year

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%proteasome%'



select distinct  a.uuid as profile_id,  
doi, 
document_issn,
document_title,
is_author,
publisher,
document_pub_year

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%autophagy%'


select count(*) from scopus.dim_document where  document_title like '%proteasome%'


52935

select count(distinct(a.profile_id)) 


from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%proteasome%'

72052

select count(distinct(a.profile_id)) 

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%autophagy%'




select distinct  a.uuid as profile_id

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  document_title like '%proteasome%'
or document_title like '%autophagy%'


select count(distinct(a.uuid))

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where ( document_title like '%proteasome%'
or document_title like '%autophagy%')


186151

select count(distinct(a.uuid))

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where ( document_title like '%proteasome%'
or document_title like '%autophagy%')
and date_added>=getdate()-(2*365)


68627

select count(distinct(a.uuid))

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where ( document_title like '%proteasome%'
or document_title like '%autophagy%')
and date_added>=getdate()-(365)



select count(distinct(a.uuid))

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where ( document_title like '%proteasome%'
or document_title like '%autophagy%')
and date_added>=getdate()-(180)



---final 
select distinct  a.uuid as profile_id

from spectrum_docs.documents a
inner join scopus.dim_document  b
on a.doi=b.document_doi
where  (document_title like '%proteasome%'
or document_title like '%autophagy%')
and date_added>='2017-04-24' and date_added<='2017-10-24'
and a.doi not in ('')	

























select movement, index_ts, count(distinct(profile_id)) as users
from usage.mendeley.active_users_movements
group by 1,2
union all
select   'T'  as movement, index_ts, counT(distinct(uu_profile_id)) as users
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts group by 1,2
union all
select 'D'  as movement,
a.index_ts,
users-users1 as users
from ( select index_ts, counT(distinct(uu_profile_id)) as users
from (select distinct index_ts, 1 as ID from mendeley.active_users order by 1) a
left join (select uu_profile_id, joined, 1 as ID from  mendeley.profiles) b
on a.id=b.id and joined<=index_ts 
group by 1 ) a
left join (select index_ts, counT(distinct(profile_id)) as users1 from mendeley.active_users group by 1) c
on a.index_ts=c.index_ts






select date_trunc('month', ts),JSON_EXTRACT_PATH_TEXT(properties, 'TextProcessor') as text_editor_version , count(profile_id) as citations, count(distinct profile_id) as users
from live_events_filtered 
where event_name = 'SendDocumentsToTextProcessor'
and ts between '2014-10-01' and getdate()
group by 1,2




select * from mendeley.live_events_latest  where event_name='Import' limit 10

'{"Referrer":"toolbar-menus","Importer":"pdf","DocumentsCount":"1"}'

'{"Referrer":"context-menu","Importer":"pdf","DocumentsCount":"1"}'







