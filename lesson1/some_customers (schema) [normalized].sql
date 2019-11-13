SET @@foreign_key_checks = 0;

DROP TABLE IF EXISTS `language`;
DROP TABLE IF EXISTS `country`;
DROP TABLE IF EXISTS `city`;
DROP TABLE IF EXISTS `street`;
DROP TABLE IF EXISTS `address`;
DROP TABLE IF EXISTS `gender`;
DROP TABLE IF EXISTS `marital_status`;
DROP TABLE IF EXISTS `person_title`;
DROP TABLE IF EXISTS `person_title_localized`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `customer_individual`;
DROP TABLE IF EXISTS `customer_company`;

CREATE TABLE `language` (
  `name` varchar(255) NOT NULL COMMENT 'Language name',

  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `country` (
  `name` varchar(255) NOT NULL COMMENT 'Country name',
  `language` varchar(255) NOT NULL COMMENT 'Default language for the country',

  PRIMARY KEY (`name`),
  FOREIGN KEY 
    fk_country_language (`language`)
    REFERENCES `language` (`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `city` (
  `id` bigint AUTO_INCREMENT NOT NULL COMMENT 'Synthetic ID of city',
  `country` varchar(255) NOT NULL COMMENT 'Country link',
  `region` varchar(255) DEFAULT NULL COMMENT 'Region name (if exists)',
  `name` varchar(255) NOT NULL COMMENT 'City name',

  PRIMARY KEY (`id`),
  UNIQUE KEY (`country`, `name`, `region`),
  FOREIGN KEY 
    fk_city_country (`country`)
    REFERENCES `country` (`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `street` (
  `id` bigint AUTO_INCREMENT NOT NULL COMMENT 'Synthetic ID of street',
  `city_id` bigint NOT NULL COMMENT 'City link',
  `name` varchar(255) NOT NULL COMMENT 'Street name',

  PRIMARY KEY (`id`),
  UNIQUE KEY ux_street_city_name (`city_id`, `name`),
  FOREIGN KEY 
    fk_street_city (`city_id`)
    REFERENCES `city` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `address` (
  `id` bigint AUTO_INCREMENT NOT NULL COMMENT 'Synthetic ID of address',
  `street_id` bigint NOT NULL COMMENT 'Street link',
  `building_number` varchar(255) NOT NULL COMMENT 'Building number',
  `additional_number` varchar(255) DEFAULT NULL COMMENT 'Additional number of building (строение, корпус и т.п. — пример: к2с1)',

  PRIMARY KEY (`id`),
  UNIQUE KEY ux_address_street_id_building_number_additional_number (`street_id`, `building_number`, `additional_number`),
  FOREIGN KEY 
    fk_address_street_id (`street_id`)
    REFERENCES `street` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `gender` (
  `key` varchar(255) NOT NULL COMMENT 'Gender key',

  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `marital_status` (
  `key` varchar(255) NOT NULL COMMENT 'Status key',
  
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person_title` (
  `key` varchar(255) NOT NULL COMMENT 'Person title key',

  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `person_title_localized` (
  `key` varchar(255) NOT NULL COMMENT 'Person title key link',
  `localized_title` varchar(255) NOT NULL,

  PRIMARY KEY (`key`, `localized_title`),
  FOREIGN KEY 
    fk_person_title_localized_key (`key`)
    REFERENCES `person_title` (`key`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `customer` (
  `id` bigint AUTO_INCREMENT NOT NULL COMMENT 'Synthetic ID of customer',
  `address_id` bigint NOT NULL COMMENT 'Address link',
  `correspondence_language` varchar(255) DEFAULT NULL COMMENT 'Correspondence language link',

  PRIMARY KEY (`id`),
  FOREIGN KEY 
    fk_customer_address_id (`address_id`)
    REFERENCES `address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY 
    fk_customer_correspondence_language (`correspondence_language`)
    REFERENCES `language` (`name`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `customer_individual` (
  `customer_id` bigint NOT NULL COMMENT 'Customer link',
  `first_name` varchar(255) DEFAULT NULL COMMENT 'First name',
  `last_name` varchar(255) NOT NULL COMMENT 'Last name',
  `birth_date` date DEFAULT NULL COMMENT 'Birth date',
  `gender` varchar(255) NOT NULL COMMENT 'Gender link',
  `marital_status` varchar(255) DEFAULT NULL COMMENT 'Status link',
  `title` varchar(255) DEFAULT NULL COMMENT 'Title link',

  FOREIGN KEY 
    fk_customer_individual_customer_id (`customer_id`)
    REFERENCES `customer` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY 
    fk_customer_individual_gender (`gender`)
    REFERENCES `gender` (`key`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY 
    fk_customer_individual_marital_status (`marital_status`)
    REFERENCES `marital_status` (`key`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  FOREIGN KEY 
    fk_customer_individual_title (`title`)
    REFERENCES `person_title` (`key`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `customer_company` (
  `customer_id` bigint NOT NULL COMMENT 'Customer link',

  FOREIGN KEY 
    fk_customer_company_customer_id (`customer_id`)
    REFERENCES `customer` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

SET @@foreign_key_checks = 1;