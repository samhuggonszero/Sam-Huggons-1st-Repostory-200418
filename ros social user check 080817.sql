select index_ts, product,  count(distinct(profile_id)) from  mendeley.ros_social_users 
where product not in ('Newsfeed Viewers')
group by 1,2


select index_ts, count(distinct(profile_id)) 
from  mendeley.ros_social_users 
where product not in ('Newsfeed Viewers')
group by 1
order by 1 desc


select index_ts, max(max_date) as max_date,
count(distinct(profile_id)) as MDLY_USERS,
sum(case when feed_views>=1 then 1 else 0 end) as Active_newsfeed_users,
sum(case when profile_views>=1 then 1 else 0 end) as profile_users,
sum(case when stats_views>=1 then 1 else 0 end) as stats_users,
sum(case when suggest_views>=1 then 1 else 0 end) as suggest_users,
sum(case when group_views>=1 or feed_group_interactors>=1 then 1 else 0 end) as group_users,
sum(case when feed2_views>=1 then 1 else 0 end) as Newsfeed_viewing_users,
sum(case when feed_views>=1 or profile_views>=1 or stats_views>=1 or suggest_views>=1  or group_views>=1 or feed_group_interactors>=1 or mobile_suggest_views>=1 or mobile_feed_views>=1 
or Sneak_peak_views>=1 or web_cat_rec_interactor>=1 then 1 else 0 end) as ROS_SOCIAL_users,
sum(case when web_views>=1 then 1 else 0 end) as Web_viewing_users,
sum(case when desktop_views>=1 then 1 else 0 end) as Desktop_users,
sum(case when web_importer_views>=1 then 1 else 0 end) as Web_importer_users,
sum(case when data_views>=1 then 1 else 0 end) as Data_viewing_users,
sum(case when Web_Library_views>=1 then 1 else 0 end) as Web_library_users,
sum(case when Catalogue_views>=1 then 1 else 0 end) as Catalogue_viewing_users,
sum(case when Funding_views>=1 then 1 else 0 end) as Funding_viewing_users,
sum(case when Careers_views>=1 then 1 else 0 end) as Careers_viewing_users,
sum(case when mobile_views>=1 then 1 else 0 end) as Mobile_viewing_users,
sum(case when mobile_suggest_views>=1 then 1 else 0 end) as Mobile_suggest_users,
sum(case when mobile_feed_views>=1 then 1 else 0 end) as Mobile_feed_users,
sum(case when Sneak_peak_views>=1 then 1 else 0 end) as Sneak_peek_users

from (		
	select  profile_id,
			date_trunc('month', ts) as index_ts,
			max(ts) as max_date, 
				sum(case when le.client_id = 2364 and 							
					(le.event_name in ('FeedItemClicked', 'followed', 'unfollowed', 'RecommendationAddToLibrary', 'RecommendationADDTOLIBRARY','FeedNavAllNewsClicked','FeedNavNewPublicationsClicked','FeedNavGroupClicked','FeedFilterSelected','FeedJoinGroupClicked'))					
					or					
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 6 and ts<'2016-10-01')				
					or
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 2 and ts>='2016-10-01' and ts<='2017-05-14')
					or 
					(le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(properties, 'index') >= 1 and ts>='2017-05-15' and ts<'2017-06-27')
					or 
					(le.event_name='FeedPageScrolled' and ts>'2017-06-27')
										then 1 else 0 end) as feed_views,

					sum(case when le.client_id = 2364 then 1 else 0 end) as feed2_views,
			sum(case when le.client_id in (1127,3379) then 1 else 0 end) as profile_views,
			sum(case when le.client_id = 2054 then 1 else 0 end) as stats_views,
			sum(case when le.client_id = 2066 then 1 else 0 end) as suggest_views,
			sum(case when le.client_id = 3181 or le.event_name in ('group-admin-joined',
									'group-follower-joined',
									'group-member-joined',
								'group-owner-joined',
									'GroupSearchExecuted',
									'invite-group-invite-sent',
									'log.group-document-add',
									'log.group-status-update') 
									or  (le.event_name = 'SelectGroup' and le.client_id = 6 and json_extract_path_text(le.properties, 'GroupRemoteId') in (select uu_group_id from mendeley.groups))
									then 1 else 0 end) as group_views,
									sum(case when le.client_id=2364 and le.event_name in ('FeedFilterSelected') and json_extract_path_text(properties, 'filter') in ('group','groups') 
					then 1 else 0 end) as feed_group_interactors,
					sum(case when le.client_id in ('666','1025','1108','1125','1127','1360','1524','1695','1735','1777','1893','1980','2054','2066','2067','2074','2122','2124','2364','2409','2650','2713','2929','web')
					then 1 else 0 end) as web_views,
					sum(case when le.client_id in (7,808) then 1 else 0 end) mobile_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('RecommendationDisplayed') then 1 else 0 end) mobile_suggest_views,
					sum(case when le.client_id in (7,808) and le.event_name in ('FeedItemViewed') then 1 else 0 end) mobile_feed_views,
					sum(case when le.client_id in (3874) then 1 else 0 end) Sneak_peak_views,
					sum(case when le.client_id in (6) then 1 else 0 end) as desktop_views,
					sum(case when le.client_id in (2409) then 1 else 0 end) as web_importer_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as data_views,
					sum(case when le.client_id in (1360) then 1 else 0 end) as Web_Library_views,
					sum(case when le.client_id in (3945) then 1 else 0 end) as Catalogue_views,
					sum(case when le.client_id in (3585) then 1 else 0 end) as Funding_views,
					sum(case when le.client_id in (3518) then 1 else 0 end) as Careers_views,
					sum(case when le.client_id = 3945 AND le.event_name in ('WebCatalogDocumentRecommendationsAddToLibrary',
            'WebCatalogDocumentRecommendationsExpandAuthors',
            'WebCatalogDocumentRecommendationsOpen','WebCatalogDocumentRecommendationsOpenFullText',
            'WebCatalogDocumentRecommendationsViewLess','WebCatalogDocumentRecommendationsViewMore')
			then 1 else 0 end ) as web_cat_rec_interactor


	

