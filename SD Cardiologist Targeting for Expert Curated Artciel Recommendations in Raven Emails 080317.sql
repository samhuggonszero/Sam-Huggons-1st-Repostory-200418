---query for SUTD target population
select Subject_area, 
scopus_claimed,
Platform,
SD_last_30_days,
index_ts,
count(distinct(a.web_user_id)) as users 

from mendeley.ros_kmau a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id
left join (select profile_id, 1 as scopus_claimed from mendeley.profiles_scopus_authors where claim_status='active' group by 1) d
on b.uu_profile_id=d.profile_id
left join (select distinct web_user_id, 1 as SD_last_30_days from mendeley.sv_aa_datafeed_sd
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' and web_user_id>0) e
on a.web_user_id=e.web_user_id
where a.index_ts='2018-01-01' and b.research_interests like '%cardio%'
group by 1,2,3,4,5
order by 6 desc

---AA SD page view data
select * 
from mendeley.sv_aa_datafeed_sd 
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0
limit 10

post_pagename, 
'sd:product:journal:article'
post_page_url, 
'https://vpn2.psu.ac.th/proxy/729c3758/http/www.sciencedirect.com/science/article/pii/S1876107010001094'
account_name_v7, 
'ae:prince of songkla university'
post_product_list, 
';sd:article:pii:s0964830506001430;;;;117=mime-xhtml|120=sd:article:scope-full|128=::hash::0|138=::hash::0|140=::hash::0|173=::hash::0|175=::hash::0|279=package|1203=sd:article:subtype:rev|1210=::hash::0|1211=::hash::0|1215=::hash::0'

'http://www.sciencedirect.com.ezproxy1.library.usyd.edu.au/science/article/pii/S0304387809000121'

--generate temp table to speed up query build
create table mendeley.sh_temp_sd_aa_smaple10k as (
select * from mendeley.sv_aa_datafeed_sd where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' limit 10000
)

--Checking method for getting pii's of pages seen -- working saved copy
select post_pagename,  
post_product_list, 
post_page_url, 
web_user_id,
position('pii/' in post_page_url) as position_pii,
position('pii/' in post_page_url)+4 as position_pii4,
len(post_page_url) as len_url,
substring(post_page_url,position('pii/' in post_page_url)+4 ,len(post_page_url)-position('pii/' in post_page_url)+4) as pii

from mendeley.sh_temp_sd_aa_smaple10k
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
limit 10


position('pii/',post_page_url)
---options for pii decode to title??
SELECT * FROM usage.scidir.dim_serial_detail LIMIT 100;
serial_detail_pii, 
SELECT * FROM usage.scidir.dim_non_serial_detail LIMIT 100;
non_serial_detail_pii, 
SELECT * FROM usage.scopus.dim_document LIMIT 100;
'Canadian Journal of Earth Sciences' document_pii,  document_oeid, 

--- doc joins example


------------------------------EXP3 - Reading list experiment Infectious Diseases------------------

--has document in library form last 3 years elsevier journals  55K 
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  --is_author=1 and
  serial_detail_formatted_issn  in ('2352-7714','25425196','0167-5877','0147-9571','0021-9975','2210-6006','1477-8939')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

--non elsevier journal doc in library since 2014 as pr
select  a.profile_id, document_issn as issn, is_author, publisher, max(document_pub_year) as most_recent_pub_year

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where document_issn in (23527714,25425196,01675877,01479571,00219975,22106006,14778939)
and a.cluster_centre like '%scopus%'
and document_pub_year>=2014 
group by 1,2,3,4

--is in  research interests 1338
select uu_profile_id from  mendeley.profiles
where research_interests like '%health%'
or research_interests like '%one health%'
or research_interests like '%global  health%'

--has authored doc in library ever elsevier journals 2277
select a.profile_id, 
serial_detail_issn as issn,
is_author,
publisher, 
max(serial_detail_cover_start_date) as most_recent_publication_date

from usage.mendeley.documents a
left join scidir.dim_serial_detail b
on trim(substring(a.cluster_centre,9,100))=b.serial_detail_scopus_eid
where  is_author=1 and
  serial_detail_formatted_issn  in ('2352-7714','25425196','0167-5877','0147-9571','0021-9975','2210-6006','1477-8939')
and a.cluster_centre like '%scopus%'
and serial_detail_cover_start_date>=getdate()-1095
group by 1,2,3,4

---is in X subject area 951K
select count(*) from  mendeley.profiles
where subject_area in ('Nursing and Health Professions','Medicine and Dentistry')

select subject_area, count(*) from mendeley.profiles group by 1

----non elsevier journals authored 1998
select distinct a.profile_id, document_issn as issn, is_author, publisher

from usage.mendeley.documents a
left join scopus.dim_document  b
on b.document_eid= trim(substring(a.cluster_centre,9,100))
where  is_author=1
and  document_issn in (23527714,25425196,01675877,01479571,00219975,22106006,14778939)
and a.cluster_centre like '%scopus%'


---join to get doc titles, issns, journals and key word based search??? -- slow join, could be problem -- 180s for only 10K rows
select post_pagename,  
post_product_list, 
post_page_url, 
web_user_id,
position('pii/' in post_page_url) as position_pii,
position('pii/' in post_page_url)+4 as position_pii4,
len(post_page_url) as len_url,
substring(post_page_url,position('pii/' in post_page_url)+4 ,len(post_page_url)-position('pii/' in post_page_url)+4) as pii,
substring(post_page_url,position('pii/' in post_page_url)+5 ,len(post_page_url)-position('pii/' in post_page_url)+5) as pii2,
b.*

from mendeley.sh_temp_sd_aa_smaple10k a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
limit 10


---
select * from scidir.dim_serial_detail
where serial_detail_pii='001502821400212'




select post_pagename,  
post_product_list, 
post_page_url, 
web_user_id,
position('pii/' in post_page_url) as position_pii,
position('pii/' in post_page_url)+4 as position_pii4,
len(post_page_url) as len_url,
substring(post_page_url,position('pii/' in post_page_url)+4 ,len(post_page_url)-position('pii/' in post_page_url)+4) as pii,
substring(post_page_url,position('pii/' in post_page_url)+5 ,len(post_page_url)-position('pii/' in post_page_url)+5) as pii2,
b.*

from mendeley.sh_temp_sd_aa_smaple10k a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (lower(document_title) like '%cardio%'
or document_full_title='American Journal of Cardiology')
limit 10


select '0167487001000630'

select * from spectrum_docs.documents limit 10

select * from scopus.dim_document where document_pii is not null limit 1000
'S0966479300889347'

---requirements
1) subscribed to SD article recs - provided by Raven web user ids
2) Active recently on SD last month or so depending on volumes
3) looking at article pages with something to do with cadiology so we align with practiceupdate.com
4) could be looking at cardiology journals list provided by someone --http://www.scimagojr.com/journalrank.php?category=2705


