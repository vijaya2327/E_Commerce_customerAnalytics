
============================================
--- E-COMMERCE ANALYTICS PROJECT
--- Database: PostgreSQL
--- Author: Vijaya Kumari
--- Description: E-Commerce Sales & Customer Analytics
============================================


--------------------------------------------
-- TABLE CREATION
--------------------------------------------

CREATE TABLE customers (
    customer_id  INT PRIMARY KEY,
    full_name    VARCHAR(100),
    email        VARCHAR(120),
    phone        VARCHAR(20),
    city         VARCHAR(100),
    created_at   TIMESTAMP
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(120),
    category     VARCHAR(60),
    mrp          DECIMAL(10,2),
    cost         DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    TIMESTAMP,
    status        VARCHAR(20),       -- Delivered / Cancelled / Returned
    payment_mode  VARCHAR(20),       -- UPI / Card / NetBanking / COD
    coupon_code   VARCHAR(30),
    shipping_city VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT,
    selling_price DECIMAL(10,2),     -- Per unit selling price after product-level discounts
    discount_pct  DECIMAL(5,2),      -- e.g., 10.00 means 10%
    FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


--------------------------------------------
-- INSERTING SAMPLE DATA
--------------------------------------------

INSERT INTO customers VALUES
(1, '  koti konda  ', 'koti.konda@gmail.com',  '+91-98765 43210', 'Hyderabad', '2025-08-01 10:20:00'),
(2, 'Jaswitha Konda','JASWITHA@GMAIL.COM',      '9876543211',      'Hyderabad', '2025-09-11 11:00:00'),
(3, 'Daniwik Konda', 'daniwik@gmail.com',       '98765-11111',     'Bengaluru', '2025-10-05 09:15:00'),
(4, 'Ayesha Khan',   'ayesha.khan@gmail.com',   '+91 99999 88888', 'Pune',      '2025-11-20 14:05:00'),
(5, 'Ravi Teja',     'ravi.teja@outlook.com',   '88888 77777',     'Chennai',   '2025-12-15 18:45:00'),
(6, 'Sita Rao',      'sita.rao@gmail.com',      '77777 66666',     'Hyderabad', '2026-01-07 08:40:00');

INSERT INTO products VALUES
(101, 'Noise Smartwatch X2',    'Wearables',   2999, 1600),
(102, 'Boat Earbuds Airdopes',  'Audio',        1999, 1100),
(103, 'Laptop Backpack 25L',    'Accessories',  1499,  700),
(104, 'Mixer Grinder 750W',     'Home',         4999, 3500),
(105, 'Running Shoes Pro',      'Fashion',      3999, 2300);

INSERT INTO orders VALUES
(5001, 1, '2026-01-02 10:10:00', 'Delivered', 'UPI',        'NEW10',  'Hyderabad'),
(5002, 1, '2026-01-18 16:35:00', 'Delivered', 'Card',        NULL,    'Hyderabad'),
(5003, 2, '2026-01-10 12:00:00', 'Cancelled', 'COD',        'NEW10',  'Hyderabad'),
(5004, 3, '2026-01-22 19:20:00', 'Delivered', 'UPI',        'FEST20', 'Bengaluru'),
(5005, 4, '2026-02-03 09:05:00', 'Delivered', 'NetBanking',  NULL,    'Pune'),
(5006, 5, '2026-02-05 13:45:00', 'Returned',  'Card',       'FEST20', 'Chennai'),
(5007, 6, '2026-02-10 20:10:00', 'Delivered', 'UPI',         NULL,    'Hyderabad'),
(5008, 3, '2026-02-11 11:30:00', 'Delivered', 'UPI',        'NEW10',  'Bengaluru');

INSERT INTO order_items VALUES
(9001, 5001, 101, 1, 2699, 10),
(9002, 5001, 103, 1, 1299,  0),
(9003, 5002, 102, 2, 1799, 10),
(9004, 5003, 105, 1, 3999,  0),
(9005, 5004, 104, 1, 4499, 10),
(9006, 5005, 101, 1, 2799,  7),
(9007, 5005, 102, 1, 1899,  5),
(9008, 5006, 103, 2, 1199, 20),
(9009, 5007, 105, 1, 3599, 10),
(9010, 5008, 102, 1, 1699, 15);


--------------------------------------------
-- A) DATA CLEANING & STRING FUNCTIONS 
--------------------------------------------

-- Q1: customer_id, cleaned name (TRIM), email in lowercase (LOWER),
--     and phone digits only using REGEXP_REPLACE
SELECT
    customer_id,
    TRIM(full_name)                              AS cleaned_name,
    LOWER(email)                                 AS cleaned_email,
    REGEXP_REPLACE(phone, '[^0-9]', '', 'g')    AS phone_digits
FROM customers;


-- Q2: Customer Tag in format CUST-<customer_id>-<CITY> using CONCAT + UPPER
SELECT
    customer_id,
    CONCAT('CUST-', customer_id, '-', UPPER(city)) AS customer_tag
FROM customers;


--------------------------------------------
-- B) NUMERIC FUNCTIONS: REVENUE, DISCOUNT, PROFIT 
--------------------------------------------

-- Q3: For each order_item compute gross_amount, discount_amount, net_amount using ROUND
SELECT
    order_item_id,
    quantity,
    selling_price,
    ROUND(quantity * selling_price, 2)                              AS gross_amount,
    ROUND(quantity * selling_price * discount_pct / 100, 2)        AS discount_amount,
    ROUND(quantity * selling_price * (1 - discount_pct / 100), 2)  AS net_amount
FROM order_items;


