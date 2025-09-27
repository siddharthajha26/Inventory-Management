-- Cost optimization can be checked at SKU level against inventory capacity and safety stock levels.
SELECT 
    p.productCode,
    p.productName,
    p.warehouseCode,
    p.quantityInStock,
    MAX(o.orderDate) AS lst_ordr_dt,
    COALESCE(SUM(od.quantityOrdered),0) AS total_sales_last_6m,
    ROUND(p.quantityInStock / NULLIF(SUM(od.quantityOrdered),0),2) AS stock_to_sales_ratio
    
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
LEFT JOIN orders o ON od.orderNumber = o.orderNumber
    AND o.orderDate >= DATE_SUB(MAX(o.orderDate), INTERVAL 6 MONTH)
GROUP BY p.productCode, p.productName, p.warehouseCode, p.quantityInStock,lst_ordr_dt
ORDER BY stock_to_sales_ratio DESC;

-- Checking for obsolete or slow moving inventory at SKU level and identifying SKU for discontinuation,Markdown 
-- Comparing the stock in hand with Sales to identify the SKU for reduction or re allocation.alter  