select * from scopus.dim_document where document_full_title='American Journal of Cardiology'

---- 9794  page views in 1 day -- 281 seconds not too bad
select count(*)

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (lower(document_title) like '%cardio%'
or document_full_title='American Journal of Cardiology')


---- 643308  page views in 1 month -283 seconds
select count(*)

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (lower(document_title) like '%cardio%'
or document_full_title='American Journal of Cardiology')

---------------------------------



select count(distinct(web_user_id))

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (lower(document_title) like '%cardio%'
or document_full_title='American Journal of Cardiology')


select distinct document_title
from scopus.dim_document 
where lower(document_title) like '%cardio%'


select count(distinct(web_user_id))
from mendeley.sv_aa_datafeed_sd a
where post_cust_hit_time_gmt>='2018-03-01' and post_cust_hit_time_gmt<'2018-04-01' 

document_publisher_id, 

document_issn, 

'00029149'


('00097322','0195668X','00097330','19368798','22131779','19417640','00392499','13889842','1936878X','10795642','03009572','00123692','00028703','17595002','0271678X','03008428','00086363','19413149','08947317','15475271','13556037','00222828','09579672','20479980','00225223','10995129','02636352','07415214','00029149','20472404','1774024X','07351097','19332874','15266028','10453873','00330620','03636135','00219150','14752840','10159770','13469843','18610684','10785884','13824147','20474873','10107940','19375387','09394753','01675273','10719164','00034975','19345925','20488726','11282460','01462806','09169636','15221946','0828282X','10739688','10501738','18684483','01609289','21638306','17555914','15675688','10510443','14791641','10181172','00283940','09203206','15233804','20900163','10742484','18752136','10929126','19331711','00262862','10713581','14712261','15517136','02684705','00946176','15396851','10615377','09145087','11766344','13403478','01602446','02683555','15469530','20900597','1383875X','15246175','10548807','01741551','19327501','20902824','11753277','00086312','15695794','15701611','1573403X','10523057','16643828','08964327','09295305','15307905','22118160','15699293','08037051','01720643','07338651','00219509','15233782','1871529X','09546928','14745151','09108327','1358863X','1747079X','17385997','13860291','01478389','14347229','10430679','11787104','14767120','10530770','17498090','14779072','13492365','1535282X','14796678','00033197','07422822','17442648','08905096','13053825','15538389','08860440','09668519','14204096','10928464','08957967','15685888','14439506','17482941','2213333X','1082720X','18636705','01479563','17539447','03008932','07399529','19739621','15306550','01716425','00220736','16715411','10892516','10892532','13595237','18975593','09742069','15748901','15385744','18684300','11795468','11209879')


