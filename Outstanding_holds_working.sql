
-- All bibliographic records which have a 
-- bib-level hold

SELECT 
concat ('b', bib_view.record_num, 'a') AS bibrecnum,
Min (hold.placed_gmt) AS MIN_HOLD_PLACED_DATE,
hold.placed_gmt AS HOLD_PLACED_DATE,

FROM 
sierra_view.bib_view, 
sierra_view.hold

where 
hold.record_id = bib_view.id

group by  bibrecnum

ORDER BY
MIN_HOLD_PLACED_DATE;
