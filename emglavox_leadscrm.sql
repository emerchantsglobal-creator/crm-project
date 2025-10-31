-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 21, 2025 at 07:10 PM
-- Server version: 11.4.8-MariaDB-cll-lve-log
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `emglavox_leadscrm`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_log`
--

CREATE TABLE `activity_log` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(128) NOT NULL,
  `target_type` varchar(64) DEFAULT NULL,
  `target_id` varchar(64) DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `ip` varchar(64) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ai_chatbot_visibility`
--

CREATE TABLE `ai_chatbot_visibility` (
  `role` varchar(20) NOT NULL,
  `enabled` tinyint(1) DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `ai_chatbot_visibility`
--

INSERT INTO `ai_chatbot_visibility` (`role`, `enabled`) VALUES
('Admin', 1),
('Sales', 1),
('Billing', 1),
('QC', 0),
('Owner', 1);

-- --------------------------------------------------------

--
-- Table structure for table `ai_conversations`
--

CREATE TABLE `ai_conversations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `who` enum('user','ai') NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ai_settings`
--

CREATE TABLE `ai_settings` (
  `setting` varchar(64) NOT NULL,
  `value` tinyint(1) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ai_settings`
--

INSERT INTO `ai_settings` (`setting`, `value`, `updated_at`) VALUES
('agent_enabled', 1, '2025-09-10 21:17:58'),
('ai_tagging_enabled', 1, '2025-09-10 21:17:58'),
('lead_tagging_enabled', 0, '2025-08-29 19:30:24'),
('predictive_enabled', 1, '2025-09-10 21:17:58'),
('predictive_insights_enabled', 1, '2025-08-29 19:30:24');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` text DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `call_centers`
--

CREATE TABLE `call_centers` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chatbot_settings`
--

CREATE TABLE `chatbot_settings` (
  `id` int(11) NOT NULL,
  `role` varchar(50) NOT NULL,
  `enabled` tinyint(1) DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `chatbot_settings`
--

INSERT INTO `chatbot_settings` (`id`, `role`, `enabled`) VALUES
(1, 'Admin', 1),
(2, 'Owner', 1),
(3, 'Sales', 1),
(4, 'Billing', 0),
(5, 'QC', 0);

-- --------------------------------------------------------

--
-- Table structure for table `commissions`
--

CREATE TABLE `commissions` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `payout_percent` float DEFAULT 0,
  `month` varchar(20) DEFAULT NULL,
  `total_leads` int(11) DEFAULT 0,
  `total_commission` float DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `companies`
--

CREATE TABLE `companies` (
  `id` int(11) NOT NULL,
  `company_uid` varchar(32) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('DME','CGM','LABS','TESTING','DOCTOR') NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `gmb_url` varchar(255) DEFAULT NULL,
  `ein` varchar(32) DEFAULT NULL,
  `ssn_last4` varchar(4) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `group_npi` varchar(32) DEFAULT NULL,
  `taxonomy` varchar(64) DEFAULT NULL,
  `assigned_by_owner` varchar(255) DEFAULT 'E M GLOBAL',
  `registration_type` enum('NEW','OLD','RE-CHANGED') DEFAULT 'NEW',
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `approved_by` int(11) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `uid` varchar(120) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `company_users`
--

CREATE TABLE `company_users` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role_in_company` varchar(64) DEFAULT 'Member'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `dme_leads`
--

CREATE TABLE `dme_leads` (
  `id` int(11) NOT NULL,
  `call_center_name` varchar(255) DEFAULT NULL,
  `patient_full_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `patient_phone` varchar(20) DEFAULT NULL,
  `alternate_phone` varchar(20) DEFAULT NULL,
  `street_address` varchar(255) DEFAULT NULL,
  `street_address_2` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `medicare_number` varchar(100) DEFAULT NULL,
  `ppo_number` varchar(100) DEFAULT NULL,
  `insurance_company` varchar(255) DEFAULT NULL,
  `has_secondary_insurance` varchar(10) DEFAULT NULL,
  `secondary_ppo` varchar(100) DEFAULT NULL,
  `has_deductibles` varchar(10) DEFAULT NULL,
  `deductibles_amount` decimal(10,2) DEFAULT NULL,
  `pain_location` text DEFAULT NULL,
  `brace_requested` text DEFAULT NULL,
  `height` varchar(20) DEFAULT NULL,
  `weight` varchar(20) DEFAULT NULL,
  `doctor_visit` text DEFAULT NULL,
  `brace_type` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `height_weight` varchar(100) DEFAULT NULL,
  `past_brace_order` text DEFAULT NULL,
  `brace_size` varchar(50) DEFAULT NULL,
  `doctor_first_name` varchar(100) DEFAULT NULL,
  `doctor_last_name` varchar(100) DEFAULT NULL,
  `doctor_phone` varchar(20) DEFAULT NULL,
  `doctor_address` text DEFAULT NULL,
  `additional_info` text DEFAULT NULL,
  `lead_status` varchar(50) DEFAULT 'Pending',
  `submitted_by` int(11) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `ai_tag` varchar(100) DEFAULT NULL,
  `qc_status` varchar(50) DEFAULT NULL,
  `qc_comment` text DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `hcpcs_code` varchar(100) DEFAULT NULL,
  `shoe_size` varchar(20) DEFAULT NULL,
  `waist_size` varchar(20) DEFAULT NULL,
  `recordings_shared` varchar(255) DEFAULT NULL,
  `chartnotes_shared` varchar(255) DEFAULT NULL,
  `doctor_name` varchar(255) DEFAULT NULL,
  `lead_status_notes` text DEFAULT NULL,
  `shipping_details` text DEFAULT NULL,
  `lead_cancelled_flag` varchar(10) DEFAULT NULL,
  `cancelled_reason` text DEFAULT NULL,
  `cancelled_proof_url` text DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` datetime DEFAULT current_timestamp(),
  `sales_user_id` int(11) DEFAULT NULL,
  `billing_user_id` int(11) DEFAULT NULL,
  `qc_user_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `google_sheets`
--

CREATE TABLE `google_sheets` (
  `id` int(11) NOT NULL,
  `sheet_name` varchar(255) DEFAULT NULL,
  `sheet_url` text DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `last_synced_at` datetime DEFAULT NULL,
  `sync_status` varchar(50) DEFAULT 'PENDING'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `paid_amount` decimal(12,2) DEFAULT 0.00,
  `status` enum('Draft','Sent','Partially Paid','Paid','Overdue','Cancelled') DEFAULT 'Draft',
  `due_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `lead_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `submitted_by` int(11) DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `billing_status` varchar(50) DEFAULT 'Pending',
  `status` enum('Approved','Declined','Pending') DEFAULT 'Pending',
  `qc_status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `call_center` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `alt_phone` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `medicare` varchar(100) DEFAULT NULL,
  `ppo` varchar(100) DEFAULT NULL,
  `ppo_company` varchar(150) DEFAULT NULL,
  `has_secondary` varchar(10) DEFAULT NULL,
  `secondary_ppo` varchar(100) DEFAULT NULL,
  `has_deductibles` varchar(10) DEFAULT NULL,
  `deductible_amount` varchar(100) DEFAULT NULL,
  `pain_areas` text DEFAULT NULL,
  `visited_doctor` varchar(10) DEFAULT NULL,
  `brace_type` varchar(100) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `height_weight` varchar(100) DEFAULT NULL,
  `prior_brace` text DEFAULT NULL,
  `brace_size` varchar(100) DEFAULT NULL,
  `doctor_name` varchar(100) DEFAULT NULL,
  `doctor_phone` varchar(100) DEFAULT NULL,
  `doctor_address` text DEFAULT NULL,
  `doctor_npi` varchar(50) DEFAULT NULL,
  `insurance` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `ai_tag` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `zip_code` varchar(20) DEFAULT NULL,
  `hcpcs` varchar(255) DEFAULT NULL,
  `height` varchar(50) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `shoe_size` varchar(50) DEFAULT NULL,
  `waist_size` varchar(50) DEFAULT NULL,
  `call_recording` varchar(50) DEFAULT NULL,
  `doctor_orders` varchar(500) DEFAULT NULL,
  `dr_orders` varchar(50) DEFAULT NULL,
  `eligibility_reports` text DEFAULT NULL,
  `authorization_reports` text DEFAULT NULL,
  `sns_check_reports` text DEFAULT NULL,
  `allowed_amounts_status` text DEFAULT NULL,
  `deductibles_reports` text DEFAULT NULL,
  `medical_rec_reports` text DEFAULT NULL,
  `status_notes` text DEFAULT NULL,
  `shipping_details` text DEFAULT NULL,
  `lead_denied_cancelled` varchar(50) DEFAULT NULL,
  `lead_denied_cancelled_reason` text DEFAULT NULL,
  `lead_denied_cancelled_proof` text DEFAULT NULL,
  `external_key` varchar(64) DEFAULT NULL,
  `qc_stage_code` varchar(64) DEFAULT NULL,
  `billing_stage_code` varchar(64) DEFAULT NULL,
  `date_of_lead` datetime DEFAULT NULL,
  `dos` date DEFAULT NULL,
  `insurance_ppo_id` varchar(120) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `leads`
--

INSERT INTO `leads` (`id`, `name`, `phone`, `email`, `submitted_by`, `owner_id`, `billing_status`, `status`, `qc_status`, `created_at`, `updated_at`, `call_center`, `first_name`, `last_name`, `alt_phone`, `address`, `medicare`, `ppo`, `ppo_company`, `has_secondary`, `secondary_ppo`, `has_deductibles`, `deductible_amount`, `pain_areas`, `visited_doctor`, `brace_type`, `gender`, `height_weight`, `prior_brace`, `brace_size`, `doctor_name`, `doctor_phone`, `doctor_address`, `doctor_npi`, `insurance`, `dob`, `notes`, `ai_tag`, `middle_name`, `city`, `state`, `zip`, `zip_code`, `hcpcs`, `height`, `weight`, `shoe_size`, `waist_size`, `call_recording`, `doctor_orders`, `dr_orders`, `eligibility_reports`, `authorization_reports`, `sns_check_reports`, `allowed_amounts_status`, `deductibles_reports`, `medical_rec_reports`, `status_notes`, `shipping_details`, `lead_denied_cancelled`, `lead_denied_cancelled_reason`, `lead_denied_cancelled_proof`, `external_key`, `qc_stage_code`, `billing_stage_code`, `date_of_lead`, `dos`, `insurance_ppo_id`) VALUES
(1, '[value-2]', '[value-3]', '[value-4]', 0, NULL, '[value-6]', 'Pending', '[value-7]', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '[value-10]', '[value-11]', '[value-12]', '[value-13]', '[value-14]', '[value-15]', '[value-16]', NULL, '[value-17]', '[value-18]', '[value-19]', '[value-20]', '[value-21]', '[value-22]', '[value-23]', '[value-24]', '[value-25]', '[value-26]', '[value-27]', '[value-28]', '[value-29]', '[value-30]', '[value-31]', '[value-32]', '0000-00-00', '[value-34]', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'md Islam', '8327868089', 'marketing.microsmart@gmail.com', NULL, NULL, 'Pending', 'Pending', 'Pending', '2025-06-17 22:30:33', '2025-09-01 02:51:12', 'MD', 'md', 'Islam', '', '1469 35TH ST , nd usa, postals', 'HVJHJHu677', '9876', NULL, 'No', '9876', 'No', 'no', 'BACKS', 'Yes', 'm', 'Male', '123', 'NO', 'MID', 'BFFD', '7019757101', '1469 35T.', '899', 'EM test', '1978-09-07', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'under_verification', NULL, NULL, NULL),
(3, NULL, '555-123-4567', NULL, 14, NULL, 'Pending', 'Pending', 'Pending', '2025-08-27 19:49:25', '2025-08-27 19:49:25', 'Test Marketer', 'John', 'Testrun', NULL, '123 Test St', 'Blue Cross PPO', 'Knee', 'Pain Relief Knee Brace', NULL, NULL, NULL, NULL, '5\'8 / 180lbs / 9 / 34\"', NULL, 'Yes', 'M', NULL, NULL, NULL, 'Pending', 'Testing sync row', NULL, 'Not Shipped', NULL, '1980-01-01', NULL, NULL, '', 'Test City, TX 75001', 'M1234567', 'PPO123456', NULL, 'Yes', 'Dr. Smith', '1234567890', '555-987-6543', '456 Clinic Rd, TX', 'Eligible', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(4, NULL, '555-123-4567', NULL, 14, NULL, 'Pending', 'Pending', 'Pending', '2025-08-27 19:49:51', '2025-08-27 19:49:51', 'Test Marketer', 'John', 'Testrun', NULL, '123 Test St', 'Blue Cross PPO', 'Knee', 'Pain Relief Knee Brace', NULL, NULL, NULL, NULL, '5\'8 / 180lbs / 9 / 34\"', NULL, 'Yes', 'M', NULL, NULL, NULL, 'Pending', 'Testing sync row', NULL, 'Not Shipped', NULL, '1980-01-01', NULL, NULL, '', 'Test City, TX 75001', 'M1234567', 'PPO123456', NULL, 'Yes', 'Dr. Smith', '1234567890', '555-987-6543', '456 Clinic Rd, TX', 'Eligible', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, NULL, '555-123-4567', NULL, 14, NULL, 'Pending', 'Pending', 'Pending', '2025-08-28 12:11:40', '2025-08-28 12:11:40', 'Test Marketer', 'John', 'Testrun', NULL, '123 Test St', 'Blue Cross PPO', 'Knee', 'Pain Relief Knee Brace', NULL, NULL, NULL, NULL, '5\'8 / 180lbs / 9 / 34\"', NULL, 'Yes', 'M', NULL, NULL, NULL, 'Pending', 'Testing sync row', NULL, 'Not Shipped', NULL, '1980-01-01', NULL, NULL, '', 'Test City, TX 75001', 'M1234567', 'PPO123456', NULL, 'Yes', 'Dr. Smith', '1234567890', '555-987-6543', '456 Clinic Rd, TX', 'Eligible', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(6, NULL, '7019757101', NULL, NULL, NULL, 'Pending', 'Pending', 'Pending', '2025-08-28 12:17:44', '2025-08-28 12:17:44', 'EMGLOBAL08', 'MD MOZAMMAL', 'K RAJU', NULL, '1469 35TH ST S APT 310', 'HVJHJHu677trfdd', 'AN9876', NULL, NULL, NULL, NULL, NULL, 'BACKS', NULL, 'm', 'M', NULL, NULL, NULL, 'dr ansrew', '215-9897-0099', '1469 35TH ST', '767889555', 'PPO ANTHEM', '1977-12-31', '{\"middle_name\":\"\",\"city\":\"FARGO\",\"state\":\"ND\",\"zip\":\"58103\",\"ppo_company\":\"ANTHEM\",\"hcpcs\":\"\",\"height\":\"5 feet\",\"weight\":\"150 lbs\",\"shoe_size\":\"25\",\"waist_size\":\"130\",\"call_recording\":\"yes\",\"doctor_orders\":\"yes\"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(7, NULL, '555-123-4567', NULL, 14, NULL, 'Pending', 'Approved', 'Pending', '2025-08-28 16:03:51', '2025-10-19 23:10:38', 'Test Marketer', 'John', 'Testrun', NULL, '123 Test St', 'Blue Cross PPO', 'Knee', 'Pain Relief Knee Brace', NULL, NULL, NULL, NULL, '5\'8 / 180lbs / 9 / 34\"', NULL, 'Yes', 'M', NULL, NULL, NULL, 'Pending', 'Testing sync row', NULL, 'Not Shipped', NULL, '1980-01-01', NULL, NULL, '', 'Test City, TX 75001', 'M1234567', 'PPO123456', NULL, 'Yes', 'Dr. Smith', '1234567890', '555-987-6543', '456 Clinic Rd, TX', 'Eligible', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, '8462de2635977c1caabdae08aa213de1f453746a', 'Not Billed', 'claims_billed', NULL, NULL, NULL),
(8, NULL, '5551234567', NULL, 14, 14, 'Pending', '', 'Pending', '2025-09-03 16:12:51', '2025-10-19 20:42:33', 'Test Marketer', 'John', 'Testrun', NULL, '123 Test St', 'Blue Cross PPO', 'Knee', 'Pain Relief Knee Brace', NULL, NULL, NULL, NULL, '5\'8 / 180lbs / 9 / 34\"', NULL, 'Yes', 'M', NULL, NULL, NULL, 'Pending', 'Testing sync row', NULL, 'Not Shipped', NULL, '1980-01-01', NULL, NULL, NULL, 'Test City, TX 75001', 'M1234567', 'PPO123456', NULL, 'Yes', 'Dr. Smith', '1234567890', '555-987-6543', '456 Clinic Rd, TX', 'Eligible', 'Approved', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lead_attachments`
--

CREATE TABLE `lead_attachments` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_by` int(11) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lead_export_log`
--

CREATE TABLE `lead_export_log` (
  `id` int(11) NOT NULL,
  `exported_by` int(11) DEFAULT NULL,
  `exported_role` varchar(50) DEFAULT NULL,
  `filter_used` text DEFAULT NULL,
  `exported_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lead_history`
--

CREATE TABLE `lead_history` (
  `id` int(11) NOT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `changed_by` int(11) DEFAULT NULL,
  `change_type` varchar(100) DEFAULT NULL,
  `old_value` text DEFAULT NULL,
  `new_value` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `changed_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lead_status_catalog`
--

CREATE TABLE `lead_status_catalog` (
  `id` int(11) NOT NULL,
  `scope` enum('global','qc','billing') NOT NULL DEFAULT 'global',
  `name` varchar(80) NOT NULL,
  `color` varchar(20) NOT NULL DEFAULT 'primary',
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lead_status_catalog`
--

INSERT INTO `lead_status_catalog` (`id`, `scope`, `name`, `color`, `is_active`) VALUES
(1, 'global', 'New Lead', 'secondary', 1),
(2, 'global', 'Approved', 'success', 1),
(3, 'global', 'Declined', 'danger', 1),
(4, 'global', 'Pending', 'warning', 1),
(5, 'qc', 'Not Started', 'secondary', 1),
(6, 'qc', 'In Review', 'primary', 1),
(7, 'qc', 'Approved', 'success', 1),
(8, 'qc', 'Rejected', 'danger', 1),
(9, 'qc', 'Needs Correction', 'warning', 1),
(10, 'billing', 'Not Billed', 'secondary', 1),
(11, 'billing', 'Billed', 'info', 1),
(12, 'billing', 'Payment Pending', 'warning', 1),
(13, 'billing', 'Paid', 'success', 1),
(14, 'billing', 'Denied', 'danger', 1),
(15, 'billing', 'Rebill Required', 'dark', 1);

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `logged_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `body` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reply_to_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `subject`, `body`, `created_at`, `reply_to_id`) VALUES
(1, 7, 11, 'MAKE Q.C PROPERLY', 'MAKE IT OKAY.', '2025-08-27 13:44:10', NULL),
(2, 7, 8, 'hello owner', 'Please start posting leads now.', '2025-08-28 12:08:53', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `owner_google_sheets`
--

CREATE TABLE `owner_google_sheets` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `sheet_id` varchar(255) NOT NULL,
  `sheet_range` varchar(50) DEFAULT 'A:Z',
  `sync_enabled` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `owner_google_sheets`
--

INSERT INTO `owner_google_sheets` (`id`, `owner_id`, `sheet_id`, `sheet_range`, `sync_enabled`, `created_at`, `updated_at`) VALUES
(1, 14, '1xPvDhYapGHQyILwYHkmeAHdQMYPjnLy2SCiNtXjDJI8', 'A:Z', 1, '2025-08-15 22:44:17', '2025-08-15 22:44:17');

-- --------------------------------------------------------

--
-- Table structure for table `owner_sales`
--

CREATE TABLE `owner_sales` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `sales_id` int(11) NOT NULL,
  `assigned_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `owner_sales`
--

INSERT INTO `owner_sales` (`id`, `owner_id`, `sales_id`, `assigned_at`) VALUES
(4, 14, 15, '2025-07-27 22:47:20'),
(5, 8, 10, '2025-07-30 16:52:13');

-- --------------------------------------------------------

--
-- Table structure for table `owner_sheets`
--

CREATE TABLE `owner_sheets` (
  `id` int(11) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `google_sheet_id` varchar(128) NOT NULL,
  `sheet_tab` varchar(128) DEFAULT NULL,
  `sheet_range` varchar(32) DEFAULT 'A:Z',
  `sync_enabled` tinyint(1) DEFAULT 1,
  `last_sync_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `owner_sheets`
--

INSERT INTO `owner_sheets` (`id`, `owner_id`, `google_sheet_id`, `sheet_tab`, `sheet_range`, `sync_enabled`, `last_sync_at`, `created_at`) VALUES
(1, 8, '', NULL, 'A:Z', 0, NULL, '2025-08-14 21:13:13'),
(2, 12, '', NULL, 'A:Z', 0, NULL, '2025-08-14 21:13:13'),
(3, 14, '', NULL, 'A:Z', 0, NULL, '2025-08-14 21:13:13');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `call_center_id` int(11) DEFAULT NULL,
  `month` varchar(20) DEFAULT NULL,
  `total_leads` int(11) DEFAULT NULL,
  `total_commission` decimal(10,2) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `perm_key` varchar(128) NOT NULL,
  `perm_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `perm_key`, `perm_name`) VALUES
(1, 'dashboard.view', 'View Admin Dashboard'),
(2, 'users.view', 'View Users'),
(3, 'users.manage', 'Create/Edit/Status/Delete Users'),
(4, 'permissions.view', 'View Permissions Matrix'),
(5, 'permissions.manage', 'Edit Role Permissions'),
(6, 'logs.view', 'View Activity Logs'),
(7, 'sync.view', 'View Google Sync Checker'),
(8, 'sync.run', 'Run Google Sync Manually');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role` enum('Admin','Manager','Agent','Viewer') NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role`, `permission_id`) VALUES
('Admin', 1),
('Manager', 1),
('Agent', 1),
('Viewer', 1),
('Admin', 2),
('Manager', 2),
('Agent', 2),
('Admin', 3),
('Manager', 3),
('Admin', 4),
('Manager', 4),
('Admin', 5),
('Admin', 6),
('Manager', 6),
('Admin', 7),
('Manager', 7),
('Agent', 7),
('Admin', 8),
('Manager', 8);

-- --------------------------------------------------------

--
-- Table structure for table `sheet_sources`
--

CREATE TABLE `sheet_sources` (
  `id` int(11) NOT NULL,
  `sheet_name` varchar(255) NOT NULL,
  `webhook_token` varchar(100) NOT NULL,
  `owner_user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `statuses`
--

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL,
  `code` varchar(80) NOT NULL DEFAULT '',
  `label` varchar(255) NOT NULL DEFAULT '',
  `sort_order` int(11) NOT NULL DEFAULT 100,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `statuses`
--

INSERT INTO `statuses` (`id`, `code`, `label`, `sort_order`, `active`) VALUES
(1, 'CLAIMS UNDER PROCESS', 'CLAIMS BILLED. INSURANCE', 100, 1);

-- --------------------------------------------------------

--
-- Table structure for table `status_catalog`
--

CREATE TABLE `status_catalog` (
  `id` int(11) NOT NULL,
  `scope` enum('global','qc','billing') NOT NULL,
  `code` varchar(64) NOT NULL,
  `label` varchar(100) NOT NULL,
  `color` varchar(7) NOT NULL DEFAULT '#6c757d',
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `status_catalog`
--

INSERT INTO `status_catalog` (`id`, `scope`, `code`, `label`, `color`, `is_active`) VALUES
(1, 'global', 'Pending', 'Pending', '#ffc107', 1),
(2, 'global', 'Approved', 'Approved', '#198754', 1),
(3, 'global', 'Declined', 'Declined', '#dc3545', 1),
(4, 'qc', 'qc_pending', 'QC Pending', '#ffc107', 1),
(5, 'qc', 'qc_passed', 'QC Passed', '#198754', 1),
(6, 'qc', 'qc_failed', 'QC Failed', '#dc3545', 1),
(7, 'billing', 'claims_billed', 'Claims Billed', '#0d6efd', 1),
(8, 'billing', 'denied', 'Denied', '#dc3545', 1),
(9, 'billing', 'cancelled', 'Cancelled', '#6c757d', 1),
(10, 'billing', 'under_verification', 'Under Verification', '#fd7e14', 1),
(11, 'billing', 'more_info_needed', 'More Info Needed', '#6f42c1', 1),
(12, 'billing', 'waiting_payment', 'Waiting for Payment', '#20c997', 1),
(13, 'billing', 'paid', 'Paid', '#198754', 1),
(14, 'billing', 'payment_collected', 'Payment Collected', '#0d6efd', 1),
(15, 'billing', 'settled', 'Settled', '#0dcaf0', 1),
(16, 'billing', 'returned', 'Returned', '#6610f2', 1),
(17, 'billing', 'refunded', 'Refunded', '#0dcaf0', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','Billing','QC','Sales','Owner') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `bank_info` text DEFAULT NULL,
  `payout_method` varchar(100) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `call_center_name` varchar(255) DEFAULT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `whatsapp_number` varchar(50) DEFAULT NULL,
  `skype_id` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `payout_email` varchar(255) DEFAULT NULL,
  `bank_account_name` varchar(255) DEFAULT NULL,
  `bank_account_number` varchar(100) DEFAULT NULL,
  `bank_routing` varchar(100) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `bank_address` text DEFAULT NULL,
  `bank_country` varchar(100) DEFAULT NULL,
  `bank_type` enum('Personal','Business') DEFAULT 'Personal',
  `id_number` varchar(100) DEFAULT NULL,
  `id_issue_date` date DEFAULT NULL,
  `id_expiry_date` date DEFAULT NULL,
  `id_country` varchar(100) DEFAULT NULL,
  `id_file_url` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `verification_token` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `status` enum('Active','Paused','Deactivated') NOT NULL DEFAULT 'Active',
  `deleted_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `owner_id` int(11) DEFAULT NULL,
  `company` varchar(150) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `payout_details` text DEFAULT NULL,
  `terms_agreed` tinyint(1) DEFAULT 0,
  `kyc_agreed` tinyint(1) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `full_name`, `phone`, `password`, `role`, `created_at`, `first_name`, `last_name`, `email`, `company_name`, `bank_info`, `payout_method`, `profile_image`, `call_center_name`, `phone_number`, `whatsapp_number`, `skype_id`, `address`, `city`, `state`, `country`, `zipcode`, `payout_email`, `bank_account_name`, `bank_account_number`, `bank_routing`, `bank_name`, `bank_address`, `bank_country`, `bank_type`, `id_number`, `id_issue_date`, `id_expiry_date`, `id_country`, `id_file_url`, `is_verified`, `verification_token`, `reset_token`, `reset_token_expiry`, `status`, `deleted_at`, `last_login_at`, `updated_at`, `owner_id`, `company`, `zip`, `payout_details`, `terms_agreed`, `kyc_agreed`) VALUES
(7, 'admin', NULL, NULL, 'admin123', 'Admin', '2025-07-17 23:43:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-08-19 17:07:47', NULL, NULL, NULL, NULL, 0, 0),
(8, 'EMGLOBAL08', NULL, NULL, '$2y$10$F5tYb3to2Y9AHujuxpgeyuDfPyH9U5S5gK9hlH9xKZbh.pUhuPHGS', 'Owner', '2025-07-17 23:54:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-08-30 17:07:12', NULL, NULL, NULL, NULL, 0, 0),
(9, 'billing02', NULL, NULL, 'Billing2021', 'Billing', '2025-07-17 23:55:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-08-19 17:07:47', NULL, NULL, NULL, NULL, 0, 0),
(10, 'sales01', NULL, NULL, 'Sales2021', 'Sales', '2025-07-17 23:56:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-09-05 21:08:44', 14, NULL, NULL, NULL, 0, 0),
(11, 'qcagent', NULL, NULL, 'qc2021', 'QC', '2025-07-17 23:57:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-08-19 17:07:47', NULL, NULL, NULL, NULL, 0, 0),
(12, 'IMAXTECHNOLOGIES', NULL, NULL, '$2y$10$qP7Sbx4QnJfzlEiCd8rO2.Yzjerau5H4/kdn4nmKGYIe/VBQRwDke', 'Owner', '2025-07-18 21:18:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-08-30 17:08:14', NULL, NULL, NULL, NULL, 0, 0),
(13, 'IMAX01', NULL, NULL, 'IMAXSales@01', 'Sales', '2025-07-18 21:21:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, '', NULL, NULL, '2025-10-19 02:57:17', NULL, NULL, NULL, NULL, 0, 0),
(14, 'SBEIntellicomowner', NULL, NULL, 'SbeIntell@2025', 'Owner', '2025-07-19 00:45:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-10-20 17:02:02', 14, NULL, NULL, NULL, 0, 0),
(16, 'SA_OWNER', NULL, NULL, 'sarimkhan1898', 'Owner', '2025-10-21 06:37:46', 'SARIM', 'KHAN', 'sarimkhan1898@gmail.com', NULL, NULL, 'Bank wires', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, 'Personal', NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 'Active', NULL, NULL, '2025-10-21 02:37:46', NULL, 'ENG', NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_messages`
--

CREATE TABLE `user_messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `read_status` tinyint(1) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_permissions`
--

CREATE TABLE `user_permissions` (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `allowed` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_log`
--
ALTER TABLE `activity_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ai_chatbot_visibility`
--
ALTER TABLE `ai_chatbot_visibility`
  ADD PRIMARY KEY (`role`);

--
-- Indexes for table `ai_conversations`
--
ALTER TABLE `ai_conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ai_user` (`user_id`);

--
-- Indexes for table `ai_settings`
--
ALTER TABLE `ai_settings`
  ADD PRIMARY KEY (`setting`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `call_centers`
--
ALTER TABLE `call_centers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `chatbot_settings`
--
ALTER TABLE `chatbot_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role` (`role`);

--
-- Indexes for table `commissions`
--
ALTER TABLE `commissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `companies`
--
ALTER TABLE `companies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `company_uid` (`company_uid`),
  ADD KEY `idx_companies_status` (`status`);

--
-- Indexes for table `company_users`
--
ALTER TABLE `company_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_company_user` (`company_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `dme_leads`
--
ALTER TABLE `dme_leads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `google_sheets`
--
ALTER TABLE `google_sheets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_invoices_company` (`company_id`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_leads_external_key` (`external_key`),
  ADD UNIQUE KEY `unique_lead` (`owner_id`,`phone`,`dob`),
  ADD KEY `idx_billing_status` (`billing_status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_submitted_by` (`submitted_by`),
  ADD KEY `idx_leads_owner` (`owner_id`),
  ADD KEY `idx_leads_qc_stage` (`qc_stage_code`),
  ADD KEY `idx_leads_billing_stage` (`billing_stage_code`);

--
-- Indexes for table `lead_attachments`
--
ALTER TABLE `lead_attachments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lead_export_log`
--
ALTER TABLE `lead_export_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lead_history`
--
ALTER TABLE `lead_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lead_status_catalog`
--
ALTER TABLE `lead_status_catalog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_scope_name` (`scope`,`name`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `receiver_id` (`receiver_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `idx_reply_to` (`reply_to_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owner_google_sheets`
--
ALTER TABLE `owner_google_sheets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_owner` (`owner_id`);

--
-- Indexes for table `owner_sales`
--
ALTER TABLE `owner_sales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `owner_sheets`
--
ALTER TABLE `owner_sheets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_owner` (`owner_id`),
  ADD KEY `idx_sync_enabled` (`sync_enabled`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `call_center_id` (`call_center_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `perm_key` (`perm_key`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role`,`permission_id`),
  ADD KEY `fk_rp_perm` (`permission_id`);

--
-- Indexes for table `sheet_sources`
--
ALTER TABLE `sheet_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `webhook_token` (`webhook_token`);

--
-- Indexes for table `statuses`
--
ALTER TABLE `statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `status_catalog`
--
ALTER TABLE `status_catalog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_scope_code` (`scope`,`code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_users_role_status` (`role`,`status`),
  ADD KEY `idx_users_owner` (`owner_id`);

--
-- Indexes for table `user_messages`
--
ALTER TABLE `user_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD PRIMARY KEY (`user_id`,`permission_id`),
  ADD KEY `fk_up_perm` (`permission_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_log`
--
ALTER TABLE `activity_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ai_conversations`
--
ALTER TABLE `ai_conversations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `call_centers`
--
ALTER TABLE `call_centers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chatbot_settings`
--
ALTER TABLE `chatbot_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `commissions`
--
ALTER TABLE `commissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `companies`
--
ALTER TABLE `companies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `company_users`
--
ALTER TABLE `company_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dme_leads`
--
ALTER TABLE `dme_leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `google_sheets`
--
ALTER TABLE `google_sheets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `lead_attachments`
--
ALTER TABLE `lead_attachments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lead_export_log`
--
ALTER TABLE `lead_export_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lead_history`
--
ALTER TABLE `lead_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lead_status_catalog`
--
ALTER TABLE `lead_status_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `owner_google_sheets`
--
ALTER TABLE `owner_google_sheets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `owner_sales`
--
ALTER TABLE `owner_sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `owner_sheets`
--
ALTER TABLE `owner_sheets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `sheet_sources`
--
ALTER TABLE `sheet_sources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `statuses`
--
ALTER TABLE `statuses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `status_catalog`
--
ALTER TABLE `status_catalog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `user_messages`
--
ALTER TABLE `user_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD CONSTRAINT `fk_up_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
