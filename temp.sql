

--select * from sierra_view.fund_property_name;

-- select * from sierra_view.external_fund_property;

--select * from sierra_view.external_fund_property_myuser;

--select * from sierra_view.external_fund_property_name;

with orders_paid_in_chosen_fy as (

select * from sierra_view.order_record_paid ORP
where paid_date_gmt between '2018-07-30' and '2019-07-09'


),
cost_per_order as (
select order_record_id, paid_date_gmt, paid_amount, copies, paid_amount / copies as cost_per_copy from orders_paid_in_chosen_fy
)

 copies_per_order as (
SELECT 
--  sierra_view.id2reckey(ORC.order_record_id) || 'a' as orecnum,
ORC.*
from sierra_view.order_record_cmf ORC

where location_code != 'multi'
)

select order_record_id, paid_date_gmt, paid_amount, copies, paid_amount / copies as cost_per_copy from orders_paid_in_chosen_fy
--where copies_per_order.order_record_id = orders_paid_in_chosen_fy.order_record_id
order by orders_paid_in_chosen_fy.paid_date_gmt;