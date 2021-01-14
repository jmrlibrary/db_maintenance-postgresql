SELECT 
SUB.*, 
trim(regexP_REPLACE(vv.field_content, '\|\w', ' ', 'g')) as "callNum" FROM 

(

SELECT 
  max(br.id) as b_id
   ,count(distinct h.id) as "holdCount"
  ,min(h.placed_gmt) AS "holdDateMin"
  
  ,max(concat('o', ov.record_num, 'a')) as "oRecnum"
  ,max(or_t.form_code) as "oFormCode"
  ,min(or_t.received_date_gmt) AS "oRdate"
  ,max(cmf.copies) as "oCopies"

  ,max(concat('b', bv.record_num, 'a')) as "bRecnum"
  ,max (bv.bcode3) as "bcode3"
  ,max (brp.best_title) as "title"
  ,max (brp.best_author) as "author"
   
FROM 

  sierra_view.bib_view bv,
  sierra_view.hold h,
  
  sierra_view.bib_record_order_record_link orl,
  sierra_view.bib_record_property brp,
  sierra_view.order_view ov,
  sierra_view.order_record or_t,
  sierra_view.order_record_cmf cmf,

  sierra_view.bib_record br
   LEFT JOIN
	sierra_view.bib_record_item_record_link irl
	ON irl.bib_record_id = br.record_id

WHERE 

bv.bcode3 = '-' 

AND br.record_id = bv.id
  AND irl.bib_record_id IS NULL
    AND h.id IS NOT NULL
  
  AND br.record_id = orl.bib_record_id
  AND br.record_id = h.record_id
  AND orl.order_record_id = or_t.id
  AND or_t.id = ov.id
  AND ov.record_id = cmf.order_record_id
  AND bv.id = brp.bib_record_id

  AND or_t.received_date_gmt IS NOT NULL

  GROUP BY 
  br.record_id
  
  ORDER BY
  "oRdate"
  
  ) sub,
 
 sierra_view.varfield_view vv

 where 
 sub.b_id = vv.record_id
 AND vv.marc_tag in ('092', '082');