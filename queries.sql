with tab as (
select
*,
case when age >=16 and age <=25 then '16-25'
     when age >=26 and age <=40 then '26-40'
     when age > 40 then '40+'
end as age_category
from customers
)
select 
age_category,
count(customer_id) as age_count
from tab
group by age_category
order by age_category;
-- категории клиентов

select
to_char(sale_date, 'YYYY-MM') as selling_month,
count(distinct customer_id) as total_customers,
floor(sum(products.price*sales.quantity)) as income
from sales
left join products on sales.product_id = products.product_id 
group by to_char(sale_date, 'YYYY-MM')
order by selling_month;
--количество покупателей и выручка по месяцам

with tab as (
select
c.customer_id,
concat(c.first_name, ' ', c.last_name) as customer,
s.sale_date,
concat(e.first_name, ' ', e.last_name) as seller,
p.name as name,
p.price as price,
row_number () over (partition by concat(c.first_name, c.last_name) order by sale_date) as rn
from sales s
left join customers c on s.customer_id = c.customer_id
left join employees e on s.sales_person_id = e.employee_id
left join products p on s.product_id  = p.product_id
order by sale_date
)
select 
customer, sale_date, seller
from tab
where price = 0 and rn = 1
order by customer_id;
--покупатели, первая покупка которых была в ходе проведения акций