SELECT * FROM usage.mendeley.institutions LIMIT 100;


sis_id, 
Fraunhofer Institut IPA (Trial)

SELECT * FROM usage.mendeley.institutions
where sis_id=340544


'340544'count(distinct(uu_profile_id)) 


SELECT * FROM usage.mendeley.institutions
where sis_id=923

'923'

select joined,
sis_id, 
name, 
a.country as inst_country, 
institution_type, 
is_mie, 
uu_profile_id


from mendeley.institutions a
left join mendeley.profiles b
on a.id=b.institution_id
where sis_id=923





select sis_id, 
joined,
uu_profile_id

from mendeley.institutions a
left join mendeley.profiles b
on a.id=b.institution_id
where sis_id=923



select count(*) from (

select sis_id, 
index_ts as joined,
uu_profile_id	

from mendeley.institutions a
left join mendeley.profiles b
on a.id=b.institution_id
left join mendeley.active_users c
on b.uu_profile_id=c.profile_id
where sis_id=923

)






