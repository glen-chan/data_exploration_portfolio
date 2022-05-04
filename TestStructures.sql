DROP DATABASE IF EXISTS `my_little_pony`;
CREATE DATABASE `my_little_pony`; 
USE `my_little_pony`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE `users` (
  `user_id` integer NOT NULL AUTO_INCREMENT,
  `user_city` varchar(50) NOT NULL,
  `user_gender` char(1) NOT NULL,
  `user_registration_timestamp` timestamp DEFAULT now(),
  PRIMARY KEY (`user_id`)
) AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Berlin','M','2018-01-01 17:50:11');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Stuttgart','F','2019-02-03 06:22:58');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Bochum','F','2019-12-01 02:40:23');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Aachen','M','2019-02-03 19:30:22');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Munich','F','2019-04-08 15:18:36');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Cologne','F','2019-04-04 07:15:09');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Düsseldorf','F','2018-06-23 00:12:12');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Berlin','F','2019-02-03 14:50:16');
INSERT INTO `users` (`user_city`,`user_gender`,`user_registration_timestamp`)  VALUES ('Berlin','M','2019-05-17 10:33:47');

CREATE TABLE `sales` (
  `sale_id` integer NOT NULL AUTO_INCREMENT,
  `sale_user_id` integer NOT NULL,
  `sale_timestamp` timestamp DEFAULT now(),
  `sale_type` varchar(50),
  PRIMARY KEY (`sale_id`),
  KEY `fk_sales_users_idx` (`sale_user_id`),
  CONSTRAINT `fk_sales_users` FOREIGN KEY (`sale_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
)  AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (1,'sale type 1','2019-08-17 02:40:23');
INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (2,'sale type 1','2019-02-05 15:18:24');
INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (3,'sale type 3','2019-12-03 07:34:59');
INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (1,'sale type 3','2019-08-17 06:14:48');
INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (4,'sale type 1','2019-02-05 18:21:40');
INSERT INTO `sales` (`sale_user_id`,`sale_type`,`sale_timestamp`)  VALUES (4,'sale type 3','2019-03-05 09:27:11');


CREATE TABLE `payments` (
  `pay_sale_id` integer NOT NULL,
  `pay_timestamp` timestamp DEFAULT now(),
  `pay_amount` decimal(4,2),
  PRIMARY KEY (`pay_sale_id`),
 CONSTRAINT `fk_payment_sales` FOREIGN KEY (`pay_sale_id`) REFERENCES `sales` (`sale_id`) ON DELETE CASCADE
)  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `payments` (`pay_sale_id`,`pay_amount`)  VALUES (1,9.99);
INSERT INTO `payments` (`pay_sale_id`,`pay_amount`)  VALUES (2,4.99);
INSERT INTO `payments` (`pay_sale_id`,`pay_amount`)  VALUES (3,20.00);
INSERT INTO `payments` (`pay_sale_id`,`pay_amount`)  VALUES (4,15.50);
INSERT INTO `payments` (`pay_sale_id`,`pay_amount`)  VALUES (5,9.99);


CREATE TABLE `devices` (
  `device_id` varchar(10) NOT NULL,
  `device_name` varchar(50),
  PRIMARY KEY (`device_id`)
 ) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
INSERT INTO `devices` (`device_id`,`device_name`)  VALUES ('SAR3OU83KL','First device');
INSERT INTO `devices` (`device_id`,`device_name`)  VALUES ('ILM37O83AH','Second device');
INSERT INTO `devices` (`device_id`,`device_name`)  VALUES ('YU389739RR','Third device');
INSERT INTO `devices` (`device_id`,`device_name`)  VALUES ('MI387387GM','Fourth device');
INSERT INTO `devices` (`device_id`,`device_name`)  VALUES ('JIU97879RA','Fifth device');

UPDATE `devices`
SET `device_name` = 'phone' WHERE `device_id`='MI387387GM';

UPDATE `devices`
SET `device_name` = 'phone' WHERE `device_id`='SAR3OU83KL';

CREATE TABLE `activities` (
  `activity_user_id` integer NOT NULL,
  `activity_device_id` varchar(10) NOT NULL,
  `activity_timestamp` timestamp DEFAULT now(),
  `activity_is_last` boolean DEFAULT TRUE,
  PRIMARY KEY (`activity_user_id`, `activity_device_id`,`activity_timestamp`),
    CONSTRAINT `fk_activities_users` FOREIGN KEY (`activity_user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_activities_devices` FOREIGN KEY (`activity_device_id`) REFERENCES `devices` (`device_id`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`, `activity_is_last`)  VALUES (1,'SAR3OU83KL','2019-08-15 04:49:09',FALSE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (1,'SAR3OU83KL','2019-08-16 12:07:24',FALSE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (1,'SAR3OU83KL','2019-08-17 02:34:04',TRUE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (2,'ILM37O83AH','2019-07-10 02:34:04',FALSE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (2,'ILM37O83AH','2019-08-17 02:34:04',FALSE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (2,'MI387387GM','2019-08-17 12:15:30',FALSE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (2,'MI387387GM','2019-08-17 18:14:48',TRUE);
INSERT INTO `activities` (`activity_user_id`,`activity_device_id`,`activity_timestamp`,`activity_is_last`)  VALUES (9,'JIU97879RA','2019-05-19 04:54:31',TRUE);


/*UPDATE `activities`
SET `activity_is_last` = FALSE
WHERE `activity_user_id`= 2 AND `activity_device_id`= 'MI387387GM' AND `activity_timestamp`= '2019-08-17 12:15:30';*/

CREATE TABLE `informations` (
  `info_device_id` varchar(10) NOT NULL,
  `info_timestamp` timestamp DEFAULT now(),
  `info_page_visits` integer,
  PRIMARY KEY (`info_device_id`,`info_timestamp`),
  KEY `fk_informations_devices_idx` (`info_device_id`),
  CONSTRAINT `fk_informations_devices` FOREIGN KEY (`info_device_id`) REFERENCES `devices` (`device_id`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('SAR3OU83KL','2019-08-15 04:49:09',3);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('SAR3OU83KL','2019-08-16 12:07:24',2);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('SAR3OU83KL','2019-08-17 02:34:04',3);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('ILM37O83AH','2019-07-10 02:34:04',5);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('ILM37O83AH','2019-08-17 02:34:04',1);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('MI387387GM','2019-08-17 12:15:30',2);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('MI387387GM','2019-08-17 18:14:48',2);

INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('YU389739RR','2019-01-05 07:30:30',2);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('YU389739RR','2019-04-27 18:25:06',3);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('YU389739RR','2019-07-31 14:08:17',1);
INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('YU389739RR','2019-12-28 11:03:20',4);

INSERT INTO `informations` (`info_device_id`,`info_timestamp`,`info_page_visits`)  VALUES ('JIU97879RA','2019-05-19 04:54:31',4);
