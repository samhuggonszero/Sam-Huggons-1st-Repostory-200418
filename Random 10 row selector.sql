SELECT
	event_name,
	properties
FROM
(
	SELECT
		event_name,
		properties,
		row_number() over (partition by event_name order by random()) AS row
	FROM
		mendeley.live_events_latest
	WHERE
		DATE(ts) = ‘2018-02-01’
) tmp
WHERE
	tmp.row <= 10