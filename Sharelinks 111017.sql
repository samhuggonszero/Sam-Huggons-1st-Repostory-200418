--------------readers
select *

from mendeley.live_events_latest a
where client_id=2364 and event_name='FeedItemDisplayed'
and ts>='2017-10-09'
limit 100


'{"pageLoadId":"d1741b5aaa.3a98","filter":"all","itemId":"92ec953e-7bae-4f5d-be48-54ac539113bd","itemType":"new-pub"}'

(json_extract_path_text(properties, 'section')='comment_added'
(json_extract_path_text(properties, 'itemType')



select distinct json_extract_path_text(properties, 'itemType')
from mendeley.live_events_latest a
where client_id=2364 and event_name='FeedItemDisplayed'
and ts>='2017-10-09'


'third-party-rosx-gunter'
'third-party-rosx-gunter-helper'
'third-party-rosx-1'
'third-party-rosx-2'
'third-party-rosx-3'

select *
from mendeley.live_events_latest a
where event_name='NewsItemViewCreated'
and ts>='2017-10-09'
limit 100


'{"timestamp":"2017-10-09T19:48:15.176Z","type":"first-document-ever-added","audience":"06f6567a-d211-30b4-bcb6-7a78a5a57aee"}'


---does not appear to be a newsitemview created thingy??
select distinct json_extract_path_text(properties, 'type')
from mendeley.live_events_latest a
where event_name='NewsItemViewCreated'
and ts>='2017-10-09'


'aggregated-recently-read-document'
'aggregated-new-document-citations'
'aggregated-new-document-added'



select distinct event_name
from mendeley.live_events_latest a
where (json_extract_path_text(properties, 'type') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper')
or json_extract_path_text(properties, 'itemType') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper'))
and ts>='2017-10-09'
and client_id=2364 


'FeedItemClicked'
'FeedItemDisplayed'
'FeedItemViewed'



select a.*, 
json_extract_path_text(properties, 'itemType') as itemType,
json_extract_path_text(properties, 'section') as section

from mendeley.live_events_latest a
where (json_extract_path_text(properties, 'type') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper')
or json_extract_path_text(properties, 'itemType') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper'))
and ts>='2017-10-09'
and client_id=2364 
order by profile_id, ts


'ShareLinkScopusClaim'



select *

from mendeley.live_events_latest a
where client_id=2122 and event_name='ShareLinkScopusClaim'
and ts>='2017-10-09'
limit 100


{"scopusIds":"12803705700","dgcid":"AdobeCampaign_EES_sharelinksexperiment001_email","articlePII":"S0048969717325111","scopusIdsClaimed":"false","status":"success","mendeleyId":"47af6cb2-d8d0-356a-82a8-8780b7828984"}


json_extract_path_text(properties, 'scopusIds')
json_extract_path_text(properties, 'dgcid')
json_extract_path_text(properties, 'articlePII')
json_extract_path_text(properties, 'scopusIdsClaimed')
json_extract_path_text(properties, 'status')
json_extract_path_text(properties, 'mendeleyId')

'{"scopusIds":"6602401917","dgcid":"AdobeCampaign_EES_sharelinksexperiment001_email","articlePII":"S0968-0896(17)31830-8","scopusIdsClaimed":"false","status":"success","mendeleyId":"a26cd9d9-b542-35e5-9e95-4c3a9bac9792"}'

---------Metric for fun............
Primary KPI for Authors - % of Authors contacted who successfully  advertise the sharelink to their network
Primary KPI for Co-authors – average claims per successful primary Author who claims (virality of claim)
Primary KPI for Readers - % of users that see a sharelink reader card that click on the that card

--Primary KPI for Authors - % of Authors contacted who successfully  advertise the sharelink to their network
--Primary KPI for Co-authors – average claims per successful primary Author who claims (virality of claim)
select profile_id,
ts, 
event_name,
json_extract_path_text(properties, 'scopusIds') as scopusIds,
json_extract_path_text(properties, 'dgcid') as dgcid,
json_extract_path_text(properties, 'articlePII') as articlePII,
json_extract_path_text(properties, 'scopusIdsClaimed') as scopusIdsClaimed,
json_extract_path_text(properties, 'status') as status,
json_extract_path_text(properties, 'mendeleyId') as mendeleyId

from mendeley.live_events_201610_to_present a
where client_id=2122 and event_name='ShareLinkScopusClaim'
and ts>='2017-10-09'



--Primary KPI for Readers - % of users that see a sharelink reader card that click on the that card
select profile_id,
event_name,
ts,
json_extract_path_text(properties, 'itemType') as itemType,
json_extract_path_text(properties, 'section') as section

from mendeley.live_events_latest a
where (json_extract_path_text(properties, 'type') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper')
or json_extract_path_text(properties, 'itemType') in ('third-party-rosx-gunter','third-party-rosx-gunter-helper'))
and ts>='2017-10-09'
and client_id=2364 


third-party-rosx-gunter-helper = author success card
third-party-rosx-gunter = reader card

4782 =  third-party-rosx-1 (equals editor’s picks of one article)
4783 = third-party-rosx-2 (equals editor’s picks of a list of articles)
4784 = third-party-rosx-3 (equals editor’s picks of a preprint)


--registartions due to sharelinks
select profile_id,
ts, 
event_name,
json_extract_path_text(properties, 'scopusIds') as scopusIds,
json_extract_path_text(properties, 'dgcid') as dgcid,
json_extract_path_text(properties, 'articlePII') as articlePII,
json_extract_path_text(properties, 'scopusIdsClaimed') as scopusIdsClaimed,
json_extract_path_text(properties, 'status') as status,
json_extract_path_text(properties, 'mendeleyId') as mendeleyId,
case when date_trunc('day',ts)=date_trunc('day',joined) then 1 else 0 end as new_reg

from mendeley.live_events_201610_to_present a
left join mendeley.profiles b
on a.profile_id=b.uu_profile_id
where client_id=2122 and event_name='ShareLinkScopusClaim'
and ts>='2017-10-09'