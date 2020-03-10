 select 
    -- HOLDS.ID,
    max(concat (ITEMVIEW.record_type_code, ITEMVIEW.record_num, 'a')) as "iRecnum",

    trim (
      REGEXP_REPLACE ( 
      max (IRECPROP.call_number) , '\|\w', ' ', 'g'
      )  )  as "callnum",

    max(ITEMVIEW.barcode) as "barcode",
    max(ITEMVIEW.location_code) as "loc",
 --   max(ITEMVIEW.item_status_code) as iStatusCode,
    max(BRECPROP.best_author) as "author",
    max(BRECPROP.best_title) as "title",
    min (HOLDS.placed_gmt) as "placed",
    max (ITEMVIEW.last_checkout_gmt) as "lastCheckout"
 --   , max (CIRC.due_date_gmt) as "duedate"
 
  FROM 
  
  sierra_view.hold HOLDS
  
  join sierra_view.item_view ITEMVIEW
  on HOLDS.record_id = ITEMVIEW.id
  
  join sierra_view.bib_record_item_record_link BIBITEMLINK
  on ITEMVIEW.id = BIBITEMLINK.item_record_id
  
  join sierra_view.bib_record_property BRECPROP
  on BIBITEMLINK.bib_record_id = BRECPROP.bib_record_id

  join sierra_view.item_record_property IRECPROP
  on BIBITEMLINK.item_record_id = IRECPROP.item_record_id
  
	join sierra_view.circ_trans CIRC
	on BIBITEMLINK.item_record_id = CIRC.item_record_id
	

  where
   ITEMVIEW.item_status_code = '-'
  AND ITEMVIEW.is_suppressed = 'f'
  and CIRC.due_date_gmt = '1969-12-31 19:00:00-05'
  
  group by 
  ITEMVIEW.id

 order by 7 asc

  ;