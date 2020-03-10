with bib_avail_item_count as (
  select
    BV.id,

(select id from sierra_view.varfield_view where varfield_view.record_id = BV.id and marc_tag = '049' and field_content ilike '%|aPDV%' limit 1 ) 
     as pdv,
     (select id from sierra_view.varfield_view where varfield_view.record_id = BV.id and marc_tag in ('500', '530') and field_content ilike '%Minimal Record%' limit 1 ) 
     as on_order_minimal_record,

string_agg( orderview.vendor_record_code, ', ') as vendors,
     
    SUM (
      case
        when ITEMVIEW.item_status_code in ('-', 't', '!')
        and ITEMVIEW.icode2 != 'n'
        and ITEMVIEW.itype_code_num not in (100, /* non-circulating (1) : we should be agnostic on suppressing non-circulating things */  99, 76, 70, 78, 77, 40) then 1
        else 0 
      end
    ) as item_avail_count,
    count(ORDERVIEW.id) as order_count,
    /*
    sum (
case when ORDERVIEW.record_creation_date_gmt > now() - interval '1 year' then 1 else 0 end


) as order_live_count,
*/
min ( 
date_part('day', now() - ORDERVIEW.record_creation_date_gmt) )::int

as min_days_since_order_created
  from
    sierra_view.bib_view BV
    /* 
                        link to item records 
                        */
    left join sierra_view.bib_record_item_record_link BILINK on BILINK.BIB_RECORD_ID = BV.ID
    LEFT join sierra_view.item_view ITEMVIEW on bilink.item_record_id = ITEMVIEW.id
    /* 
                        link to order records 
                        */
    left join sierra_view.bib_record_order_record_link BOLINK on BOLINK.BIB_RECORD_ID = BV.id
    left join sierra_view.order_view orderview on BOLINK.order_record_id = orderview.id
  where
    /*
           only look at books, cds (music and audio), undesignated, 
           large print, bluray, dvd
            at mat type 
            */
     bv.bcode2 in ('a', 'z', '-', 'l', 'b', 'd', 'j')
    /*
                we only care about bibs that are suppressed, for this purpose, 
                because we want to unsuppress them
                */
                  /*
can fine-tune / invert the results based on this : 
  */
    and bv.bcode3 != 'n'
    /*
    make sure we don't delete anything the catalogers might
    have just imported
    */
    and bv.record_creation_date_gmt <= now() - interval '1 month'
    and orderview.order_status_code not in ('z')
  GROUP BY
    1
)
select
'b' || BIBVIEW.record_num || 'a' as brecnum,
title,
cataloging_date_gmt as cat_date,
date_part('day', now() - cataloging_date_gmt) ::int

as days_since_cataloged,

  *
from
  bib_avail_item_count BAIC,
  sierra_view.bib_view BIBVIEW
WHERE
  BIBVIEW.ID = BAIC.ID
  /*
can fine-tune / invert the results based on this : 
  */
  and item_avail_count = 0
--  and order_live_count = 0
  --and min_days_since_order_created > 450

  and on_order_minimal_record is null
  and pdv is not null

order by min_days_since_order_created;