from mendeley.live_events_filtered le
inner join mendeley.usage_events x
on le.event_name=x.event_name
and le.client_id=x.client_id 
	where le.ts >= '2017-06-01' and le.ts < '2017-07-01'
	group by 1,2
	order by 1,2
  ) c
  group by 1
  order by 1
  
  
  
  
  
  import datetime
import sys
from analyticsutils.cronkins.cronkins_config_interface import CronkinsConfigInterface as CCI
sys.path.append('.')
from shared.last_updated import LastUpdated
from aggregations.base_aggregation import BaseAggregation


class RosSocialUsersAggregation(BaseAggregation):
    """
    Update ros_social_users table per ANA-2760
    """

    TABLE_NAME = 'ros_social_users'

    SQL_TEMPLATE = """
      INSERT INTO ros_social_users
      SELECT DISTINCT '{index_ts}'::TIMESTAMP as index_ts, profile_id, product_name
      FROM
      (
        SELECT le.profile_id, {product_case_statement} as product_name FROM {le_table} le
        LEFT JOIN group_events_filter gef ON le.event_name::text = gef.event_name::text AND le.group_id = gef.group_id AND trunc(le.received_at) = trunc(gef.index_ts)
        LEFT JOIN client_events_filter cef ON le.event_name::text = cef.event_name::text AND le.client_id::text = cef.client_id::text
        LEFT JOIN clients_filter cf ON le.client_id::text = cf.client_id::text
        INNER JOIN usage_events ue ON le.event_name = ue.event_name and le.client_id = ue.client_id
        LEFT JOIN profile_features pf ON le.profile_id = pf.profile_id
        WHERE gef.group_id IS NULL AND cef.client_id IS NULL AND cf.client_id IS NULL
        AND date_trunc('month', le.{ts_field}) = '{index_ts}'
      )
      WHERE product_name != 'NONE'
      """

    CLEAR_SQL = """
        DELETE FROM ros_social_users WHERE index_ts = '{0}'
    """

    PRODUCTS = [
        {
            'name': 'Feed Groups Filter Interactor',
            'condition': """
              le.client_id = 2364
              AND le.event_name = 'FeedFilterSelected'
              AND json_extract_path_text(le.properties, 'filter') in ('group','groups')
            """
        },
        {
            'name': 'Active Newsfeed',
            'condition': """
                le.client_id = 2364
                AND
                (
                  (
                    le.event_name in ('FeedItemClicked', 'followed', 'unfollowed', 'RecommendationAddToLibrary', 
                    'RecommendationADDTOLIBRARY','FeedNavAllNewsClicked','FeedNavNewPublicationsClicked',
                    'FeedNavGroupClicked','FeedFilterSelected','FeedJoinGroupClicked'
                    )
                  )
                  OR
                  (le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(le.{misc_field}, 'index') >= 6 and le.{ts_field} <'2016-10-01')
                  OR
                  (le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(le.{misc_field}, 'index') >= 2 and le.{ts_field} >='2016-10-01' and le.{ts_field} <='2017-05-14')
                  OR
                  (le.event_name = 'FeedItemViewed' and JSON_EXTRACT_PATH_TEXT(le.{misc_field}, 'index') >= 1 and le.{ts_field} >='2017-05-15' and le.{ts_field} <'2017-06-27')
                  OR
                  (le.event_name = 'FeedPageScrolled' and le.{ts_field} >='2017-06-27')
                )
            """
        },
        {
            'name': 'Newsfeed Viewers',
            'condition': """le.client_id = 2364""",
        },
        {
            'name': 'Profile',
            'condition': """le.client_id = 1127 AND le.event_name='login'""",
        },
        {
            'name': 'Stats',
            'condition': """le.client_id = 2054 AND le.event_name='login'""",
        },
        {
            'name': 'Suggest',
            'condition': """le.client_id = 2066 AND le.event_name='login'""",
        },
        {
            'name': 'Group',
            'condition': """
                le.event_name in (
                    'group-admin-joined',
                    'group-follower-joined',
                    'group-member-joined',
                    'group-owner-joined',
                    'GroupSearchExecuted',
                    'invite-group-invite-sent',
                    'log.group-document-add',
                    'log.group-status-update'
                )
            """,
        },
        {
            'name': 'Mobile Suggest',
            'condition': """le.client_id in (808,7) AND le.event_name = 'RecommendationDisplayed'""",
        },
        {
            'name': 'Desktop Group Viewers',
            'condition': """
                le.event_name = 'SelectGroup'
                and le.client_id = 6
                and json_extract_path_text(le.{misc_field}, 'GroupRemoteId') in (select distinct(uu_group_id) from groups)
            """,
        },
        {
            'name': 'Community Interactors',
            'condition': """le.client_id = 3181 and le.event_name not in ('authFailed', 'login')""",
        },
        {
            'name': 'Community Viewers',
            'condition': """le.client_id = 3181""",
        },
        {
            'name': 'Stats Post Claim Viewers',
            'condition': """le.client_id = 2054 and pf.is_scopus_linked = 1""",
        },
        {
            'name': 'Cell Sneak Peek',
            'condition': """le.client_id = 3874""",
        },
        {
            'name': 'Research Papers Catalogue Suggest Interactors',
            'condition': """le.client_id = 3945 AND le.event_name in ('RecommendationAddToLibrary', 'RecommendationGetFullText', 'RecommendationOpenInLibrary')""",
        },
        {
            'name': 'Catalog Recommendation Interactors',
            'condition': """le.client_id = 3945 AND le.event_name in ('WebCatalogDocumentRecommendationsAddToLibrary',
            'WebCatalogDocumentRecommendationsExpandAuthors','WebCatalogDocumentRecommendationsInFocus',
            'WebCatalogDocumentRecommendationsOpen','WebCatalogDocumentRecommendationsOpenFullText',
            'WebCatalogDocumentRecommendationsViewLess','WebCatalogDocumentRecommendationsViewMore')""",
        },
    ]

    OVERALL_START_DATE = datetime.datetime(2015, 11, 1)

    def __init__(self, start_date=None, end_date=None):
        super(RosSocialUsersAggregation, self).__init__()
        self._get_date_range(start_date, end_date)
        self._check_source_data()

    def _get_product_case_statement(self):
        # produce a huge case statement in SQL based on our conditinos above.
        case_fragments = []
        for product in self.PRODUCTS:
            fragment = "WHEN {condition} THEN '{product_name}'".format(
                condition=product['condition'].format(
                    misc_field=CCI.get_redshift_misc_field(),
                    ts_field=CCI.get_redshift_ts_field(),
                ),
                product_name=product['name'],
            )
            case_fragments.append(fragment)
        return "CASE {0} ELSE 'NONE' END".format(' \n'.join(case_fragments))

    def _do_inserts(self):
        self.logger.info('Inserting data for {0}'.format(self.c_month_ts))

        self.rs.execute(
            self.SQL_TEMPLATE.format(
                index_ts=self.c_month_ts,
                product_case_statement=self._get_product_case_statement(),
                le_table=self.rs.get_event_table_name(self.c_date),
                ts_field=CCI.get_redshift_ts_field(),
            )
        )

    def _clear_rs_table(self):
        for self.c_date in self.month_iterator:
            self.logger.info('Clearing data for {0}'.format(self.c_month_ts))
            self.rs.execute(self.CLEAR_SQL.format(self.c_month_ts))

    @LastUpdated.set_updated_on_completion
    def _run_aggregation(self):
        for self.c_date in self.month_iterator:
            self._do_inserts()


if __name__ == '__main__':
    rsau = RosSocialUsersAggregation()
    rsau.process()
