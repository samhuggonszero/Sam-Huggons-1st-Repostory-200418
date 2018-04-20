
select * from mendeley.groups 
where name in ('Cairo University','Mansoura University','Assiut University','Beni-Suef University','Arab Academy For Science, Technology And Maritime Transport','National Cancer Institute Cairo University','Bibliotheca Alexandrina','Nile University','Misr International University','Egyptian Atomic Energy Authority','Electronics Research Institute','Agricultural Research Center','Fayoum University','National Water Research Center','Ain Shams University','Al-Azhar University','Alexandria University','Aswan University','Banha University','British University In Egypt','Central Metallurgical Research And Development Institute','ChildrenS Cancer Hospital Egypt','City Of Scientific Research And Technological Applications','Damanhour University','Damietta University','Egyptian National Scientific And Technical Information Network','Egyptian Petroleum Research Institute','German University In Cairo','Helwan University','Kafrelsheikh University','Menoufia University','Military Technical College','Minia University','Misr University For Science And Technology','National Authority For Remote Sensing And Space Sciences','National Institute Of Oceanography And Fisheries','National Research Institute Of Astronomy And Geophysics','Port Said University','Research Institute Of Ophthalmology','Sohag University','South Valley University','Suez Canal University','Suez University','Tanta University','Theodor Bilharz Research Institute','University Of Sadat City','Zagazig University','Zewail City Of Science And Technology')


select name, count(distinct(profile_id)) as users

from mendeley.groups a
left join mendeley.group_members b
on a.id=b.group_id
where name in ('Cairo University','Mansoura University','Assiut University','Beni-Suef University','Arab Academy For Science, Technology And Maritime Transport','National Cancer Institute Cairo University','Bibliotheca Alexandrina','Nile University','Misr International University','Egyptian Atomic Energy Authority','Electronics Research Institute','Agricultural Research Center','Fayoum University','National Water Research Center','Ain Shams University','Al-Azhar University','Alexandria University','Aswan University','Banha University','British University In Egypt','Central Metallurgical Research And Development Institute','ChildrenS Cancer Hospital Egypt','City Of Scientific Research And Technological Applications','Damanhour University','Damietta University','Egyptian National Scientific And Technical Information Network','Egyptian Petroleum Research Institute','German University In Cairo','Helwan University','Kafrelsheikh University','Menoufia University','Military Technical College','Minia University','Misr University For Science And Technology','National Authority For Remote Sensing And Space Sciences','National Institute Of Oceanography And Fisheries','National Research Institute Of Astronomy And Geophysics','Port Said University','Research Institute Of Ophthalmology','Sohag University','South Valley University','Suez Canal University','Suez University','Tanta University','Theodor Bilharz Research Institute','University Of Sadat City','Zagazig University','Zewail City Of Science And Technology')
group by 1









select 
	p.uu_profile_id, 
	user_role, 
	subject_area, 
	initcap(lower(
        coalesce(
        case when e.sis_id is not null then 'Egypt' else
            case when p.country='' then 
                case when i.country is null or i.country='' then pc.country else i.country end
            else p.country end
        end, 'other')
    )) as country,
    coalesce(i.country , 'None') institution_country,
    coalesce(initcap(i.name), 'None') institution_name,
    coalesce(an.annotations, 0) annotations,
    coalesce(pd.refs, 0) document_references,
    coalesce(pd.publications, 0) publications,
    count(distinct case when members>1 and pg1.visibility='private' then group_id_free end) private_groups_1plus_free,
    count(distinct case when pg1.visibility='public' then group_id_free end) public_groups_free,
    count(distinct case when gj.visibility='private' and coalesce(i.is_mie, 0)=0 then group_id_joined end) private_groups_joined,
    count(distinct case when gj.visibility='public' and coalesce(i.is_mie, 0)=0 then group_id_joined end) public_groups_joined,
    count(distinct case when gt.visibility='private' then gt.group_id end) prv_groups_crt_jn,
    count(distinct case when gt.visibility='public' then gt.group_id end) pub_groups_crt_jn

