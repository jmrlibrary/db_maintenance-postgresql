
SELECT 
  PV.record_num,
  PV.home_library_code,
  PV.barcode,
  PV.ptype_code,
--  PRF.prefix,
 -- PRF.first_name,
--  PRF.middle_name,
 -- PRF.last_name,
  VF.varfield_type_code,
  VF.field_content
  
FROM 

  sierra_view.patron_view PV 

   join sierra_view.patron_record_fullname PRF
  on PRF.patron_record_id = PV.id

	 join sierra_view.varfield VF
	on VF.record_id = PV.id

  where 
  PV.record_num in (21743005730379, 21743005730346,1275204, 1275058)
  or

(VF.varfield_type_code = 'z' and field_content in ('4myjoseph', '21743005730379', '21743005730346','1275204', '1275058'))
  or
  
  -- alternate id
(VF.varfield_type_code = 's' and field_content in ('4myjoseph', '21743005730379', '21743005730346','1275204', '1275058'))
    or

(VF.varfield_type_code = 'b' and field_content in ('4myjoseph', '21743005730379', '21743005730346','1275204', '1275058'))

order by 1
;