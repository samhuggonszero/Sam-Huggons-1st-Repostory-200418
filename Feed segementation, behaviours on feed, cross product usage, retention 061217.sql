--------Feed segementation, behaviours on feed, cross product usage, retention
---groups a memebr of, composite index of activity in groups + size + 
--following, followers
---Scopus claimed
---Co authors
-- profile completeion
--geo location

select * from mendeley.profile_docs_totals limit 10
select * from mendeley.profiles_scopus_authors limit 10
mendeley.ros_social_feed_events
mendeley.profiles_scopus_authors
mendeley.profile_documents
mendeley.profile_editorships
mendeley.profile_docs_totals
mendeley.profile_followers
select * from mendeley.active_users_by_client_by_event_per_day limit 10
select * from mendeley.profiles limit 10

institution_id, 

631,701

select count(*) from (

select profile_id,
client_id,
index_ts

from mendeley.active_users_by_client_by_event_per_day 
where client_id=2364
and index_ts>='2017-11-01' and index_ts<'2017-12-01'
group by 1,2,3

)

---first seen on feed?? 3,808,944
select count(*) from (
select profile_id,
client_id,
min(index_ts) as cohort_day

from mendeley.active_users_by_client_by_event_per_day 
where client_id=2364
and index_ts<'2017-12-01'
group by 1,2
)


--scopus claimed
select profile_id, 1 as scopus_claimed 
from mendeley.profiles_scopus_authors where claim_status='active'

--group membership
select * from mendeley.group_members limit 10

select z.*,
x.unique_group_user_in_groups_with_them

from (
select profile_id, 
count(distinct(a.group_id)) as groups_a_member_of,
sum(b.group_members) as group_connections_non_unique

from mendeley.group_members a
left join (select group_id, count(distinct(profile_id)) as group_members from mendeley.group_members group by 1) b
on a.group_id=b.group_id
group by 1
order by 3 desc
) z

left join (
select a.profile_id, 
count(distinct(b.profile_id)) as unique_group_user_in_groups_with_them

from mendeley.group_members a
left join mendeley.group_members b
on a.group_id=b.group_id
group by 1
) x
on z.profile_id=x.profile_id

----documents created

select count(*), min(index_ts) from mendeley.active_users_by_client_by_event_per_day where event_name='UserDocumentCreated'

select profile_id, 
count(*) as documents_created, 
max(index_ts) as most_recent_doc_created_date 

from mendeley.active_users_by_client_by_event_per_day 
where event_name='UserDocumentCreated'
group by 1
order by 2 desc
limit 1000

---main descriptive data sets
---join MDLY date + following connections + user role + country + subject aea
--drop table mendeley.sh_temp_descriptive_feed_segmentation_141217 
create table mendeley.sh_temp_descriptive_feed_segmentation_141217 as (
select a.uu_profile_id as profile_id, 
joined,
subject_area,
user_role,
photo_url,
case when institution_id>0 then 1 else 0 end as institution_linked,
d.country,
location_country_un_territory,
location_continent_name,
case when location_continent_name='Africa' then 1 
when location_continent_name='Antarctica' then 2 
when location_continent_name='Asia' then 3 
when location_continent_name='Europe' then 4 
when location_continent_name='North America' then 5 
when location_continent_name='Oceania' then 6 
when location_continent_name='South America' then 7 end as continent_numeric,
most_recent_doc_created_date,
case when c.followers is null then 0 else c.followers end as followers,
case when groups_a_member_of is null then 0 else groups_a_member_of end as groups_a_member_of,
case when group_connections_non_unique is null then 0 else group_connections_non_unique end as group_connections_non_unique,
case when b.followees is null then 0 else b.followees end as followees,
case when documents_created is null then 0 else documents_created end as total_docs, 
case when scopus_claimed is null then 0 else scopus_claimed end as scopus_claimed,
case when unique_group_user_in_groups_with_them is null then 0 else unique_group_user_in_groups_with_them end as unique_group_user_in_groups_with_them


from mendeley.profiles a
left join (select follower_id as profile_id, count(distinct(followee_id)) as followees  from mendeley.profile_followers group by 1) b
on a.uu_profile_id=b.profile_id
left join (select followee_id as profile_id, count(distinct(follower_id)) as followers  from mendeley.profile_followers group by 1) c
on a.uu_profile_id=c.profile_id
left join mendeley.profile_countries d
on a.uu_profile_id=d.profile_id
left join (select profile_id, 1 as scopus_claimed 
from mendeley.profiles_scopus_authors where claim_status='active') e
on a.uu_profile_id=e.profile_id
left join (select distinct location_country_name, location_continent_name, location_country_un_territory from common.dim_location) f
on d.country=f.location_country_name
left join (select profile_id, 
count(*) as documents_created, 
max(index_ts) as most_recent_doc_created_date 

from mendeley.active_users_by_client_by_event_per_day 
where event_name='UserDocumentCreated'
group by 1) g
on a.uu_profile_id=g.profile_id
left join (select z.*,
x.unique_group_user_in_groups_with_them

from (
select profile_id, 
count(distinct(a.group_id)) as groups_a_member_of,
sum(b.group_members) as group_connections_non_unique

from mendeley.group_members a
left join (select group_id, count(distinct(profile_id)) as group_members from mendeley.group_members group by 1) b
on a.group_id=b.group_id
group by 1
order by 3 desc
) z

left join (
select a.profile_id, 
count(distinct(b.profile_id)) as unique_group_user_in_groups_with_them

from mendeley.group_members a
left join mendeley.group_members b
on a.group_id=b.group_id
group by 1
) x
on z.profile_id=x.profile_id
) h
on a.uu_profile_id=h.profile_id 
--limit 1000
)


