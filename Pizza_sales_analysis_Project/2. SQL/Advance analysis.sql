
#. Advanced Analysis:
#.17 Calculate the percentage contribution of each pizza type to total revenue.

with cte (name,revenue) as(
select 
pt.category as name, 
cast(sum(quantity*price) as decimal (10,2)) as revenue
from order_details od 
join pizzas p on od.pizza_id=p.pizza_id
join pizza_types  pt 
on p.pizza_type_id= pt.pizza_type_id
group by pt.category
)

select 
name,
revenue*100/(select cast(sum(quantity*price) as decimal (10,2)) as revenue
from 
order_details od join pizzas p 
on od.pizza_id=p.pizza_id 
join pizza_types  pt 
on p.pizza_type_id= pt.pizza_type_id) as PCT
from cte 
order by revenue desc;
 

-- Classic share most of the revenue distribution while veggie is the least of it.

#.18 Contribution % of Each Pizza

SELECT 
    pt.name,
    ROUND(SUM(od.quantity * p.price) * 100 / 
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id), 2) AS contribution_pct
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY contribution_pct DESC;
 

-- Here is percentage wise distribution of pizzas over revenue 

-- #.19 Size-wise Revenue Share

with rev as (
select 
    size,
    sum(price*quantity) as revenue
from order_details od join pizzas p on od.pizza_id=p.pizza_id group by size
)

select
    size,
    revenue*100/(select sum(price*quantity) from order_details od join pizzas p on od.pizza_id=p.pizza_id) as PCT	from rev;

 
-- Here is percentage wise distribution of revenue share of Large size is the most while XXL and XL are the least


#.20 Peak vs Non-Peak Revenue

with rev as (
select 
    sum(price*quantity) as revenue
from order_details od join pizzas p on od.pizza_id=p.pizza_id
)

select
    case
        when hour(order_time) between 12 and 15 then "Lunch"
        when hour(order_time) between 18 and 22 then "Dinner"
        else "Off-peak"
    end as Time_slot,
        sum(price*quantity) as revenue,
        round(sum(price*quantity)*100/(select revenue from rev),2) as PCT
from orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
group by time_slot;

 
-- Revenue distributed over Peak vs Non-peak hours, during ‘Lunch’ peak hours revenue distribution is the most 40.37% and followed by Dinner peak hour with 34.85% then Off-peak hours which is the lowest 24.79%


#.21 Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT
	CATEGORY, 
NAME, 
revenue
FROM
(SELECT 
category,
NAME, 
total_orders, 
revenue,
    rank() OVER(PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM
(SELECT 
pt.category,
pt.name, 
COUNT(DISTINCT order_id) total_orders, CAST(SUM(quantity*price) AS DECIMAL (10,2)) AS revenue
FROM 
order_details od JOIN pizzas p 
ON od.pizza_id=p.pizza_id 
JOIN pizza_types  pt 
ON p.pizza_type_id= pt.pizza_type_id
GROUP BY pt.category,pt.name) AS cat_total) AS cat_rank

WHERE rnk <=3;
