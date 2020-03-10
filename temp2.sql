
with orders_paid_in_chosen_fy as (

select * from sierra_view.order_record_paid ORP
where paid_date_gmt between '2018-07-30' and '2019-07-09'


),
cost_per_order as (
select order_record_id, 
-- paid_date_gmt, 
-- paid_amount, 
-- copies, 
paid_amount / copies as cost_per_copy 
from orders_paid_in_chosen_fy
),

orders as (
select * from sierra_view.order_record_cmf
where location_code != 'multi'
)

select  
orders.fund_code as fund_code, orders.location_code as location_code,
sum( orders.copies * cost_per_order.cost_per_copy) as cost

from 
orders,
cost_per_order

  where cost_per_order.order_record_id = orders.order_record_id
 group by rollup ( fund_code, location_code);




