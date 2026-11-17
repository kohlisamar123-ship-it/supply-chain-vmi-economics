-- The Final Executive Summary 

SELECT 
    COUNT(order_id) AS total_order_ids,
    ROUND(SUM(total_cost), 2) AS total_spend,
    ROUND(SUM(freight_cost), 2) AS total_freight_spend,
    ROUND(SUM(warehousing_cost), 2) AS total_warehouse_spend,
    ROUND(AVG(total_cost), 2) AS cost_per_order
FROM vw_order_economics;


-- Total freight spend grouped by carriers.

SELECT 
    carrier,
    ROUND(SUM(freight_cost), 2) AS total_freight_spend,
    COUNT(order_id) AS total_order_ids
FROM vw_order_economics
GROUP BY carrier
ORDER BY total_freight_spend 
DESC;


-- VMI analytics

SELECT 
    is_vmi,
    COUNT(order_id),
    ROUND(AVG(total_cost), 2) AS avg_tot_cost,
    ROUND(AVG(warehousing_cost), 2) AS avg_ware_cost
FROM vw_order_economics
GROUP BY is_vmi;

-- Verfying the reason of higher VMI costing.

SELECT 
    vw.is_vmi,
    ROUND(AVG(o.unit_quant), 2) AS avg_units_per_order
FROM vw_order_economics AS vw
LEFT JOIN order_list AS o
ON vw.order_id = o.order_id
GROUP BY vw.is_vmi
;
