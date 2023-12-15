-- Creating a database named SALES_PROJECT if it doesn't already exist.
CREATE DATABASE IF NOT EXISTS SALES_PROJECT;

-- Use the SALES_PROJECT database for subsequent queries.
USE sales_project;

-- Retrieve the count of rows in the 'orders' table.
SELECT 
	count(*) 
FROM orders;

-- Retrieve all records from the 'orders' table.
SELECT 
	* 
FROM orders;

-- checking whether the Order ID is primary key or not -- 

SELECT 
	`Order ID`, 
	count(*) AS Total_times
FROM orders
GROUP BY `Order ID`
HAVING count(`Order ID`) > 1;

-- Retrieve the structure of the 'orders' table, showing its columns and their data types.

DESCRIBE orders;

-- Disable the SQL_SAFE_UPDATES mode, allowing potentially unsafe update operations.

SET SQL_SAFE_UPDATES = 0;

-- Run the UPDATE statement to convert the text representation of dates to a valid date format:

UPDATE orders
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

-- Run the ALTER TABLE statement to change the data type of the Order Date column to DATE: 

ALTER TABLE orders
MODIFY COLUMN `Order Date` DATE;

-- Similar steps for Ship date column

UPDATE orders
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE orders
MODIFY COLUMN `Ship Date` DATE;

-- All dataset columns now have appropriate and assigned data types.

DESCRIBE orders;

-- Check for the records from the 'orders' table where 'Ship Date' is earlier than 'Order Date.'

SELECT 
	* 
FROM orders
WHERE `Ship Date` < `Order Date`;

-- Retrieve distinct values of the 'Segment' column from the 'orders' table.

SELECT 
	DISTINCT Segment
FROM orders;

SELECT 
	DISTINCT `Ship Mode`
FROM orders;

-- Add a new integer column 'Day Diff' to the 'orders' table.

ALTER TABLE orders
ADD COLUMN `Day Diff` int;

-- Calculate the difference between 'Ship Date' and 'Order Date' and update 'Day Diff' column.

UPDATE orders
SET `Day Diff` = DATEDIFF(`Ship Date`, `Order Date`);

-- Find the minimum and Maximum value in the 'Day Diff' column.

SELECT 
	min(`Day Diff`) as Min_day_diff, 
	max(`Day Diff`) as Max_day_diff
FROM orders;

-- Exploratory data analysis (EDA)

-- 1. Find the Total sales, quantity and profit performance throughout the years?

SELECT 
	YEAR(`Order Date`) AS YEAR, 
    FORMAT(SUM(`Quantity`), 0) AS Total_Quantity,
	FORMAT(SUM(`Profit`),0) AS Total_Profit,
    FORMAT(SUM(`Sales`),0) AS Total_Sales
FROM orders
GROUP BY YEAR(`Order Date`)
ORDER BY YEAR(`Order Date`);

-- 2. Retrieve the top 10 countries with the highest sales and profit.

SELECT 
	Country, Total_Sales, Total_Profit, Top_rank
FROM
(
SELECT 
	Country,
	FORMAT(SUM(Sales),0) AS Total_Sales,
    FORMAT(SUM(Profit),0) AS Total_Profit,
    DENSE_RANK() OVER(order by SUM(Sales) DESC, SUM(Profit) DESC) AS Top_rank
FROM orders
GROUP BY Country
)E
WHERE E.Top_rank <= 10;

-- 3. Find the most profitable Product Category.

SELECT 
	Category,
    FORMAT(SUM(PROFIT),2) AS Total_Profit
FROM Orders
GROUP BY Category
ORDER BY Total_Profit DESC;

-- 4. Retrieve the top 10 products by sales.

SELECT 
	`Product Name`,
    FORMAT(SUM(Sales), 0) AS Total_Sales
FROM orders
GROUP BY `Product Name`
ORDER BY SUM(Sales) DESC LIMIT 10;

-- 5. What shipping modes sold the most products?

SELECT 
	`Ship Mode`,
    FORMAT(SUM(Sales),2) AS TOTAL_SALES
FROM orders
-- WHERE YEAR(`Order Date`) = 2014
GROUP BY `Ship Mode`
ORDER BY SUM(Sales) DESC;

-- 6. Calculate the average shipping cost for the top 10 different countries.

SELECT 
	Country,
	ROUND(AVG(`Shipping Cost`),2) AS Avg_Ship_Cost
FROM orders
GROUP BY Country
ORDER BY Avg_Ship_Cost DESC lIMIT 10;

-- 7. Count the total number of distinct customers By each country.

SELECT
	Country,
	COUNT(DISTINCT `Customer Name`) AS Total_No_Customers
FROM orders
GROUP BY Country
ORDER BY Total_No_Customers DESC;

-- 8. Lists the yearly number of customers, Sales and Number of Product Sold.

SELECT 
	YEAR(`Order Date`) AS Year,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    FORMAT(SUM(SALES),2) AS Total_Sales,
    FORMAT(SUM(Quantity), 0) AS Quantity_Sold
FROM orders
GROUP BY 1 
ORDER BY 1 DESC;

-- 9. Retrieve the top 10 most profitable customers.

SELECT 
	`Customer Name`,
    FORMAT(SUM(Profit), 2) AS Total_Profit
FROM orders
GROUP BY `Customer Name`
ORDER BY SUM(Profit) DESC LIMIT 10;

-- 10. Lists the Yearly Average Revenue Per Customer

SELECT 
	YEAR(`Order Date`) AS Year,
    ROUND(SUM(Sales) / COUNT(DISTINCT `Customer ID`),2) AS 'Avg Rev Per Customer'
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 11. Calculate the percentage of returned orders by market.

SET SQL_SAFE_UPDATES = 0;

UPDATE returns
SET MARKET = 'US' 
WHERE MARKET = 'United States';


WITH T_ORDERS AS
(
SELECT 
	MARKET,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY MARKET
),
RETUNRED_ORDERS AS
(
SELECT 
	MARKET,
    COUNT(*) AS Total_Returns
FROM returns
GROUP BY MARKET
)
SELECT 
	T1.MARKET, 
    FORMAT(Total_Orders, 0) Total_Orders, 
	Total_Returns, 
    ROUND((Total_Returns / Total_Orders * 100.0), 2) AS Percentage_Returned
FROM T_ORDERS T1 JOIN RETUNRED_ORDERS T2
ON T1.MARKET = T2.MARKET;




