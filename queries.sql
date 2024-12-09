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

-- age groups
select case when age between 16 and 25 then '16-25' when age between 26 and 40 then '26-40' when age > 40 then '40+' end age_category, count(*) as age_count
from customers
group by case when age between 16 and 25 then '16-25' when age between 26 and 40 then '26-40' when age > 40 then '40+' end
order by 1;

-- customers by month
select extract(year from sales.sale_date) || '-' || right('00' || extract(month from sales.sale_date), 2) as selling_month, count(distinct sales.customer_id) as total_customers, 
       floor(sum(sales.quantity * products.price)) as income 
from sales
  inner join products on sales.product_id = products.product_id
group by extract(year from sales.sale_date) || '-' || right('00' || extract(month from sales.sale_date), 2)
order by 1;

-- special offer
select customers.first_name || ' ' || customers.last_name as customer, x1.sale_date, employees.first_name || ' ' || employees.last_name as seller 
from
(select sales.sales_person_id, sales.customer_id, sales.sale_date, products.price, row_number( ) over(partition by sales.customer_id order by sales.sale_date, sales.sales_id) as num
from sales
  inner join products on sales.product_id = products.product_id) x1
  inner join customers on x1.customer_id = customers.customer_id 
  inner join employees on x1.sales_person_id = employees.employee_id 
where x1.price = 0 
  and x1.num   = 1;