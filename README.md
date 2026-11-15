# Olist E-Commerce Sales Analysis (PostgreSQL)

## Overview

This project analyzes order and sales data from Olist, a Brazilian e-commerce marketplace, using PostgreSQL. I answer six business questions about order volume, revenue, pricing, and product categories, using core SQL: `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`, aggregate functions, and multi-table `JOIN`s.

**Tools:** PostgreSQL, pgAdmin
**Dataset:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle), covering roughly 100,000 orders from 2016 to 2018.

## Data

Four tables from the dataset were used:

| Table | Description |
|---|---|
| `orders` | One row per order: status and purchase date |
| `order_items` | One row per item in an order: price and product |
| `products` | One row per product: category |
| `category_translation` | Translates category names from Portuguese to English |

**Relationships**
- `orders.order_id` = `order_items.order_id`
- `order_items.product_id` = `products.product_id`
- `products.product_category_name` = `category_translation.product_category_name`

## How to reproduce

1. Download the dataset from Kaggle.
2. Create the four tables in PostgreSQL (see `01_schema.sql`).
3. Import the CSV files with pgAdmin (Import/Export Data, header on, comma delimiter).
4. Run the queries (see `02_queries.sql`).

---

## Analysis

### 1. How many orders are there, and how many were delivered?

```sql
SELECT COUNT(*) FROM orders;

SELECT COUNT(*) FROM orders
WHERE order_status = 'delivered';
```

**Result:** 99,441 total orders, 96,478 delivered.
**Insight:** About 97.02% of orders were delivered.

### 2. How many orders are in each status?

```sql
SELECT order_status, COUNT(*) AS number_of_orders
FROM orders
GROUP BY order_status
ORDER BY number_of_orders DESC;
```

**Insight:** Delivered orders dominate with 96,478 total orders. Cancelled and Unavailable orders only make up a small portion of the total orders with 625 and 609 orders respectively. 
(see `results/count_orders_by_order_status.csv`)

### 3. What is the total revenue?

```sql
-- All orders
SELECT SUM(price) AS total_revenue
FROM order_items;

-- Delivered orders only
SELECT SUM(oi.price) AS delivered_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';
```

**Result:** Total 13,591,643.70, delivered only 13,221,498.11.
**Insight:** Delivered orders account for about 97.28% of total revenue. I used delivered orders only in later queries because canceled orders did not earn money.

### 4. What are the 10 most expensive items sold?

```sql
SELECT order_id, product_id, price
FROM order_items
ORDER BY price DESC
LIMIT 10;
```

**Insight:** The most expensive item sold for 6,735.00 and the 10th for 3,999.90. These are far above the average item price of about 120.50, but the values look realistic (for example 4,799.00), so they appear to be genuine high-priced products rather than data errors.
(see `results/10_most_expensive_items.csv`)

### 5. What is the revenue per month?

```sql
SELECT TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
       SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;
```

**Insight:** Revenue was negligible in 2016 (from 134.97 in 2016-09 to 10.90 in 2016-12), so I treated 2016 as unreliable for trends. From 2017-01 revenue grew steadily to a peak of 987,765.37 in 2017-11, likely driven by Black Friday sales, then dipped in 2017-12. Through 2018 it levelled off at roughly 800,000 to 970,000 per month.

![alt text](image.png)

The line chart shows an uneven but upward trend from 2017 to 2018, with dips after peaks. The sharpest was a drop of roughly 27% from the 2017-11 peak (987,765.37) to 2017-12. 2016 was very low and erratic: revenue was only 134.97 in 2016-09, rose to 40,325.11 in 2016-10, then fell to 10.90 in 2016-12, before growth began in 2017-01.

### 6. What is the revenue per product category?

```sql
SELECT t.product_category_name_english AS category,
       SUM(oi.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
```

**Insight:** *Health & beauty* was the top category at 1,233,131.72, followed by *Watches & Gifts* and *Bed, Bath & Table*.

**Note:** An inner `JOIN` drops products with no category, so those items are excluded from this result.

---

## Key takeaways
- Revenue grew strongly through 2017 and then levelled off. Monthly revenue rose from about 100,000 in 2017-01 to a peak of 987,765.37 in 2017-11, then held at roughly 800,000 to 970,000 a month through 2018. The 2016 months were too small to use for trends.
- The November 2017 peak was followed by a sharp dip. Revenue fell about 26.50% in 2017-12. The spike is likely linked to Black Friday, though the data alone doesn’t prove it.
- High-priced items are rare but realistic. The most expensive item sold for 6,735.00 and the 10th for 3,999.90, far above the average item price of 120.50.
- Nearly all orders are delivered. 97.02% of orders were delivered.
- *Health & beauty* was the top category at 1,233,131.72, followed by *Watches & Gifts* and *Bed, Bath & Table*.

## What I learned

- Writing `JOIN`s across three and four tables, and filtering before aggregating
- Using `GROUP BY` with aggregate functions (`COUNT`, `SUM`, `AVG`)
- Checking results for sanity (for example, whether the largest prices were realistic)
- Recognizing data limits, such as incomplete months at the start and end of the dataset

## Next steps

- Add customer analysis (repeat purchase rate) using `customer_unique_id`
- Use window functions for month-over-month growth
- Build a dashboard in Tableau Public or Power BI