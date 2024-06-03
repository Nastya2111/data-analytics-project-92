--ШАГ 4
select count(customer_id) as customers_count
from customers;
--запрос, который считает общее количество покупателей из таблицы customers
--ШАГ 5
select
concat(emp.first_name, emp.last_name) as seller,
sum(sales.sales_id) as operation,
sum(sales.quantity * products.price) as income
from sales
inner join employees as emp on sales.sales_person_id = emp.employee_id
inner join products on sales.product_id = products.product_id
group by concat(emp.first_name, emp.last_name)
order by income desc
limit 10;
-- топ-10 продавцов, у которых наибольшая выручка

select
concat(emp.first_name, emp.last_name) as seller,
Floor(avg(sales.quantity * products.price)) as average_income
from sales
inner join employees as emp on sales.sales_person_id = emp.employee_id
inner join products on sales.product_id = products.product_id
group by concat(emp.first_name, emp.last_name)
having Floor(avg(sales.quantity * products.price)) < (select 
                                                      Floor(AVG(sales.quantity * products.price)) as general_avg
                                                      from sales
                                                      inner join products on sales.product_id = products.product_id);
--список продавцов, чья выручка ниже средней выручки всех продавцов
                                                     
with tab as (
select
   concat(first_name, last_name) as seller,
    to_char(sale_date, 'Day')as day_of_week,
    floor(sum(quantity*price)) as income, 
    extract(isodow from sale_date) as dow
    from employees e
    left join sales s on e.employee_id = s.sales_person_id
    left join products p on s.product_id = p.product_id
    group by to_char(sale_date, 'Day'), concat(first_name, last_name), sale_date)
 select seller, day_of_week, income
 from tab
 group by seller, day_of_week, income, dow
 order by dow, seller;
 
--суммарные продажи каждого проавца по дням недели
--ШАГ 6
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
