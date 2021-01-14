
-- isn search on phrase_entry
SELECT
id2reckey(e.record_id)
FROM
sierra_view.phrase_entry as e
WHERE
e.index_tag || e.index_entry = 'i' || LOWER('9780525658351');

