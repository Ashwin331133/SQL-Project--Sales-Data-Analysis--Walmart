create database walmart;

use walmart;

create table sales(
Invoice_id varchar(50) primary key,
Branch varchar(5) not null,
City varchar(30) not null,
Customer_type varchar(20) not null,
Gender varchar(10) not null,
Product_line varchar(50) not null,
unit_price decimal(10,2) not null,
Quantity int(100) not null,
VAT decimal (10,4) not null,
Total decimal (12,4) not null,
Sale_date date not null,
Sale_time Time not null,
Payments varchar(20) not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9) not null,
gross_income decimal(6,4) not null,
Rating float(3,1) not null
);

drop table sales

select * from sales


SET GLOBAL local_infile = 'ON';
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL_Server 8.0/Uploads/Walmart Sales Data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from sales

----------------Exploratory Data Analysis (EDA)----------------------
Generic Questions

-- 1.How many distinct cities are present in the dataset?
select distinct city from sales;

-- 2.In which city is each branch situated?
select distinct city,branch from sales;

Product Analysis
-- 1.How many distinct product lines are there in the dataset?
select distinct product_line from sales;

-- 2.What is the most common payment method?
select payments, count(payments) as count from sales
group by payments
order by sales desc limit 1;

-- 3.What is the most selling product line?
select distinct product_line, count(quantity) as total from sales
group by product_line
order by total desc limit 1;

-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
select sum(cogs) as total_cogs, monthname(sale_date) as sale_month
from sales
group by sale_month
order by total_cogs desc limit 1;

-- 6.Which product line generated the highest revenue?
select  product_line, sum(total) as highest_income
from sales
group by product_line
order by highest_income desc limit 1;

-- 7.Which city has the highest revenue?
select city, sum(total) as revenue
from sales
group by city
order by revenue desc limit 1;

-- 8.Which product line incurred the highest VAT?
select product_line, sum(Vat) as highest_Vat
from sales
group by product_line
order by highest_Vat desc limit 1;

-- 9.Which branch sold more products than average product sold?
select branch, sum(quantity) as qty
from sales
group by branch
having qty > avg(quantity)
order by qty desc limit 1;

-- 10.What is the most common product line by gender?
select gender, product_line, count(product_line) as total_count
from sales
group by gender,product_line
order by total_count desc limit 1;

-- 11.What is the average rating of each product line?
select product_line, round(avg(rating),2) avg_rating
from sales
group by product_line;

Sales Analysis
-- 1.Number of sales made in each time of the day per weekday
select dayname(sale_date) as weekday, count(invoice_id) as no_of_sales
from sales
where dayname(sale_date) not in ('Saturday','Sunday')
group by weekday;

-- 2.Identify the customer type that generates the highest revenue.
select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc limit 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, sum(vat) as total_vat
from sales
group by city
order by total_vat desc limit 1;

-- 4.Which customer type pays the most in VAT?
select customer_type, sum(vat) as sum_vat
from sales
group by customer_type
order by sum_vat limit 1;

Customer Analysis

-- 1.How many unique customer types does the data have?
select distinct customer_type
from sales;

-- 2.How many unique payment methods does the data have?
select distinct payments from sales;

-- 3.Which is the most common customer type?
select customer_type, count(customer_type) as total_count
from sales
group by customer_type
order by total_count desc limit 1;

-- 4.Which customer type buys the most?
select customer_type, sum(total) as total_sales
from sales
group by customer_type
order by total_sales desc limit 1;

-- 5.What is the gender of most of the customers?
select gender, count(gender) as count
from sales
group by gender
order by count desc limit 1;

-- 6.What is the gender distribution per branch?
select branch, gender,count(gender) from sales
group by branch,gender
order by branch;

-- 7.Which day of the week has the best avg ratings?
select dayname(sale_date) as dy, avg(rating) as avg_rating
from sales
group by dy
order by avg_rating desc limit 1;

-- 8.Which day of the week has the best average ratings per branch?
select dayname(sale_date) as dy, avg(rating) as avg_rating, branch
from sales
group by dy,branch
order by avg_rating desc limit 1;

