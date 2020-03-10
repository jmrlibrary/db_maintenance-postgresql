SELECT 
  PV.record_num,
  PRF.prefix,
  PRF.first_name,
  PRF.middle_name,
  PRF.last_name,
  VF.varfield_type_code,
  VF.field_content
  
FROM 

  sierra_view.patron_view PV 

   join sierra_view.patron_record_fullname PRF
  on PRF.patron_record_id = PV.id

	 join sierra_view.varfield VF
	on VF.record_id = PV.id

  where 
  -- email
  ('zweisser@gmail.com' is null or (VF.varfield_type_code = 'z' and field_content = 'zweisser@gmail.com'))
  or
  
  -- alternate id
  ('xx' is null or (VF.varfield_type_code = 's' and field_content = 'xx'))
    or
    
    -- barcode, and barcode if they left off
  (21743005005996 is null or (VF.varfield_type_code = 'b' and (field_content = 21743005005996::varchar or field_content = concat('2174300',5005996::varchar))))
  ;