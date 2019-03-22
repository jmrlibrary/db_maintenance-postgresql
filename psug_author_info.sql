SELECT 
  substring(bib_record_property.best_title, 1,26),
  -- bib_record_property.best_author_norm, 
  item_view.last_year_to_date_checkout_total, 
  item_view.year_to_date_checkout_total, 
  item_view.checkout_total,
    SUBSTRING(item_view.location_code,1,1),
ITEM_VIEW.RECORD_CREATION_DATE_GMT
FROM 
  sierra_view.bib_record_item_record_link, 
  sierra_view.item_view, 
  sierra_view.bib_record_property
WHERE 
  bib_record_item_record_link.item_record_id = item_view.id AND
  bib_record_item_record_link.bib_record_id = bib_record_property.bib_record_id AND
    bib_record_property.best_author LIKE 'Roby, Kimberla Lawson.' AND
        bib_record_property.material_code = 'a'

    ORDER BY 1, 5, 6;
