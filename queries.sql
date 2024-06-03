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