
-- -------- Q1: How many orders are there and how many delivered?

SELECT COUNT(*) FROM orders; -- count rows from orders
-- 99,441

-- Count orders where status is delivered
SELECT COUNT(*) FROM orders
WHERE order_status = 'delivered';
-- 96,478

-- -------- Q2: How many orders are in each status?

SELECT order_status, COUNT(*) AS number_of_orders -- show each order status and a count
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;

-- -------- Q3: What is the total revenue?

SELECT SUM(price) AS total_revenue
FROM order_items; -- 13,591,643.70

-- Actual revenue of delivered orders
SELECT SUM(oi.price) AS delivered_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'; -- 13,221,498.11

-- -------- Q4: What are the 10 most expensive items sold?
SELECT order_id, product_id, price
FROM order_items
ORDER BY price DESC
LIMIT 10;

SELECT AVG(price) AS average_price
FROM order_items; -- average of approx. 120.65

-- -------- Q5: What is the revenue per month?
SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month, 
	SUM(oi.price) AS revenue -- sums the prices within each month's bucket
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month, 
	SUM(oi.price) AS revenue -- sums the prices within each month's bucket
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY revenue DESC;

-- -------- Q6: What is the revenue per product category?

SELECT COUNT(*) FROM products; -- 32,951
SELECT COUNT(*) FROM category_translation; -- 71

SELECT t.product_category_name_english AS category, SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;






