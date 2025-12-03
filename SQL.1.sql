-- SCRIPT 1: DDL - Swiggy Food Delivery DB
-- =======================================

DROP DATABASE IF EXISTS swiggy_db;
CREATE DATABASE swiggy_db;
USE swiggy_db;

-- 1. CUSTOMER & ADDRESS
-- ---------------------------------------

CREATE TABLE customer (
    customer_id       BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(80)        NOT NULL,
    email             VARCHAR(120)       NOT NULL UNIQUE,
    phone_no          CHAR(10)           NOT NULL UNIQUE,
    signup_datetime   DATETIME           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status            ENUM('ACTIVE','BLOCKED','DELETED') DEFAULT 'ACTIVE'
) ENGINE = InnoDB;

CREATE TABLE customer_address (
    address_id        INT UNSIGNED AUTO_INCREMENT,
    customer_id       BIGINT UNSIGNED   NOT NULL,
    label             ENUM('HOME','WORK','OTHER') DEFAULT 'HOME',
    address_line1     VARCHAR(120)      NOT NULL,
    address_line2     VARCHAR(120)      NULL,
    landmark          VARCHAR(100)      NULL,
    city              VARCHAR(60)       NOT NULL,
    state             VARCHAR(40)       NOT NULL,
    pincode           CHAR(6)           NOT NULL,
    is_default        TINYINT(1)        NOT NULL DEFAULT 0,
    PRIMARY KEY (address_id),
    CONSTRAINT fk_sw_customer_address_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- 2. CITY ZONES & RESTAURANTS
-- ---------------------------------------

CREATE TABLE city_zone (
    zone_id           SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    city              VARCHAR(60)       NOT NULL,
    zone_name         VARCHAR(60)       NOT NULL,
    UNIQUE (city, zone_name)
) ENGINE = InnoDB;

CREATE TABLE restaurant (
    restaurant_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    restaurant_name   VARCHAR(100)      NOT NULL,
    zone_id           SMALLINT UNSIGNED NOT NULL,
    is_pure_veg       TINYINT(1)        NOT NULL DEFAULT 0,
    avg_preparation_time_mins TINYINT UNSIGNED DEFAULT 20,
    address_line1     VARCHAR(120)      NOT NULL,
    address_line2     VARCHAR(120)      NULL,
    pincode           CHAR(6)           NOT NULL,
    opening_time      TIME              NOT NULL,
    closing_time      TIME              NOT NULL,
    is_active         TINYINT(1)        NOT NULL DEFAULT 1,
    CONSTRAINT fk_restaurant_zone
        FOREIGN KEY (zone_id) REFERENCES city_zone(zone_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- 3. CUISINE, MENU ITEMS, RESTAURANT MENU
-- ---------------------------------------

CREATE TABLE cuisine (
    cuisine_id        SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cuisine_name      VARCHAR(60)       NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE menu_item (
    menu_item_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cuisine_id        SMALLINT UNSIGNED NOT NULL,
    item_name         VARCHAR(120)      NOT NULL,
    is_veg            TINYINT(1)        NOT NULL DEFAULT 1,
    description       VARCHAR(255)      NULL,
    default_base_price DECIMAL(8,2)     NOT NULL,
    is_active         TINYINT(1)        NOT NULL DEFAULT 1,
    CONSTRAINT fk_menuitem_cuisine
        FOREIGN KEY (cuisine_id) REFERENCES cuisine(cuisine_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE restaurant_menu (
    restaurant_id     INT UNSIGNED      NOT NULL,
    menu_item_id      BIGINT UNSIGNED   NOT NULL,
    item_price        DECIMAL(8,2)      NOT NULL,
    is_available      TINYINT(1)        NOT NULL DEFAULT 1,
    avg_prep_time_mins TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (restaurant_id, menu_item_id),
    CONSTRAINT fk_rest_menu_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_rest_menu_item
        FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB;

-- 4. COUPONS & USAGE
-- ---------------------------------------

CREATE TABLE coupon (
    coupon_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    coupon_code       VARCHAR(20)       NOT NULL UNIQUE,
    description       VARCHAR(120)      NULL,
    discount_type     ENUM('FLAT','PERCENT') NOT NULL,
    discount_value    DECIMAL(6,2)      NOT NULL,
    max_discount_amt  DECIMAL(6,2)      NULL,
    min_order_amount  DECIMAL(8,2)      NULL,
    start_date        DATE              NOT NULL,
    end_date          DATE              NOT NULL,
    usage_limit       INT UNSIGNED      NULL,
    is_active         TINYINT(1)        NOT NULL DEFAULT 1
) ENGINE = InnoDB;

CREATE TABLE customer_coupon_usage (
    customer_id       BIGINT UNSIGNED   NOT NULL,
    coupon_id         INT UNSIGNED      NOT NULL,
    usage_count       SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (customer_id, coupon_id),
    CONSTRAINT fk_sw_ccu_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sw_ccu_coupon
        FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- 5. FOOD ORDER & ORDER ITEMS
-- ---------------------------------------

CREATE TABLE food_order (
    order_id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id       BIGINT UNSIGNED   NOT NULL,
    address_id        INT UNSIGNED      NOT NULL,
    restaurant_id     INT UNSIGNED      NOT NULL,
    coupon_id         INT UNSIGNED      NULL,
    order_status      ENUM('PLACED','CONFIRMED','PREPARING','OUT_FOR_DELIVERY',
                           'DELIVERED','CANCELLED') NOT NULL DEFAULT 'PLACED',
    order_datetime    DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    scheduled_delivery_time DATETIME    NULL,
    subtotal_amount   DECIMAL(10,2)     NOT NULL DEFAULT 0.00,
    delivery_fee      DECIMAL(8,2)      NOT NULL DEFAULT 0.00,
    platform_fee      DECIMAL(6,2)      NOT NULL DEFAULT 0.00,
    discount_amount   DECIMAL(8,2)      NOT NULL DEFAULT 0.00,
    total_payable     DECIMAL(10,2)     NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_sw_order_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_sw_order_address
        FOREIGN KEY (address_id) REFERENCES customer_address(address_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_sw_order_restaurant
        FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_sw_order_coupon
        FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
        ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE order_item (
    order_id          BIGINT UNSIGNED   NOT NULL,
    menu_item_id      BIGINT UNSIGNED   NOT NULL,
    quantity          SMALLINT UNSIGNED NOT NULL,
    item_price        DECIMAL(8,2)      NOT NULL,
    line_total        DECIMAL(10,2)     NOT NULL,
    PRIMARY KEY (order_id, menu_item_id),
    CONSTRAINT fk_sw_orderitem_order
        FOREIGN KEY (order_id) REFERENCES food_order(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sw_orderitem_menuitem
        FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id)
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 6. PAYMENT
-- ---------------------------------------

CREATE TABLE payment (
    payment_id        BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id          BIGINT UNSIGNED   NOT NULL,
    payment_method    ENUM('UPI','CARD','WALLET','COD') NOT NULL,
    payment_status    ENUM('PENDING','SUCCESS','FAILED','REFUNDED')
                                        NOT NULL DEFAULT 'PENDING',
    transaction_ref   VARCHAR(60)       NULL,
    paid_amount       DECIMAL(10,2)     NOT NULL,
    payment_datetime  DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sw_payment_order
        FOREIGN KEY (order_id) REFERENCES food_order(order_id)
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- 7. DELIVERY PARTNER & ASSIGNMENT
-- ---------------------------------------

CREATE TABLE delivery_partner (
    partner_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(80)       NOT NULL,
    phone_no          CHAR(10)          NOT NULL UNIQUE,
    vehicle_type      ENUM('BIKE','SCOOTER','CYCLE','OTHER') NOT NULL,
    current_zone_id   SMALLINT UNSIGNED NULL,
    is_active         TINYINT(1)        NOT NULL DEFAULT 1,
    CONSTRAINT fk_sw_delivery_partner_zone
        FOREIGN KEY (current_zone_id) REFERENCES city_zone(zone_id)
        ON DELETE SET NULL
) ENGINE = InnoDB;

CREATE TABLE delivery_assignment (
    assignment_id     BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id          BIGINT UNSIGNED   NOT NULL,
    partner_id        INT UNSIGNED      NOT NULL,
    assigned_at       DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    picked_at         DATETIME          NULL,
    delivered_at      DATETIME          NULL,
    status            ENUM('ASSIGNED','PICKED','DELIVERED','REALLOCATED','CANCELLED')
                                        NOT NULL DEFAULT 'ASSIGNED',
    CONSTRAINT fk_sw_da_order
        FOREIGN KEY (order_id) REFERENCES food_order(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sw_da_partner
        FOREIGN KEY (partner_id) REFERENCES delivery_partner(partner_id)
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 8. ORDER RATINGS
-- ---------------------------------------

CREATE TABLE order_rating (
    rating_id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id          BIGINT UNSIGNED   NOT NULL,
    customer_id       BIGINT UNSIGNED   NOT NULL,
    restaurant_rating TINYINT UNSIGNED  NULL,
    delivery_rating   TINYINT UNSIGNED  NULL,
    comments          VARCHAR(255)      NULL,
    created_at        DATETIME          NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sw_rating_order
        FOREIGN KEY (order_id) REFERENCES food_order(order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_sw_rating_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON DELETE CASCADE
) ENGINE = InnoDB;