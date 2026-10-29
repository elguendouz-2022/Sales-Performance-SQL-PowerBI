create database fast_food_sales;
use fast_food_sales;
SELECT * FROM fast_food_sales_data;
DESCRIBE fast_food_sales_data;

use fast_food_sales;
SHOW TABLES;



RENAME TABLE `fast_food_sales` TO fast_food_sales_data;



##DATA CLEANING
SET SQL_SAFE_UPDATES = 0;
UPDATE fast_food_sales_data 
SET transaction_date = STR_TO_DATE(transaction_date, '%W, %M %e, %Y');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE fast_food_sales_data
MODIFY COLUMN transaction_date DATE;


SET SQL_SAFE_UPDATES = 0;
-- Extracts just the HH:MM:SS part from the end of the text
UPDATE fast_food_sales_data 
SET transaction_time = REGEXP_SUBSTR(transaction_time, '[0-9]{2}:[0-9]{2}:[0-9]{2}$');
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE fast_food_sales_data 
SET transaction_time = STR_TO_TIME(transaction_time, ' %H:%i: %s');
SET SQL_SAFE_UPDATES = 1;

ROLLBACK;

SELECT * FROM fast_food_sales_data LIMIT 10;

DROP TABLE fast_food_sales_data;



SET SQL_SAFE_UPDATES = 0;
UPDATE fast_food_sales_data   
SET transaction_time = STR_TO_DATE(transaction_time, '%m/%d/%Y %h:%i:%s %p');
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE fast_food_sales_data 
ADD COLUMN extracted_time TIME;

UPDATE fast_food_sales_data 
SET extracted_time = TIME(transaction_time);

ALTER TABLE fast_food_sales_data 
DROP COLUMN extracted_date,
DROP COLUMN transaction_time;

ALTER TABLE fast_food_sales_data
RENAME COLUMN extracted_time TO transaction_time;

ALTER TABLE fast_food_sales_data
CHANGE COLUMN `ï»¿transaction_id`  transaction_id INT;


##1Calculate the total sales for each respective month
select 
   month(transaction_date) as month_number,
   sum(transaction_qty*unit_price) as total_sales
from fast_food_sales_data
group by month(transaction_date)
order by month_number;

##Calculate the difference in sales between the selected month and the previous month.
select 
  month(transaction_date) as date_number,
  sum(transaction_qty*unit_price) as total_sales,
  sum(transaction_qty*unit_price)-LAG(sum(transaction_qty*unit_price),1)
  over(order by month(transaction_date))
from fast_food_sales_data
group by month(transaction_date)
order by date_number;



##Determine the month-on-month increase or decrease in sales.

select 
  month(transaction_date) as date_number,
  sum(transaction_qty*unit_price) as total_sales,
  (sum(transaction_qty*unit_price)-LAG(sum(transaction_qty*unit_price),1)
  over(order by month(transaction_date)))/LAG(sum(transaction_qty*unit_price),1)
  over(order by month(transaction_date))*100
from fast_food_sales_data
group by month(transaction_date)
order by date_number;











##2Calculate the total number of orders for each respective month.

SELECT
  month(transaction_date),
  COUNT(transaction_id) as total_orders
  ##monthname(transaction_date) AS month_name
FROM fast_food_sales_data
GROUP BY 
    MONTH(transaction_date);
    ##monthname(transaction_date)

  
  ##Calculate the difference in the number of orders between the selected month and the previous month.

SELECT 
    MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(transaction_id) AS total_orders,
    
    -- Raw Difference Calculation: (Current Month Orders) - (Previous Month Orders)
    COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
        OVER (ORDER BY MONTH(transaction_date)) AS mom_order_difference
FROM 
    fast_food_sales_data
GROUP BY 
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY 
    month_number;
  
  
##Determine the month-on-month increase or decrease in the number of orders.
 
 
 SELECT 
    MONTH(transaction_date) AS month_number,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(transaction_id) AS total_orders,
    
    
    COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
        OVER (ORDER BY MONTH(transaction_date)) AS mom_order_difference,
    
    
    ROUND(
        (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) OVER (ORDER BY MONTH(transaction_date))) 
        / LAG(COUNT(transaction_id), 1) OVER (ORDER BY MONTH(transaction_date)) * 100, 
        2
    ) AS mom_growth_percentage

FROM 
    fast_food_sales_data
GROUP BY 
    MONTH(transaction_date),
    MONTHNAME(transaction_date)
ORDER BY 
    month_number;
 


    
    
 select * from fast_food_sales_data; 
 
 
##3Calculate the total quantity sold for each respective month.
SELECT 
  month(transaction_date) as month_number,
  SUM(transaction_qty) as total_qty
from fast_food_sales_data
group by month_number
order by month_number;


##Calculate the difference in the total quantity sold between the selected month and the previous month.
select
   month(transaction_date) as month_number,
   sum(transaction_qty) as total_qty,
   sum(transaction_qty)-LAG(sum(transaction_qty),1)
   OVER (order by month(transaction_date)) as quantity_difrence
from 
    fast_food_sales_data
group by
     month(transaction_date)  
order by
     month_number;
   

##Determine the month-on-month increase or decrease in the total quantity sold.

select
   month(transaction_date) as month_number,
   sum(transaction_qty) as total_qty,
   (sum(transaction_qty)-LAG(sum(transaction_qty),1) over (order by month(transaction_date)))
   /LAG(sum(transaction_qty),1) over (order by month(transaction_date))*100 as mom_total_quantity
