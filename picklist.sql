SELECT 
--  h.record_id,  
 --   item_record.id, 
  --  item_view.id,
 -- h.patron_record_id, 

 vv.field_content as "callnum",
  item_view.barcode, 
  concat (item_view.record_type_code, item_view.record_num, 'a') as "_oId"
  , 
  item_view.location_code as "loc", 
  h.placed_gmt, 
  -- I don't know what this shows
  -- item_view.is_bib_hold, 

  -- these are the same
  --item_view.icode2 as "itemSuppressed", -- shows item suppression
  -- I'm not sure if we need this -- since i think it will reject a hold attempt
--    item_record.is_suppressed,

-- oh, this might do all the filtering for me :
-- covers : IN TRANSIT, ON HOLD SHELF, ...
-- so I can filter by it, but don't need to include it
  --item_record.is_available_at_library, 

  -- filter by this; don't need to display it ??
  -- item_view.item_status_code,
  
  item_view.last_checkin_gmt,

  -- these match
  --irl.bib_record_id,
  --brp.bib_record_id,
  
 -- this is a dumb tiny integer -- the BRP table columns are indexed themselves
 --  brp.id

 brp.best_author as "author",
 brp.best_title as "title",

 bib_record.id AS "iii_bid"

FROM 
  sierra_view.hold h, 
  sierra_view.item_view, 
  sierra_view.item_record ir,
  -- sierra_view.bib_record_item_record_link irl,
  -- sierra_view.bib_record_property brp
  sierra_view.varfield_view vv
  join 
  sierra_view.bib_record_item_record_link irl
on ir.record_id = irl.item_record_id

join sierra_view.bib_record_property brp
on irl.bib_record_id = brp.bib_record_id
  
WHERE 
  item_view.id = h.record_id AND
  item_view.id = item_record.record_id
  and item_record.is_available_at_library = 't'
 -- and item_record.record_id = irl.item_record_id
 and   item_view.item_status_code = '-'
 and     item_record.is_suppressed = 'f'
 AND "iii_bid" = vv.record_id
 AND vv.marc_tag in ('092', '082')

  AND SUBSTR(item_view.location_code,1,1) = 'r'

 order by 
  "loc"
  ;
