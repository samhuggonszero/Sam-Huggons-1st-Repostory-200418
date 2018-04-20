

For the funding the users that will be eligible for recommendations will be the same on the newsfeed and through email:
• 10 Documents within their library
• Active within the last year
• Not a librarian
• Claimed a publication (or claim their Scopus profile)
• Have academic status and discipline set

These criteria come from the experiments we did at the beginning of the year. There was a big drop in CTR it we targeted all Mendeley years instead of the people who had claimed a profile. https://confluence.cbsels.com/display/FROS/Recommendations

As we have done no test yet with Careers this is a bit harder though we believe it would be a slightly looser criteria:
• 10 documents in their library
• Active within the last year
• Not a librarian
• Have academic status and discipline set

All the criteria’s would be the same for email and/or newsfeed.

-------------------------------Funding

select * from spectrum_docs.documents limit 10
select * from mendeley.active_users_by_client_per_day limit 10
select * from mendeley.active_users_per_day limit 10
select * from mendeley.profiles limit 10

---10 not deleed docs in library

select profile_id,
1 as Has_gt_10_docs_in_library,
count(*) as docs_in_library

from spectrum_docs.documents 
group by 1,2
having count(*)>=10

---- active last 12 months -3,598,287
select count(distinct (profile_id))
from mendeley.active_users_per_day
where index_ts>=getdate()-366 and index_ts<getdate()

---- active last 12 months -3,748,530
select count(distinct (profile_id))
from mendeley.active_users_per_day
where index_ts>='2016-09-01' and index_ts<'2017-10-01'


---
select indxe_ts, profile_id

from mendeley.active_users_by_client_per_day
where cleint_id=2364

select uu_profile_id, 1 as has_subarea_role_not_librarian from  mendeley.profiles 
where user_role is not null and use_role not in ('Librarian','') 
and subject_area is not null and subject_area not in ('') 





----------------------------------------------- main funding or careers overall
----------------------------------
select Has_gt_10_docs_in_library,
1 as active_in_last_12_months,
has_subarea_role_not_librarian,
scopus_claimed,
count(distinct(a.profile_id)) as users

from (select distinct profile_id
from mendeley.active_users_per_day
where index_ts>='2016-09-01' and index_ts<'2017-10-01'
) a

left join (select profile_id,
1 as Has_gt_10_docs_in_library,
count(*) as docs_in_library

from spectrum_docs.documents 
group by 1,2
having count(*)>=10) b
on a.profile_id=b.profile_id

left join (select uu_profile_id, 1 as has_subarea_role_not_librarian from  mendeley.profiles 
where user_role is not null and user_role not in ('Librarian','') 
and subject_area is not null and subject_area not in ('') ) c
on a.profile_id=c.uu_profile_id

left join (select distinct profile_id, 1 as scopus_claimed
from mendeley.profiles_scopus_authors ) d
on a.profile_id=d.profile_id

group by 1,2,3,4

----------------------------------------------- main funding or careers overall active on feed
select Has_gt_10_docs_in_library,
1 as active_in_last_12_months,
has_subarea_role_not_librarian,
scopus_claimed,
month_on_feed,
count(distinct(a.profile_id)) as users

from (select distinct profile_id
from mendeley.active_users_per_day
where index_ts>='2016-09-01' and index_ts<'2017-10-01'
) a

left join (select profile_id,
1 as Has_gt_10_docs_in_library,
count(*) as docs_in_library

from spectrum_docs.documents 
group by 1,2
having count(*)>=10) b
on a.profile_id=b.profile_id

left join (select uu_profile_id, 1 as has_subarea_role_not_librarian from  mendeley.profiles 
where user_role is not null and user_role not in ('Librarian','') 
and subject_area is not null and subject_area not in ('') ) c
on a.profile_id=c.uu_profile_id

left join (select distinct profile_id, 1 as scopus_claimed
from mendeley.profiles_scopus_authors) d
on a.profile_id=d.profile_id

left join (select date_trunc('month',index_ts) as month_on_feed, profile_id
from mendeley.active_users_by_client_per_day
where client_id=2364 
group by 1,2) e
on a.profile_id=e.profile_id

group by 1,2,3,4,5


---------------------CTR analysis

----------------------DAILY EVENTS-----------------------------

