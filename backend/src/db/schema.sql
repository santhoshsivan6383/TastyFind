-- TastyFind MySQL Database Schema
-- Production-minded relational schema for Food Discovery and Bayesian Dish Rankings

CREATE DATABASE IF NOT EXISTS `tastyfind_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `tastyfind_db`;

-- Drop existing tables in reverse dependency order if migrating
DROP TABLE IF EXISTS `restaurant_ordering_links`;
DROP TABLE IF EXISTS `saved_items`;
DROP TABLE IF EXISTS `reviews`;
DROP TABLE IF EXISTS `dishes`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `restaurants`;
DROP TABLE IF EXISTS `towns`;

-- 1. Towns Table
CREATE TABLE `towns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100) NOT NULL DEFAULT 'India',
  `latitude` DECIMAL(10, 7) NULL,
  `longitude` DECIMAL(10, 7) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_town_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Categories Table
CREATE TABLE `categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(100) NOT NULL UNIQUE,
  `image_url` VARCHAR(500) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_category_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Restaurants Table
CREATE TABLE `restaurants` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `town_id` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL,
  `address` VARCHAR(255) NOT NULL,
  `latitude` DECIMAL(10, 7) NOT NULL,
  `longitude` DECIMAL(10, 7) NOT NULL,
  `phone` VARCHAR(30) NULL,
  `opening_hours` VARCHAR(100) DEFAULT '7:00 AM - 10:30 PM',
  `is_open_now` BOOLEAN DEFAULT TRUE,
  `cuisine_type` VARCHAR(100) DEFAULT 'South Indian',
  `overall_rating` DECIMAL(3, 2) DEFAULT 0.00,
  `overall_review_count` INT DEFAULT 0,
  `min_price` DECIMAL(10, 2) DEFAULT 50.00,
  `max_price` DECIMAL(10, 2) DEFAULT 120.00,
  `cover_image_url` VARCHAR(500) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`) ON DELETE CASCADE,
  INDEX `idx_restaurant_town` (`town_id`),
  INDEX `idx_restaurant_rating` (`overall_rating`),
  INDEX `idx_restaurant_geo` (`latitude`, `longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Dishes Table
CREATE TABLE `dishes` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL,
  `current_price` DECIMAL(10, 2) NULL,
  `currency` VARCHAR(10) DEFAULT 'INR',
  `dish_rating` DECIMAL(3, 2) DEFAULT 0.00,
  `dish_review_count` INT DEFAULT 0,
  `bayesian_score` DECIMAL(4, 3) DEFAULT 0.000,
  `image_url` VARCHAR(500) NULL,
  `vegetarian` BOOLEAN DEFAULT TRUE,
  `availability_status` ENUM('available', 'sold_out', 'seasonal') DEFAULT 'available',
  `badge` VARCHAR(50) NULL,
  `highlight_quote` VARCHAR(255) NULL,
  `price_verified_at` TIMESTAMP NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`) ON DELETE RESTRICT,
  INDEX `idx_dishes_restaurant` (`restaurant_id`),
  INDEX `idx_dishes_category` (`category_id`),
  INDEX `idx_dishes_rating` (`dish_rating`),
  INDEX `idx_dishes_price` (`current_price`),
  INDEX `idx_dishes_veg` (`vegetarian`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Reviews Table
CREATE TABLE `reviews` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL DEFAULT 1,
  `user_name` VARCHAR(100) NOT NULL DEFAULT 'Food Explorer',
  `user_avatar` VARCHAR(500) NULL,
  `dish_id` INT NOT NULL,
  `rating` INT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
  `review_text` TEXT NULL,
  `image_url` VARCHAR(500) NULL,
  `moderation_status` ENUM('pending', 'approved', 'rejected') DEFAULT 'approved',
  `helpful_count` INT DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`dish_id`) REFERENCES `dishes`(`id`) ON DELETE CASCADE,
  INDEX `idx_reviews_dish` (`dish_id`),
  INDEX `idx_reviews_user` (`user_id`),
  INDEX `idx_reviews_moderation` (`moderation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Saved Items Table
CREATE TABLE `saved_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL DEFAULT 1,
  `entity_type` ENUM('restaurant', 'dish') NOT NULL,
  `entity_id` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_user_saved_entity` (`user_id`, `entity_type`, `entity_id`),
  INDEX `idx_saved_user` (`user_id`, `entity_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Restaurant Ordering Links Table
CREATE TABLE `restaurant_ordering_links` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `restaurant_id` INT NOT NULL,
  `platform` ENUM('swiggy', 'zomato') NOT NULL,
  `url` VARCHAR(500) NOT NULL,
  `verification_status` ENUM('verified', 'unverified', 'broken') DEFAULT 'verified',
  `last_verified_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants`(`id`) ON DELETE CASCADE,
  UNIQUE KEY `uk_restaurant_platform` (`restaurant_id`, `platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
