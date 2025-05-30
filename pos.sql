/*
 Navicat Premium Data Transfer

 Source Server         : sg
 Source Server Type    : MySQL
 Source Server Version : 50541
 Source Host           : localhost:3306
 Source Schema         : pos

 Target Server Type    : MySQL
 Target Server Version : 50541
 File Encoding         : 65001

 Date: 31/05/2025 00:47:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `phone` varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `address` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for inventory_batches
-- ----------------------------
DROP TABLE IF EXISTS `inventory_batches`;
CREATE TABLE `inventory_batches`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `quantity` decimal(10, 2) NOT NULL,
  `cost_price` decimal(10, 2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `discount` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product`(`product_id`) USING BTREE,
  INDEX `fk_purchase`(`purchase_id`) USING BTREE,
  CONSTRAINT `fk_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `barcode` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `hsn_code` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `brand_id` int(11) NULL DEFAULT NULL,
  `unit` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'pcs',
  `price` decimal(10, 2) NOT NULL,
  `is_taxable` enum('YES','NO') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'YES',
  `tax_rate` decimal(5, 2) NULL DEFAULT 18.00,
  `status` enum('AVAILABLE','NOT AVAILABLE') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'AVAILABLE',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sku`(`sku`) USING BTREE,
  UNIQUE INDEX `barcode`(`barcode`) USING BTREE,
  INDEX `category_id`(`category_id`) USING BTREE,
  INDEX `brand_id`(`brand_id`) USING BTREE,
  INDEX `idx_product_name`(`name`) USING BTREE,
  INDEX `idx_product_sku`(`sku`) USING BTREE,
  INDEX `idx_product_barcode`(`barcode`) USING BTREE,
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for purchase_items
-- ----------------------------
DROP TABLE IF EXISTS `purchase_items`;
CREATE TABLE `purchase_items`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10, 2) NOT NULL,
  `cost_price` decimal(10, 2) NOT NULL,
  `discount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `purchase_id`(`purchase_id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `purchase_items_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `purchase_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Table structure for purchases
-- ----------------------------
DROP TABLE IF EXISTS `purchases`;
CREATE TABLE `purchases`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supplier_id` int(11) NOT NULL,
  `invoice_number` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `purchase_date` date NOT NULL,
  `total_amount` decimal(12, 2) NULL DEFAULT NULL,
  `created_by` int(11) NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invoice_number`(`invoice_number`) USING BTREE,
  INDEX `supplier_id`(`supplier_id`) USING BTREE,
  INDEX `created_by`(`created_by`) USING BTREE,
  INDEX `idx_purchase_date`(`purchase_date`) USING BTREE,
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `purchases_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sale_items
-- ----------------------------
DROP TABLE IF EXISTS `sale_items`;
CREATE TABLE `sale_items`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10, 2) NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `tax_rate` decimal(5, 2) NULL DEFAULT 0.00,
  `discount` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `cogs` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sale_id`(`sale_id`) USING BTREE,
  INDEX `product_id`(`product_id`) USING BTREE,
  CONSTRAINT `sale_items_ibfk_1` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sale_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for sales
-- ----------------------------
DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NULL DEFAULT NULL,
  `invoice_number` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `sale_date` date NOT NULL,
  `total_amount` decimal(12, 2) NULL DEFAULT NULL,
  `discount` decimal(10, 2) NULL DEFAULT 0.00,
  `tax` decimal(10, 2) NULL DEFAULT 0.00,
  `net_amount` decimal(12, 2) NULL DEFAULT NULL,
  `created_by` int(11) NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `customer_id`(`customer_id`) USING BTREE,
  INDEX `created_by`(`created_by`) USING BTREE,
  INDEX `idx_sale_date`(`sale_date`) USING BTREE,
  INDEX `idx_invoice_number`(`invoice_number`) USING BTREE,
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for stock
-- ----------------------------
DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10, 2) NULL DEFAULT 0.00,
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_stock_product`(`product_id`) USING BTREE,
  CONSTRAINT `stock_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `phone` varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `address` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `role` enum('admin','cashier') CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT 'cashier',
  `status` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Compact;

-- ----------------------------
-- View structure for sales_invoice_view
-- ----------------------------
DROP VIEW IF EXISTS `sales_invoice_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `sales_invoice_view` AS SELECT
    c.name           AS customer_name,
    c.phone          AS mobile,
    s.invoice_number AS bill_no,
    s.created_at     AS bill_date,
    p.name           AS product_name,

    si.price         AS price_inclusive_per_item,
    si.quantity      AS qty,

    -- Base price per item (excluding tax)
    ROUND(si.price / 1.18, 2) AS base_price_per_item,

    -- Gross amount before discount (base price × qty)
    ROUND((si.price / 1.18) * si.quantity, 2) AS gross_total,

    -- Discount amount (on base value)
    ROUND((si.price / 1.18) * si.quantity * (si.discount / 100), 2) AS discount_amount,

    -- Net base amount after discount
    ROUND((si.price / 1.18) * si.quantity * (1 - si.discount / 100), 2) AS net_base_amount,

    -- Tax amount extracted from final (discounted) inclusive total
    ROUND(
        si.price * si.quantity * (1 - si.discount / 100) -
        ((si.price / 1.18) * si.quantity * (1 - si.discount / 100)),
        2
    ) AS tax_amount,

    -- Final payable amount after discount (still tax-inclusive)
    ROUND(si.price * si.quantity * (1 - si.discount / 100), 2) AS total_amount

FROM
    sales s
    JOIN customer   c  ON s.customer_id = c.id
    JOIN sale_items si ON s.id         = si.sale_id
    JOIN product    p  ON si.product_id = p.id

ORDER BY
    s.invoice_number,
    p.name ;

-- ----------------------------
-- Triggers structure for table brand
-- ----------------------------
DROP TRIGGER IF EXISTS `before_brand_insert`;
delimiter ;;
CREATE TRIGGER `before_brand_insert` BEFORE INSERT ON `brand` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table brand
-- ----------------------------
DROP TRIGGER IF EXISTS `before_brand_update`;
delimiter ;;
CREATE TRIGGER `before_brand_update` BEFORE UPDATE ON `brand` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table category
-- ----------------------------
DROP TRIGGER IF EXISTS `before_category_insert`;
delimiter ;;
CREATE TRIGGER `before_category_insert` BEFORE INSERT ON `category` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.description IS NOT NULL THEN
    SET NEW.description = UPPER(NEW.description);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table category
-- ----------------------------
DROP TRIGGER IF EXISTS `before_category_update`;
delimiter ;;
CREATE TRIGGER `before_category_update` BEFORE UPDATE ON `category` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.description IS NOT NULL THEN
    SET NEW.description = UPPER(NEW.description);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table customer
-- ----------------------------
DROP TRIGGER IF EXISTS `before_customer_insert`;
delimiter ;;
CREATE TRIGGER `before_customer_insert` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.phone IS NOT NULL THEN
    SET NEW.phone = UPPER(NEW.phone);
  END IF;
  IF NEW.email IS NOT NULL THEN
    SET NEW.email = UPPER(NEW.email);
  END IF;
  IF NEW.address IS NOT NULL THEN
    SET NEW.address = UPPER(NEW.address);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table customer
-- ----------------------------
DROP TRIGGER IF EXISTS `before_customer_update`;
delimiter ;;
CREATE TRIGGER `before_customer_update` BEFORE UPDATE ON `customer` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.phone IS NOT NULL THEN
    SET NEW.phone = UPPER(NEW.phone);
  END IF;
  IF NEW.email IS NOT NULL THEN
    SET NEW.email = UPPER(NEW.email);
  END IF;
  IF NEW.address IS NOT NULL THEN
    SET NEW.address = UPPER(NEW.address);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `before_product_insert`;
delimiter ;;
CREATE TRIGGER `before_product_insert` BEFORE INSERT ON `product` FOR EACH ROW BEGIN
  SET NEW.sku = UPPER(NEW.sku);
  SET NEW.name = UPPER(NEW.name);
  IF NEW.barcode IS NOT NULL THEN
    SET NEW.barcode = UPPER(NEW.barcode);
  END IF;
  IF NEW.unit IS NOT NULL THEN
    SET NEW.unit = UPPER(NEW.unit);
  END IF;
  IF NEW.status IS NOT NULL THEN
    SET NEW.status = UPPER(NEW.status);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `before_product_update`;
delimiter ;;
CREATE TRIGGER `before_product_update` BEFORE UPDATE ON `product` FOR EACH ROW BEGIN
  SET NEW.sku = UPPER(NEW.sku);
  SET NEW.name = UPPER(NEW.name);
  IF NEW.barcode IS NOT NULL THEN
    SET NEW.barcode = UPPER(NEW.barcode);
  END IF;
  IF NEW.unit IS NOT NULL THEN
    SET NEW.unit = UPPER(NEW.unit);
  END IF;
  IF NEW.status IS NOT NULL THEN
    SET NEW.status = UPPER(NEW.status);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `before_purchases_insert`;
delimiter ;;
CREATE TRIGGER `before_purchases_insert` BEFORE INSERT ON `purchases` FOR EACH ROW BEGIN
  SET NEW.invoice_number = UPPER(NEW.invoice_number);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table purchases
-- ----------------------------
DROP TRIGGER IF EXISTS `before_purchases_update`;
delimiter ;;
CREATE TRIGGER `before_purchases_update` BEFORE UPDATE ON `purchases` FOR EACH ROW BEGIN
  SET NEW.invoice_number = UPPER(NEW.invoice_number);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table sales
-- ----------------------------
DROP TRIGGER IF EXISTS `before_sales_insert`;
delimiter ;;
CREATE TRIGGER `before_sales_insert` BEFORE INSERT ON `sales` FOR EACH ROW BEGIN
  SET NEW.invoice_number = UPPER(NEW.invoice_number);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table sales
-- ----------------------------
DROP TRIGGER IF EXISTS `before_sales_update`;
delimiter ;;
CREATE TRIGGER `before_sales_update` BEFORE UPDATE ON `sales` FOR EACH ROW BEGIN
  SET NEW.invoice_number = UPPER(NEW.invoice_number);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table supplier
-- ----------------------------
DROP TRIGGER IF EXISTS `before_supplier_insert`;
delimiter ;;
CREATE TRIGGER `before_supplier_insert` BEFORE INSERT ON `supplier` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.phone IS NOT NULL THEN
    SET NEW.phone = UPPER(NEW.phone);
  END IF;
  IF NEW.email IS NOT NULL THEN
    SET NEW.email = UPPER(NEW.email);
  END IF;
  IF NEW.address IS NOT NULL THEN
    SET NEW.address = UPPER(NEW.address);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table supplier
-- ----------------------------
DROP TRIGGER IF EXISTS `before_supplier_update`;
delimiter ;;
CREATE TRIGGER `before_supplier_update` BEFORE UPDATE ON `supplier` FOR EACH ROW BEGIN
  SET NEW.name = UPPER(NEW.name);
  IF NEW.phone IS NOT NULL THEN
    SET NEW.phone = UPPER(NEW.phone);
  END IF;
  IF NEW.email IS NOT NULL THEN
    SET NEW.email = UPPER(NEW.email);
  END IF;
  IF NEW.address IS NOT NULL THEN
    SET NEW.address = UPPER(NEW.address);
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `before_user_insert`;
delimiter ;;
CREATE TRIGGER `before_user_insert` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
  SET NEW.role = UPPER(NEW.role);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `before_user_update`;
delimiter ;;
CREATE TRIGGER `before_user_update` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
  SET NEW.role = UPPER(NEW.role);
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
