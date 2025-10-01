 -- Dead or Slow-Moving Inventory
-- Comparing the stock in hand with Sales to identify the SKU for reduction or re-allocation.
-- Checking for obsolete or slow moving inventory at SKU level and identifying SKU for discontinuation,Markdown 
USE mintclassics;
SELECT
	p.productCode,
    p.productName,
    p.warehouseCode,
    p.quantityInStock,
    COALESCE(SUM(od.quantityOrdered),0) AS total_sales_last_12m
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
LEFT JOIN orders o ON od.orderNumber = o.orderNumber
    AND o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock
HAVING total_sales_last_12m = 0
ORDER BY p.quantityInStock DESC;

-- As is evident from the results of the query that the  product code S18_3233 The product 1985 Toyota Supra lying in the warehouse b has total quantity 7733
-- and has 0 sales in the past 12 months which means that this stock is obsolete and is non moving.
-- Therefore the need to re-allocate the stock from this warehouse to the warehouse where its sales is more than quantity in stock.

SELECT 
    p.productCode,
    p.productName,
    p.warehouseCode,
    p.quantityInStock,
	COALESCE(SUM(od.quantityOrdered),0) AS total_sales
FROM products p 
LEFT JOIN orderdetails od ON p.productCode = od.productCode
LEFT JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock
HAVING total_sales>quantityInStock
ORDER BY total_sales DESC;

  
