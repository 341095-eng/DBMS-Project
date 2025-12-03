USE swiggy_db;

-- 1. Customers
INSERT INTO customer (full_name, email, phone_no, signup_datetime, status) VALUES
('Aditi Rao', 'aditi.rao@mail.com', '9123456780', '2025-09-12 14:22:10', 'ACTIVE'),
('Kabir Khan', 'kabir.khan@mail.com', '9234567891', '2025-08-05 10:12:55', 'ACTIVE'),
('Neha Chawla', 'neha.chawla@mail.com', '9345678912', '2025-07-21 18:45:33', 'ACTIVE'),
('Imran Sheikh', 'imran.sheikh@mail.com', '9456789123', '2025-06-18 09:15:47', 'BLOCKED');

-- 2. Customer Address
INSERT INTO customer_address (customer_id, label, address_line1, address_line2, landmark, city, state, pincode, is_default) VALUES
(1, 'HOME', 'Flat 18B, RiverView Homes', NULL, 'Near ISKCON Temple', 'Bengaluru', 'Karnataka', '560078', 1),
(2, 'HOME', 'House 22, Maple Street', 'Behind Big Bazaar', 'Near Silk Board', 'Bengaluru', 'Karnataka', '560068', 1),
(3, 'WORK', 'Block 5, Infosys Campus', 'Electronic City', NULL, 'Bengaluru', 'Karnataka', '560100', 1),
(3, 'HOME', '12, Ocean Pearl Towers', 'Marine Lines', 'Opp NCPA', 'Mumbai', 'Maharashtra', '400020', 0);

-- 3. City Zones
INSERT INTO city_zone (city, zone_name) VALUES
('Bengaluru', 'Indiranagar'),
('Bengaluru', 'Electronic City'),
('Mumbai', 'Marine Lines');

-- 4. Restaurants
INSERT INTO restaurant (restaurant_name, zone_id, is_pure_veg, avg_preparation_time_mins,
                        address_line1, address_line2, pincode, opening_time, closing_time, is_active) VALUES
('Burger Town', 1, 0, 15, '80 Feet Rd, Indiranagar', NULL, '560038', '10:00:00', '23:45:00', 1),
('Madras Food House', 2, 1, 20, 'Infosys Gate 6', 'Electronic City', '560100', '07:30:00', '22:00:00', 1),
('Coastal Curry Co.', 3, 0, 28, '99, Queen’s Rd', 'Near Charni Rd', '400020', '11:00:00', '23:30:00', 1),
('Green Bowl Salads', 1, 1, 10, '12th Main, HAL 2nd Stage', NULL, '560008', '08:00:00', '21:00:00', 1);

-- 5. Cuisines
INSERT INTO cuisine (cuisine_name) VALUES
('Italian'),
('South Indian'),
('North Indian'),
('Fast Food'),
('Seafood');

-- 6. Menu Items
INSERT INTO menu_item (cuisine_id, item_name, is_veg, description, default_base_price, is_active) VALUES
(4, 'Cheese Burst Pizza', 1, 'Mozzarella loaded', 320.00, 1),
(2, 'Onion Uttapam', 1, NULL, 110.00, 1),
(3, 'Mutton Rogan Josh', 0, 'Slow cooked Kashmiri mutton', 340.00, 1),
(5, 'Prawn Coconut Curry', 0, NULL, 290.00, 1),
(4, 'Peri Peri Fries', 1, 'Spicy fries', 140.00, 1),
(1, 'Pasta Alfredo', 1, NULL, 210.00, 1),
(4, 'Chicken Burger', 0, 'Grilled + cheese', 180.00, 1),
(2, 'Plain Idli', 1, '2 pieces, steamed', 70.00, 1);

-- 7. Restaurant Menu
INSERT INTO restaurant_menu (restaurant_id, menu_item_id, item_price, is_available, avg_prep_time_mins) VALUES
(1, 1, 310.00, 1, 18),
(1, 5, 135.00, 1, 8),
(2, 2, 105.00, 1, 12),
(2, 8, 70.00, 1, 5),
(3, 4, 295.00, 1, 20),
(4, 6, 200.00, 1, 11),
(1, 7, 175.00, 0, 15),
(2, 3, 330.00, 1, 25);

