<h1 align="center">🛒 E-Commerce Business Intelligence & Customer Analytics</h1>

<p>
This project simulates a real-world Data Analyst role at an e-commerce company. Using PostgreSQL, I performed end-to-end analysis covering data cleaning, revenue reporting, customer segmentation, and purchase trend analysis — all using SQL built-in functions.
</p>

<h2>📌 Project Overview</h2>
<p>
This project simulates a real-world Data Analyst role at an e-commerce company. Using PostgreSQL, I performed end-to-end analysis covering data cleaning, revenue reporting, customer segmentation, and purchase trend analysis — all using SQL built-in functions.
</p>

<h2>🎯 Business Objectives</h2>
<ul>
<li>Clean and standardize raw customer and order data</li>
<li>Generate Monthly KPI reports (revenue, orders, average order value)</li>
<li>Identify top-performing cities, products, and categories</li>
<li>Segment customers into value tiers (Platinum, Gold, Silver, Bronze)</li>
<li>Analyze customer purchase trends using advanced Window Functions</li>
</ul>

<h2>🗄️ Database Schema</h2>
<pre>
customers
│   customer_id (PK), full_name, email, phone, city, created_at
│
products
│   product_id (PK), product_name, category, mrp, cost
│
orders
│   order_id (PK), customer_id (FK), order_date, status, payment_mode, coupon_code, shipping_city
│
order_items
    order_item_id (PK), order_id (FK), product_id (FK), quantity, selling_price, discount_pct
</pre>

<h2>📂 Project Structure</h2>
<pre>
ecommerce-analytics-postgresql/
│
├── ecommerce_analytics.sql       # Main SQL file with all queries
├── README.md                     # Project documentation
└── screenshots/                  # Output screenshots (optional)
</pre>

<h2>🔍 Analysis Sections</h2>

<h3>A) Data Cleaning & String Functions</h3>
<table>
<tr><th>Task</th><th>Functions Used</th></tr>
<tr><td>Clean customer names</td><td>TRIM</td></tr>
<tr><td>Standardize email to lowercase</td><td>LOWER</td></tr>
<tr><td>Extract digits from phone numbers</td><td>REGEXP_REPLACE</td></tr>
<tr><td>Generate customer tags</td><td>CONCAT, UPPER</td></tr>
</table>

<h3>B) Numeric Functions — Revenue, Discount & Profit</h3>
<table>
<tr><th>Task</th><th>Functions Used</th></tr>
<tr><td>Compute gross, discount, net amount</td><td>ROUND</td></tr>
<tr><td>Calculate profit per order item</td><td>Arithmetic expressions</td></tr>
<tr><td>Identify loss-making items</td><td>ABS, CASE WHEN</td></tr>
</table>

<h3>C) Date & Time Analysis</h3>
<table>
<tr><th>Task</th><th>Functions Used</th></tr>
<tr><td>Extract day, month, year from orders</td><td>EXTRACT</td></tr>
<tr><td>Format month labels</td><td>TO_CHAR</td></tr>
<tr><td>Calculate customer tenure in days</td><td>CURRENT_DATE, DATE</td></tr>
<tr><td>Find orders placed within 7 days of signup</td><td>INTERVAL</td></tr>
</table>

<h3>D) Aggregate Functions — Business KPIs</h3>
<table>
<tr><th>Task</th><th>Functions Used</th></tr>
<tr><td>Monthly revenue, orders, avg order value</td><td>SUM, COUNT, AVG</td></tr>
<tr><td>Top 3 revenue-generating cities</td><td>GROUP BY, ORDER BY, LIMIT</td></tr>
<tr><td>Category-wise revenue and profit</td><td>HAVING</td></tr>
<tr><td>Unique customer count per city</td><td>COUNT(DISTINCT)</td></tr>
</table>

<h3>E) Window Functions — Advanced Analytics</h3>
<table>
<tr><th>Task</th><th>Functions Used</th></tr>
<tr><td>Top 3 customers by revenue</td><td>DENSE_RANK()</td></tr>
<tr><td>Product ranking per city</td><td>RANK() OVER (PARTITION BY)</td></tr>
<tr><td>Customer value segmentation</td><td>NTILE(4)</td></tr>
<tr><td>Purchase trend analysis</td><td>LAG(), LEAD()</td></tr>
<tr><td>First and last order tracking</td><td>FIRST_VALUE(), LAST_VALUE()</td></tr>
</table>

<h2>💡 Key Insights</h2>
<ul>
<li>Hyderabad is the top revenue-generating city with the highest number of unique customers</li>
<li>Wearables and Home categories contribute the most to overall revenue</li>
<li>Customer segmentation using NTILE(4) reveals clear Platinum-tier high-value buyers</li>
<li>LAG() analysis shows repeat customers have increasing order values over time</li>
</ul>

<h2>🛠️ Tech Stack</h2>
<ul>
<li><b>Database:</b> PostgreSQL</li>
<li><b>Language:</b> SQL</li>
<li><b>Functions:</b> String, Numeric, Date/Time, Aggregate, Window</li>
</ul>

<h2>🚀 How to Run</h2>
<ol>
<li>Open pgAdmin or any PostgreSQL client</li>
<li>Create a new database:</li>
</ol>

<pre>
CREATE DATABASE ecommerce_analytics;
</pre>

<ol start="3">
<li>Open and run ecommerce_analytics.sql section by section</li>
<li>View outputs for each query</li>
</ol>

<h2>👤 Author</h2>
<p>
Vijaya Kumari <br>
📧 [vijaya2023it@gmail.com]<br>
💼 [https://www.linkedin.com/in/vijaya-kumari-kanala-417b76318]<br>
🐙 [https://github.com/vijaya2327]
</p>

<p align="left">⭐ If you found this project helpful, feel free to star the repository!</p>
