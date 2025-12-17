USE swiggy_simple;

-- 1. Customers with addresses
SELECT 
    c.customer_name,
    a.city,
    a.pincode
FROM customer c
JOIN address a ON c.customer_id = a.customer_id;

-- 2. Restaurants and their menu
SELECT
    r.restaurant_name,
    f.food_name,
    f.price
FROM restaurant r
JOIN restaurant_menu rm ON r.restaurant_id = rm.restaurant_id
JOIN food_item f ON rm.food_id = f.food_id;

-- 3. Orders placed by customers
SELECT
    o.order_id,
    c.customer_name,
    r.restaurant_name,
    o.order_date,
    o.total_amount
FROM food_order o
JOIN customer c ON o.customer_id = c.customer_id
JOIN restaurant r ON o.restaurant_id = r.restaurant_id;

-- 4. Items inside each order
SELECT
    o.order_id,
    f.food_name,
    oi.quantity
FROM food_order o
JOIN order_item oi ON o.order_id = oi.order_id
JOIN food_item f ON oi.food_id = f.food_id;

-- 5. Delivery partner assigned to each order
SELECT
    o.order_id,
    d.partner_name
FROM delivery_assignment da
JOIN food_order o ON da.order_id = o.order_id
JOIN delivery_partner d ON da.partner_id = d.partner_id;

-- 6. Total orders per customer
SELECT
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customer c
JOIN food_order o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;