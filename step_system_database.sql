-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 07, 2026 at 03:45 AM
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
  `approvable_id` char(36) DEFAULT NULL,
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
('0dc321e7-029b-474b-9109-f0196cad11f7', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'blockchain', 'Tampering & Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 tampered block(s) detected and 2 budget mismatch(es) detected across verified project chains.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:45:55', 0),
('0e31d694-5023-451e-80dc-ecaa9c5b97e0', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'blockchain', 'Tampering & Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '2 tampered block(s) detected and 1 budget mismatch(es) detected across verified project chains.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:50:57', 0),
('11157662-9f37-4a6c-b00d-996b32627553', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:48:51', 0),
('2928ea08-dbbf-457e-bab6-91ee4b654d79', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'blockchain', 'Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 budget mismatch(es) detected across verified project chains.', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:43:53', 0),
('39f2626e-eb4d-42dc-9640-e503a35178fd', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 03:00:32', 0),
('4af0ba28-8ab9-4c34-b7cc-4c2076dfc011', NULL, '05285a81-c501-4694-9097-12c09b76ff0a', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:123:4567', NULL, NULL, '2026-09-06 03:03:43', 0),
('4c6d9329-6168-4c21-b5f9-c817eb88f1f3', NULL, '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:67:100', NULL, NULL, '2026-09-06 02:57:07', 0),
('589780c5-f25e-42d9-a31d-d54f7c768b88', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:56:28', 0),
('837f56ac-8483-4c2d-8701-00b46c2849cb', NULL, '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:345:100', NULL, NULL, '2026-09-06 03:01:14', 0),
('8ce5a377-87dd-42a3-a9ea-d9d7b8db2417', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'dbee66df-2864-47b3-9877-d7561c1ce5aa', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:49:01', 0),
('aefa8811-246e-4388-a4a4-628ead6f973d', NULL, '05285a81-c501-4694-9097-12c09b76ff0a', 'blockchain', 'Tampering detected - email delivered', 'blockchain', 'alert', 'Warning', 'tampering_signature:86252b72050b44cebfe39213661d06922f44164e0ff9f635e526bc4d8e32e097', NULL, NULL, '2026-09-06 02:50:40', 0),
('b548842a-a5a1-435a-99be-24be14c42bab', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2bd1640d-a30a-498d-a6e9-1da2187a5f79', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 02:51:54', 0),
('b5cc1136-53e7-4e54-9bd8-d243d5d2652a', NULL, '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'blockchain', 'Tampering detected - email delivered', 'blockchain', 'alert', 'Warning', 'tampering_signature:ae5c497510a8ca43583fceb4939977cd19e19accb73ec6a1376dc0bbc3c8742a', NULL, NULL, '2026-09-06 02:45:55', 0),
('cc71a4d7-82b7-4a32-b08e-9203ea40d760', NULL, '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:86:100', NULL, NULL, '2026-09-06 03:03:13', 0),
('d7949ba8-c054-4ba6-a6d3-fb294452e6e3', NULL, '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:567:100', NULL, NULL, '2026-09-06 02:55:40', 0),
('e4efac45-a5f9-4fae-8fac-1606e248b539', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', '2026-09-06 03:02:00', 0),
('fad5c70f-2126-4e86-b598-e8b5a6c8306d', NULL, '05285a81-c501-4694-9097-12c09b76ff0a', 'blockchain', 'Tampering detected - email delivered', 'blockchain', 'alert', 'Warning', 'tampering_signature:dbc646d022b254e56e1b32cba98bd3dde940535811fe3ddc1784f4b9f0cafcbc', NULL, NULL, '2026-09-06 03:03:41', 0);

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
('1af12821-ba22-45ff-8925-bfe0d558c47f', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 5, '3ab0d6e1135ed3cd684bf1d579b78dac511f7dd176c4f50ab13289739656d3f9', '2236c17142a8282889b6aaef13e9795e6551630a4ed24d080eddddbdfdc6b349', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"dbee66df-2864-47b3-9877-d7561c1ce5aa\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"description\\\":\\\"Transferred to project \\\\\\\"TRANSFER\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"1.00\\\",\\\"entry_type\\\":\\\"Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T06:02:47+00:00\\\",\\\"snapshot_nonce\\\":\\\"9b7c1d15db8c87a6\\\"}\"', '2026-09-05 06:02:47'),
('450280cc-c530-4974-82a4-446958b1708e', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 4, '83f0add28eae662125f1e61fb0fd59e2e7865c686b17d90873e10dfa01064113', '3ab0d6e1135ed3cd684bf1d579b78dac511f7dd176c4f50ab13289739656d3f9', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"84b2fea5-053e-44d7-9182-774d09dc7d83\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"description\\\":\\\"dfgdf123\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"dgdfg\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T05:45:57+00:00\\\",\\\"snapshot_nonce\\\":\\\"7be67181f8ceab5c\\\"}\"', '2026-09-05 05:45:57'),
('4cd8de13-213a-4397-aa48-285224344b33', '9968ff80-9f04-4960-92cd-f878b08f2960', 0, NULL, '7b6438ff2c55b0f44070fab13aaca710054b3047151388f7a4100f2ed801aaac', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"9968ff80-9f04-4960-92cd-f878b08f2960\\\",\\\"title\\\":\\\"TRANSFER\\\",\\\"description\\\":\\\"sdfsd\\\",\\\"amount\\\":\\\"1.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T06:02:47+00:00\\\"}\"', '2026-09-05 06:02:47'),
('5b4f1270-9c20-4123-b63d-4cdd23286b50', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 2, '6eb6718378b87cb1e7f76aecfe73ab353fb5afc4d959605bb072ca6d77c32d7a', '9aa0b2a78dabae3349ccce6b89e192c17dab9dda264f8ba77c2d267316b30a3f', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"1dd34cf6-58d3-4220-a56a-95c3cca705e3\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"description\\\":\\\"ewrew\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"rewre\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Donation\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T05:45:45+00:00\\\",\\\"snapshot_nonce\\\":\\\"24afd2d62d5f9a36\\\"}\"', '2026-09-05 05:45:45'),
('79125a22-7e63-40c7-ae4f-b462109597a4', '9968ff80-9f04-4960-92cd-f878b08f2960', 1, '7b6438ff2c55b0f44070fab13aaca710054b3047151388f7a4100f2ed801aaac', 'ce3bf9315ad18590516f9e3163475d350722551828f2c4e1b19262ea2bce3e66', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"dd06b73b-cd9c-4f2c-aa7c-fbf420b2abf6\\\",\\\"project_id\\\":\\\"9968ff80-9f04-4960-92cd-f878b08f2960\\\",\\\"description\\\":\\\"Transferred from completed project \\\\\\\"TEST A1\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"1.00\\\",\\\"entry_type\\\":\\\"Initial Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T06:02:47+00:00\\\",\\\"snapshot_nonce\\\":\\\"6145985e658f0208\\\"}\"', '2026-09-05 06:02:47'),
('976a09ea-a878-499f-9309-6fc11bcf23c5', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 0, NULL, 'c9b1c73e3cc0ddb4e93b207b3574a5626a1c633837621b368fe8b4a8faa71feb', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"title\\\":\\\"TEST A1\\\",\\\"description\\\":\\\"TEST A\\\",\\\"amount\\\":\\\"1.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T04:52:10+00:00\\\"}\"', '2026-09-05 04:52:10'),
('b6b01b79-3189-4823-aa31-f22a5345c7c6', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 3, '9aa0b2a78dabae3349ccce6b89e192c17dab9dda264f8ba77c2d267316b30a3f', '83f0add28eae662125f1e61fb0fd59e2e7865c686b17d90873e10dfa01064113', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"cba9fb5a-ee41-425f-ac2d-dcc1b7d07c1a\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"description\\\":\\\"erwterw\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"tewte\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T05:45:51+00:00\\\",\\\"snapshot_nonce\\\":\\\"b5453bf0a010eb06\\\"}\"', '2026-09-05 05:45:51'),
('f3341e3f-a34c-48cf-819b-a13d4b03ad64', '05285a81-c501-4694-9097-12c09b76ff0a', 1, '43534707a9b0240bc88a8b6416635cc73347b7882e8ddba642b44e72197ec6e1', '598583e5205aeba296e7322a3f0ac40007f8a9a7fad09fab7e87cb331742c3f3', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"2bd1640d-a30a-498d-a6e9-1da2187a5f79\\\",\\\"project_id\\\":\\\"05285a81-c501-4694-9097-12c09b76ff0a\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"123.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-06T10:20:13+00:00\\\",\\\"snapshot_nonce\\\":\\\"040cf2f51dfefa36\\\"}\"', '2026-09-06 10:20:13'),
('f351b9a1-bb9c-4cc8-9601-60c2c830834d', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 1, 'c9b1c73e3cc0ddb4e93b207b3574a5626a1c633837621b368fe8b4a8faa71feb', '6eb6718378b87cb1e7f76aecfe73ab353fb5afc4d959605bb072ca6d77c32d7a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"5339c1ce-078b-455d-b1e5-0dd463651823\\\",\\\"project_id\\\":\\\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"1.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-05T04:52:10+00:00\\\",\\\"snapshot_nonce\\\":\\\"979ef8dfc6084732\\\"}\"', '2026-09-05 04:52:10'),
('fb50ad9e-5172-4d06-ad9d-521128d8f590', '05285a81-c501-4694-9097-12c09b76ff0a', 0, NULL, '43534707a9b0240bc88a8b6416635cc73347b7882e8ddba642b44e72197ec6e1', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"05285a81-c501-4694-9097-12c09b76ff0a\\\",\\\"title\\\":\\\"TEST B\\\",\\\"description\\\":\\\"TEST B\\\",\\\"amount\\\":\\\"123.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-06T10:20:13+00:00\\\"}\"', '2026-09-06 10:20:13');

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
-- Table structure for table `concern`
--

CREATE TABLE `concern` (
  `id` char(36) NOT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `concern` varchar(255) DEFAULT NULL,
  `favorite` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `concern`
--

INSERT INTO `concern` (`id`, `user_id`, `concern`, `favorite`, `created_at`) VALUES
('1a1e0d1f-4748-4d3d-9b63-b0325d8d2027', NULL, 'asdfsdaf', 1, '2026-09-04 22:09:08'),
('69bd2c29-8e96-448d-bb48-cfe71c03c87c', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'w name', 1, '2026-09-04 22:09:00');

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
-- Table structure for table `date_change_requests`
--

CREATE TABLE `date_change_requests` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `requested_by` char(36) NOT NULL,
  `current_start_date` date NOT NULL,
  `current_end_date` date NOT NULL,
  `proposed_start_date` date NOT NULL,
  `proposed_end_date` date NOT NULL,
  `reason` longtext NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `reviewed_by` char(36) DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `rejection_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `date_change_requests`
--

INSERT INTO `date_change_requests` (`id`, `project_id`, `requested_by`, `current_start_date`, `current_end_date`, `proposed_start_date`, `proposed_end_date`, `reason`, `status`, `reviewed_by`, `reviewed_at`, `rejection_reason`, `created_at`, `updated_at`) VALUES
('aecd7925-3b19-42ee-8c06-2426a1fd5f38', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', '2026-09-26', '2026-09-29', '2026-09-28', '2026-09-30', 'dfsafsda', 'approved', NULL, NULL, 'qwert', '2026-09-04 20:56:09', '2026-09-04 20:56:21'),
('e008ff3d-a45c-4380-ad01-e47bbb19e9e7', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', '2026-09-26', '2026-09-29', '2026-09-26', '2026-09-28', 'sdadas', 'rejected', NULL, NULL, 'TEST AA', '2026-09-04 20:55:15', '2026-09-04 20:55:52');

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
  `type` enum('Income','Expense','Donation','Sponsorship','Canvas','Initial','Transfer','Initial Transfer') NOT NULL,
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
('1dd34cf6-58d3-4220-a56a-95c3cca705e3', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Donation', 100.00, 'ewrew', NULL, '\"[{\\\"item\\\":\\\"rewre\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'ledger_proofs/1f6f7adddacd9a347b897a4b720beb9ea4bfc7e3fac6a9e6e48130cabd9efbed.jpg', '1f6f7adddacd9a347b897a4b720beb9ea4bfc7e3fac6a9e6e48130cabd9efbed', 'Approved', 0, 'sadfs', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 21:45:44', NULL, 0, '2026-09-04 21:12:05', '2026-09-04 23:22:52'),
('2bd1640d-a30a-498d-a6e9-1da2187a5f79', '05285a81-c501-4694-9097-12c09b76ff0a', 'Initial', 4567.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'project_approval/bd5551a03b526b863f28ac136d906880fafc0348b09dd9bc6471c0d5de8db018.pdf', 'bd5551a03b526b863f28ac136d906880fafc0348b09dd9bc6471c0d5de8db018', 'Approved', 0, 'Auto-generated baseline on project approval', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-06 02:20:13', NULL, 0, '2026-09-06 02:20:11', '2026-09-06 11:03:31'),
('47c992fb-f153-4fb0-bcf6-41b832c38d82', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Expense', 78.00, 'sdafds', NULL, '\"[{\\\"item\\\":\\\"fasd\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"234\\\",\\\"amount\\\":234}]\"', 'ledger_proofs/f560311131c3741e5b4c75ae368ee418b1025281031bed08a3e42a4599ebe185.png', 'f560311131c3741e5b4c75ae368ee418b1025281031bed08a3e42a4599ebe185', 'Pending Adviser Approval', 0, NULL, NULL, 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', NULL, NULL, NULL, 0, '2026-09-06 02:07:52', '2026-09-06 10:44:13'),
('5339c1ce-078b-455d-b1e5-0dd463651823', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Initial', 1.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90.png', 'cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90', 'Approved', 0, 'Auto-generated baseline on project creation', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 20:52:10', NULL, 0, '2026-09-04 20:26:16', '2026-09-06 00:44:56'),
('84b2fea5-053e-44d7-9182-774d09dc7d83', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Expense', 100.00, 'dfgdf123', NULL, '\"[{\\\"item\\\":\\\"dgdfg\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'ledger_proofs/fc0a0610bd5a9b6c22120c0dcdc499f3f89c80adaa12280d88fe20589fb01e94.png', 'fc0a0610bd5a9b6c22120c0dcdc499f3f89c80adaa12280d88fe20589fb01e94', 'Approved', 0, 'sadfds', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 21:45:57', NULL, 0, '2026-09-04 20:59:19', '2026-09-05 00:24:40'),
('ad21d62f-8523-4d9d-907b-6c2fb438134a', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Income', 234.00, 'dfgfdgd', NULL, '\"[{\\\"item\\\":\\\"dfsgfd\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"234\\\",\\\"amount\\\":234}]\"', 'ledger_proofs/51081bfeb594daf785caef18f8cf959b42ef63e6640079a853424d41ba01afda.png', '51081bfeb594daf785caef18f8cf959b42ef63e6640079a853424d41ba01afda', 'Pending Adviser Approval', 0, 'sfd', NULL, 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, '2026-09-06 02:02:07', 0, '2026-09-06 02:01:35', '2026-09-06 02:06:28'),
('c6eafa33-e7a3-4191-ad3f-6d37c591b103', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Income', 345.00, 'weqrtyt', NULL, '\"[{\\\"item\\\":\\\"dfgdf\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'ledger_proofs/2b9acb3692e54a333f478db8d6a3ae63c4d216697836cb273ba5b67967e3b6fa.png', '2b9acb3692e54a333f478db8d6a3ae63c4d216697836cb273ba5b67967e3b6fa', 'Rejected', 0, 'erter', NULL, 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, '2026-09-04 21:42:00', 0, '2026-09-04 20:58:40', '2026-09-05 06:12:31'),
('cba9fb5a-ee41-425f-ac2d-dcc1b7d07c1a', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Sponsorship', 100.00, 'erwterw', NULL, '\"[{\\\"item\\\":\\\"tewte\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'ledger_proofs/1f6f7adddacd9a347b897a4b720beb9ea4bfc7e3fac6a9e6e48130cabd9efbed.jpg', '1f6f7adddacd9a347b897a4b720beb9ea4bfc7e3fac6a9e6e48130cabd9efbed', 'Approved', 0, 'sadfsd', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 21:45:51', NULL, 0, '2026-09-04 21:15:03', '2026-09-06 01:09:33'),
('dbee66df-2864-47b3-9877-d7561c1ce5aa', '0fae4fb3-0cfe-478c-91aa-3c157e488fca', 'Transfer', 1.00, 'Transferred to project \"TRANSFER\"', 'Transfer', NULL, 'ledger_proofs/cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90.png', 'cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90', 'Approved', 0, '{\"transfer_source_project_id\":\"0fae4fb3-0cfe-478c-91aa-3c157e488fca\",\"transfer_source_project_title\":\"TEST A1\",\"transfer_destination_project_id\":\"9968ff80-9f04-4960-92cd-f878b08f2960\",\"transfer_destination_project_title\":\"TRANSFER\"}', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 22:02:47', NULL, 0, '2026-09-04 22:02:07', '2026-09-06 02:49:01'),
('dd06b73b-cd9c-4f2c-aa7c-fbf420b2abf6', '9968ff80-9f04-4960-92cd-f878b08f2960', 'Initial Transfer', 1.00, 'Transferred from completed project \"TEST A1\"', 'Transfer', NULL, 'ledger_proofs/cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90.png', 'cdabcf03bacea79a032f19482c8d06ba5a146447eb1eebee797a89d06b4c4b90', 'Approved', 0, 'Transferred from completed project \"TEST A1\" to project \"TRANSFER\"', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '2026-09-04 22:02:47', NULL, 0, '2026-09-04 22:02:07', '2026-09-06 02:17:22'),
('e81e0129-aad0-4cdd-91e6-4f2ff6b9d3d9', '05285a81-c501-4694-9097-12c09b76ff0a', 'Initial', 4657.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/defb070072b7f81b29e41098379e0087425b7842c7d1bb210a42808baef906ac.png', 'defb070072b7f81b29e41098379e0087425b7842c7d1bb210a42808baef906ac', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', NULL, NULL, NULL, 1, '2026-09-04 20:44:43', '2026-09-05 08:44:29');

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
  `file_content_hash` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meeting`
--

INSERT INTO `meeting` (`id`, `student_id`, `title`, `description`, `scheduled_date`, `created_at`, `is_done`, `minutes_content`, `action_items`, `expected_attendees`, `attendees`, `meeting_proof`, `file_content_hash`, `updated_at`, `archive`) VALUES
('2a2f6bde-ff2e-4fff-a052-613fd89404d3', NULL, 'Proof Documents', 'Proof Documents', '2026-09-02 13:55:00', '2026-09-04 21:56:36', 0, NULL, NULL, '12', '[\"safsda\",\"123123\"]', 'meeting_proofs/87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b.pdf', '87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b', '2026-09-04 21:56:36', 0),
('5ba07d5c-78e9-46fd-b51b-be27a973854f', NULL, 'TEST C', 'sdfsdf', '2026-09-09 13:54:00', '2026-09-04 21:54:02', 0, NULL, NULL, '12', '[]', NULL, NULL, '2026-09-04 21:54:16', 1),
('b810f554-b14e-4f98-81da-bcbabc51a76e', NULL, 'Proof Documents', 'Proof Documents', '2026-09-02 13:55:00', '2026-09-04 21:54:54', 1, NULL, NULL, '12', '[\"safsda\",\"123123\"]', 'meeting_proofs/87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b.pdf', '87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b', '2026-09-04 21:55:44', 0);

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
(10, '2026_04_20_add_invitation_tokens_to_users', 8),
(11, '2026_06_19_create_date_change_requests_table', 9);

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
('0d939386-fbd4-4e3a-bdad-d93cdf5affb5', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:56:28', '2026-09-06 02:56:28', 0),
('16c7fa30-32fe-41bf-bc5e-08cdd284a26b', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST B\" was restored by LAWRENCE CALIBUSO.', 'ledger', 0, NULL, '2026-09-06 02:51:55', '2026-09-06 02:51:55', 0),
('232d53a0-d7ef-46e2-a333-2bc64bdabcb6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"TRANSFER\"\" in project \"TEST A1\" was restored by LAWRENCE CALIBUSO.', 'ledger', 0, NULL, '2026-09-06 02:49:01', '2026-09-06 02:49:01', 0),
('234f2183-89d7-4d08-868e-9a1eacb45546', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:36:17', '2026-09-06 02:36:17', 0),
('4fd91ea4-f327-49d4-9f0a-680bb927c674', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST B\" was restored by LAWRENCE CALIBUSO.', 'ledger', 0, NULL, '2026-09-06 02:36:24', '2026-09-06 02:36:24', 0),
('99d6bc09-4a22-4d73-a0fa-2727ec2dc479', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:42:56', '2026-09-06 02:42:56', 0),
('9c79bb12-fd6e-472a-82ef-99042adadd19', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 03:00:32', '2026-09-06 03:00:32', 0),
('a80c58e4-805a-43fd-9827-d56464d9ba67', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST B\" was restored by LAWRENCE CALIBUSO.', 'ledger', 0, NULL, '2026-09-06 02:40:30', '2026-09-06 02:40:30', 0),
('bcab7e3e-3ad0-4ae9-8bff-17be1ed5dbd5', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:40:22', '2026-09-06 02:40:22', 0),
('c323c511-7a37-40df-a990-9259522692a7', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST B\" was restored by LAWRENCE CALIBUSO.', 'ledger', 0, NULL, '2026-09-06 02:29:11', '2026-09-06 02:29:11', 0),
('eeb96c70-f6f5-4de7-984f-4bc8ba502b0f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 3 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:29:02', '2026-09-06 02:29:02', 0),
('efa93229-88f9-4cc1-90fd-26872e0e6cf0', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 02:48:51', '2026-09-06 02:48:51', 0),
('f8b77f3f-66f6-46b0-a718-b5d24895d77f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-06 03:02:00', '2026-09-06 03:02:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `notification_reads`
--

CREATE TABLE `notification_reads` (
  `notification_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `read_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
('27619e4b-431e-4d56-8666-395376d970e1', 'Ledger', 'reject', 'ledger.reject', 'Reject access for Ledger', '2026-08-26 09:39:09', '2026-08-26 09:39:09', 0),
('351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'Meetings', 'submit', 'meetings.submit', 'Submit access for Meetings', '2026-08-26 09:39:09', '2026-08-26 09:39:09', 0),
('a1b10001-0000-4000-8000-000000000001', 'Projects', 'view', 'projects.view', 'View access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10002-0000-4000-8000-000000000002', 'Projects', 'create', 'projects.create', 'Create access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10003-0000-4000-8000-000000000003', 'Projects', 'edit', 'projects.edit', 'Edit access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10004-0000-4000-8000-000000000004', 'Projects', 'delete', 'projects.delete', 'Delete access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10005-0000-4000-8000-000000000005', 'Projects', 'approve', 'projects.approve', 'Approve access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10006-0000-4000-8000-000000000006', 'Projects', 'rate', 'projects.rate', 'Rate access for Projects', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10007-0000-4000-8000-000000000007', 'Ledger', 'view', 'ledger.view', 'View access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10008-0000-4000-8000-000000000008', 'Ledger', 'create', 'ledger.create', 'Create access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10009-0000-4000-8000-000000000009', 'Ledger', 'edit', 'ledger.edit', 'Edit access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10010-0000-4000-8000-000000000010', 'Ledger', 'delete', 'ledger.delete', 'Delete access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10011-0000-4000-8000-000000000011', 'Ledger', 'approve', 'ledger.approve', 'Approve access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10012-0000-4000-8000-000000000012', 'Ledger', 'submit', 'ledger.submit', 'Submit access for Ledger', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10013-0000-4000-8000-000000000013', 'Proof Documents', 'view', 'proof-documents.view', 'View access for Proof Documents', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10014-0000-4000-8000-000000000014', 'Proof Documents', 'upload', 'proof-documents.upload', 'Upload access for Proof Documents', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10015-0000-4000-8000-000000000015', 'Proof Documents', 'delete', 'proof-documents.delete', 'Delete access for Proof Documents', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10016-0000-4000-8000-000000000016', 'Proof Documents', 'approve', 'proof-documents.approve', 'Approve access for Proof Documents', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10017-0000-4000-8000-000000000017', 'Proof Documents', 'validate', 'proof-documents.validate', 'Validate access for Proof Documents', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10018-0000-4000-8000-000000000018', 'Meetings', 'view', 'meetings.view', 'View access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10019-0000-4000-8000-000000000019', 'Meetings', 'create', 'meetings.create', 'Create access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10020-0000-4000-8000-000000000020', 'Meetings', 'edit', 'meetings.edit', 'Edit access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10021-0000-4000-8000-000000000021', 'Meetings', 'delete', 'meetings.delete', 'Delete access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10022-0000-4000-8000-000000000022', 'Meetings', 'upload minutes', 'meetings.upload-minutes', 'Upload Minutes access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10023-0000-4000-8000-000000000023', 'Meetings', 'approve minutes', 'meetings.approve-minutes', 'Approve Minutes access for Meetings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10024-0000-4000-8000-000000000024', 'Ratings', 'view', 'ratings.view', 'View access for Ratings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10025-0000-4000-8000-000000000025', 'Ratings', 'submit', 'ratings.submit', 'Submit access for Ratings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10026-0000-4000-8000-000000000026', 'Ratings', 'moderate', 'ratings.moderate', 'Moderate access for Ratings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10027-0000-4000-8000-000000000027', 'Ratings', 'analytics', 'ratings.analytics', 'Analytics access for Ratings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10028-0000-4000-8000-000000000028', 'Notifications', 'view', 'notifications.view', 'View access for Notifications', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10029-0000-4000-8000-000000000029', 'Notifications', 'send', 'notifications.send', 'Send access for Notifications', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10030-0000-4000-8000-000000000030', 'Notifications', 'manage', 'notifications.manage', 'Manage access for Notifications', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10031-0000-4000-8000-000000000031', 'User Management', 'view', 'user-management.view', 'View access for User Management', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10032-0000-4000-8000-000000000032', 'User Management', 'create', 'user-management.create', 'Create access for User Management', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10033-0000-4000-8000-000000000033', 'User Management', 'edit', 'user-management.edit', 'Edit access for User Management', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10034-0000-4000-8000-000000000034', 'User Management', 'suspend', 'user-management.suspend', 'Suspend access for User Management', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10035-0000-4000-8000-000000000035', 'User Management', 'delete', 'user-management.delete', 'Delete access for User Management', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10036-0000-4000-8000-000000000036', 'Organizations', 'view', 'organizations.view', 'View access for Organizations', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10037-0000-4000-8000-000000000037', 'Organizations', 'create', 'organizations.create', 'Create access for Organizations', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10038-0000-4000-8000-000000000038', 'Organizations', 'edit', 'organizations.edit', 'Edit access for Organizations', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10039-0000-4000-8000-000000000039', 'Organizations', 'archive', 'organizations.archive', 'Archive access for Organizations', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10040-0000-4000-8000-000000000040', 'System Settings', 'view', 'system-settings.view', 'View access for System Settings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10041-0000-4000-8000-000000000041', 'System Settings', 'configure', 'system-settings.configure', 'Configure access for System Settings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10042-0000-4000-8000-000000000042', 'System Settings', 'backup', 'system-settings.backup', 'Backup access for System Settings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('a1b10043-0000-4000-8000-000000000043', 'System Settings', 'logs', 'system-settings.logs', 'Logs access for System Settings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0),
('b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'Projects', 'submit', 'projects.submit', 'Submit access for Projects', '2026-08-26 09:39:09', '2026-08-26 09:39:09', 0),
('ccc15133-f9f3-4f94-9bae-fbe289eeb66c', 'Projects', 'reject', 'projects.reject', 'Reject access for Projects', '2026-08-26 09:39:09', '2026-08-26 09:39:09', 0);

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
  `project_proof` varchar(255) DEFAULT NULL,
  `file_content_hash` varchar(64) DEFAULT NULL,
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

INSERT INTO `projects` (`id`, `student_id`, `title`, `description`, `objective`, `category`, `budget`, `is_initial`, `venue`, `status`, `proposed_by`, `note`, `project_proof`, `file_content_hash`, `start_date`, `end_date`, `approve_by`, `approval_status`, `approved_at`, `created_at`, `updated_at`, `created_by`, `updated_by`, `archive`) VALUES
('05285a81-c501-4694-9097-12c09b76ff0a', NULL, 'TEST B', 'TEST B', 'TEST B', 'Social', 123.00, 1, 'TEST B', 'Draft', 'TEST B', 'fghgf', 'project_approval/bd5551a03b526b863f28ac136d906880fafc0348b09dd9bc6471c0d5de8db018.pdf', 'bd5551a03b526b863f28ac136d906880fafc0348b09dd9bc6471c0d5de8db018', '2026-09-28', '2026-09-29', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'Approved', '2026-09-06 02:20:13', '2026-09-04 20:44:43', '2026-09-06 02:48:51', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 0),
('0fae4fb3-0cfe-478c-91aa-3c157e488fca', NULL, 'TEST A1', 'TEST A', 'TEST A', 'Social', 86.00, 0, 'TEST A', 'Draft', 'TEST A', 'rejectReason', 'project_approval/87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b.pdf', '87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b', '2025-09-06', '2025-09-10', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'Approved', '2026-09-04 20:52:10', '2026-09-04 20:26:16', '2026-09-06 11:02:46', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 0),
('9968ff80-9f04-4960-92cd-f878b08f2960', NULL, 'TRANSFER', 'sdfsd', 'sdafds', 'Social', 1.00, 0, 'sdfsdf', 'Draft', 'sdafsd', 'sdfsdaf', 'project_approval/87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b.pdf', '87a33eda2e250dece31e071f2b1c97973eaf557c6b77c41bd30146922c68a94b', '2026-10-01', '2026-10-06', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 'Approved', '2026-09-04 22:02:47', '2026-09-04 22:02:07', '2026-09-06 02:29:02', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 'd1de808f-0522-4486-ae80-c82cba2a69e4', 0);

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

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `project_id`, `user_id`, `satisfaction_rating`, `completeness_rating`, `engagement_rating`, `comments`, `helpful_count`, `created_at`, `archive`) VALUES
('8d07c84a-ba35-44e5-af41-dbf7594755ee', '9968ff80-9f04-4960-92cd-f878b08f2960', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', 4, 2, 4, 'weqreqwr', 0, '2026-09-04 22:08:11', 0);

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
('059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', 'Super Admin', 'superadmin', 'Full system access with all permissions', '2026-03-19 06:29:42', '2026-03-19 06:32:19', 0),
('059ef712-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', 'Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', '2026-03-19 06:29:42', '2026-03-19 06:32:48', 0),
('059efde1-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', 'CSG Officer', 'csg', 'Organization operations and submissions', '2026-03-19 06:29:42', '2026-03-19 06:33:09', 0),
('059f4170-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'Student', 'student', 'View, rate, and engage in projects', '2026-03-19 06:29:42', '2026-03-19 06:33:29', 0),
('059f4213-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-03-19 06:29:42', '2026-03-19 06:33:46', 0),
('059f5000-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', 'Admin/SADU', 'admin-sadu', 'Administrator with SADU (Student Affairs and Discipline Office) responsibilities - manages student discipline and welfare', '2026-05-30 20:36:18', '2026-05-31 04:47:47', 0);

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `role_id` char(36) DEFAULT NULL,
  `permission_id` char(36) DEFAULT NULL,
  `position_id` char(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`id`, `user_id`, `role_id`, `permission_id`, `position_id`, `created_at`) VALUES
('01483439-2181-409f-b7c7-c3caa3d9fb6d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('03be05df-1ea0-46ee-b335-147b907912ee', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('04d9de08-2a57-4963-87bc-b74697bb16d5', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-04 20:25:04'),
('051f7545-bcf0-472d-9176-7beda04cae3b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('07d59730-9ab0-4eeb-8b81-7bb864d8f02c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('0846499b-6fc8-4989-b36c-b64ba9d7200d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('0846c604-2c41-4a6c-8a14-73c1c6994b23', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('08ce651e-48ef-4618-b8a0-3d386a534a44', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('09c2cd08-e2c3-4053-bd37-6b44d15bc8fc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('0c386af8-38c8-4aa8-9785-148c0bc1a22b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('0ce1f38b-25c8-4b0d-9aae-1dfaa74f742e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('0cf46ab1-116a-492c-ae13-0345be6eaf00', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('0d50cca5-8334-4931-89a1-3ee8baaf2829', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-04 21:41:45'),
('0e162afc-6113-4d70-8617-309d040c9d4b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('10e23ec5-5c79-420f-b008-48dbfdee932c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('11534c61-4c2a-4008-9aaa-2ee367a842e2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('12dc31f9-0dd3-4b8b-8397-2a520a606459', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('1387bfea-da67-4ae5-b670-0ed0ea9827d5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('146435cf-dd2f-455f-9949-fce2bb847e31', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('1467d516-3041-46e5-917b-69169703a0b5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('16ac231d-55c0-47e6-ace9-ca16bcd3acb5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('1872405d-f4a0-441b-86fc-c0c44a5e577d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('1950c75f-e108-41d3-befc-ac84a8cd82cc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('1a1d2412-232c-4c88-b3c8-7289303d4c5c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('1b1fbccd-4de4-4e2a-979d-d7212d3fe2be', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('1bd4a3f1-575a-4933-a5c1-f7b9fbe27913', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('1c7d1d0b-4c49-4576-9225-e2b0bf51b95a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('1ce45349-4188-48cb-ab84-3d56634f4708', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('1ce7bf21-6bf3-4868-a7b1-6f4cfe223920', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('1d7a7280-42d8-47ed-afb2-b124829ea9d9', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('1db9ed95-e8ce-4ff8-bc47-5f40218ecd3a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('1e0c5ae7-789e-4793-be3f-8496c35ce7db', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('20f60ad3-0ffe-4c00-87cd-97e44bfe3e36', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('21cc204e-d880-4c67-9f60-01177374f616', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('2239bcdb-bd52-4848-9c2a-2a789fc594ae', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('22cac0a6-3dc3-49d2-ade9-428e58bb3b69', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('2387d6a9-d5d7-4cc3-9052-90f0a4f5468a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('27013a96-7d70-4221-afa1-0c645a100d13', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('27c8cfd1-9d9a-4f9f-8cea-02d4a348d7c2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('28a2ab98-c605-4b13-9121-94e7ec4dc077', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('294e1845-dc21-4c3f-9472-1c89dfcad854', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('2ae676a3-8982-43b3-92b7-4bb8e4f2fe7e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('2ae91fe4-a2ec-436a-9255-25c1923904ae', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('2b2ef989-fd8c-4e6e-9e8e-ade91f41b039', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('2df2e717-f9ae-4fae-8659-50c4d4e1509b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('321f4e7c-dfe4-407d-9bc2-ba70142fae07', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('339c141f-a3fd-44cd-a39d-a1a07e2e91bc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('33f73546-10bf-4bcf-ad1f-33245599de1d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('3840a6e4-0ffd-4c0b-a866-a57a97ec966e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('3a6b79fa-275d-4b36-bb87-5ceab75e2ef6', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('3b9e6e21-1cdc-43eb-876c-e8f968fc4e65', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('3d3cef84-29de-4ce0-8ff5-4f1aaf246199', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('3dd8ae7f-5d57-474b-9611-0d60df6b8d17', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('3dfeb614-01dc-4dd4-92ab-ef511afdf171', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('3e12c6ed-e867-47f6-b263-8b35e4d16e89', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('3eccd078-5db9-49c7-b383-d3c98b231cd9', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('40de29e5-8925-48b9-9023-5598dfd2cce5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('41e4cd4b-affd-4735-8764-ef1f6ccedcf0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('442b4392-d071-43bf-ac2a-023049b94606', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('45551f1c-ac47-4642-ad3b-c65ac88e16c3', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('45dda166-9b0b-45e7-8b20-9b924eced0f4', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('45e4ca4c-b88b-4d08-898d-293b0ebf4024', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('45f1d974-4c46-4949-b1bc-b3ce4ade48be', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('46deca56-52e3-4e86-bb6d-fc53670abda2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('47e1009e-ac90-42d4-8dfd-aab007cd1cba', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('484c4c3e-9010-4064-94da-bb172e5fca04', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('48e0793f-23fc-48c5-98c6-20eefb2557f4', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('49eb3a50-a82e-4fd6-a9ea-12c743d0ab29', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('4a0644af-b758-4a08-ae87-c33ef0f6390e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('4a7071c5-8ba8-48ce-af03-49df9716dbf3', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('4b0b64d4-7d27-4fd6-a23f-115ec92b078c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('4b1dcaf8-07f9-41b1-a62d-475c0f53b50f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('4bfaf8e9-dcce-43e7-b0ef-51403914f444', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('4cb75081-98d8-4db0-b429-7b395e6814dc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('50530a0f-012d-4488-ad41-f646217351ad', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('50b47ae5-c261-425d-8caa-a378dcde1e7b', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('51c47b66-7912-44ca-b7bb-46333ec8bf00', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('53091eed-dbf0-49e0-91e3-6ee71fee4005', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('5380cbfe-1673-4f5b-9fc4-6bb9b54be97c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('540de873-5197-40d7-8f1c-c16a3b08aee9', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('557b75ab-94fc-4739-aa2d-2c4517de6869', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('56102e48-1859-48dc-9659-4e5a8226b26e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('57bd861f-4794-44be-ba42-8931f204ad99', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('5852e86f-91a3-493f-9ef4-bbab9dd50206', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('5912225e-148e-4abc-8112-ca6a1e4087db', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('5ab5af00-da73-4653-8d5b-183e6a46f6cd', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('5b045821-06a5-404e-bb38-a26d450ce59b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('5bd75d0b-24c3-45a5-80f9-4149816b9d76', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('5bee1127-1693-4cac-803a-50e8d24b8488', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('5c6a1823-7661-4dea-b5be-19bc982d8f1e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('5d3c63f9-7172-4674-8f6c-f14d838bdfe5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('5fe51be4-eb90-4bc8-a4af-ccd0fa2fd7ea', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('611cd00b-9d8c-4700-b77f-bd7bf5ae7c74', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('61ee9b9d-313e-4a43-b4e1-b68e9713d5ef', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('63238b5f-9b4e-48cf-ad46-7f1b28b556a9', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('6472dc8f-b296-4b4a-b856-3e92beeb96fe', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('6548e635-c395-41e1-b284-ff21da56bcba', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('66b9f391-3dab-4786-81d0-3f040796709f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('6762f0b4-1f09-47f1-8d26-972b5305319d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('67ad7a67-95f7-42fd-bb06-26761d484fc5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('69503ffa-8cbc-46a6-b0bb-e8534982aea6', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('6e948c3f-ccb4-43c1-b1f9-4f47a28befdf', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('6f24aba8-2c67-4418-9945-00b979960890', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('6f7892d6-28dc-42d2-b167-8fa0ef2ad951', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('6ff548aa-0c40-4650-bf82-d3b937646a6b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('72d9d5af-60da-406a-a2e9-6d8b0c19bec8', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('7303e3af-a8fe-4a41-bcfa-42e7d6449cd2', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('73a54fae-176f-41cf-b631-32dd2983475d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('754a86c0-fc72-47fd-b528-08752f73c669', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('756bb1fc-4a7a-4cbd-95c1-4ac001cc3f9e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('77591957-359b-4274-8400-d6edf165db61', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('79aa7a97-737f-4ee5-ada8-9a02f0515ccf', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('79b0f4a6-f34f-43a8-af6e-32a59394e0b2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('79cdc867-06d4-4248-a024-bc5b61dfc603', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('7a0841c4-0974-43ad-921c-945c2974624e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('7b10ca44-04ed-4028-a329-30e74954076c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('7bad9e5e-678b-477b-bb61-a797d07aa64a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('7ede2658-8ac8-4ba3-9b88-fc63562d8822', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('803a166d-e8c8-41de-bb56-e2e0f64e612f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('863beb64-d349-4d95-9a7a-efb0d00521d5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('86894be9-bb55-4ede-99b1-79df97613ae1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('86f7cb22-97d6-474e-b1c3-6cdf161c4ca1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('874f6b92-f470-4ba4-9d53-357c224bf9c5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('87817251-c905-4874-b2a4-1366b41fa6fc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('8872ff0a-d63a-4973-aa8e-0274ca44a787', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('88a86609-0ee2-40c7-86ee-579081d78c5f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('8931cb5f-8116-435f-842e-3bd1f137cd77', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('8a3a8464-cf3b-4fd2-b9cd-e0079c125321', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('8a89dc52-46ad-489d-93a6-f54590b20b23', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('8aa9f212-720c-4f9a-8123-2109a8ecd3a4', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('8c2cb036-8e42-4431-8f4a-28c4627c18f1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('8d0f767a-fa22-45bf-b712-c78c75308c50', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('8d0ffe2a-7de3-417a-b525-5efe7b802c49', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('8d502077-9a4c-4b37-a12e-5e6d40d726f8', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('8f9d72fc-53da-4563-a576-e98464177d95', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('90647aab-fc5c-4555-9f1a-0fad2f61cb3f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('90ad9ac8-d735-452b-931d-1c60358f9001', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('90c6b499-cb1e-49be-acaa-c44fc6829a4a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('911e70c3-2734-4313-af23-bb7dbe2e2258', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('957151a2-0674-4ff5-ba20-a45b3ec61758', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('95d2ef87-8a88-40f8-a731-dc4dfa22632e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('965d6c32-d340-4c21-b744-fa635f919627', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('96855852-8cea-422a-9189-55fb5ea37f1b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('96b61f4f-f054-4a32-9bb4-4c72df068b4b', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('96d26ba7-8b1d-451c-82a1-669b3ecbd304', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('9759ff90-d4a2-402e-be36-ee531a8cf1a5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('982209f8-c4ef-4531-ab24-b84df54b9629', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('987e3c6c-f740-444f-923e-ece766c03d3a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('98aa6d6f-5bbc-4975-af44-8ec402cceaa0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('99173c52-e216-4b01-888f-18243fdab078', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('992117d7-6360-47ae-add7-9fef31d0f553', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('99cbc067-fd11-4982-a5be-8ed3ceb74bec', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('9a3f2fda-48a8-4dfe-b7db-966223f9d255', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('9b71b35e-0570-4ced-8567-cd6fe35f2205', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('9b979a94-8751-4d59-bbe3-8bdd746da8d2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('9d116cb6-e459-402e-bea9-3d868c5ac049', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-04 21:41:45'),
('9d183cb6-ec81-4381-9f21-9e269ef40514', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-04 21:41:45'),
('9e2087c9-60c7-4184-9489-31b160bd85e8', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('9e3188e5-684d-4921-b7f7-0258a251ab8e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('9f17f17e-eba4-4b0f-9b37-fe074c318b34', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('9f1f1b9a-6875-4847-a68c-210a24617e71', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('a0e809ea-378a-4eca-a191-7c88fe69dd7c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('a15ae16e-12af-46dd-a27b-707cf95c496d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('a2533ec0-209a-4211-9ea6-0b83540a8c83', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('a34a8eb1-9708-4a63-a3ff-caa389472650', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('a50896f9-9226-4577-87a7-ee59eb675d49', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('a6169cdb-7bbf-4c28-8d28-7c55b76807c0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('a792043f-68d6-43c8-92cf-ffaa6b11d309', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('a7d75a81-9d6f-4043-8de6-701dae89788a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('a898fe72-292d-464b-afed-e150b5b76e33', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('ab6db5b1-6bd1-40ad-8210-ce25dbc881d1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('ac1d3824-0123-4991-ae4f-3bf023591cd2', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('adc8536f-b904-45d0-b4e4-013845467950', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('afd70649-8ccf-427f-9f25-9bfd1f773884', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('b0a03922-beaa-4632-8fb5-6b3a7cb018ab', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-04 20:25:04'),
('b2c20001-0000-4000-8000-000000000001', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-08-05 00:00:00'),
('b2c20002-0000-4000-8000-000000000002', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-08-05 00:00:00'),
('b2c20003-0000-4000-8000-000000000003', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-08-05 00:00:00'),
('b2c20004-0000-4000-8000-000000000004', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-08-05 00:00:00'),
('b2c20005-0000-4000-8000-000000000005', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-08-05 00:00:00'),
('b2c20006-0000-4000-8000-000000000006', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-08-05 00:00:00'),
('b2c20007-0000-4000-8000-000000000007', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-08-05 00:00:00'),
('b2c20008-0000-4000-8000-000000000008', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-08-05 00:00:00'),
('b2c20009-0000-4000-8000-000000000009', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-08-05 00:00:00'),
('b2c20010-0000-4000-8000-000000000010', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', NULL, '2026-08-05 00:00:00'),
('b2c20011-0000-4000-8000-000000000011', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-08-05 00:00:00'),
('b2c20012-0000-4000-8000-000000000012', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-08-05 00:00:00'),
('b2c20013-0000-4000-8000-000000000013', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-08-05 00:00:00'),
('b2c20014-0000-4000-8000-000000000014', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-08-05 00:00:00'),
('b2c20015-0000-4000-8000-000000000015', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-08-05 00:00:00'),
('b2c20016-0000-4000-8000-000000000016', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10016-0000-4000-8000-000000000016', NULL, '2026-08-05 00:00:00'),
('b2c20017-0000-4000-8000-000000000017', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10017-0000-4000-8000-000000000017', NULL, '2026-08-05 00:00:00'),
('b2c20018-0000-4000-8000-000000000018', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-08-05 00:00:00'),
('b2c20019-0000-4000-8000-000000000019', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-08-05 00:00:00'),
('b2c20020-0000-4000-8000-000000000020', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-08-05 00:00:00'),
('b2c20021-0000-4000-8000-000000000021', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', NULL, '2026-08-05 00:00:00'),
('b2c20022-0000-4000-8000-000000000022', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-08-05 00:00:00'),
('b2c20023-0000-4000-8000-000000000023', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10023-0000-4000-8000-000000000023', NULL, '2026-08-05 00:00:00'),
('b2c20024-0000-4000-8000-000000000024', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-08-05 00:00:00'),
('b2c20025-0000-4000-8000-000000000025', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-08-05 00:00:00'),
('b2c20026-0000-4000-8000-000000000026', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10026-0000-4000-8000-000000000026', NULL, '2026-08-05 00:00:00'),
('b2c20027-0000-4000-8000-000000000027', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10027-0000-4000-8000-000000000027', NULL, '2026-08-05 00:00:00'),
('b2c20028-0000-4000-8000-000000000028', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-08-05 00:00:00'),
('b2c20029-0000-4000-8000-000000000029', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10029-0000-4000-8000-000000000029', NULL, '2026-08-05 00:00:00'),
('b2c20030-0000-4000-8000-000000000030', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10030-0000-4000-8000-000000000030', NULL, '2026-08-05 00:00:00'),
('b2c20031-0000-4000-8000-000000000031', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10031-0000-4000-8000-000000000031', NULL, '2026-08-05 00:00:00'),
('b2c20032-0000-4000-8000-000000000032', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10032-0000-4000-8000-000000000032', NULL, '2026-08-05 00:00:00'),
('b2c20033-0000-4000-8000-000000000033', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10033-0000-4000-8000-000000000033', NULL, '2026-08-05 00:00:00'),
('b2c20034-0000-4000-8000-000000000034', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10034-0000-4000-8000-000000000034', NULL, '2026-08-05 00:00:00'),
('b2c20035-0000-4000-8000-000000000035', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10035-0000-4000-8000-000000000035', NULL, '2026-08-05 00:00:00'),
('b2c20036-0000-4000-8000-000000000036', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-08-05 00:00:00'),
('b2c20037-0000-4000-8000-000000000037', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10037-0000-4000-8000-000000000037', NULL, '2026-08-05 00:00:00'),
('b2c20038-0000-4000-8000-000000000038', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10038-0000-4000-8000-000000000038', NULL, '2026-08-05 00:00:00'),
('b2c20039-0000-4000-8000-000000000039', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10039-0000-4000-8000-000000000039', NULL, '2026-08-05 00:00:00'),
('b2c20040-0000-4000-8000-000000000040', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10040-0000-4000-8000-000000000040', NULL, '2026-08-05 00:00:00'),
('b2c20041-0000-4000-8000-000000000041', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10041-0000-4000-8000-000000000041', NULL, '2026-08-05 00:00:00'),
('b2c20042-0000-4000-8000-000000000042', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10042-0000-4000-8000-000000000042', NULL, '2026-08-05 00:00:00'),
('b2c20043-0000-4000-8000-000000000043', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10043-0000-4000-8000-000000000043', NULL, '2026-08-05 00:00:00'),
('b2c20087-0000-4000-8000-000000000087', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-08-05 00:00:00'),
('b2c20088-0000-4000-8000-000000000088', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-08-05 00:00:00'),
('b2c20089-0000-4000-8000-000000000089', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-08-05 00:00:00'),
('b2c20090-0000-4000-8000-000000000090', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-08-05 00:00:00'),
('b2c20091-0000-4000-8000-000000000091', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-08-05 00:00:00'),
('b2c20092-0000-4000-8000-000000000092', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-08-05 00:00:00'),
('b2c20093-0000-4000-8000-000000000093', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-08-05 00:00:00'),
('b2c20094-0000-4000-8000-000000000094', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-08-05 00:00:00'),
('b2c20095-0000-4000-8000-000000000095', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-08-05 00:00:00'),
('b2c20096-0000-4000-8000-000000000096', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-08-05 00:00:00'),
('b2c20097-0000-4000-8000-000000000097', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-08-05 00:00:00'),
('b2c20098-0000-4000-8000-000000000098', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-08-05 00:00:00'),
('b2c20099-0000-4000-8000-000000000099', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-08-05 00:00:00'),
('b2c20100-0000-4000-8000-000000000100', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-08-05 00:00:00'),
('b2c20101-0000-4000-8000-000000000101', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-08-05 00:00:00'),
('b2c20102-0000-4000-8000-000000000102', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-08-05 00:00:00'),
('b2c20103-0000-4000-8000-000000000103', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-08-05 00:00:00'),
('b2c20104-0000-4000-8000-000000000104', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-08-05 00:00:00'),
('b2c20105-0000-4000-8000-000000000105', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-08-05 00:00:00'),
('b2c20106-0000-4000-8000-000000000106', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-08-05 00:00:00'),
('b2c20107-0000-4000-8000-000000000107', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-08-05 00:00:00'),
('b2c20108-0000-4000-8000-000000000108', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-08-05 00:00:00'),
('b2c20109-0000-4000-8000-000000000109', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-08-05 00:00:00'),
('b2c20110-0000-4000-8000-000000000110', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-08-05 00:00:00'),
('b2c20111-0000-4000-8000-000000000111', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-08-05 00:00:00'),
('b2c20112-0000-4000-8000-000000000112', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-08-05 00:00:00'),
('b2c20113-0000-4000-8000-000000000113', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-08-05 00:00:00'),
('b2c20114-0000-4000-8000-000000000114', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-08-05 00:00:00'),
('b2c20115-0000-4000-8000-000000000115', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-08-05 00:00:00'),
('b2c20116-0000-4000-8000-000000000116', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-08-05 00:00:00'),
('b2c20117-0000-4000-8000-000000000117', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-08-05 00:00:00'),
('b2c3a5fd-77c7-4f70-ad7d-85ce1fa20413', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('b363b764-13a0-47d6-b46e-718b1139b651', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('b3cbbc80-6f21-4dac-a91c-abf67aaf4583', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('b5b562f5-19db-457b-949b-94447940641e', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'ccc15133-f9f3-4f94-9bae-fbe289eeb66c', NULL, '2026-09-04 21:41:45'),
('b6c6b727-aa0f-436f-bd0d-386d0c7dcce8', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('b7b900fc-559b-4a89-8c39-de0255a7a26c', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('b948ed61-4aeb-45c9-a0ef-f11e68e3880d', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-04 21:41:45'),
('b96ec1dd-72ca-4c76-b02c-99f9c910561e', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('b9a0d4f0-c814-49c5-8b65-75ff6dd42271', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('bb93d438-c7e0-49bb-9521-97e13a9b55e4', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('bd95fe1d-a145-4e4d-a16e-b9aefad1ac1a', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-04 21:41:45'),
('be171a75-0d8c-41d5-b1b2-cc9d2b2c2dcb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('be63d59f-d842-4dd2-8a07-bf47596bc0ef', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('bfcbb6b6-ccbf-43a7-aa1b-e3d95213f6d8', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('c3142404-3058-40fc-9f1b-cdd6f1d2dc35', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('c33b3e69-50dc-4b28-b83a-f3070fd8a63a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('c3714a26-7af4-493c-bc6b-ea654ab4ea74', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('c3f41807-770d-4019-9bb0-f3b71b1a1146', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('c45039c4-fc59-4595-8af5-cfdbd5564da7', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('c4bfd511-a736-4861-b9cc-bd77346bd4ca', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('c50d4292-482d-4687-bf98-ab3cd6c69f97', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('c5ae5093-6195-4426-a325-58d54517be15', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('c6258ad2-491d-4212-be20-b19cd27ee2ac', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('c8710528-ebe5-4075-a642-d234e1cee311', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('c88c8552-4d0d-40b8-88b1-13b19f790491', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('ca5c411e-b384-4ea5-a32d-71853ad104eb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('cb04a829-adbd-4f0a-af9c-a36a4b4cee10', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('cc091bcd-d674-4e3d-9e92-cc56ef6d03ac', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('ce09e899-187b-4034-a080-b342852a3430', NULL, '059f5000-235d-11f1-9647-10683825ce81', '27619e4b-431e-4d56-8666-395376d970e1', NULL, '2026-09-04 20:25:04'),
('ce2c62e2-4e5e-43c2-b438-c8e7707fe3a1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('cf415408-bcb7-46f0-8c35-e9cf38a90302', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-04 21:41:45'),
('cf94b875-179f-45e4-8f55-c11ac50d0ae1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('d0b493cb-25fc-44f3-a6a7-9ba0e2d3df72', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('d1a17e7a-5f20-48b1-b575-e352d06038c5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09');
INSERT INTO `role_permission` (`id`, `user_id`, `role_id`, `permission_id`, `position_id`, `created_at`) VALUES
('d205e1b2-ada1-40cd-a103-851d07a27383', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('d242e714-0eef-4c71-b32f-cf5b5d03081d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:09'),
('d3df5524-3b3d-45db-8b09-4265d9710fbb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('d50baba9-7350-4340-8209-dae1b89d048a', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('d610eb6c-36e4-4092-8de3-536bd3f2b599', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('d6201421-1e49-45b6-9aba-acc90d67e7e5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('d6634050-a252-47b4-bd41-97a7b83f897b', NULL, '059ef712-235d-11f1-9647-10683825ce81', '27619e4b-431e-4d56-8666-395376d970e1', NULL, '2026-09-04 21:41:45'),
('d75abc0a-56a8-4e82-ad09-d329ab5346c5', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('d78ca3e6-f5dc-4611-a703-69eebf9656cb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('da017d5b-6232-4b1e-b785-0a31f0a83565', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('da266a1b-2347-474e-b085-38bb35403614', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('da9ba1dc-ba94-4fa0-963d-6e6133064bdf', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('dbd947e6-8253-485f-8b47-6421e4a2415f', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('dc6fde45-e371-4acb-b057-8a175d820215', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-04 21:41:45'),
('dc7e8b6b-0345-4c4d-aab9-485d1c478199', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('dd32d638-19b1-4ee6-9709-e4a0871a8508', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('ddd72d43-1b69-44ad-a3e7-57ea027394e0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('dec35316-49a9-419f-afbd-691a4606ef09', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('ded7bcab-b5a7-46df-a816-a992164bbb25', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-04 20:25:04'),
('e0cf49ed-0c9d-40c0-9775-28d7c9bad09c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('e10fe978-bb69-49d5-9fbd-d747c0a9ceee', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', 'd4a05f3085ca485481297597809ce86b', '2026-08-26 09:39:09'),
('e152add8-d06e-4561-919f-1dc6e14ab505', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('e1e2b4e5-702b-402f-ad46-82ec79556180', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('e22d867f-10f9-4c46-8ee7-448db984e491', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('e2766b20-d32c-494a-a6ef-5c4e1a2d98ef', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('e28da1d9-b8e0-43c7-9fad-54f553db9a40', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('e2ec2e8d-5cac-4a86-a47d-d4e9db4264ae', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('e4027fb4-c37d-4c5c-83be-7e4d3f8fbcec', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('e5ca98b9-96c8-4990-a3ff-0f8b0e1a61b6', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('e613e683-19f6-4228-acfb-6e279a40a96b', NULL, '059efde1-235d-11f1-9647-10683825ce81', '351ae38f-fa2f-4ffa-bf0c-2df76c4b76e8', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('e70ed49a-822e-4762-93cd-f4eb52809a7d', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('e761c913-edac-43a2-a860-3d1164abe1cb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('e79baf71-f44a-46cb-9a60-4811c8e30935', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('e8f1c5ca-bdff-4221-83ee-8de89d02ce6c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('e94bcfa8-c456-4337-817b-a16c5b4a4123', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'f95370650f034c519f0d664804e6e39e', '2026-08-26 09:39:10'),
('eb733cc4-6bab-4cdb-99fb-ff1e11360475', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('ec80019c-8bc8-4f32-b508-a931091611fb', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '4d56f01a349c417080773dd2e903af79', '2026-08-26 09:39:09'),
('ec97ee43-46c1-428d-8f2b-d330b5e0ddd0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('ed5fd991-9615-429b-bd99-736d8ac838e1', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('edeee60f-20ac-4d6a-af62-aa02a0792fbf', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('ef0d7b28-f17a-4253-900c-79e037684938', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '0ccfddd1088444f6b51ab3ab2db4136d', '2026-08-26 09:39:09'),
('ef1fcc0a-2d81-4eef-bea5-b150d9ba65cd', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'cd38469e830347ea992a9bef247976de', '2026-08-26 09:39:09'),
('f0e234f4-9eb5-443e-a574-854e12ba7410', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('f41382a0-87d0-462a-a3a1-1e4af03fbd94', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '1e4c17b97cdd4698bcff7c013968ca0c', '2026-08-26 09:39:09'),
('f464baee-5c09-4801-8c66-9c8c7efe4cba', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '65139933a20941e6b43a6ac994dbaf37', '2026-08-26 09:39:09'),
('f5cbe05b-2009-4a51-bd4f-04c6d32c59ac', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', 'ca496e8495a940dcbfd47577c0dc3804', '2026-08-26 09:39:09'),
('f7efb2a2-453c-46af-b1ee-c97934451b14', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', 'd866ab91189341e582fdcf09ccda7c41', '2026-09-06 00:35:09'),
('f98c003f-5a64-4e96-9bc8-8e868e550a91', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '149ec35a62264ad0bfda18568cd63580', '2026-08-26 09:39:09'),
('fbf43ffc-4b53-432e-b28d-36eca5ac1373', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', 'cbba3880ef414030a6cd1c4ffae6f909', '2026-08-26 09:39:09'),
('fce8c9b1-b712-416d-bad5-ac4802acc3fc', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '27add2cb646b4a319e9bdbfc9d8054b6', '2026-09-04 22:06:25'),
('fd97ca96-2394-4e33-a1b4-e5db486a44d0', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2a7f5a843c864b97ac0696e7b563a1e3', '2026-08-26 09:39:09'),
('fe4e5732-89ba-46a2-88b4-116015a7e66c', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'b8aa8993-45b6-45f3-aa4b-1e0c23833c6c', '6c939efb408344c3bd58806f80ed4a9e', '2026-08-26 09:39:09'),
('fedcc7a3-4781-4d70-ad86-950aad437ebd', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-04 20:25:04');

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
('JPUMtWf8ba6WoWtKb81VWh1UJgyWa4L83DUnnnp0', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiaURYWHJ5bGFSWDVPV29JcnFZZ3hMa0U5TW5IRzhxYUV0YUJlRDJ0YyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyOToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkdmlzZXIiO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czoyNjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3VzZXIiO3M6NToicm91dGUiO3M6MTQ6InVzZXIuZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO3M6MzY6ImUyMjNkN2QwLTNlY2YtNGRkZC1iZGE2LWU1NTg3NDFmZWMyNiI7fQ==', 1788692623, 1),
('U2k8xvj15o2WTFjVsZ89mUZ4TW7Jls381uPG0UN8', 'd1de808f-0522-4486-ae80-c82cba2a69e4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Safari/537.36 Edg/152.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoibGJDdlBDUjBIMmlzcGk2NjJWZjVSZjdTN090UWRJWXQ1dlZHdnlhNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZHZpc2VyL3JvbGUtcGVybWlzc2lvbnMvZ2V0LWNvdW5jaWwtdGVybSI7czo1OiJyb3V0ZSI7czo0MToiYWR2aXNlci5yb2xlLXBlcm1pc3Npb25zLmdldC1jb3VuY2lsLXRlcm0iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiZDFkZTgwOGYtMDUyMi00NDg2LWFlODAtYzgyY2JhMmE2OWU0Ijt9', 1788692526, 0);

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
('12312313', 'e223d7d0-3ecf-4ddd-bda6-e558741fec26', NULL, 0, 'Member', NULL, NULL, 0, '2026-09-04 20:14:19', '2026-09-06 03:02:05', 0);

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
('897987', '6373498c-903e-43a9-bb1d-b67a496aee24', '059bb3b0-235d-11f1-9647-10683825ce81', 1, '2026-08-04 23:52:28', '2026-08-05 00:04:21', 0),
('T-123123123', 'd1de808f-0522-4486-ae80-c82cba2a69e4', NULL, 1, '2026-09-04 20:08:40', '2026-09-04 20:23:20', 0);

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
('6373498c-903e-43a9-bb1d-b67a496aee24', '059ef3f9-235d-11f1-9647-10683825ce81', 'LARENCE jhgjgh', 'jmsumulong@kld.edu.ph', '2026-08-04 23:52:28', NULL, NULL, 0, NULL, '$2y$12$f3.xbygNSC3HZnB.KZHEAe8/Is4sba5o5GvuXo0IaSN.tnEFjvaOi', NULL, 1, NULL, 'active', '2026-09-04 20:08:16', NULL, '2026-08-04 23:51:52', '2026-09-04 20:08:16', 0),
('d1de808f-0522-4486-ae80-c82cba2a69e4', '059ef712-235d-11f1-9647-10683825ce81', 'LAWRENCE CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-09-04 20:08:40', NULL, NULL, 0, '09234234231', '$2y$12$DLUzPOQtLZX39HIGz2Ro1u7ZSSU4vYocNejzgCndhz5PgQhvmer4y', NULL, 1, NULL, 'active', '2026-09-06 00:33:34', NULL, '2026-09-04 20:07:38', '2026-09-06 00:33:34', 0),
('e223d7d0-3ecf-4ddd-bda6-e558741fec26', '059f4170-235d-11f1-9647-10683825ce81', 'EDWARD QUINTOS', 'emdgquintos@kld.edu.ph', '2026-09-04 20:14:19', NULL, NULL, 0, '09345345325', '$2y$12$nUA6ArFjnCEkjXyevYZ0Z.ETaQkojcpwEPxlfexeE5x3XifZ69Uhy', NULL, 1, NULL, 'active', '2026-09-06 00:33:52', NULL, '2026-09-04 20:13:52', '2026-09-06 03:02:05', 0),
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
-- Indexes for table `concern`
--
ALTER TABLE `concern`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`user_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `institute_id` (`institute_id`);

--
-- Indexes for table `date_change_requests`
--
ALTER TABLE `date_change_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date_change_requests_project_id_foreign` (`project_id`),
  ADD KEY `date_change_requests_requested_by_foreign` (`requested_by`),
  ADD KEY `date_change_requests_reviewed_by_foreign` (`reviewed_by`);

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
-- Indexes for table `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD PRIMARY KEY (`notification_id`,`user_id`),
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
  ADD KEY `permission_id` (`permission_id`),
  ADD KEY `position_id` (`position_id`);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

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
-- Constraints for table `date_change_requests`
--
ALTER TABLE `date_change_requests`
  ADD CONSTRAINT `date_change_requests_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `date_change_requests_requested_by_foreign` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `date_change_requests_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

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
-- Constraints for table `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD CONSTRAINT `notification_reads_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_reads_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `student_csg_officers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
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
