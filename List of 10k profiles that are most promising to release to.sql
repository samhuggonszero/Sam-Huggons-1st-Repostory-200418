--List of 10k profiles that are most promising to release to
    size of library (total docs)
    docs with at least 1 file attached
    number of files per document
    number of annotations
    number of files annotated
    number of folders
    number of sub folders

1) using document table, count distinct "did" thats only up to Oct 17
2) file hash in document is not null when doc is really attached, could ask catalogue team
3) Joe to provide locations of annotations data, annotation type, colour, document ID, Annotation ID,
on spectrum, from S3 bucket and operations system, position of highlight on doc page
- spectrum.temp_user_annotations, up to date till early feb time range un clear
4) Count of annotaion id's by doc Id's
5) FolderCreated event and parent Id is populated in poroperties then it's a sub folder
'
;



select * from spectrum_docs.documents limit 100
did, filehash, profile_id, 
select * from spectrum.temp_user_annotations limit 100
id, profile_id, filehash, document_id, created, 
select * from mendeley.live_events_latest where event_name='FolderCreated' limit 100
select * from mendeley.live_events_latest where event_name='FolderRemoved' limit 100
select * from mendeley.live_events_latest where event_name='FolderUpdated' limit 100
'{"dateCreated":"1517459983000","id":"4e08d405-0ae2-40f3-aa8d-dfaadbf0cfc3","name":"Statistics Module"}'
'{"parent":"50b502b3-f87a-49a0-b5fe-bd63fce30a66","dateCreated":"1517522892000","id":"6a6a0b1b-ec72-4024-
a6b6-ed7644ff70ed","name":"MCC Data"}'
'{"dateCreated":"1516203221000","id":"6a19d1c2-e69e-4bce-b510-25182bb38923","name":"New Folder"}'
'{"dateCreated":"1497001347000","id":"770393fc-f78b-48f4-98b0-8ccfbd924350","name":"my articles"}'


'{"newParent":"49ca7e13-ad7c-4617-b2f1-48ca4b73c3e4","dateCreated":"1503923453000","id":"f9210074-b919-41ee-a212-9498fb3d553f","name":"proteomics"}'


properties, ts, client_id, profile_id, --4,063,598
select count(*) from mendeley.fact_request_201802
where event_name in ('FolderCreated','FolderRemoved','FolderUpdated')

select profile_id, client_id, request_start_time as ts, misc as properties
from mendeley.fact_request_201802
where event_name in ('FolderCreated','FolderRemoved','FolderUpdated')
limit 100

---library size


select uu_profile_id as profile_id, 
count(distinct(case when filehash not in ('') or  filehash is not null then did end)) as Docs_with_files,
sum(case when filehash not in ('') or  filehash is not null  then 1 else 0 end) as files,
count(distinct(did)) as docs
from spectrum_docs.documents a
inner join mendeley.profiles b
on a.profile_id=b.id
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on b.uu_profile_id=c.profile_id
group by 1


select uu_profile_id as profile_id, 
did, 
count(distinct(case when filehash not in ('') or  filehash is not null then filehash end)) as file_per_doc_with_files

from spectrum_docs.documents a
inner join mendeley.profiles b
on a.profile_id=b.id
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on b.uu_profile_id=c.profile_id
group by 1,2

---annotations

select a.profile_id,
count(distinct(id)) as annotations,
count(distinct(document_id)) as docs_annotated

from spectrum.temp_user_annotations a
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on a.profile_id=c.profile_id
group by 1
limit 100

select count(*), count(distinct(profile_id)) from spectrum.temp_user_annotations --728,341,085


----folders and sub folders

Create table mendeley.sh_temp_reference_management_folders as (
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201401 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201402 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201403 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201404 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201405 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201406 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201407 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201408 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201409 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201410 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201411 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201412 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201501 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201502 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201503 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201504 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201505 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201506 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201507 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201508 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201509 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201510 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201511 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201512 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201601 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201602 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201603 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201604 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201605 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201606 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201607 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201608 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201609 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201610 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201611 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201612 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201701 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201702 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201703 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201704 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201705 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201706 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201707 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201708 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201709 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201710 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201711 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from spectrum.fact_request_201712 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from mendeley.fact_request_201801 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') union all
select profile_id, client_id, event_name, request_start_time as ts, misc as properties from mendeley.fact_request_201802 where event_name in ('FolderCreated','FolderRemoved','FolderUpdated') 
) 
;
GRANT SELECT ON mendeley.sh_temp_reference_management_folders TO GROUP mendeley_reader;


DISTKEY(profile_id) SORTKEY(ts);


--original query

WITH main AS (select distinct b.profile_id,
b.version AS latest_version,
b.os AS Latest_os

from mendeley.tmp_dev_desktop_users b

inner join (select profile_id,
max(user_request_start_time) as ts_max
from mendeley.tmp_dev_desktop_users
group by 1) a

on b.profile_id = a.profile_id
and b.user_request_start_time = a.ts_max)

SELECT
a.version,
a.os,
a.profile_id,
MIN(a.user_request_start_time) AS first_use_ts,
latest_version,
Latest_os,
city,
country
FROM
mendeley.tmp_dev_desktop_users a
left JOIN mendeley.profiles c
on a.profile_id = c.uu_profile_id
LEFT JOIN
main b
on a.profile_id = b.profile_id
WHERE
a.version != 'unknown'
and a.version LIKE '%dev%'
GROUP BY
1,2,3,5,6,7,8
ORDER BY
1 DESC
LIMIT
100;


