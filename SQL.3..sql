-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema swiggy_simple
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema swiggy_simple
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `swiggy_simple` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `swiggy_simple` ;

-- -----------------------------------------------------
-- Table `swiggy_simple`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`customer` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(50) NULL DEFAULT NULL,
  `phone_no` CHAR(10) NULL DEFAULT NULL,
  `email` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  `pincode` CHAR(6) NULL DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `address_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_simple`.`customer` (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`restaurant` (
  `restaurant_id` INT NOT NULL AUTO_INCREMENT,
  `restaurant_name` VARCHAR(60) NULL DEFAULT NULL,
  `city` VARCHAR(40) NULL DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`food_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`food_order` (
  `order_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NULL DEFAULT NULL,
  `restaurant_id` INT NULL DEFAULT NULL,
  `order_date` DATE NULL DEFAULT NULL,
  `total_amount` DECIMAL(8,2) NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `restaurant_id` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `food_order_ibfk_1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `swiggy_simple`.`customer` (`customer_id`),
  CONSTRAINT `food_order_ibfk_2`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `swiggy_simple`.`restaurant` (`restaurant_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`delivery_partner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`delivery_partner` (
  `partner_id` INT NOT NULL AUTO_INCREMENT,
  `partner_name` VARCHAR(50) NULL DEFAULT NULL,
  `phone_no` CHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`partner_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`delivery_assignment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`delivery_assignment` (
  `order_id` INT NOT NULL,
  `partner_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `partner_id` (`partner_id` ASC) VISIBLE,
  CONSTRAINT `delivery_assignment_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_simple`.`food_order` (`order_id`),
  CONSTRAINT `delivery_assignment_ibfk_2`
    FOREIGN KEY (`partner_id`)
    REFERENCES `swiggy_simple`.`delivery_partner` (`partner_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`food_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`food_item` (
  `food_id` INT NOT NULL AUTO_INCREMENT,
  `food_name` VARCHAR(60) NULL DEFAULT NULL,
  `price` DECIMAL(6,2) NULL DEFAULT NULL,
  PRIMARY KEY (`food_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`order_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`order_item` (
  `order_id` INT NOT NULL,
  `food_id` INT NOT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`, `food_id`),
  INDEX `food_id` (`food_id` ASC) VISIBLE,
  CONSTRAINT `order_item_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `swiggy_simple`.`food_order` (`order_id`),
  CONSTRAINT `order_item_ibfk_2`
    FOREIGN KEY (`food_id`)
    REFERENCES `swiggy_simple`.`food_item` (`food_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `swiggy_simple`.`restaurant_menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `swiggy_simple`.`restaurant_menu` (
  `restaurant_id` INT NOT NULL,
  `food_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_id`, `food_id`),
  INDEX `food_id` (`food_id` ASC) VISIBLE,
  CONSTRAINT `restaurant_menu_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `swiggy_simple`.`restaurant` (`restaurant_id`),
  CONSTRAINT `restaurant_menu_ibfk_2`
    FOREIGN KEY (`food_id`)
    REFERENCES `swiggy_simple`.`food_item` (`food_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
