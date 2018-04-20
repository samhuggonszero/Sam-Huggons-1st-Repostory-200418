select distinct event_name

from mendeley.active_users_by_client_by_event_per_day 
where lower(event_name) like '%fileshare%'
and index_ts>'2018-01-01'

select distinct event_name from mendeley.fact_request_201801
where lower(event_name) like '%fileshare%'



'FileShareSubmitSuccess'
'FileShareSubmitError'
'FileShareInitiated'

select event_name,
index_ts,
Count(*) as rows, 
count(distinct(profile_id)) as useers

from mendeley.active_users_by_client_by_event_non_whitelisted_per_day
where event_name in ('FileShareSubmitSuccess','FileShareSubmitError','FileShareInitiated')
group by 1,2


select * from mendeley.profile_folder
where folder in ('/graham-hutchings/','/jean-marc-greneche/','/philippe-buhlmann/','/sergio-pinzauti/','/sarah-michele-harmon/','/akira-ohtomo/','/qunying-huang/','/vincent-j-fratello/','/wolf-dieter-schneider2/','/marja-liisa-riekkola/','/alejandro-j-mller/','/alberto-vomiero/','/wolffram-schroer/','/eric-le-bourhis/','/alberto-bianco2/','/i-baker/','/narayanan-neithalath/','/maria-cristina-fossi/','/arjan-jmc-mol/','/j-rinklebe/','/pierre-muller5/','/aimaro-sanna/','/stratos-pistikopoulos/','/franky-so/','/obada-kayali/','/toshiaki-enoki/','/rafael-luque5/','/matthias-beller/','/yang-lu55/','/guy-b-marin/','/wha-seung-ahn/','/jun-haginaka2/','/alexis-bell3/','/susan-sinnott/','/john-brian-mullin/','/ralf-ludwig2/','/david-field5/','/tamara-galloway/','/carolina-belver/','/matthias-bickermann/','/wentian-li2/','/surya-mallapragada/','/andrzej-stankiewicz2/','/bernhard-schartel/','/koji-sode/','/haruyuki-inui/','/jamie-platts/','/todd-hoare/','/per-hansson3/','/he-tian3/','/mark-van-der--auweraer/','/satoshi-uda/','/sangwoo-han3/','/hirofumi-wada2/','/paul-munroe/','/eric-suuberg/','/leyong-wang/','/jason-killgore2/','/jon-stewart3/','/darren-bradshaw2/','/roland-winter/','/constantina-e-marazioti/','/david-hage/','/lin-ye11/','/victor-carlos-pandolfelli/','/richard-hoogenboom/','/kevin-thomas17/',
'/junsaku-nitta/','/charles-wilkins2/')


select * from mendeley.profile_folder
where folder like '%hutchings%'