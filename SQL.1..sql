USE swiggy_simple;

-- Customers
INSERT INTO customer (customer_name, phone_no, email) VALUES
('Ankit Mehra', '9012345678', 'ankit@gmail.com'),
('Pooja Nair', '9023456789', 'pooja@gmail.com'),
('Rahul Iyer', '9034567890', 'rahul@gmail.com');

-- Addresses
INSERT INTO address (customer_id, city, pincode) VALUES
(1, 'Delhi', '110001'),
(2, 'Mumbai', '400050'),
(3, 'Bengaluru', '560034');

-- Restaurants
INSERT INTO restaurant (restaurant_name, city) VALUES
('Spice Hub', 'Delhi'),
('South Treat', 'Bengaluru');

-- Food Items
INSERT INTO food_item (food_name, price) VALUES
('Chicken Biryani', 220.00),
('Masala Dosa', 120.00),
('Paneer Butter Masala', 200.00),
('Veg Fried Rice', 150.00);

-- Restaurant Menu
INSERT INTO restaurant_menu (restaurant_id, food_id) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4);

-- Orders
INSERT INTO food_order (customer_id, restaurant_id, order_date, total_amount) VALUES
(1, 1, '2025-03-01', 420.00),
(2, 2, '2025-03-02', 270.00),
(3, 2, '2025-03-03', 150.00);

-- Order Items
INSERT INTO order_item (order_id, food_id, quantity) VALUES
(1, 1, 1),
(1, 3, 1),
(2, 2, 2),
(3, 4, 1);

-- Delivery Partners
INSERT INTO delivery_partner (partner_name, phone_no) VALUES
('Sanjay Rider', '9111122233'),
('Aakash Delivery', '9222233344');

-- Delivery Assignment
INSERT INTO delivery_assignment (order_id, partner_id) VALUES
(1, 1),
(2, 2),
(3, 1);