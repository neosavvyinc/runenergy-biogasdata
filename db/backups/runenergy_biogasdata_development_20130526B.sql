-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 26, 2013 at 05:16 PM
-- Server version: 5.1.44
-- PHP Version: 5.3.1

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `runenergy_biogasdata_development`
--

-- --------------------------------------------------------

--
-- Table structure for table `active_admin_comments`
--

DROP TABLE IF EXISTS `active_admin_comments`;
CREATE TABLE IF NOT EXISTS `active_admin_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` varchar(255) NOT NULL,
  `resource_type` varchar(255) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `author_type` varchar(255) DEFAULT NULL,
  `body` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `namespace` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_admin_notes_on_resource_type_and_resource_id` (`resource_type`,`resource_id`),
  KEY `index_active_admin_comments_on_namespace` (`namespace`),
  KEY `index_active_admin_comments_on_author_type_and_author_id` (`author_type`,`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `active_admin_comments`
--


-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_admin_users_on_email` (`email`),
  UNIQUE KEY `index_admin_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `email`, `encrypted_password`, `reset_password_token`, `reset_password_sent_at`, `remember_created_at`, `sign_in_count`, `current_sign_in_at`, `last_sign_in_at`, `current_sign_in_ip`, `last_sign_in_ip`, `created_at`, `updated_at`) VALUES
(1, 'admin@example.com', '$2a$10$kBg.IsS0NENTflAxLVTgJek2.A2K0kSKvRLk4xY5JwV.jBe5A/8P6', NULL, NULL, NULL, 4, '2013-05-26 05:22:34', '2013-05-25 22:47:20', '127.0.0.1', '127.0.0.1', '2013-05-25 20:54:00', '2013-05-26 05:22:34');

-- --------------------------------------------------------

--
-- Table structure for table `attribute_name_mappings`
--

DROP TABLE IF EXISTS `attribute_name_mappings`;
CREATE TABLE IF NOT EXISTS `attribute_name_mappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attribute_name` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `applies_to_class` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `attribute_name_mappings`
--

