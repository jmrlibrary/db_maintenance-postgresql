SELECT 
  patron_record.notification_medium_code, 
  patron_record.record_id, 
  patron_record_fullname.first_name, 
  patron_record_fullname.middle_name, 
  patron_record_fullname.last_name
FROM 
  sierra_view.patron_record, 
  sierra_view.patron_record_fullname
WHERE 
  patron_record.record_id = patron_record_fullname.patron_record_id AND
  patron_record_fullname.first_name = 'JASON'
ORDER BY
  patron_record_fullname.last_name ASC;
