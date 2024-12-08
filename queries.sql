-- customers_count
select count(customer_id) as customers_count
from customers;

-- top 10 total income
select employees.first_name || ' ' || employees.last_name as seller, count(*) as operations, floor(sum(sales.quantity * products.price)) as income
from sales 
  inner join employees on sales.sales_person_id = employees.employee_id  
  inner join products  on sales.product_id      = products.product_id 
group by employees.first_name || ' ' || employees.last_name
order by income desc limit 10; 

-- lowest average income
select employees.first_name || ' ' || employees.last_name as seller, floor(avg(sales.quantity * products.price)) as average_income
from sales 
  inner join employees on sales.sales_person_id = employees.employee_id  
  inner join products  on sales.product_id      = products.product_id 
group by employees.first_name || ' ' || employees.last_name
having avg(sales.quantity * products.price) < 
(select avg(sales.quantity * products.price) as avg_income
from sales 
  inner join products on sales.product_id = products.product_id)
order by avg(sales.quantity * products.price);  

-- day of the week income
select employees.first_name || ' ' || employees.last_name as seller, trim(both to_char(sales.sale_date, 'day')) as day_of_week, floor(sum(sales.quantity * products.price)) as income
from sales 
  inner join employees on sales.sales_person_id = employees.employee_id  
  inner join products  on sales.product_id      = products.product_id 
group by employees.first_name, employees.last_name, sales.sale_date
order by extract(isodow from sales.sale_date), employees.first_name || ' ' || employees.last_name; 