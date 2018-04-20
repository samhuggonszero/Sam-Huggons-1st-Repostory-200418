
---final ish
select index_ts,
account_id, 
count(distinct(case when tenure_months=0 then uu_profile_id end)) as reg_mie_users,
count(distinct(uu_profile_id)) active_mie_users

from (
select date_trunc('month',joined) as Join_month,
index_ts,
datediff('month', date_trunc('month',joined), index_ts) as Tenure_months,
sis_id, 
c.account_id,
is_mie, 
uu_profile_id,
web_user_id


from mendeley.institutions a
left join mendeley.profiles b
on a.id=b.institution_id
left join common.dim_account c
on a.sis_id=account_sis_id
left join mendeley.active_users d
on b.uu_profile_id=d.profile_id
where is_mie=1

)
group by 1,2
limit 100


