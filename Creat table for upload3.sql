--drop TABLE  mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors;
create table mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors(
authorId NUMERIC ENCODE LZO
)DISTKEY(authorId) SORTKEY(authorId);
GRANT SELECT ON mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors  TO GROUP mendeley_reader;


select * from  mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors limit 10;

select authorId, count(*) from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors  group by 1 having count(*)>1;

select  count(*) from mendeley.sh_temp_chemistry_outreach_datascience_scopus_universe_181017_authors

3,715,228


