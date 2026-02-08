-- Found a correlation between product weight and delivery delays across cities
WITH cte AS (
SELECT 
s.seller_city,
COUNT(DISTINCT o.order_id) AS "total", 
SUM(CASE WHEN o.order_estimated_delivery_date < o.order_delivered_customer_date THEN 1 
ELSE 0 END) AS "late_orders",
ROUND(AVG(p.product_weight_g)::numeric, 2) AS "avg_weight_per_order"
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN sellers s ON oi.seller_id = s.seller_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1)
SELECT *, 
ROUND(((late_orders::numeric / total) * 100), 2) AS "Delay_Rate"
FROM cte
WHERE total > 10 
ORDER BY "avg_weight_per_order" DESC;