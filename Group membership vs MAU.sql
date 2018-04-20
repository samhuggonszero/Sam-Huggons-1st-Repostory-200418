select * from mendeley.group_members a limit 10



select index_ts,
case when groups_a_member_of is null then 0 else groups_a_member_of end as groups_a_member_of,
count(distinct(a.profile_id)) as MAU

from mendeley.active_users a
left join (
select profile_id, 
count(distinct(group_id)) as groups_a_member_of

from mendeley.group_members  
group by 1 ) b
on a.profile_id=b.profile_id
group by 1,2




select distinct event_name from mendeley.group_events_per_day

select * from mendeley.group_events_per_day limit 10

'FileUploaded' --thats the badger


select date_trunc('month',index_ts) as index_ts, 
group_id, 
client_id,
sum(event_count) as FileUploaded

from mendeley.group_events_per_day 
where event_name='FileUploaded'
group by 1,2,3


select *

from mendeley.group_events_per_day 
where event_name='FileUploaded'
limit 100



select distinct event_name from mendeley.group_events_per_day and client_id=6


select * from spectrum_docs.documents limit 10



------------checking how many docs added to groups a month


select date_trunc('month',date_added) as month,
group_id,
count(*)

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
where date_added>='2017-01-01'
and group_id not in (0)
group by 1,2 



-----------memebers * docs = emails if 1 per doc

select date_trunc('month',date_added) as month,
members,
count(*) as doc_adds,
count(distinct(a.group_id)) as groups,
count(distinct(a.group_id))*members as group_members_product

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.group_id=c.group_id
where date_added>='2017-01-01'
and a.group_id not in (0)
group by 1,2 




select date_trunc('week',date_added) as month,
members,
count(*) as doc_adds,
count(distinct(a.group_id)) as groups,
count(distinct(a.group_id))*members as group_members_product

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.group_id=c.group_id
where date_added>='2017-01-01'
and a.group_id not in (0)
group by 1,2 



select date_trunc('day',date_added) as month,
members,
count(*) as doc_adds,
count(distinct(a.group_id)) as groups,
count(distinct(a.group_id))*members as group_members_product

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.group_id=c.group_id
where date_added>='2017-01-01'
and a.group_id not in (0)
group by 1,2 


----unique a unique daily count of groups with >=1 doc added per profile id per day and then average and see that as % of how many get email per day etc.



select groups,
day,
count(distinct(profile_id)) as users

from (

select date_trunc('day',date_added) as day,
uuid as profile_id,
count(*) as doc_adds,
count(distinct(a.group_id)) as groups

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
where date_added>='2017-01-01'
and a.group_id not in (0)
group by 1,2 

)

group by 1,2



select profile_id,
day,
count(distinct(group_id)) as group_id

from (

select distinct date_trunc('day',date_added) as day,
profile_id as profile_id,
a.group_id 

from spectrum_docs.documents a
inner join mendeley.groups b
on a.group_id=b.id
left join (select group_id, profile_id as members from mendeley.group_members) c
on a.group_id=c.group_id
where date_added>='2017-01-01'
and a.group_id not in (0)
)

group by 1,2
having count(distinct(group_id))>1







