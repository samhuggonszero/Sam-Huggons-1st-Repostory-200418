select 
	name, 
	client_after, 
	w.profile_id profile_id, 
	e.profile_id user_adding_docs,
	e.document_id document_id_added,
	w.first_ts,
	e.ts
	
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
		where joined>='2017-08-22 12:00'
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
group by 1,2,3,4,5,6,7