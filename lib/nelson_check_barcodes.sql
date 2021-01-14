-- in marcedit
-- use "export tab delimited file" on main menu hud
-- choose ftp file as in
-- name .txt as out
-- excel and change " to ' and add comma and paren
-- ="('" & B1 & "'), "



drop table if exists all_ftp_barcodes;
create temp table all_ftp_barcodes ( barcode varchar);


with a as (

insert into all_ftp_barcodes 
values

('31743309583712'), 
('31743309584082'), 
('31743309584165'), 
('31743309584215'), 
('31743309584272'), 
('31743309584280'), 
('31743309584298'), 
('31743309583589'), 
('31743309583514'), 
('31743309583761'), 
('31743309583852'), 
('31743309583860'), 
('31743309583886'), 
('31743309583977'), 
('31743309584108'), 
('31743309584116'), 
('31743309584199'), 
('31743309584249')

returning *
)

select * 
from a 

left join  sierra_view.item_record_property i

on i.barcode = a.barcode

where id is null;

