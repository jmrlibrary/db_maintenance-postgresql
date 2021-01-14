
with iteminfo as (
SELECT 
  IRP.item_record_id as irecid,
  IRP.barcode as barcode,
  IV.item_status_code as istatuscode,
  IV.record_num as irecnum,
  IV.checkout_total as totchkout,
  IV.renewal_total as totrenew,
  IV.last_year_to_date_checkout_total as lyrcirc,
  IV.year_to_date_checkout_total as ytdcirc,
  IV.is_suppressed

FROM 
  sierra_view.item_record_property IRP,
  sierra_view.item_view IV


where
  IRP.barcode = 31743308135258::varchar
and IRP.item_record_id = IV.id

  )
  select
  iteminfo.* ,
  h.id as hrecnum,
   CK.due_gmt as iduedate,
  
  from iteminfo
  
    left join   sierra_view.hold H
  on   iteminfo.irecid = H.record_id

  left join sierra_view.checkout CK
  on iteminfo.irecid = CK.item_record_id

;