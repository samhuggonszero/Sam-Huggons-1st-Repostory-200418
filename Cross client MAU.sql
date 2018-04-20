with client_pairs as (
    select  A.index_ts,
            A.client_id clientA,
            B.client_id clientB
    from mendeley.dashboard_1m A
    inner join mendeley.dashboard_1m B
    on A.profile_id = B.profile_id
        and A.index_ts = B.index_ts
        --and A.client_id != B.client_id
    where A.index_ts >= '2017-01-01'
    group by    A.index_ts,
                A.client_id,
                B.client_id,
                A.profile_id,
                B.profile_id
), client_mau as (
    select  index_ts,
            client_id,
            count(distinct profile_id) client_mau
    from mendeley.dashboard_1m
    where index_ts >= '2017-01-01'
    group by 1, 2
)
select  cp.index_ts,
        clientA,
        clientB,
        cm.client_mau,
        count(*) as times
from client_pairs cp
left join client_mau cm
on cm.client_id = cp.clientA and cm.index_ts = cp.index_ts
group by 1, 2, 3, 4



