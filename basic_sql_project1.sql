create table retail_sales (
transactions_id int primary key,
sale_date DATE,
sale_time time,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
toatal_sale FLOAT

);
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or toatal_sale is null ;
drop table retail_sales;

--data exploration
--how many sales do we have?
select count(*) toatal_sale from retail_sales;

--how many customers do we have 
select count(distinct customer_id) as toatal_customers from retail_sales;

---how many categories do we have ?
select distinct category from retail_sales;

--data analysis / bussiness analysis 
--Q1 retreive all the sales that made on 2022-11-05
select * from retail_sales
where sale_date = '2022-11-05';

--retrive all the transactions where the category is clothing and the quantity sold is more than or equal to 4 in the month of 2022-11
select count(*) from retail_sales
where category = 'Clothing'
and to_char(sale_date,'yyyy-mm') = '2022-11'
and quantity >= 3;

--write a query to calculate the total sale for each category 
select category,sum(toatal_sale) from retail_sales
group by 1;

--write a query to get the total sales of clothing in month of november 2022
select sum(toatal_sale) from retail_sales
where category ='Clothing' and to_char(sale_date,'yyyy-mm')='2022-11';

--write a query to find out the avg age of customers who purchased the beauty itemms from category 
select round(avg(age), 2) as average_age from retail_sales 
where category= 'Beauty';--where round is used to round up the large decimal points to readable 

--write a query to get the all the transactions where total sale is greater than the 1000
select * from retail_sales where toatal_sale > 1000;--(select count(*) from retail_sales where toatal_sale > 1000; for count )

--write a query to get the all the transaction that made by each gender in each category
select category,gender, count (*) as total_trsctions from retail_sales
group by category ,gender
order by 1;

--write a query to get the all the transcations made by the customers whose age between 20 to 30 from the category beauty
select category,age ,count (*) from retail_sales 
where age between 20 and  30 and category = 'Beauty'
group by category,age 
order by age ;

--write a query to find out theaverage sales per month and findout the best sale(subqueis)
select * from(select extract(YEAR FROM sale_date) as year,
extract(MONTH from sale_date) as month ,
avg(toatal_sale) as avg_sale,
rank () over(partition by EXTRACT(YEAR from sale_date) order by AVG(toatal_sale) desc)
from retail_sales
group by 1,2
order by 1,avg_sale desc)
where Rank =1 
;

--write a query to find top 5 customers on toatal sales
select customer_id,sum(toatal_sale) from retail_sales
group by customer_id
order by sum(toatal_sale) desc
limit 5;


--write a query to create a shift and find out number of orders per each shift 
with hourly_sale
as 
(select * ,case
when EXTRACT(hour from sale_time) < 12 then 'morning' 
when EXTRACT(hour from sale_time) between 12 and 17 then 'Afternoon' 
else 'evening'
end as shift
from retail_sales)
select 
shift,
count(*) as total_orders 
from hourly_sale
group by shift



