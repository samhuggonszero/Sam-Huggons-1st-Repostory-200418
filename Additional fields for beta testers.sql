select * from spectrum_docs.documents limit 100


select * from spectrum_docs.documents limit 100

filehash, 

uuid, 

profile_id, 

date_added, 

select max(date_added)  from spectrum_docs.documents limit 100

'2017-10-24 03:09:13'

select uuid, profile_id, count(distinct(filehash)) as filehash from spectrum_docs.documents group by 1,2 limit 100