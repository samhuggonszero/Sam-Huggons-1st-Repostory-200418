--drop TABLE mendeley.SH_TEMP_feed_vs_library_exp1_110917;
create table mendeley.SH_TEMP_feed_vs_library_exp1_110917 (
profile_id CHAR(50) ENCODE LZO,
groups VARCHAR(10) ENCODE LZO
)DISTKEY(profile_id) SORTKEY(profile_id, groups);
GRANT SELECT ON mendeley.SH_TEMP_feed_vs_library_exp1_110917 TO GROUP mendeley_reader;


select * from mendeley.SH_TEMP_feed_vs_library_exp1_110917