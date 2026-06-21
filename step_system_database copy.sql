-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 31, 2026 at 05:55 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `step2`
--

-- --------------------------------------------------------

--
-- Table structure for table `approval`
--

CREATE TABLE `approval` (
  `id` char(36) NOT NULL,
  `employee_id` varchar(100) DEFAULT NULL,
  `project_id` char(36) DEFAULT NULL,
  `reference_type` varchar(100) DEFAULT NULL,
  `approvable_type` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `officers_approved` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `actionable_id` varchar(100) DEFAULT NULL,
  `actionable_type` varchar(100) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `module` varchar(100) DEFAULT NULL,
  `action_type` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `browser_info` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('26df601b-a438-49ff-b6d6-548d9e6faddc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 09:54:23', 0),
('5d72cca0-211c-46e8-9d82-42c04a8734ce', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:39', 0),
('76890987-36b0-471e-9a76-ff6d2bdfbaf8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TESTING\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:44:07', 0),
('966502e3-3aca-421e-b267-3a1fe5087ed6', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '81f86e97-f3b4-4ab0-b437-9396875ac877', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:03:29', 0),
('a9a68477-43da-47b4-b69b-05fab089b10d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:56:17', 0),
('a9ca6f4c-3b0b-49c6-bee2-bb4e1d52c5cb', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:24:15', 0),
('aef0ce0a-7df2-422e-b7d1-6013f2fa3776', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'emdgquintos — TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:23:57', 0),
('e2e0b8b3-d4b1-4672-a2f5-06dd7dbb7877', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:57', 0),
('e6e29f6b-9348-44a5-9ddc-aa7fddb999f0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:28:00', 0),
('ed821bc2-ec85-4c96-8405-77e2a0535329', '087ccbc9-efa8-44e0-8435-3310207554d7', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 12:24:48', 0);

-- --------------------------------------------------------

--
-- Table structure for table `badge`
--

CREATE TABLE `badge` (
  `id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `badge`
--

INSERT INTO `badge` (`id`, `name`, `description`, `icon`, `category`, `created_at`, `updated_at`, `archive`) VALUES
('05aa4b9c-235d-11f1-9647-10683825ce81', 'Event Organizer', 'Successfully organized an event', 'star', 'achievement', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa4d10-235d-11f1-9647-10683825ce81', 'Active Member', 'Participated in 5+ events', 'flame', 'engagement', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5cdb-235d-11f1-9647-10683825ce81', 'Budget Master', 'Managed project budget efficiently', 'coins', 'financial', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5ddb-235d-11f1-9647-10683825ce81', 'Team Leader', 'Led a successful project', 'crown', 'leadership', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5e25-235d-11f1-9647-10683825ce81', 'Quick Approver', 'Approved projects within 24 hours', 'flash', 'performance', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5e68-235d-11f1-9647-10683825ce81', 'Documentation Pro', 'Submitted complete project documentation', 'document', 'quality', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5eac-235d-11f1-9647-10683825ce81', 'Community Hero', 'Contributed to community service', 'heart', 'community', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0);

-- --------------------------------------------------------

--
-- Table structure for table `badge_collected`
--

CREATE TABLE `badge_collected` (
  `id` char(36) NOT NULL,
  `badge_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `earned_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chain`
--

CREATE TABLE `chain` (
  `id` char(36) NOT NULL,
  `project_id` char(36) DEFAULT NULL,
  `block_index` int(11) NOT NULL DEFAULT 0,
  `prev_hash` varchar(255) DEFAULT NULL,
  `hash` varchar(255) DEFAULT NULL,
  `data_snapshot` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `chain`
--

INSERT INTO `chain` (`id`, `project_id`, `block_index`, `prev_hash`, `hash`, `data_snapshot`, `created_at`) VALUES
('495a3be7-d8ca-4c57-b8fa-c4dd4e146663', 'e6808957-5fca-42ef-813a-446935e61126', 1, '77db84e18d6eed03125bd29254ecf915f80a95df10fbd20721937eceb72bf40e', '6ee3ddda0f513bd562f67b253346edf1a37b253e5f8bf9a5248901164df52e5c', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"b55d1a03-f4f8-4592-8573-eb3dc6de246d\\\",\\\"project_id\\\":\\\"e6808957-5fca-42ef-813a-446935e61126\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"9000.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-05-26T02:54:23+00:00\\\",\\\"snapshot_nonce\\\":\\\"30656874b281439f\\\"}\"', '2026-05-26 02:54:23'),
('82988b23-941d-4131-bb89-4dc212e1671f', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 0, NULL, '58edf29a2345e763b7e5952b8f632f7cd1626829f7d9e4812731cbe672ea110d', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"2e8dc2e7-5618-44b4-9230-a48658daf0a6\\\",\\\"title\\\":\\\"test2\\\",\\\"description\\\":\\\"test2\\\",\\\"amount\\\":\\\"0.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-05-26T05:24:48+00:00\\\"}\"', '2026-05-26 05:24:48'),
('873ef469-f013-4577-8a06-4a62ecb0c7f3', 'e6808957-5fca-42ef-813a-446935e61126', 2, '6ee3ddda0f513bd562f67b253346edf1a37b253e5f8bf9a5248901164df52e5c', 'f5ca985927f6525375b6588fed17390a7575ad7f7c91ce9013636e1473a606df', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"b1be13a0-1aa8-4fca-bbef-e28771a65872\\\",\\\"project_id\\\":\\\"e6808957-5fca-42ef-813a-446935e61126\\\",\\\"description\\\":\\\"emdgquintos\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"emdgquintos\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"12\\\\\\\",\\\\\\\"amount\\\\\\\":12}]\\\",\\\"amount\\\":\\\"12.00\\\",\\\"entry_type\\\":\\\"Income\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-05-26T03:23:57+00:00\\\",\\\"snapshot_nonce\\\":\\\"9fbe6f91a196e200\\\"}\"', '2026-05-26 03:23:57'),
('9125283b-5a09-4fe7-912d-b88d87d62e80', 'e6808957-5fca-42ef-813a-446935e61126', 0, NULL, '77db84e18d6eed03125bd29254ecf915f80a95df10fbd20721937eceb72bf40e', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"e6808957-5fca-42ef-813a-446935e61126\\\",\\\"title\\\":\\\"TESTING\\\",\\\"description\\\":\\\"TESTING\\\",\\\"amount\\\":\\\"9000.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-05-26T02:54:23+00:00\\\"}\"', '2026-05-26 02:54:23');

--
-- Triggers `chain`
--
DELIMITER $$
CREATE TRIGGER `prevent_chain_deletes` BEFORE DELETE ON `chain` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chain records cannot be deleted';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_chain_updates` BEFORE UPDATE ON `chain` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chain records cannot be updated';
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` char(36) NOT NULL,
  `institute_id` char(36) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `institute_id`, `name`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('059d226e-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSIS', NULL, '2026-03-19 06:29:42', '2026-04-14 05:49:49', 0),
('059d2571-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSCS', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d2612-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSPSY', NULL, '2026-03-19 06:29:42', '2026-04-14 05:49:58', 0),
('059d267c-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSCE', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d26df-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSM', NULL, '2026-03-19 06:29:42', '2026-04-14 05:50:34', 0),
('059d2744-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSN', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d279f-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSocSc', NULL, '2026-03-19 06:29:42', '2026-04-14 05:52:23', 0);

-- --------------------------------------------------------

--
-- Table structure for table `id_verifications`
--

CREATE TABLE `id_verifications` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `role_type` enum('student','teacher') NOT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `teacher_id` varchar(255) DEFAULT NULL,
  `proof_file_path` varchar(255) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `file_mime_type` varchar(255) NOT NULL,
  `file_size` bigint(20) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `admin_notes` longtext DEFAULT NULL,
  `verified_by` char(36) DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `rejection_count` int(11) NOT NULL DEFAULT 0,
  `last_rejection_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `institute`
--

CREATE TABLE `institute` (
  `id` char(36) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `institute`
--

INSERT INTO `institute` (`id`, `name`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('059bab0d-235d-11f1-9647-10683825ce81', 'ICDI', NULL, '2026-03-19 06:29:42', '2026-04-14 07:48:48', 0),
('059bb26f-235d-11f1-9647-10683825ce81', 'IBS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:24', 0),
('059bb31d-235d-11f1-9647-10683825ce81', 'IE', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:38', 0),
('059bb359-235d-11f1-9647-10683825ce81', 'IFS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:45', 0),
('059bb388-235d-11f1-9647-10683825ce81', 'IGDS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:51', 0),
('059bb3b0-235d-11f1-9647-10683825ce81', 'IM', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:59', 0),
('059bb3d9-235d-11f1-9647-10683825ce81', 'CCJ', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('c062692a-37d6-11f1-81d0-0ee6e07d3d3d', 'ISM', NULL, '2026-04-14 07:51:27', '2026-04-14 07:51:27', 0);

-- --------------------------------------------------------

--
-- Table structure for table `ledger_entries`
--

CREATE TABLE `ledger_entries` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `type` enum('Income','Expense','Donation','Sponsorship','Canvas','Initial') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `budget_breakdown` text DEFAULT NULL,
  `ledger_proof` varchar(500) DEFAULT NULL COMMENT 'Path to uploaded proof file',
  `file_content_hash` varchar(64) DEFAULT NULL COMMENT 'SHA-256 hash of uploaded file for integrity verification',
  `approval_status` enum('Draft','Pending Adviser Approval','Approved','Rejected') DEFAULT 'Draft',
  `is_initial_entry` tinyint(1) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL COMMENT 'Approval/rejection notes',
  `approved_by` char(36) DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ledger_entries`
--

INSERT INTO `ledger_entries` (`id`, `project_id`, `type`, `amount`, `description`, `category`, `budget_breakdown`, `ledger_proof`, `file_content_hash`, `approval_status`, `is_initial_entry`, `note`, `approved_by`, `created_by`, `updated_by`, `approved_at`, `rejected_at`, `archive`, `created_at`, `updated_at`) VALUES
('81f86e97-f3b4-4ab0-b437-9396875ac877', 'e6808957-5fca-42ef-813a-446935e61126', 'Expense', 23423.00, 'qwe', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"qwe\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"23423\\\",\\\"amount\\\":23423}]\"', NULL, NULL, 'Pending Adviser Approval', 0, NULL, NULL, '97bf6c0e-420b-4627-be8b-31f37f5bed9f', NULL, NULL, NULL, 0, '2026-05-26 12:03:29', '2026-05-26 12:03:42'),
('b1be13a0-1aa8-4fca-bbef-e28771a65872', 'e6808957-5fca-42ef-813a-446935e61126', 'Income', 12.00, 'emdgquintos', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"emdgquintos\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"12\\\",\\\"amount\\\":12}]\"', NULL, NULL, 'Approved', 0, '12', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-05-26 10:23:57', NULL, 0, '2026-05-26 09:56:17', '2026-05-26 10:23:57'),
('b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'e6808957-5fca-42ef-813a-446935e61126', 'Initial', 9000.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, NULL, NULL, 'Approved', 0, 'Auto-generated baseline on project creation', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-05-26 09:54:23', NULL, 0, '2026-05-26 09:44:07', '2026-05-26 10:27:57');

-- --------------------------------------------------------

--
-- Table structure for table `meeting`
--

CREATE TABLE `meeting` (
  `id` char(36) NOT NULL,
  `student_id` varchar(100) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_done` tinyint(1) DEFAULT 0,
  `minutes_content` text DEFAULT NULL,
  `action_items` text DEFAULT NULL,
  `expected_attendees` text DEFAULT NULL,
  `attendees` text DEFAULT NULL,
  `meeting_proof` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2026_04_09_050446_create_personal_access_tokens_table', 1),
(2, '2026_04_09_120000_add_file_content_hash_to_ledger_entries', 2),
(3, '2026_04_12_000001_add_profile_fields_to_users_table', 3),
(4, '2026_04_14_000000_add_sample_upcoming_meetings', 4),
(5, '2026_04_14_000001_fix_onboarding_foreign_keys', 4),
(6, '2026_04_15_000000_fix_teacher_adviser_fk_constraint', 4),
(7, '2026_04_16_000001_create_push_subscriptions_table', 5),
(8, '2026_04_17_000001_create_id_verification_table', 6),
(9, '2026_04_17_000002_add_id_verification_to_users', 7),
(10, '2026_04_20_add_invitation_tokens_to_users', 8);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `read_at`, `created_at`, `updated_at`, `archive`) VALUES
('06d20008-235d-11f1-9647-10683825ce81', NULL, 'Welcome', 'Thank you for regitering with STEP Platform.', 'system', 0, NULL, '2026-03-20 13:30:00', '2026-04-14 03:55:02', 0);

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `id` char(36) NOT NULL,
  `module` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `permission` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `module`, `action`, `permission`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('059e4bca-235d-11f1-9647-10683825ce81', 'Projects', 'Approve', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e56c0-235d-11f1-9647-10683825ce81', 'Users', 'Create', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e5761-235d-11f1-9647-10683825ce81', 'Meetings', 'Schedule', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e5794-235d-11f1-9647-10683825ce81', 'Reports', 'View', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e57be-235d-11f1-9647-10683825ce81', 'Settings', 'Update', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e57e6-235d-11f1-9647-10683825ce81', 'Audit', 'Export', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e580c-235d-11f1-9647-10683825ce81', 'Roles', 'Assign', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0);

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position`
--

CREATE TABLE `position` (
  `id` char(32) NOT NULL,
  `position_name` varchar(255) DEFAULT NULL,
  `created_at` date NOT NULL DEFAULT current_timestamp(),
  `updated_at` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `position_name`, `created_at`, `updated_at`) VALUES
('0ccfddd1088444f6b51ab3ab2db4136d', 'Student Liaison', '2026-05-31', '2026-05-31'),
('149ec35a62264ad0bfda18568cd63580', 'Press Relations Officer', '2026-05-31', '2026-05-31'),
('1e4c17b97cdd4698bcff7c013968ca0c', 'Secretary', '2026-05-31', '2026-05-31'),
('27add2cb646b4a319e9bdbfc9d8054b6', 'Vice President for External Affairs', '2026-05-31', '2026-05-31'),
('2a7f5a843c864b97ac0696e7b563a1e3', 'Auditor', '2026-05-31', '2026-05-31'),
('4d56f01a349c417080773dd2e903af79', 'Business Manager', '2026-05-31', '2026-05-31'),
('65139933a20941e6b43a6ac994dbaf37', 'IGDS SW Representative', '2026-05-31', '2026-05-31'),
('6c939efb408344c3bd58806f80ed4a9e', 'ICDI CS Representative', '2026-05-31', '2026-05-31'),
('ca496e8495a940dcbfd47577c0dc3804', 'Treasurer', '2026-05-31', '2026-05-31'),
('cbba3880ef414030a6cd1c4ffae6f909', 'IOM Representative', '2026-05-31', '2026-05-31'),
('cd38469e830347ea992a9bef247976de', 'ION Representative', '2026-05-31', '2026-05-31'),
('d4a05f3085ca485481297597809ce86b', 'ICDI IS Representative', '2026-05-31', '2026-05-31'),
('d866ab91189341e582fdcf09ccda7c41', 'President', '2026-05-30', '2026-05-30'),
('f95370650f034c519f0d664804e6e39e', 'Vice President for Internal Affairs', '2026-05-30', '2026-05-30');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` char(36) NOT NULL,
  `student_id` varchar(100) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `objective` text DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `budget` decimal(15,2) DEFAULT NULL,
  `is_initial` tinyint(4) NOT NULL DEFAULT 0,
  `venue` varchar(255) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `proposed_by` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `project_proof` blob DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `approve_by` varchar(255) DEFAULT NULL,
  `approval_status` varchar(50) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` char(36) DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `student_id`, `title`, `description`, `objective`, `category`, `budget`, `is_initial`, `venue`, `status`, `proposed_by`, `note`, `project_proof`, `start_date`, `end_date`, `approve_by`, `approval_status`, `approved_at`, `created_at`, `updated_at`, `created_by`, `updated_by`, `archive`) VALUES
('2e8dc2e7-5618-44b4-9230-a48658daf0a6', NULL, 'test2', 'test2', 'test2', 'Sports', 0.00, 0, 'test2', 'Draft', 'test2', 'emdgquintos', NULL, '2026-06-26', '2026-06-30', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-05-26 12:24:48', '2026-05-26 12:24:15', '2026-05-26 12:24:48', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '087ccbc9-efa8-44e0-8435-3310207554d7', 0),
('e6808957-5fca-42ef-813a-446935e61126', NULL, 'TESTING', 'TESTING', 'TESTING', 'Sports', 9012.00, 1, 'TESTING', 'Draft', 'TESTING', 'emdgquintos', NULL, '2026-06-25', '2026-06-25', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-05-26 09:54:23', '2026-05-26 09:44:07', '2026-05-26 10:28:00', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', 0);

-- --------------------------------------------------------

--
-- Table structure for table `push_subscriptions`
--

CREATE TABLE `push_subscriptions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `endpoint` text NOT NULL,
  `auth_key` text NOT NULL,
  `public_key` text NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` char(36) NOT NULL,
  `project_id` char(36) DEFAULT NULL,
  `user_id` char(36) DEFAULT NULL,
  `rating_score` int(11) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `helpful_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `project_id`, `user_id`, `rating_score`, `comments`, `helpful_count`, `created_at`, `archive`) VALUES
('598910fc-5661-47ca-b1c9-938b5ea790c2', 'e6808957-5fca-42ef-813a-446935e61126', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 5, '123', 0, '2026-05-26 10:29:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reset_password_token`
--

CREATE TABLE `reset_password_token` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` char(36) NOT NULL,
  `permission_id` char(36) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `permission_id`, `name`, `slug`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Super Admin', 'superadmin', 'Full system access with all permissions', '2026-03-19 06:29:42', '2026-03-19 06:32:19', 0),
('059ef712-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', '2026-03-19 06:29:42', '2026-03-19 06:32:48', 0),
('059efde1-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'CSG Officer', 'csg', 'Organization operations and submissions', '2026-03-19 06:29:42', '2026-03-19 06:33:09', 0),
('059f4170-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Student', 'student', 'View, rate, and engage in projects', '2026-03-19 06:29:42', '2026-03-19 06:33:29', 0),
('059f4213-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-03-19 06:29:42', '2026-03-19 06:33:46', 0),
('059f5000-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Admin/SADU', 'admin-sadu', 'Administrator with SADU (Student Affairs and Discipline Office) responsibilities - manages student discipline and welfare', '2026-05-30 20:36:18', '2026-05-30 20:36:18', 0);

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `role_id` char(36) DEFAULT NULL,
  `permission_id` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext DEFAULT NULL,
  `last_activity` int(11) DEFAULT NULL,
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`, `archive`) VALUES
('7o7mVKlP5L9O4EYJxSGnUQb87Y3eIwZhST6Snx2X', '087ccbc9-efa8-44e0-8435-3310207554d7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiUnJjNjE2Wk5pM3U1NWpBcXo4RmpMT1dDWkE1cERmcFlRZGlPa0pINyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZHZpc2VyL3JvbGUtcGVybWlzc2lvbnMvZ2V0LWNvdW5jaWwtdGVybSI7czo1OiJyb3V0ZSI7czo0MToiYWR2aXNlci5yb2xlLXBlcm1pc3Npb25zLmdldC1jb3VuY2lsLXRlcm0iO31zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiMDg3Y2NiYzktZWZhOC00NGUwLTg0MzUtMzMxMDIwNzU1NGQ3Ijt9', 1780199340, 0),
('KROgF53SPFHjCciplcBVHDAasM9QqlBPBMr1tTUv', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiS1NzWXB4dDJIWGpFejRMR1Mxc0psNnRsYzlKUXRNbWN5b0RIQks3SyI7czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO3M6MzY6Ijk3YmY2YzBlLTQyMGItNDYyNy1iZThiLTMxZjM3ZjViZWQ5ZiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9yb2xlLXBlcm1pc3Npb25zL3Bvc2l0aW9ucyI7czo1OiJyb3V0ZSI7czozMjoiYWRtaW4ucm9sZS1wZXJtaXNzaW9ucy5wb3NpdGlvbnMiO319', 1780199640, 0),
('rGuaLtSRf5DDARIbnnxNp29jG3tBw9D9azsXxaiD', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoicFh2SFV1aTNGbzlINWwwODhyYnFOeUtuUFR4bVhDUkFuMFhWbm15VyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyOToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkdmlzZXIiO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czozODoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3NhZG1pbi9kYXNoYm9hcmQiO3M6NToicm91dGUiO3M6MjI6InNhZG1pbi5kYXNoYm9hcmQuYWxpYXMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiOTdiZjZjMGUtNDIwYi00NjI3LWJlOGItMzFmMzdmNWJlZDlmIjt9', 1780190953, 0);

-- --------------------------------------------------------

--
-- Table structure for table `student_csg_officers`
--

CREATE TABLE `student_csg_officers` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `course_id` varchar(100) DEFAULT NULL,
  `is_csg` tinyint(1) DEFAULT 0,
  `csg_position` varchar(100) DEFAULT NULL,
  `csg_term_start` date DEFAULT NULL,
  `csg_term_end` date DEFAULT NULL,
  `csg_is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_csg_officers`
--

INSERT INTO `student_csg_officers` (`id`, `user_id`, `course_id`, `is_csg`, `csg_position`, `csg_term_start`, `csg_term_end`, `csg_is_active`, `created_at`, `updated_at`, `archive`) VALUES
('123', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059d226e-235d-11f1-9647-10683825ce81', 0, 'Member', '2026-05-13', '2026-05-30', 0, '2026-04-24 05:34:53', '2026-05-28 01:20:45', 0),
('12312', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059d226e-235d-11f1-9647-10683825ce81', 1, 'President', '2026-05-28', '2026-09-18', 1, '2026-04-24 05:48:10', '2026-05-31 09:33:23', 0),
('123123', NULL, NULL, 0, NULL, NULL, NULL, 0, '2026-04-24 06:28:24', '2026-05-24 16:27:09', 0);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_adviser`
--

CREATE TABLE `teacher_adviser` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `institute_id` char(36) DEFAULT NULL,
  `is_adviser` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teacher_adviser`
--

INSERT INTO `teacher_adviser` (`id`, `user_id`, `institute_id`, `is_adviser`, `created_at`, `updated_at`, `archive`) VALUES
('123', '087ccbc9-efa8-44e0-8435-3310207554d7', '059bb388-235d-11f1-9647-10683825ce81', 1, '2026-04-24 06:30:43', '2026-05-31 05:31:01', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `role_id` char(36) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `invitation_token` varchar(64) DEFAULT NULL,
  `token_expires_at` timestamp NULL DEFAULT NULL,
  `is_token_expired` tinyint(1) NOT NULL DEFAULT 0,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `profile_completed` tinyint(1) NOT NULL DEFAULT 0,
  `id_verification_id` char(36) DEFAULT NULL,
  `status` enum('active','suspended','archived') DEFAULT 'active',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `email_verified_at`, `invitation_token`, `token_expires_at`, `is_token_expired`, `phone`, `password`, `avatar_url`, `profile_completed`, `id_verification_id`, `status`, `last_login_at`, `remember_token`, `created_at`, `updated_at`, `archive`) VALUES
('087ccbc9-efa8-44e0-8435-3310207554d7', '059ef712-235d-11f1-9647-10683825ce81', 'EDWARD QUINTOS', 'emdgquintos@kld.edu.ph', '2026-04-24 06:30:43', NULL, NULL, 0, '09234234234', '$2y$12$ez57d.qwWe0NGNJYtU0oDer2hVL6c2HIhbVWDHtQn.0kRBPeFNv6C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, NULL, 'active', '2026-05-31 09:54:41', NULL, '2026-04-24 06:30:08', '2026-05-31 10:53:59', 0),
('97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059ef3f9-235d-11f1-9647-10683825ce81', 'JHONNY MACAWILI SUMULONG', 'jmsumulong@kld.edu.ph', '2026-04-24 05:33:52', NULL, NULL, 0, NULL, '$2y$12$0tiBxJWX3qRNRUOr.V0UAu6MEf4y0kXAAU68YpFQQawyIpV8vukli', 'https://lh3.googleusercontent.com/a/ACg8ocLXVrWI7RGw1OTDRtjF9lXO27fk8oBLR-ZI3irgbXl_7fS5sA=s96-c', 1, NULL, 'active', '2026-05-31 08:29:12', NULL, '2026-04-24 05:33:52', '2026-05-31 08:29:12', 0),
('b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059efde1-235d-11f1-9647-10683825ce81', 'LAWRECE CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-04-24 05:48:10', NULL, NULL, 0, '09398331593', '$2y$12$./qxavDvVjZjFlfz4kxRLOdREWZJKpD76iNFbqwNLDATYRi3L3VKK', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, NULL, 'active', '2026-04-26 18:09:04', NULL, '2026-04-24 05:48:10', '2026-05-28 03:38:42', 0),
('f6b776d6-8d77-43e3-976a-fbb0daffa325', '059f4213-235d-11f1-9647-10683825ce81', 'JAMES TAMAYO', 'jttamayo@kld.edu.ph', NULL, NULL, NULL, 0, NULL, '$2y$12$9MvKx3sc82BPlDGMYqxRaeybMw2Lwjp5GX3EsJY5nZ527Ahg528w6', NULL, 0, NULL, 'active', '2026-05-28 01:33:53', NULL, '2026-05-10 09:19:57', '2026-05-28 01:33:53', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approval`
--
ALTER TABLE `approval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `badge`
--
ALTER TABLE `badge`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_category` (`category`);

--
-- Indexes for table `badge_collected`
--
ALTER TABLE `badge_collected`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_badge` (`badge_id`,`user_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_badge_id` (`badge_id`),
  ADD KEY `idx_earned_date` (`earned_date`);

--
-- Indexes for table `chain`
--
ALTER TABLE `chain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institute_id` (`institute_id`);

--
-- Indexes for table `id_verifications`
--
ALTER TABLE `id_verifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_verifications_student_id_foreign` (`student_id`),
  ADD KEY `id_verifications_teacher_id_foreign` (`teacher_id`),
  ADD KEY `id_verifications_user_id_index` (`user_id`),
  ADD KEY `id_verifications_role_type_index` (`role_type`),
  ADD KEY `id_verifications_status_index` (`status`),
  ADD KEY `id_verifications_verified_by_index` (`verified_by`),
  ADD KEY `id_verifications_created_at_index` (`created_at`);

--
-- Indexes for table `institute`
--
ALTER TABLE `institute`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `meeting`
--
ALTER TABLE `meeting`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `position`
--
ALTER TABLE `position`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `push_subscriptions`
--
ALTER TABLE `push_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `push_subscriptions_endpoint_unique` (`endpoint`) USING HASH,
  ADD KEY `push_subscriptions_user_id_is_active_index` (`user_id`,`is_active`),
  ADD KEY `push_subscriptions_is_active_index` (`is_active`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_project_user_rating` (`project_id`,`user_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `reset_password_token`
--
ALTER TABLE `reset_password_token`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `student_csg_officers`
--
ALTER TABLE `student_csg_officers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `teacher_adviser`
--
ALTER TABLE `teacher_adviser`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `institute_id` (`institute_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_invitation_token_unique` (`invitation_token`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `users_id_verification_id_index` (`id_verification_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approval`
--
ALTER TABLE `approval`
  ADD CONSTRAINT `approval_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `teacher_adviser` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `approval_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `badge_collected`
--
ALTER TABLE `badge_collected`
  ADD CONSTRAINT `badge_collected_ibfk_1` FOREIGN KEY (`badge_id`) REFERENCES `badge` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `badge_collected_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chain`
--
ALTER TABLE `chain`
  ADD CONSTRAINT `chain_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`institute_id`) REFERENCES `institute` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `id_verifications`
--
ALTER TABLE `id_verifications`
  ADD CONSTRAINT `id_verifications_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `student_csg_officers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `id_verifications_teacher_id_foreign` FOREIGN KEY (`teacher_id`) REFERENCES `teacher_adviser` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `id_verifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `id_verifications_verified_by_foreign` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD CONSTRAINT `ledger_entries_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ledger_entries_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ledger_entries_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ledger_entries_ibfk_4` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `meeting`
--
ALTER TABLE `meeting`
  ADD CONSTRAINT `meeting_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_csg_officers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student_csg_officers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `push_subscriptions`
--
ALTER TABLE `push_subscriptions`
  ADD CONSTRAINT `push_subscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reset_password_token`
--
ALTER TABLE `reset_password_token`
  ADD CONSTRAINT `reset_password_token_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permission_ibfk_3` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_csg_officers`
--
ALTER TABLE `student_csg_officers`
  ADD CONSTRAINT `student_csg_officers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `student_csg_officers_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `teacher_adviser`
--
ALTER TABLE `teacher_adviser`
  ADD CONSTRAINT `teacher_adviser_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_adviser_ibfk_2` FOREIGN KEY (`institute_id`) REFERENCES `institute` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_id_verification_id_foreign` FOREIGN KEY (`id_verification_id`) REFERENCES `id_verifications` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
