SELECT * FROM shipments_tbl;

SELECT shipment_id,
	proper_case(trim(origin_warehouse)) AS origin_warehouse,
	proper_case(trim(destination_city)) AS destination_city,
	ucase(destination_state) AS destination_state,
	proper_case(trim(carrier)) AS carrier,
    
str_to_date(delivery_date,'%Y-%m-%d') AS delivery_date,
str_to_date(ship_date,'%Y-%m-%d') AS ship_date,

datediff(delivery_date,ship_date) AS No_of_days_delivered,
CASE
	WHEN(delivery_date) < (ship_date) THEN 'Invalid'
	WHEN(delivery_date) = (ship_date) THEN 'Same Day Delivery'
    ELSE 'Valid'
END as delivery_status,

CASE
	WHEN weight_kg < 0 THEN abs(weight_kg)
	WHEN weight_kg = 0 THEN 0
    ELSE weight_kg
END as valid_weight,

row_number() over(
	partition by origin_warehouse, destination_city, destination_state,
	ship_date, carrier,
	CONVERT(weight_kg, char),
	CONVERT(freight_cost, char)
ORDER BY shipment_id) as row_nums
FROM shipments_tbl;

DELETE FROM shipment_db.shipments_tbl
WHERE shipment_id IN (
    SELECT shipment_id
    FROM (
        SELECT shipment_id,
               ROW_NUMBER() OVER (
                   PARTITION BY origin_warehouse, destination_city, destination_state,
                                ship_date, carrier
                   ORDER BY shipment_idcleaned_datacleaned_datacleaned_datacleaned_datacleaned_data
               ) AS row_num
        FROM shipment_db.shipments_tbl
    ) sub
    WHERE row_num > 1
);