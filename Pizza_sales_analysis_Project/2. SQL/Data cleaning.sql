#. Data Cleaning, null handling & ensured relational integrity:

# Data type correction
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE pizza_types 
MODIFY pizza_type_id VARCHAR(50);

ALTER TABLE pizzas 
MODIFY pizza_type_id VARCHAR(50);


# Primary key 
alter table pizza_types
add primary key (pizza_type_id);

# Foreign key
alter table pizzas
add constraint fk_pizza_type
foreign key (pizza_type_id)
references pizza_types(pizza_type_id);

# Standardize date and time with safe updates off

UPDATE orders
SET order_time = STR_TO_DATE(order_time, '%H:%i:%s');

UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%y-%m-%d');

UPDATE orders
SET order_time = '00:00:00'
WHERE order_time IS NULL;

 	
SET SQL_SAFE_UPDATES = 1;

-- Null handling & join validation :

# Null checking for every table
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_details_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS pizza_id_nulls,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls
FROM order_details;

SELECT 
    count(*) as total_rows,
    sum(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    sum(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
    sum(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_time_nulls
FROM orders;

SELECT 
    count(*) as total_rows,
    sum(CASE WHEN pizza_id IS NULL THEN 1 ELSE 0 END) AS pizza_id_nulls,
    sum(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS pizza_type_id_nulls,
    sum(CASE WHEN size IS NULL THEN 1 ELSE 0 END) AS size_nulls,
    sum(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls
FROM pizzas;

SELECT 
    count(*) as total_rows,
    sum(CASE WHEN pizza_type_id IS NULL THEN 1 ELSE 0 END) AS pizza_type_id_nulls,
    sum(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS pizza_type_id_nulls,
    sum(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS pizza_type_id_nulls,
    sum(CASE WHEN ingredients IS NULL THEN 1 ELSE 0 END) AS pizza_type_id_nulls
FROM pizza_types;

# Updating handleable null values
SET SQL_SAFE_UPDATES = 0;

UPDATE pizza_types 
SET 	 category = 'others'
WHERE
category IS NULL;

UPDATE pizza_types 
SET    name = 'unknown'
WHERE
name IS NULL;

UPDATE pizza_types 
SET    ingredients = 'not available'
WHERE
ingredients IS NULL;
# Deleting non-handleable null values
DELETE FROM orders 
WHERE
order_time IS NULL OR
order_date IS NULL OR
order_id IS NULL;
    
DELETE FROM order_details 
WHERE
    order_details_id IS NULL
    OR order_id IS NULL
    OR pizza_id IS NULL
    OR quantity IS NULL;

SET SQL_SAFE_UPDATES = 1;