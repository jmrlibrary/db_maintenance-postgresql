-- used 12/12/2019

select 'billed suppress', string_agg( '"i' || IV.record_num || '"', ', ')
 from sierra_view.item_view iV
 left join sierra_view.checkout C
  on IV.id = C.item_record_id

  where c.overdue_gmt <= now() - interval '1 year'
  and IV.item_status_code = 'n'
  and IV.icode2 != 'n'
  and IV.itype_code_num not in (100)


  union 
  select 'billed unsuppress', string_agg( '"i' || IV.record_num || '"', ', ')
 from sierra_view.item_view iV
 left join sierra_view.checkout C
  on IV.id = C.item_record_id

  where c.overdue_gmt > now() - interval '1 year'
  and IV.item_status_code = 'n'
  and IV.icode2 = 'n'
  -- don't include ILLs
  and IV.itype_code_num not in (100);