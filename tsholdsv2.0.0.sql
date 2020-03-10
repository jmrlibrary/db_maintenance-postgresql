with cte_bibcode3 as (
  select
    bibview.bcode3 as bcode3,
    bibview.id as brecid,
    concat('b', BIBVIEW.record_num, 'a') as brecnum,
    min (holds.placed_gmt) as "hold_date",
    count(distinct HOLDS.id) as "hold_count"
  from
    sierra_view.hold HOLDS,
    sierra_view.bib_view BIBVIEW
  where
    HOLDS.record_id = BIBVIEW.id
    and bibview.bcode3 = '-'
  group by
    bibview.id,
    bibview.bcode3,
    bibview.record_num
),
no_items as (
  select
    cte_bibcode3.*
  from
    cte_bibcode3
    left join sierra_view.bib_record_item_record_link BIBITEMLINK on cte_bibcode3.brecid = BIBITEMLINK.bib_record_id
  where
    BIBITEMLINK.bib_record_id IS NULL
),
title_author as (
  select
    no_items.*,
    BIBRECPROP.best_title as "title",
    BIBRECPROP.best_author as "author"
  from
    no_items,
    sierra_view.bib_record_property BIBRECPROP
  where
    no_items.brecid = BIBRECPROP.bib_record_id
),
cte_callnum as (
  select
    STRING_AGG(field_content, ' ') as callnum,
    record_id as brecid
  from
    sierra_view.varfield_view varfieldview,
    title_author
  where
    varfieldview.marc_tag in ('092', '082')
    and varfieldview.record_id = title_author.brecid
  group by
    varfieldview.record_id
),
cte_orders as (
  select
    cte_callnum.brecid as brecid,
    BIBORDERLINK.order_record_id as orecid,
    sierra_view.id2reckey(BIBORDERLINK.order_record_id) || 'a' as orecnum
  from
    sierra_view.bib_record_order_record_link BIBORDERLINK,
    cte_callnum
  where
    cte_callnum.brecid = BIBORDERLINK.bib_record_id
),
cte_orderinfo as (
  select
  
    cte_orders.orecid,
    cte_orders.brecid,
    ORDERREC.form_code as o_form_code,
    ORDERREC.received_date_gmt AS o_rdate,
    ORDERCMF.copies as o_copies
  from
    sierra_view.order_record ORDERREC,
    cte_orders,
    sierra_view.order_record_cmf ORDERCMF
  where
    orderrec.id = cte_orders.orecid
    and ORDERCMF.order_record_id = cte_orders.orecid
    and ORDERREC.received_date_gmt is not null


),
with_json as (

 select array_to_json(array_agg(row_to_json(cte_orderinfo.*))), 
 cte_orderinfo.brecid as brecid
    from cte_orderinfo

    group by cte_orderinfo.brecid
)
select
  *
from
  with_json, title_author, cte_callnum
  where with_json.brecid = title_author.brecid
  and title_author.brecid = cte_callnum.brecid;




--SELECT cte_callnum.callnum, title_author.* FROM cte_callnum, title_author where title_author.brecid = cte_callnum.brecid;



