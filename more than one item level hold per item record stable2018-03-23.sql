-- Moved into node-js-database-tutorial vscode project --


SELECT 
concat('i', item_view.record_num, 'a') as "recnum",
count (item_view.record_num) as "holds",
  max(bib_record.bcode2) as "bcode2"
FROM 
  sierra_view.hold, 
  sierra_view.item_view, 
  sierra_view.bib_record_item_record_link, 
  sierra_view.bib_record,
  sierra_view.patron_record
WHERE 
  hold.record_id = item_view.id AND
  bib_record_item_record_link.item_record_id = item_view.id AND
  bib_record_item_record_link.bib_record_id = bib_record.id AND
  bib_record.bcode2 not in ('k') AND
  hold.patron_record_id = patron_record.record_id AND
  patron_record.ptype_code not in (18)

group by 
item_view.record_num

having 
count (item_view.record_num) > 1

order by
count (item_view.record_num) desc
;
