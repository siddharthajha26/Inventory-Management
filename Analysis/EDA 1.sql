-- 1-Warehouse Analysis
-- 2-Utilization vs capacity (warehouses vs products.quantityInStock).
-- 3-Absorption test for closure feasibility.

USE mintclassics;
SHOW TABLES;
SELECT * FROM customers;
SELECT COUNT(*) FROM customers;
SELECT COUNT(DISTINCT(customerName)) FROM customers;
SELECT * FROM customers WHERE customerName IS NOT NULL;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM productlines;
SELECT * FROM products;
SELECT * FROM warehouses;

-- Where are items stored and if they were rearranged, could a warehouse be eliminated?

-- Calculate stock, utilization and spare capacity by warehouse
SELECT 
    w.warehouseCode,
    w.warehouseName,
    SUM(p.quantityInStock) AS total_stock,
    w.warehousePctCap AS utilization_pct,
    (100 - w.warehousePctCap) AS spare_capacity_pct,
    round(SUM(p.quantityInStock)*100/w.warehousePctCap,0) AS total_capacity,
    round(SUM(p.quantityInStock)*100/w.warehousePctCap,0)-(SUM(p.quantityInStock)) AS spare_capacity,
    RANK() OVER (ORDER BY (100 - w.warehousePctCap) DESC) AS spare_capacity_rank
FROM warehouses w
LEFT JOIN products p
    ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseCode, w.warehouseName, w.warehousePctCap
ORDER BY spare_capacity_pct DESC;

-- As is evident from the results of the query the most underutilized warehouse in terms of percentage utilisation is that in the west(warehouse C) with 50% utlization.In that case it may be 
-- feasable to close the West warehouse only when the total stock at west can be approprately adjusted to the other three warehouses.

-- We need to make an absorption test for the purpose as shown below:-
-- Step 1: Calculate Stock, capacity, and spare capacity in ABSOLUTE units
WITH warehouse_summary AS (
    SELECT 
    w.warehouseCode,
    w.warehouseName,
    SUM(p.quantityInStock) AS total_stock,
    w.warehousePctCap AS utilization_pct,
    (100 - w.warehousePctCap) AS spare_capacity_pct,
    round(SUM(p.quantityInStock)*100/w.warehousePctCap,0) AS total_capacity,
    round(SUM(p.quantityInStock)*100/w.warehousePctCap,0)-(SUM(p.quantityInStock)) AS spare_capacity,
    RANK() OVER (ORDER BY (100 - w.warehousePctCap) DESC) AS spare_capacity_rank
FROM warehouses w
LEFT JOIN products p
    ON w.warehouseCode = p.warehouseCode
GROUP BY w.warehouseCode, w.warehouseName, w.warehousePctCap
ORDER BY spare_capacity_pct DESC),

-- Step 2: Select the candidate (most underutilized warehouse)
candidate AS (
    SELECT warehouseCode, warehouseName, total_stock
    FROM warehouse_summary
    ORDER BY (CAST(total_stock AS DECIMAL) / NULLIF(total_capacity,0)) ASC
    LIMIT 1 
),

-- Step 3: Compute spare capacity of other warehouses in ABSOLUTE UNITS
other_sites  AS (
    SELECT SUM(spare_capacity) AS total_other_spare_units
    FROM warehouse_summary
    WHERE warehouseCode NOT IN (SELECT warehouseCode FROM candidate)
)

-- Step 4: Compare evac stock vs. available spare capacity
SELECT 
    candidate.warehouseCode AS candidate_code,
    candidate.warehouseName AS candidate_name,
    candidate.total_stock AS evac_stock_units,
    other_sites.total_other_spare_units AS other_spare_capacity_units,
    CASE 
        WHEN other_sites.total_other_spare_units >= candidate.total_stock 
        THEN '✅ Feasible to close'
        ELSE '❌ Not feasible'
    END AS closure_feasibility
FROM candidate 
CROSS JOIN other_sites ;






