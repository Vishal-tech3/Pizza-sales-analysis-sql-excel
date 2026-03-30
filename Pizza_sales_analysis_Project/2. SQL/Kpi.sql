
-- #.Basic Analysis with KPI’s:
-- SQL Queries

use pizza_mania;
SELECT * FROM  orders;
#1. Retrieve the total number of orders placed.

SELECT 
    COUNT(*) AS total_orders
FROM
    orders;

 
-- There are total 21350  different orders

#2. Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(od.quantity * p.price) AS Total_sales
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

 
--  Total revenue generate as on 31-Dec-2015 is $817860.05

#.3 Identify the highest-priced pizza.

SELECT 
    name, price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;

 
-- “The Greek Pizza” is the highest price pizza


#.4 Identify the most common pizza size ordered.

SELECT 
    size, COUNT(DISTINCT order_id) AS total_orders
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY total_orders DESC
LIMIT 1;

 
-- Large pizzas are mostly ordered.
 
#5. KPI's of orders placed.

SELECT 
    COUNT(DISTINCT od.order_id) total_orders,
    SUM(price * quantity) AS total_revenue,
    ROUND(SUM(price * quantity) / COUNT(DISTINCT od.order_id),
            2) AS avg_order_value,
    SUM(quantity) AS total_pizzas_sold
FROM
    orders o
        JOIN
    order_details od ON o.order_id = od.order_id
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

 
-- There are total 21350 order placed, 49574 pizzas sold and over 817860 revenue generated over year 2015 with average order value $38.31

#6. Revenue per Pizza    
    
select
    round(sum(price*quantity)/ sum(quantity),2) as revenue_per_pizza
from order_details od join pizzas p on od.pizza_id=p.pizza_id;

 
-- Average revenue generated over pizza quantity is $16.5
#.7 List the top 5 most ordered pizza types along with their quantities.

SELECT 
    name, SUM(quantity) AS total_qty_ordered
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY name
ORDER BY total_qty_ordered DESC
LIMIT 5;

 
-- Most ordered pizza quantity is from  classic deluxe.


#.8 List the worst 5 ordered pizza types along with their quantities.

SELECT 
    pt.name,
    SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_qty ASC LIMIT 5;


 
-- Here are the 5 least ordered pizzas 

