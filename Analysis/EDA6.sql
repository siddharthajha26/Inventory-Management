-- Geographic Demand vs Warehouse Location
-- If a warehouse serves regions with low customer demand, it may be unnecessary.
SELECT 
    c.country,
    p.warehouseCode,
    SUM(od.quantityOrdered) AS total_units_sold,
    SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM orders o
JOIN orderdetails od ON o.orderNumber = od.orderNumber
JOIN products p ON od.productCode = p.productCode
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY c.country, p.warehouseCode
HAVING revenue < 10000 AND total_units_sold <100
ORDER BY revenue DESC;
--  As we can clearly see the result of the query that the warehouses in countries having total_units_sold <100 and revenue < 10000 need to be rationalised

