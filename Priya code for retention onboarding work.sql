/*********************************************************************************************************************//*********************************************************************************************************************/
-- Query V-5
-- 12 March - Onboarding Part 2
-- a find profile ids that perfomed actions a1,a2...a5
-- b find if these profile Ids are still active next week
-- c then make combinations 
/*********************************************************************************************************************/
/* Notes :
    Smaller date range is selected
    Actions are monitored in the first 14 days of Joining
    Retention period is 30-60 days after Joining 
    Join Date is June 17 - onwards
*/
/*********************************************************************************************************************/


with cc as
(


        with 
            ee as 
            (	        -- active users from Jule 2017 to Current date 
                        select 	distinct(profile_id),index_ts
                        from 	mendeley.active_users_per_day
                        where 	(index_ts >= '2017-06-01') and (index_ts < date_trunc('day',getdate())) 
                                            
                    
            ),
        dd as
        (    	

        --   a : Selecting Users that perfomed any of the actions listed in first month of joining
        --       Checking the events and flagging them if they were performed  

        select  profile_id,
                date_trunc('month',index_ts) as index_ts,
                date_trunc('day',d.joined) as join_day_of_month,
                date_trunc('month', d.joined) as cohort_month,
                --client_id,

                max(case when event_name in ('UserDocumentCreated') then 1 else 0 end) as UserDocumentCreated,
                max(case when event_name in ('MendeleyScopusAuthorClaim') then 1 else 0 end) as MendeleyScopusAuthorClaim,
                max(case when event_name in ('GroupJoined') then 1 else 0 end) as GroupJoined,
                max(case when event_name in ('followed') then 1 else 0 end) as ProfileFollowed,  

                -- need to add client id = 6, event Login is triggered when someone logs in Desktop for the first time and then register/sync 
                max(case when event_name in ('login') and client_id = 6 then 1 else 0 end) as DesktopDownloaded, 
               
                -- Range Duration when user performed any of the actions first time and last time from the Join date 
                min(index_ts) as first_time_action_taken
                --max(index_ts) as last_action_taken_on 
        
                from mendeley.active_users_by_client_by_event_per_day
                         
                left join mendeley.profiles d
                on profile_id=d.uu_profile_id
                and joined >= '2017-06-01' -- creates a table with profiles from 1st jan and then joins onto the active users table

                where index_ts >= '2017-06-01'
                and index_ts < date_trunc('day',getdate())           -- Checking for Index TS 
                and index_ts::date <= dateadd(day, 14, joined::date) -- we only look at events within 14 days of registration
                and (event_name in ('UserDocumentCreated','MendeleyScopusAuthorClaim','GroupJoined','followed') or (event_name in ('login') and client_id = 6)) 
                                     
                group by 1,2,3,4

	) -- dd ends 
	
				
	-- This will give profile Ids of all users that perfomed the below activites combinations after first 7 days of Joining
          
            Select  
                dd.cohort_month,
                dd.join_day_of_month,
				datediff('days',dd.join_day_of_month,dd.first_time_action_taken) as days_afterjoin_action_combination_taken,  -- Check with Sam

                -- If user taking action is NULL - that means that user took either of the action in 
                -- 'query part a' but not combination 
   
                --dd.last_action_taken_on,

                case 	
                    when UserDocumentCreated=1  and MendeleyScopusAuthorClaim=1 then 'Doc added & Scopus claimed'
                    when UserDocumentCreated=1  and MendeleyScopusAuthorClaim=0 then 'Doc added only'
                    when UserDocumentCreated=1  and GroupJoined=1 then 'Doc added & Group joined'
                    when UserDocumentCreated=1  and DesktopDownloaded=1 then 'Doc added & Desktop-Downloaded'
                    when UserDocumentCreated=1  and ProfileFollowed =1 then 'Doc added & Profile Followed'
                    when MendeleyScopusAuthorClaim=1 then 'Scopus claimed only'
                    when GroupJoined=1  then 'Group Joined Only'
                    when DesktopDownloaded=1 then 'Desktop Downloaded only'

                end as actions_taken,
                count(distinct(dd.profile_id)) as Users_that_took_com_action
                        
             /*  To check if a user in dd is still active in ee. */ 
            
               --count(distinct(ee.profile_id)) as Users_that_are_still_active ---this not giving correct number
            
               from dd
			   

               --left join ee on dd.profile_id = ee.profile_id -- Retention period is 30-60 days after join date 
                  --  where ee.index_ts >= dateadd(day,30,dd.join_day_of_month)
                   -- and ee.index_ts < dateadd(day,60,dd.join_day_of_month)
    
                group by 1,2,3,4
	    		order by 2,4,3
)

                select 	    cohort_month,
                            join_day_of_month,
                            days_afterjoin_action_combination_taken,

                            -- If user taking action is NULL - that means that user took either of the action in 'query part a' but not combination 
                            -- Trying with fewer combinations to check if this logic works
                        
                            --last_action_taken_on,
                            actions_taken,
                            Users_that_took_com_action,
                            --Users_that_are_still_active,	
	           	            p.acquisition_on_day 	

from cc

-- Checking total acquisition on the day 

left join       (select date_trunc('days', joined) as DayJoined, count(distinct(uu_profile_id)) as acquisition_on_day 
from            mendeley.profiles group by 1)p on cc.join_day_of_month = p.DayJoined

order by 1,2,3