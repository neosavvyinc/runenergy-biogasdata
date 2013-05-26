-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 26, 2013 at 02:14 PM
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=25 ;

--
-- Dumping data for table `companies`
--

INSERT INTO `companies` (`id`, `name`, `created_at`, `updated_at`) VALUES
(22, 'Gasco', '2013-05-26 06:42:31', '2013-05-26 06:42:31'),
(23, 'ABM Combustible', '2013-05-26 06:42:31', '2013-05-26 06:42:31'),
(24, 'Run Energy', '2013-05-26 06:42:31', '2013-05-26 06:42:31');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `flare_deployments`
--

INSERT INTO `flare_deployments` (`id`, `flare_specification_id`, `location_id`, `customer_id`, `client_flare_id`, `flare_data_mapping_id`, `created_at`, `updated_at`) VALUES
(5, '15', 1, 5, 'LFG-FLR1-1-1', NULL, '2013-05-26 06:42:31', '2013-05-26 06:42:31'),
(6, '16', 2, NULL, 'LFG-FLR1-1-10', NULL, '2013-05-26 06:42:31', '2013-05-26 06:42:31');

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2881 ;

--
-- Dumping data for table `flare_monitor_data`
--

INSERT INTO `flare_monitor_data` (`id`, `date_time_reading`, `inlet_pressure`, `blower_speed`, `methane`, `flame_temperature`, `standard_lfg_flow`, `standard_cumulative_lfg_volume`, `static_pressure`, `lfg_temperature`, `standard_lfg_volume`, `standard_methane_volume`, `created_at`, `updated_at`) VALUES
(2785, NULL, -1, 19, 48, 884, 91, 327543, 0, 27, 69964, 36543, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2786, NULL, -1, 18, 48, 894, 91, 327565, 0, 27, 22, 11, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2787, NULL, -1, 19, 48, 891, 90, 327588, 0, 28, 45, 22, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2788, NULL, -1, 19, 48, 885, 91, 327611, 0, 28, 68, 33, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2789, NULL, -1, 19, 48, 958, 90, 327634, 0, 28, 90, 44, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2790, NULL, -1, 19, 48, 955, 90, 327656, 0, 28, 113, 55, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2791, NULL, -1, 19, 48, 889, 90, 327679, 0, 28, 136, 66, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2792, NULL, -1, 19, 48, 903, 91, 327702, 0, 27, 159, 77, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2793, NULL, -1, 19, 48, 854, 91, 327725, 0, 27, 181, 88, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2794, NULL, -1, 19, 48, 890, 90, 327747, 0, 27, 204, 99, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2795, NULL, -1, 19, 48, 886, 91, 327770, 0, 27, 227, 110, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2796, NULL, -1, 19, 48, 873, 90, 327793, 0, 27, 250, 121, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2797, NULL, -1, 19, 48, 863, 91, 327816, 0, 27, 273, 132, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2798, NULL, -1, 19, 48, 853, 90, 327838, 0, 27, 295, 143, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2799, NULL, -1, 19, 48, 891, 90, 327861, 0, 27, 318, 154, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2800, NULL, -1, 20, 48, 891, 90, 327884, 0, 27, 341, 165, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2801, NULL, -1, 18, 48, 905, 90, 327906, 0, 28, 363, 176, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2802, NULL, -1, 19, 48, 880, 90, 327929, 0, 28, 386, 187, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2803, NULL, -1, 18, 48, 850, 90, 327952, 0, 28, 409, 198, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2804, NULL, -1, 20, 48, 874, 90, 327974, 0, 28, 431, 209, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2805, NULL, -1, 19, 48, 848, 90, 327997, 0, 28, 454, 220, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2806, NULL, -1, 18, 47, 933, 90, 328020, 0, 28, 477, 230, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2807, NULL, -1, 20, 47, 881, 89, 328042, 0, 28, 499, 241, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2808, NULL, -1, 19, 47, 909, 89, 328065, 0, 28, 521, 252, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2809, NULL, -1, 19, 47, 859, 89, 328087, 0, 28, 544, 262, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2810, NULL, -1, 20, 47, 875, 88, 328109, 0, 28, 566, 273, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2811, NULL, -1, 19, 47, 846, 89, 328132, 0, 29, 588, 284, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2812, NULL, -1, 19, 46, 887, 89, 328154, 0, 29, 611, 294, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2813, NULL, -1, 18, 47, 929, 89, 328176, 0, 29, 633, 305, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2814, NULL, -1, 19, 47, 885, 89, 328199, 0, 29, 655, 315, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2815, NULL, -1, 19, 47, 852, 88, 328221, 0, 29, 678, 326, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2816, NULL, -1, 19, 46, 878, 87, 328243, 0, 29, 700, 336, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2817, NULL, -1, 19, 47, 939, 87, 328265, 0, 30, 722, 347, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2818, NULL, -1, 19, 47, 931, 87, 328287, 0, 31, 744, 357, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2819, NULL, -1, 19, 47, 969, 85, 328308, 0, 32, 765, 367, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2820, NULL, -1, 19, 47, 845, 81, 328329, 0, 33, 785, 377, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2821, NULL, -1, 19, 47, 907, 88, 328350, 0, 33, 807, 387, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2822, NULL, -1, 19, 47, 862, 86, 328372, 0, 34, 829, 398, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2823, NULL, -1, 20, 47, 800, 86, 328394, 0, 34, 851, 408, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2824, NULL, -1, 19, 47, 769, 85, 328415, 0, 35, 872, 418, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2825, NULL, -1, 19, 47, 756, 86, 328437, 0, 35, 894, 428, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2826, NULL, -1, 19, 48, 765, 87, 328459, 0, 35, 915, 439, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2827, NULL, -1, 19, 47, 758, 88, 328481, 0, 35, 938, 450, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2828, NULL, -1, 19, 47, 699, 88, 328503, 0, 34, 960, 460, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2829, NULL, -1, 20, 48, 887, 87, 328525, 0, 34, 982, 471, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2830, NULL, -1, 19, 47, 730, 88, 328547, 0, 33, 1004, 481, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2831, NULL, -1, 18, 48, 815, 88, 328569, 0, 33, 1026, 492, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2832, NULL, -1, 19, 47, 855, 88, 328591, 0, 34, 1048, 503, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2833, NULL, -1, 19, 47, 901, 88, 328614, 0, 34, 1071, 513, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2834, NULL, -1, 19, 47, 779, 88, 328636, 0, 34, 1093, 524, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2835, NULL, -1, 18, 48, 759, 89, 328658, 0, 33, 1115, 535, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2836, NULL, -1, 18, 47, 812, 88, 328680, 0, 33, 1137, 545, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2837, NULL, -1, 19, 47, 862, 89, 328703, 0, 33, 1160, 556, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2838, NULL, -1, 20, 47, 816, 89, 328725, 0, 33, 1182, 566, '2013-05-25 19:46:44', '2013-05-25 19:46:44'),
(2839, NULL, -1, 20, 47, 759, 89, 328747, 0, 33, 1204, 577, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2840, NULL, -1, 19, 47, 741, 90, 328770, 0, 33, 1227, 588, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2841, NULL, -1, 20, 48, 868, 89, 328792, 0, 33, 1249, 599, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2842, NULL, -1, 19, 47, 905, 89, 328815, 0, 33, 1272, 609, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2843, NULL, -1, 20, 48, 791, 90, 328837, 0, 33, 1294, 620, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2844, NULL, -1, 20, 48, 904, 89, 328860, 0, 33, 1317, 631, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2845, NULL, -1, 20, 48, 858, 89, 328882, 0, 32, 1339, 642, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2846, NULL, -1, 20, 48, 890, 90, 328905, 0, 33, 1362, 653, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2847, NULL, -1, 20, 48, 837, 90, 328927, 0, 32, 1384, 663, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2848, NULL, -1, 20, 48, 849, 90, 328950, 0, 32, 1407, 674, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2849, NULL, -1, 20, 48, 828, 89, 328972, 0, 32, 1429, 685, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2850, NULL, -1, 20, 48, 868, 90, 328995, 0, 32, 1452, 696, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2851, NULL, -1, 19, 48, 885, 90, 329018, 0, 31, 1475, 707, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2852, NULL, -1, 19, 48, 837, 90, 329040, 0, 31, 1497, 718, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2853, NULL, -1, 19, 48, 914, 90, 329063, 0, 31, 1520, 729, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2854, NULL, -1, 20, 48, 908, 90, 329086, 0, 30, 1543, 740, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2855, NULL, -1, 19, 47, 850, 90, 329108, 0, 30, 1565, 750, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2856, NULL, -1, 20, 46, 974, 90, 329131, 0, 30, 1588, 761, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2857, NULL, -1, 19, 47, 903, 91, 329154, 0, 30, 1611, 772, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2858, NULL, -1, 19, 47, 946, 91, 329177, 0, 29, 1634, 783, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2859, NULL, -1, 20, 47, 941, 91, 329199, 0, 29, 1656, 794, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2860, NULL, -1, 19, 47, 961, 91, 329222, 0, 29, 1679, 804, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2861, NULL, -1, 19, 47, 1000, 91, 329245, 0, 29, 1702, 815, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2862, NULL, -1, 19, 47, 984, 90, 329268, 0, 29, 1725, 826, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2863, NULL, -1, 20, 47, 960, 90, 329290, 0, 28, 1747, 837, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2864, NULL, -1, 18, 47, 970, 90, 329313, 0, 28, 1770, 847, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2865, NULL, -1, 19, 47, 995, 90, 329336, 0, 28, 1793, 858, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2866, NULL, -1, 19, 47, 966, 90, 329358, 0, 28, 1815, 869, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2867, NULL, -1, 19, 47, 998, 90, 329381, 0, 29, 1838, 879, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2868, NULL, -1, 19, 47, 958, 90, 329404, 0, 29, 1860, 890, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2869, NULL, -1, 18, 47, 1005, 90, 329426, 0, 29, 1883, 901, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2870, NULL, -1, 19, 47, 1024, 90, 329449, 0, 29, 1906, 912, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2871, NULL, -1, 18, 47, 988, 90, 329471, 0, 29, 1928, 922, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2872, NULL, -1, 19, 47, 1015, 90, 329494, 0, 29, 1951, 933, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2873, NULL, -1, 19, 47, 985, 90, 329517, 0, 28, 1974, 944, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2874, NULL, -1, 19, 47, 979, 90, 329539, 0, 28, 1996, 955, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2875, NULL, -1, 19, 47, 993, 90, 329562, 0, 28, 2019, 966, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2876, NULL, -1, 18, 47, 967, 90, 329585, 0, 28, 2042, 976, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2877, NULL, -1, 19, 47, 945, 90, 329607, 0, 28, 2064, 987, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2878, NULL, -1, 19, 47, 982, 90, 329630, 0, 28, 2087, 998, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2879, NULL, -1, 19, 47, 976, 90, 329653, 0, 28, 2110, 1009, '2013-05-25 19:46:45', '2013-05-25 19:46:45'),
(2880, NULL, -1, 19, 47, 888, 90, 329675, 0, 28, 2132, 1020, '2013-05-25 19:46:45', '2013-05-25 19:46:45');

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

