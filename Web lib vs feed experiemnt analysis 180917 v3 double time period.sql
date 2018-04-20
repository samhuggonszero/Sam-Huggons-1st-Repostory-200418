---and create clean file for analysis
--1) only those in each sample that actualy landed on feed or library afetr account weblet
--2) only those that are not in both samples
--3) Only those with join dates in the sample period

--drop table mendeley.SH_TEMP_feed_vs_library_exp1_080917_cleaned
create table mendeley.SH_TEMP_feed_vs_library_exp1_110917_cleaned as (

with main as (select w.profile_id profile_id,
	max(case when name='Weblet Account' and client_after='Web Library' then 1 else 0 end) as web_library_landed,
	max(case when name='Weblet Account' and client_after='Mendeley News Feed' then 1 else 0 end) as Feed_landed
	
from (
    select 
        profile_id, 
        first_ts,
        lag(f.profile_id) over (order by profile_id, first_ts) profile_before,
        c.name, 
        lead(c.name) over (order by profile_id, first_ts) client_after
    from (
        select 
            e.profile_id, 
            e.client_id, 
            min(e.ts) as first_ts
	from mendeley.live_events_latest e
	join (
		select uu_profile_id as profile_id 
		from mendeley.profiles 
		where joined>'2017-08-22' and joined<'2017-09-11'
		) p on p.profile_id=e.profile_id
	where event_name='login'
	group by 1,2
    ) f 
    left outer join mendeley.oauth2_clients c on c.id=f.client_id
    order by profile_id, first_ts
) w
left outer join  mendeley.live_events_latest e 
	on w.profile_id=e.profile_id 
	and e.event_name = 'UserDocumentCreated' 
	and datediff('min', w.first_ts, e.ts)<=30
	
where profile_before is null or profile_before<>w.profile_id
and (
	name in ('Web Library', 'Mendeley News Feed') 
	or (name in ('Weblet Account') and client_after in ('Web Library', 'Mendeley News Feed')))
group by 1
)


select a.profile_id,
case when groups='Control' and web_library_landed=0 and feed_landed=1 then 'Control'
   when groups='var1' and web_library_landed=1 and feed_landed=0 then 'var1'
   else 'Excluded' end as cleaned_group,
   web_library_landed,
   Feed_landed,
   groups as original_group


from (select distinct profile_id, groups from mendeley.SH_TEMP_feed_vs_library_exp1_110917) a
left join mendeley.profiles b 
on a.profile_id=uu_profile_id
left join main c
on a.profile_id=c.profile_id
where joined>'2017-08-22' and joined<'2017-09-11'
and a.profile_id not in (select profile_id from (
select profile_id, count(*) from (select distinct profile_id, groups from mendeley.SH_TEMP_feed_vs_library_exp1_110917) a
left join mendeley.profiles b on a.profile_id=uu_profile_id
where joined>'2017-08-22' and joined<'2017-09-11' group by 1 having count(*)>1 ))
)

-----actual analysis
--select * from mendeley.SH_TEMP_feed_vs_library_exp1_080917_cleaned


with retained_users as (
    select  p.uu_profile_id as profile_id,
            seniority,
            date_trunc('day', p.joined) as index_ts,
            case when sum(case when s.ts_start between p.joined + interval '24 hours' and p.joined + interval '7 days' then 1 else 0 end) > 0
             then 1 else 0 end as is_retained
    from mendeley.profiles p
    left join mendeley.user_role_to_seniority_map
    using(user_role)
    left join mendeley.sessions_all s
    on s.profile_id = p.uu_profile_id
    where p.joined < (select max(index_ts) from mendeley.active_users_per_day) - interval '6 days'
    group by 1, 2, 3
)