from mendeley.profiles p
left outer join mendeley.institutions i on i.id=p.institution_id
left outer join mendeley.profile_countries pc on pc.profile_id=p.uu_profile_id
left outer join mendeley.institutions_egyptian_consortium e on e.sis_id=i.sis_id
left outer join (
	select 
		owner, 
		visibility,
		members,
		g.id as group_id,
		case 
			when joined_mie_group is null and i.contract_start_date is null then g.id
			when created<joined_mie_group or created<i.contract_start_date then g.id
			end as group_id_free
	from mendeley.groups g
	join (select group_id, count(*) members from mendeley.group_members group by 1) gm
		on gm.group_id=g.id
	left outer join (
		select profile_id, min(joined) joined_mie_group
		from mendeley.group_members gm
		join mendeley.groups g on g.id=gm.group_id and g.type='institution'
		group by 1
	) mj on mj.profile_id=g.owner
	left outer join mendeley.profiles p on p.uu_profile_id=g.owner
	left outer join mendeley.institutions i on i.id=p.institution_id and i.is_mie=1
) pg1 on pg1.owner=p.uu_profile_id
left outer join (
	select profile_id, g.visibility, gm.group_id as group_id_joined
	from mendeley.group_members gm
	join mendeley.groups g on g.id=gm.group_id
	where role<>'owner'
) gj on gj.profile_id=p.uu_profile_id
left outer join (
	select owner as profile_id, visibility, id as group_id
	from mendeley.groups
	union all
	select profile_id, visibility, gm.group_id
	from mendeley.group_members gm
	join mendeley.groups g on g.id=gm.group_id
) gt on gt.profile_id=p.uu_profile_id
left outer join mendeley.profile_annotations an on an.profile_id=p.uu_profile_id
left outer join mendeley.profile_documents pd on pd.uu_profile_id=p.uu_profile_id
where i.name in ('Cairo University','Mansoura University','Assiut University','Beni-Suef University','Arab Academy For Science, Technology And Maritime Transport','National Cancer Institute Cairo University','Bibliotheca Alexandrina','Nile University','Misr International University','Egyptian Atomic Energy Authority','Electronics Research Institute','Agricultural Research Center','Fayoum University','National Water Research Center','Ain Shams University','Al-Azhar University','Alexandria University','Aswan University','Banha University','British University In Egypt','Central Metallurgical Research And Development Institute','ChildrenS Cancer Hospital Egypt','City Of Scientific Research And Technological Applications','Damanhour University','Damietta University','Egyptian National Scientific And Technical Information Network','Egyptian Petroleum Research Institute','German University In Cairo','Helwan University','Kafrelsheikh University','Menoufia University','Military Technical College','Minia University','Misr University For Science And Technology','National Authority For Remote Sensing And Space Sciences','National Institute Of Oceanography And Fisheries','National Research Institute Of Astronomy And Geophysics','Port Said University','Research Institute Of Ophthalmology','Sohag University','South Valley University','Suez Canal University','Suez University','Tanta University','Theodor Bilharz Research Institute','University Of Sadat City','Zagazig University','Zewail City Of Science And Technology')
group by 1,2,3,4,5,6,7,8,9













select follower_id as profile_id, count(distinct(followee_id)) as followees  from mendeley.profile_followers group by 1
select followee_id as profile_id, count(distinct(follower_id)) as followers  from mendeley.profile_followers group by 1






select a.profile_id, a.name, b.followees, c.followers from (
select distinct profile_id, name

from mendeley.groups a
left join mendeley.group_members b
on a.id=b.group_id
where name in ('Cairo University','Mansoura University','Assiut University','Beni-Suef University','Arab Academy For Science, Technology And Maritime Transport','National Cancer Institute Cairo University','Bibliotheca Alexandrina','Nile University','Misr International University','Egyptian Atomic Energy Authority','Electronics Research Institute','Agricultural Research Center','Fayoum University','National Water Research Center','Ain Shams University','Al-Azhar University','Alexandria University','Aswan University','Banha University','British University In Egypt','Central Metallurgical Research And Development Institute','ChildrenS Cancer Hospital Egypt','City Of Scientific Research And Technological Applications','Damanhour University','Damietta University','Egyptian National Scientific And Technical Information Network','Egyptian Petroleum Research Institute','German University In Cairo','Helwan University','Kafrelsheikh University','Menoufia University','Military Technical College','Minia University','Misr University For Science And Technology','National Authority For Remote Sensing And Space Sciences','National Institute Of Oceanography And Fisheries','National Research Institute Of Astronomy And Geophysics','Port Said University','Research Institute Of Ophthalmology','Sohag University','South Valley University','Suez Canal University','Suez University','Tanta University','Theodor Bilharz Research Institute','University Of Sadat City','Zagazig University','Zewail City Of Science And Technology')
) a
left join (select follower_id as profile_id, count(distinct(followee_id)) as followees  from mendeley.profile_followers group by 1) b
on a.profile_id=b.profile_id
left join (select followee_id as profile_id, count(distinct(follower_id)) as followers  from mendeley.profile_followers group by 1) c
on a.profile_id=c.profile_id



select * from mendeley.groups a
 left join mendeley.group_members b
 on a.id=b.group_id
 where a.id=10735091




