-- 1. Verifying the contents of various tables after loading csv data into data base.

SELECT * FROM wh_costs LIMIT 5;

SELECT * FROM wh_capacities LIMIT 5;

SELECT * FROM vmi_customers LIMIT 5;


-- 2. Verifying the count of rows for every table to ensure data integrity.

SELECT 'order_list' AS table_name, COUNT(*) AS row_count FROM order_list
UNION ALL
SELECT 'products_per_plant' AS table_name, COUNT(*) AS row_count FROM products_per_plant
UNION ALL
SELECT 'freight_rates' AS table_name, COUNT(*) AS row_count FROM freight_rates
UNION ALL
SELECT 'plant_ports' AS table_name, COUNT(*) AS row_count FROM plant_ports
UNION ALL
SELECT 'vmi_customers' AS table_name, COUNT(*) AS row_count FROM vmi_customers
UNION ALL
SELECT 'wh_capacities' AS table_name, COUNT(*) AS row_count FROM wh_capacities
UNION ALL
SELECT 'wh_costs' AS table_name, COUNT(*) AS row_count FROM wh_costs;


-- 3. Ensuring the order_list table has valid data.

SELECT 
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date,
    SUM(CASE WHEN unit_quant <= 0 THEN 1 ELSE 0 END) AS bad_quantities,
    SUM(CASE WHEN weight <= 0 THEN 1 ELSE 0 END) AS zero_or_neg_weights,
    SUM(CASE WHEN tpt_day_count < 0 THEN 1 ELSE 0 END) AS neg_transit_days
FROM order_list;


-- 3.1 Analyzing the orders with weight equal to zero. 

SELECT order_id, unit_quant, carrier, product_id
FROM order_list
WHERE weight <= 0;

-- 3.1.1 Inspecting the average unit weight of orders other than weight equal to zero for two specific product id's.

SELECT 
    product_id,
    COUNT(*) AS valid_order_count,
    ROUND(AVG(weight / unit_quant), 6) AS avg_unit_weight
FROM order_list
WHERE product_id IN ('1699946', '1658528')
  AND weight > 0
GROUP BY product_id;


-- 4. Orders that can be succesfully priced by freight rate list.

SELECT 
    COUNT(*) AS total_rows_joined
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN f.rate_id IS NOT NULL THEN o.order_id END) AS matched_orders,
    COUNT(DISTINCT CASE WHEN f.rate_id IS NULL THEN o.order_id END) AS unmatched_orders
FROM order_list AS o 
LEFT JOIN freight_rates AS f ON o.carrier = f.carrier 
    AND o.orig_port = f.orig_port  
    AND o.dest_port = f.dest_port
    AND o.service_level = f.service_level
    AND o.weight BETWEEN f.min_weight_quant AND f.max_weight_quant
;

-- 4.1 Information about orders that can't be succesfully priced by freight list.

SELECT 
    o.carrier,
    o.service_level,
    o.orig_port,
    o.dest_port,
    COUNT(DISTINCT o.order_id) AS unmatched_count,
    ROUND(MIN(o.weight), 2) AS min_wt,
    ROUND(MAX(o.weight), 2) AS max_wt
FROM order_list AS o
LEFT JOIN freight_rates AS f 
    ON o.carrier = f.carrier 
    AND o.orig_port = f.orig_port  
    AND o.dest_port = f.dest_port
    AND o.service_level = f.service_level
    AND o.weight BETWEEN f.min_weight_quant AND f.max_weight_quant
WHERE f.rate_id IS NULL
GROUP BY o.carrier, o.service_level, o.orig_port, o.dest_port
ORDER BY unmatched_count DESC;


-- 4.1.1 Uncovering the missing weight gap in frieght table

SELECT 
    carrier,
    service_level,
    orig_port,
    dest_port,
    min_weight_quant,
    max_weight_quant,
    min_cost,
    rate
FROM freight_rates
WHERE carrier IN ('V444_1', 'V44_3')
  AND orig_port IN ('PORT04', 'PORT05', 'PORT09')
ORDER BY carrier, orig_port, min_weight_quant;




