--drop TABLE  mendeley.sh_temp_gaia_editors_021117;
create table mendeley.sh_temp_gaia_editors_021117(
folder CHAR(64) ENCODE LZO
)DISTKEY(folder) SORTKEY(folder);
GRANT SELECT ON mendeley.sh_temp_gaia_editors_021117 TO GROUP mendeley_reader;


select * from  mendeley.sh_temp_gaia_editors_021117 limit 10;

select folder, count(*) from mendeley.sh_temp_gaia_editors_021117 group by 1 having count(*)>1;

select  count(*) from mendeley.sh_temp_gaia_editors_021117


SELECT a.* FROM usage.mendeley.profile_folder a
inner join mendeley.sh_temp_gaia_editors_021117 b
on lower(trim(a.folder))=lower(trim(b.folder))


SELECT * FROM  mendeley.sh_temp_gaia_editors_021117 b
where folder not in (select folder from mendeley.profile_folder)