select a.*,
followees+total_docs+(scopus_claimed*10)+unique_group_user_in_groups_with_them as activation_index

from mendeley.sh_temp_descriptive_feed_segmentation_141217 a
limit 1000



select * from mendeley.ros_social_feed_events limit 10


--------need monthly following, scopus claim, docs added to library in that month, docs in libray in that month, groups data

--47% not actiavted
------------------event based datse but which tyes of engagment drive retention
with main as (
select profile_id,client_id,index_ts
from mendeley.active_users_by_client_by_event_per_day 
where client_id in (2364,808,7,3181)
and index_ts>='2017-10-01' and index_ts<'2017-11-01'
group by 1,2,3 limit 1000
)

select a.profile_id,
a.client_id,
a.index_ts,
sum(case when event_name='FeedItemViewed' then 1 else 0 end) as Items_viewed,
sum(case when event_name='FeedItemDisplayed' then 1 else 0 end) as Items_displayed,
sum(case when event_name='FeedItemClicked' then 1 else 0 end) as Items_clicked,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click,
sum(case when event_name='FeedItemClicked' and item_type='post-a-status' and section='post_button' then 1 else 0 end) as post_button_click



from main a 
left join mendeley.ros_social_feed_events b
on a.profile_id=b.profile_id
and a.index_ts=b.index_ts
and a.client_id=b.client_id
group by 1,2,3


select distinct item_type from mendeley.ros_social_feed_events 

item_type
new-pub  --yes
recommendation -- group recs into doc and people
onboarding ---yes
third-party-rosx - group all thrid party together
third-party-rosx-chem-RL-DOW
third-party-rosx-gunter-chem-RL-SI
rss-item -- ignore
new-status -any interaction
post-a-status---yes but only post button interesting
people-recommendation-error
third-party-rosx-rosx-proto-gunter
third-party-rosx-chem-CON-Els
third-party-rosx-gunter-chem-ART
third-party-rosx-gunter-helper
third-party-rosx-gunter-chem-RL-TOC
third-party-rosx-gunter-chem-RL-CIT
third-party-rosx-3
group-status-posted -- yes
third-party-newsflo
third-party-undefined
third-party-client-id-4411
education-update --yes
third-party-rosx-chem-CON-MT
third-party-rosx-gunter-test
third-party-rosx-gunter-chem-RL-EP-group
third-party-mendeley-funding-a
posted-pub
third-party-rosx-gunter-chem-ED-UP
third-party
third-party-rosx-gunter-rosx-proto-gunter
third-party-rosx-gunter
new-coauthor-pub --yes
third-party-rosx-chem-RL-EP-jhp
people-recommendation
new-follower --yes
third-party-rosx-test0
third-party-mendeley-data
third-party-rosx-gunter-chem-RL-DOW-new
third-party-rosx-chem-RL-TOC
aggregated-new-document-citations
employment-update --yes
posted-catalogue-pub
third-party-rosx-gunter-chem-CON-Els
document-recommendation
third-party-rosx-gunter-chem-Mblog
third-party-rosx-1
third-party-rosx-gunter-chem-FUN
documents-recommendation
newscientist -- put in third party

new-document-citations
third-party-rosx-chem-RL-EP-group
third-party-rosx-gunter-chem-RL-EP-jhp
group-doc-added
third-party-rosx-gunter-chem-ART-new
third-party-rosx-gunter-rosx-test
third-party-rosx-2
third-party-rosx-gunter-chem-RL-DOW

----need a retained flag for 24 hour, 6 day, 1 month , 6 month for example but also need all types of clicks splt out as flags some how????????