from fast_food_sales_data
group by month(transaction_date)
order by month_number;


SELECT    
    MONTH(transaction_date) AS month_number,    
    SUM(transaction_qty) AS total_qty,    
    -- Formule : ((Actuel - Précédent) / Précédent) * 100
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) 
    / LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_total_quantity 
FROM 
    fast_food_sales_data 
GROUP BY 
    MONTH(transaction_date) 
ORDER BY 
    month_number;
    
    
###charts requirements
##(Sales, Orders, Quantity) when hovering over a specific day.

SELECT
   concat( round(SUM(unit_price*transaction_qty)/1000,1),'K') as total_sales,
   SUM(transaction_qty) AS total_qty,
   COUNT(transaction_id) AS total_orders
FROM fast_food_sales_data
where transaction_date='2023-05-18';

## sales by weekday and weeekend
select
   case when dayofweek(transaction_date) in(1,7) then 'weekend'
   else 'weekday'
   end as day_type,
   concat(round(sum(unit_price*transaction_qty),1),'K') as total_sales
from fast_food_sales_data
where month(transaction_date)=5
group by case when dayofweek(transaction_date) in(1,7) then 'weekend'
   else 'weekday'
   end ;


##Sales Analysis by Store Location:

select
     store_location,
     concat(round(sum(unit_price*transaction_qty)/1000,1),'K') as total_sales
from fast_food_sales_data
where month(transaction_date)=5
group by store_location 
order by total_sales asc;


##Daily Sales Analysis with Average Line

select avg(total_sales) as avg_total_sales
from
    (select  sum(unit_price * transaction_qty) as total_sales
    from fast_food_sales_data
    WHERE MONTH(transaction_date) = 5 
    group by transaction_date
    ) as internel_query;
    
select  
   DAY(transaction_date) AS day_number,    
   SUM(unit_price * transaction_qty) AS daily_sales_raw
from fast_food_sales_data
WHERE MONTH(transaction_date) = 5 
group by  DAY(transaction_date)
order by  DAY(transaction_date);


select
    daily_sales,
    day_of_month,
    case
        when daily_sales > avg_sales  then 'above average'
        when daily_sales < avg_sales  then 'under average'
        else 'average'
    end as sales_performance 
from
    (select
         DAY(transaction_date) AS day_of_month,    
         SUM(unit_price * transaction_qty) AS daily_sales,
         AVG(unit_price * transaction_qty) AS avg_sales
	from fast_food_sales_data
    where month (transaction_date)=5
    group by  DAY(transaction_date)
    ) as sales_data
    order by  day_of_month;
    






with daily_sales_sales as(
SELECT    
        MONTH(transaction_date) AS month_number,    
        DAY(transaction_date) AS day_number,    
        SUM(unit_price * transaction_qty) AS daily_sales_raw,
        CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1), 'K') AS total_sales
FROM fast_food_sales_data 
WHERE MONTH(transaction_date) = 5 
GROUP BY MONTH(transaction_date), DAY(transaction_date)
)

select
    month_number,
    day_number,
    total_sales,
    CONCAT(ROUND(AVG(daily_sales_raw) OVER() / 1000, 1), 'K') AS monthly_avg_sales,
    case
        when daily_sales_raw > AVG(daily_sales_raw) over() then 'above average'
        when daily_sales_raw < AVG(daily_sales_raw) over() then 'under average'
        else 'average'
    end as sales_performance 
from daily_sales_sales
order by day_number;


-- Sales Analysis by Product Category:
-- Analyze sales performance across different product categories.
-- Provide insights into which product categories contribute the most to overall sales.
-- Top 10 Products by Sales:

select
   sum(transaction_qty*unit_price) as total_sales,
   product_category
from fast_food_sales_data
where MONTH(transaction_date)=5
group by product_category
order by total_sales desc
limit 10;

select
   sum(transaction_qty*unit_price) as total_sales,
   product_type
from fast_food_sales_data
where MONTH(transaction_date)=5 and product_category='Pizza'

group by product_type
order by total_sales desc
limit 10;

-- Sales Analysis by Days and Hours:

select
   sum(transaction_qty*unit_price) as total_sales,
   sum(transaction_qty) as total_qty,
   count(*)
from fast_food_sales_data
where MONTH(transaction_date)=5 and dayofweek(transaction_date)=1 and hour(transaction_time)=8;

select
   hour(transaction_time),
   sum(transaction_qty*unit_price) as total_sales
from fast_food_sales_data
where MONTH(transaction_date)=5 
group by hour(transaction_time)
order by  hour(transaction_time);

select 
	case
        when dayofweek(transaction_date)=1 then 'sunday'
		when dayofweek(transaction_date)=2 then 'monday'
	    when dayofweek(transaction_date)=3 then 'tuesday'
		when dayofweek(transaction_date)=4 then 'wednesday'
		when dayofweek(transaction_date)=5 then 'thursday'
		when dayofweek(transaction_date)=6 then 'friday'
        else 'saturday'
	end as day_of_week,
    sum(transaction_qty*unit_price) as total_sales
from fast_food_sales_data
where MONTH(transaction_date)=5 
group by 
       case
           when dayofweek(transaction_date)=1 then 'sunday'
		   when dayofweek(transaction_date)=2 then 'monday'
	       when dayofweek(transaction_date)=3 then 'tuesday'
		   when dayofweek(transaction_date)=4 then 'wednesday'
		   when dayofweek(transaction_date)=5 then 'thursday'
		   when dayofweek(transaction_date)=6 then 'friday'
           else 'saturday'
		end