-- 8. Coupons
INSERT INTO coupon (coupon_code, description, discount_type, discount_value,
                    max_discount_amt, min_order_amount, start_date, end_date,
                    usage_limit, is_active)
VALUES
('WELCOME75', 'Flat 75 off on first 3 orders', 'FLAT', 75.00, 75.00, 199.00, 
 '2025-04-01', '2025-12-31', 2000, 1),
('FEST20', '20% off upto 100 on festive orders', 'PERCENT', 20.00, 100.00, 299.00,
 '2025-10-01', '2025-10-31', 3000, 0);

-- 9. Customer Coupon Usage
INSERT INTO customer_coupon_usage (customer_id, coupon_id, usage_count) VALUES
(1, 1, 1),
(2, 1, 3),
(3, 2, 1);

-- 10. Food Orders
INSERT INTO food_order (customer_id, address_id, restaurant_id, coupon_id, order_status,
                        scheduled_delivery_time, order_datetime, subtotal_amount,
                        delivery_fee, platform_fee, discount_amount, total_payable)
VALUES
(1, 1, 1, 1, 'DELIVERED', '2025-11-28 15:40:00', '2025-11-28 15:15:00',
 450.00, 25.00, 8.00, 75.00, 408.00),

(2, 2, 2, NULL, 'OUT_FOR_DELIVERY', '2025-11-29 12:20:00', '2025-11-29 11:55:12',
 280.00, 20.00, 7.00, 0.00, 307.00),

(3, 3, 3, NULL, 'PLACED', NULL, '2025-12-02 09:12:44',
 600.00, 30.00, 9.00, 0.00, 639.00),

(1, 2, 4, NULL, 'CONFIRMED', '2025-12-01 19:50:00', '2025-12-01 19:20:00',
 210.00, 20.00, 5.00, 0.00, 235.00);

-- 11. Order Items
INSERT INTO order_item (order_id, menu_item_id, quantity, item_price, line_total) VALUES
(1, 1, 1, 310.00, 310.00),
(1, 5, 1, 135.00, 135.00),
(2, 2, 2, 105.00, 210.00),
(3, 4, 1, 295.00, 295.00),
(3, 8, 3, 70.00, 210.00),
(4, 6, 1, 200.00, 200.00);

-- 12. Payments
INSERT INTO payment (order_id, payment_method, payment_status, transaction_ref, paid_amount, payment_datetime)
VALUES
(1, 'CARD', 'SUCCESS', 'SW_PAY_CARD_01', 408.00, '2025-11-28 15:16:10'),
(2, 'WALLET', 'SUCCESS', 'SW_PAY_WALLET_05', 307.00, '2025-11-29 11:57:00'),
(3, 'UPI', 'FAILED', 'SW_PAY_UPI_33', 639.00, '2025-12-02 09:15:10'),
(4, 'COD', 'PENDING', NULL, 235.00, '2025-12-01 19:22:12');

-- 13. Delivery Partners
INSERT INTO delivery_partner (full_name, phone_no, vehicle_type, current_zone_id, is_active)
VALUES
('Sunil Dash', '8001234501', 'CYCLE', 1, 1),
('Farah Speed', '7002234502', 'BIKE', 2, 1),
('Rohan Flash', '9003234503', 'SCOOTER', 3, 1);

-- 14. Delivery Assignments
INSERT INTO delivery_assignment (order_id, partner_id, assigned_at, picked_at, delivered_at, status)
VALUES
(1, 1, '2025-11-28 15:14:00', '2025-11-28 15:25:10', '2025-11-28 15:39:55', 'DELIVERED'),
(2, 2, '2025-11-29 11:56:00', '2025-11-29 12:05:10', NULL, 'PICKED'),
(3, 3, '2025-12-02 09:13:40', NULL, NULL, 'ASSIGNED');

-- 15. Order Ratings
INSERT INTO order_rating (order_id, customer_id, restaurant_rating, delivery_rating, comments, created_at)
VALUES
(1, 1, 4, 5, 'Packing was neat, delivery was super fast', '2025-11-28 15:50:00'),
(2, 2, 3, 4, 'Great idli but took a little extra time', '2025-11-29 12:30:22');