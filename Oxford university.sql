select * from mendeley.institutions limit 100

name, id, sis_id, country, institution_type, 

select * from mendeley.institutions where lower(name) like '%oxford%'


'9807bca875ea6f4145bc9bdd017db3fc' --6673


institution_id, 

select * from mendeley.profiles a
left join mendeley.institutions b
on a.institution_id=b.id
where b.id='9807bca875ea6f4145bc9bdd017db3fc' 


---------------------------------

select index_ts, 
name, 
count(distinct(c.profile_id)) as active_users

from mendeley.profiles a
left join mendeley.institutions b
on a.institution_id=b.id
left join mendeley.active_users c
on a.uu_profile_id=c.profile_id
where b.id='9807bca875ea6f4145bc9bdd017db3fc' 
group by 1,2






select index_ts, 
name, 
b.country,
count(distinct(c.profile_id)) as active_users

from mendeley.profiles a
left join mendeley.institutions b
on a.institution_id=b.id
left join mendeley.active_users c
on a.uu_profile_id=c.profile_id
where name not in ('')
and index_ts>='2017-04-01'
group by 1,2,3