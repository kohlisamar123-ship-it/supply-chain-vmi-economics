
DROP VIEW IF EXISTS vw_clean_freight_rates;
DROP VIEW IF EXISTS vw_order_economics;


CREATE VIEW vw_clean_freight_rates AS
SELECT 
    carrier, 
    orig_port, 
    dest_port, 
    min_weight_quant,
    max_weight_quant,
    service_level,
    MIN(min_cost) AS min_cost,
    MIN(rate) AS rate 
FROM freight_rates
GROUP BY carrier, service_level, orig_port, dest_port, min_weight_quant, max_weight_quant
;


CREATE VIEW vw_order_economics AS 
SELECT  
    o.order_id,
    o.carrier,
    o.service_level,
    o.orig_port,
    o.dest_port,

    CASE 
        WHEN o.service_level = 'CRF' THEN 0.0

        WHEN vf.rate IS NULL AND o.carrier = 'V444_1' THEN MAX(7.8044, o.weight * 0.0804)

        ELSE MAX(vf.min_cost, o.weight * vf.rate)
    END AS freight_cost,

    ROUND((o.unit_quant * wc.cost_per_unit), 2) AS warehousing_cost,

    ROUND((o.unit_quant * wc.cost_per_unit),2) + CASE 
        WHEN o.service_level = 'CRF' THEN 0.0
        WHEN vf.rate IS NULL AND o.carrier = 'V444_1' THEN MAX(7.8044, o.weight * 0.0804)
        ELSE MAX(vf.min_cost, o.weight * vf.rate)
    END AS total_cost,

    CASE WHEN v.customer IS NOT NULL THEN 1 ELSE 0 END AS is_vmi
FROM order_list AS o
LEFT JOIN vw_clean_freight_rates AS vf
ON o.carrier = vf.carrier 
    AND o.orig_port = vf.orig_port  
    AND o.dest_port = vf.dest_port
    AND o.service_level = vf.service_level
    AND o.weight BETWEEN vf.min_weight_quant AND vf.max_weight_quant
LEFT JOIN wh_costs AS wc ON o.plant_code = wc.plant_code
LEFT JOIN vmi_customers AS v ON o.customer = v.customer
;