-- Q4: Compute profit = net_amount - (quantity * cost)
--     loss_abs = ABS(profit) only when profit is negative, else NULL
SELECT
    oi.order_item_id,
    ROUND(oi.quantity * oi.selling_price * (1 - oi.discount_pct / 100), 2)  AS net_amount,
    ROUND(oi.quantity * (oi.selling_price - p.cost), 2)                      AS profit,
    CASE
        WHEN (oi.quantity * (oi.selling_price - p.cost)) < 0
        THEN ROUND(ABS(oi.quantity * (oi.selling_price - p.cost)), 2)
        ELSE NULL
    END AS loss_abs
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;


--------------------------------------------
-- C) DATE & TIME ANALYSIS 
--------------------------------------------

-- Q5: For each order extract day, month, year and month label
SELECT
    order_id,
    EXTRACT(DAY   FROM order_date)          AS order_day,
    EXTRACT(MONTH FROM order_date)          AS order_month,
    EXTRACT(YEAR  FROM order_date)          AS order_year,
    TO_CHAR(order_date, 'Mon-YYYY')         AS month_label
FROM orders;


-- Q6: Customer tenure in days from signup to today
SELECT
    customer_id,
    full_name,
    CURRENT_DATE - DATE(created_at)         AS tenure_days
FROM customers;


-- Q7: Customers who placed an order within 7 days of signup
SELECT
    c.customer_id,
    c.full_name,
    o.order_id,
    o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= c.created_at
  AND o.order_date <= c.created_at + INTERVAL '7 days';


--------------------------------------------
-- D) AGGREGATE FUNCTIONS 
--------------------------------------------

-- Q8: Monthly KPI report (Delivered orders only)
--     Columns: month, total_orders, total_revenue (net_amount), avg_order_value
SELECT
    TO_CHAR(o.order_date, 'Mon-YYYY')                                                   AS month,
    COUNT(DISTINCT o.order_id)                                                           AS total_orders,
    SUM(ROUND(oi.quantity * oi.selling_price * (1 - oi.discount_pct / 100), 2))        AS total_revenue,
    AVG(ROUND(oi.quantity * oi.selling_price * (1 - oi.discount_pct / 100), 2))        AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY TO_CHAR(o.order_date, 'Mon-YYYY');


-- Q9: Top 3 cities by revenue (Delivered only) with unique customer count
SELECT
    o.shipping_city,
    SUM(oi.quantity * oi.selling_price)     AS revenue,
    COUNT(DISTINCT o.customer_id)           AS unique_customers
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
GROUP BY o.shipping_city
ORDER BY revenue DESC
LIMIT 3;


-- Q10: Category performance: total qty, total revenue, total profit
--      Filter categories with revenue > 5000 using HAVING
SELECT
    p.category,
    SUM(oi.quantity)                                                              AS total_qty,
    SUM(ROUND(oi.quantity * oi.selling_price * (1 - oi.discount_pct / 100), 2)) AS total_revenue,
    SUM(ROUND(oi.quantity * (oi.selling_price - p.cost), 2))                     AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
HAVING SUM(oi.quantity * oi.selling_price) > 5000;


--------------------------------------------
-- E) WINDOW FUNCTIONS 
--------------------------------------------

-- Q11: Top 3 customers by Delivered revenue using DENSE_RANK()
SELECT *
FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.selling_price)                                          AS revenue,
        DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.selling_price) DESC)        AS rank_no
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY o.customer_id
) AS ranked_customers
WHERE rank_no <= 3;


-- Q12: For each city, rank products by revenue using RANK() with PARTITION BY
SELECT
    shipping_city,
    product_name,
    revenue,
    RANK() OVER (PARTITION BY shipping_city ORDER BY revenue DESC) AS rank_no
FROM (
    SELECT
        o.shipping_city,
        p.product_name,
        SUM(oi.quantity * oi.selling_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.shipping_city, p.product_name
) AS city_product_revenue;


-- Q13: Segment customers into 4 tiers by Delivered revenue using NTILE(4)
--      Tier mapping: 1=Platinum, 2=Gold, 3=Silver, 4=Bronze
SELECT
    customer_id,
    revenue,
    CASE ntile_group
        WHEN 1 THEN 'Platinum'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        ELSE        'Bronze'
    END AS customer_tier
FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.selling_price)                                           AS revenue,
        NTILE(4) OVER (ORDER BY SUM(oi.quantity * oi.selling_price) DESC)             AS ntile_group
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Delivered'
    GROUP BY o.customer_id
) AS customer_revenue;


-- Q14: For each customer show order_date, net_order_value, previous order value (LAG),
--      difference from previous order, and next order date (LEAD)
SELECT
    o.customer_id,
    o.order_date,
    SUM(oi.quantity * oi.selling_price)                                                     AS net_order_value,
    LAG(SUM(oi.quantity * oi.selling_price))
        OVER (PARTITION BY o.customer_id ORDER BY o.order_date)                             AS prev_value,
    SUM(oi.quantity * oi.selling_price) -
        LAG(SUM(oi.quantity * oi.selling_price))
        OVER (PARTITION BY o.customer_id ORDER BY o.order_date)                             AS diff_from_prev,
    LEAD(o.order_date)
        OVER (PARTITION BY o.customer_id ORDER BY o.order_date)                             AS next_order_date
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id, o.order_date;


-- Q15: For each customer show first and last order date using FIRST_VALUE and LAST_VALUE
--      Full frame: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
SELECT
    customer_id,
    order_date,
    FIRST_VALUE(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_order_date,
    LAST_VALUE(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_order_date
FROM orders;


============================================
-- END OF PROJECT
============================================
