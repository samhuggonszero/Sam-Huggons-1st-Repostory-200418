select * from mendeley.tmp_gdpr_event_properties


select * from mendeley.tmp_gdpr_event_properties a
inner join mendeley.usage_events b
on a.event_name=b.event_name
where b.client_id in (808,7,1127,2054,2066,2364,3181,3518)



