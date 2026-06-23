-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 20, 2026 at 06:18 AM
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
('012276d2-2d85-4eed-84fa-e65733e10f7c', NULL, 'd8791d58-fac4-46cb-8679-0f81570866b3', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dsfgdf', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 16:13:22', 0),
('05a8a69d-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', NULL, NULL, 'Login', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8a865-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', NULL, NULL, 'Created Project', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8a90a-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', NULL, NULL, 'Approved Project', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8a96a-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', NULL, NULL, 'Logout', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8a9c8-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', NULL, NULL, 'Updated User', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8aa25-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', NULL, NULL, 'Deleted Entry', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a8aa86-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', NULL, NULL, 'Exported Data', NULL, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('0b76726a-c9d0-4361-aa15-b5cb7ebb8fe9', NULL, '0d56054d-187f-4db5-88bb-b6048c2a0d50', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: w', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 18:18:01', 0),
('0bd1f682-ff77-4a8d-9f4f-ae4048b0cfc8', NULL, '8e011df2-e700-4b01-8677-d7d63b732ce5', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: a', '127.0.0.1', 'Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 CrKey/1.54.250320', '2026-04-14 16:30:11', 0),
('2ac13fc6-d76e-4b28-bdc3-ea38d63e887f', NULL, '2c9c4c60-f782-48d2-9101-aa92b40db7e9', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdfds', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 19:40:09', 0),
('2b7670fc-dc0e-4093-8db6-e33aca1b854e', NULL, 'd98eb613-2798-4619-ba01-7ffd7ef96e11', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: z', '127.0.0.1', 'Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 CrKey/1.54.250320', '2026-04-14 17:24:36', 0),
('2f1c3557-582a-4251-a9f9-4869b5714b8d', NULL, 'b9134f66-c27e-4b12-8f0b-f7fa58e07873', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 20:36:16', 0),
('6bc0fc4a-0d68-42f0-bb59-41b54a75c089', NULL, '82107b3c-1767-48c8-a690-ead71aa87748', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: wowasd123', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 20:49:06', 0),
('71c10251-7010-404a-b0f0-20dbe9fcbb0e', NULL, '6e9e0dd4-8071-4262-b575-6bfaa90163eb', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdfsd', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 20:06:16', 0),
('e8b0c528-43fb-42d6-9861-d099406357d6', NULL, '684358c0-ddce-437f-9c74-b7d47e717d2d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: Current Budget', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2026-04-14 20:10:58', 0),
('fed06888-ac53-4310-9ab4-fcbeb90ae7ac', NULL, 'd98eb613-2798-4619-ba01-7ffd7ef96e11', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: z', '127.0.0.1', 'Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 CrKey/1.54.250320', '2026-04-14 17:24:36', 0);

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

--
-- Dumping data for table `badge_collected`
--

INSERT INTO `badge_collected` (`id`, `badge_id`, `user_id`, `earned_date`, `created_at`, `archive`) VALUES
('05ab9ce3-235d-11f1-9647-10683825ce81', '05aa4b9c-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43', '2026-03-19 06:29:43', 0),
('05aba156-235d-11f1-9647-10683825ce81', '05aa5eac-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '2026-03-12 06:29:43', '2026-03-19 06:29:43', 0),
('05aba2ac-235d-11f1-9647-10683825ce81', '05aa4d10-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '2026-03-05 06:29:43', '2026-03-19 06:29:43', 0),
('05aba374-235d-11f1-9647-10683825ce81', '05aa4b9c-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43', '2026-03-19 06:29:43', 0),
('05aba41d-235d-11f1-9647-10683825ce81', '05aa5eac-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '2026-03-16 06:29:43', '2026-03-19 06:29:43', 0),
('05aba4e6-235d-11f1-9647-10683825ce81', '05aa4d10-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '2026-02-26 06:29:43', '2026-03-19 06:29:43', 0),
('05aba5ab-235d-11f1-9647-10683825ce81', '05aa4b9c-235d-11f1-9647-10683825ce81', '05a032b9-235d-11f1-9647-10683825ce81', '2026-03-18 06:29:43', '2026-03-19 06:29:43', 0);

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
('057933f9-8ebc-471d-80be-e21ea7530ccc', '82107b3c-1767-48c8-a690-ead71aa87748', 0, NULL, 'ddf0df642baf47f8da9ae55d542d68e4099e733ae0fdf740efc6f94de8ee9db7', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"82107b3c-1767-48c8-a690-ead71aa87748\\\",\\\"title\\\":\\\"wowasd123\\\",\\\"description\\\":\\\"wow\\\",\\\"amount\\\":\\\"0.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-04-15T04:49:06+00:00\\\"}\"', '2026-04-15 04:49:06');

-- --------------------------------------------------------
--
-- Triggers to make chain table immutable (append-only)
--

DELIMITER $$
CREATE TRIGGER prevent_chain_updates
BEFORE UPDATE ON chain
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chain records cannot be updated';
END$$

CREATE TRIGGER prevent_chain_deletes
BEFORE DELETE ON chain
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chain records cannot be deleted';
END$$

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
  `budget_breakdown` text NOT NULL,
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

--
-- Dumping data for table `meeting`
--

INSERT INTO `meeting` (`id`, `student_id`, `title`, `description`, `scheduled_date`, `created_at`, `is_done`, `minutes_content`, `action_items`, `expected_attendees`, `attendees`, `meeting_proof`, `updated_at`, `archive`) VALUES
('05a6aa59-235d-11f1-9647-10683825ce81', NULL, 'Intro Meet', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6ac07-235d-11f1-9647-10683825ce81', NULL, 'Budget Plan', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6ac90-235d-11f1-9647-10683825ce81', NULL, 'Event Sync', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6ace6-235d-11f1-9647-10683825ce81', NULL, 'Officer Meet', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6ad3a-235d-11f1-9647-10683825ce81', NULL, 'Emergency', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6ad87-235d-11f1-9647-10683825ce81', NULL, 'Wrap up', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('05a6add1-235d-11f1-9647-10683825ce81', NULL, 'Review', NULL, NULL, '2026-03-19 06:29:42', 0, NULL, NULL, NULL, NULL, NULL, '2026-03-19 06:29:42', 0),
('23157862-4996-4f2f-a98f-bd3974af3d9c', NULL, 'CSG Officer Meeting', 'Monthly CSG officers coordination meeting', '2026-04-17 10:00:25', '2026-04-14 08:36:25', 0, NULL, NULL, NULL, NULL, NULL, '2026-04-14 08:36:25', 0),
('8747a1c6-e34c-4938-b567-f7db82891fbe', NULL, 'Event Planning Session', 'Plan upcoming student events and activities', '2026-04-24 13:45:25', '2026-04-14 08:36:25', 1, NULL, NULL, NULL, NULL, NULL, '2026-04-14 19:30:21', 0),
('dd633dcf-85e7-4c06-bc80-684c14144d96', NULL, 'HR Budget Planning Session', 'Quarterly budget review and planning for HR department', '2026-04-19 14:00:25', '2026-04-14 08:36:25', 0, NULL, NULL, NULL, NULL, NULL, '2026-04-14 08:36:25', 0),
('f3bde4ff-65b0-4596-8c4c-7abc2cb4be17', NULL, 'Project Review Meeting', 'Review of ongoing projects and progress', '2026-04-21 15:30:25', '2026-04-14 08:36:25', 0, NULL, NULL, NULL, NULL, NULL, '2026-04-14 08:36:25', 0);

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
('05a79f2e-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', 'Welcome', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a144-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', 'Project Approved', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a1e9-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', 'Meeting Reminder', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a24b-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', 'Budget Alert', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a2a9-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', 'New Role', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a306-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', 'Task Update', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05a7a363-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', 'System Maintenance', NULL, NULL, 0, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('06d20001-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Project Approved', 'Your project \"Tech Expo\" was approved by the adviser.', 'project', 0, NULL, '2026-03-20 08:10:00', '2026-03-20 08:10:00', 0),
('06d20002-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Ledger Entry Pending', 'A ledger entry for \"Tech Expo\" is waiting for approval.', 'ledger', 0, NULL, '2026-03-20 09:25:00', '2026-03-20 09:25:00', 0),
('06d20003-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'New Proof Uploaded', 'A new proof document was uploaded for transaction 06b10002.', 'proof', 1, '2026-03-20 10:12:00', '2026-03-20 10:00:00', '2026-03-20 10:12:00', 0),
('06d20004-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Meeting Reminder', 'Budget planning meeting starts at 2:00 PM today.', 'meeting', 0, NULL, '2026-03-20 11:00:00', '2026-03-20 11:00:00', 0),
('06d20005-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Badge Earned', 'You unlocked \"Documentation Pro\" badge.', 'badge', 0, NULL, '2026-03-20 12:15:00', '2026-03-20 12:15:00', 0),
('06d20006-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Points Added', 'You received 15 points from helpful project feedback.', 'points', 1, '2026-03-20 13:00:00', '2026-03-20 12:40:00', '2026-03-20 13:00:00', 0),
('06d20007-235d-11f1-9647-10683825ce81', '05a033dc-235d-11f1-9647-10683825ce81', 'Rating Posted', 'Your rating on \"Sports Fest\" has been published.', 'rating', 0, NULL, '2026-03-20 13:25:00', '2026-03-20 13:25:00', 0),
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
('82107b3c-1767-48c8-a690-ead71aa87748', NULL, 'wowasd123', 'wow', 'wow', 'Sports', 0.00, 0, 'wow', 'Draft', 'wow', 'wow', NULL, '2026-04-16', '2026-05-08', '64a81ff1-871d-4a54-a6e2-5f61820fab09', 'Approved', '2026-04-14 20:49:06', '2026-04-14 20:48:45', '2026-04-14 20:49:06', NULL, '64a81ff1-871d-4a54-a6e2-5f61820fab09', 0),
('a3441af4-0a31-4b73-ac10-69829cf21dee', NULL, 'wow', 'wow', 'wow', 'Social', 1.00, 1, 'wow', 'Draft', 'wow', NULL, NULL, '2026-04-16', '2026-04-30', NULL, 'Draft', NULL, '2026-04-14 20:48:06', '2026-04-14 20:48:06', NULL, NULL, 0),
('b9150b61-f909-47fb-88eb-a8f6c15c4a8f', NULL, 'qw', 'qw', 'qw', 'Sports', 1.00, 1, 'qw', 'Draft', 'qw', NULL, NULL, '2026-04-09', '2026-04-30', NULL, 'Draft', NULL, '2026-04-14 21:00:05', '2026-04-14 21:00:05', NULL, NULL, 0),
('c5c08cc3-bf1f-4735-a56c-63717e330209', NULL, 'qwer', 'qwer', 'v', 'Sports', 1.00, 1, 'qwer', 'Draft', 'qwer', NULL, NULL, '2026-04-16', '2026-05-07', NULL, 'Draft', NULL, '2026-04-14 21:02:46', '2026-04-14 21:02:46', NULL, NULL, 0),
('ef858d6b-56b4-42e8-8019-84f54cdc8906', NULL, 'qwer', 'qwer', 'qwer', 'Social', 0.00, 0, 'qwer', 'Draft', 'qwer', NULL, NULL, '2026-04-17', '2026-04-30', NULL, 'Pending Adviser Approval', NULL, '2026-04-14 21:02:15', '2026-04-14 21:02:21', NULL, NULL, 0);

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
  `satisfaction_rating` int(11) DEFAULT NULL,
  `completeness_rating` int(11) DEFAULT NULL,
  `engagement_rating` int(11) DEFAULT NULL,
  `comments` text DEFAULT NULL,
  `helpful_count` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
('059f4213-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-03-19 06:29:42', '2026-03-19 06:33:46', 0);

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

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`id`, `user_id`, `role_id`, `permission_id`, `created_at`) VALUES
('05acae39-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05acb16e-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e56c0-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05acb277-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05acb39e-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e56c0-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05acb459-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05acb50b-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e56c0-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43'),
('05ad21e2-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', '2026-03-19 06:29:43');

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
('05a9731a-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '127.0.0.1', NULL, NULL, NULL, 0),
('05a9750e-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '127.0.0.1', NULL, NULL, NULL, 0),
('05a975d1-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '192.168.1.1', NULL, NULL, NULL, 0),
('05a979d5-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '192.168.1.2', NULL, NULL, NULL, 0),
('05a97a57-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '10.0.0.1', NULL, NULL, NULL, 0),
('05a97ab9-235d-11f1-9647-10683825ce81', '05a031f5-235d-11f1-9647-10683825ce81', '10.0.0.2', NULL, NULL, NULL, 0),
('05a97b1a-235d-11f1-9647-10683825ce81', '05a02fe2-235d-11f1-9647-10683825ce81', '172.16.0.1', NULL, NULL, NULL, 0),
('FyiSdJZwecnztxcggk58ihrlltSHjrBT6X5DFrry', NULL, '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiV1EzRmMzUXhPUjM1OUR0cWJramgzVWZDTTFuYTlIZDUyN3R3dTBZeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9zYWRtaW4vdXNlcnMiO3M6NToicm91dGUiO3M6MTI6InNhZG1pbi51c2VycyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776657345, 0),
('srbzHhCtmyq48mqm94TniFAinOhEN3eKQB64cfyy', '6547c91d-e74f-4fb0-ac13-6aa20fbdb8cb', '127.0.0.1', 'Mozilla/5.0 (X11; Linux aarch64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 CrKey/1.54.250320', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRTJlamFKb0NSaHlKWENlc3l6N2tzWndwN0pKajlEdEhyMkJJZVNhMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9jYWxsYmFjayI7czo1OiJyb3V0ZSI7czoxMzoiYXV0aC5jYWxsYmFjayI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtzOjM2OiI2NTQ3YzkxZC1lNzRmLTRmYjAtYWMxMy02YWEyMGZiZGI4Y2IiO30=', 1776658414, 0);

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
('111', NULL, '059d2571-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 09:25:23', '2026-04-16 09:25:23', 0),
('1111', NULL, '059d2571-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 09:20:38', '2026-04-16 09:20:38', 0),
('111111111', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 09:30:03', '2026-04-16 09:30:03', 0),
('112112321', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 19:47:56', '2026-04-16 19:47:56', 0),
('12312312', NULL, '059d2612-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 20:56:51', '2026-04-16 20:56:51', 0),
('1431134', NULL, '059d2571-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 21:27:10', '2026-04-16 21:27:10', 0),
('144444', NULL, '059d2571-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-16 21:24:36', '2026-04-16 21:24:36', 0),
('222222', NULL, '059d267c-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-14 08:59:50', '2026-04-14 08:59:50', 0),
('ewerr233324', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-04-19 19:08:27', '2026-04-19 19:08:27', 0),
('TEST-001', NULL, NULL, 0, NULL, NULL, NULL, 1, '2026-04-19 08:17:17', '2026-04-19 08:17:17', 0);

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
('05a02fe2-235d-11f1-9647-10683825ce81', '059ef3f9-235d-11f1-9647-10683825ce81', 'Super Admin', 'superadmin@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09466552088', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a031f5-235d-11f1-9647-10683825ce81', '059ef712-235d-11f1-9647-10683825ce81', 'Dr. Maria Santos', 'maria.santos@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09799179280', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a032b9-235d-11f1-9647-10683825ce81', '059f4213-235d-11f1-9647-10683825ce81', 'Prof. Juan Reyes', 'juan.reyes@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09696240168', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a0334d-235d-11f1-9647-10683825ce81', '059efde1-235d-11f1-9647-10683825ce81', 'David', 'david@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09983663026', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a033dc-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Eve', 'eve@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09929594658', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a0346d-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Frank', 'frank@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09696984240', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('05a034e4-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Grace', 'grace@kld.edu.ph', '2026-03-19 06:53:13', NULL, NULL, 0, '09596137256', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-19 06:44:49', NULL, '2026-03-19 06:29:42', '2026-03-19 06:53:13', 0),
('06e30001-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Henry Cruz', 'henry.cruz@kld.edu.ph', '2026-03-20 07:10:00', NULL, NULL, 0, '09981110001', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:10:00', NULL, '2026-03-20 07:10:00', '2026-03-20 07:10:00', 0),
('06e30002-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Ivy Santos', 'ivy.santos@kld.edu.ph', '2026-03-20 07:15:00', NULL, NULL, 0, '09981110002', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:15:00', NULL, '2026-03-20 07:15:00', '2026-03-20 07:15:00', 0),
('06e30003-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Justin Lim', 'justin.lim@kld.edu.ph', '2026-03-20 07:20:00', NULL, NULL, 0, '09981110003', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:20:00', NULL, '2026-03-20 07:20:00', '2026-03-20 07:20:00', 0),
('06e30004-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Karla Mendoza', 'karla.mendoza@kld.edu.ph', '2026-03-20 07:25:00', NULL, NULL, 0, '09981110004', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:25:00', NULL, '2026-03-20 07:25:00', '2026-03-20 07:25:00', 0),
('06e30005-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Leo Navarro', 'leo.navarro@kld.edu.ph', '2026-03-20 07:30:00', NULL, NULL, 0, '09981110005', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:30:00', NULL, '2026-03-20 07:30:00', '2026-03-20 07:30:00', 0),
('06e30006-235d-11f1-9647-10683825ce81', '059f4170-235d-11f1-9647-10683825ce81', 'Mia Perez', 'mia.perez@kld.edu.ph', '2026-03-20 07:35:00', NULL, NULL, 0, '09981110006', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', NULL, 0, NULL, 'active', '2026-03-20 07:35:00', NULL, '2026-03-20 07:35:00', '2026-03-20 07:35:00', 0),
('6547c91d-e74f-4fb0-ac13-6aa20fbdb8cb', '059f4170-235d-11f1-9647-10683825ce81', 'LAWRENCE PHILIP CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-04-19 19:33:30', NULL, NULL, 0, NULL, NULL, 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 0, NULL, 'active', '2026-04-19 20:13:30', NULL, '2026-04-19 19:33:30', '2026-04-19 20:13:30', 0),
('a44a895f-62b8-40c8-80d4-f78814a2d2e0', '059f4170-235d-11f1-9647-10683825ce81', 'JAMES TORILLAS TAMAYO', 'jttamayo@kld.edu.ph', '2026-04-19 19:37:42', NULL, NULL, 0, NULL, NULL, 'https://lh3.googleusercontent.com/a/ACg8ocJSq8gDznGQvQNLtVugx21hZN-Z40sehpu-m1mE9a1HhJkOGQ=s96-c', 0, NULL, 'active', '2026-04-19 20:12:59', NULL, '2026-04-19 19:37:42', '2026-04-19 20:12:59', 0),
('b8e339ed-f115-4cdc-bbd9-641593e7e6f4', '059ef712-235d-11f1-9647-10683825ce81', 'Dr. Maria Santos', 'maria.santos@kld.edu.ph', '2026-04-19 09:11:05', NULL, NULL, 1, '09991234567', '$2y$12$3KO/nGoWpukaACuFQ.aFuOdCzdUTrfWXGbjRWochAhV7tdNfv4LTO', NULL, 0, NULL, 'active', NULL, NULL, '2026-04-19 09:11:05', '2026-04-19 09:11:05', 0),
('d0189180-734c-4c8b-89c3-340a5e0739c0', '059ef712-235d-11f1-9647-10683825ce81', 'Prof. Juan Reyes Test', 'juan.reyes.test@kld.edu.ph', NULL, '76e283676df717ef6b9cfdea45c77e49fffe327a5a6a014a0a8fb2555f71fc65', '2026-04-22 09:11:20', 0, NULL, '$2y$12$xevtTf0fOLYWbSVa/Xc5p.rHk6oOplRp/.WTmv6Xb1oBWDFgUrJKC', NULL, 0, NULL, 'active', NULL, NULL, '2026-04-19 09:11:20', '2026-04-19 17:40:13', 0),
('d6b88ae5-3f44-4850-be6b-c49022604ccb', '059f4170-235d-11f1-9647-10683825ce81', 'a w', 'jimj87313@gmail.com', '2026-04-16 08:53:16', NULL, NULL, 0, NULL, '$2y$12$FW0c1KJwkyb64iY9WblO.eKlC8Boo15hMWCvVtxJWIgPTJsPulhTq', 'https://www.gravatar.com/avatar/f5d7276f7729115b2ed6bc91f6509aae?s=400&d=identicon', 0, NULL, 'active', NULL, NULL, '2026-04-16 08:53:16', '2026-04-20 02:43:47', 0);

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