select a.profile_id,
a.cleaned_group, 
c.joined,
is_retained as retained,
max(case when client_id=6 and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as desktop_use_24h,
max(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as import_doc_24h


from mendeley.SH_TEMP_feed_vs_library_exp1_110917_cleaned a
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
left join mendeley.live_events_201610_to_present b
on a.profile_id=b.profile_id
left join retained_users d
on a.profile_id=d.profile_id
where ts>='2017-08-22'
group by 1,2,3,4

---additional metrics
# Documents added by each user in first 7d (Events)
% Users who use Desktop in first 7d (Events)
% Users who use any of the Mobile clients in first 7d (Events)
Clicks on the nav bar (Optimizely)
% Users who claim a Scopus profile in first 7d (Events)
% Users who upload a Profile photo in first 7d (Events)
% Users who follow another user in first 7d (Events)
% Engagement rate






with retained_users as (
    select  p.uu_profile_id as profile_id,
            seniority,
            date_trunc('day', p.joined) as index_ts,
            case when sum(case when s.ts_start between p.joined + interval '24 hours' and p.joined + interval '7 days' then 1 else 0 end) > 0
             then 1 else 0 end as is_retained
    from mendeley.profiles p
    left join mendeley.user_role_to_seniority_map
    using(user_role)
    left join mendeley.sessions_all s
    on s.profile_id = p.uu_profile_id
    where p.joined < (select max(index_ts) from mendeley.active_users_per_day) - interval '6 days'
    group by 1, 2, 3
)

select a.profile_id,
seniority,
a.cleaned_group, 
c.joined,
is_retained as retained_2_7d,
max(case when client_id=6 and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as desktop_use_24h,
max(case when client_id=6 and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as desktop_use_2_7d,
max(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as import_doc_24h,
max(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as import_doc_0_7d,
max(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as import_doc_2_7d,
sum(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as import_doc_count_24h,
sum(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as import_doc_count_0_7d,
sum(case when event_name in ('UserDocumentCreated','Import','DocumentAdd') and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as import_doc_count_2_7d,
max(case when client_id in (7,808) and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as mobile_use_24h,
max(case when client_id in (7,808) and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as mobile_use_0_7d,
max(case when client_id in (7,808) and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as mobile_use_2_7d,
max(case when event_name ='MendeleyScopusAuthorClaim' and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as scopus_claim_24h,
max(case when event_name ='MendeleyScopusAuthorClaim' and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as scopus_claim_0_7d,
max(case when event_name ='MendeleyScopusAuthorClaim' and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as scopus_claim_2_7d,
max(case when event_name ='ProfileUpdated' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_type') = 'photo' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_event') = 'ResourceAdded'  and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as photo_upload_24h,
max(case when event_name ='ProfileUpdated' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_type') = 'photo' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_event') = 'ResourceAdded'  and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as photo_upload_0_7d,
max(case when event_name ='ProfileUpdated' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_type') = 'photo' and JSON_EXTRACT_PATH_TEXT(properties, 'resource_event') = 'ResourceAdded'  and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as photo_upload_2_7d,
max(case when event_name ='followed' and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as follow_atleast1_24h,
max(case when event_name ='followed' and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as follow_atleast1_0_7d,
max(case when event_name ='followed' and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as follow_atleast1_2_7d,
sum(case when event_name ='followed' and b.ts>c.joined and b.ts<c.joined+1 then 1 else 0 end) as follow_count_24h,
sum(case when event_name ='followed' and b.ts>c.joined and b.ts<c.joined+8 then 1 else 0 end) as follow_count_0_7d,
sum(case when event_name ='followed' and b.ts>c.joined+1 and b.ts<c.joined+8 then 1 else 0 end) as follow_count_2_7d

from mendeley.SH_TEMP_feed_vs_library_exp1_110917_cleaned a
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
left join mendeley.live_events_201610_to_present b
on a.profile_id=b.profile_id
left join retained_users d
on a.profile_id=d.profile_id
where ts>='2017-08-22'
group by 1,2,3,4,5


---more usage stats -- not yet working

select a.profile_id,
a.cleaned_group, 
c.joined,
max(case when client_id in (2364) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as Feed_use_24h,
max(case when client_id in (1127) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as Profile_use_24h,
max(case when client_id in (3181) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as Groupweb_use_24h,
max(case when client_id in (1360) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as WebLib_use_24h,
max(case when client_id in (2409) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as WebImp_use_24h,
max(case when client_id in (3518) and b.index_ts>c.joined and b.index_ts<c.joined+1 then 1 else 0 end) as Career_use_24h


from mendeley.SH_TEMP_feed_vs_library_exp1_080917_cleaned a
left join mendeley.profiles c
on a.profile_id=c.uu_profile_id
left join mendeley.active_users_by_client_per_day b
on a.profile_id=b.profile_id
where index_ts>='2017-08-22'
group by 1,2,3