select count(distinct(web_user_id))

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (document_issn in ('00097322','0195668X','00097330','19368798','22131779','19417640','00392499','13889842','1936878X','10795642','03009572','00123692','00028703','17595002','0271678X','03008428','00086363','19413149','08947317','15475271','13556037','00222828','09579672','20479980','00225223','10995129','02636352','07415214','00029149','20472404','1774024X','07351097','19332874','15266028','10453873','00330620','03636135','00219150','14752840','10159770','13469843','18610684','10785884','13824147','20474873','10107940','19375387','09394753','01675273','10719164','00034975','19345925','20488726','11282460','01462806','09169636','15221946','0828282X','10739688','10501738','18684483','01609289','21638306','17555914','15675688','10510443','14791641','10181172','00283940','09203206','15233804','20900163','10742484','18752136','10929126','19331711','00262862','10713581','14712261','15517136','02684705','00946176','15396851','10615377','09145087','11766344','13403478','01602446','02683555','15469530','20900597','1383875X','15246175','10548807','01741551','19327501','20902824','11753277','00086312','15695794','15701611','1573403X','10523057','16643828','08964327','09295305','15307905','22118160','15699293','08037051','01720643','07338651','00219509','15233782','1871529X','09546928','14745151','09108327','1358863X','1747079X','17385997','13860291','01478389','14347229','10430679','11787104','14767120','10530770','17498090','14779072','13492365','1535282X','14796678','00033197','07422822','17442648','08905096','13053825','15538389','08860440','09668519','14204096','10928464','08957967','15685888','14439506','17482941','2213333X','1082720X','18636705','01479563','17539447','03008932','07399529','19739621','15306550','01716425','00220736','16715411','10892516','10892532','13595237','18975593','09742069','15748901','15385744','18684300','11795468','11209879')
OR lower(document_full_title) in ('circulation','european heart journal','circulation research','jacc: cardiovascular interventions','jacc: heart failure','circulation: cardiovascular interventions','stroke','european journal of heart failure','jacc: cardiovascular imaging','arteriosclerosis, thrombosis, and vascular biology','resuscitation','chest','american heart journal','nature reviews cardiology','journal of cerebral blood flow and metabolism','basic research in cardiology','cardiovascular research','circulation: arrhythmia and electrophysiology','journal of the american society of echocardiography','heart rhythm','heart','journal of molecular and cellular cardiology','current opinion in lipidology','journal of the american heart association','journal of thoracic and cardiovascular surgery','europace','journal of hypertension','journal of vascular surgery','american journal of cardiology','european heart journal cardiovascular imaging','eurointervention','journal of the american college of cardiology','journal of clinical lipidology','journal of endovascular therapy','journal of cardiovascular electrophysiology','progress in cardiovascular diseases','american journal of physiology - heart and circulatory physiology','atherosclerosis','cardiovascular diabetology','cerebrovascular diseases','circulation journal','clinical research in cardiology','european journal of vascular and endovascular surgery','heart failure reviews','european journal of preventive cardiology','european journal of cardio-thoracic surgery','journal of cardiovascular translational research','nutrition, metabolism and cardiovascular diseases','international journal of cardiology','journal of cardiac failure','annals of thoracic surgery','journal of cardiovascular computed tomography','european heart journal: acute cardiovascular care','acta myologica','current problems in cardiology','hypertension research','catheterization and cardiovascular interventions','canadian journal of cardiology','microcirculation','trends in cardiovascular medicine','translational stroke research','clinical cardiology','cpt: pharmacometrics and systems pharmacology','cardiovascular therapeutics','atherosclerosis supplements','journal of vascular and interventional radiology','diabetes and vascular disease research','journal of vascular research','neuroradiology','cardiovascular drugs and therapy','current atherosclerosis reports','cardiovascular psychiatry and neurology','journal of cardiovascular pharmacology and therapeutics','archives of cardiovascular diseases','pediatric cardiac surgery annual','journal of the american society of hypertension','microvascular research','journal of nuclear cardiology','bmc cardiovascular disorders','heart failure clinics','current opinion in cardiology','seminars in thrombosis and hemostasis','lymphatic research and biology','cardiology in review','journal of cardiology','vascular health and risk management','journal of atherosclerosis and thrombosis','journal of cardiovascular pharmacology','phlebology','current heart failure reports','cardiology research and practice','journal of interventional cardiac electrophysiology','journal of clinical hypertension','cardiovascular pathology','cardiovascular and interventional radiology','journal of cardiopulmonary rehabilitation and prevention','international journal of vascular medicine','american journal of cardiovascular drugs','cardiology','international journal of cardiovascular imaging','current vascular pharmacology','current cardiology reviews','journal of stroke and cerebrovascular diseases','cardiorenal medicine','journal of interventional cardiology','journal of thrombosis and thrombolysis','cardiovascular toxicology','global heart','interactive cardiovascular and thoracic surgery','blood pressure','pediatric cardiology','cardiology clinics','journal of cardiovascular surgery','current cardiology reports','cardiovascular and hematological disorders - drug targets','coronary artery disease','european journal of cardiovascular nursing','heart and vessels','vascular medicine','congenital heart disease','electrolyte and blood pressure','clinical hemorheology and microcirculation','pace - pacing and clinical electrophysiology','journal of artificial organs','seminars in thoracic and cardiovascular surgery','integrated blood pressure control','cardiovascular ultrasound','journal of cardiothoracic and vascular anesthesia','journal of cardiothoracic surgery','expert review of cardiovascular therapy','international heart journal','critical pathways in cardiology','future cardiology','angiology','echocardiography','evidence and policy','annals of vascular surgery','diagnostic and interventional radiology','cardiovascular revascularization medicine','journal of cardiac surgery','journal of heart valve disease','kidney and blood pressure research','current treatment options in cardiovascular medicine','seminars in vascular surgery','netherlands heart journal','heart lung and circulation','acute cardiac care','journal of vascular surgery: venous and lymphatic disorders','annals of noninvasive electrocardiology','general thoracic and cardiovascular surgery','heart and lung: journal of acute and critical care','therapeutic advances in cardiovascular disease','revista espanola de cardiologia','seminars in interventional radiology','hot topics in cardiology','reviews in cardiovascular medicine','thoracic and cardiovascular surgeon','journal of electrocardiology','journal of geriatric cardiology','techniques in vascular and interventional radiology','seminars in cardiothoracic and vascular anesthesia','blood pressure monitoring','cardiology journal','annals of pediatric cardiology','recent patents on cardiovascular drug discovery','vascular and endovascular surgery','cardiovascular intervention and therapeutics','clinical medicine insights: cardiology','high blood pressure and cardiovascular prevention','american journal of cardiovascular disease','cardiovascular engineering and technology','vasa - journal of vascular diseases','cardiovascular journal of africa','annals of cardiac anaesthesia','minerva cardioangiologica','innovations: technology and techniques in cardiothoracic and vascular surgery','interventional neuroradiology','annals of thoracic medicine','world journal for pediatric and congenital hearth surgery','vascular','korean circulation journal','international angiology','arya atherosclerosis','perfusion','journal of cardiovascular disease research','annals of thoracic and cardiovascular surgery','texas heart institute journal','arquivos brasileiros de cardiologia','artery research','heart international','open cardiovascular medicine journal','journal of cardiovascular ultrasound','korean journal of thoracic and cardiovascular surgery','kardiologia polska','cardiology in the young','journal of cardiovascular medicine','indian pacing and electrophysiology journal','acta cardiologica','international cardiovascular research journal','journal of the saudi heart association','indian heart journal','revista portuguesa de cardiologia','herzschrittmachertherapie und elektrophysiologie','progress in pediatric cardiology','herz','operative techniques in thoracic and cardiovascular surgery','interventional cardiology clinics','journal of extra-corporeal technology','acta phlebologica','clinical medicine insights: circulatory, respiratory and pulmonary medicine','turk kardiyoloji dernegi arsivi','ijc heart and vasculature','journal des maladies vasculaires','cardiac electrophysiology clinics','ijc metabolic and endocrine','postepy w kardiologii interwencyjnej','journal of arrhythmia','international journal of angiology','phlebolymphology','world heart journal','clinica e investigacion en arteriosclerosis','giornale italiano di cardiologia','phlebologie','annales de cardiologie et dangeiologie','gefasschirurgie','jornal vascular brasileiro','monaldi archives for chest disease','archives of clinical infectious diseases','turkish journal of thoracic and cardiovascular surgery','journal of tehran university heart center','cor et vasa','phlebologie','ijc heart and vessels','archivos de cardiologia de mexico','european heart journal, supplement','acta cardiologica sinica','applied cardiopulmonary pathophysiology','vnitrni lekarstvi','british journal of cardiology','reviews in vascular medicine','revista espanola de cardiologia suplementos','interventional cardiology (london)','vascular disease management','heart asia','revista brasileira de cardiologia invasiva','der kardiologe','interventional cardiology','journal of cardiovascular echography','chinese journal of cardiology','primary care cardiovascular journal','cardiovascular therapy and prevention (russian federation)','kardiologiya','russian journal of cardiology','angiologia','cardiology letters','cardiology (pakistan)','journal of atrial fibrillation','journal of cardiology cases','cirugia cardiovascular','egyptian heart journal','journal für kardiologie','kardiochirurgia i torakochirurgia polska','hipertension y riesgo vascular','clinical and experimental medical letters','revista colombiana de cardiologia','revista mexicana de cardiologia','revista mexicana de angiologia','zeitschrift für gefassmedizin','medecine des maladies metaboliques','revista argentina de cardiologia','acta angiologica','european cardiology','zeitschrift für herz-, thorax- und gefasschirurgie','insuficiencia cardiaca','kardiologicka revue','revista de la federacion argentina de cardiologia','open hypertension journal','dialogues in cardiovascular medicine','ejves extra','research journal of cardiology','cardiocore','chinese journal of cerebrovascular diseases','intervencni a akutni kardiologie','polski przeglad kardiologiczny','turk serebrovaskuler hastaliklar dergisi','angeiologie','heart and metabolism','indian journal of thoracic and cardiovascular surgery','iranian heart journal','journal of the hong kong college of cardiology','nadcisnienie tetnicze','revista latinoamericana de hipertension','thoracic and cardiovascular surgeon, supplement','archives of cardiovascular diseases supplements','italian journal of vascular and endovascular surgery','journal for vascular ultrasound','journal phlebology and lymphology','kardiotechnik','turkiye klinikleri cardiovascular sciences','vasomed','archives des maladies du coeur et des vaisseaux - pratique','respiration and circulation','revista mexicana de enfermeria cardiologica','cardiology and therapy','cardiovascular endocrinology','cerebrovascular diseases extra','clinical trials and regulatory science in cardiology','ejves short reports','global cardiology science and practice','heartrhythm case reports','interventional neurology','jacc: clinical electrophysiology','journal of stroke','journal of vascular surgery cases','open heart','world journal of cardiology')
)
323 seconds
23365
24475