INSERT INTO `attribute_name_mappings` (`id`, `attribute_name`, `display_name`, `applies_to_class`, `created_at`, `updated_at`) VALUES
(1, 'blower_speed', 'Blower Speed', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(2, 'date_time_reading', 'Reading At', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(3, 'flame_temperature', 'Flame Temperature', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(4, 'inlet_pressure', 'Inlet Pressure', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(5, 'lfg_temperature', 'LFG Temperature', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(6, 'methane', 'Methane', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(7, 'standard_cumulative_lfg_volume', 'Standard Cumulative LFG Volume', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(8, 'standard_lfg_flow', 'Standard LFG Flow', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(9, 'standard_lfg_volume', 'Standard LFG Volume (Month to Date)', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(10, 'standard_methane_volume', 'Standard Methane Volume (Month to Date', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12'),
(11, 'static_pressure', 'Static Pressure', 'FlareMonitorData', '2013-05-26 04:57:12', '2013-05-26 04:57:12');

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE IF NOT EXISTS `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `created_at`, `updated_at`) VALUES
(25, 'Gasco', '2013-05-26 15:18:19', '2013-05-26 15:18:19'),
(26, 'ABM Combustible', '2013-05-26 15:18:19', '2013-05-26 15:18:19'),
(27, 'Run Energy', '2013-05-26 15:18:19', '2013-05-26 15:18:19');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Australia', '2013-05-25 22:22:08', '2013-05-25 22:22:08');

-- --------------------------------------------------------

--
-- Table structure for table `flare_collection_statistics`
--

DROP TABLE IF EXISTS `flare_collection_statistics`;
CREATE TABLE IF NOT EXISTS `flare_collection_statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_reading_collected` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_csv_read` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `flare_collection_statistics`
--


-- --------------------------------------------------------

--
-- Table structure for table `flare_data_mappings`
--

DROP TABLE IF EXISTS `flare_data_mappings`;
CREATE TABLE IF NOT EXISTS `flare_data_mappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_reading_column` int(11) DEFAULT NULL,
  `time_reading_column` int(11) DEFAULT NULL,
  `inlet_pressure_column` int(11) DEFAULT NULL,
  `blower_speed_column` int(11) DEFAULT NULL,
  `methane_column` int(11) DEFAULT NULL,
  `flame_temperature_column` int(11) DEFAULT NULL,
  `static_pressure_column` int(11) DEFAULT NULL,
  `lfg_temperature_column` int(11) DEFAULT NULL,
  `standard_methane_volume_column` int(11) DEFAULT NULL,
  `standard_lfg_flow_column` int(11) DEFAULT NULL,
  `standard_lfg_volume_column` int(11) DEFAULT NULL,
  `standard_cumulative_lfg_volume_column` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dumping data for table `flare_data_mappings`
--


-- --------------------------------------------------------

--
-- Table structure for table `flare_deployments`
--

DROP TABLE IF EXISTS `flare_deployments`;
CREATE TABLE IF NOT EXISTS `flare_deployments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flare_specification_id` varchar(255) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `client_flare_id` varchar(255) DEFAULT NULL,
  `flare_data_mapping_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `flare_deployments`
--

INSERT INTO `flare_deployments` (`id`, `flare_specification_id`, `location_id`, `customer_id`, `client_flare_id`, `flare_data_mapping_id`, `created_at`, `updated_at`) VALUES
(7, '17', 1, 7, 'LFG-FLR1-1-1', NULL, '2013-05-26 15:18:19', '2013-05-26 15:18:19'),
(8, '19', 2, NULL, 'LFG-FLR1-1-10', NULL, '2013-05-26 15:18:19', '2013-05-26 15:18:19');

-- --------------------------------------------------------

--
-- Table structure for table `flare_monitor_data`
--

DROP TABLE IF EXISTS `flare_monitor_data`;
CREATE TABLE IF NOT EXISTS `flare_monitor_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_time_reading` datetime DEFAULT NULL,
  `inlet_pressure` decimal(10,0) DEFAULT NULL,
  `blower_speed` decimal(10,0) DEFAULT NULL,
  `methane` decimal(10,0) DEFAULT NULL,
  `flame_temperature` decimal(10,0) DEFAULT NULL,
  `standard_lfg_flow` decimal(10,0) DEFAULT NULL,
  `standard_cumulative_lfg_volume` decimal(10,0) DEFAULT NULL,
  `static_pressure` decimal(10,0) DEFAULT NULL,
  `lfg_temperature` decimal(10,0) DEFAULT NULL,
  `standard_lfg_volume` decimal(10,0) DEFAULT NULL,
  `standard_methane_volume` decimal(10,0) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `flare_specification_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20560 ;

--
-- Dumping data for table `flare_monitor_data`
--


-- --------------------------------------------------------

--
-- Table structure for table `flare_specifications`
--

DROP TABLE IF EXISTS `flare_specifications`;
CREATE TABLE IF NOT EXISTS `flare_specifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flare_id` varchar(255) DEFAULT NULL,
  `capacity_scmh` int(11) DEFAULT NULL,
  `manufacturer_id` int(11) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `manufacturer_product_id` varchar(255) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `web_address` varchar(255) DEFAULT NULL,
  `ftp_address` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `data_location` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `flare_collection_statistic_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

--
-- Dumping data for table `flare_specifications`
--

INSERT INTO `flare_specifications` (`id`, `flare_id`, `capacity_scmh`, `manufacturer_id`, `purchase_date`, `manufacturer_product_id`, `owner_id`, `web_address`, `ftp_address`, `username`, `password`, `data_location`, `created_at`, `updated_at`, `flare_collection_statistic_id`) VALUES
(17, 'LFG-FLR1', 500, 25, '0000-00-00', 'P2513-01', 27, 'runflare1.dyndns.org', 'runflare1.dyndns.org', 'runflare1', 'run007', '/DATA', '2013-05-26 15:18:19', '2013-05-26 15:18:19', NULL),
(18, 'LFG-FLR10', 500, 26, '0000-00-00', 'P2513-01', 27, 'runflare10.dyndns.org', 'runflare10.dyndns.org', 'runflare10', 'run007', '/DATA', '2013-05-26 15:18:19', '2013-05-26 15:18:19', NULL),
(19, 'LFG-FLR6', 500, 26, '0000-00-00', 'P2513-01', 27, 'runflare6.dyndns.org', 'runflare6.dyndns.org', 'runflare6', 'run007', '/DATA', '2013-05-26 15:18:19', '2013-05-26 16:40:53', 2);

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_name` varchar(255) DEFAULT NULL,
  `address` text,
  `state_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `lattitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `google_earth_file_file_name` varchar(255) DEFAULT NULL,
  `google_earth_file_content_type` varchar(255) DEFAULT NULL,
  `google_earth_file_file_size` int(11) DEFAULT NULL,
  `google_earth_file_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `site_name`, `address`, `state_id`, `country_id`, `lattitude`, `longitude`, `created_at`, `updated_at`, `google_earth_file_file_name`, `google_earth_file_content_type`, `google_earth_file_file_size`, `google_earth_file_updated_at`) VALUES
(1, 'Elizabeth Drive Landfill', NULL, 53, NULL, '33o15''52.33S', '150o45''39.26E', '2013-05-25 22:22:08', '2013-05-25 22:22:08', NULL, NULL, NULL, NULL),
(2, 'Stevensons Road Closed Landfill', NULL, 52, NULL, '33o15''35.33S', '190o45''14.26E', '2013-05-25 22:22:08', '2013-05-25 22:22:08', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `schema_migrations`
--

INSERT INTO `schema_migrations` (`version`) VALUES
('20130525162901'),
('20130525204904'),
('20130525205333'),
('20130525205335'),
('20130525205336'),
('20130525210425'),
('20130525220327'),
('20130525220634'),
('20130525220840'),
('20130525220849'),
('20130525221124'),
('20130525221345'),
('20130525222912'),
('20130525223046'),
('20130525223925'),
('20130526044313'),
('20130526051933'),
('20130526052843'),
('20130526053027'),
('20130526063200'),
('20130526144657'),
('20130526144737'),
('20130526145004'),
('20130526154908');

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
CREATE TABLE IF NOT EXISTS `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `country_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=54 ;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`id`, `name`, `postal_code`, `created_at`, `updated_at`, `country_id`) VALUES
(52, 'VIC', NULL, '2013-05-25 22:22:08', '2013-05-25 22:22:08', 1),
(53, 'NSW', NULL, '2013-05-25 22:22:08', '2013-05-25 22:22:08', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) DEFAULT NULL,
  `last_sign_in_ip` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `encrypted_password`, `reset_password_token`, `reset_password_sent_at`, `remember_created_at`, `sign_in_count`, `current_sign_in_at`, `last_sign_in_at`, `current_sign_in_ip`, `last_sign_in_ip`, `created_at`, `updated_at`, `user_type_id`, `name`) VALUES
(7, 'doctorrockso@gmail.com', '$2a$10$bXJj3Ep.U.FR627rt0WVUOeQm9Gy1fOEGo.w6/BAXuWd/ZDtsvANu', NULL, NULL, NULL, 1, '2013-05-26 16:53:16', '2013-05-26 16:53:16', '127.0.0.1', '127.0.0.1', '2013-05-26 15:18:19', '2013-05-26 16:53:16', 2, 'Dr. Rockso'),
(8, 'lemmy@gmail.com', '$2a$10$Y3hSE/O.5EIhLvbQh1A8WOFu9oSMLNsN5z7ZIVSiWl19hD2ql5C2i', NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, '2013-05-26 15:18:19', '2013-05-26 15:18:19', 1, 'Lemmy Kilmister');

-- --------------------------------------------------------

--
-- Table structure for table `user_types`
--

DROP TABLE IF EXISTS `user_types`;
CREATE TABLE IF NOT EXISTS `user_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `user_types`
--

INSERT INTO `user_types` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'OVERSEER', '2013-05-26 05:30:12', '2013-05-26 05:30:12'),
(2, 'CUSTOMER', '2013-05-26 05:30:12', '2013-05-26 05:30:12');
SET FOREIGN_KEY_CHECKS=1;
