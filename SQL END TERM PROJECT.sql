-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema swiggy_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema swiggy_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `swiggy_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `swiggy_db` ;

-- -----------------------------------------------------
-- Table `swiggy_db`.`city_zone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`city_zone` (
  `zone_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(60) NOT NULL,
  `zone_name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`zone_id`),
  UNIQUE INDEX `city` (`city` ASC, `zone_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`coupon` (
  `coupon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `coupon_code` VARCHAR(20) NOT NULL,
  `description` VARCHAR(120) NULL DEFAULT NULL,
  `discount_type` ENUM('FLAT', 'PERCENT') NOT NULL,
  `discount_value` DECIMAL(6,2) NOT NULL,
  `max_discount_amt` DECIMAL(6,2) NULL DEFAULT NULL,
  `min_order_amount` DECIMAL(8,2) NULL DEFAULT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `usage_limit` INT UNSIGNED NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`coupon_id`),
  UNIQUE INDEX `coupon_code` (`coupon_code` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`cuisine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`cuisine` (
  `cuisine_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cuisine_name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`cuisine_id`),
  UNIQUE INDEX `cuisine_name` (`cuisine_name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`customer` (
  `customer_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(80) NOT NULL,
  `email` VARCHAR(120) NOT NULL,
  `phone_no` CHAR(10) NOT NULL,
  `signup_datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('ACTIVE', 'BLOCKED', 'DELETED') NULL DEFAULT 'ACTIVE',
  PRIMARY KEY (`customer_id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_no` (`phone_no` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`customer_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`customer_address` (
  `address_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `label` ENUM('HOME', 'WORK', 'OTHER') NULL DEFAULT 'HOME',
  `address_line1` VARCHAR(120) NOT NULL,
  `address_line2` VARCHAR(120) NULL DEFAULT NULL,
  `landmark` VARCHAR(100) NULL DEFAULT NULL,
  `city` VARCHAR(60) NOT NULL,
  `state` VARCHAR(40) NOT NULL,
  `pincode` CHAR(6) NOT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`address_id`),
  INDEX `fk_sw_customer_address_customer` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_customer_address_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_db`.`customer` (`customer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`customer_coupon_usage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`customer_coupon_usage` (
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `coupon_id` INT UNSIGNED NOT NULL,
  `usage_count` SMALLINT UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`customer_id`, `coupon_id`),
  INDEX `fk_sw_ccu_coupon` (`coupon_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_ccu_coupon`
    FOREIGN KEY (`coupon_id`)
    REFERENCES `swiggy_db`.`coupon` (`coupon_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_sw_ccu_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_db`.`customer` (`customer_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`restaurant` (
  `restaurant_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_name` VARCHAR(100) NOT NULL,
  `zone_id` SMALLINT UNSIGNED NOT NULL,
  `is_pure_veg` TINYINT(1) NOT NULL DEFAULT '0',
  `avg_preparation_time_mins` TINYINT UNSIGNED NULL DEFAULT '20',
  `address_line1` VARCHAR(120) NOT NULL,
  `address_line2` VARCHAR(120) NULL DEFAULT NULL,
  `pincode` CHAR(6) NOT NULL,
  `opening_time` TIME NOT NULL,
  `closing_time` TIME NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`restaurant_id`),
  INDEX `fk_restaurant_zone` (`zone_id` ASC) VISIBLE,
  CONSTRAINT `fk_restaurant_zone`
    FOREIGN KEY (`zone_id`)
    REFERENCES `swiggy_db`.`city_zone` (`zone_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`food_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`food_order` (
  `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `address_id` INT UNSIGNED NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `coupon_id` INT UNSIGNED NULL DEFAULT NULL,
  `order_status` ENUM('PLACED', 'CONFIRMED', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PLACED',
  `order_datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `scheduled_delivery_time` DATETIME NULL DEFAULT NULL,
  `subtotal_amount` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  `delivery_fee` DECIMAL(8,2) NOT NULL DEFAULT '0.00',
  `platform_fee` DECIMAL(6,2) NOT NULL DEFAULT '0.00',
  `discount_amount` DECIMAL(8,2) NOT NULL DEFAULT '0.00',
  `total_payable` DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`order_id`),
  INDEX `fk_sw_order_customer` (`customer_id` ASC) VISIBLE,
  INDEX `fk_sw_order_address` (`address_id` ASC) VISIBLE,
  INDEX `fk_sw_order_restaurant` (`restaurant_id` ASC) VISIBLE,
  INDEX `fk_sw_order_coupon` (`coupon_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_order_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `swiggy_db`.`customer_address` (`address_id`)
    ON DELETE RESTRICT,
  CONSTRAINT `fk_sw_order_coupon`
    FOREIGN KEY (`coupon_id`)
    REFERENCES `swiggy_db`.`coupon` (`coupon_id`)
    ON DELETE SET NULL,
  CONSTRAINT `fk_sw_order_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_db`.`customer` (`customer_id`)
    ON DELETE RESTRICT,
  CONSTRAINT `fk_sw_order_restaurant`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `swiggy_db`.`restaurant` (`restaurant_id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`delivery_partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`delivery_partner` (
  `partner_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(80) NOT NULL,
  `phone_no` CHAR(10) NOT NULL,
  `vehicle_type` ENUM('BIKE', 'SCOOTER', 'CYCLE', 'OTHER') NOT NULL,
  `current_zone_id` SMALLINT UNSIGNED NULL DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`partner_id`),
  UNIQUE INDEX `phone_no` (`phone_no` ASC) VISIBLE,
  INDEX `fk_sw_delivery_partner_zone` (`current_zone_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_delivery_partner_zone`
    FOREIGN KEY (`current_zone_id`)
    REFERENCES `swiggy_db`.`city_zone` (`zone_id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`delivery_assignment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`delivery_assignment` (
  `assignment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `partner_id` INT UNSIGNED NOT NULL,
  `assigned_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picked_at` DATETIME NULL DEFAULT NULL,
  `delivered_at` DATETIME NULL DEFAULT NULL,
  `status` ENUM('ASSIGNED', 'PICKED', 'DELIVERED', 'REALLOCATED', 'CANCELLED') NOT NULL DEFAULT 'ASSIGNED',
  PRIMARY KEY (`assignment_id`),
  INDEX `fk_sw_da_order` (`order_id` ASC) VISIBLE,
  INDEX `fk_sw_da_partner` (`partner_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_da_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_db`.`food_order` (`order_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_sw_da_partner`
    FOREIGN KEY (`partner_id`)
    REFERENCES `swiggy_db`.`delivery_partner` (`partner_id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`menu_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`menu_item` (
  `menu_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cuisine_id` SMALLINT UNSIGNED NOT NULL,
  `item_name` VARCHAR(120) NOT NULL,
  `is_veg` TINYINT(1) NOT NULL DEFAULT '1',
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `default_base_price` DECIMAL(8,2) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`menu_item_id`),
  INDEX `fk_menuitem_cuisine` (`cuisine_id` ASC) VISIBLE,
  CONSTRAINT `fk_menuitem_cuisine`
    FOREIGN KEY (`cuisine_id`)
    REFERENCES `swiggy_db`.`cuisine` (`cuisine_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`order_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`order_item` (
  `order_id` BIGINT UNSIGNED NOT NULL,
  `menu_item_id` BIGINT UNSIGNED NOT NULL,
  `quantity` SMALLINT UNSIGNED NOT NULL,
  `item_price` DECIMAL(8,2) NOT NULL,
  `line_total` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_id`, `menu_item_id`),
  INDEX `fk_sw_orderitem_menuitem` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_orderitem_menuitem`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `swiggy_db`.`menu_item` (`menu_item_id`)
    ON DELETE RESTRICT,
  CONSTRAINT `fk_sw_orderitem_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_db`.`food_order` (`order_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`order_rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`order_rating` (
  `rating_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `restaurant_rating` TINYINT UNSIGNED NULL DEFAULT NULL,
  `delivery_rating` TINYINT UNSIGNED NULL DEFAULT NULL,
  `comments` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  INDEX `fk_sw_rating_order` (`order_id` ASC) VISIBLE,
  INDEX `fk_sw_rating_customer` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_rating_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_db`.`customer` (`customer_id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_sw_rating_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_db`.`food_order` (`order_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`payment` (
  `payment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` BIGINT UNSIGNED NOT NULL,
  `payment_method` ENUM('UPI', 'CARD', 'WALLET', 'COD') NOT NULL,
  `payment_status` ENUM('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
  `transaction_ref` VARCHAR(60) NULL DEFAULT NULL,
  `paid_amount` DECIMAL(10,2) NOT NULL,
  `payment_datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  INDEX `fk_sw_payment_order` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_sw_payment_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_db`.`food_order` (`order_id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_db`.`restaurant_menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_db`.`restaurant_menu` (
  `restaurant_id` INT UNSIGNED NOT NULL,
  `menu_item_id` BIGINT UNSIGNED NOT NULL,
  `item_price` DECIMAL(8,2) NOT NULL,
  `is_available` TINYINT(1) NOT NULL DEFAULT '1',
  `avg_prep_time_mins` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`restaurant_id`, `menu_item_id`),
  INDEX `fk_rest_menu_item` (`menu_item_id` ASC) VISIBLE,
  CONSTRAINT `fk_rest_menu_item`
    FOREIGN KEY (`menu_item_id`)
    REFERENCES `swiggy_db`.`menu_item` (`menu_item_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rest_menu_restaurant`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `swiggy_db`.`restaurant` (`restaurant_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