--drop table mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 
create table mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 as (
select distinct (cast(web_user_id as numeric))

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (document_issn in ('00097322','0195668X','00097330','19368798','22131779','19417640','00392499','13889842','1936878X','10795642','03009572','00123692','00028703','17595002','0271678X','03008428','00086363','19413149','08947317','15475271','13556037','00222828','09579672','20479980','00225223','10995129','02636352','07415214','00029149','20472404','1774024X','07351097','19332874','15266028','10453873','00330620','03636135','00219150','14752840','10159770','13469843','18610684','10785884','13824147','20474873','10107940','19375387','09394753','01675273','10719164','00034975','19345925','20488726','11282460','01462806','09169636','15221946','0828282X','10739688','10501738','18684483','01609289','21638306','17555914','15675688','10510443','14791641','10181172','00283940','09203206','15233804','20900163','10742484','18752136','10929126','19331711','00262862','10713581','14712261','15517136','02684705','00946176','15396851','10615377','09145087','11766344','13403478','01602446','02683555','15469530','20900597','1383875X','15246175','10548807','01741551','19327501','20902824','11753277','00086312','15695794','15701611','1573403X','10523057','16643828','08964327','09295305','15307905','22118160','15699293','08037051','01720643','07338651','00219509','15233782','1871529X','09546928','14745151','09108327','1358863X','1747079X','17385997','13860291','01478389','14347229','10430679','11787104','14767120','10530770','17498090','14779072','13492365','1535282X','14796678','00033197','07422822','17442648','08905096','13053825','15538389','08860440','09668519','14204096','10928464','08957967','15685888','14439506','17482941','2213333X','1082720X','18636705','01479563','17539447','03008932','07399529','19739621','15306550','01716425','00220736','16715411','10892516','10892532','13595237','18975593','09742069','15748901','15385744','18684300','11795468','11209879')
OR lower(document_full_title) in ('circulation','european heart journal','circulation research','jacc: cardiovascular interventions','jacc: heart failure','circulation: cardiovascular interventions','stroke','european journal of heart failure','jacc: cardiovascular imaging','arteriosclerosis, thrombosis, and vascular biology','resuscitation','chest','american heart journal','nature reviews cardiology','journal of cerebral blood flow and metabolism','basic research in cardiology','cardiovascular research','circulation: arrhythmia and electrophysiology','journal of the american society of echocardiography','heart rhythm','heart','journal of molecular and cellular cardiology','current opinion in lipidology','journal of the american heart association','journal of thoracic and cardiovascular surgery','europace','journal of hypertension','journal of vascular surgery','american journal of cardiology','european heart journal cardiovascular imaging','eurointervention','journal of the american college of cardiology','journal of clinical lipidology','journal of endovascular therapy','journal of cardiovascular electrophysiology','progress in cardiovascular diseases','american journal of physiology - heart and circulatory physiology','atherosclerosis','cardiovascular diabetology','cerebrovascular diseases','circulation journal','clinical research in cardiology','european journal of vascular and endovascular surgery','heart failure reviews','european journal of preventive cardiology','european journal of cardio-thoracic surgery','journal of cardiovascular translational research','nutrition, metabolism and cardiovascular diseases','international journal of cardiology','journal of cardiac failure','annals of thoracic surgery','journal of cardiovascular computed tomography','european heart journal: acute cardiovascular care','acta myologica','current problems in cardiology','hypertension research','catheterization and cardiovascular interventions','canadian journal of cardiology','microcirculation','trends in cardiovascular medicine','translational stroke research','clinical cardiology','cpt: pharmacometrics and systems pharmacology','cardiovascular therapeutics','atherosclerosis supplements','journal of vascular and interventional radiology','diabetes and vascular disease research','journal of vascular research','neuroradiology','cardiovascular drugs and therapy','current atherosclerosis reports','cardiovascular psychiatry and neurology','journal of cardiovascular pharmacology and therapeutics','archives of cardiovascular diseases','pediatric cardiac surgery annual','journal of the american society of hypertension','microvascular research','journal of nuclear cardiology','bmc cardiovascular disorders','heart failure clinics','current opinion in cardiology','seminars in thrombosis and hemostasis','lymphatic research and biology','cardiology in review','journal of cardiology','vascular health and risk management','journal of atherosclerosis and thrombosis','journal of cardiovascular pharmacology','phlebology','current heart failure reports','cardiology research and practice','journal of interventional cardiac electrophysiology','journal of clinical hypertension','cardiovascular pathology','cardiovascular and interventional radiology','journal of cardiopulmonary rehabilitation and prevention','international journal of vascular medicine','american journal of cardiovascular drugs','cardiology','international journal of cardiovascular imaging','current vascular pharmacology','current cardiology reviews','journal of stroke and cerebrovascular diseases','cardiorenal medicine','journal of interventional cardiology','journal of thrombosis and thrombolysis','cardiovascular toxicology','global heart','interactive cardiovascular and thoracic surgery','blood pressure','pediatric cardiology','cardiology clinics','journal of cardiovascular surgery','current cardiology reports','cardiovascular and hematological disorders - drug targets','coronary artery disease','european journal of cardiovascular nursing','heart and vessels','vascular medicine','congenital heart disease','electrolyte and blood pressure','clinical hemorheology and microcirculation','pace - pacing and clinical electrophysiology','journal of artificial organs','seminars in thoracic and cardiovascular surgery','integrated blood pressure control','cardiovascular ultrasound','journal of cardiothoracic and vascular anesthesia','journal of cardiothoracic surgery','expert review of cardiovascular therapy','international heart journal','critical pathways in cardiology','future cardiology','angiology','echocardiography','evidence and policy','annals of vascular surgery','diagnostic and interventional radiology','cardiovascular revascularization medicine','journal of cardiac surgery','journal of heart valve disease','kidney and blood pressure research','current treatment options in cardiovascular medicine','seminars in vascular surgery','netherlands heart journal','heart lung and circulation','acute cardiac care','journal of vascular surgery: venous and lymphatic disorders','annals of noninvasive electrocardiology','general thoracic and cardiovascular surgery','heart and lung: journal of acute and critical care','therapeutic advances in cardiovascular disease','revista espanola de cardiologia','seminars in interventional radiology','hot topics in cardiology','reviews in cardiovascular medicine','thoracic and cardiovascular surgeon','journal of electrocardiology','journal of geriatric cardiology','techniques in vascular and interventional radiology','seminars in cardiothoracic and vascular anesthesia','blood pressure monitoring','cardiology journal','annals of pediatric cardiology','recent patents on cardiovascular drug discovery','vascular and endovascular surgery','cardiovascular intervention and therapeutics','clinical medicine insights: cardiology','high blood pressure and cardiovascular prevention','american journal of cardiovascular disease','cardiovascular engineering and technology','vasa - journal of vascular diseases','cardiovascular journal of africa','annals of cardiac anaesthesia','minerva cardioangiologica','innovations: technology and techniques in cardiothoracic and vascular surgery','interventional neuroradiology','annals of thoracic medicine','world journal for pediatric and congenital hearth surgery','vascular','korean circulation journal','international angiology','arya atherosclerosis','perfusion','journal of cardiovascular disease research','annals of thoracic and cardiovascular surgery','texas heart institute journal','arquivos brasileiros de cardiologia','artery research','heart international','open cardiovascular medicine journal','journal of cardiovascular ultrasound','korean journal of thoracic and cardiovascular surgery','kardiologia polska','cardiology in the young','journal of cardiovascular medicine','indian pacing and electrophysiology journal','acta cardiologica','international cardiovascular research journal','journal of the saudi heart association','indian heart journal','revista portuguesa de cardiologia','herzschrittmachertherapie und elektrophysiologie','progress in pediatric cardiology','herz','operative techniques in thoracic and cardiovascular surgery','interventional cardiology clinics','journal of extra-corporeal technology','acta phlebologica','clinical medicine insights: circulatory, respiratory and pulmonary medicine','turk kardiyoloji dernegi arsivi','ijc heart and vasculature','journal des maladies vasculaires','cardiac electrophysiology clinics','ijc metabolic and endocrine','postepy w kardiologii interwencyjnej','journal of arrhythmia','international journal of angiology','phlebolymphology','world heart journal','clinica e investigacion en arteriosclerosis','giornale italiano di cardiologia','phlebologie','annales de cardiologie et dangeiologie','gefasschirurgie','jornal vascular brasileiro','monaldi archives for chest disease','archives of clinical infectious diseases','turkish journal of thoracic and cardiovascular surgery','journal of tehran university heart center','cor et vasa','phlebologie','ijc heart and vessels','archivos de cardiologia de mexico','european heart journal, supplement','acta cardiologica sinica','applied cardiopulmonary pathophysiology','vnitrni lekarstvi','british journal of cardiology','reviews in vascular medicine','revista espanola de cardiologia suplementos','interventional cardiology (london)','vascular disease management','heart asia','revista brasileira de cardiologia invasiva','der kardiologe','interventional cardiology','journal of cardiovascular echography','chinese journal of cardiology','primary care cardiovascular journal','cardiovascular therapy and prevention (russian federation)','kardiologiya','russian journal of cardiology','angiologia','cardiology letters','cardiology (pakistan)','journal of atrial fibrillation','journal of cardiology cases','cirugia cardiovascular','egyptian heart journal','journal für kardiologie','kardiochirurgia i torakochirurgia polska','hipertension y riesgo vascular','clinical and experimental medical letters','revista colombiana de cardiologia','revista mexicana de cardiologia','revista mexicana de angiologia','zeitschrift für gefassmedizin','medecine des maladies metaboliques','revista argentina de cardiologia','acta angiologica','european cardiology','zeitschrift für herz-, thorax- und gefasschirurgie','insuficiencia cardiaca','kardiologicka revue','revista de la federacion argentina de cardiologia','open hypertension journal','dialogues in cardiovascular medicine','ejves extra','research journal of cardiology','cardiocore','chinese journal of cerebrovascular diseases','intervencni a akutni kardiologie','polski przeglad kardiologiczny','turk serebrovaskuler hastaliklar dergisi','angeiologie','heart and metabolism','indian journal of thoracic and cardiovascular surgery','iranian heart journal','journal of the hong kong college of cardiology','nadcisnienie tetnicze','revista latinoamericana de hipertension','thoracic and cardiovascular surgeon, supplement','archives of cardiovascular diseases supplements','italian journal of vascular and endovascular surgery','journal for vascular ultrasound','journal phlebology and lymphology','kardiotechnik','turkiye klinikleri cardiovascular sciences','vasomed','archives des maladies du coeur et des vaisseaux - pratique','respiration and circulation','revista mexicana de enfermeria cardiologica','cardiology and therapy','cardiovascular endocrinology','cerebrovascular diseases extra','clinical trials and regulatory science in cardiology','ejves short reports','global cardiology science and practice','heartrhythm case reports','interventional neurology','jacc: clinical electrophysiology','journal of stroke','journal of vascular surgery cases','open heart','world journal of cardiology')
)
)


