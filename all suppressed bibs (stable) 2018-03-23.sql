SELECT 
  concat ('b', bib_view.record_num, 'a')
FROM 
  sierra_view.bib_view

  where 
  bib_view.bcode3 = 'n'
  ;
