ALTER TABLE products ADD PRIMARY KEY (product_id); --встановлюємо первинні ключі
ALTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE orders ADD PRIMARY KEY (order_id);
ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customers -- встановлєємо зовнішні ключі
FOREIGN KEY (customer_id) REFERENCES customers (customer_id);
ALTER TABLE order_items 
ADD CONSTRAINT fk_items_products 
FOREIGN KEY (product_id) REFERENCES products (product_id);
ALTER TABLE order_items 
ADD CONSTRAINT fk_items_orders 
FOREIGN KEY (order_id) REFERENCES orders (order_id);