select  date_trunc('month',index_ts) as index_ts,
count(distinct(profile_id)) as profiel_and_sats_users

from mendeley.active_users_by_client_per_day
where client_id in(1127,2054)
group by 1
order by 1




select  date_trunc('month',index_ts) as index_ts,
count(distinct(case when event_name='StatsOverviewViewed' then profile_id end)) as Stats_over_viewed,
count(distinct(case when client_id=2054 then profile_id end)) as all_stats_viewers,
count(distinct(case when event_name='MendeleyScopusAuthorClaim' then profile_id end)) as New_claims


from mendeley.active_users_by_client_by_event_per_day
group by 1
order by 1



select index_ts,
sum(case when Stats_over_viewed=1 and New_claims=0 then 1 else 0 end) as returning_stats_viewer,
sum(case when New_claims=1 then 1 else 0 end) as New_claims,
sum(case when all_stats_viewers=1 then 1 else 0 end) as all_stats_viewers

from (
select  date_trunc('month',index_ts) as index_ts,
profile_id,
max(case when event_name='StatsOverviewViewed' then 1 else 0 end) as Stats_over_viewed,
max(case when client_id=2054 then 1 else 0 end) as all_stats_viewers,
max(case when event_name='MendeleyScopusAuthorClaim' then 1 else 0 end) as New_claims

from mendeley.active_users_by_client_by_event_per_day
where event_name in ('StatsOverviewViewed','MendeleyScopusAuthorClaim') or client_id =2054
group by 1,2
order by 1
)
group by 1
order by 1





select case when new_claim_user=0 and stats_viewer=1 then 'return'
when new_claim_user=1 then 'new' end as new_ret_stats_viewer,
month,
count(distinct(profile_id)) as users

from (
select profile_id,
date_trunc('month',ts) as month,
max(case when event_name in ('MendeleyScopusAuthorClaim','MendeleyScopusAuthorClaimEvent') then 1 else 0 end) as new_claim_user,
max(case when event_name in ('StatsOverviewViewed') then 1 else 0 end) as stats_viewer

from mendeley.live_events_201510_to_present a
where ts>='2016-04-16'  and ts<getdate()
and event_name in( 'MendeleyScopusAuthorClaim','MendeleyScopusAuthorClaimEvent','StatsOverviewViewed')
group by 1,2
)
group by 1,2