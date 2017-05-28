--
DESC orders
DESC order_items
DESC products;

-- customers.customer_id -> orders.customer_id, orders.order_id -> order_items.order_id, order_items.product_id -> products.product_id AND products.list_price > 1000;

SELECT c.cust_first_name, c.cust_last_name, c.customer_id, p.list_price, p.product_id, p.product_name
FROM customers c
JOIN orders o ON (o.customer_id = c.customer_id)
JOIN order_items oi ON (oi.order_id = o.order_id)
JOIN products p ON (p.product_id = oi.product_id)
WHERE p.list_price > 1000;

-- ALTERNATIVELY:
SELECT cust_first_name, cust_last_name, customer_id, list_price, product_id, product_name
FROM customers
JOIN orders USING (customer_id)
JOIN order_items USING (order_id)
JOIN products p USING (product_id)
WHERE p.list_price > 1000;

-- ZZ