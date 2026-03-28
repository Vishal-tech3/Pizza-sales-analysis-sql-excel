
#.Exploratory Data Analysis:
#.9 Analyze small set of pizzas (~20%) generating (~80%) of the revenue.

with pizza_revenue as (
	select
		pt.name as pizza_name,
        sum(price*quantity) as revenue
	from order_details od join pizzas p on od.pizza_id=p.pizza_id join pizza_types pt on p.pizza_type_id= pt.pizza_type_id
    group by pt.name
),
ranked as (
	select
		pizza_name,
        revenue,
        sum(revenue) over (order by revenue desc) as cumulative_revenue,
        sum(revenue) over () as total_revenue
    from pizza_revenue
)
select
	pizza_name,
    revenue,
    round(cumulative_revenue*100/total_revenue,2) as cumulative_pct,
    row_number() over() as row_num
from ranked
order by revenue desc;


 
#.10 Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
category,
COUNT(name) AS total
FROM pizza_types GROUP BY category;
 
-- Here are total 27 pizzas over 4 categories
#.11 Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    category, SUM(quantity) AS total_qty_ordered
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY category;


 
-- Classic category is the strongest asset, it has the highest brand recognition and customer trust, Veggie and supreme suggest a balance demand, Chicken is trailing 

 
#12. Peak Day Analysis

SELECT 
    DAYNAME(order_date) AS day_name,
    COUNT(DISTINCT order_id) AS total_orders,
    concat(round(COUNT(order_id)*100/(select COUNT(DISTINCT order_id) from orders),2),"%") as PCT
FROM orders
GROUP BY day_name
ORDER BY total_orders DESC;    

 
-- On (Friday, Thursday, Saturday, Wednesday) these day order distribution is 60.69% and 39.31% is for the rest days.




#13.  Revenue Growth % (Day-over-Day)
select
    order_date,
    round(daily_revenue,2) as daily_revenue,
    round((daily_revenue - lag(daily_revenue) over (order by order_date))
    / lag(daily_revenue) over(order by order_date)*100,2) as growth_pct
from
(select order_date,
        sum(quantity*price) as daily_revenue
from orders o join order_details od on o.order_id=od.order_id
        join pizzas p on od.pizza_id=p.pizza_id
        group by o.order_date)  daily_rev;

 

-- It shows Day-by-day percentage revenue growth

#.14 Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS Time, COUNT(DISTINCT order_id) AS Total_orders
FROM
    orders
GROUP BY HOUR(order_time);

 

-- Most orders are seen from 11am to 9pm




#.15 Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(qty),2) AS avg_order_value
FROM
    (SELECT 
        o.order_date AS date, SUM(od.quantity) AS qty
    FROM
        order_details od
    JOIN orders o ON od.order_id = o.order_id
    GROUP BY o.order_date) AS order_qty;
 
-- Here is average 138 quantity of pizza ordered pe day

 
#.16 Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pt.name AS Pizza_name,
    COUNT(DISTINCT order_id) AS Total_orders,
    SUM(quantity) AS Total_quantity_ordered,
    CAST(SUM(quantity * price) AS DECIMAL (10 , 2 )) AS revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

 
-- most revenue of orders are form these 3 pizza categories


