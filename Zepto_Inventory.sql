CREATE DATABASE zepto_sql_P2;

use zepto_sql_P2;

-- data exploration
select count(*)
from _zepto_inventory;

select * from _zepto_inventory;

-- null values
SELECT count(*) AS null_records 
FROM _zepto_inventory
WHERE id IS NULL
OR	
Category IS NULL
OR	
name IS NULL
OR	
mrp IS NULL
OR	
discountPercent IS NULL
OR	
availableQuantity IS NULL
OR	
discountedSellingPrice IS NULL
OR	
weightInGms IS NULL
OR
outOfStock IS NULL
OR	
quantity IS NULL;

-- different product categories
SELECT DISTINCT(Category) AS Category
FROM _zepto_inventory
ORDER BY Category ASC;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(outOfStock) AS stock_count
FROM _zepto_inventory
GROUP BY outOfStock;

-- data cleaning
SELECT * FROM _zepto_inventory
WHERE mrp = 0
      OR 
      discountedSellingPrice = 0;
 
DELETE FROM _zepto_inventory
WHERE  mrp = 0
      OR 
      discountedSellingPrice = 0;
      
SET SQL_SAFE_UPDATES = 0;

-- convert paise to rupees
UPDATE _zepto_inventory
SET mrp = mrp/100.0,
    discountedSellingPrice = discountedSellingPrice/100.0;
    
-- data analysis
-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM _zepto_inventory
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM _zepto_inventory
WHERE outOfStock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT Category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM _zepto_inventory
GROUP BY Category
ORDER BY total_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM _zepto_inventory
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT Category,
AVG(discountPercent) AS avg_dis
FROM _zepto_inventory
GROUP BY Category
ORDER BY avg_dis DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value. 
SELECT DISTINCT name, weightInGms, discountedSellingPrice, 
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM _zepto_inventory
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE 
    WHEN  weightInGms < 1000 THEN 'Low'
    WHEN  weightInGms < 5000 THEN 'Medium'
    ELSE 'Bulk'
END AS whight_category
FROM _zepto_inventory;

-- Q8.What is the Total Inventory Weight Per Category
SELECT category, SUM(weightInGms * availableQuantity) AS total_whight
FROM _zepto_inventory
GROUP BY category
ORDER BY total_whight DESC;
   
    












