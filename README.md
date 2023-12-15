# Sales Analysis Using MySQL

### Project Overview

#### Objective:

##### The primary objective of this project was to analyze sales data and returns data to gain insights into customer behavior, product performance, and market-specific return rates.

#### Data Tables:

##### 1. Orders Table:
    This table contained information related to customer orders, including order ID, order date, shipping details, customer information, product details, sales, profit, and market-specific information.It was used to analyze sales, customer behavior, and product performance.

##### 2. Returns Table:
    This table contained information about returned orders, specifically marking orders with "Yes" for returns. It was used to analyze return rates by market and product.

#### Key Questions and Analyses:

##### 1. Find the Total sales, quantity and profit performance throughout the years?

```sql
SELECT 
	YEAR(`Order Date`) AS YEAR, 
    FORMAT(SUM(`Quantity`), 0) AS Total_Quantity,
	FORMAT(SUM(`Profit`),0) AS Total_Profit,
    FORMAT(SUM(`Sales`),0) AS Total_Sales
FROM orders
GROUP BY YEAR(`Order Date`)
ORDER BY YEAR(`Order Date`);
```

##### 2. Retrieve the top 10 countries with the highest sales and profit.

```sql
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
```
##### 3. Find the most profitable Product Category.

```sql
SELECT 
	Category,
    FORMAT(SUM(PROFIT),2) AS Total_Profit
FROM Orders
GROUP BY Category
ORDER BY Total_Profit DESC;
```
##### 4. Retrieve the top 10 products by sales.

```sql
SELECT 
	`Product Name`,
    FORMAT(SUM(Sales), 0) AS Total_Sales
FROM orders
GROUP BY `Product Name`
ORDER BY SUM(Sales) DESC LIMIT 10;
```
##### 5. What shipping modes sold the most products?

```sql
SELECT 
	`Ship Mode`,
    FORMAT(SUM(Sales),2) AS TOTAL_SALES
FROM orders
WHERE YEAR(`Order Date`) = 2014
GROUP BY `Ship Mode`
ORDER BY SUM(Sales) DESC;
```

##### 6. Calculate the average shipping cost for the top 10 different countries.

```sql
SELECT 
	Country,
	ROUND(AVG(`Shipping Cost`),2) AS Avg_Ship_Cost
FROM orders
GROUP BY Country
ORDER BY Avg_Ship_Cost DESC lIMIT 10;
```

##### 7. Count the total number of distinct customers By each country.

```sql
SELECT
	Country,
	COUNT(DISTINCT `Customer Name`) AS Total_No_Customers
FROM orders
GROUP BY Country
ORDER BY Total_No_Customers DESC;
```

##### 8. Lists the yearly number of customers, Sales and Number of Product Sold.

```sql
SELECT 
	YEAR(`Order Date`) AS Year,
    COUNT(DISTINCT `Customer ID`) AS Total_Customers,
    FORMAT(SUM(SALES),2) AS Total_Sales,
    FORMAT(SUM(Quantity), 0) AS Quantity_Sold
FROM orders
GROUP BY 1 
ORDER BY 1 DESC;
```

##### 9. Retrieve the top 10 most profitable customers.

```sql
SELECT 
	`Customer Name`,
    FORMAT(SUM(Profit), 2) AS Total_Profit
FROM orders
GROUP BY `Customer Name`
ORDER BY SUM(Profit) DESC LIMIT 10;
```

##### 10. Lists the Yearly Average Revenue Per Customer

```sql
SELECT 
	YEAR(`Order Date`) AS Year,
    ROUND(SUM(Sales) / COUNT(DISTINCT `Customer ID`),2) AS 'Avg Rev Per Customer'
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
```

##### 11. Calculate the percentage of returned orders by market.

```sql
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
```


### Conclusion:

##### In this project, I have conducted a comprehensive analysis of sales and returns data from two primary tables: "Orders" and "Returns." The objective was to gain valuable insights into Sales, customer behavior, product performance, and market-specific return patterns.
