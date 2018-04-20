SELECT count(*) FROM usage.mendeley.profiles where mie_user=1

SELECT * FROM usage.mendeley.profiles where mie_user=1 limit 100

SELECT * FROM usage.mendeley.institutions where lower(name) like '%maryland%'

SELECT * FROM usage.mendeley.groups 

where lower(name) like '%maryland%'

'University of Maryland University College Europe' '6551'

SELECT name,
count(*) 

FROM usage.mendeley.profiles a
left join mendeley.institutions  b
on a.institution_id=b.id
where mie_user=1
and b.id='6551'
group by 1

select * from mendeley.group_members limit 100

SELECT * FROM usage.mendeley.groups a
left join (select group_id , count(distinct(profile_id)) as members from mendeley.group_members group by 1) b
on a.id=b.group_id
where lower(name) like '%maryland%'

62 users is what we are aiming for


---ask seb
---maceij method

SELECT 
  "i"."institution_id" AS "institution_id",
    "i"."sis_id" as "sis_id",
    "i"."name" as "name",
    "i"."mendeley_name" as "mendeley_name",
    "i2".domain as domain,
    "i2"."is_mie" as "mie",
    "i2"."contract_start_date",
    "i2"."region",
    "i2"."sub_region",
    "i2"."ag_corp_hs",
    "i2"."subscription_year",
    "i2"."active_or_cancelled",
  "i"."user_count" AS "user_count",
  "i"."user_count_start_of_year" AS "user_count_start_of_year",
  "i"."active_user_count" AS "active_user_count",
  "i"."sessions_l6m_avg" AS "sessions_l6m_avg",
  "i"."docs_per_user_avg" AS "docs_per_user_avg",
  "i"."monthly_docs_read_per_user_avg" AS "monthly_docs_read_per_user_avg",
  "i"."public_group_memberships_per_user_avg" AS "public_group_memberships_per_user_avg",
  "i"."private_group_memberships_per_user_avg" AS "private_group_memberships_per_user_avg",
  "i"."followers_same_institution_per_user_avg" AS "followers_same_institution_per_user_avg",
  "i"."followees_same_institution_per_user_avg" AS "followees_same_institution_per_user_avg",
  "i"."followers_same_country_per_user_avg" AS "followers_same_country_per_user_avg",
  "i"."followees_same_country_per_user_avg" AS "followees_same_country_per_user_avg",
  "i"."followers_worldwide_per_user_avg" AS "followers_worldwide_per_user_avg",
  "i"."followees_worldwide_per_user_avg" AS "followees_worldwide_per_user_avg",
    mi.total_private_groups_created as "total_private_groups_created",
    "m"."mie_members",
    "s"."users_at_campaign_start",
    "s"."mie_users_at_campaign_start"

FROM "mendeley"."report_mps_institutions" "i"
left outer join "mendeley"."institutions" "i2" on "i2"."id"="i"."institution_id"
left outer join "mendeley"."report_mie_institutions" mi on mi.institution_id=i.institution_id
left outer join (
    select 
      "m"."institution_id", 
      count(DISTINCT "m"."profile_id") AS "mie_members"
    from "mendeley"."profile_mie_upgrade_dates" "m" 
    group by "m"."institution_id") "m" on "m"."institution_id"="i"."institution_id" 
left outer join (
  select 
    "i"."institution_id" AS "institution_id",
    "i"."mie" as "mie",
    COUNT(DISTINCT "p"."uu_profile_id") AS "users_at_campaign_start",
    COUNT(DISTINCT "m2"."profile_id") AS "mie_users_at_campaign_start"
  from "mendeley"."report_mie_institutions" "i"
  left outer join "mendeley"."institutions" "i2" on "i2"."id"="i"."institution_id"
  left outer join "mendeley"."profiles" "p" on "p"."institution_id"="i"."institution_id" 
    and "p"."joined" < "i2"."contract_start_date"
    and "p"."mie_user"="i2"."is_mie"
  left outer join "mendeley"."profile_mie_upgrade_dates" "m2" on "m2"."profile_id"="p"."uu_profile_id" 
  group by "i"."institution_id", "i"."mie"
  ) "s" on "s"."institution_id"="i"."institution_id" and "s"."mie"="i2"."is_mie"
  where lower(i.name) like'%maryland%'
  
  select * from mendeley.report_mie_institutions limit 100