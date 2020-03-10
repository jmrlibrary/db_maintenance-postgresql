-- select * from sierra_view.item_view where icode1 between 46 and 54;

select count(*),substring(location_code, 1, 1)

  from sierra_view.item_view 
  where icode1 between 46 and 53

  group by substring(location_code, 1, 1);

;