SELECT 

  --item_view.id, 
 -- item_record_property.item_record_id, 
    
  item_view.barcode, 
  item_view.icode1 as "icode1", -- the locationy thing (rotating, etc)


  -- suppressed or not :
  -- these fields always match
  item_view.icode2 as "icode2", -- enum '-' , 'n' SUPPRESSED
  item_view.is_suppressed as "iSuppressed",  -- boolean

  
  concat (  item_view.record_type_code, item_view.record_num, 'a') as "iRecnum",

  item_view.inventory_gmt as "inventoryDate", 
  item_view.last_checkout_gmt as "lchkoutDate", 
  item_view.item_status_code as "iStatusCode",
  item_status_property_myuser.name as "iStatusCodeName",
 -- the ID for the item_record_property row -- probably not a FK to anything else.
 -- item_record_property.id, 

 checkout.due_gmt as "dueDate",
 checkout.overdue_count as "overdueCount",

  item_record_property.call_number as "callNum", 
  item_record_property.call_number_norm as "callNumNorm",
  concat( item_view.itype_code_num, ' : ',itype_property_myuser.name) as "itypeCode",
  concat(item_view.location_code, ' : ', location_myuser.name) as "loc",

  bib_record_property.best_title as "title",
  bib_record_property.best_author as "author"

  
FROM 
  sierra_view.item_view

  join
  sierra_view.item_record_property
  on 
    item_view.id = item_record_property.item_record_id

   join 
  sierra_view.item_status_property_myuser
on   item_view.item_status_code = sierra_view.item_status_property_myuser.code

join 
  sierra_view.itype_property_myuser
on
  item_view.itype_code_num = itype_property_myuser.code

  JOIN 
  sierra_view.bib_record_item_record_link
  on
item_view.id = bib_record_item_record_link.item_record_id

join 
sierra_view.bib_record_property
on 
bib_record_item_record_link.bib_record_id = bib_record_property.bib_record_id

join 
sierra_view.location_myuser
on
item_view.location_code = location_myuser.code
  
left join sierra_view.checkout
on item_view.id = checkout.item_record_id
  
--WHERE 
  --  item_view.barcode = '31743308566130'

limit 150
;
