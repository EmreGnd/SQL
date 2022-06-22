



---Discount Effect 


SELECT distinct product_id, quantity, discount
FROM	SALE.order_item
ORDER BY product_id, discount


SELECT	product_id, discount, sum(quantity)
FROM	SALE.order_item
GROUP BY product_id, discount
ORDER BY product_id, discount


------------------


---The difference between the amount of product sold at the lowest discount rate applied and the amount of product sold at the highest discount rate.
---The rate of increase to be obtained by dividing the product with the lowest discount rate applied


WITH T1 AS (
SELECT	product_id, discount, sum(quantity) total_quantity
FROM	SALE.order_item
GROUP BY product_id, discount
) , T2 AS(
SELECT	*, 
		FIRST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount) lower_dis_quan,
		LAST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) higher_dis_quan	
FROM	T1
), T3 AS (
SELECT	DISTINCT product_id,  1.0*(higher_dis_quan - lower_dis_quan) / lower_dis_quan increase_rate
FROM	T2
) 
SELECT	product_id, 
		CASE WHEN increase_rate >= 0.05 THEN 'positive' 
			WHEN increase_rate <= - 0.05 THEN 'negative'
			ELSE 'neutral'
		END	discount_effect
FROM	T3



