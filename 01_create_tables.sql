-- ---------- CREATE TABLES

-- olist_orders_dataset.csv

CREATE TABLE orders (
	order_id TEXT PRIMARY KEY,
	customer_id TEXT,
	order_status TEXT,
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

-- olist_order_items_dataset.csv

CREATE TABLE order_items (
	order_id TEXT,
	order_item_id INT,
	product_id TEXT,
	seller_id TEXT,
	shipping_limit_date TIMESTAMP,
	price NUMERIC(10, 2),
	freight_value NUMERIC(10, 2)
);

-- olist_products_dataset.csv

CREATE TABLE products (
	product_id TEXT PRIMARY KEY,
	product_category_name TEXT,
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty INT,
  	product_weight_g INT,
  	product_length_cm INT,
  	product_height_cm INT,
  	product_width_cm INT
);

-- product_category_name_translation.csv

CREATE TABLE category_translation (
  product_category_name TEXT,
  product_category_name_english TEXT
);