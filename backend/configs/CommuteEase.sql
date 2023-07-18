/*
 Navicat Premium Data Transfer

 Source Server         : user_chargemaster
 Source Server Type    : MySQL
 Source Server Version : 80028
 Source Host           : localhost:3306
 Source Schema         : project_chargemaster

 Target Server Type    : MySQL
 Target Server Version : 80028
 File Encoding         : 65001

 Date: 16/06/2023 22:25:39
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cars
-- ----------------------------
DROP TABLE IF EXISTS `cars`;
CREATE TABLE `cars`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `power_capacity` float NOT NULL,
  `power_current` float NOT NULL,
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cars
-- ----------------------------
INSERT INTO `cars` VALUES (1, 2, '', 51, 96, '1');
INSERT INTO `cars` VALUES (2, 2, '威震天', 100, 50, '1');
INSERT INTO `cars` VALUES (3, 2, '参关的调被则', 100, 50, 'USING');
INSERT INTO `cars` VALUES (4, 2, '即将注册1号车', 100, 50, 'USING');
INSERT INTO `cars` VALUES (5, 2, '即将注册1号车', 100, 50, 'USING');
INSERT INTO `cars` VALUES (6, 2, '即将注册1号车', 100, 50, 'USING');

-- ----------------------------
-- Table structure for charges
-- ----------------------------
DROP TABLE IF EXISTS `charges`;
CREATE TABLE `charges`  (
  `id` int NOT NULL,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `mode` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `state` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `total_charge` float NOT NULL,
  `total_charge_times` int NOT NULL,
  `total_charge_duration` int NOT NULL,
  `total_charge_fee` float NOT NULL,
  `total_charge_service` float NOT NULL,
  `total_fee` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of charges
-- ----------------------------
INSERT INTO `charges` VALUES (1, '1号', 'F', 'REST', 0, 0, 0, 0, 0, 0);
INSERT INTO `charges` VALUES (2, '2号', 'F', 'REST', 0, 0, 0, 0, 0, 0);
INSERT INTO `charges` VALUES (3, '3号', 'T', 'REST', 0, 0, 0, 0, 0, 0);
INSERT INTO `charges` VALUES (4, '4号', 'T', 'REST', 0, 0, 0, 0, 0, 0);
INSERT INTO `charges` VALUES (5, '5号', 'T', 'REST', 0, 0, 0, 0, 0, 0);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `car_id` int NOT NULL,
  `mode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `apply_kwh` float NOT NULL,
  `charge_kwh` float NOT NULL,
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `charge_price` float NOT NULL,
  `service_price` float NOT NULL,
  `fee` float NOT NULL,
  `create_time` datetime NOT NULL,
  `dispatch_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `charge_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `start_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `finish_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 235 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-05-31 23:52:00', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (2, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-05-31 23:53:11', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (3, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-05-31 23:57:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (4, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:18:03', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (5, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:27:43', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (6, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:32:32', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (7, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:34:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (8, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:47:19', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (9, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:49:24', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (10, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:55:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (11, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:56:28', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (12, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:57:58', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (13, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:59:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (14, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 00:59:42', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (15, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:00:09', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (16, 2, 1, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:02:44', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (17, 2, 3, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:02:57', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (18, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:06:00', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (19, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:21:25', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (20, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:22:43', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (21, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:23:29', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (22, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:26:05', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (23, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:27:03', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (24, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:29:14', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (25, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:30:49', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (26, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:32:48', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (27, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 01:33:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (28, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:15:11', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (29, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:15:13', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (30, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:20:30', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (31, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:20:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (32, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:29:13', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (33, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:29:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (34, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:29:16', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (35, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:32:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (36, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:32:18', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (37, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:32:19', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (38, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:37:51', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (39, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:37:52', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (40, 2, 2, 'F', 30, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:37:59', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (41, 2, 2, 'F', 30, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:52:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (42, 2, 2, 'F', 20, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:52:28', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (43, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:52:32', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (44, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:57:26', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (45, 2, 2, 'F', 30, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:57:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (46, 2, 2, 'F', 20, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 12:57:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (47, 2, 2, 'F', 20, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:01:47', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (48, 2, 2, 'F', 30, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:01:53', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (49, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:01:58', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (50, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:08:00', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (51, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:08:01', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (52, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:08:02', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (53, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:11:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (54, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:11:18', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (55, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:11:19', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (56, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:14:32', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (57, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:14:33', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (58, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:14:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (59, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:16:32', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (60, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:16:33', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (61, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:16:34', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (62, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 13:16:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (63, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:42:16', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (64, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:42:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (65, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:42:18', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (66, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:42:19', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (67, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:43:05', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (68, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:43:06', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (69, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:43:06', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (70, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:43:08', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (71, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:48:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (72, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:48:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (73, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:48:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (74, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:56:00', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (75, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:56:18', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (76, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 18:56:19', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (77, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:00:13', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (78, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:00:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (79, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:00:16', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (80, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:00:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (81, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:05:50', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (82, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:05:51', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (83, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:05:51', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (84, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:05:52', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (85, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:13:34', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (86, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:13:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (87, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:13:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (88, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:13:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (89, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:13:39', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (90, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:22:12', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (91, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:22:13', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (92, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:22:13', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (93, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:22:14', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (94, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:22:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (95, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:27:55', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (96, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:27:56', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (97, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:27:57', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (98, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:27:58', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (99, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:27:59', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (100, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:29:14', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (101, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:29:16', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (102, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:29:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (103, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:29:17', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (104, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:29:18', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (105, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:27', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (106, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:28', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (107, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:29', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (108, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:29', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (109, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:30', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (110, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:33:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (111, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:38', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (112, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:39', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (113, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:39', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (114, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:40', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (115, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:40', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (116, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:34:41', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (117, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:47:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (118, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:47:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (119, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:50:45', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (120, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 19:50:56', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (121, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (122, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:24', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (123, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:25', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (124, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:25', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (125, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:26', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (126, 2, 2, 'F', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:10:26', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (127, 2, 2, 'T', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:11:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (128, 2, 2, 'T', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:13:44', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (129, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:18:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (130, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:32:16', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (131, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 20:35:58', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (132, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.7, 0.8, 83.3333, '2023-06-01 21:27:02', '2023-06-01 21:27:14', '0', '2023-06-01 21:27:19', '2023-06-01 21:27:59');
INSERT INTO `orders` VALUES (133, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:29:35', '2023-06-01 21:29:44', '0', '2023-06-01 21:29:49', '2023-06-01 21:29:59');
INSERT INTO `orders` VALUES (134, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:33:03', '2023-06-01 21:33:10', '', '2023-06-01 21:33:10', '2023-06-01 21:33:20');
INSERT INTO `orders` VALUES (135, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:37:04', '2023-06-01 21:37:17', '', '2023-06-01 21:37:22', '2023-06-01 21:37:32');
INSERT INTO `orders` VALUES (136, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:39:05', '2023-06-01 21:39:17', '', '2023-06-01 21:39:22', '2023-06-01 21:39:32');
INSERT INTO `orders` VALUES (137, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:40:24', '2023-06-01 21:40:34', '3', '2023-06-01 21:40:39', '2023-06-01 21:40:49');
INSERT INTO `orders` VALUES (138, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 21:45:17', '2023-06-01 21:45:29', '3', '2023-06-01 21:45:34', '2023-06-01 21:45:44');
INSERT INTO `orders` VALUES (139, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 22:07:10', '2023-06-01 22:07:19', '3', '2023-06-01 22:07:24', '2023-06-01 22:07:34');
INSERT INTO `orders` VALUES (140, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 22:16:34', '2023-06-01 22:16:45', '4', '2023-06-01 22:16:50', '2023-06-01 22:17:00');
INSERT INTO `orders` VALUES (141, 2, 2, 'T', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 22:16:34', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (142, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 22:16:35', '2023-06-01 22:16:45', '3', '2023-06-01 22:17:00', '2023-06-01 22:17:10');
INSERT INTO `orders` VALUES (143, 2, 2, 'T', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 22:16:35', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (144, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 22:16:36', '2023-06-01 22:16:45', '5', '2023-06-01 22:17:00', '2023-06-01 22:17:10');
INSERT INTO `orders` VALUES (145, 2, 2, 'T', 10, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 22:16:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (146, 2, 2, 'T', 10, 13.8889, 'FINISHED', 0.7, 0.8, 20.8333, '2023-06-01 22:16:46', '2023-06-01 22:17:00', '3', '2023-06-01 22:17:11', '2023-06-01 22:17:21');
INSERT INTO `orders` VALUES (147, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.7, 0.8, 83.3333, '2023-06-01 22:20:23', '2023-06-01 22:20:36', '3', '2023-06-01 22:20:41', '2023-06-01 22:21:21');
INSERT INTO `orders` VALUES (148, 2, 2, 'T', 50, 13.8889, 'FINISHED', 0.4, 0.8, 16.6667, '2023-06-01 23:19:29', '2023-06-01 23:19:41', '3', '2023-06-01 23:19:46', '2023-06-01 23:20:06');
INSERT INTO `orders` VALUES (149, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:20:20', '2023-06-01 23:20:26', '4', '2023-06-01 23:20:36', '2023-06-01 23:21:16');
INSERT INTO `orders` VALUES (150, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 23:20:20', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (151, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:20:21', '2023-06-01 23:20:26', '5', '2023-06-01 23:20:36', '2023-06-01 23:21:16');
INSERT INTO `orders` VALUES (152, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:20:22', '2023-06-01 23:20:26', '4', '2023-06-01 23:21:16', '2023-06-01 23:21:56');
INSERT INTO `orders` VALUES (153, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:25:32', '2023-06-01 23:25:42', '3', '2023-06-01 23:25:47', '2023-06-01 23:26:27');
INSERT INTO `orders` VALUES (154, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:26:00', '2023-06-01 23:26:12', '4', '2023-06-01 23:26:17', '2023-06-01 23:26:57');
INSERT INTO `orders` VALUES (155, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:28:50', '2023-06-01 23:28:55', '4', '2023-06-01 23:28:55', '2023-06-01 23:29:35');
INSERT INTO `orders` VALUES (156, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 23:28:50', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (157, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:28:51', '2023-06-01 23:28:55', '3', '2023-06-01 23:29:35', '2023-06-01 23:30:15');
INSERT INTO `orders` VALUES (158, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 23:28:51', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (159, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:28:52', '2023-06-01 23:28:55', '4', '2023-06-01 23:29:35', '2023-06-01 23:30:15');
INSERT INTO `orders` VALUES (160, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:31:32', '2023-06-01 23:31:45', '3', '2023-06-01 23:31:45', '2023-06-01 23:32:25');
INSERT INTO `orders` VALUES (161, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:31:33', '2023-06-01 23:31:45', '5', '2023-06-01 23:31:45', '2023-06-01 23:32:25');
INSERT INTO `orders` VALUES (162, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 23:31:33', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (163, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-01 23:31:34', '2023-06-01 23:31:45', '4', '2023-06-01 23:32:25', '2023-06-01 23:33:05');
INSERT INTO `orders` VALUES (164, 2, 2, 'T', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-01 23:31:34', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (165, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:39:48', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-01 23:39:49');
INSERT INTO `orders` VALUES (166, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:41:07', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-01 23:41:12');
INSERT INTO `orders` VALUES (167, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:42:40', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-01 23:42:41');
INSERT INTO `orders` VALUES (168, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:44:07', '2023-06-01 23:44:10', '3', '2023-06-01 23:44:10', '2023-06-01 23:44:12');
INSERT INTO `orders` VALUES (169, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:45:33', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-01 23:45:38');
INSERT INTO `orders` VALUES (170, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-01 23:49:26', '2023-06-01 23:49:35', '3', '2023-06-01 23:49:35', '2023-06-01 23:49:37');
INSERT INTO `orders` VALUES (171, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:17:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:17:38');
INSERT INTO `orders` VALUES (172, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:18:49', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:18:50');
INSERT INTO `orders` VALUES (173, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:19:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:19:18');
INSERT INTO `orders` VALUES (174, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:20:23', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:20:25');
INSERT INTO `orders` VALUES (175, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:21:07', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:21:10');
INSERT INTO `orders` VALUES (176, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-02 00:22:13', '2023-06-02 00:22:20', '3', '2023-06-02 00:22:25', '2023-06-02 00:23:05');
INSERT INTO `orders` VALUES (177, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-02 00:22:14', '2023-06-02 00:22:20', '4', '2023-06-02 00:22:25', '2023-06-02 00:23:05');
INSERT INTO `orders` VALUES (178, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:22:15', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:22:16');
INSERT INTO `orders` VALUES (179, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:27:03', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:27:08');
INSERT INTO `orders` VALUES (180, 2, 2, 'T', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-02 00:29:38', '2023-06-02 00:31:12', '1', '2023-06-02 00:31:17', '2023-06-02 00:31:37');
INSERT INTO `orders` VALUES (181, 2, 2, 'T', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:30:27', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:30:40');
INSERT INTO `orders` VALUES (182, 2, 2, 'F', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:31:02', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:31:16');
INSERT INTO `orders` VALUES (183, 2, 2, 'F', 50, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 00:31:48', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (184, 2, 2, 'F', 50, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-02 00:32:48', '2023-06-02 00:32:57', '1', '2023-06-02 00:33:02', '2023-06-02 00:33:22');
INSERT INTO `orders` VALUES (185, 2, 2, 'F', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 00:59:41', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 00:59:42');
INSERT INTO `orders` VALUES (186, 2, 2, 'F', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:00:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 01:00:38');
INSERT INTO `orders` VALUES (187, 2, 2, 'F', 50, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:01:43', '2023-06-02 01:01:50', '1', '2023-06-02 01:01:50', '2023-06-02 01:01:54');
INSERT INTO `orders` VALUES (188, 2, 2, 'F', 100, 0, 'CHARGING', 0, 0.8, 0, '2023-06-02 01:03:58', 'xxxx-xx-xx xx:xx:xx', '1', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (189, 2, 2, 'F', 100, 0, 'CHARGING', 0, 0.8, 0, '2023-06-02 01:04:55', 'xxxx-xx-xx xx:xx:xx', '1', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (190, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:05:57', '2023-06-02 01:06:07', '1', '2023-06-02 01:06:07', '2023-06-02 01:06:11');
INSERT INTO `orders` VALUES (191, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:07:43', '2023-06-02 01:07:52', '1', '2023-06-02 01:07:52', '2023-06-02 01:07:56');
INSERT INTO `orders` VALUES (192, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:08:57', '2023-06-02 01:09:07', '1', '2023-06-02 01:09:07', '2023-06-02 01:09:09');
INSERT INTO `orders` VALUES (193, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:16:52', '2023-06-02 01:17:03', '1', '2023-06-02 01:17:03', '2023-06-02 01:17:05');
INSERT INTO `orders` VALUES (194, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:17:36', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 01:17:37');
INSERT INTO `orders` VALUES (195, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:20:32', '2023-06-02 01:20:33', '1', '2023-06-02 01:20:38', '2023-06-02 01:21:18');
INSERT INTO `orders` VALUES (196, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:20:33', '2023-06-02 01:20:48', '1', '2023-06-02 01:21:18', '2023-06-02 01:21:58');
INSERT INTO `orders` VALUES (197, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 01:20:33', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (198, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:20:34', '2023-06-02 01:20:48', '2', '2023-06-02 01:21:18', '2023-06-02 01:21:58');
INSERT INTO `orders` VALUES (199, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:20:45', '2023-06-02 01:21:18', '2', '2023-06-02 01:21:58', '2023-06-02 01:22:38');
INSERT INTO `orders` VALUES (200, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 01:20:45', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (201, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:20:55', '2023-06-02 01:22:03', '1', '2023-06-02 01:22:38', '2023-06-02 01:23:18');
INSERT INTO `orders` VALUES (202, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:20:56', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 01:21:06');
INSERT INTO `orders` VALUES (203, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:31:28', '2023-06-02 01:31:33', '1', '2023-06-02 01:31:38', '2023-06-02 01:32:18');
INSERT INTO `orders` VALUES (204, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:31:29', '2023-06-02 01:31:33', '1', '2023-06-02 01:32:18', '2023-06-02 01:32:58');
INSERT INTO `orders` VALUES (205, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 01:31:29', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (206, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:31:30', '2023-06-02 01:31:33', '2', '2023-06-02 01:32:18', '2023-06-02 01:32:58');
INSERT INTO `orders` VALUES (207, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:31:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', '2023-06-02 01:31:55');
INSERT INTO `orders` VALUES (208, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 01:31:31', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (209, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:36:06', '2023-06-02 01:36:17', '1', '2023-06-02 01:36:17', '2023-06-02 01:36:57');
INSERT INTO `orders` VALUES (210, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:36:08', '2023-06-02 01:36:17', '2', '2023-06-02 01:36:17', '2023-06-02 01:36:57');
INSERT INTO `orders` VALUES (211, 2, 2, 'F', 100, 0, 'FINISHED', 0, 0.8, 0, '2023-06-02 01:36:11', '2023-06-02 01:36:17', '1', '2023-06-02 01:36:57', '2023-06-02 01:37:02');
INSERT INTO `orders` VALUES (212, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:36:14', '2023-06-02 01:36:17', '2', '2023-06-02 01:36:57', '2023-06-02 01:37:37');
INSERT INTO `orders` VALUES (213, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:47:48', '2023-06-02 01:47:56', '1', '2023-06-02 01:48:01', '2023-06-02 01:48:41');
INSERT INTO `orders` VALUES (214, 2, 2, 'F', 100, 55.5556, 'FINISHED', 0.4, 0.8, 66.6667, '2023-06-02 01:47:51', '2023-06-02 01:47:56', '2', '2023-06-02 01:48:01', '2023-06-02 01:48:21');
INSERT INTO `orders` VALUES (215, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:47:54', '2023-06-02 01:47:56', '1', '2023-06-02 01:48:41', '2023-06-02 01:49:21');
INSERT INTO `orders` VALUES (216, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 01:47:58', '2023-06-02 01:48:11', '2', '2023-06-02 01:48:31', '2023-06-02 01:49:11');
INSERT INTO `orders` VALUES (217, 2, 2, 'F', 100, 27.7778, 'FINISHED', 0.4, 0.8, 33.3333, '2023-06-02 02:41:18', '2023-06-02 02:41:21', '1', '2023-06-02 02:41:26', '2023-06-02 02:41:38');
INSERT INTO `orders` VALUES (218, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.4, 0.8, 133.333, '2023-06-02 05:50:57', '2023-06-02 05:51:07', '1', '2023-06-02 05:51:07', '2023-06-02 05:51:47');
INSERT INTO `orders` VALUES (219, 2, 2, 'F', 100, 111.111, 'FINISHED', 1, 0.8, 200, '2023-06-02 14:33:56', '2023-06-02 14:34:01', '2', '2023-06-02 14:34:06', '2023-06-02 14:34:46');
INSERT INTO `orders` VALUES (220, 2, 2, 'F', 100, 111.111, 'FINISHED', 1, 0.8, 200, '2023-06-02 14:33:57', '2023-06-02 14:36:16', '2', '2023-06-02 14:36:16', '2023-06-02 14:36:56');
INSERT INTO `orders` VALUES (221, 2, 2, 'F', 100, 111.111, 'FINISHED', 1, 0.8, 200, '2023-06-02 14:33:58', '2023-06-02 14:35:31', '2', '2023-06-02 14:35:36', '2023-06-02 14:36:16');
INSERT INTO `orders` VALUES (222, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 14:33:58', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (223, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 14:34:11', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (224, 2, 2, 'F', 100, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 14:34:11', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (225, 2, 2, 'F', 100, 83.3333, 'FINISHED', 1, 0.8, 150, '2023-06-02 14:40:40', '2023-06-02 14:41:19', '2', '2023-06-02 14:41:29', '2023-06-02 14:41:59');
INSERT INTO `orders` VALUES (226, 2, 2, 'F', 72.2222, 0, 'WAITING', 0, 0.8, 0, '2023-06-02 14:41:10', 'xxxx-xx-xx xx:xx:xx', '0', 'xxxx-xx-xx xx:xx:xx', 'xxxx-xx-xx xx:xx:xx');
INSERT INTO `orders` VALUES (227, 2, 2, 'F', 100, 27.7778, 'FINISHED', 1, 0.8, 50, '2023-06-02 14:58:51', '2023-06-02 14:59:00', '1', '2023-06-02 14:59:05', '2023-06-02 14:59:20');
INSERT INTO `orders` VALUES (228, 2, 2, 'F', 72.2222, 83.3333, 'FINISHED', 0.9, 0.8, 141.667, '2023-06-02 14:59:20', '2023-06-02 14:59:30', '2', '2023-06-02 14:59:35', '2023-06-02 15:00:05');
INSERT INTO `orders` VALUES (229, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:05:04', '2023-06-02 15:05:07', '1', '2023-06-02 15:05:12', '2023-06-02 15:05:52');
INSERT INTO `orders` VALUES (230, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:05:05', '2023-06-02 15:05:07', '2', '2023-06-02 15:05:12', '2023-06-02 15:05:52');
INSERT INTO `orders` VALUES (231, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:05:08', '2023-06-02 15:05:22', '1', '2023-06-02 15:05:52', '2023-06-02 15:06:32');
INSERT INTO `orders` VALUES (232, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:05:09', '2023-06-02 15:05:22', '2', '2023-06-02 15:05:52', '2023-06-02 15:06:32');
INSERT INTO `orders` VALUES (233, 2, 2, 'F', 100, 0, 'FINISHED', 0.7, 0.8, 0, '2023-06-02 15:05:11', '2023-06-02 15:05:52', '1', '2023-06-02 15:06:32', '2023-06-02 15:06:40');
INSERT INTO `orders` VALUES (234, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:05:12', '2023-06-02 15:05:52', '2', '2023-06-02 15:06:32', '2023-06-02 15:07:12');
INSERT INTO `orders` VALUES (235, 2, 2, 'F', 100, 111.111, 'FINISHED', 0.7, 0.8, 166.667, '2023-06-02 15:06:40', '2023-06-02 15:06:52', '2', '2023-06-02 15:07:12', '2023-06-02 15:07:52');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `auth` int NOT NULL,
  `account` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cars` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `balance` float NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 1, 'account', 'password', 'admin', '', 0);
INSERT INTO `users` VALUES (2, 0, '2020211376', 'password', 'mtc', '', 0);
INSERT INTO `users` VALUES (3, 0, '2020211375', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (4, 0, '2020211377', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (5, 0, '2020211374', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (6, 0, '2020211373', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (7, 0, '2020211370', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (8, 0, 'yangyexuan@qq.com', 'password', '未命名', '', 0);
INSERT INTO `users` VALUES (9, 0, '2020211390', 'password', '未命名', '', 0);

SET FOREIGN_KEY_CHECKS = 1;
