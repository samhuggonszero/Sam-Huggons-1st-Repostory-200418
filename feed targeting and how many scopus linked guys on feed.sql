SELECT * FROM usage.mendeley.profile_stats_claim_per_day LIMIT 100;


select client_id,
a.index_ts,
count(distinct(case when a.index_ts<=b.index_ts then b.profile_id end)) as scopus_linked_at_time,
count(distinct(a.profile_id)) as feed_viewers

from mendeley.active_users_by_client_per_day a
left join mendeley.profile_stats_claim_per_day b
on a.profile_id=b.profile_id
where a.client_id=2364
and a.index_ts>='2017-01-01'
group by 1,2
order by 2 desc