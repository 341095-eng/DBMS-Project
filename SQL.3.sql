-- SCRIPT 3: DQL (Data Query Language)
-- OBJECTIVE: Business Analytics & Decision Support Queries for Swiggy
-- ================================================================

USE swiggy_db;

-- ---------------------------------------------------------
-- BUSINESS QUERY 1: "Restaurant Revenue Leaderboard"
-- ---------------------------------------------------------
SELECT
    r.restaurant_id,
    r.restaurant_name,
    cz.city,
    cz.zone_name,
    COUNT(o.order_id) AS Total_Orders,
    ROUND(SUM(o.total_payable), 2) AS Total_Revenue,
    ROUND(AVG(o.total_payable), 2) AS Avg_Ticket_Size
FROM restaurant r
JOIN city_zone cz ON r.zone_id = cz.zone_id
JOIN food_order o ON o.restaurant_id = r.restaurant_id
WHERE o.order_status <> 'CANCELLED'
GROUP BY r.restaurant_id, r.restaurant_name, cz.city, cz.zone_name
ORDER BY Total_Revenue DESC;

-- ---------------------------------------------------------
-- BUSINESS QUERY 2: "Cuisine Demand Insights"
-- ---------------------------------------------------------
SELECT 
    cz.city,
    cz.zone_name,
    c.cuisine_name,
    COUNT(oi.menu_item_id) AS Total_Times_Ordered
FROM food_order o
JOIN order_item oi ON o.order_id = oi.order_id
JOIN menu_item mi ON oi.menu_item_id = mi.menu_item_id
JOIN cuisine c ON mi.cuisine_id = c.cuisine_id
JOIN restaurant r ON o.restaurant_id = r.restaurant_id
JOIN city_zone cz ON r.zone_id = cz.zone_id
WHERE o.order_status IN ('CONFIRMED','PREPARING','OUT_FOR_DELIVERY','DELIVERED')
GROUP BY cz.city, cz.zone_name, c.cuisine_name
ORDER BY Total_Times_Ordered DESC;

-- ---------------------------------------------------------
-- BUSINESS QUERY 3: "Delivery Partner Efficiency Report"
-- (Fixed zone table reference -> city_zone)
-- ---------------------------------------------------------
SELECT
    dp.partner_id,
    dp.full_name AS Rider_Name,
    cz.city AS Operating_City,
    cz.zone_name AS Operating_Zone,
    COUNT(da.assignment_id) AS Orders_Assigned,
    SUM(CASE WHEN da.status = 'DELIVERED' THEN 1 ELSE 0 END) AS Orders_Delivered,
    AVG(
        CASE 
            WHEN da.delivered_at IS NOT NULL AND da.picked_at IS NOT NULL 
            THEN TIMESTAMPDIFF(MINUTE, da.picked_at, da.delivered_at)
            ELSE NULL
        END
    ) AS Avg_Delivery_Time_Minutes
FROM delivery_partner dp
LEFT JOIN city_zone cz ON dp.current_zone_id = cz.zone_id
JOIN delivery_assignment da ON dp.partner_id = da.partner_id
GROUP BY dp.partner_id, dp.full_name, cz.city, cz.zone_name
ORDER BY Orders_Delivered DESC, Avg_Delivery_Time_Minutes ASC
LIMIT 0, 1000;

-- ---------------------------------------------------------
-- BUSINESS QUERY 4: "Loyal Customer Lifetime Spend"
-- ---------------------------------------------------------
SELECT
    c.customer_id,
    c.full_name AS Customer_Name,
    c.email,
    c.phone_no,
    COUNT(o.order_id) AS Total_Orders,
    ROUND(SUM(o.total_payable), 2) AS Total_Spent,
    ROUND(AVG(o.total_payable), 2) AS Avg_Order_Spend
FROM customer c
JOIN food_order o ON c.customer_id = o.customer_id
WHERE o.order_status <> 'CANCELLED'
GROUP BY c.customer_id, c.full_name, c.email, c.phone_no
ORDER BY Total_Spent DESC;

-- ---------------------------------------------------------
-- BUSINESS QUERY 5: "Restaurant Experience Scorecard"
-- ---------------------------------------------------------
SELECT
    r.restaurant_id,
    r.restaurant_name,
    cz.city,
    cz.zone_name,
    ROUND(AVG(rt.restaurant_rating), 2) AS Avg_Food_Rating,
    ROUND(AVG(rt.delivery_rating), 2) AS Avg_Delivery_Rating,
    COUNT(rt.rating_id) AS Total_Feedbacks
FROM order_rating rt
JOIN food_order o ON rt.order_id = o.order_id
JOIN restaurant r ON o.restaurant_id = r.restaurant_id
JOIN city_zone cz ON r.zone_id = cz.zone_id
WHERE o.order_status = 'DELIVERED'
GROUP BY r.restaurant_id, r.restaurant_name, cz.city, cz.zone_name
ORDER BY Avg_Food_Rating DESC, Avg_Delivery_Rating DESC;