--
-- Dumping data for table `flare_specifications`
--

INSERT INTO `flare_specifications` (`id`, `flare_id`, `capacity_scmh`, `manufacturer_id`, `purchase_date`, `manufacturer_product_id`, `owner_id`, `web_address`, `ftp_address`, `username`, `password`, `data_location`, `created_at`, `updated_at`) VALUES
(15, 'LFG-FLR1', 500, 22, '0000-00-00', 'P2513-01', 24, 'runflare1.dyndns.org', 'runflare1.dyndns.org', 'runflare1', 'run007', '/DATA', '2013-05-26 06:42:31', '2013-05-26 06:42:31'),
(16, 'LFG-FLR10', 500, 23, '0000-00-00', 'P2513-01', 24, 'runflare10.dyndns.org', 'runflare10.dyndns.org', 'runflare10', 'run007', '/DATA', '2013-05-26 06:42:31', '2013-05-26 06:42:31');

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
('20130526063200');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `encrypted_password`, `reset_password_token`, `reset_password_sent_at`, `remember_created_at`, `sign_in_count`, `current_sign_in_at`, `last_sign_in_at`, `current_sign_in_ip`, `last_sign_in_ip`, `created_at`, `updated_at`, `user_type_id`, `name`) VALUES
(5, 'doctorrockso@gmail.com', '$2a$10$fgtqWRsAZPYr91VpHnNCVuqwZoupjjoiIwwbYaff.I9PLu0DXwxiy', NULL, NULL, NULL, 1, '2013-05-26 06:47:58', '2013-05-26 06:47:58', '127.0.0.1', '127.0.0.1', '2013-05-26 06:42:31', '2013-05-26 06:47:58', 2, 'Dr. Rockso'),
(6, 'lemmy@gmail.com', '$2a$10$GLjuGHBbY4F7lS.seS9r/OwZn1V/oXneW06TKP9lkuym744wrLqM.', NULL, NULL, NULL, 2, '2013-05-26 06:48:19', '2013-05-26 06:42:59', '127.0.0.1', '127.0.0.1', '2013-05-26 06:42:31', '2013-05-26 06:48:19', 1, 'Lemmy Kilmister');

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
