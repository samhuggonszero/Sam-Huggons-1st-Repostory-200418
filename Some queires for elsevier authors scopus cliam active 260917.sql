SELECT * FROM usage.mendeley.profiles_scopus_authors LIMIT 100;


with dd as(
select distinct pa.web_user_id, psa.created_date
from mendeley.profiles_scopus_authors psa
inner join mendeley.profiles_ae pa
using (profile_id)
)
select month, count(distinct r.web_user_id) as ros_kmau, count(distinct case when platform = 'mdy_ke' then r.web_user_id end) as mdly_mau, 
count(distinct dd.web_user_id) as ros_kmau_with_claim, count(distinct case when platform = 'mdy_ke' then dd.web_user_id end) as mdly_mau_with_claim
from mendeley.ros_kmau_daily_tmp r
left join dd
on dd.web_user_id = r.web_user_id
and dd.created_date::date <= r.index_ts::date
where month >= '2016-09-01'
and month < date_trunc('month', getdate())
group by 1
order by 1



select * from mendeley.ros_kmau_daily_tmp limit 100
select * from mendeley.profiles limit 100





select * from mendeley.profiles_scopus_author limit 100








with dd as(
select distinct pa.web_user_id, psa.created_date
from mendeley.profiles_scopus_authors psa
inner join mendeley.profiles_ae pa
using (profile_id)
)
select month,
Case when month=date_trunc('month',joined) then 'New' else 'Repeat' end as new_repeat,
published_in_elsevier_ever,
subject_area,
count(distinct r.web_user_id) as ros_kmau, count(distinct case when platform = 'mdy_ke' then r.web_user_id end) as mdly_mau, 
count(distinct dd.web_user_id) as ros_kmau_with_claim, count(distinct case when platform = 'mdy_ke' then dd.web_user_id end) as mdly_mau_with_claim

from mendeley.ros_kmau_daily_tmp r
left join dd
on dd.web_user_id = r.web_user_id
and dd.created_date::date <= r.index_ts::date
left join mendeley.profiles p
on r.web_user_id=p.web_user_id
left join (select a.profile_id,
max(case when publisher='ELSEVIER' and is_author=1 then 1 else 0 end) as published_in_elsevier_ever

from mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,8,100))=b.serial_detail_scopus_eid
left join (select distinct profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors) c
on a.profile_id=c.profile_id
where publisher='ELSEVIER' and is_author=1
group by 1
) z
on z.profile_id=p.uu_profile_id
where month >= '2016-09-01'
and month < date_trunc('month', getdate())
group by 1,2,3,4









select a.profile_id,
max(case when publisher='ELSEVIER' and is_author=1 then 1 else 0 end) as published_in_elsevier_ever

from mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,8,100))=b.serial_detail_scopus_eid
left join (select distinct profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors) c
on a.profile_id=c.profile_id
where publisher='ELSEVIER' and is_author=1
group by 1


on a.profile_id=p.uu_profile_id



select * from mendeley.documents limit 100




















select index_ts, b.group_id, members, 
visibility, invite_only,
count(*) as Events

from mendeley.groups a
inner join mendeley.group_events_per_day b
on a.uu_group_id=b.group_id
left join (select group_id, count(distinct(profile_id)) as members from mendeley.group_members group by 1) c
on a.id=c.group_id
group by 1,2,3,4,5





select * from mendeley.group_events_per_day limit 100

visibility, invite_only, 





