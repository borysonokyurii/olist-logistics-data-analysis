-- The impact of timely delivery on customer ratings
SELECT 
CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late Delivery' 
ELSE 'On Time' 
END AS delivery_status,
ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o 
JOIN reviews r ON o.order_id = r.order_id 
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
GROUP BY 1