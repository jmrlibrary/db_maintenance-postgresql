with duplicate_barcodes
/**
 CTE `duplicate_barcodes` returns 
 barcodes which appear on 1 or more items
 in the catalog
 */
as (
    select i.barcode as barcode,
        array_agg(i.item_record_id) as item_record_id_array,
        count(*) as barcode_count
    from sierra_view.item_record_property i
        /**
         filter out barcode fields which are blank or null
         */
    where barcode is not null
        and barcode != ''
    group by barcode
    having count(*) > 1
),
/**
 CTE `one_bib_or_two`
 
 If used to join with CTE `c`, will only return results 
 where the duplicate barcodes are on two items which are on 
 the SAME bib. 
 
 Otherwise, `c` will return any duplicate barcodes (which can include
 items which contain the duplicate barcodes
 but the items are on different bib records).
 
 */
number_of_linked_bibs as (
    select db.barcode as barcode,
        db.barcode_count as barcode_count,
        array_agg(id2reckey(link.bib_record_id) || 'a') as bib_record_key_array,
        array_agg (br.bcode2) as mat_type_array,
        count(link.id) as bib_record_count
    from duplicate_barcodes db,
        sierra_view.bib_record_item_record_link link,
        sierra_view.bib_record br
    where link.item_record_id = any (db.item_record_id_array)
        and link.bib_record_id = br.record_id
    group by db.barcode,
        db.barcode_count
    order by bib_record_count
)
select *
from number_of_linked_bibs nolb
order by mat_type_array [1];