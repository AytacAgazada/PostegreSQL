CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    account_balance DECIMAL(10, 2) DEFAULT 0.00
);

create table orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    city VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    complaint_text TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'unresolved',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Customers
INSERT INTO customers (full_name, email, phone, city, account_balance)
VALUES
('Ali Veli', 'ali@example.com', '0501234567', 'Baku', 150.00),
('Aysel Mammadova', 'aysel@example.com', '0509876543', 'Ganja', 300.00),
('Elvin Hasanov', 'elvin@example.com', '0511112222', 'Baku', 50.00);

-- Products
INSERT INTO products (name, category, price)
VALUES
('iPhone 13', 'Electronics', 1200.00),
('Galaxy Phone', 'Electronics', 1000.00),
('Laptop Pro', 'Electronics', 2000.00);

-- Orders
INSERT INTO orders (customer_id, order_date, city)
VALUES
(1, '2024-02-01', 'Baku'),
(2, '2024-03-15', 'Ganja'),
(3, '2023-12-10', 'Baku');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity)
VALUES
(1, 1, 1),
(2, 2, 2),
(2, 3, 1);

-- Payments
INSERT INTO payments (order_id, amount, payment_date)
VALUES
(1, 1200.00, '2024-02-01'),
(2, 4000.00, '2024-03-15'),
(3, 0.00, '2023-12-10');

-- Complaints
INSERT INTO complaints (customer_id, complaint_text)
VALUES
(1, 'Product was damaged'),
(2, 'Delivery was late'),
(1, 'Wrong color');

SELECT full_name,phone FROM customers;

SELECT full_name,phone
FROM customers
WHERE city = 'Baku';

SELECT * FROM products
         WHERE name LIKE  '%Phone%';

SELECT * FROM customers
         WHERE customer_id IN (
         SELECT customer_id FROM orders WHERE order_date > '2024-01-01');

SELECT * FROM customers
         WHERE customer_id NOT IN (
         SELECT distinct customer_id FROM complaints);

SELECT full_name FROM customers
                 WHERE city = 'Baku' OR account_balance = '200';

SELECT * FROM products
         ORDER BY price DESC ;

SELECT * FROM products
         ORDER BY category LIKE 'E%';

UPDATE customers SET email = 'newemail@example.com'
                 WHERE customer_id = 2;

UPDATE customers
SET full_name = CASE
    WHEN customer_id = 1 THEN 'Ali Agayev'
    WHEN customer_id = 2 THEN 'Aysel Agayeva'
    ELSE full_name
END;

UPDATE complaints SET status = 'resolved' WHERE status != 'resolved';

alter table customers add column loyalty_points int default 0;

alter table customers drop column loyalty_points;

delete from customers
       WHERE customer_id = 3;

delete from orders
       WHERE order_id NOT IN (
               SELECT DISTINCT order_id FROM order_items
           );

SELECT c.full_name AS customer, cmp.complaint_text
FROM customers c
JOIN complaints cmp ON c.customer_id = cmp.customer_id;

SELECT c.full_name AS customer, o.order_id, p.amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id;

SELECT c.full_name AS customer, p.name AS product
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT p.name, COUNT(*) AS times_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
HAVING COUNT(*) > 1;


-- DROP TABLE complaints, payments, order_items, orders, products, customers;