select case when JSON_EXTRACT_PATH_TEXT(properties, 'itemType') in ('recommendation','documents-recommendation') then 'documents-recommendation' 
when event_name='followed' then 'followed'
when event_name='unfollowed' then 'unfollowed'
else JSON_EXTRACT_PATH_TEXT(properties, 'itemType') end as ITEM_TYPE,
date_trunc('month' , ts) as month,
count(distinct( case when event_name in ('FeedItemDisplayed') then profile_id end )) as Displayed_Users,
count(distinct( case when event_name in ('FeedItemViewed') then profile_id end )) as Viewing_Users,
count(distinct( case when event_name in ('FeedItemClicked') then profile_id end )) as Clicking_Users,
count(distinct( case when event_name in ('FeedCommentAdded') then profile_id end )) as commenting_users,
count(distinct( case when event_name in ('FeedCommentAdded') and JSON_EXTRACT_PATH_TEXT(properties, 'commentIndex')>=2  then profile_id end )) as conversing_users,
count(distinct( case when event_name in ('followed') then profile_id end )) as following_users,
count(distinct( case when event_name in ('unfollowed') then profile_id end )) as unfollowing_users,
count( case when event_name in ('FeedItemClicked') then 1 end ) as Clicked_items,
count( case when event_name in ('FeedItemViewed') then 1 end ) as Viewed_items,
count( case when event_name in ('FeedItemDisplayed') then 1 end ) as Displayed_items,
count( case when event_name in ('FeedCommentAdded') then 1 end ) as comments,
count( case when event_name in ('FeedCommentAdded','FeedCommentEdited','FeedCommentDeleted') then 1 end ) as comment_action,
count( case when event_name in ('FeedCommentAdded') and JSON_EXTRACT_PATH_TEXT(properties, 'commentIndex')>=2  then 1 end ) as comments_GT_2_commentIndex,
count( case when event_name in ('followed') then 1 end ) as following_events,
count( case when event_name in ('unfollowed') then 1 end ) as unfollowing_events


from mendeley.live_events_201604_to_present
where client_id=2364
and event_name in ('FeedItemDisplayed', 'FeedItemViewed', 'FeedItemClicked','FeedCommentAdded','FeedCommentEdited','FeedCommentDeleted','followed','unfollowed')
and ts >= '2016-02-10' and ts < date_trunc('day' ,getdate())
and case when JSON_EXTRACT_PATH_TEXT(properties, 'itemType') in ('recommendation','documents-recommendation') then 'documents-recommendation' 
when event_name='followed' then 'followed'
when event_name='unfollowed' then 'unfollowed'
else JSON_EXTRACT_PATH_TEXT(properties, 'itemType') end  is not null

group by 1,2
order by 2,1



------email stuff

Reed Elsevier:
select date_trunc('week',index_ts) as month,
'Raven Suggest'  as type,
count(distinct case when action_name = 'Recommendation Sent' then profile_id end) as email_sent

from mendeley.raven_suggest_users_per_day
where ref = 'raven'
group by 1,2


select 
profile_id,
Date_trunc('day',ts) as date,
client_id,
name_ana,
json_extract_path_text(properties, 'endpoint') as Endpoint,
sum(case when event_name in ('RecommendationProfileFollowed','RecommendationProfileViewed') or json_extract_path_text(properties, 'itemType')='people-recommendation'then 1 else 0
end) as People_rec_click,
sum(case when event_name in ('RecommendationAddToLibrary','RecommendationViewed','RecommendationOpenInLibrary','RecommendationGetFullText',
'WebCatalogDocumentRecommendationsAddToLibrary','WebCatalogDocumentRecommendationsExpandAuthors','WebCatalogDocumentRecommendationsOpen',
'WebCatalogDocumentRecommendationsOpenFullText','WebCatalogDocumentRecommendationsViewLess','WebCatalogDocumentRecommendationsViewMore') or json_extract_path_text(properties, 'itemType')='document-recommendation' then 1 else 0
end) as Article_rec_click,
sum(case when event_name='SuggestLanded' then 1 else 0 end) as SuggestlandedravenClick,
sum(case when event_name='login' then 1 else 0 end) as PageView


from mendeley.live_events_201604_to_present a
left join mendeley.oauth2map b
on a.client_id=b.id
where (event_name in ('RecommendationAddToLibrary','RecommendationViewed','RecommendationOpenInLibrary','RecommendationGetFullText'
'RecommendationProfileFollowed','RecommendationProfileViewed','SuggestLanded',
'WebCatalogDocumentRecommendationsAddToLibrary','WebCatalogDocumentRecommendationsExpandAuthors','WebCatalogDocumentRecommendationsOpen',
'WebCatalogDocumentRecommendationsOpenFullText','WebCatalogDocumentRecommendationsViewLess','WebCatalogDocumentRecommendationsViewMore'))
or
(event_name='FeedItemClicked' and json_extract_path_text(properties, 'itemType') in ('people-recommendation','document-recommendation') )
or (event_name='login' and client_id in (2066,2364))
group by 1,2,3,4,5