--- mega query part 1
create table mendeley.sh_temp_ref2_launch_to_beta_050318 as (
WITH main AS (select distinct b.profile_id,
b.version AS latest_version,
b.os AS Latest_os

from mendeley.tmp_dev_desktop_users b

inner join (select profile_id,
max(user_request_start_time) as ts_max
from mendeley.tmp_dev_desktop_users
group by 1) a

on b.profile_id = a.profile_id
and b.user_request_start_time = a.ts_max)

SELECT
a.version,
a.os,
a.profile_id,
MIN(a.user_request_start_time) AS first_use_ts,
latest_version,
Latest_os,
city,
country
FROM
mendeley.tmp_dev_desktop_users a
left JOIN mendeley.profiles c
on a.profile_id = c.uu_profile_id
LEFT JOIN
main b
on a.profile_id = b.profile_id
WHERE
a.version != 'unknown'
and a.version LIKE '%dev%'
GROUP BY
1,2,3,5,6,7,8
ORDER BY
1 DESC
)


--- mega query part 2

select a.*,
doc.Docs_with_files,
doc.docs,
doc.files,
--case when doc.files not in (0) and docs_with_files not in (0) then cast(doc.files as decimal(10,2))/cast(docs_with_files as decimal(10,2)) else null end as files_per_doc_with_files, 
ana.docs_annotated,
ana.annotations

from mendeley.sh_temp_ref2_launch_to_beta_050318 a
left join 

(
select uu_profile_id as profile_id, 
count(distinct(case when filehash not in ('') or  filehash is not null then did end)) as Docs_with_files,
sum(case when filehash not in ('') or  filehash is not null  then 1 else 0 end) as files,
count(distinct(did)) as docs
from spectrum_docs.documents a
inner join mendeley.profiles b
on a.profile_id=b.id
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on b.uu_profile_id=c.profile_id
group by 1
) doc

on a.profile_id=doc.profile_id

left join (
select a.profile_id,
count(distinct(id)) as annotations,
count(distinct(document_id)) as docs_annotated

from spectrum.temp_user_annotations a
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on a.profile_id=c.profile_id
group by 1
) ana

on a.profile_id=ana.profile_id

--need joe to re build table
select * from  mendeley.refman_folder_history_per_day limit 1000

select max(len(properties)) from  mendeley.refman_folder_history_per_day limit 1000
select max(len(properties)) from  spectrum.fact_request_201801 where event_name in ('FolderCreated','FolderRemoved' ,'FolderUpdated')

SELECT a.profile_id, 
sum(case when event_name='FolderCreated' then 1 else 0 end) as FolderCreatedsince2017,
sum(case when event_name='FolderRemoved' then 1 else 0 end) as FolderRemovedsince2017,
sum(case when JSON_EXTRACT_PATH_TEXT(properties,'parent') not in ('') and event_name='FolderCreated' then 1 else 0 end) as SubFolderCreatedsince2017,
sum(case when JSON_EXTRACT_PATH_TEXT(properties,'deletedSubFolders') not in ('')  and event_name='FolderRemoved' then 1 else 0 end) as SubFolderRemovedsince2017

FROM mendeley.refman_folder_history_per_day a
inner join mendeley.sh_temp_ref2_launch_to_beta_050318 c
on a.profile_id=c.profile_id
where index_ts>'2017-01-01'
group by 1




name
newName
parent
id



'{"parent":"902ea0a3-dbc2-4c77-833f-ce91c3b5552c","dateCreated":"1406285425000","id":"6bfb0c07-7d8a-40be-baf3-dfe0ed130c3e","name":"F2"}'
'{"newName":"Fo1o","dateCreated":"1390825150000","id":"902ea0a3-dbc2-4c77-833f-ce91c3b5552c","name":"Foo"}''{"newName":"Foo","dateCreated":"1390825150000","id":"902ea0a3-dbc2-4c77-833f-ce91c3b5552c","name":"F1oo"}'

SELECT profile_id, 
sum(case when event_name='FolderCreated' then 1 else 0 end) as FolderCreated,
sum(case when event_name='FolderRemoved' then 1 else 0 end) as FolderRemoved,
sum(case when JSON_EXTRACT_PATH_TEXT(properties,'parent') = JSON_EXTRACT_PATH_TEXT(properties,'id') and event_name='FolderCreated' then 1 else 0 end) as SubFolderCreated,
sum(case when JSON_EXTRACT_PATH_TEXT(properties,'parent') = JSON_EXTRACT_PATH_TEXT(properties,'id') and event_name='FolderRemoved' then 1 else 0 end) as SubFolderRemoved

FROM mendeley.refman_folder_history_per_day 
group by 1
limit 100


SELECT a.*,
JSON_EXTRACT_PATH_TEXT(properties,'parent') as parent,
JSON_EXTRACT_PATH_TEXT(properties,'id') as id

FROM mendeley.refman_folder_history_per_day  a
--where JSON_EXTRACT_PATH_TEXT(properties,'parent') not in ('')
where index_ts>'2017-01-01'
limit 10000


