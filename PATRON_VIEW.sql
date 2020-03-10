select COUNT(*) from sierra_view.patron_view PATVIEW

join sierra_view.patron_record_fullname PATNAME
on PATVIEW.ID = PATNAME.patron_record_id

--where PATVIEW.id = 481037504754
;