select client_id,
count(distinct(a.web_user_id)) as users

from mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 a
left join mendeley.profiles b
on a.web_user_id=b.web_user_id
left join mendeley.active_users_by_client_by_event_per_day c
on b.uu_profile_id=c.profile_id
where date_trunc('month',index_ts)='2018-01-01'
group by 1
order by 2 desc

select count(*) from mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 

select * from mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 
select web_user_id from mendeley.profiles limit 1000



14159940
11164808
mendeley.ros_social_feed_events


select client_id,
count(distinct(a.web_user_id)) as users

from mendeley.sh_temp_cadiologists_article_on_sd_viewers_jan18 a
left join mendeley.profiles b
on cast(a.web_user_id as integer)=b.web_user_id
left join mendeley.active_users_by_client_by_event_per_day c
on b.uu_profile_id=c.profile_id
where date_trunc('month',index_ts)='2018-01-01'
group by 1
order by 2 desc



select  count(distinct(visitor_id)) from mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18
select * from  mendeley.sv_aa_datafeed_sd limit 10
mcvisid, 

---checking if sd article rec email clickers 

select *

from mendeley.sv_aa_datafeed_sd a
left join scopus.dim_document b
on substring(a.post_page_url,position('pii/' in a.post_page_url)+4 ,len(a.post_page_url)-position('pii/' in a.post_page_url)+4)=b.document_pii
inner join mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18 c
on a.mcvisid=replace(c.visitor_id,'_','')
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-02-01' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 
and position('pii/' in post_page_url)>0
and (document_issn in ('00097322','0195668X','00097330','19368798','22131779','19417640','00392499','13889842','1936878X','10795642','03009572','00123692','00028703','17595002','0271678X','03008428','00086363','19413149','08947317','15475271','13556037','00222828','09579672','20479980','00225223','10995129','02636352','07415214','00029149','20472404','1774024X','07351097','19332874','15266028','10453873','00330620','03636135','00219150','14752840','10159770','13469843','18610684','10785884','13824147','20474873','10107940','19375387','09394753','01675273','10719164','00034975','19345925','20488726','11282460','01462806','09169636','15221946','0828282X','10739688','10501738','18684483','01609289','21638306','17555914','15675688','10510443','14791641','10181172','00283940','09203206','15233804','20900163','10742484','18752136','10929126','19331711','00262862','10713581','14712261','15517136','02684705','00946176','15396851','10615377','09145087','11766344','13403478','01602446','02683555','15469530','20900597','1383875X','15246175','10548807','01741551','19327501','20902824','11753277','00086312','15695794','15701611','1573403X','10523057','16643828','08964327','09295305','15307905','22118160','15699293','08037051','01720643','07338651','00219509','15233782','1871529X','09546928','14745151','09108327','1358863X','1747079X','17385997','13860291','01478389','14347229','10430679','11787104','14767120','10530770','17498090','14779072','13492365','1535282X','14796678','00033197','07422822','17442648','08905096','13053825','15538389','08860440','09668519','14204096','10928464','08957967','15685888','14439506','17482941','2213333X','1082720X','18636705','01479563','17539447','03008932','07399529','19739621','15306550','01716425','00220736','16715411','10892516','10892532','13595237','18975593','09742069','15748901','15385744','18684300','11795468','11209879')
OR lower(document_full_title) in ('circulation','european heart journal','circulation research','jacc: cardiovascular interventions','jacc: heart failure','circulation: cardiovascular interventions','stroke','european journal of heart failure','jacc: cardiovascular imaging','arteriosclerosis, thrombosis, and vascular biology','resuscitation','chest','american heart journal','nature reviews cardiology','journal of cerebral blood flow and metabolism','basic research in cardiology','cardiovascular research','circulation: arrhythmia and electrophysiology','journal of the american society of echocardiography','heart rhythm','heart','journal of molecular and cellular cardiology','current opinion in lipidology','journal of the american heart association','journal of thoracic and cardiovascular surgery','europace','journal of hypertension','journal of vascular surgery','american journal of cardiology','european heart journal cardiovascular imaging','eurointervention','journal of the american college of cardiology','journal of clinical lipidology','journal of endovascular therapy','journal of cardiovascular electrophysiology','progress in cardiovascular diseases','american journal of physiology - heart and circulatory physiology','atherosclerosis','cardiovascular diabetology','cerebrovascular diseases','circulation journal','clinical research in cardiology','european journal of vascular and endovascular surgery','heart failure reviews','european journal of preventive cardiology','european journal of cardio-thoracic surgery','journal of cardiovascular translational research','nutrition, metabolism and cardiovascular diseases','international journal of cardiology','journal of cardiac failure','annals of thoracic surgery','journal of cardiovascular computed tomography','european heart journal: acute cardiovascular care','acta myologica','current problems in cardiology','hypertension research','catheterization and cardiovascular interventions','canadian journal of cardiology','microcirculation','trends in cardiovascular medicine','translational stroke research','clinical cardiology','cpt: pharmacometrics and systems pharmacology','cardiovascular therapeutics','atherosclerosis supplements','journal of vascular and interventional radiology','diabetes and vascular disease research','journal of vascular research','neuroradiology','cardiovascular drugs and therapy','current atherosclerosis reports','cardiovascular psychiatry and neurology','journal of cardiovascular pharmacology and therapeutics','archives of cardiovascular diseases','pediatric cardiac surgery annual','journal of the american society of hypertension','microvascular research','journal of nuclear cardiology','bmc cardiovascular disorders','heart failure clinics','current opinion in cardiology','seminars in thrombosis and hemostasis','lymphatic research and biology','cardiology in review','journal of cardiology','vascular health and risk management','journal of atherosclerosis and thrombosis','journal of cardiovascular pharmacology','phlebology','current heart failure reports','cardiology research and practice','journal of interventional cardiac electrophysiology','journal of clinical hypertension','cardiovascular pathology','cardiovascular and interventional radiology','journal of cardiopulmonary rehabilitation and prevention','international journal of vascular medicine','american journal of cardiovascular drugs','cardiology','international journal of cardiovascular imaging','current vascular pharmacology','current cardiology reviews','journal of stroke and cerebrovascular diseases','cardiorenal medicine','journal of interventional cardiology','journal of thrombosis and thrombolysis','cardiovascular toxicology','global heart','interactive cardiovascular and thoracic surgery','blood pressure','pediatric cardiology','cardiology clinics','journal of cardiovascular surgery','current cardiology reports','cardiovascular and hematological disorders - drug targets','coronary artery disease','european journal of cardiovascular nursing','heart and vessels','vascular medicine','congenital heart disease','electrolyte and blood pressure','clinical hemorheology and microcirculation','pace - pacing and clinical electrophysiology','journal of artificial organs','seminars in thoracic and cardiovascular surgery','integrated blood pressure control','cardiovascular ultrasound','journal of cardiothoracic and vascular anesthesia','journal of cardiothoracic surgery','expert review of cardiovascular therapy','international heart journal','critical pathways in cardiology','future cardiology','angiology','echocardiography','evidence and policy','annals of vascular surgery','diagnostic and interventional radiology','cardiovascular revascularization medicine','journal of cardiac surgery','journal of heart valve disease','kidney and blood pressure research','current treatment options in cardiovascular medicine','seminars in vascular surgery','netherlands heart journal','heart lung and circulation','acute cardiac care','journal of vascular surgery: venous and lymphatic disorders','annals of noninvasive electrocardiology','general thoracic and cardiovascular surgery','heart and lung: journal of acute and critical care','therapeutic advances in cardiovascular disease','revista espanola de cardiologia','seminars in interventional radiology','hot topics in cardiology','reviews in cardiovascular medicine','thoracic and cardiovascular surgeon','journal of electrocardiology','journal of geriatric cardiology','techniques in vascular and interventional radiology','seminars in cardiothoracic and vascular anesthesia','blood pressure monitoring','cardiology journal','annals of pediatric cardiology','recent patents on cardiovascular drug discovery','vascular and endovascular surgery','cardiovascular intervention and therapeutics','clinical medicine insights: cardiology','high blood pressure and cardiovascular prevention','american journal of cardiovascular disease','cardiovascular engineering and technology','vasa - journal of vascular diseases','cardiovascular journal of africa','annals of cardiac anaesthesia','minerva cardioangiologica','innovations: technology and techniques in cardiothoracic and vascular surgery','interventional neuroradiology','annals of thoracic medicine','world journal for pediatric and congenital hearth surgery','vascular','korean circulation journal','international angiology','arya atherosclerosis','perfusion','journal of cardiovascular disease research','annals of thoracic and cardiovascular surgery','texas heart institute journal','arquivos brasileiros de cardiologia','artery research','heart international','open cardiovascular medicine journal','journal of cardiovascular ultrasound','korean journal of thoracic and cardiovascular surgery','kardiologia polska','cardiology in the young','journal of cardiovascular medicine','indian pacing and electrophysiology journal','acta cardiologica','international cardiovascular research journal','journal of the saudi heart association','indian heart journal','revista portuguesa de cardiologia','herzschrittmachertherapie und elektrophysiologie','progress in pediatric cardiology','herz','operative techniques in thoracic and cardiovascular surgery','interventional cardiology clinics','journal of extra-corporeal technology','acta phlebologica','clinical medicine insights: circulatory, respiratory and pulmonary medicine','turk kardiyoloji dernegi arsivi','ijc heart and vasculature','journal des maladies vasculaires','cardiac electrophysiology clinics','ijc metabolic and endocrine','postepy w kardiologii interwencyjnej','journal of arrhythmia','international journal of angiology','phlebolymphology','world heart journal','clinica e investigacion en arteriosclerosis','giornale italiano di cardiologia','phlebologie','annales de cardiologie et dangeiologie','gefasschirurgie','jornal vascular brasileiro','monaldi archives for chest disease','archives of clinical infectious diseases','turkish journal of thoracic and cardiovascular surgery','journal of tehran university heart center','cor et vasa','phlebologie','ijc heart and vessels','archivos de cardiologia de mexico','european heart journal, supplement','acta cardiologica sinica','applied cardiopulmonary pathophysiology','vnitrni lekarstvi','british journal of cardiology','reviews in vascular medicine','revista espanola de cardiologia suplementos','interventional cardiology (london)','vascular disease management','heart asia','revista brasileira de cardiologia invasiva','der kardiologe','interventional cardiology','journal of cardiovascular echography','chinese journal of cardiology','primary care cardiovascular journal','cardiovascular therapy and prevention (russian federation)','kardiologiya','russian journal of cardiology','angiologia','cardiology letters','cardiology (pakistan)','journal of atrial fibrillation','journal of cardiology cases','cirugia cardiovascular','egyptian heart journal','journal für kardiologie','kardiochirurgia i torakochirurgia polska','hipertension y riesgo vascular','clinical and experimental medical letters','revista colombiana de cardiologia','revista mexicana de cardiologia','revista mexicana de angiologia','zeitschrift für gefassmedizin','medecine des maladies metaboliques','revista argentina de cardiologia','acta angiologica','european cardiology','zeitschrift für herz-, thorax- und gefasschirurgie','insuficiencia cardiaca','kardiologicka revue','revista de la federacion argentina de cardiologia','open hypertension journal','dialogues in cardiovascular medicine','ejves extra','research journal of cardiology','cardiocore','chinese journal of cerebrovascular diseases','intervencni a akutni kardiologie','polski przeglad kardiologiczny','turk serebrovaskuler hastaliklar dergisi','angeiologie','heart and metabolism','indian journal of thoracic and cardiovascular surgery','iranian heart journal','journal of the hong kong college of cardiology','nadcisnienie tetnicze','revista latinoamericana de hipertension','thoracic and cardiovascular surgeon, supplement','archives of cardiovascular diseases supplements','italian journal of vascular and endovascular surgery','journal for vascular ultrasound','journal phlebology and lymphology','kardiotechnik','turkiye klinikleri cardiovascular sciences','vasomed','archives des maladies du coeur et des vaisseaux - pratique','respiration and circulation','revista mexicana de enfermeria cardiologica','cardiology and therapy','cardiovascular endocrinology','cerebrovascular diseases extra','clinical trials and regulatory science in cardiology','ejves short reports','global cardiology science and practice','heartrhythm case reports','interventional neurology','jacc: clinical electrophysiology','journal of stroke','journal of vascular surgery cases','open heart','world journal of cardiology')
)
limit 100

--need linking too work


select * from  mendeley.sh_temp_sd_rec_article_email_subscribers_up_to_060418 limit 10;



select *

from mendeley.sv_aa_datafeed_sd a
inner join mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18 c
on trim(a.mcvisid)=trim(replace(c.visitor_id,'_',''))
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
and web_user_id>0 and post_pagename='sd:product:journal:article' 

limit 100


select * from mendeley.sv_aa_datafeed_sd limit 100
'20417917049732455773934523036260815701'
select * from  mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18  limit 10;
'1001504257446658043_2305618107558675467'



select * from mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18 
where visitor_id='1001504257446658043_2305618107558675467'

select * from mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18 
where trim(replace(visitor_id,'_',''))='10015042574466580432305618107558675467'

select * from mendeley.sv_aa_datafeed_sd
where mcvisid='10015042574466580432305618107558675467'


select *

from mendeley.sv_aa_datafeed_sd a
inner join mendeley.sh_temp_visitor_id_sd_email_clickers_oct17_mar18 c
on trim(a.mcvisid)=trim(replace(c.visitor_id,'_',''))
where post_cust_hit_time_gmt>='2018-01-01' and post_cust_hit_time_gmt<'2018-01-02' 
limit 100

