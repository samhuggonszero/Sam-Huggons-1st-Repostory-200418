SELECT  date_trunc('day',date_added) as date,  
sum(case when is_author=1 then 1 else 0 end) as Profile_pub_list_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups) 
then 1 else 0 end) as Groups_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='public')
then 1 else 0 end) as Groups_Public_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='private')
then 1 else 0 end) as Groups_Private_doc_add,
count(*) as all_mdly_doc_adds

FROM mendeley.documents 
where date_added>='2016-01-01'
group by 1
order by 1




select * from mendeley.profile_stats_claim_per_day

-----stats claim on same day

SELECT  date_trunc('day',date_added) as date,  
case when date_trunc('day',date_added)=b.index_ts then 1 else 0 end as scopus_claim_day,
sum(case when is_author=1 then 1 else 0 end) as Profile_pub_list_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups) 
then 1 else 0 end) as Groups_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='public')
then 1 else 0 end) as Groups_Public_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='private')
then 1 else 0 end) as Groups_Private_doc_add,
count(*) as all_mdly_doc_adds

FROM mendeley.documents a
left join mendeley.profile_stats_claim_per_day b
on a.profile_id=b.profile_id
and date_trunc('day',a.date_added)=b.index_ts
where date_added>='2016-06-01'
group by 1,2
order by 1


-----publication update on same day which is useless :(

SELECT  date_trunc('day',date_added) as date,  
case when date_trunc('day',date_added)=b.index_ts then 1 else 0 end as scopus_claim_day,
sum(case when is_author=1 then 1 else 0 end) as Profile_pub_list_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups) 
then 1 else 0 end) as Groups_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='public')
then 1 else 0 end) as Groups_Public_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='private')
then 1 else 0 end) as Groups_Private_doc_add,
count(*) as all_mdly_doc_adds

FROM mendeley.documents a
left join mendeley.profile_updates_per_day b
on a.profile_id=b.profile_id
and date_trunc('day',a.date_added)=b.index_ts
where date_added>='2016-01-01'
and profile_information='publication'
group by 1,2
order by 1



----------------final with
SELECT  date_trunc('day',date_added) as date,  
case when date_trunc('day',date_added)=b.index_ts then 1 else 0 end as scopus_claim_day,
sum(case when is_author=1 then 1 else 0 end) as Profile_pub_list_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups) 
then 1 else 0 end) as Groups_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='public')
then 1 else 0 end) as Groups_Public_doc_add,
sum(case when group_id in (select uu_group_id from mendeley.groups where visibility='private')
then 1 else 0 end) as Groups_Private_doc_add,
count(*) as all_mdly_doc_adds

FROM mendeley.documents a
left join (select distinct profile_id, date_trunc('day',ts) as index_ts
from mendeley.live_events_201610_to_present
where client_id=2122
and event_name='ScopusPublicationImport') b
on a.profile_id=b.profile_id
and date_trunc('day',a.date_added)=b.index_ts
where date_added>='2016-06-01'
group by 1,2
order by 1


select distinct profile_id, date_trunc('day',ts) as index_ts
from mendeley.live_events_201610_to_present
where client_id=2122
and event_name='ScopusPublicationImport'


select * from mendeley.event_registry_new
where event_name='ScopusPublicationImport'

'Event fired when Scopus Publications are imported from documents-service'







