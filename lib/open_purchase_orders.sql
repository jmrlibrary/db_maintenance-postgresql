select OV.order_date_gmt::date as "orderdate",
concat('o', OV.record_num, 'a') as "orecnum",
OV.order_status_code as "ostatuscode",
OV.received_date_gmt::date as "oreceiveddate",
OV.vendor_record_code as "vendor",
OV.ocode3 as "ocode3",
FM.code as fund,
BRP.best_title as "title",
BRP.best_author as "author"


from sierra_view.bib_record_order_record_link BRORL

join sierra_view.order_view OV
on BRORL.order_record_id = OV.id

join sierra_view.bib_record_property BRP
on BRORL.bib_record_id = BRP.bib_record_id

join sierra_view.order_record_cmf CMF
on OV.id = CMF.order_record_id
and CMF.display_order = 0

join sierra_view.fund_master FM
on CMF.fund_code::int = FM.code_num

where 
ov.order_status_code != 'z'
and (
ov.order_status_code = 'o'
or
OV.received_date_gmt is null
)
and
OV.record_creation_date_gmt < now() - (90 || ' days')::interval

order by OV.vendor_record_code, OV.order_date_gmt;