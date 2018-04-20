select * from mendeley.live_events_latest
where client_id=3874

select count(distinct(profile_id)) from mendeley.live_events_latest
where client_id=3874



select max(ts) from mendeley.live_events_latest
where ts<getdate()

select date_trunc('month',index_ts), count(distinct(profile_id)) from mendeley.active_users_per_day
where index_ts>'2017-01-01'
group by 1




select date_trunc('day',ts), date_trunc('hour',ts), count(*) from mendeley.live_events_latest
where ts<getdate() and ts>=getdate()-7
group by 1,2
order by 2 desc


select distinct product from mendeley.ros_social_users_per_day

select count(distinct(profile_id)) from mendeley.live_events_latest
where client_id=3874


select * from mendeley.live_events_latest where event_name='UserRegistration' limit 100 

'{"os.family":"Windows Server 2008 R2 / 7","joined_timestamp":"2017-02-01T20:48:09.000Z","referrer_url":"https://www.mendeley.com/join/?_section=group-invitation&inviteCode=6a3df60217&inviteeEmail=miquelferrf@gmail.com&inviteFunnel=group-join","os.version":"7","ip_address":"172.31.15.179","os.architecture":"64","profile_id":"7f1e4aab-536c-3b7a-a2bf-f0bda6bb2ed7","utt":"6ea41702aa20551b54834516af6e3fdd8835e8","registration_url":"https://www.mendeley.com/newsfeed","browser":"Chrome"}'
and json_extract_path_text(properties, 'registration_url')



select json_extract_path_text(properties, 'registration_url'), count(*)
from mendeley.live_events_latest 
where event_name='UserRegistration'
and ts>='2017-03-28'
group by 1 
order by 2 desc

'https://www.mendeley.com/sneak-peek/cellpress'





select profile_id, event_name, ts, json_extract_path_text(properties, 'registration_url') as registration_url, user_role, name as Instituion
from mendeley.live_events_latest a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.institutions c
on b.institution_id=c.id
where event_name='UserRegistration'
and json_extract_path_text(properties, 'registration_url')='https://www.mendeley.com/sneak-peek/cellpress'
and ts>='2017-03-28'




select profile_id, event_name, ts, json_extract_path_text(properties, 'registration_url') as registration_url, user_role, name as Instituion
from mendeley.live_events_latest a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.institutions c
on b.institution_id=c.id
where client_id=3874 and event_name='login'
and ts>='2017-03-28'




select a.profile_id, event_name, ts, d.registration_url, user_role, name as Instituion, joined as MDLY_REG_DATE,
e.country, f.city, subject_area
from mendeley.live_events_201610_to_present a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.institutions c
on b.institution_id=c.id
left join (select profile_id, json_extract_path_text(properties, 'registration_url') as registration_url
from mendeley.live_events_201610_to_present a
where event_name='UserRegistration'
and json_extract_path_text(properties, 'registration_url')='https://www.mendeley.com/sneak-peek/cellpress'
and ts>='2017-03-28') d
on a.profile_id=d.profile_id
left join mendeley.profile_countries e
on a.profile_id=e.profile_id
left join mendeley.profile_cities f
on a.profile_id=f.profile_id
where client_id=3874
and ts>='2017-03-28'

--the good extract
select distinct profile_id from (

select a.profile_id, event_name, ts, d.registration_url, user_role, name as Instituion, joined as MDLY_REG_DATE
from mendeley.live_events_201610_to_present a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
left join mendeley.institutions c
on b.institution_id=c.id
left join (select profile_id, json_extract_path_text(properties, 'registration_url') as registration_url
from mendeley.live_events_201610_to_present a
where event_name='UserRegistration'
and json_extract_path_text(properties, 'registration_url')='https://www.mendeley.com/sneak-peek/cellpress'
and ts>='2017-03-28') d
on a.profile_id=d.profile_id
where client_id=3874 and event_name='login'
and ts>'2017-05-08' and ts<getdate()

)

select profile_id, json_extract_path_text(properties, 'registration_url') as registration_url
from mendeley.live_events_latest a
where event_name='UserRegistration'
and json_extract_path_text(properties, 'registration_url')='https://www.mendeley.com/sneak-peek/cellpress'
and ts>='2017-03-28'


select distinct product from mendeley.ros_social_users

'Feed Groups Filter Interactor'


---top Sneak Peek guys
select
profile_id,
sum(case when event_name='login' then 1 end)  as Login_count,
sum(case when event_name='SneakPeekCellPressDownloadConfirm' then 1 else 0 end)  as Download_count,
min(ts) as first_log_in,
max(ts) as most_recent_log_in

from mendeley.live_events_201610_to_present
where client_id=3874 
and ts>'2017-05-08' and ts<getdate()
group by 1
order by 2 desc
