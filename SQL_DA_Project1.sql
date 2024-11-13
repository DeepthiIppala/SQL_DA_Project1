SELECT COUNT(*)
FROM retail_sales;

--Data cleaning
SELECT * FROM retail_sales;

--Null values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

--
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	gender IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;

--deleting null values
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL OR
	sale_date IS NULL OR
	sale_time IS NULL OR
	gender IS NULL OR
	category IS NULL OR
	quantiy IS NULL OR
	cogs IS NULL OR
	total_sale IS NULL;


--Data Exploration

-- How many sales we have?
SELECT * FROM retail_sales;

SELECT 
	COUNT(*)
FROM retail_sales; --1997

--How many customers we have?
SELECT 
	COUNT(distinct customer_id)
FROM retail_sales; -- 155

--How many categories we have?

SELECT 
	DISTINCT category
FROM retail_sales; --"Electronics","Clothing","Beauty"

--Data Analysis FOR Business Key problems

--Analysis & Findings
--1. Query to fetch all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--2. SQL query to retrive all transactions WHERE the category = 'Clothing' and the quantity sold is more than 4 and in the month of Nov-2022.

SELECT * 
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND 
	quantiy >= 4;

--3. Query to calculate the total sales fOR each category

SELECT category,
	SUM(total_sale) AS net_sale,
	COUNT(*) total_ORders
FROM retail_sales
GROUP BY category;

--4. Query to find the average age of customers who purchASed items FROM the 'Beauty' category

SELECT 
	ROUND(AVG(age)) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

--5. Query to find all transactions WHERE total_sale is greater than 1000.

SELECT 
	COUNT(*)
FROM retail_sales
WHERE total_sale >= 1000;

--6. Query to find the total number of transactions made by each gender in each category

SELECT 
	category, 
	gender, 
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

--7. Query to calculate the avg sale fOR each month, find out best selling month in each year

SELECT 
	year, 
	month, 
	avg_sale
FROM
	(SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) desc) AS rank
	FROM retail_sales
	GROUP BY 1,2) AS t1
WHERE RANK=1;

--8. query to find the top 5 customers bASed on the highest total_sale

SELECT 
	customer_id,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sale desc
LIMIT 5;

--9. Query to find the number of unique customers who purchASed items FROM each category.

SELECT 
	category, 
	COUNT(distinct customer_id) unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Query to create each shift AND no of ORders( mORning <= 12, afternoon b/w 12&17, evening >17)

with hourly_sales AS
(SELECT *,
	cASe
		when EXTRACT(hour FROM sale_time) < 12 then 'MORning'
		when EXTRACT(hour FROM sale_time) between 12 AND 17 then 'Afternoon'
		else 'Evening'
	end AS shift
FROM retail_sales)
SELECT
	shift,
	COUNT(*) AS total_ORders
FROM hourly_sales
GROUP BY shift;

--END of project
