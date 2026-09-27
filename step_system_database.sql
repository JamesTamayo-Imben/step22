-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 27, 2026 at 06:43 AM
-- Server version: 11.8.9-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u516679075_stepsystemdb`
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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assets`
--

CREATE TABLE `assets` (
  `id` char(36) NOT NULL,
  `source_ledger_entry_id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `asset_category` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `available_quantity` int(10) UNSIGNED NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL DEFAULT 0.00,
  `status` enum('available','unavailable','archived') NOT NULL DEFAULT 'available',
  `archive` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assets`
--

INSERT INTO `assets` (`id`, `source_ledger_entry_id`, `project_id`, `name`, `asset_category`, `description`, `quantity`, `available_quantity`, `unit_cost`, `status`, `archive`, `created_at`, `updated_at`) VALUES
('0e20aa10-f378-4ea2-9ec5-d370ce8c1730', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Tables', 'Furniture', 'We will buy item that can be use for the future events', 1, 1, 100.00, 'available', 0, '2026-09-26 10:58:00', '2026-09-27 05:54:29'),
('67050124-08b0-43de-be28-b658d58982aa', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Chairs', 'Furniture', 'We will buy item that can be use for the future events', 10, 10, 10.00, 'available', 0, '2026-09-26 10:58:00', '2026-09-27 05:54:29'),
('879fd4a3-8e76-4b7b-89a1-67bfa7d462f6', 'a63da296-8a8f-43c6-a150-e11eb425c12a', '58f38625-3132-485e-a8a6-308436e56bf2', 'chair', 'Other', 'We will buy a materials that can be use as asset in the future', 10, 0, 100.00, 'unavailable', 0, '2026-09-26 10:10:36', '2026-09-26 10:10:36'),
('887b7aa0-0db9-43bf-8d76-c88f47f70aeb', 'db403730-fb41-47bc-a2e3-78245d425ff0', '58f38625-3132-485e-a8a6-308436e56bf2', 'Laptop', 'Other', 'We will buy a materials that can be use as asset in the future', 1, 0, 100.00, 'unavailable', 0, '2026-09-26 08:38:05', '2026-09-26 08:38:05'),
('90a14b98-54c9-46e9-bf1b-cff2dace8f6a', '802fbfdb-6639-4949-af5e-7b83d2cf9d2b', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Speakers', 'Other', 'Test asset - dont approve', 1, 0, 1000.00, 'unavailable', 0, '2026-09-26 16:42:15', '2026-09-26 16:42:15'),
('c1839f54-1236-44bb-beda-7b6edd4ae29d', 'db403730-fb41-47bc-a2e3-78245d425ff0', '58f38625-3132-485e-a8a6-308436e56bf2', 'Chairs', 'Other', 'We will buy a materials that can be use as asset in the future', 1, 0, 100.00, 'unavailable', 0, '2026-09-26 08:38:05', '2026-09-26 08:38:05');

-- --------------------------------------------------------

--
-- Table structure for table `asset_disposals`
--

CREATE TABLE `asset_disposals` (
  `id` char(36) NOT NULL,
  `asset_id` char(36) DEFAULT NULL,
  `source_ledger_entry_id` char(36) DEFAULT NULL,
  `asset_name` varchar(255) NOT NULL,
  `asset_category` varchar(255) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `reason` text NOT NULL,
  `disposed_by` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `asset_usages`
--

CREATE TABLE `asset_usages` (
  `id` char(36) NOT NULL,
  `asset_id` char(36) NOT NULL,
  `project_id` char(36) DEFAULT NULL,
  `ledger_entry_id` char(36) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `status` enum('assigned','returned') NOT NULL DEFAULT 'assigned',
  `assigned_at` timestamp NULL DEFAULT NULL,
  `returned_quantity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `returned_at` timestamp NULL DEFAULT NULL,
  `returned_by` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `asset_usages`
--

INSERT INTO `asset_usages` (`id`, `asset_id`, `project_id`, `ledger_entry_id`, `quantity`, `status`, `assigned_at`, `returned_quantity`, `returned_at`, `returned_by`, `created_at`, `updated_at`) VALUES
('516a9c8e-1946-4eb0-bd5f-eb87a202abf4', '887b7aa0-0db9-43bf-8d76-c88f47f70aeb', '58f38625-3132-485e-a8a6-308436e56bf2', 'db403730-fb41-47bc-a2e3-78245d425ff0', 1, 'assigned', '2026-09-26 08:38:05', 0, NULL, NULL, '2026-09-26 08:38:05', '2026-09-26 08:38:05'),
('67572e5c-0b6a-4516-9472-9d9ec405d7fd', '90a14b98-54c9-46e9-bf1b-cff2dace8f6a', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', '802fbfdb-6639-4949-af5e-7b83d2cf9d2b', 1, 'assigned', '2026-09-26 16:42:15', 0, NULL, NULL, '2026-09-26 16:42:15', '2026-09-26 16:42:15'),
('6a25fb60-bb27-43fe-ae6e-293e77fc6bfb', '879fd4a3-8e76-4b7b-89a1-67bfa7d462f6', '58f38625-3132-485e-a8a6-308436e56bf2', 'a63da296-8a8f-43c6-a150-e11eb425c12a', 10, 'assigned', '2026-09-26 10:10:36', 0, NULL, NULL, '2026-09-26 10:10:36', '2026-09-26 10:10:36'),
('95e89f1d-c488-4f39-a95c-5266565b873c', '67050124-08b0-43de-be28-b658d58982aa', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 10, 'returned', '2026-09-26 10:58:00', 10, '2026-09-27 05:54:29', NULL, '2026-09-26 10:58:00', '2026-09-27 05:54:29'),
('aa42c96e-87f5-47cb-a732-5bbfd82beeb3', '0e20aa10-f378-4ea2-9ec5-d370ce8c1730', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 1, 'returned', '2026-09-26 10:58:00', 1, '2026-09-27 05:54:29', NULL, '2026-09-26 10:58:00', '2026-09-27 05:54:29'),
('e06eda5d-74c3-48e0-ba81-3ebe95f8b01c', 'c1839f54-1236-44bb-beda-7b6edd4ae29d', '58f38625-3132-485e-a8a6-308436e56bf2', 'db403730-fb41-47bc-a2e3-78245d425ff0', 1, 'assigned', '2026-09-26 08:38:05', 0, NULL, NULL, '2026-09-26 08:38:05', '2026-09-26 08:38:05');

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
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('07cf9c17-d4ca-4745-8720-85f0f9ee6886', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', NULL, 'blockchain', 'Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 budget mismatch(es) detected across verified project chains.', '2405:8d40:4c80:372c:c00b:9ad3:f5b9:a742', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 02:24:11', 0),
('11cf5109-05bb-4084-adbf-befc14c51a54', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:1:4823', NULL, NULL, '2026-09-22 23:29:46', 0),
('13a5b678-0251-43a6-b929-d62353949661', '756b0138-bbe6-4fb8-be43-21b17361e5ec', NULL, 'blockchain', 'Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 budget mismatch(es) detected across verified project chains.', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:49:44', 0),
('18fde0da-77d3-4aa8-aede-bdc33a4cf24c', NULL, '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'test — TEST', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:09:29', 0),
('238926f5-c708-40b2-a131-8ded74c5fe32', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '58f38625-3132-485e-a8a6-308436e56bf2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"KLD FOUNDATION WEEK 2025 (sample1)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 07:55:00', 0),
('29080b6f-caae-4c02-81ca-e647f9187043', NULL, NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 23:30:38', 0),
('2f11cbfe-2395-4aa5-b20a-99fe4783bd43', NULL, 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: HACKATON 2026 (sample 3) — Need more information for credibility', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:21:12', 0),
('33dcf4ff-ea63-4cc5-9b76-0c61facbc4f2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'a63da296-8a8f-43c6-a150-e11eb425c12a', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"We will buy a materials that can be use as asset in the future\" for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:56:28', 0),
('33fec2dd-20a6-4a64-ad5a-5d4b07783023', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"Anti-Bullying Awareness 2026\"', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-27 04:16:01', 0),
('35ae704f-d9d2-4a1d-a892-c7419ed12d8f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'b984c09c-a66d-4e34-9489-4d75222b8188', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"sample\"', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 07:57:38', 0),
('35ae8f8d-57b8-4415-9494-f6f434c39770', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd6c01bae-4c4e-4626-bbed-9f145155bc24', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"Tech Innovation Summit 2026\"', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 07:55:58', 0),
('3bc65066-33be-4ad2-b042-3c263d28700f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd2f97975-322c-4cd4-aa14-6b302b71e7b8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SAMPLE\"', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 12:03:59', 0),
('3bf9485a-a530-4d00-bd78-a364dc1c8755', NULL, NULL, 'blockchain', 'Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 budget mismatch(es) detected across verified project chains.', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 23:29:46', 0),
('404fe3ce-f133-49e9-8160-031f6391e120', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '62946d3c-8596-4ca5-9927-21b63d1965bd', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:06:41', 0),
('40bfcef2-6d20-4460-a2c0-374b11d45ec9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd2f97975-322c-4cd4-aa14-6b302b71e7b8', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"SAMPLE\" and 0 related ledger entries', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 07:53:41', 0),
('417a0079-17a9-40cd-be68-17e87d4d6972', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:41', 0),
('43ac3dc8-7174-40aa-b2d7-7c3aec2433d4', NULL, '2804cc1f-55c4-4be6-9d30-bda126f19766', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:49:44', 0),
('45c955ab-54cc-4ec2-86b2-31a80bfc1f34', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'project', 'Project Approved', 'approvals', 'update', NULL, 'Approved project: Tech Innovation Summit 2026', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:39:18', 0),
('485de113-de6c-44ab-9d57-07f8458b102c', NULL, '65f4072c-fca0-4a53-a99e-d7a2b8af29bf', 'date_change_request', 'Date Change Request Approved', 'approvals', NULL, NULL, 'Approved date change request for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 12:37:13', 0),
('4953a150-e952-425e-bf1a-04def159161e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '1ee4d579-9b41-468a-a691-b86ad5735c04', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"KULTURA\'T MUSIKA: Himig ng Kabataan, Tinig ng Kinabukasan 2026 (sample 2)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:18:34', 0),
('49e828c9-f441-4cc4-aaad-07aae89ba167', NULL, '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'test — TEST', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:15:36', 0),
('4c7f57e6-0b82-4e58-b534-38627bc50b22', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '3d8e70fe-3a7d-4d59-8cd1-09685ac38cae', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 12:56:43', 0),
('50a7deb4-0e0a-41c3-8fa1-ebea5ceabcb3', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID d087b77d-8451-48fb-9ae9-f07e26aa9232', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:58:00', 0),
('57951b95-d200-448b-ad91-1d7be2e0a8bb', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '6b058e99-109b-413a-9d33-64314f658821', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (1 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('5b6f3512-99c5-4f51-82b5-a1ff38499c23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '76de8fab-03a1-49a0-9a59-a796b83ca94c', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"TEST\" for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:18:16', 0),
('5dc94bcf-e599-43fe-813f-799ea0220989', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '02205088-ebd3-4d02-b7e4-42a9bd0473c3', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 14:33:38', 0),
('5fc5dc34-a268-4448-90b1-b8b3d6541f24', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"SAMPLE 7\" and 1 related ledger entry', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 07:53:44', 0),
('6cfeb7c3-0787-4d8e-9e32-2db40a30026e', NULL, NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 02:50:05', 0),
('6dad0668-1ba5-4573-85ba-72a4bbd86943', NULL, 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: SPORT FEST 2026', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 01:52:15', 0),
('6f5ca0f3-58d2-414b-8d12-c7498424182b', NULL, '6f6f7039-e6c3-4f82-9abf-5027970a4232', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:38', 0),
('7066e332-76ac-43dc-9ef7-14b6ef36a6ce', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '6f6f7039-e6c3-4f82-9abf-5027970a4232', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:08:37', 0),
('792f96fd-1479-48b0-9c68-8f59235463cb', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'db403730-fb41-47bc-a2e3-78245d425ff0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:38:05', 0),
('7a27761e-14e3-4d99-ac63-64d52248d4e7', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SAMPLE 7\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 10:58:52', 0),
('7d4a681f-52e9-4a13-a219-3c2ad2a2af57', '756b0138-bbe6-4fb8-be43-21b17361e5ec', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:51:05', 0),
('849d7189-d796-4935-9f3e-0da7b8a93037', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '802fbfdb-6639-4949-af5e-7b83d2cf9d2b', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID d087b77d-8451-48fb-9ae9-f07e26aa9232', '123.253.51.170', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Mobile Safari/537.36', '2026-09-26 16:42:15', 0),
('86773f21-4e72-4a83-967c-ee0fae4e13c6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"Anti-Bullying Awareness 2026\" and 1 related ledger entry', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-27 04:19:51', 0),
('8761393a-67c4-4150-b4e2-71c35bb6fa98', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'fdc79177-c941-45a7-9c29-666a64c85e36', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (1 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('890c128e-a7c5-4dc4-ae46-798cc3e4f2c9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '7f34c673-3de7-4386-9191-135ad6ea2666', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:30:36', 0),
('91024ae2-003c-437e-8f54-b1172355d98c', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:02:40', 0),
('9391d8cf-92b3-47d5-87fb-9b1f7cac162d', NULL, '62946d3c-8596-4ca5-9927-21b63d1965bd', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'This is the list of materials that we are buying for the event.\r\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below. — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:21', 0),
('940e441f-dd46-498f-bf0d-05fbe26fa493', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:09', 0),
('967811b3-ac44-4e00-944a-898ee6457772', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '98cf7626-6bff-4cbb-9cc3-43884ece691f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"BAKOD KO LINIS KO (sample 4)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:28:25', 0),
('971739b6-60bd-41b7-8b13-bdb0bd5ab659', NULL, NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 02:07:38', 0),
('98a014b7-896f-4890-bdfe-4f8469ecae3c', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'db403730-fb41-47bc-a2e3-78245d425ff0', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', 'reject', NULL, 'We will buy a materials that can be use as asset in the future — Check the proof', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:42:04', 0),
('a158d671-5006-4bb8-a24b-53b7cd12a524', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '46e6086e-090e-4c74-9798-07600cdc9aa4', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (2 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('a6037bc8-9cc3-434e-b18c-980e0db2d761', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SPORT FEST 2026\"', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 01:49:24', 0),
('a634c97e-262d-46c8-b62e-a36d0945c973', NULL, '1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'adsa — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:07:14', 0),
('a9d2a91e-b136-4203-bdc1-13bb0b224fbd', NULL, NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 03:18:50', 0),
('ac2cb058-56b8-4056-a083-da9d5481af23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd6c01bae-4c4e-4626-bbed-9f145155bc24', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"Tech Innovation Summit 2026\" and 1 related ledger entry', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:18:25', 0),
('adabad65-674e-479f-ad81-424d3cf546cd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 13:20:43', 0),
('af378725-73ce-4998-897a-23ea67b4c17a', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2804cc1f-55c4-4be6-9d30-bda126f19766', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sample 6\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:49:04', 0),
('af7178b3-34b0-4c50-a815-97eef337a5b6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'a63da296-8a8f-43c6-a150-e11eb425c12a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:10:36', 0),
('af7c82e1-3492-4a13-8cd4-78c9981a96ac', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"HACKATON 2026 (sample 3)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:20:41', 0),
('b0846c5e-99bb-4879-9a00-365611bd8684', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '90f61bee-2f51-4194-97af-fc3ea4357d57', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 04:02:24', 0),
('b096e636-1343-4666-8219-b41675bc8aee', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"Tech Innovation Summit 2026\"', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:19:59', 0),
('bb6c77f5-7ec8-4bed-982b-d0adf606ab9b', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'test — KLD FOUNDATION WEEK 2025 (sample1)', '175.158.217.73', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 02:05:56', 0),
('bed92588-ae56-44ac-9c11-9d43a412f550', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '11047d70-5665-4c11-ae0a-a9d367ccdf8c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-19 10:14:01', 0),
('bf7cf06a-9b38-441b-a242-538799140463', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'ledger', 'alert', 'Warning', 'budget_mismatch:123:23', NULL, NULL, '2026-09-26 10:49:03', 0),
('c8bb8e46-61dd-4b67-85d4-d89ad6813717', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '03e59f8a-19df-41ee-8cd9-2413ed3eea80', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"TEST PROJECT\"', '123.253.51.170', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Mobile Safari/537.36', '2026-09-26 16:40:36', 0),
('c9053d69-03e6-41a3-b620-56a815d4a20e', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: SAMPLE 7 — ahscgajsgbc', '175.158.217.73', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 02:02:58', 0),
('d855afed-b358-4f47-8682-74e015112b57', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '76de8fab-03a1-49a0-9a59-a796b83ca94c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:18:07', 0),
('d8a6bc9f-da93-4663-b4a8-2aa12a277443', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:09:58', 0),
('d9a2891b-54e8-4a72-baff-e58b8390ed2d', NULL, '4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'The following materials is the list of canvas materials — too expensive', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:57', 0),
('da4324cf-191a-4fbe-9ad0-813d1c269fe9', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4c80:372c:c00b:9ad3:f5b9:a742', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 02:35:02', 0),
('db8b96ea-b8f5-4e7e-8839-3ca42b8f5e6c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:06:54', 0),
('dbb98611-ad88-4adf-a81b-7d278e2196b2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '533308f1-dcba-4a77-9a1e-d454ef42fe73', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"SportFest 2026 - Event Planning Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:18:00', 0),
('dbca3475-e2f8-42cf-adc6-acc38fb4c2dd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Marked Completed', 'meetings', 'update', 'Success', 'Marked meeting as completed \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:47', 0),
('ddeb8aee-f801-404a-a6e6-098a6aad7943', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:1:4723', NULL, NULL, '2026-09-23 02:04:06', 0),
('e295363a-2fd8-4b68-b68c-534ff38cd214', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '11047d70-5665-4c11-ae0a-a9d367ccdf8c', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Sample\" for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-19 10:14:16', 0),
('e46bfdd1-3548-4caa-baa2-69c802e45200', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'e9f4fe95-4551-4536-8241-223f7111b422', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 04:01:34', 0),
('effb0bf1-f48b-45f1-bf17-17d91e496202', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '428555bf-e5c1-4a55-85aa-8565bd218efd', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"Anti-Bullying Awareness 2026\"', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-27 04:48:23', 0),
('f0cf8c4b-4c63-4665-a58c-d496e2557a92', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 'ledger_entry', 'Ledger Entry Approved', 'ledger', 'approve', NULL, 'We will buy item that can be use for the future events — Tech Innovation Summit 2026', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 10:58:23', 0),
('fbc2bf00-8d84-4077-aa27-35c156cc8e96', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '65f4072c-fca0-4a53-a99e-d7a2b8af29bf', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 11:55:35', 0),
('fe1b697a-2274-42f3-ad98-b951740a6a56', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'deed10ed-dd6c-4ec5-bad6-d22eaa981632', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 14:32:54', 0),
('fe25c8b3-4990-467e-86f6-95d86796343c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'b984c09c-a66d-4e34-9489-4d75222b8188', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"sample\" and 1 related ledger entry', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-26 08:18:21', 0);

--
-- Triggers `audit_logs`
--
DELIMITER $$
CREATE TRIGGER `audit_logs_prevent_delete` BEFORE DELETE ON `audit_logs` FOR EACH ROW SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Audit logs are immutable and cannot be deleted'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_logs_prevent_update` BEFORE UPDATE ON `audit_logs` FOR EACH ROW SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Audit logs are immutable and cannot be updated'
$$
DELIMITER ;

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('step-platform-demo-cache-0f6270495d27e97a6e25412116940ff20d4d30a5', 'i:2;', 1790482352),
('step-platform-demo-cache-0f6270495d27e97a6e25412116940ff20d4d30a5:timer', 'i:1790482352;', 1790482352),
('step-platform-demo-cache-24e6ac0b751e3f508e80fa5d4ad1b146103a029c', 'i:1;', 1790491429),
('step-platform-demo-cache-24e6ac0b751e3f508e80fa5d4ad1b146103a029c:timer', 'i:1790491429;', 1790491429),
('step-platform-demo-cache-87484a900536cd9c2476cddf48b7e819fedbb799', 'i:1;', 1790489231),
('step-platform-demo-cache-87484a900536cd9c2476cddf48b7e819fedbb799:timer', 'i:1790489231;', 1790489231),
('step-platform-demo-cache-c67c1239939431c3e95a2e6c76ecf64cea843c07', 'i:4;', 1790483863),
('step-platform-demo-cache-c67c1239939431c3e95a2e6c76ecf64cea843c07:timer', 'i:1790483863;', 1790483863),
('step-platform-demo-cache-c9797c514aaf151122667725fac9d41a2f994db7', 'i:1;', 1790486294),
('step-platform-demo-cache-c9797c514aaf151122667725fac9d41a2f994db7:timer', 'i:1790486294;', 1790486294),
('step-platform-demo-cache-d28c12cdba3d48006294e2c48648170b1589dac7', 'i:1;', 1790407372),
('step-platform-demo-cache-d28c12cdba3d48006294e2c48648170b1589dac7:timer', 'i:1790407372;', 1790407372),
('step-platform-demo-cache-d47044f2848aab5834610bf348a4bb482a27b62d', 'i:1;', 1790439318),
('step-platform-demo-cache-d47044f2848aab5834610bf348a4bb482a27b62d:timer', 'i:1790439318;', 1790439318),
('step-platform-demo-cache-f1304a4116526b3fdaa5f8a81e859dc3a7f6a4ec', 'i:2;', 1790483959),
('step-platform-demo-cache-f1304a4116526b3fdaa5f8a81e859dc3a7f6a4ec:timer', 'i:1790483959;', 1790483959);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
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
('25900655-0c6f-4d3f-a275-ac6023ab301b', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 0, NULL, '1f2632ee27d07a6f77a5b655494ac8136011762646a4cf11f260a3301da9647e', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"d087b77d-8451-48fb-9ae9-f07e26aa9232\\\",\\\"title\\\":\\\"Tech Innovation Summit 2026\\\",\\\"description\\\":\\\"The primary objective of the Tech Innovation Summit 2026 is to expose students to current industry practices and emerging technologies that are not always covered within the standard academic curriculum, thereby enriching their understanding of what awaits them in the professional world.\\\",\\\"amount\\\":\\\"4700.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-26T08:39:18+00:00\\\"}\"', '2026-09-26 08:39:18'),
('68b3c240-eedd-46b2-9858-2d76fdee0685', '58f38625-3132-485e-a8a6-308436e56bf2', 3, '15be417d6d454e391aa81384f7e6fd6ec93a3038ac4d5fd6f0293ba08daae3a7', '419ed25c92438b9b34d46cee54c8d52d2dee3540d4a27b6d532d81428b7a9e3a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"6f6f7039-e6c3-4f82-9abf-5027970a4232\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"John Doe\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"500\\\\\\\",\\\\\\\"amount\\\\\\\":500}]\\\",\\\"amount\\\":\\\"500.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:11:38+00:00\\\",\\\"snapshot_nonce\\\":\\\"f91e96dc9ed0e1f9\\\"}\"', '2026-09-19 08:11:38'),
('75726d30-4175-4abf-a07c-10e48a9ee3f5', '58f38625-3132-485e-a8a6-308436e56bf2', 1, '25c0dce7a3b5a6312b86de5f07b69a3d24b040b777799eac1ee371ec8717bc99', '5174ea925c1e76feaaa8db189556e10a6e36cf3c260798cf84614fecdb2dbb29', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"75b8ee1d-b6bb-4dac-8f49-68cdbab157c5\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"5000.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:02:40+00:00\\\",\\\"snapshot_nonce\\\":\\\"028e3d4c5c408e2b\\\"}\"', '2026-09-19 08:02:40'),
('79289a1a-42e2-4def-a7a2-a5c529aa7bda', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 1, '1f2632ee27d07a6f77a5b655494ac8136011762646a4cf11f260a3301da9647e', '3734c86256edffe7ebf2b036d564b2ef08599f34fd9fe989bd2ba6a6cc0d4c03', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"8c0ea63a-6f9c-4315-9806-ee9448ad780b\\\",\\\"project_id\\\":\\\"d087b77d-8451-48fb-9ae9-f07e26aa9232\\\",\\\"description\\\":\\\"Transferred from completed project \\\\\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\\\\\" to project \\\\\\\"Tech Innovation Summit 2026\\\\\\\"\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"source\\\\\\\":\\\\\\\"Transfer\\\\\\\",\\\\\\\"name\\\\\\\":\\\\\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\\\\\",\\\\\\\"amount\\\\\\\":4700}]\\\",\\\"amount\\\":\\\"4700.00\\\",\\\"entry_type\\\":\\\"Initial Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-26T08:39:18+00:00\\\",\\\"snapshot_nonce\\\":\\\"afe617efcdcff453\\\"}\"', '2026-09-26 08:39:18'),
('871289ba-6911-4ff7-b49d-57fa4c0737ed', '58f38625-3132-485e-a8a6-308436e56bf2', 5, 'cda59b1b5599c83f4717808ecbb4d91296338bde72fc50d157af04c05d79d8f5', 'd291331222c0a276f89b0cfab6a2d718242ce06ec0d63bb610a0bbd5c4f56a31', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"63e0a0f6-f833-49bb-8bcb-ce78f564fbc7\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"Transferred to project \\\\\\\"SPORT FEST 2026\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-23T01:52:15+00:00\\\",\\\"snapshot_nonce\\\":\\\"2f47ed415d871294\\\"}\"', '2026-09-23 01:52:15'),
('99bcd241-36cf-4662-bef9-d156a4243962', '58f38625-3132-485e-a8a6-308436e56bf2', 0, NULL, '25c0dce7a3b5a6312b86de5f07b69a3d24b040b777799eac1ee371ec8717bc99', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"title\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"description\\\":\\\"KLD Foundation Week 2025 marks the 5th founding anniversary celebration of Kolehiyo ng Lungsod ng Dasmari\\\\u00f1as. The celebration, themed \\\\\\\"Lima\'t Laya,\\\\\\\" commemorates five years of the institution\'s commitment to accessible education and community development in Dasmari\\\\u00f1as. The project has the currecnt budget of 5,000 php.\\\",\\\"amount\\\":\\\"5000.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:02:40+00:00\\\"}\"', '2026-09-19 08:02:40'),
('9ed2ac02-5a79-4caf-a67d-5147a5ae7540', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 2, '3734c86256edffe7ebf2b036d564b2ef08599f34fd9fe989bd2ba6a6cc0d4c03', 'ef5a0f4ad1ecc7dcb39f3f9f66984d79ccf2da8876e87887c22e821a8b504ede', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8\\\",\\\"project_id\\\":\\\"d087b77d-8451-48fb-9ae9-f07e26aa9232\\\",\\\"description\\\":\\\"We will buy item that can be use for the future events\\\",\\\"budget_breakdown\\\":[{\\\"id\\\":1,\\\"item\\\":\\\"Chairs\\\",\\\"qty\\\":10,\\\"asset_category\\\":\\\"Furniture\\\",\\\"unitPrice\\\":10,\\\"amount\\\":100,\\\"asset_mode\\\":\\\"purchase\\\"},{\\\"id\\\":2,\\\"item\\\":\\\"Tables\\\",\\\"qty\\\":1,\\\"asset_category\\\":\\\"Furniture\\\",\\\"unitPrice\\\":100,\\\"amount\\\":100,\\\"asset_mode\\\":\\\"purchase\\\"}],\\\"amount\\\":\\\"200.00\\\",\\\"entry_type\\\":\\\"Asset\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-26T10:58:23+00:00\\\",\\\"snapshot_nonce\\\":\\\"7dc88c5e7fafb6ab\\\"}\"', '2026-09-26 10:58:23'),
('a5d6af2e-3452-430c-978a-61688cf026bd', '58f38625-3132-485e-a8a6-308436e56bf2', 2, '5174ea925c1e76feaaa8db189556e10a6e36cf3c260798cf84614fecdb2dbb29', '15be417d6d454e391aa81384f7e6fd6ec93a3038ac4d5fd6f0293ba08daae3a7', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"62946d3c-8596-4ca5-9927-21b63d1965bd\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"This is the list of materials that we are buying for the event.\\\\r\\\\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below.\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"chair\\\\\\\",\\\\\\\"qty\\\\\\\":\\\\\\\"50\\\\\\\",\\\\\\\"unitPrice\\\\\\\":\\\\\\\"5\\\\\\\",\\\\\\\"amount\\\\\\\":250},{\\\\\\\"id\\\\\\\":2,\\\\\\\"item\\\\\\\":\\\\\\\"balloons\\\\\\\",\\\\\\\"quantity\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"5\\\\\\\",\\\\\\\"amount\\\\\\\":250,\\\\\\\"qty\\\\\\\":\\\\\\\"50\\\\\\\"},{\\\\\\\"id\\\\\\\":3,\\\\\\\"item\\\\\\\":\\\\\\\"microphones\\\\\\\",\\\\\\\"quantity\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":300,\\\\\\\"qty\\\\\\\":\\\\\\\"3\\\\\\\"}]\\\",\\\"amount\\\":\\\"800.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:11:21+00:00\\\",\\\"snapshot_nonce\\\":\\\"468be75993dbb664\\\"}\"', '2026-09-19 08:11:21'),
('a8db28b8-9d43-440c-b361-707ec9b1469b', '58f38625-3132-485e-a8a6-308436e56bf2', 4, '419ed25c92438b9b34d46cee54c8d52d2dee3540d4a27b6d532d81428b7a9e3a', 'cda59b1b5599c83f4717808ecbb4d91296338bde72fc50d157af04c05d79d8f5', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"adsa\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"asfasd\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"amount\\\\\\\":123}]\\\",\\\"amount\\\":\\\"123.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-22T14:07:14+00:00\\\",\\\"snapshot_nonce\\\":\\\"d3dd2bd59db8007f\\\"}\"', '2026-09-22 14:07:14'),
('c2048526-7f39-4aa8-a74c-fe06517d5c64', '58f38625-3132-485e-a8a6-308436e56bf2', 7, '6c66e69dc4fc7e1ce69d088b6e75526a3edf1b990c4fbdfd5a1e9343ad3d02b8', 'e81235f1d025a0ad44e59550f87653b3dde8ac7b45fd3aa5ccff2f6850561036', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"86f4eb8e-5b52-4b62-8294-833a4e8779c6\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"Transferred to project \\\\\\\"Tech Innovation Summit 2026\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"4700.00\\\",\\\"entry_type\\\":\\\"Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-26T08:39:18+00:00\\\",\\\"snapshot_nonce\\\":\\\"a0aa1fc3347f9925\\\"}\"', '2026-09-26 08:39:18'),
('d998b07a-cf9f-4241-9c5c-f8849364bb4c', '58f38625-3132-485e-a8a6-308436e56bf2', 6, 'd291331222c0a276f89b0cfab6a2d718242ce06ec0d63bb610a0bbd5c4f56a31', '6c66e69dc4fc7e1ce69d088b6e75526a3edf1b990c4fbdfd5a1e9343ad3d02b8', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"2229be95-ea51-4ca6-8a55-cfb14218b8e7\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"test\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"test\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"amount\\\\\\\":123}]\\\",\\\"amount\\\":\\\"123.00\\\",\\\"entry_type\\\":\\\"Canvas\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-24T02:05:56+00:00\\\",\\\"snapshot_nonce\\\":\\\"39232782a3c12f79\\\"}\"', '2026-09-24 02:05:56');

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
  `favorite` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `concern`
--

INSERT INTO `concern` (`id`, `user_id`, `concern`, `favorite`, `created_at`) VALUES
('79866110-06a7-4820-80a7-c90eb4a2afbf', NULL, 'Hello test', 1, '2026-09-19 08:36:26'),
('a153dbf6-1466-4c5a-87d6-af5e3ae590ab', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'I like the event but I have a small concer about....', 0, '2026-09-19 08:36:13'),
('f88ec8bb-40d8-4943-9517-b09bd5b48840', NULL, 'HELLO OO', 0, '2026-09-22 06:28:31');

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` char(36) NOT NULL,
  `institute_id` char(36) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `course`
--

INSERT INTO `course` (`id`, `institute_id`, `name`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('093e25fc-5f35-4f75-9a1c-096da57acc5e', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSM', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('19719e81-53c4-44d1-bbd3-927880ef12cd', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSPSY', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('5b28cedf-abc5-4f97-a719-980bbcd1a9f5', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSCE', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('6fa069d5-b9f1-439d-8b9f-522549aafb6a', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSCS', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('80a61798-080f-4ae5-993e-3ee976155cf9', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSocSc', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a7aab4e8-0f1f-4f62-96cf-78a219b925da', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSN', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('e133d759-1965-4cc4-b0ec-4890329e4edf', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'BSIS', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0);

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

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `institute`
--

INSERT INTO `institute` (`id`, `name`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('108f0503-2f5d-42af-91ac-25cb106c7780', 'IE', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 'ICDI', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('201f624b-2f59-4b95-9f93-b92d617fccac', 'CCJ', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('3bed98dd-a394-4eb3-b76e-eaf54deefd81', 'IM', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('c73f4bee-c53d-477f-b2f4-7d42280764fc', 'ISM', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('cb38c894-6507-44b7-8363-b7f1641da9c7', 'IFS', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('f4728bb1-154f-40c6-be2a-8e9804b57da2', 'IBS', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('ff598575-504d-4d1b-967c-f20faaf1377c', 'IGDS', NULL, '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ledger_entries`
--

CREATE TABLE `ledger_entries` (
  `id` char(36) NOT NULL,
  `project_id` char(36) NOT NULL,
  `type` enum('Income','Expense','Asset','Canvas','Donation','Sponsorship','Initial','Transfer','Initial Transfer') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `description` text NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `budget_breakdown` text DEFAULT NULL,
  `ledger_proof` varchar(500) DEFAULT NULL COMMENT 'Path to uploaded proof file',
  `file_content_hash` varchar(64) DEFAULT NULL,
  `approval_status` enum('Draft','Pending Adviser Approval','Approved','Rejected') NOT NULL DEFAULT 'Draft',
  `is_initial_entry` tinyint(1) NOT NULL DEFAULT 0,
  `note` text DEFAULT NULL COMMENT 'Approval/rejection notes',
  `approved_by` char(36) DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ledger_proof_original_name` char(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ledger_entries`
--

INSERT INTO `ledger_entries` (`id`, `project_id`, `type`, `amount`, `description`, `category`, `budget_breakdown`, `ledger_proof`, `file_content_hash`, `approval_status`, `is_initial_entry`, `note`, `approved_by`, `created_by`, `updated_by`, `approved_at`, `rejected_at`, `archive`, `created_at`, `updated_at`, `ledger_proof_original_name`) VALUES
('0657d359-fd24-4cb5-82d7-d64e8b90fffc', '03e59f8a-19df-41ee-8cd9-2413ed3eea80', 'Initial', 1010.00, 'Sponsorship came from:\n- Jani - ₱1,000.00\nDonation came from:\n- Ed - ₱10.00', 'Project Budget Baseline', '\"[{\\\"source\\\":\\\"Sponsorship\\\",\\\"name\\\":\\\"Jani\\\",\\\"amount\\\":1000},{\\\"source\\\":\\\"Donation\\\",\\\"name\\\":\\\"Ed\\\",\\\"amount\\\":10}]\"', 'ledger_proofs/e25b9092d02135a696b758a4163ab04b55bb21974aebb37fb8dd480ead99de33.jpg', 'e25b9092d02135a696b758a4163ab04b55bb21974aebb37fb8dd480ead99de33', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-26 16:40:36', '2026-09-26 16:41:01', 'Screenshot_20260926_222239.jpg'),
('0c69aba4-5eb1-4a31-9aff-37b40d8fae78', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 23.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:48:23', '2026-09-27 04:48:47', 'receipt.png'),
('11e922ce-6b14-4ae7-a617-1cfa73693f32', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Transfer', 3977.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, NULL, NULL, 'Pending Adviser Approval', 0, '{\"transfer_source_project_id\":\"d087b77d-8451-48fb-9ae9-f07e26aa9232\",\"transfer_source_project_title\":\"Tech Innovation Summit 2026\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-27 05:48:30', '2026-09-27 05:49:12', NULL),
('183a3b34-c93d-41db-9c76-573a48107333', 'd6c01bae-4c4e-4626-bbed-9f145155bc24', 'Initial', 800.00, 'Sponsorship came from:\n- JANI — ₱300.00\nDonation came from:\n- LAWRENCE — ₱500.00', 'Project Budget Baseline', '\"[{\\\"source\\\":\\\"Sponsorship\\\",\\\"name\\\":\\\"JANI\\\",\\\"amount\\\":300},{\\\"source\\\":\\\"Donation\\\",\\\"name\\\":\\\"LAWRENCE\\\",\\\"amount\\\":500}]\"', NULL, NULL, 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-26 07:55:58', '2026-09-26 08:18:25', 'sample_proof.png'),
('1b3b1895-e509-4d24-a9ba-6062f6a13b1e', '428555bf-e5c1-4a55-85aa-8565bd218efd', 'Initial Transfer', 21.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Anti-Bullying Awareness 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":21}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Anti-Bullying Awareness 2026\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:56:16', '2026-09-27 05:48:30', 'receipt.png'),
('1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 123.00, 'adsa', NULL, '\"[{\\\"item\\\":\\\"asfasd\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Approved', 0, 'safsd', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-22 14:07:14', NULL, 0, '2026-09-22 14:06:54', '2026-09-22 14:07:14', 'sample_proof.png'),
('21010ad4-4bf5-4110-bac2-60f42e20c158', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 21.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, NULL, NULL, 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:56:16', '2026-09-27 05:48:30', NULL),
('2229be95-ea51-4ca6-8a55-cfb14218b8e7', '58f38625-3132-485e-a8a6-308436e56bf2', 'Canvas', 123.00, 'test', NULL, '\"[{\\\"item\\\":\\\"test\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'vhfjhfv', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', '2026-09-24 02:05:56', NULL, 0, '2026-09-22 13:20:43', '2026-09-24 02:05:56', 'sample_proof.png'),
('27d046dc-05f7-4cb0-9ddf-3bfe03682d4a', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 23.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:16:01', '2026-09-27 04:16:02', 'receipt.png'),
('31a06c0b-7fdc-4f49-99a3-1d0d6138e746', '7f34c673-3de7-4386-9191-135ad6ea2666', 'Initial Transfer', 1000.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:30:36', '2026-09-19 08:30:48', 'sample_proof.png'),
('46e6086e-090e-4c74-9798-07600cdc9aa4', '58f38625-3132-485e-a8a6-308436e56bf2', 'Expense', 2750.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Venue rental\\\",\\\"qty\\\":1,\\\"unitPrice\\\":1500,\\\"amount\\\":1500},{\\\"id\\\":2,\\\"item\\\":\\\"Snacks\\\",\\\"qty\\\":50,\\\"unitPrice\\\":25,\\\"amount\\\":1250}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-19 08:32:56', '2026-09-19 08:32:56', 'sample_proof.png'),
('4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', '58f38625-3132-485e-a8a6-308436e56bf2', 'Canvas', 3060.00, 'The following materials is the list of canvas materials', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"tables\\\",\\\"qty\\\":\\\"3\\\",\\\"unitPrice\\\":\\\"20\\\",\\\"amount\\\":60},{\\\"id\\\":2,\\\"item\\\":\\\"food\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"30\\\",\\\"amount\\\":3000,\\\"qty\\\":\\\"100\\\"}]\"', 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Rejected', 0, 'too expensive', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, '2026-09-19 08:11:57', 0, '2026-09-19 08:09:58', '2026-09-22 11:37:15', 'sample_proof.png'),
('50fdea94-b85c-4a69-8adf-26e776246d6e', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Transfer', 4477.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"d087b77d-8451-48fb-9ae9-f07e26aa9232\",\"transfer_source_project_title\":\"Tech Innovation Summit 2026\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:48:23', '2026-09-27 04:48:47', 'receipt.png'),
('62946d3c-8596-4ca5-9927-21b63d1965bd', '58f38625-3132-485e-a8a6-308436e56bf2', 'Expense', 800.00, 'This is the list of materials that we are buying for the event.\r\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below.', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"chair\\\",\\\"qty\\\":\\\"50\\\",\\\"unitPrice\\\":\\\"5\\\",\\\"amount\\\":250},{\\\"id\\\":2,\\\"item\\\":\\\"balloons\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"5\\\",\\\"amount\\\":250,\\\"qty\\\":\\\"50\\\"},{\\\"id\\\":3,\\\"item\\\":\\\"microphones\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":300,\\\"qty\\\":\\\"3\\\"}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'gow', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:11:21', NULL, 0, '2026-09-19 08:06:41', '2026-09-19 08:11:21', 'sample_proof.png'),
('63e0a0f6-f833-49bb-8bcb-ce78f564fbc7', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 100.00, 'Transferred to project \"SPORT FEST 2026\"', 'Transfer', NULL, 'ledger_proofs/ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c.png', 'ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c', 'Approved', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"f4d91e54-e7bf-4606-ac18-5fed0125f690\",\"transfer_destination_project_title\":\"SPORT FEST 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-23 01:52:15', NULL, 0, '2026-09-23 01:49:24', '2026-09-23 01:52:15', 'sample_proof.png'),
('6b058e99-109b-413a-9d33-64314f658821', '58f38625-3132-485e-a8a6-308436e56bf2', 'Donation', 1000.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Alumni contribution\\\",\\\"qty\\\":1,\\\"unitPrice\\\":1000,\\\"amount\\\":1000}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-19 08:32:56', '2026-09-19 08:32:56', 'sample_proof.png'),
('6f6f7039-e6c3-4f82-9abf-5027970a4232', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 500.00, 'During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"John Doe\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"500\\\",\\\"amount\\\":500}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'alright!', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:11:38', NULL, 0, '2026-09-19 08:08:37', '2026-09-19 08:11:38', 'sample_proof.png'),
('6fd8ac00-6021-4e4d-a6b6-ed2d6164d8b4', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 1000.00, 'Transferred to project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"7f34c673-3de7-4386-9191-135ad6ea2666\",\"transfer_destination_project_title\":\"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:30:36', '2026-09-19 08:30:48', 'sample_proof.png'),
('75b8ee1d-b6bb-4dac-8f49-68cdbab157c5', '58f38625-3132-485e-a8a6-308436e56bf2', 'Initial', 5000.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:02:40', NULL, 0, '2026-09-19 07:55:00', '2026-09-19 08:02:40', 'sample_proof.png'),
('76de8fab-03a1-49a0-9a59-a796b83ca94c', '58f38625-3132-485e-a8a6-308436e56bf2', 'Expense', 100.00, 'TEST', NULL, '\"[{\\\"item\\\":\\\"TEST\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'ledger_proofs/e2bd9d72a2cfe33ff155a755e21eed3e50c6b2611ac323366e8b9e09d8720292.png', 'e2bd9d72a2cfe33ff155a755e21eed3e50c6b2611ac323366e8b9e09d8720292', 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 1, '2026-09-26 08:18:07', '2026-09-26 08:18:16', 'csg_logo.png'),
('7be7f264-1528-479d-a5ef-03f7a5612fcc', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Transfer', 977.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"d087b77d-8451-48fb-9ae9-f07e26aa9232\",\"transfer_source_project_title\":\"Tech Innovation Summit 2026\",\"transfer_destination_project_id\":\"f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:16:01', '2026-09-27 04:16:02', 'receipt.png'),
('802fbfdb-6639-4949-af5e-7b83d2cf9d2b', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Asset', 1000.00, 'Test asset - dont approve', NULL, '[{\"item\":\"Speakers\",\"qty\":1,\"unitPrice\":\"1000\",\"amount\":1000,\"asset_category\":\"Other\",\"asset_mode\":\"purchase\",\"id\":1}]', 'ledger_proofs/e25b9092d02135a696b758a4163ab04b55bb21974aebb37fb8dd480ead99de33.jpg', 'e25b9092d02135a696b758a4163ab04b55bb21974aebb37fb8dd480ead99de33', 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-26 16:42:15', '2026-09-26 16:42:38', 'Screenshot_20260926_222239.jpg'),
('832044f6-c5f2-4c4c-9dc8-a13b24eb28ce', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Initial', 500.00, 'Sponsorship came from:\n- jani — ₱100.00\nDonation came from:\n- lawrence — ₱400.00', 'Project Budget Baseline', '\"[{\\\"source\\\":\\\"Sponsorship\\\",\\\"name\\\":\\\"jani\\\",\\\"amount\\\":100},{\\\"source\\\":\\\"Donation\\\",\\\"name\\\":\\\"lawrence\\\",\\\"amount\\\":400}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-26 08:19:59', '2026-09-26 08:21:38', 'receipt.png'),
('86f4eb8e-5b52-4b62-8294-833a4e8779c6', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 4700.00, 'Transferred to project \"Tech Innovation Summit 2026\"', 'Transfer', NULL, NULL, NULL, 'Approved', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"d087b77d-8451-48fb-9ae9-f07e26aa9232\",\"transfer_destination_project_title\":\"Tech Innovation Summit 2026\"}', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-26 08:39:18', NULL, 0, '2026-09-26 08:21:38', '2026-09-26 08:39:18', 'sample_proof.png'),
('8c0ea63a-6f9c-4315-9806-ee9448ad780b', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Initial Transfer', 4700.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Tech Innovation Summit 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":4700}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Tech Innovation Summit 2026\"', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-26 08:39:18', NULL, 0, '2026-09-26 08:21:38', '2026-09-26 08:39:18', 'receipt.png'),
('8c50c684-2105-483a-8229-09f59ac9887d', '428555bf-e5c1-4a55-85aa-8565bd218efd', 'Initial Transfer', 20.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Anti-Bullying Awareness 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":20}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"Anti-Bullying Awareness 2026\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:48:47', '2026-09-27 04:56:16', 'receipt.png'),
('8d467bca-dff4-4f6b-90f4-e1818673f3c6', '98cf7626-6bff-4cbb-9cc3-43884ece691f', 'Initial Transfer', 700.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"BAKOD KO LINIS KO (sample 4)\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:28:25', '2026-09-19 08:28:26', 'sample_proof.png'),
('a499b62e-3f81-4112-871e-a71e7ba94bd1', '428555bf-e5c1-4a55-85aa-8565bd218efd', 'Initial Transfer', 4000.00, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱3,977.00) to project \"Anti-Bullying Awareness 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":23},{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"Tech Innovation Summit 2026\\\",\\\"amount\\\":3977}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱3,977.00) to project \"Anti-Bullying Awareness 2026\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-27 05:48:30', '2026-09-27 05:49:12', 'receipt.png'),
('a63da296-8a8f-43c6-a150-e11eb425c12a', '58f38625-3132-485e-a8a6-308436e56bf2', 'Asset', 1000.00, 'We will buy a materials that can be use as asset in the future', NULL, '[{\"item\":\"chair\",\"qty\":\"10\",\"unitPrice\":\"100\",\"amount\":1000,\"asset_category\":\"Other\",\"asset_mode\":\"purchase\"}]', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 1, '2026-09-26 10:10:36', '2026-09-26 10:56:28', 'receipt.png'),
('abfe2481-d2a6-4a0e-8077-6c5eb60be2d9', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 700.00, 'Transferred to project \"BAKOD KO LINIS KO (sample 4)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"98cf7626-6bff-4cbb-9cc3-43884ece691f\",\"transfer_destination_project_title\":\"BAKOD KO LINIS KO (sample 4)\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:28:25', '2026-09-19 08:28:26', 'sample_proof.png'),
('b13724a4-416b-4786-b6c4-df62df87bdb1', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 23.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, NULL, NULL, 'Pending Adviser Approval', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-27 05:48:30', '2026-09-27 05:49:12', NULL),
('c51ccd9c-8f14-48c2-b97b-8fb39bc1842d', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 20.00, 'Transferred to project \"Anti-Bullying Awareness 2026\"', 'Transfer', NULL, NULL, NULL, 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"428555bf-e5c1-4a55-85aa-8565bd218efd\",\"transfer_destination_project_title\":\"Anti-Bullying Awareness 2026\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:48:47', '2026-09-27 04:56:16', NULL),
('d536d12c-b68b-4bbe-b278-0958be2f5686', 'f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe', 'Initial Transfer', 1000.00, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱977.00) to project \"Anti-Bullying Awareness 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":23},{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"Tech Innovation Summit 2026\\\",\\\"amount\\\":977}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱977.00) to project \"Anti-Bullying Awareness 2026\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:16:01', '2026-09-27 04:19:51', 'receipt.png'),
('db403730-fb41-47bc-a2e3-78245d425ff0', '58f38625-3132-485e-a8a6-308436e56bf2', 'Income', 200.00, 'We will buy a materials that can be use as asset in the future', NULL, '\"[{\\\"item\\\":\\\"Chairs\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100,\\\"asset_category\\\":\\\"Other\\\",\\\"id\\\":1},{\\\"item\\\":\\\"Laptop\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100,\\\"asset_category\\\":\\\"Other\\\",\\\"id\\\":2}]\"', 'ledger_proofs/e2bd9d72a2cfe33ff155a755e21eed3e50c6b2611ac323366e8b9e09d8720292.png', 'e2bd9d72a2cfe33ff155a755e21eed3e50c6b2611ac323366e8b9e09d8720292', 'Pending Adviser Approval', 0, 'Check the proof', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-26 08:42:04', 0, '2026-09-26 08:38:05', '2026-09-26 10:10:05', 'csg_logo.png'),
('deed10ed-dd6c-4ec5-bad6-d22eaa981632', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 500.00, 'Lawrence Calibuso sponsor 500 php', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Lawrence Calibuso sponsor 500 php\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"500\\\",\\\"amount\\\":500}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-20 14:32:54', '2026-09-20 14:33:01', 'sample_proof.png'),
('e1be99a0-24ed-4ccb-b1eb-dfc34db7fcb8', 'd087b77d-8451-48fb-9ae9-f07e26aa9232', 'Asset', 200.00, 'We will buy item that can be use for the future events', NULL, '[{\"id\":1,\"item\":\"Chairs\",\"qty\":10,\"asset_category\":\"Furniture\",\"unitPrice\":10,\"amount\":100,\"asset_mode\":\"purchase\"},{\"id\":2,\"item\":\"Tables\",\"qty\":1,\"asset_category\":\"Furniture\",\"unitPrice\":100,\"amount\":100,\"asset_mode\":\"purchase\"}]', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'Good', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-26 10:58:23', NULL, 0, '2026-09-26 10:57:59', '2026-09-26 10:58:23', 'receipt.png'),
('e6926cfc-094f-4795-aeca-ae17a3b08357', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Rejected', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', NULL, '2026-09-24 02:02:58', 1, '2026-09-19 10:58:52', '2026-09-26 07:53:44', 'sample_proof.png'),
('eabd7350-2a2b-447f-a0b7-e6fcde83f17e', '1ee4d579-9b41-468a-a691-b86ad5735c04', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:18:34', '2026-09-19 08:18:35', 'sample_proof.png'),
('f0af82f1-c1c7-4fba-95b6-b72e4bcf39b9', '428555bf-e5c1-4a55-85aa-8565bd218efd', 'Initial Transfer', 4500.00, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱4,477.00) to project \"Anti-Bullying Awareness 2026\"', 'Transfer', '\"[{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"amount\\\":23},{\\\"source\\\":\\\"Transfer\\\",\\\"name\\\":\\\"Tech Innovation Summit 2026\\\",\\\"amount\\\":4477}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed projects: KLD FOUNDATION WEEK 2025 (sample1) (₱23.00), Tech Innovation Summit 2026 (₱4,477.00) to project \"Anti-Bullying Awareness 2026\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-27 04:48:23', '2026-09-27 04:48:47', 'receipt.png'),
('fdc79177-c941-45a7-9c29-666a64c85e36', '58f38625-3132-485e-a8a6-308436e56bf2', 'Income', 2500.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Registration fees\\\",\\\"qty\\\":1,\\\"unitPrice\\\":2500,\\\"amount\\\":2500}]\"', NULL, NULL, 'Pending Adviser Approval', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-19 08:32:56', '2026-09-19 08:33:14', 'sample_proof.png'),
('fdfc27fe-7994-48c4-ab26-780f9baa1837', 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Rejected', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, '2026-09-19 08:21:12', 0, '2026-09-19 08:20:41', '2026-09-19 08:21:12', NULL),
('fefc536a-77a9-4d6f-a733-a1fa889dea87', 'b984c09c-a66d-4e34-9489-4d75222b8188', 'Initial', 2.00, 'Sponsorship came from:\n- sample — ₱1.00\nDonation came from:\n- sample — ₱1.00', 'Project Budget Baseline', '\"[{\\\"source\\\":\\\"Sponsorship\\\",\\\"name\\\":\\\"sample\\\",\\\"amount\\\":1},{\\\"source\\\":\\\"Donation\\\",\\\"name\\\":\\\"sample\\\",\\\"amount\\\":1}]\"', NULL, NULL, 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-26 07:57:38', '2026-09-26 08:18:21', NULL);

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
  `is_done` tinyint(1) NOT NULL DEFAULT 0,
  `minutes_content` text DEFAULT NULL,
  `action_items` text DEFAULT NULL,
  `expected_attendees` text DEFAULT NULL,
  `attendees` text DEFAULT NULL,
  `meeting_proof` varchar(255) DEFAULT NULL,
  `file_content_hash` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `meeting`
--

INSERT INTO `meeting` (`id`, `student_id`, `title`, `description`, `scheduled_date`, `created_at`, `is_done`, `minutes_content`, `action_items`, `expected_attendees`, `attendees`, `meeting_proof`, `file_content_hash`, `updated_at`, `archive`) VALUES
('39e0396a-ff9c-48de-8752-5faa44d59980', NULL, 'Monthly Routine Meeting', 'Monthly routine meeting for council status checking and goal alignment.', '2026-09-16 23:37:00', '2026-09-16 15:38:40', 1, NULL, NULL, '10', '[\"CSG1\"]', 'meeting_proofs/f5bca99b321e807c8e1e97e8f97ea691ca333be1c3cfbb12974dcb6e88ae82b5.pdf', 'f5bca99b321e807c8e1e97e8f97ea691ca333be1c3cfbb12974dcb6e88ae82b5', '2026-09-20 03:16:47', 0),
('533308f1-dcba-4a77-9a1e-d454ef42fe73', NULL, 'SportFest 2026 - Event Planning Meeting', 'Meeting for sportfest 2026', '2026-09-16 23:37:00', '2026-09-20 03:18:00', 0, NULL, NULL, '10', '[\"CSG1\"]', NULL, NULL, '2026-09-20 03:18:00', 0);

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
(1, '2026_04_01_000001_create_institute_table', 1),
(2, '2026_04_01_000002_create_course_table', 1),
(3, '2026_04_01_000003_create_position_table', 1),
(4, '2026_04_01_000004_create_permission_table', 1),
(5, '2026_04_01_000005_create_roles_table', 1),
(6, '2026_04_01_000006_create_users_table', 1),
(7, '2026_04_01_000007_create_teacher_adviser_table', 1),
(8, '2026_04_01_000008_create_student_csg_officers_table', 1),
(9, '2026_04_01_000009_create_role_permission_table', 1),
(10, '2026_04_01_000010_create_projects_table', 1),
(11, '2026_04_01_000011_create_approval_table', 1),
(12, '2026_04_01_000012_create_ledger_entries_table', 1),
(13, '2026_04_01_000013_create_chain_table', 1),
(14, '2026_04_01_000014_create_meeting_table', 1),
(15, '2026_04_01_000015_create_concern_table', 1),
(16, '2026_04_01_000016_create_notifications_table', 1),
(17, '2026_04_01_000017_create_audit_logs_table', 1),
(18, '2026_04_01_000018_create_badge_table', 1),
(19, '2026_04_01_000019_create_badge_collected_table', 1),
(20, '2026_04_01_000020_create_ratings_table', 1),
(21, '2026_04_01_000021_create_reset_password_token_table', 1),
(22, '2026_04_01_000022_create_sessions_table', 1),
(23, '2026_04_09_050446_create_personal_access_tokens_table', 1),
(24, '2026_04_16_000001_create_push_subscriptions_table', 1),
(25, '2026_04_17_000001_create_id_verifications_table', 1),
(26, '2026_04_17_000002_add_id_verification_foreign_key_to_users', 1),
(27, '2026_06_19_create_date_change_requests_table', 1),
(28, '2026_09_06_000002_create_notification_reads_table', 1),
(29, '0001_01_01_000002_create_jobs_table', 2),
(30, '0001_01_01_000001_create_cache_table', 3);

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
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `read_at`, `created_at`, `updated_at`, `archive`) VALUES
('012f0007-83f2-4e3a-b046-2f4dbdc37166', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:09:13', '2026-09-22 14:09:13', 0),
('037fa2dc-058b-4f66-8ae8-651550d60cef', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:07:03', '2026-09-22 14:07:03', 0),
('04351f1a-1a98-413b-a0b3-ceb6749c2507', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:35', '2026-09-19 08:10:35', 0),
('044933fa-d0a0-4dfd-ac4f-ff0073ddcf52', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 08:38:10', '2026-09-26 08:38:10', 0),
('065c16a6-4ab2-40b6-b949-8e36a0754e86', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:33:14', '2026-09-19 08:33:14', 0),
('0eda2eba-c066-405e-8bc0-04c166eefbe2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: Check the proof', 'ledger', 0, NULL, '2026-09-26 08:42:04', '2026-09-26 08:42:04', 0),
('0f264203-2331-48cd-8435-8e71d06415e9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-26 10:51:05', '2026-09-26 10:51:05', 0),
('10fd541d-35d5-4b5d-a7cf-e0484a32355d', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: TEST', 'ledger', 0, NULL, '2026-09-22 14:09:29', '2026-09-22 14:09:29', 0),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', NULL, 'Project Approved', 'Project \"sample 6\" has been approved.', 'project', 0, NULL, '2026-09-19 08:49:44', '2026-09-19 08:49:44', 0),
('152156dc-e5df-4685-85c7-9939611d35d4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"SAMPLE 7\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 10:59:37', '2026-09-19 10:59:37', 0),
('16028c11-c63a-4a57-8c95-b84c0e1a17ae', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 07:56:01', '2026-09-19 07:56:01', 0),
('1bd10896-f5cc-4660-87de-27210df06046', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'Project submitted for approval', 'Project \"Anti-Bullying Awareness 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-27 05:49:12', '2026-09-27 05:49:12', 0),
('1e4e3c93-5c69-44d5-a855-c6f97fcde5a9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-22 14:07:14', '2026-09-22 14:07:14', 0),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 02:50:05', '2026-09-23 02:50:05', 0),
('23aa6fd0-c4bc-4458-9b43-70623a9d405c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-24 02:05:56', '2026-09-24 02:05:56', 0),
('2a7f84b0-7e9e-4df4-b030-33263af7fe16', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project Rejected', 'Your project \"HACKATON 2026 (sample 3)\" was rejected. Reason: Need more information for credibility', 'project', 0, NULL, '2026-09-19 08:21:12', '2026-09-19 08:21:12', 0),
('2e563cc9-46f9-4245-872a-0e17db078cbe', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'Ledger entry submitted for approval', 'A ledger entry for project \"Tech Innovation Summit 2026\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:58:07', '2026-09-26 10:58:07', 0),
('310855f7-f4b7-4398-a47a-8b7169a7d285', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-22 23:30:38', '2026-09-22 23:30:38', 0),
('34824674-b11f-4755-a730-d16228717fae', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"Anti-Bullying Awareness 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-27 05:49:12', '2026-09-27 05:49:12', 0),
('349e8c7c-f789-470d-a5d3-8b6a7ef7e5cc', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:15:23', '2026-09-22 14:15:23', 0),
('35e188ce-c31a-4f17-b081-63f7df33dbf2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project Rejected', 'Your project \"SAMPLE 7\" was rejected. Reason: ahscgajsgbc', 'project', 0, NULL, '2026-09-24 02:02:58', '2026-09-24 02:02:58', 0),
('371dcf4b-4f96-4c3a-bb77-1ef9ee26aef7', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:10:05', '2026-09-26 10:10:05', 0),
('3fe7d4e5-a8d4-4de0-ac06-bc42aa93bf23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Date Change Request Approved', 'Your date change request for project \"sample 6\" has been approved.', 'date_change', 0, NULL, '2026-09-20 12:37:13', '2026-09-20 12:37:13', 0),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', NULL, 'New Meeting Scheduled', 'A new meeting titled \'SportFest 2026 - Event Planning Meeting\' has been scheduled for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:18:00', '2026-09-20 03:18:00', 0),
('4b6c9f4f-3c99-4e98-a61b-ad3fe6c57e6c', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"SAMPLE 7\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 10:59:37', '2026-09-19 10:59:37', 0),
('4d5b51ff-67a6-4035-9a57-1d77489d0fbc', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 08:38:10', '2026-09-26 08:38:10', 0),
('56044327-85c1-4532-b9b4-4478d4e3337e', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"SPORT FEST 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 01:50:09', '2026-09-23 01:50:09', 0),
('5626d442-b404-4dfd-8112-54738cbe0d1c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"HACKATON 2026 (sample 3)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:20:45', '2026-09-19 08:20:45', 0),
('5db1ad97-5365-4a2e-b521-6cbdb51aff6e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:15:23', '2026-09-22 14:15:23', 0),
('5f486a6a-92d5-4fb4-9035-ee530790fdf3', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"sample 6\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:49:10', '2026-09-19 08:49:10', 0),
('613686d5-2f07-4b17-b5c1-7cf0708650b1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:10:05', '2026-09-26 10:10:05', 0),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', NULL, 'Meeting Updated', 'The meeting titled \'Monthly Routine Meeting\' was updated for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:16:09', '2026-09-20 03:16:09', 0),
('6cb4e16c-7edb-40d2-8f91-6b4ef5846368', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:16:57', '2026-09-22 14:16:57', 0),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', NULL, 'Meeting Updated', 'The meeting titled \'Monthly Routine Meeting\' was updated for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:16:41', '2026-09-20 03:16:41', 0),
('70ed0b6d-7752-44b7-b15a-39f46ace0bc4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"Anti-Bullying Awareness 2026\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-27 05:49:12', '2026-09-27 05:49:12', 0),
('725c0edd-dece-4167-9837-6d2610e5ca52', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-24 02:35:02', '2026-09-24 02:35:02', 0),
('765c3002-a2de-4668-806e-630ec3413506', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-19 08:11:38', '2026-09-19 08:11:38', 0),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', NULL, 'Project Approved', 'Project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'project', 0, NULL, '2026-09-19 08:02:40', '2026-09-19 08:02:40', 0),
('7d7f9bf4-09d3-4e3c-bd2d-92bddf320d15', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"Tech Innovation Summit 2026\" has been approved.', 'ledger', 0, NULL, '2026-09-26 10:58:23', '2026-09-26 10:58:23', 0),
('7f22256e-cee8-4353-b233-59b6d0686561', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"SPORT FEST 2026\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 01:50:09', '2026-09-23 01:50:09', 0),
('819b0bc3-fb39-4c54-9541-c1f222c98abf', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:10:05', '2026-09-26 10:10:05', 0),
('83e7034c-2946-455a-809c-69229d3ad9a5', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"Tech Innovation Summit 2026\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:58:07', '2026-09-26 10:58:07', 0),
('8681114c-7641-4593-b095-ca77872fe494', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:46', '2026-09-19 08:10:46', 0),
('87c8acc1-f724-4fdf-87bd-67fe3f0ed088', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:37', '2026-09-19 08:10:37', 0),
('8e7bbb43-dd50-4a86-8b44-cd6b2403e69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:09:13', '2026-09-22 14:09:13', 0),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', NULL, 'Project Approved', 'Project \"SPORT FEST 2026\" has been approved.', 'project', 0, NULL, '2026-09-23 01:52:15', '2026-09-23 01:52:15', 0),
('91326b43-f9b9-445f-a9d5-289a8802eb46', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"Tech Innovation Summit 2026\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-26 10:58:07', '2026-09-26 10:58:07', 0),
('94ffe5ef-19f7-4ed9-ba8a-385d91586a46', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-20 14:33:01', '2026-09-20 14:33:01', 0),
('999f2a8f-b9a9-45e1-b87b-441caa4420c6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:16:57', '2026-09-22 14:16:57', 0),
('9ccd535c-3f7a-4ea6-96be-18f6c574e2a6', NULL, 'Project Approved', 'Project \"Tech Innovation Summit 2026\" has been approved.', 'project', 0, NULL, '2026-09-26 08:39:18', '2026-09-26 08:39:18', 0),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 02:07:38', '2026-09-23 02:07:38', 0),
('b7c7745b-64b3-4119-afb4-970a3b55a055', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:30:48', '2026-09-19 08:30:48', 0),
('b9b21856-21dd-42c6-9d4b-93da76475785', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:46', '2026-09-19 08:10:46', 0),
('ba140221-b91e-4a9d-9630-848a3b85adb6', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-20 14:33:01', '2026-09-20 14:33:01', 0),
('c43e6208-7d73-47d3-81dc-411f5a56f0f9', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"Tech Innovation Summit 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-26 08:22:15', '2026-09-26 08:22:15', 0),
('c9927155-5ea4-48a5-b498-330056f77c58', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 07:56:01', '2026-09-19 07:56:01', 0),
('ca5814c2-e76e-4c52-9efe-33448fe000a0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:07:03', '2026-09-22 14:07:03', 0),
('cad1c647-057e-4a23-b7f5-4cfcdcec1092', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"Tech Innovation Summit 2026\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-26 08:22:15', '2026-09-26 08:22:15', 0),
('d4a8acef-0f90-4389-8c38-5c9a2c648890', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"HACKATON 2026 (sample 3)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:20:45', '2026-09-19 08:20:45', 0),
('d6ebedeb-565f-47a2-bb06-d88b3bfb0b91', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:30:48', '2026-09-19 08:30:48', 0),
('d799b9a7-4026-4c2c-912b-ea45d528833a', NULL, 'Announcement', 'The system will be down for a while because of an update thankyou!', 'system', 0, NULL, '2026-09-27 05:43:38', '2026-09-27 05:43:38', 0),
('df791218-11c9-471d-81a3-8544f3cc686b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-19 08:11:21', '2026-09-19 08:11:21', 0),
('e5271b32-3659-4203-80b8-5f6930b5babb', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 03:18:50', '2026-09-23 03:18:50', 0),
('eaae5a15-6b1b-4fbb-86e2-a513a2548cdf', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:35', '2026-09-19 08:10:35', 0),
('ec5f2165-f975-4dbb-bb22-da5bbc9a1aa8', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:33:14', '2026-09-19 08:33:14', 0),
('ed440768-760b-4167-9ba2-fe5d2ae1c7f1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"sample 6\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:49:10', '2026-09-19 08:49:10', 0),
('f113232b-709c-497b-86e9-a82fb87c6ca0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: too expensive', 'ledger', 0, NULL, '2026-09-19 08:11:57', '2026-09-19 08:11:57', 0),
('f64422e6-8516-4f78-9845-a7346c1b964a', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:37', '2026-09-19 08:10:37', 0),
('f76a1581-3c77-44dd-8d03-c96bcfe40b72', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: TEST', 'ledger', 0, NULL, '2026-09-22 14:15:36', '2026-09-22 14:15:36', 0);

-- --------------------------------------------------------

--
-- Table structure for table `notification_reads`
--

CREATE TABLE `notification_reads` (
  `notification_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `read_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notification_reads`
--

INSERT INTO `notification_reads` (`notification_id`, `user_id`, `read_at`) VALUES
('012f0007-83f2-4e3a-b046-2f4dbdc37166', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('037fa2dc-058b-4f66-8ae8-651550d60cef', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('04351f1a-1a98-413b-a0b3-ceb6749c2507', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('044933fa-d0a0-4dfd-ac4f-ff0073ddcf52', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('065c16a6-4ab2-40b6-b949-8e36a0754e86', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('0eda2eba-c066-405e-8bc0-04c166eefbe2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('0f264203-2331-48cd-8435-8e71d06415e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('0f264203-2331-48cd-8435-8e71d06415e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('10fd541d-35d5-4b5d-a7cf-e0484a32355d', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:22'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:02:49'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:07'),
('152156dc-e5df-4685-85c7-9939611d35d4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('16028c11-c63a-4a57-8c95-b84c0e1a17ae', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('1e4e3c93-5c69-44d5-a855-c6f97fcde5a9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('23aa6fd0-c4bc-4458-9b43-70623a9d405c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('2a7f84b0-7e9e-4df4-b030-33263af7fe16', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('2e563cc9-46f9-4245-872a-0e17db078cbe', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('349e8c7c-f789-470d-a5d3-8b6a7ef7e5cc', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('35e188ce-c31a-4f17-b081-63f7df33dbf2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('3fe7d4e5-a8d4-4de0-ac06-bc42aa93bf23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:18'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', '2026-09-22 05:55:58'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:11:00'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:04'),
('4b6c9f4f-3c99-4e98-a61b-ad3fe6c57e6c', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('4d5b51ff-67a6-4035-9a57-1d77489d0fbc', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-27 02:54:26'),
('56044327-85c1-4532-b9b4-4478d4e3337e', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('5626d442-b404-4dfd-8112-54738cbe0d1c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('5db1ad97-5365-4a2e-b521-6cbdb51aff6e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('5f486a6a-92d5-4fb4-9035-ee530790fdf3', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('613686d5-2f07-4b17-b5c1-7cf0708650b1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:21'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:06'),
('6cb4e16c-7edb-40d2-8f91-6b4ef5846368', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:21'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', '2026-09-22 05:56:05'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:11:02'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:05'),
('725c0edd-dece-4167-9837-6d2610e5ca52', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('725c0edd-dece-4167-9837-6d2610e5ca52', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('725c0edd-dece-4167-9837-6d2610e5ca52', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('725c0edd-dece-4167-9837-6d2610e5ca52', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('725c0edd-dece-4167-9837-6d2610e5ca52', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('725c0edd-dece-4167-9837-6d2610e5ca52', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:02:40'),
('765c3002-a2de-4668-806e-630ec3413506', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:24'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:07'),
('7d7f9bf4-09d3-4e3c-bd2d-92bddf320d15', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('7f22256e-cee8-4353-b233-59b6d0686561', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('819b0bc3-fb39-4c54-9541-c1f222c98abf', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('83e7034c-2946-455a-809c-69229d3ad9a5', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('8681114c-7641-4593-b095-ca77872fe494', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('87c8acc1-f724-4fdf-87bd-67fe3f0ed088', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('8e7bbb43-dd50-4a86-8b44-cd6b2403e69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:02:45'),
('94ffe5ef-19f7-4ed9-ba8a-385d91586a46', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('999f2a8f-b9a9-45e1-b87b-441caa4420c6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('9ccd535c-3f7a-4ea6-96be-18f6c574e2a6', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('9ccd535c-3f7a-4ea6-96be-18f6c574e2a6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('b7c7745b-64b3-4119-afb4-970a3b55a055', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('b9b21856-21dd-42c6-9d4b-93da76475785', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('ba140221-b91e-4a9d-9630-848a3b85adb6', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('c9927155-5ea4-48a5-b498-330056f77c58', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('ca5814c2-e76e-4c52-9efe-33448fe000a0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('cad1c647-057e-4a23-b7f5-4cfcdcec1092', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('d4a8acef-0f90-4389-8c38-5c9a2c648890', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('d6ebedeb-565f-47a2-bb06-d88b3bfb0b91', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('d799b9a7-4026-4c2c-912b-ea45d528833a', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('d799b9a7-4026-4c2c-912b-ea45d528833a', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-27 05:48:08'),
('df791218-11c9-471d-81a3-8544f3cc686b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('e5271b32-3659-4203-80b8-5f6930b5babb', '45d33f04-28d9-4d27-af01-990f0a029d39', '2026-09-25 12:45:10'),
('e5271b32-3659-4203-80b8-5f6930b5babb', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '2026-09-27 05:47:59'),
('e5271b32-3659-4203-80b8-5f6930b5babb', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('e5271b32-3659-4203-80b8-5f6930b5babb', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('e5271b32-3659-4203-80b8-5f6930b5babb', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '2026-09-25 14:04:16'),
('e5271b32-3659-4203-80b8-5f6930b5babb', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', '2026-09-25 13:10:47'),
('eaae5a15-6b1b-4fbb-86e2-a513a2548cdf', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('ec5f2165-f975-4dbb-bb22-da5bbc9a1aa8', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('ed440768-760b-4167-9ba2-fe5d2ae1c7f1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('f113232b-709c-497b-86e9-a82fb87c6ca0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21'),
('f64422e6-8516-4f78-9845-a7346c1b964a', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '2026-09-26 04:02:35'),
('f76a1581-3c77-44dd-8d03-c96bcfe40b72', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-26 16:43:21');

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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `module`, `action`, `permission`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('610ce578-e823-4977-8f79-28da28a168ae', 'Projects', 'reject', 'projects.reject', 'Reject access for Projects', '2026-09-07 17:55:19', '2026-09-07 17:55:19', 0),
('a1b10001-0000-4000-8000-000000000001', 'Projects', 'view', 'projects.view', 'View access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10002-0000-4000-8000-000000000002', 'Projects', 'create', 'projects.create', 'Create access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10003-0000-4000-8000-000000000003', 'Projects', 'edit', 'projects.edit', 'Edit access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10004-0000-4000-8000-000000000004', 'Projects', 'delete', 'projects.delete', 'Delete access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10005-0000-4000-8000-000000000005', 'Projects', 'approve', 'projects.approve', 'Approve access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10006-0000-4000-8000-000000000006', 'Projects', 'rate', 'projects.rate', 'Rate access for Projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10007-0000-4000-8000-000000000007', 'Ledger', 'view', 'ledger.view', 'View access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10008-0000-4000-8000-000000000008', 'Ledger', 'create', 'ledger.create', 'Create access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10009-0000-4000-8000-000000000009', 'Ledger', 'edit', 'ledger.edit', 'Edit access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10010-0000-4000-8000-000000000010', 'Ledger', 'delete', 'ledger.delete', 'Delete access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10011-0000-4000-8000-000000000011', 'Ledger', 'approve', 'ledger.approve', 'Approve access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10012-0000-4000-8000-000000000012', 'Ledger', 'submit', 'ledger.submit', 'Submit access for Ledger', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10013-0000-4000-8000-000000000013', 'Proof Documents', 'view', 'proof-documents.view', 'View access for Proof Documents', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10014-0000-4000-8000-000000000014', 'Proof Documents', 'upload', 'proof-documents.upload', 'Upload access for Proof Documents', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10015-0000-4000-8000-000000000015', 'Proof Documents', 'delete', 'proof-documents.delete', 'Delete access for Proof Documents', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10016-0000-4000-8000-000000000016', 'Proof Documents', 'approve', 'proof-documents.approve', 'Approve access for Proof Documents', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10017-0000-4000-8000-000000000017', 'Proof Documents', 'validate', 'proof-documents.validate', 'Validate access for Proof Documents', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10018-0000-4000-8000-000000000018', 'Meetings', 'view', 'meetings.view', 'View access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10019-0000-4000-8000-000000000019', 'Meetings', 'create', 'meetings.create', 'Create access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10020-0000-4000-8000-000000000020', 'Meetings', 'edit', 'meetings.edit', 'Edit access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10021-0000-4000-8000-000000000021', 'Meetings', 'delete', 'meetings.delete', 'Delete access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10022-0000-4000-8000-000000000022', 'Meetings', 'upload minutes', 'meetings.upload-minutes', 'Upload Minutes access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10023-0000-4000-8000-000000000023', 'Meetings', 'approve minutes', 'meetings.approve-minutes', 'Approve Minutes access for Meetings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10024-0000-4000-8000-000000000024', 'Ratings', 'view', 'ratings.view', 'View access for Ratings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10025-0000-4000-8000-000000000025', 'Ratings', 'submit', 'ratings.submit', 'Submit access for Ratings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10026-0000-4000-8000-000000000026', 'Ratings', 'moderate', 'ratings.moderate', 'Moderate access for Ratings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10027-0000-4000-8000-000000000027', 'Ratings', 'analytics', 'ratings.analytics', 'Analytics access for Ratings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10028-0000-4000-8000-000000000028', 'Notifications', 'view', 'notifications.view', 'View access for Notifications', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10029-0000-4000-8000-000000000029', 'Notifications', 'send', 'notifications.send', 'Send access for Notifications', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10030-0000-4000-8000-000000000030', 'Notifications', 'manage', 'notifications.manage', 'Manage access for Notifications', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10031-0000-4000-8000-000000000031', 'User Management', 'view', 'user-management.view', 'View access for User Management', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10032-0000-4000-8000-000000000032', 'User Management', 'create', 'user-management.create', 'Create access for User Management', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10033-0000-4000-8000-000000000033', 'User Management', 'edit', 'user-management.edit', 'Edit access for User Management', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10034-0000-4000-8000-000000000034', 'User Management', 'suspend', 'user-management.suspend', 'Suspend access for User Management', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10035-0000-4000-8000-000000000035', 'User Management', 'delete', 'user-management.delete', 'Delete access for User Management', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10036-0000-4000-8000-000000000036', 'Organizations', 'view', 'organizations.view', 'View access for Organizations', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10037-0000-4000-8000-000000000037', 'Organizations', 'create', 'organizations.create', 'Create access for Organizations', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10038-0000-4000-8000-000000000038', 'Organizations', 'edit', 'organizations.edit', 'Edit access for Organizations', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10039-0000-4000-8000-000000000039', 'Organizations', 'archive', 'organizations.archive', 'Archive access for Organizations', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10040-0000-4000-8000-000000000040', 'System Settings', 'view', 'system-settings.view', 'View access for System Settings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10041-0000-4000-8000-000000000041', 'System Settings', 'configure', 'system-settings.configure', 'Configure access for System Settings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10042-0000-4000-8000-000000000042', 'System Settings', 'backup', 'system-settings.backup', 'Backup access for System Settings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('a1b10043-0000-4000-8000-000000000043', 'System Settings', 'logs', 'system-settings.logs', 'Logs access for System Settings', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('acb7b197-cb89-4e0f-a135-2b3c64affffd', 'Meetings', 'submit', 'meetings.submit', 'Submit access for Meetings', '2026-09-07 17:55:20', '2026-09-07 17:55:20', 0),
('b5624339-3f3a-439a-954f-88b2251f3b3b', 'Ledger', 'reject', 'ledger.reject', 'Reject access for Ledger', '2026-09-07 17:55:19', '2026-09-07 17:55:19', 0),
('e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'Projects', 'submit', 'projects.submit', 'Submit access for Projects', '2026-09-07 17:55:19', '2026-09-07 17:55:19', 0),
('f298d5a3-d2a7-4c23-97a8-289d2928069f', 'Ledger', 'fix tampered', 'ledger.fix-tampered', 'Fix Tampered access for Ledger', '2026-09-26 04:00:44', '2026-09-26 04:00:44', 0);

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
  `created_at` date NOT NULL DEFAULT curdate(),
  `updated_at` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `position`
--

INSERT INTO `position` (`id`, `position_name`, `created_at`, `updated_at`) VALUES
('5epndb4oho94dy81m5bvcmxizoxgxcn9', 'IGDS SW Representative', '2026-09-07', '2026-09-07'),
('5uvqzamuyudnjelaat3eg9hqvkwsjjn0', 'Treasurer', '2026-09-07', '2026-09-07'),
('6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', 'Vice President for Internal Affairs', '2026-09-07', '2026-09-07'),
('a6gwfcioumlfbouuqrdg4uxh53b0vtj6', 'Auditor', '2026-09-07', '2026-09-07'),
('d6zmpklwrr4bealvclya0sd7sspb4sn4', 'ION Representative', '2026-09-07', '2026-09-07'),
('daqqum81lqom3w5lde5unsn3k54bymmn', 'Student Liaison', '2026-09-07', '2026-09-07'),
('dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', 'ICDI IS Representative', '2026-09-07', '2026-09-07'),
('f5ssbkxesaexrd5qddpvliuunl8xkzco', 'Press Relations Officer', '2026-09-07', '2026-09-07'),
('nkvv7loq6oc6wctbk4ngck1jk3vcw938', 'ICDI CS Representative', '2026-09-07', '2026-09-07'),
('qjtim1ggjxclcljt5at73oetsntp5lm8', 'Secretary', '2026-09-07', '2026-09-07'),
('qwef7qelcixo5hi3nrmmivevzvxkpwzs', 'President', '2026-09-07', '2026-09-07'),
('rcqgju2wsyaoilufnv0afwurkxop9oqt', 'Business Manager', '2026-09-07', '2026-09-07'),
('ymmwbp4nqedawvo2puiimcoabxj855wx', 'IOM Representative', '2026-09-07', '2026-09-07'),
('ytiqwugtxxbyorspbc1qbzq8xno7bvz0', 'Vice President for External Affairs', '2026-09-07', '2026-09-07');

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
  `is_initial` tinyint(1) NOT NULL DEFAULT 0,
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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` char(36) DEFAULT NULL,
  `updated_by` char(36) DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `student_id`, `title`, `description`, `objective`, `category`, `budget`, `is_initial`, `venue`, `status`, `proposed_by`, `note`, `project_proof`, `file_content_hash`, `start_date`, `end_date`, `approve_by`, `approval_status`, `approved_at`, `created_at`, `updated_at`, `created_by`, `updated_by`, `archive`) VALUES
('03e59f8a-19df-41ee-8cd9-2413ed3eea80', NULL, 'TEST PROJECT', 'Test dont approve', 'Test dont approve', 'Environmental', 1010.00, 1, 'Dasmarinas', 'Draft', 'Csg1', NULL, NULL, NULL, '2026-10-17', '2026-10-17', NULL, 'Draft', NULL, '2026-09-26 16:40:36', '2026-09-26 16:41:01', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('1ee4d579-9b41-468a-a691-b86ad5735c04', NULL, 'KULTURA\'T MUSIKA: Himig ng Kabataan, Tinig ng Kinabukasan 2026 (sample 2)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Objectives\r\n-Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n-Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Cultural', 0.00, 0, 'City of Dasmarinas Arena', 'Draft', 'CSG1', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-09', '2026-10-09', NULL, 'Draft', NULL, '2026-09-19 08:18:34', '2026-09-19 08:18:35', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('428555bf-e5c1-4a55-85aa-8565bd218efd', NULL, 'Anti-Bullying Awareness 2026', 'A campus-wide anti-bullying awareness program that promotes a safe, respectful, and inclusive school environment through seminars, interactive workshops, poster campaigns, and peer-support activities. The initiative brings together students, teachers, and counselors to openly discuss the causes and effects of bullying while equipping everyone with the knowledge and confidence to prevent and report it.', 'Objectives:\r\n- To raise awareness among students, teachers, and staff on the different forms of bullying, including physical, verbal, social, and cyberbullying\r\n- To promote a culture of respect, empathy, and inclusivity within the school community\r\n- To encourage students to speak up, report incidents, and seek help without fear of judgment\r\n- To provide support systems and counseling services for both victims and those who exhibit bullying behavior\r\n- To strengthen collaboration between students, faculty, and parents in creating a safer learning environment', 'Social', 4000.00, 0, 'KLD', 'Draft', 'jani', NULL, NULL, NULL, '2026-10-18', '2026-10-19', NULL, 'Pending Adviser Approval', NULL, '2026-09-27 04:48:23', '2026-09-27 05:49:12', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('58f38625-3132-485e-a8a6-308436e56bf2', NULL, 'KLD FOUNDATION WEEK 2025 (sample1)', 'KLD Foundation Week 2025 marks the 5th founding anniversary celebration of Kolehiyo ng Lungsod ng Dasmariñas. The celebration, themed \"Lima\'t Laya,\" commemorates five years of the institution\'s commitment to accessible education and community development in Dasmariñas. The project has the currecnt budget of 5,000 php.', 'Objectives\r\n-To honor the college\'s five-year journey of providing quality education to local students\r\n-To strengthen community bonds through festive activities and shared celebrations\r\n-To reaffirm KLD\'s mission of fostering academic excellence and social responsibility', 'Social', 23.00, 1, 'KLD Gymnasium', 'Draft', 'CSG1, CSG2, CSG3, CSG4', 'Make sure all the requirements need is complete before the event.', 'project_approval/768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236.pdf', '768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236', '2025-10-15', '2025-10-22', '62900437-3c5f-4652-b968-f2eac510ddad', 'Approved', '2026-09-19 08:02:40', '2026-09-19 07:55:00', '2026-09-26 10:51:05', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 0),
('7f34c673-3de7-4386-9191-135ad6ea2666', NULL, 'DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Education', 1000.00, 0, 'City of Dasmarinas Area', 'Draft', 'CSG6', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-30', '2026-10-30', NULL, 'Pending Adviser Approval', NULL, '2026-09-19 08:30:36', '2026-09-19 08:30:48', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('98cf7626-6bff-4cbb-9cc3-43884ece691f', NULL, 'BAKOD KO LINIS KO (sample 4)', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Education', 700.00, 0, 'San Lorenzo Area E', 'Draft', 'CSG1, 2, 3, 4, 5', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-12-15', '2026-12-16', NULL, 'Draft', NULL, '2026-09-19 08:28:25', '2026-09-19 08:28:26', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('b984c09c-a66d-4e34-9489-4d75222b8188', NULL, 'sample', 'sample', 'sample', 'Sports', 2.00, 1, 'sample', 'Draft', 'sample', NULL, NULL, NULL, '2026-10-20', '2026-10-21', NULL, 'Draft', NULL, '2026-09-26 07:57:38', '2026-09-26 08:18:21', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1),
('bb03cf78-cc39-4bf4-94ee-103a1049e777', NULL, 'HACKATON 2026 (sample 3)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.', 'Technology', 0.00, 0, 'KLD Bldg1', 'Draft', 'CSG3', 'Need more information for credibility', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-22', '2026-11-05', NULL, 'Rejected', NULL, '2026-09-19 08:20:41', '2026-09-19 08:21:12', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '62900437-3c5f-4652-b968-f2eac510ddad', 0),
('bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', NULL, 'SAMPLE 7', 'SAMPLE 7', 'SAMPLE 7', 'Sports', 0.00, 0, 'SAMPLE 7', 'Draft', 'SAMPLE 7', 'ahscgajsgbc', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-21', '2026-10-28', NULL, 'Rejected', NULL, '2026-09-19 10:58:52', '2026-09-26 07:53:44', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', 1),
('d087b77d-8451-48fb-9ae9-f07e26aa9232', NULL, 'Tech Innovation Summit 2026', 'The primary objective of the Tech Innovation Summit 2026 is to expose students to current industry practices and emerging technologies that are not always covered within the standard academic curriculum, thereby enriching their understanding of what awaits them in the professional world.', 'The Tech Innovation Summit 2026 is a three-day campus-wide event designed to bring together students, faculty members, and industry professionals in a shared celebration of technology and innovation. The summit will serve as a platform for exploring the most relevant and emerging trends in the field, including artificial intelligence, cybersecurity, cloud computing, and modern software development practices.', 'Technology', 4500.00, 1, 'KLD Arena', 'Draft', 'jim, ed', 'Good', 'project_approval/768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236.pdf', '768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236', '2026-09-17', '2026-09-25', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'Approved', '2026-09-26 08:39:18', '2026-09-26 08:19:59', '2026-09-26 10:58:23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 0),
('d2f97975-322c-4cd4-aa14-6b302b71e7b8', NULL, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'Sports', 0.00, 0, 'SAMPLE', 'Draft', 'SAMPLE', NULL, NULL, NULL, '2026-10-20', '2026-10-28', NULL, 'Draft', NULL, '2026-09-22 12:03:59', '2026-09-26 07:53:41', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1),
('d6c01bae-4c4e-4626-bbed-9f145155bc24', NULL, 'Tech Innovation Summit 2026', 'The primary objective of the Tech Innovation Summit 2026 is to expose students to current industry practices and emerging technologies that are not always covered within the standard academic curriculum, thereby enriching their understanding of what awaits them in the professional world.', 'The Tech Innovation Summit 2026 is a three-day campus-wide event designed to bring together students, faculty members, and industry professionals in a shared celebration of technology and innovation. The summit will serve as a platform for exploring the most relevant and emerging trends in the field, including artificial intelligence, cybersecurity, cloud computing, and modern software development practices.', 'Technology', 800.00, 1, 'KLD Arena', 'Draft', 'Edward, Jim', NULL, NULL, NULL, '2026-10-21', '2026-10-22', NULL, 'Draft', NULL, '2026-09-26 07:55:58', '2026-09-26 08:18:25', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1),
('f5c0e2c4-1046-4e66-85bb-dd33b6aee2fe', NULL, 'Anti-Bullying Awareness 2026', 'A campus-wide anti-bullying awareness program that promotes a safe, respectful, and inclusive school environment through seminars, interactive workshops, poster campaigns, and peer-support activities. The initiative brings together students, teachers, and counselors to openly discuss the causes and effects of bullying while equipping everyone with the knowledge and confidence to prevent and report it.', 'Objectives:\r\n- To raise awareness among students, teachers, and staff on the different forms of bullying, including physical, verbal, social, and cyberbullying\r\n- To promote a culture of respect, empathy, and inclusivity within the school community\r\n- To encourage students to speak up, report incidents, and seek help without fear of judgment\r\n- To provide support systems and counseling services for both victims and those who exhibit bullying behavior\r\n- To strengthen collaboration between students, faculty, and parents in creating a safer learning environment', 'Social', 1000.00, 0, 'KLD Building 1 Gym', 'Draft', 'CSG1, CSG2, CSG3', NULL, NULL, NULL, '2026-10-19', '2026-10-20', NULL, 'Draft', NULL, '2026-09-27 04:16:01', '2026-09-27 04:19:51', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1);

-- --------------------------------------------------------

--
-- Table structure for table `push_subscriptions`
--

CREATE TABLE `push_subscriptions` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `endpoint` varchar(2048) NOT NULL,
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
  `helpful_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `project_id`, `user_id`, `satisfaction_rating`, `completeness_rating`, `engagement_rating`, `comments`, `helpful_count`, `created_at`, `archive`) VALUES
('040a973c-819d-430d-83e1-32b023af97d0', '58f38625-3132-485e-a8a6-308436e56bf2', 'f2c4d064-6654-4cc5-99e4-094714cef15a', 5, 5, 5, 'Excellent', 0, '2026-09-22 05:58:16', 0),
('0ac3f9d4-e22a-4ef5-8638-02b25f10dfba', '58f38625-3132-485e-a8a6-308436e56bf2', '339d6a7f-ddc2-4687-bf06-c7a7229db720', 5, 5, 5, 'Good job!', 0, '2026-09-24 03:26:49', 0),
('0cd138d6-c87a-4175-a8b3-2025e22c4ae0', '58f38625-3132-485e-a8a6-308436e56bf2', '1532c8ff-88f3-46da-8222-9df946116efa', 4, 4, 4, 'It\'s good but need to improve in visual appeal', 0, '2026-09-22 06:42:04', 0),
('136aacc8-cc90-4db6-9295-384270eee896', '58f38625-3132-485e-a8a6-308436e56bf2', '952befae-6ce5-4ea7-a018-3bb3e638a90e', 5, 5, 5, 'Very Good!', 0, '2026-09-22 03:21:22', 0),
('1609ec92-5d58-4a72-9f10-02d97128b106', '58f38625-3132-485e-a8a6-308436e56bf2', '6613df2b-711e-4e04-b8a5-df3d5f421e61', 4, 4, 4, 'It was fun and entertaining.', 0, '2026-09-23 13:06:57', 0),
('160cc1be-e9ce-42d4-a72f-8aebbc6042f8', '58f38625-3132-485e-a8a6-308436e56bf2', '9b546859-b0d4-4c1f-8489-33727c273a54', 5, 5, 5, 'Awesome', 0, '2026-09-24 04:43:34', 0),
('1c45f2f1-0fab-467f-9805-630ec58c5da2', '58f38625-3132-485e-a8a6-308436e56bf2', '2685f8e1-10ae-4337-a650-70bd0b45a3ba', 5, 5, 5, 'NICE!', 0, '2026-09-22 03:20:32', 0),
('26d0451c-dd9c-4a7b-b436-f010db76be11', '58f38625-3132-485e-a8a6-308436e56bf2', '5a091b16-6fe3-43fc-8e95-9507272190de', 5, 4, 4, 'Umamazing Greattt!!!! yummy zarappp so oblivious!!!', 0, '2026-09-24 04:36:59', 0),
('2f2174bf-d13d-4fc1-a5dc-1388f273081a', '58f38625-3132-485e-a8a6-308436e56bf2', '1957970f-e67f-4d9a-b773-94b81f84b937', 5, 5, 5, 'Good job!', 0, '2026-09-22 06:22:30', 0),
('316d40f0-1754-4f4d-b324-6e65a0229468', '58f38625-3132-485e-a8a6-308436e56bf2', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', 5, 5, 5, 'A work of art and it shows transparency', 0, '2026-09-22 03:23:35', 0),
('32c614d1-d460-4d48-a54b-c7ea964c5f61', '58f38625-3132-485e-a8a6-308436e56bf2', '54ae97c2-c473-4975-aacc-d44d84591628', 5, 5, 5, 'Not fully aware of this, but I appreciate how this helps others:)', 0, '2026-09-21 11:24:23', 0),
('3871c42e-f6db-4cc0-90ed-9210b78525d9', '58f38625-3132-485e-a8a6-308436e56bf2', '6806b839-89e2-4d50-90c5-587313474b8a', 5, 5, 5, 'visually pleasant and appealing. nasa dashboard na lahat; i like the reminders at yung calendar, reminds me of google classroom but mas nice sa mata. i thought incomplete lang siya kasi yung notifications dinadala me sa dashboard. overall: smooth, nice, and neat !!', 0, '2026-09-23 16:07:31', 0),
('3dfc4d78-8157-4b02-99bc-c51b35aafb35', '58f38625-3132-485e-a8a6-308436e56bf2', '11a031e9-b7fb-42c5-b0f8-461c2e2ae827', 5, 4, 5, 'Keep it up', 0, '2026-09-22 05:17:58', 0),
('42e69303-6ee3-4585-82be-96075523b4fd', '58f38625-3132-485e-a8a6-308436e56bf2', '0acf2825-1aff-4bd5-b24b-3fd79375fd49', 4, 4, 4, 'great', 0, '2026-09-22 03:23:52', 0),
('4778c28f-8d28-4ca0-8ea4-6813f2d3a454', '58f38625-3132-485e-a8a6-308436e56bf2', '598cf801-e6f6-447d-8706-9c5b8e86887d', 5, 5, 5, 'Good', 0, '2026-09-24 05:28:23', 0),
('4cfe0957-a4f0-44e1-ab64-41b3c45a0429', '58f38625-3132-485e-a8a6-308436e56bf2', '4364f571-2368-479e-8ec2-491d176c693a', 5, 5, 5, 'Easy to use and shows transparency.', 0, '2026-09-22 03:18:25', 0),
('54132efb-0668-4ac1-b9e1-66c4930e82c3', '58f38625-3132-485e-a8a6-308436e56bf2', 'f7ef62d5-8133-4c7e-a487-c7e000210788', 5, 5, 5, 'nice project!', 0, '2026-09-22 03:22:50', 0),
('57ffa759-d8ff-40fc-8f5d-f235ebde6f08', '58f38625-3132-485e-a8a6-308436e56bf2', 'b13efe11-ebdb-4b7f-aca4-d4fa6b9f78c6', 4, 4, 4, 'Nice', 0, '2026-09-24 01:04:56', 0),
('5d186dbc-9592-4964-8f24-3f433af348a9', '58f38625-3132-485e-a8a6-308436e56bf2', '45d33f04-28d9-4d27-af01-990f0a029d39', 4, 3, 5, 'Great!', 0, '2026-09-25 12:44:58', 0),
('5fdc5995-3121-428d-95fc-e383d38c905b', '58f38625-3132-485e-a8a6-308436e56bf2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 4, 4, 4, 'Test', 0, '2026-09-25 12:20:22', 0),
('61bb28eb-48c5-42f1-9f4c-b649897a3a96', '58f38625-3132-485e-a8a6-308436e56bf2', '5e202776-9410-424f-86a0-36d9176247a4', 5, 5, 5, 'Nice', 0, '2026-09-24 06:32:02', 0),
('6b97b5ef-57db-4232-ad73-fd132d0a22a3', '58f38625-3132-485e-a8a6-308436e56bf2', 'ba15f544-faf5-44bf-a36b-49ea4807b791', 5, 5, 5, 'NICE NICE', 0, '2026-09-24 02:02:33', 0),
('70fc576a-ddac-42f4-8e69-4824f961f858', '58f38625-3132-485e-a8a6-308436e56bf2', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 5, 5, 5, 'Great system', 0, '2026-09-22 05:54:43', 0),
('8469e0f4-659b-4b67-bda1-52ceb6f04b50', '58f38625-3132-485e-a8a6-308436e56bf2', '6350f4ad-1cf9-4f05-abb7-d318915f87ff', 5, 5, 5, 'Nice', 0, '2026-09-24 00:25:29', 0),
('84cdead7-a23a-4354-bd81-da714bafb971', '58f38625-3132-485e-a8a6-308436e56bf2', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', 5, 5, 5, 'I like it', 0, '2026-09-19 08:34:02', 0),
('8b38882a-4ffe-4cc5-809b-ac76b22083ef', '58f38625-3132-485e-a8a6-308436e56bf2', '42cba165-e218-47cb-93c9-afbcea19ecdf', 4, 5, 5, 'N/A', 0, '2026-09-23 13:00:27', 0),
('904a6b35-bbd5-48ba-b5be-8ed8645a05b8', '58f38625-3132-485e-a8a6-308436e56bf2', 'fecf41cc-142d-4038-a152-8fa34718ad37', 4, 4, 2, 'Some reliable', 0, '2026-09-22 05:58:05', 0),
('a40abe88-71d3-4c05-a1be-bbcad115455b', '58f38625-3132-485e-a8a6-308436e56bf2', '7c1c5079-05ca-4468-800c-463b24e22030', 5, 5, 5, 'Smooth naman yung app and organized hindi nakakalito i-navigate', 0, '2026-09-22 05:40:33', 0),
('a4f2d963-fdce-452c-b3b1-b8e49098f380', '58f38625-3132-485e-a8a6-308436e56bf2', '6ed430d8-5089-41c4-b5a7-28849cf5c01a', 5, 5, 5, 'nice', 0, '2026-09-24 00:34:18', 0),
('a5c2a5d4-d443-4f71-894d-7c8cf0ca17f3', '58f38625-3132-485e-a8a6-308436e56bf2', '00888baa-1ec4-4296-8de6-64a469963b14', 4, 4, 4, 'Unique', 0, '2026-09-22 06:22:40', 0),
('a85dfe0b-398b-44aa-bcdf-aaa674affe33', '58f38625-3132-485e-a8a6-308436e56bf2', '26f0e1ee-58d1-49dc-80f5-666cc082680f', 5, 5, 5, 'Great project !', 0, '2026-09-24 05:18:08', 0),
('ac533cde-eeb5-4441-a02e-ee470501f0b8', '58f38625-3132-485e-a8a6-308436e56bf2', '80cb4213-497a-4257-825a-243b0b72df0b', 5, 5, 5, 'Amazing projects!', 0, '2026-09-24 03:18:27', 0),
('b0006e82-d4fe-4038-ad36-79bd76844aa9', '58f38625-3132-485e-a8a6-308436e56bf2', '2385bf74-ee55-482d-9dba-689532e3a949', 4, 5, 4, 'I really like the concept of this project', 0, '2026-09-23 01:41:53', 0),
('b309cd46-dc5b-4e41-bc56-4d5e1054a559', '58f38625-3132-485e-a8a6-308436e56bf2', '287e2568-a064-4fb5-868c-ed96960c5031', 4, 4, 4, 'so far it is good, Im a bit confuse at the part where in the proof navigation  from the project section where in i have not yet purchase or subscribe or something similar to it from creating this acc that part got me confuse , i do not know as a user if i should be seing the proof of others, it may lead to a misconception to me as a user like i said i just create it then i suddenly saw there are proof of payment, so far that is the only thing isee for now since i just getting started.', 0, '2026-09-25 13:42:41', 0),
('b9c037bd-5a8e-48bd-b35f-00c9b66fe51a', '58f38625-3132-485e-a8a6-308436e56bf2', '05f4c23e-a777-416d-b709-272a5ab75f9c', 5, 5, 5, 'Good', 0, '2026-09-21 12:02:08', 0),
('c54b164c-4abc-4117-96e5-20ceb2271f19', '58f38625-3132-485e-a8a6-308436e56bf2', '0124cfa7-6004-4fcf-b575-a1a8bc9c732c', 4, 3, 4, 'Maganda, and Interesting for others.. I like the interface but for recommendations, i want kasi na mag dark theme sya, but the light theme is colorful and cute...', 0, '2026-09-24 01:29:34', 0),
('ca2cbea5-ebc3-406c-86c5-3423b13be235', '58f38625-3132-485e-a8a6-308436e56bf2', '2f634388-8250-4c80-8d57-20e331c9de64', 4, 4, 4, 'Wow', 0, '2026-09-22 03:21:47', 0),
('d43f1828-27b8-42c7-935f-9c65f2e1814b', '58f38625-3132-485e-a8a6-308436e56bf2', '90f15e51-d508-4c5f-8fe1-41e5689ecaec', 5, 5, 5, 'The project contains necessary information for the students. It is good since it shows the start and end date for the project while also indicating proofs for all of the transactions.', 0, '2026-09-24 05:16:02', 0),
('d4c886a5-8bb8-45cd-a601-fd0f1aade03f', '58f38625-3132-485e-a8a6-308436e56bf2', 'b9b9ca53-1785-4170-9247-73ac4b1d28fd', 5, 5, 5, 'Great initiative and a wonderful 5th anniversary celebration for Kolehiyo ng Lungsod ng Dasmariñas!', 0, '2026-09-21 12:57:41', 0),
('d6ac01be-0dc8-4a33-b1d0-6c502a8d6086', '58f38625-3132-485e-a8a6-308436e56bf2', '0cd26c12-7d5a-4c47-94e5-4109b82c907f', 5, 5, 4, 'Good', 0, '2026-09-24 01:22:57', 0),
('e9a505f2-29ab-40bf-a238-156003ffc905', '58f38625-3132-485e-a8a6-308436e56bf2', '01e1a005-fcbf-4e5b-af03-f060d50348fa', 4, 4, 5, 'More website appearance', 0, '2026-09-22 06:46:12', 0),
('f7f8f25f-6e44-4125-98e5-e560d2726ae7', '58f38625-3132-485e-a8a6-308436e56bf2', '23e1351e-c821-4e5d-aca0-d52e7346fd9c', 4, 4, 4, 'Good', 0, '2026-09-24 05:33:05', 0),
('f9a528e9-46b4-432d-8efa-f236bbef4404', '58f38625-3132-485e-a8a6-308436e56bf2', 'ff683ee5-e4a6-44fc-9bce-e33e54dff1e9', 5, 5, 5, 'Good', 0, '2026-09-22 03:20:44', 0);

-- --------------------------------------------------------

--
-- Table structure for table `reset_password_token`
--

CREATE TABLE `reset_password_token` (
  `email` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
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
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `permission_id`, `name`, `slug`, `description`, `created_at`, `updated_at`, `archive`) VALUES
('48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10001-0000-4000-8000-000000000001', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-09-26 07:26:00', '2026-09-26 07:26:00', 0),
('5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10005-0000-4000-8000-000000000005', 'Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10005-0000-4000-8000-000000000005', 'CSG Officer', 'csg', 'Organization operations and submissions', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('d8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10001-0000-4000-8000-000000000001', 'Student', 'student', 'View, rate, and engage in projects', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10005-0000-4000-8000-000000000005', 'Super Admin', 'superadmin', 'Full system access with all permissions', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0),
('e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10005-0000-4000-8000-000000000005', 'Admin/SADU', 'admin-sadu', 'Administrator with SADU responsibilities', '2026-09-07 06:28:58', '2026-09-07 06:28:58', 0);

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
('0053282d-8532-4522-85ac-f13568113bda', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('0087ee8a-def5-488f-89cd-a0fc5236bb6f', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10023-0000-4000-8000-000000000023', NULL, '2026-09-07 06:28:58'),
('01099bfd-c0d5-4e25-be3b-cc893dc2773a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('017df2df-861a-43a7-a6dc-88b7e4b91e7d', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-27 05:49:55'),
('02e6962f-8dcf-4a8a-8433-c89ad26d0ca4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('04761010-65f2-4bea-87e7-79d7df2cb09c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('0559fa4d-b41c-4dbd-b7db-d3ac8ac11bbe', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10016-0000-4000-8000-000000000016', NULL, '2026-09-07 06:28:58'),
('063f190d-e885-4890-ae78-8b4f868cd504', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('0a84bff8-1d47-4690-8397-1f99d381e6e4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('0af362c6-35d6-43ea-a0c1-4c3830390ccb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('0b73f1ff-5db8-451a-be2e-0c896fcf02eb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('0bc05e2c-74b8-424a-9ddf-4a3299239f0a', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-09-07 06:28:58'),
('0c503b55-e59f-4545-aec4-d1b74acc047b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('0e775d08-cac7-4e7b-92a2-f7404c827fde', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-26 07:40:09'),
('1337fa04-b842-44a9-956f-14381deca634', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'f298d5a3-d2a7-4c23-97a8-289d2928069f', NULL, '2026-09-26 10:55:11'),
('1552d0d7-b2e3-4a23-9642-9259bd07d695', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('167a674b-e065-4648-a938-d906395b0d8b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('16b2830e-4837-4737-ad47-3c5e8aad3c88', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('16f05dd9-2c8f-4469-b2d8-af34d368f405', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10034-0000-4000-8000-000000000034', NULL, '2026-09-07 06:28:58'),
('172045d7-0c0a-4d7e-9fef-ee71c557c466', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('184190e7-8917-4ba4-9ec2-12b9688095ab', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('192fa005-e1fb-466e-8d8f-838d086a628b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('19c1fe07-8d7f-45f4-a886-29efdc4c1f63', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-09-07 06:28:58'),
('1beef458-bd8b-43ba-b179-60216c347485', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('1ccb7966-81e3-4beb-b7f6-bf9601228a47', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'b5624339-3f3a-439a-954f-88b2251f3b3b', NULL, '2026-09-26 10:55:11'),
('1ce12f5d-8597-47c9-980b-fbbbad689ae6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('1d43d3cd-32df-45a9-ae73-529dc1f245f4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('1e46d0fd-7504-4949-9a75-8c7be084d7e5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('1f0ff18e-44c5-4178-9dd6-2031bb21cd66', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('204629bf-22ac-49bc-b6d9-2008be5b7ef0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('20f51bb0-0a80-4008-bd58-ebe644c21ade', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('233a05d4-39df-4f45-9cb2-ba5de1aa1a55', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-09-07 06:28:58'),
('238df253-e5d0-4d97-a891-9e9a4c868e3e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('2627dac6-2e3a-4575-af55-14aa4d798002', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-09-26 07:40:09'),
('275b90e3-67eb-4406-b89f-c9106159e567', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('28d7b302-6436-46f2-ab2f-a5ae85fe837e', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('2912791c-1edf-4c60-84cb-f1a3a30bc378', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('29610cfd-6453-4004-87a7-ae117f8283ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('2a56348b-3489-4f20-b586-2bc32ffa459e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('2b2da59e-7ea2-4a92-95e6-7e700b5f6905', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('2c0620b5-78c1-4475-b910-da3353178588', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('2cd06154-2a41-496c-9e08-88f97454282b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('2dc6c27d-30bf-41d5-b7b4-0c7d95a970b7', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-07 06:28:58'),
('2ee05084-2f0a-420e-ae71-029c9a8fd03b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-07 06:28:58'),
('30f0b1ca-1ead-4394-ab9a-55320176a291', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('321675ea-877e-4383-8f71-a205d2bd4177', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10026-0000-4000-8000-000000000026', NULL, '2026-09-07 06:28:58'),
('32cdba2a-007d-4f34-aebc-bdb414fc3191', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('350670a8-a316-43d2-a12e-b508850c7b2f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('355e9ed2-acfe-44c1-baed-4e800d272a70', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-07 06:28:58'),
('35fb75e9-87f4-4f33-b53e-1479c6c1cdaf', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10031-0000-4000-8000-000000000031', NULL, '2026-09-07 06:28:58'),
('36a16e17-91da-479b-b7d4-63f1da3c9bc2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('37ba0b3a-3a06-42be-9806-0c763136eb50', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('385e4075-23c3-416f-a02a-9990db30b40a', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-07 06:28:58'),
('39ccecde-4109-48c3-a372-4a50d7c17619', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-26 07:40:09'),
('3d334b7d-6237-4149-a943-44a3368db8a7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-09-07 06:28:58'),
('404b546c-9a8a-4ada-a48f-0f5eddde987d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('40df72b3-2fdf-445b-a854-d472eb81df30', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-09-07 06:28:58'),
('4127864a-5310-40c1-823e-b3ebe5e330df', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('414c823c-9900-453b-a2a2-8bfc039fc098', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('4243d722-20e0-4145-8b5f-1152fe2ed09b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('43854f25-6082-4105-a268-d0f50b2ed03f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('4432cfca-cd70-4d46-889a-957a784f02fd', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10030-0000-4000-8000-000000000030', NULL, '2026-09-07 06:28:58'),
('44601b6d-292e-454e-bb72-2347c6e2b2b0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('47f1b8ec-ff76-426c-ae06-2f587edef635', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('484b176b-bd22-4f0f-aae6-236554645646', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10032-0000-4000-8000-000000000032', NULL, '2026-09-07 06:28:58'),
('48746929-9a1d-4385-bbc2-64579869a6b3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('4fd065ef-0cf8-4f0a-9d1b-236b38bbd368', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-09-07 06:28:58'),
('501ec411-7bef-455e-876c-fcce54f765db', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('5227c7ef-eb3d-4ea2-9a81-3d61830d35ad', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-09-07 06:28:58'),
('531403ba-699e-4765-9003-46ddd83f9349', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('53248d91-b6f8-428c-acc0-42d0c0be1071', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('53671923-8032-460c-8c07-6b894ad9ca2e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('55409249-27e1-4686-bd4b-603891abbfff', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('55ba44c8-4528-437b-a5a7-8621a5bccc20', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-27 05:49:55'),
('55fb8e79-a8ee-4125-a1b5-5560722ca175', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('562f34b2-977f-4ed2-89b0-04a0a47504d0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('571a07dd-723b-48b3-a31f-6dd131f4008f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('57f44a20-805f-4e83-9f4c-b45cdc9c8333', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-09-07 06:28:58'),
('5817777b-de8e-4f96-891d-fb21678c5e4d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('58456af2-84f7-4102-a23a-b0a60fad8fb9', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-26 07:40:09'),
('5946c0ce-ee17-4b76-a882-a6adf5f46f2e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('597fa0d8-c30e-4e92-b9fc-90398cbc9b09', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('5994e7c4-f93f-42dc-8f35-476c1e3f2275', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('59ec3916-c901-47a8-8c6f-509fae8a810f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('5ae3fafa-b5ad-423b-91b9-df24764be1f1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-09-07 06:28:58'),
('5ceb949f-8aa0-4c5c-a865-c38d175818c3', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-09-07 06:28:58'),
('5d2a53ec-ab90-4adb-aa15-857ac48094e2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('60338c73-674c-45c0-9112-bb11c42cf016', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('639318ed-4fa4-4ff3-a135-45d8a6d1e7ae', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('64aad84a-0b62-486d-9443-b59b676be3ed', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10027-0000-4000-8000-000000000027', NULL, '2026-09-07 06:28:58'),
('65f4f202-f014-4848-88c1-d5f667468f98', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('668c8f8f-7d55-4753-917b-310d000ad85a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('67d29239-74ef-48fd-921c-984c9de4faf1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('689b4b5a-c528-486a-adb4-77ca948c4913', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('68d9447e-2f72-4c11-9150-0f643549f2d4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('68f8bb2b-c499-4bf6-ad76-451a47fae7c4', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-26 10:55:11'),
('69818971-a993-424f-a20c-8a4ca493ff08', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('6b11e72e-2299-486a-8df1-b5c97300f5fa', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('6b6ac999-0d42-4ee1-a50c-1ba804e0b402', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10042-0000-4000-8000-000000000042', NULL, '2026-09-07 06:28:58'),
('6bf62d92-929b-45bd-a2b7-e2a6e054b68f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:37'),
('6d3087d1-2e16-4b86-ae7c-3b5c9a0875f6', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10040-0000-4000-8000-000000000040', NULL, '2026-09-07 06:28:58'),
('6e8f9442-d871-4bfc-a82b-678af286ce45', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('6e9fe40d-4b23-48d5-8409-b8b7717376dd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('6f20ac8c-61a5-4b26-944d-63b056e74abc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:58'),
('6f88d08a-4f60-4216-8bc6-a7b993822bfe', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('706c3c0f-9a8e-43d1-be95-c7b7e507ade0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('722fe9f8-6fcf-49d2-9ffd-138125b89e73', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-09-07 06:28:58'),
('7327c839-3468-442d-892c-1b4022eb9489', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'b5624339-3f3a-439a-954f-88b2251f3b3b', NULL, '2026-09-27 05:49:55'),
('7640c151-fcb5-4eb5-b145-61a93555c72d', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:58'),
('76beb0d8-a687-489b-b794-bcddbb7618ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10038-0000-4000-8000-000000000038', NULL, '2026-09-07 06:28:58'),
('7740b627-8f0d-4d56-bd35-49847544dcf2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('77d6909e-da81-4725-828b-e1e4df59c0c8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('79ea9d9b-940c-44f2-afe2-60b9d8451ef2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('7a0f82e2-da5a-4c53-a993-d8ba41b0dbf4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('7b95c2dc-58cb-4003-b026-9784a1aa1b4d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('7c406476-e9c0-4dc1-a1bb-93fe60a17442', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-09-07 06:28:58'),
('7d8f7c42-1ff3-40c6-9716-17a56731a14c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('7dbdd15c-0b72-423c-b767-137498c19da1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('7e440a9b-32df-4017-9045-81a900679252', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('7fab14b8-f37b-4768-af2a-e9f90d296de8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('80d202c0-9e1c-4d53-b8ff-7bf9e548628c', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-26 10:55:11'),
('80f1fe0c-9881-47c1-a0f5-9c0ea9a45a9a', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-26 10:55:11'),
('84d96b32-2add-424a-8840-94411982939b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-09-07 06:28:58'),
('87679e0d-e3a0-4840-84d7-6c5dbe6a0951', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-09-07 06:28:58'),
('878f0a7e-2ad6-4873-b1a1-d953cfa762c1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-09-07 06:28:58'),
('87b2911d-bca7-49e2-bd55-8ff0403080f7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('87fab5aa-8448-40ee-88f2-f9389673f3c7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('887d227d-3979-4c51-ac48-b7f13e3215cb', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10029-0000-4000-8000-000000000029', NULL, '2026-09-07 06:28:58'),
('8b62845a-1855-468d-98cc-23a659c4ec0f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('8cd8fb1b-5367-4211-8b0f-6ccc9d85f246', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('8cf5448f-b088-4dc8-8e76-e97f011bd287', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('8d315aa1-0ff8-465f-831c-16fb6e92ccd2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('8d4fada8-cb09-4812-a3d0-2af787ec26a5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('9127ac21-cc74-4e1a-9671-f097deebbd93', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('919bfc17-9b5b-459e-ae13-9fbe35b1b764', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('92aad513-285d-45c0-8108-7731ffe958c0', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-27 05:49:55'),
('936d5811-ffff-43c7-b90e-8ff43375ebce', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-27 05:49:55'),
('9374998e-7096-4d71-b998-4fb65d9c06c4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('93b24ad3-80df-43e5-93d3-56b056c627d2', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-26 10:55:11'),
('93f4ae10-d767-4069-ac48-a1d626fcf0d0', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-26 10:55:11'),
('95b5a53b-4694-4fcd-9d7f-51ecc5300a38', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('967cbf02-ca4e-4f10-8d1e-782909a65f5e', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-09-07 06:28:58'),
('96ccb336-73c5-47e4-a6e0-a0234ac728f7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:37'),
('986fad30-de78-4987-9634-d2a306aca9dc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('9cf8216d-b129-4b31-af93-2a0fee9e6ed0', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-26 07:40:09'),
('9ddf652a-e0f6-4373-80ec-01d334723be1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:58'),
('9e7bc473-e650-4f1f-8611-ddc10ca1d96b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('9f6b7695-1a86-45c3-bc88-a57d3c3ff69b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('9f883e03-5313-43fa-b05c-59e93be95c92', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('a026595d-c599-438e-9f92-342d83be001d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('a111aa7f-461a-46d8-968b-695a4ee442cb', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:59'),
('a155b32b-d8a1-48e5-b665-ac82a74f939d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('a479abea-a92b-4dbe-95ee-4b28e31ab044', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-09-07 06:28:58'),
('a4807a50-b00c-4951-b3e4-6a8b76b97069', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('a8813366-1075-475a-bc36-490246f467d1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-09-07 06:28:58'),
('aa0336ba-3872-4f83-9b41-a215f87ff388', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('aa83a86f-19ae-4054-afab-56b8b7605229', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('ab8aa727-fb6d-4614-96df-33c6957a3378', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('aca54b43-0b3c-4c29-8f99-54202caf423e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('ae502612-b8bc-4ff6-a57d-0880dae2509d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('b117d114-0ec1-4b8c-a933-012cfdcd33d1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('b12b3396-8282-4a3b-8f7a-7d05e2fe3085', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('b4813952-6ed4-49ee-bc4c-c10b6fcc3f1c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('b550b37a-daa8-481e-982f-b6355e205a96', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('b6218bec-5c5b-451c-a5e0-ff66bd683823', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-27 05:49:55'),
('b69f64f1-fa07-4613-8876-a946bb9a8cad', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10010-0000-4000-8000-000000000010', NULL, '2026-09-07 06:28:58'),
('b6c3fa57-a9ce-4b5c-b9be-81f796eb0163', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('b8e095ac-557a-4e14-be98-524ebdd37a69', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('babf3e37-7192-4720-b062-61d997cb484c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('bb7471fd-3752-46a8-a159-21c943b56689', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-26 10:52:21'),
('bb83f934-ec93-47f8-8f4e-709e19de267f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-09-07 06:28:58'),
('bbfbb227-302c-4b1d-a6d3-64987b7fdcdd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('bd571719-7e01-4cb3-bb9f-524afdd0c230', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-26 10:55:11'),
('bdadc49f-0b83-451a-b937-446b2f7998e3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('bf487c7c-5ff0-41f9-948f-ebba45c761bd', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-27 05:49:55'),
('bfc0e50e-d75f-4fc6-bc69-f6430ed28ea4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('c1babcad-6005-4e18-832f-1844bb2e4f43', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('c22dca2a-98f7-4b0b-82a0-64b2be0f3f60', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-26 10:54:20'),
('c432cbcd-57a0-4a3d-baf9-8b0054a069e1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('c547bc84-4193-410b-b92e-efafc7d87ea3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-09-07 06:28:58'),
('c55df8f3-8ba7-48e3-a334-7538dcdf6ff5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('c646dfbb-448c-405c-adfb-614160665f82', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('c69914e3-a6d4-4e21-9887-3b7ed97b9328', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('c7bd5abc-2e09-49b2-95a1-12fdeb5d33af', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:38'),
('c8ad2060-2a93-4298-adae-6b002eadccc8', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-09-07 06:28:58'),
('c9aae737-f3d9-4aa4-8b21-78019defbaa4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('cde4dd1c-b8fe-4bc5-b875-00b6dae6265c', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:59'),
('cfb3ea37-d51a-4c6a-b2d6-9668bc3d2c0d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('cfc8f5a2-00fc-42a7-b246-e358e3ba9db5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('d1c7d9ce-0a4b-4998-8c6f-f7a414a5ff79', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('d2284a1a-178b-4ea7-b116-57d051d215d7', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-09-07 06:28:58'),
('d4a40c01-5a16-420e-8b27-f7f3a36f2241', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('d7e05411-91cc-48c4-bd16-363f87bc23c6', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-26 07:40:09'),
('d8e49c15-d9e3-4107-9467-1f78a4508a4d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:37'),
('da2c1f4e-04bc-4698-8de2-0b6082136f6d', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10039-0000-4000-8000-000000000039', NULL, '2026-09-07 06:28:58'),
('da879acc-f8cd-4ef1-94d4-7c68d6e96043', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('daf700f4-9c46-4e8b-aa92-321a59e6ee40', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-26 08:11:28'),
('db0c4d93-d8ee-4fda-ad10-505f7df7f196', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-09-07 06:28:58'),
('dc24663d-f732-42a2-a7ee-545a103e87fd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('dd720789-a2f0-4846-af21-b800feb7f9c3', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-27 05:49:55'),
('de3c83ab-f1a3-4fcd-b094-2865f9944890', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10033-0000-4000-8000-000000000033', NULL, '2026-09-07 06:28:58'),
('deabbfce-a52f-4a40-8879-7e2215326d21', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('df34b0b8-e249-4440-9a68-cacc1e7456c8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('dfb2c5f4-9c45-4b38-b42e-a1a25fa5b680', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('dfc698fe-8a02-4ddd-822d-204e9b812da1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10041-0000-4000-8000-000000000041', NULL, '2026-09-07 06:28:58'),
('e2783f37-173a-484b-abdc-0d402b77efff', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-09-07 06:28:58'),
('e2f4c51a-6d6b-44d0-a75e-362e69597dd2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-26 10:53:59'),
('e34219d0-bf32-41b1-98ed-a28c5d74f7a4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-09-07 06:28:58'),
('e34f7bad-1422-4986-852c-16c3454cdafc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-26 10:54:33'),
('e3dfa70f-e220-4cde-8ad3-4ca1562a753c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('e51aa940-51ad-4fa9-81d1-5131e5fc2e02', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10017-0000-4000-8000-000000000017', NULL, '2026-09-07 06:28:58'),
('e5e6ed2f-ae71-4cbf-b4c6-bb118a7e28a8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-26 10:53:06'),
('e996b329-1d2d-41f6-9c25-ddff13bd34e3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-26 10:53:33'),
('e997f3f5-cf8b-440f-9890-4b7329886da5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('e99832d4-46f1-4fee-ad1d-c4a742483e25', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-26 10:52:54'),
('e9be7ca0-a0bf-473b-ab50-ef1f489c24ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10035-0000-4000-8000-000000000035', NULL, '2026-09-07 06:28:58'),
('eb60b2b4-3d24-450d-b7af-c66b4563a5f8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:38'),
('ed19f561-e705-4833-b531-3b8c99090275', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', '610ce578-e823-4977-8f79-28da28a168ae', NULL, '2026-09-27 05:49:55'),
('ee82ff9a-f242-452a-b1ad-716e5e44b8dd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-09-07 06:28:58'),
('ef32ed57-e579-465a-b879-7cfa36f1c9ba', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:58'),
('efbc8a9b-a258-43ce-a6a8-51aa527f693c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('f02a3c7d-4bc8-48a5-a3f7-6c5809f2820e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('f0688e87-fb3e-4714-b6ad-62643f28ceed', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('f154a1f6-764f-48ac-b461-b6940a9342b6', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('f1889716-f977-43fd-8bd3-90639cf67096', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10021-0000-4000-8000-000000000021', NULL, '2026-09-07 06:28:58'),
('f380bf95-e03b-4cd4-b321-65829a5b29d2', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-07 06:28:58'),
('f454a230-e809-4bf1-b780-136c331db369', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-26 10:53:18'),
('f56496d5-a379-45fe-9afc-8a0050f74658', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10043-0000-4000-8000-000000000043', NULL, '2026-09-07 06:28:58'),
('f9de92fb-f21d-4287-a4de-42c95d98a306', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-26 10:52:07'),
('fb15e6f6-ada0-42ea-a475-af42c152992c', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-07 06:28:58'),
('fbca9c0a-ca60-44a7-ac02-9167e229c95a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-26 10:53:43'),
('fbff3ea9-3387-47e2-babe-dc4774d0612a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-26 10:52:38'),
('fc24493e-7a8a-4006-9b27-52c2a2c81812', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', '610ce578-e823-4977-8f79-28da28a168ae', NULL, '2026-09-26 10:55:11'),
('fdaa8480-5a73-42b0-846c-873082077b0f', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-26 10:55:11'),
('ff04959d-0ddc-4765-a335-f14808de2fce', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10037-0000-4000-8000-000000000037', NULL, '2026-09-07 06:28:58');

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
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`, `archive`) VALUES
('2yYeeJKJ7bIPfDmHH5E6Uv2YfHNLV9VOKXpXINZV', '756b0138-bbe6-4fb8-be43-21b17361e5ec', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiUVB6Vmt1VE5POEdxREpQS0FvTk5JRzJBc3NUOVJjeGNwbTV6T0NTTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjA6Imh0dHBzOi8vc2FsbW9uLWxsYW1hLTczMjg4Ny5ob3N0aW5nZXJzaXRlLmNvbS9hZHZpc2VyL2xlZGdlciI7czo1OiJyb3V0ZSI7czoxNDoiYWR2aXNlci5sZWRnZXIiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiNzU2YjAxMzgtYmJlNi00ZmI4LWJlNDMtMjFiMTczNjFlNWVjIjt9', 1790491428, 0),
('h90IJ8uLGl8IK1kbiyOjxHHYcST04F9NLXDqhO7T', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiUFl5S3pleDdhUHN4RGgyUkZEcmlhajZldUVwZUs3blVaeHI4TWRNZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTY6Imh0dHBzOi8vc2FsbW9uLWxsYW1hLTczMjg4Ny5ob3N0aW5nZXJzaXRlLmNvbS9jc2cvbGVkZ2VyIjtzOjU6InJvdXRlIjtzOjEwOiJjc2cubGVkZ2VyIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO3M6MzY6IjhiYjBmMjJhLTY1ZjUtNDAyYy04MmE0LWQ3YTYwYjc5ZjVlOSI7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6IjUwMTZlOTE3ZDVmMzMyOWQxYWEzYzQ3NzA4YmQ0M2FhZjQzNjc3NDRlZDdlZjU1ZWJhMDU1ZGRiZWQ4YWYzYWYiO30=', 1790491117, 1),
('jNB4A6yNkfH8DKChzcOTysLBFbqnncw7RH8F1SgN', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', '123.253.51.170', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/154.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiWWNFODd0SjNDYk9NSGtma09CRXFKenFybkhXdkt6TDhmRGVSR1J4WCI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1MjoiaHR0cHM6Ly9zYWxtb24tbGxhbWEtNzMyODg3Lmhvc3RpbmdlcnNpdGUuY29tL3NhZG1pbiI7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjcwOiJodHRwczovL3NhbG1vbi1sbGFtYS03MzI4ODcuaG9zdGluZ2Vyc2l0ZS5jb20vc2FkbWluL2FyY2hpdmVkLXByb2plY3RzIjtzOjU6InJvdXRlIjtzOjI0OiJzYWRtaW4uYXJjaGl2ZWQtcHJvamVjdHMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiODJhMGU1YTEtNDBjYy00OTQwLWEzM2UtNDk2NWRhNWYxYWE4Ijt9', 1790491430, 0),
('McN3fHsChnsCVxhxsXK5ilobWbIzQap9MdWf4hgN', NULL, '203.177.59.201', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoieDNLSkNiSE5MV3FiQXdHWTgxRzg4cWVJemdkc1BXbWdGaFlRWGt2dSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czo1OToiaHR0cHM6Ly9zYWxtb24tbGxhbWEtNzMyODg3Lmhvc3RpbmdlcnNpdGUuY29tL3VzZXIvcHJvamVjdHMiO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czo1MToiaHR0cHM6Ly9zYWxtb24tbGxhbWEtNzMyODg3Lmhvc3RpbmdlcnNpdGUuY29tL2xvZ2luIjtzOjU6InJvdXRlIjtzOjU6ImxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1790486190, 0),
('qkG78Jxwjoc3i0z4OUW2wjh7Cf8BESJmDplR3ASK', NULL, '136.158.50.192', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiamtJYnZkS0ZBWVdjczZ2d2g0TTdGMjRqS1MwZjVOOXRNZjNtRGxSayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTQ6Imh0dHBzOi8vc2FsbW9uLWxsYW1hLTczMjg4Ny5ob3N0aW5nZXJzaXRlLmNvbS9jYWxsYmFjayI7czo1OiJyb3V0ZSI7czoxMzoiYXV0aC5jYWxsYmFjayI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1790487490, 0);

-- --------------------------------------------------------

--
-- Table structure for table `student_csg_officers`
--

CREATE TABLE `student_csg_officers` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `course_id` varchar(100) DEFAULT NULL,
  `is_csg` tinyint(1) NOT NULL DEFAULT 0,
  `csg_position` varchar(100) DEFAULT NULL,
  `csg_term_start` date DEFAULT NULL,
  `csg_term_end` date DEFAULT NULL,
  `csg_is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_csg_officers`
--

INSERT INTO `student_csg_officers` (`id`, `user_id`, `course_id`, `is_csg`, `csg_position`, `csg_term_start`, `csg_term_end`, `csg_is_active`, `created_at`, `updated_at`, `archive`) VALUES
('000149', '05f4c23e-a777-416d-b709-272a5ab75f9c', '6fa069d5-b9f1-439d-8b9f-522549aafb6a', 0, NULL, NULL, NULL, 1, '2026-09-21 12:00:04', '2026-09-21 12:00:04', 0),
('2023', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 1, 'President', '2026-09-14', '2027-07-19', 1, '2026-09-16 12:55:11', '2026-09-26 04:09:25', 0),
('2023 - 2 - 001156', '90f15e51-d508-4c5f-8fe1-41e5689ecaec', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 05:05:27', '2026-09-24 05:05:27', 0),
('2023-1-003135', '8c75c6db-92fb-4084-9225-3c51e695f08c', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-24 05:26:42', '2026-09-24 05:26:42', 0),
('2023-1-003170', '23e1351e-c821-4e5d-aca0-d52e7346fd9c', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-24 05:27:37', '2026-09-24 05:27:37', 0),
('2023-2-000723', 'e780674f-0e13-491f-9857-607d4977aff6', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 00:22:48', '2026-09-24 00:22:48', 0),
('2023-2-000743', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, 'Member', NULL, NULL, 0, '2026-09-16 14:01:30', '2026-09-20 15:13:10', 0),
('2023-2-000838', 'ba15f544-faf5-44bf-a36b-49ea4807b791', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 02:00:13', '2026-09-24 02:00:13', 0),
('2023-2-000869', 'd7209b69-a8e5-4b85-9cb1-5170652db325', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 07:07:12', '2026-09-24 07:07:12', 0),
('2023-2-000914', 'b11fae9b-cd1a-4cd1-95fd-66d5770a7866', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-25 13:00:42', '2026-09-25 13:00:42', 0),
('2023-2-001144', '598cf801-e6f6-447d-8706-9c5b8e86887d', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 05:26:15', '2026-09-24 05:26:15', 0),
('2023-2-001155', '26f0e1ee-58d1-49dc-80f5-666cc082680f', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 05:03:37', '2026-09-24 05:03:37', 0),
('2023-2-001170', '80cb4213-497a-4257-825a-243b0b72df0b', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 03:15:22', '2026-09-24 03:15:22', 0),
('2023-2-001219', '339d6a7f-ddc2-4687-bf06-c7a7229db720', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 03:25:59', '2026-09-24 03:25:59', 0),
('2023-2-001277', '24b92d09-4f41-4882-87be-2d7395ef2737', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-25 14:24:49', '2026-09-25 14:24:49', 0),
('2023-2-001302', '287e2568-a064-4fb5-868c-ed96960c5031', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-25 13:35:55', '2026-09-25 13:35:55', 0),
('2023-3-000456', '6613df2b-711e-4e04-b8a5-df3d5f421e61', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-23 13:03:53', '2026-09-23 13:03:53', 0),
('2024-1-000094', 'fecf41cc-142d-4038-a152-8fa34718ad37', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-22 05:52:15', '2026-09-22 05:52:15', 0),
('2024-1-000189', 'f2c4d064-6654-4cc5-99e4-094714cef15a', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-22 05:54:07', '2026-09-22 05:54:07', 0),
('2024-1-000424', '11a031e9-b7fb-42c5-b0f8-461c2e2ae827', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-22 05:16:53', '2026-09-22 05:16:53', 0),
('2024-2-000038', '45d33f04-28d9-4d27-af01-990f0a029d39', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-25 12:43:21', '2026-09-25 12:43:21', 0),
('2024-2-000263', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-22 05:51:28', '2026-09-22 05:51:28', 0),
('2024-2-000282', '9b546859-b0d4-4c1f-8489-33727c273a54', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 04:41:31', '2026-09-24 04:41:31', 0),
('2024-2-000416', '5a091b16-6fe3-43fc-8e95-9507272190de', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 04:35:41', '2026-09-24 04:35:41', 0),
('2024-3-000216', '42cba165-e218-47cb-93c9-afbcea19ecdf', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-23 12:58:42', '2026-09-23 12:58:42', 0),
('2024-3-000599', '6806b839-89e2-4d50-90c5-587313474b8a', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-23 15:57:16', '2026-09-23 15:57:16', 0),
('2025-000228', 'ff683ee5-e4a6-44fc-9bce-e33e54dff1e9', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:16:49', '2026-09-22 03:16:49', 0),
('2025-3-000222', 'b9b9ca53-1785-4170-9247-73ac4b1d28fd', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-21 12:53:21', '2026-09-21 12:53:21', 0),
('2025-3-000436', '2385bf74-ee55-482d-9dba-689532e3a949', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-23 01:38:49', '2026-09-23 01:38:49', 0),
('2025-5-000007', '2f634388-8250-4c80-8d57-20e331c9de64', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:17:00', '2026-09-22 03:17:00', 0),
('2025-5-000239', '2685f8e1-10ae-4337-a650-70bd0b45a3ba', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:16:18', '2026-09-22 03:16:18', 0),
('2025-5-000240', '952befae-6ce5-4ea7-a018-3bb3e638a90e', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:16:10', '2026-09-22 03:16:10', 0),
('2025-5-000260', '4364f571-2368-479e-8ec2-491d176c693a', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:17:35', '2026-09-22 03:17:35', 0),
('2025-5-000357', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:17:12', '2026-09-22 03:17:12', 0),
('2025-5-000362', '0acf2825-1aff-4bd5-b24b-3fd79375fd49', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:19:07', '2026-09-22 03:19:07', 0),
('2025-5-000387', 'f7ef62d5-8133-4c7e-a487-c7e000210788', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 03:18:35', '2026-09-22 03:18:35', 0),
('2026 0001', '1532c8ff-88f3-46da-8222-9df946116efa', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-22 06:39:09', '2026-09-22 06:39:09', 0),
('2026- 059724', 'b13efe11-ebdb-4b7f-aca4-d4fa6b9f78c6', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 01:03:50', '2026-09-24 01:03:50', 0),
('2026-003938', '0124cfa7-6004-4fcf-b575-a1a8bc9c732c', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 01:24:20', '2026-09-24 01:24:20', 0),
('2026-006981', '7c1c5079-05ca-4468-800c-463b24e22030', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 05:37:31', '2026-09-22 05:37:31', 0),
('2026-007138', '6350f4ad-1cf9-4f05-abb7-d318915f87ff', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 00:25:02', '2026-09-24 00:25:02', 0),
('2026-064857', '00888baa-1ec4-4296-8de6-64a469963b14', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-22 06:21:20', '2026-09-22 06:21:20', 0),
('2026-096359', '6ed430d8-5089-41c4-b5a7-28849cf5c01a', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 00:33:46', '2026-09-24 00:33:46', 0),
('71717117', '24b9b9e9-113a-400f-b154-03d50737ca72', '6fa069d5-b9f1-439d-8b9f-522549aafb6a', 0, 'Member', NULL, NULL, 0, '2026-09-21 07:02:20', '2026-09-27 04:37:11', 0),
('KLD- 2026-008365', '5e202776-9410-424f-86a0-36d9176247a4', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 06:31:31', '2026-09-24 06:31:31', 0),
('KLD-2026-009689', '0cd26c12-7d5a-4c47-94e5-4109b82c907f', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-24 01:20:18', '2026-09-24 01:20:18', 0),
('KLD-2026-028196', 'b84aa483-cba2-47d5-a150-a7cc4f638fb3', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-25 13:12:31', '2026-09-25 13:12:31', 0),
('KLD-2026-035541', '1957970f-e67f-4d9a-b773-94b81f84b937', '6fa069d5-b9f1-439d-8b9f-522549aafb6a', 0, NULL, NULL, NULL, 1, '2026-09-22 06:20:57', '2026-09-22 06:20:57', 0),
('KLS-2026-009373', '01e1a005-fcbf-4e5b-af03-f060d50348fa', '6fa069d5-b9f1-439d-8b9f-522549aafb6a', 0, NULL, NULL, NULL, 1, '2026-09-22 06:41:57', '2026-09-22 06:41:57', 0);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_adviser`
--

CREATE TABLE `teacher_adviser` (
  `id` varchar(100) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `institute_id` char(36) DEFAULT NULL,
  `is_adviser` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teacher_adviser`
--

INSERT INTO `teacher_adviser` (`id`, `user_id`, `institute_id`, `is_adviser`, `created_at`, `updated_at`, `archive`) VALUES
('06476', '3c44f438-1fe8-41bb-a29e-7dce7ba457ba', 'cb38c894-6507-44b7-8363-b7f1641da9c7', 0, '2026-09-24 01:55:17', '2026-09-26 04:09:01', 0),
('06830', '3f6576aa-c747-47c5-9f69-abe36b4ef100', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 0, '2026-09-23 01:59:26', '2026-09-23 01:59:26', 0),
('123123', '756b0138-bbe6-4fb8-be43-21b17361e5ec', 'ff598575-504d-4d1b-967c-f20faaf1377c', 1, '2026-09-26 07:39:59', '2026-09-27 04:08:39', 0);

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
  `status` enum('active','suspended','archived') NOT NULL DEFAULT 'active',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `name`, `email`, `email_verified_at`, `invitation_token`, `token_expires_at`, `is_token_expired`, `phone`, `password`, `avatar_url`, `profile_completed`, `id_verification_id`, `status`, `last_login_at`, `remember_token`, `created_at`, `updated_at`, `archive`) VALUES
('00888baa-1ec4-4296-8de6-64a469963b14', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Kyle Perlin Redoblado', 'kpredoblado@kld.edu.ph', '2026-09-22 06:20:41', NULL, NULL, 0, NULL, '$2y$12$5mTHUeB8AZVLjt0XprViV.FLkdE.QN0dcz3jv0.uoOvmYnaH4DqSK', 'https://lh3.googleusercontent.com/a/ACg8ocLC3GBgESy7b-4Sj00HRYXCbiy5WBdpnGse3coSPyUDJCaNxw=s96-c', 1, NULL, 'active', '2026-09-22 06:20:41', NULL, '2026-09-22 06:20:41', '2026-09-22 06:21:20', 0),
('0124cfa7-6004-4fcf-b575-a1a8bc9c732c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Mac Gabriel Oril', 'mgoril@kld.edu.ph', '2026-09-24 01:23:54', NULL, NULL, 0, NULL, '$2y$12$cw.09qvs8RSGY8aE.p.wOeKGAJY0QhjQy/vBcg.OO0dvqvkSKD67u', 'https://lh3.googleusercontent.com/a/ACg8ocKJuSFCCWlT1u5AjmAOt5n8p4VBVxYSoQRScTTfho_Pey3Ozg=s96-c', 1, NULL, 'active', '2026-09-24 01:23:54', NULL, '2026-09-24 01:23:54', '2026-09-24 01:24:21', 0),
('01e1a005-fcbf-4e5b-af03-f060d50348fa', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JUSTINE JOHN LUCERO', 'jjlucero@kld.edu.ph', '2026-09-22 06:41:57', NULL, NULL, 0, NULL, '$2y$12$ECnjpYAbb0L15s54gDoPqemwj..wCXbmd2wnK7cFnIJ3WIOlDOyg6', 'https://www.gravatar.com/avatar/56ba9244209a27353483437ff4c6ab09?s=400&d=identicon', 1, NULL, 'active', '2026-09-22 06:42:13', NULL, '2026-09-22 06:41:57', '2026-09-22 06:42:13', 0),
('05f4c23e-a777-416d-b709-272a5ab75f9c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Seth Ebuña', 'asebuna@kld.edu.ph', '2026-09-21 12:00:04', NULL, NULL, 0, NULL, '$2y$12$bgd/e0pu4RhMoMFByPQQ2ujgbqIOeYfjDxXuNfvm9dVCTRtsmp8T.', 'https://www.gravatar.com/avatar/1eca587cfb0b9e06c71f87a8ff5895f6?s=400&d=identicon', 1, NULL, 'active', '2026-09-21 12:00:45', NULL, '2026-09-21 12:00:04', '2026-09-21 12:00:45', 0),
('0acf2825-1aff-4bd5-b24b-3fd79375fd49', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Elijah Joyce Dela Rama Vicente', 'ejdvicente@kld.edu.ph', '2026-09-22 03:18:54', NULL, NULL, 0, NULL, '$2y$12$R9dmtDiD8TaKX/Gc2A16MOWS2QgOVA0UhzeuE7kJc018t3tiyEXCO', 'https://lh3.googleusercontent.com/a/ACg8ocK-QnpQUyLG2x_5439_Gy1NvJ-JcEfmmx4VfBp1KHeoQT_c1g=s96-c', 1, NULL, 'active', '2026-09-22 03:18:54', NULL, '2026-09-22 03:18:54', '2026-09-22 03:19:07', 0),
('0cd26c12-7d5a-4c47-94e5-4109b82c907f', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Jubber Beg', 'jbeg@kld.edu.ph', '2026-09-24 01:19:38', NULL, NULL, 0, NULL, '$2y$12$4vvIWXZAG1HcZR6zRZmo/evvbOtACH1ROX/CTGB2jADqhiwS7lFS.', 'https://lh3.googleusercontent.com/a/ACg8ocJQnFrMGbWKPLWp50bL8Z4dXLIgD0AWxCI7qnvnYws8ysvS2Q=s96-c', 1, NULL, 'active', '2026-09-24 01:19:38', NULL, '2026-09-24 01:19:38', '2026-09-24 01:20:18', 0),
('11a031e9-b7fb-42c5-b0f8-461c2e2ae827', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Justine Sedricj Ramos', 'jsramos@kld.edu.ph', '2026-09-22 05:16:53', NULL, NULL, 0, NULL, '$2y$12$qXftKlazzCZ0lToBGKpBfuHQW8yKiLxcS2lvM8echSCx6gc5jhLyy', 'https://www.gravatar.com/avatar/0b1b863bd122d3d8bc50e9da8399c8b5?s=400&d=identicon', 1, NULL, 'active', '2026-09-22 05:17:20', NULL, '2026-09-22 05:16:53', '2026-09-22 05:17:20', 0),
('1532c8ff-88f3-46da-8222-9df946116efa', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Lim H. Roque', 'limroque@kld.edu.ph', '2026-09-22 06:38:03', NULL, NULL, 0, NULL, '$2y$12$YvTPy/X0SZJ/ryWw0rRmx.R8YhVQCQ7EIvcbryDJU65WcLk6K7IFS', 'https://lh3.googleusercontent.com/a/ACg8ocKtgHu0RktT8Y72GKNooJXL5ru0WWl2-35l25v9jp2x7tQS2WE=s96-c', 1, NULL, 'active', '2026-09-22 06:38:03', NULL, '2026-09-22 06:38:03', '2026-09-22 06:39:10', 0),
('1957970f-e67f-4d9a-b773-94b81f84b937', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Earl Vincent Tecson', 'evtecson@kld.edu.ph', '2026-09-22 06:20:24', NULL, NULL, 0, NULL, '$2y$12$ydyGsL4AbJRFn1aUO8HU8.trLGFo8kVDT2xyJER/MRs5yHZUQQmvq', 'https://lh3.googleusercontent.com/a/ACg8ocIcxh2TRpKMr8sNYPP2hqeaIWirnvkkmDllrEO-BeHCJH999pg=s96-c', 1, NULL, 'active', '2026-09-22 06:20:24', NULL, '2026-09-22 06:20:24', '2026-09-22 06:20:57', 0),
('2385bf74-ee55-482d-9dba-689532e3a949', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Maria Jovie Dolorzo', 'mjdolorzo@kld.edu.ph', '2026-09-23 01:38:09', NULL, NULL, 0, NULL, '$2y$12$neT2bnFImLKKPzfk6ODlLuUWG3EzBxhPZC39e/fZ3f9R2iDZrdT4y', 'https://lh3.googleusercontent.com/a/ACg8ocITNF8pdnK1jVh8iCDvvRw7s0YYGZyW_JJQewep7Ua7vBFgnA=s96-c', 1, NULL, 'active', '2026-09-23 01:38:09', NULL, '2026-09-23 01:38:09', '2026-09-23 01:38:49', 0),
('23e1351e-c821-4e5d-aca0-d52e7346fd9c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'MARK JOSHUA DIMAS MANECLANG', 'mjdmaneclang@kld.edu.ph', '2026-09-24 05:27:01', NULL, NULL, 0, NULL, '$2y$12$6hZmPrJQSBeE38siR1rB6uHuoximpbJC7Z377PI1Pc3ixWZsTW6sG', 'https://lh3.googleusercontent.com/a/ACg8ocLNNFdxqkXsRvIep8o6PIvKtg50Ti4E0K9kOX4bzlZH-Mce5zM=s96-c', 1, NULL, 'active', '2026-09-25 13:12:23', NULL, '2026-09-24 05:27:01', '2026-09-25 13:12:23', 0),
('24b92d09-4f41-4882-87be-2d7395ef2737', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JOHN LYAN MANANSAN TUDLA', 'jlmtudla@kld.edu.ph', '2026-09-25 14:24:34', NULL, NULL, 0, NULL, '$2y$12$PWvrkvbcVLPquwjpQpyit.LM5yFZY9.L7F1k/C/V5KJ31k.EFNpdO', 'https://lh3.googleusercontent.com/a/ACg8ocJewF7xE64QGVEChnm2PeoP9pXD2GQ_gcBqqyi1sOguD19MSA=s96-c', 1, NULL, 'active', '2026-09-25 14:24:34', NULL, '2026-09-25 14:24:34', '2026-09-25 14:24:49', 0),
('24b9b9e9-113a-400f-b154-03d50737ca72', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JAMES TORILLAS TAMAYO', 'jttamayo@kld.edu.ph', '2026-09-21 07:01:23', NULL, NULL, 0, NULL, '$2y$12$I/KjxkuZyojfxtFZjdw3V.t3cw52.m/GP2IyeP5id2JDsGq9u9pPi', 'https://lh3.googleusercontent.com/a/ACg8ocJSq8gDznGQvQNLtVugx21hZN-Z40sehpu-m1mE9a1HhJkOGQ=s96-c', 1, NULL, 'active', '2026-09-27 04:34:55', NULL, '2026-09-21 07:01:23', '2026-09-27 04:37:11', 0),
('2685f8e1-10ae-4337-a650-70bd0b45a3ba', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Princess Gail Taupo Magbanua', 'pgtmagbanua@kld.edu.ph', '2026-09-22 03:15:53', NULL, NULL, 0, NULL, '$2y$12$r7WK0Y.jjXy4tYIIr.lZJ.1eabQBt1eYXI0DjNsYZHgmO5uNsB9AO', 'https://lh3.googleusercontent.com/a/ACg8ocL36T6JvxEDTsgI5xfJtbJHcreOnI3TIwDZdy9TnwfitP5B_PQ=s96-c', 1, NULL, 'active', '2026-09-22 03:15:53', NULL, '2026-09-22 03:15:53', '2026-09-22 03:16:18', 0),
('26f0e1ee-58d1-49dc-80f5-666cc082680f', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JANNA PENIT ESTOPIDO', 'jpestopido@kld.edu.ph', '2026-09-24 05:03:23', NULL, NULL, 0, NULL, '$2y$12$BTSotCADGxSEo4axscqTAud1Uu5yE.gANVRw63AhNvecCXpHouRIK', 'https://lh3.googleusercontent.com/a/ACg8ocK9hJM-jl5VmvEbYxUuQcxHr-qlei_Kdg47Pn0JDULIneG2uw=s96-c', 1, NULL, 'active', '2026-09-24 05:15:38', NULL, '2026-09-24 05:03:23', '2026-09-24 05:15:38', 0),
('287e2568-a064-4fb5-868c-ed96960c5031', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Karl Cajayon', 'kicajayon@kld.edu.ph', '2026-09-25 13:35:55', NULL, NULL, 0, NULL, '$2y$12$wUY7unp27gheUQG/d0Tqg.cLYX3LtD.EUpFFopKwtroypTa2u4XR2', 'https://www.gravatar.com/avatar/b9d9b7077b70cbf1d02cda92ef9a82d1?s=400&d=identicon', 1, NULL, 'active', '2026-09-25 13:36:05', NULL, '2026-09-25 13:35:55', '2026-09-25 13:36:05', 0),
('2f634388-8250-4c80-8d57-20e331c9de64', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Shekynah Maeley Calibuso Agapito', 'smcagapito@kld.edu.ph', '2026-09-22 03:16:42', NULL, NULL, 0, NULL, '$2y$12$8eYRXzCMGuakpLv92sehue93yhysXKHFk.6HCnRrWGoCdquVFc/Ja', 'https://lh3.googleusercontent.com/a/ACg8ocL4mNnVAL1o4uYhmyDCjaNZEL8cd4kUKak9XDkBJtXekLyTHw=s96-c', 1, NULL, 'active', '2026-09-22 03:19:41', NULL, '2026-09-22 03:16:42', '2026-09-22 03:19:41', 0),
('339d6a7f-ddc2-4687-bf06-c7a7229db720', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'ANGELO RUSSEL BANDONG BAGUIO JR.', 'arbbaguiojr@kld.edu.ph', '2026-09-24 03:25:30', NULL, NULL, 0, NULL, '$2y$12$iwutsgtG6UAUWyJVeJgltOANefLIx8SUNAUXwfYCX6ZStVIWg3fr.', 'https://lh3.googleusercontent.com/a/ACg8ocJK4dQk-FTc4rFGsGJZm6PmNAJiD6f0yLbhzSolgDbIOSonug=s96-c', 1, NULL, 'active', '2026-09-24 03:25:30', NULL, '2026-09-24 03:25:30', '2026-09-24 03:26:00', 0),
('3c44f438-1fe8-41bb-a29e-7dce7ba457ba', NULL, 'Eunice Luching', 'sadu@kld.edu.ph', '2026-09-24 01:55:17', NULL, NULL, 0, NULL, '$2y$12$7JQuf3S0/5axaD0Qm2HuFuoViXN7am7NmUid4CMuxwlTLwMAGFmCa', 'https://lh3.googleusercontent.com/a/ACg8ocKDvItr9lsMQ6qKuqOU9RVdXw3FqLr8e2wP2FHkjTa1xIKqYQ=s96-c', 1, NULL, 'active', '2026-09-24 01:55:45', NULL, '2026-09-24 01:52:06', '2026-09-26 04:09:01', 0),
('3f6576aa-c747-47c5-9f69-abe36b4ef100', NULL, 'MARK CHRISTOPHER BORJA', 'mcborja@kld.edu.ph', '2026-09-23 01:59:26', NULL, NULL, 0, NULL, '$2y$12$7.saGza8LjQNqRm8wXXKw.jWKve2uvCotgKNV6nho66Khe62fIs8a', NULL, 1, NULL, 'active', NULL, NULL, '2026-09-23 01:57:53', '2026-09-23 01:59:26', 0),
('42cba165-e218-47cb-93c9-afbcea19ecdf', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Andrea De Ocampo', 'adeocampo@kld.edu.ph', '2026-09-23 12:58:25', NULL, NULL, 0, NULL, '$2y$12$xeMYRY1JD.aZCCbNZ2mE3OOaUTpzDgKxcfJuA7BL9bLHZQcS0dY1O', 'https://lh3.googleusercontent.com/a/ACg8ocKOG-myMCVtO6DbcXPrEf6y6lnk1NgK4mPmoZjjecjxQJ89BVqt=s96-c', 1, NULL, 'active', '2026-09-23 12:58:25', NULL, '2026-09-23 12:58:25', '2026-09-23 12:58:42', 0),
('4364f571-2368-479e-8ec2-491d176c693a', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Mark Ryan Pacoma Mendoza', 'mrpmendoza@kld.edu.ph', '2026-09-22 03:17:18', NULL, NULL, 0, NULL, '$2y$12$QKEYSYBoH/LpWUT9DbUWSu96qLWAFzuQNtv85XTi5bweCpGocqZO6', 'https://lh3.googleusercontent.com/a/ACg8ocJnDAc8wqPAWJdblKK_yEe3sSjWN67IDj45MU2SWzecrO51-zI=s96-c', 1, NULL, 'active', '2026-09-22 03:18:49', NULL, '2026-09-22 03:17:18', '2026-09-22 03:18:49', 0),
('45d33f04-28d9-4d27-af01-990f0a029d39', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Sherwin Samonte', 'ssamonte@kld.edu.ph', '2026-09-25 12:42:45', NULL, NULL, 0, NULL, '$2y$12$4mf9MCcLHtnvtN47YHJgDeT9j9ErnOOVXIwUv/dXQqfXUyBrvB1WO', 'https://lh3.googleusercontent.com/a/ACg8ocJPOlnACnpmsNYAdnBzJRH9XrfQX4zUl_8ePobijjB53exvVQ=s96-c', 1, NULL, 'active', '2026-09-25 12:42:45', NULL, '2026-09-25 12:42:45', '2026-09-25 12:43:21', 0),
('54ae97c2-c473-4975-aacc-d44d84591628', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Juris Inocencio', 'jinocencio@kld.edu.ph', '2026-09-21 11:22:35', NULL, NULL, 0, NULL, '$2y$12$7qyJfAct44vzZmXiTAlzgOcqdd4wiAJe3UCjohDVeQgAQlWBvpYOO', 'https://lh3.googleusercontent.com/a/ACg8ocIby9qdcX6PW9K1m_Cw06USwQgsonYYZfOtULrTOSf0Ieyw0hU=s96-c', 1, NULL, 'active', '2026-09-21 11:22:35', NULL, '2026-09-21 11:22:35', '2026-09-21 11:22:40', 0),
('598cf801-e6f6-447d-8706-9c5b8e86887d', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JANICA CURSTINE SILVA BAÑES', 'jcsbanes@kld.edu.ph', '2026-09-24 05:25:59', NULL, NULL, 0, NULL, '$2y$12$6liIUq.L0W./E4aqTZW1COCYwtgEiYrIDQPYTRlNgil1yQ8XBwKXW', 'https://lh3.googleusercontent.com/a/ACg8ocKE6Oni1MP1v2WYDmEG6OXHTdJffJrmPIUbZh_J4-kyCSmKTw=s96-c', 1, NULL, 'active', '2026-09-24 05:25:59', NULL, '2026-09-24 05:25:59', '2026-09-24 05:26:15', 0),
('5a091b16-6fe3-43fc-8e95-9507272190de', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Mark Jayson Cayanan', 'mjcayanan@kld.edu.ph', '2026-09-24 04:35:19', NULL, NULL, 0, NULL, '$2y$12$Fwgvs0Lflr9UcKiHXcGFhOoTO.O9DutSEoqdZoZyaazxUYylFWXlu', 'https://lh3.googleusercontent.com/a/ACg8ocK0jVrh-JfPoOO5nw3sDAIObrSVeioKg-G6i1sYuHkMd7eMUDs=s96-c', 1, NULL, 'active', '2026-09-24 04:35:19', NULL, '2026-09-24 04:35:19', '2026-09-24 04:35:42', 0),
('5e202776-9410-424f-86a0-36d9176247a4', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Ysabela Stef Quintos', 'ysquintos@kld.edu.ph', '2026-09-24 06:31:11', NULL, NULL, 0, NULL, '$2y$12$1/HvO/6CkUX6QNrbBtMgIehNtQ0VLlyKTnpOgznLYYNvF3BcS/qai', 'https://lh3.googleusercontent.com/a/ACg8ocIZODMj3qm_7EiSQ6cNJpVauXRta3yS5rkqsR3pYTpQh8UWvuQ=s96-c', 1, NULL, 'active', '2026-09-24 06:31:11', NULL, '2026-09-24 06:31:11', '2026-09-24 06:31:31', 0),
('5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Alexander Sarita', 'asarita@kld.edu.ph', '2026-09-22 05:51:11', NULL, NULL, 0, NULL, '$2y$12$gA.qHbTgOAL.Vi.dVO.07uZaVFQfoiVoRn8J.37iwNOBmPjQUVimi', 'https://lh3.googleusercontent.com/a/ACg8ocIcwtrGYcXyQ4wdw8x_QZ3QtOth9bnWL0vFyj6pM15abN4bBeE=s96-c', 1, NULL, 'active', '2026-09-22 05:51:11', NULL, '2026-09-22 05:51:11', '2026-09-22 05:51:29', 0),
('6350f4ad-1cf9-4f05-abb7-d318915f87ff', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Andrei Genobisa', 'agenobisa@kld.edu.ph', '2026-09-24 00:24:48', NULL, NULL, 0, NULL, '$2y$12$szD.viTB.mhZ86saYxg/AOG3D3gjcoKaZlyzZjo7ptDRzbTQwy4U.', 'https://lh3.googleusercontent.com/a/ACg8ocKqYYKhbDDEeEyGy1XAsMh-IQlFAHNhThTS91UM77S9-dtqSg=s96-c', 1, NULL, 'active', '2026-09-24 00:24:48', NULL, '2026-09-24 00:24:48', '2026-09-24 00:25:02', 0),
('6613df2b-711e-4e04-b8a5-df3d5f421e61', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'SOPHIA DIANNE GONZALES AZURO', 'sdgazuro@kld.edu.ph', '2026-09-23 13:03:30', NULL, NULL, 0, NULL, '$2y$12$WIyYf.UCAesKroBqldXekuZ.y.QoKvOdNpFnhsNMxIUckEY0hbKAq', 'https://lh3.googleusercontent.com/a/ACg8ocJmKr85SAB4CaQ9iCrahY0BbEHeqFoUXe5t4tuH82iDyVu9gtc=s96-c', 1, NULL, 'active', '2026-09-23 13:03:30', NULL, '2026-09-23 13:03:30', '2026-09-23 13:03:53', 0),
('6806b839-89e2-4d50-90c5-587313474b8a', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Alanis Bayalan', 'abayalan@kld.edu.ph', '2026-09-23 15:57:03', NULL, NULL, 0, NULL, '$2y$12$bCjr/V5BX2a5UijOFoUCZ.FCvgqK37VCBzX9LCcFEW2MUmCvQjxH6', 'https://lh3.googleusercontent.com/a/ACg8ocJ4kVN-_mAhHHhoN8fTGMBmtxnveIdxF3sdNi1hMJoIcplEJg=s96-c', 1, NULL, 'active', '2026-09-23 15:57:03', NULL, '2026-09-23 15:57:03', '2026-09-23 15:57:16', 0),
('6ed430d8-5089-41c4-b5a7-28849cf5c01a', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Lawrence Javier', 'ljavier@kld.edu.ph', '2026-09-24 00:33:18', NULL, NULL, 0, NULL, '$2y$12$SeQSKeKAJbSDKwDEn7usUeFHUtq1AHBBCe.Cm0osZCW8WZCQVFvES', 'https://lh3.googleusercontent.com/a/ACg8ocJontHmzLugQI3283FSLMKXe4ZpPq4Xx7y3I2htDicGbf0jdLE=s96-c', 1, NULL, 'active', '2026-09-24 00:33:18', NULL, '2026-09-24 00:33:18', '2026-09-24 00:33:46', 0),
('756b0138-bbe6-4fb8-be43-21b17361e5ec', '5124691a-b33f-4697-9c1a-d1701e22e31a', 'JANI SUMULONG', 'jmsumulong@kld.edu.ph', '2026-09-26 07:39:59', NULL, NULL, 0, '09345254435', '$2y$12$vbKxZVflfW7iobXXnfxBhu7CmShSltxh6yK1J0UjJuWhs5ov8vMkm', 'https://lh3.googleusercontent.com/a/ACg8ocLXVrWI7RGw1OTDRtjF9lXO27fk8oBLR-ZI3irgbXl_7fS5sA=s96-c', 1, NULL, 'active', '2026-09-27 05:20:55', NULL, '2026-09-26 07:38:24', '2026-09-27 05:20:55', 0),
('7c1c5079-05ca-4468-800c-463b24e22030', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Karel Pormatelo', 'kcpormatelo@kld.edu.ph', '2026-09-22 05:37:00', NULL, NULL, 0, NULL, '$2y$12$Q5qEigSAyUldV3ECzapDgOBpeUirswzfVXzUIeIoIrXCICkcRfm26', 'https://lh3.googleusercontent.com/a/ACg8ocK50TqQHEsXdTPZYsWv9Azt9b9NM_W6YmqRyOdTmTciwq9EWA=s96-c', 1, NULL, 'active', '2026-09-22 05:37:00', NULL, '2026-09-22 05:37:00', '2026-09-22 05:37:31', 0),
('80cb4213-497a-4257-825a-243b0b72df0b', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'ASHLEY JANE IMPERIAL ADIZAS', 'ajiadizas@kld.edu.ph', '2026-09-24 03:15:07', NULL, NULL, 0, NULL, '$2y$12$I6n065UnPqwzSgKQ05bwheNcxN516IyPTklmHYnybqpTLwZYk.Kfy', 'https://lh3.googleusercontent.com/a/ACg8ocI2OQj1Xr9g1bt6P882RQi92qhcfrcMZb4fL0NVMi4b_g9PSw=s96-c', 1, NULL, 'active', '2026-09-24 03:15:07', NULL, '2026-09-24 03:15:07', '2026-09-24 03:15:22', 0),
('82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'STEP Super Admin', 'superadmin@kld.edu.ph', '2026-09-07 06:28:59', NULL, NULL, 0, NULL, '$2y$12$3LoIn2J5DvBdb.et1cD0h.FgZLLZda0F8OxULsSd3vDAo.B83wQPi', NULL, 0, NULL, 'active', '2026-09-27 04:36:03', NULL, '2026-09-07 06:28:59', '2026-09-27 04:36:03', 0),
('8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '86e5aeee-043c-4b27-af63-4a396ee956f6', 'Edward Quintos', 'emdgquintos@kld.edu.ph', '2026-09-16 12:54:50', NULL, NULL, 0, NULL, '$2y$12$lOSPq.3OFDlYiTDtQ5do9O32ZGt1h0kOFOqE9IzeF3bPA2oJNoW4C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, NULL, 'active', '2026-09-27 04:38:59', NULL, '2026-09-16 12:54:50', '2026-09-27 04:38:59', 0),
('8c75c6db-92fb-4084-9225-3c51e695f08c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'DAVID ZAIDE CANON', 'dzcanon@kld.edu.ph', '2026-09-24 05:26:28', NULL, NULL, 0, NULL, '$2y$12$7Z79.ivDGCA37xPIn97QbebwTYI4XAilmpksP9sXEP0CPtqGIWTHO', 'https://lh3.googleusercontent.com/a/ACg8ocKF76c9vwyolUVIoVB54FkFPdaNsfksflEfZKCPr9f1W0YXi-0=s96-c', 1, NULL, 'active', '2026-09-24 05:26:28', NULL, '2026-09-24 05:26:28', '2026-09-24 05:26:42', 0),
('90f15e51-d508-4c5f-8fe1-41e5689ecaec', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JONALYN MOSNE ORTEGA', 'jmortega@kld.edu.ph', '2026-09-24 05:05:10', NULL, NULL, 0, NULL, '$2y$12$gJJf93oXIbtWabvjnl1aNeWQb1W3JQYQdYBUTm.l18UIAmGsHozfe', 'https://lh3.googleusercontent.com/a/ACg8ocIbEw2UWYgak0EFzx21Y-E-1alUvnNGCm9rqObzUByCysPPRGMf=s96-c', 1, NULL, 'active', '2026-09-24 05:05:10', NULL, '2026-09-24 05:05:10', '2026-09-24 05:05:27', 0),
('952befae-6ce5-4ea7-a018-3bb3e638a90e', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Amira Joanne Punzalan Magnanao', 'ajpmagnanao@kld.edu.ph', '2026-09-22 03:15:55', NULL, NULL, 0, NULL, '$2y$12$vRixX5thvjltQPwtnHiz9uu5cOkOmlclSzHSnKPV5Go9rG59sXxMK', 'https://lh3.googleusercontent.com/a/ACg8ocIZD8UvXPMvcIUwaGl9KZW9nHN5cB2L9tM34GcRDk4yEpue5w=s96-c', 1, NULL, 'active', '2026-09-22 03:16:25', NULL, '2026-09-22 03:15:55', '2026-09-22 03:16:25', 0),
('9b546859-b0d4-4c1f-8489-33727c273a54', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Hakim Cosain', 'hcosain@kld.edu.ph', '2026-09-24 04:41:11', NULL, NULL, 0, NULL, '$2y$12$UTIQnUE1bkbB1tkdY82nwuIHZIhhdbSrOkSJx/7hs6bxdNYt6VcqK', 'https://lh3.googleusercontent.com/a/ACg8ocI46sMGn80yb-YvgqC-N29Z7QbhCVLF2ll-X19F3pyumxvD7Q=s96-c', 1, NULL, 'active', '2026-09-24 04:41:11', NULL, '2026-09-24 04:41:11', '2026-09-24 04:41:31', 0),
('b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Lawrence Calibuso', 'lpcalibuso@kld.edu.ph', '2026-09-16 14:01:10', NULL, NULL, 0, NULL, '$2y$12$hn.5Ddz45q0h1jggkgyUhuwQq/kGXxPJpQ4tZEtUnIOScHjHe5NgK', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, NULL, 'active', '2026-09-27 05:16:05', NULL, '2026-09-16 14:01:10', '2026-09-27 05:16:05', 0),
('b11fae9b-cd1a-4cd1-95fd-66d5770a7866', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'VINCE ZYRUS RAPANAN PACIJA', 'vzrpacija@kld.edu.ph', '2026-09-25 13:00:27', NULL, NULL, 0, NULL, '$2y$12$MyM/rbe7UxwV1XB46LS/VuXSj4/3NEThHBe4LcYWTRZKga5TR3ZWO', 'https://lh3.googleusercontent.com/a/ACg8ocJGido6UXa-cnuC6RJaREC68PRetS0I3RvziHPRupmvFv2empZT=s96-c', 1, NULL, 'active', '2026-09-25 13:01:08', NULL, '2026-09-25 13:00:27', '2026-09-25 13:01:08', 0),
('b13efe11-ebdb-4b7f-aca4-d4fa6b9f78c6', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Ivan Frondozo', 'ibfrondozo@kld.edu.ph', '2026-09-24 01:03:10', NULL, NULL, 0, NULL, '$2y$12$N5vyu589uZAYLdPiaRgG/uOTN7RHH.DKUjgEi7kTKmatExFKFnti6', 'https://lh3.googleusercontent.com/a/ACg8ocJ4SLuvMSI6AOhCaGKB96MyQmT9JmvOIEMXlSKzB5r5p97kBQ=s96-c', 1, NULL, 'active', '2026-09-24 01:03:10', NULL, '2026-09-24 01:03:10', '2026-09-24 01:03:50', 0),
('b84aa483-cba2-47d5-a150-a7cc4f638fb3', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Hans Pangilinan', 'hcpangilinan@kld.edu.ph', '2026-09-25 13:12:31', NULL, NULL, 0, NULL, '$2y$12$92N5HYexjzTW497habxuZu4LUWT4Ooe8xvVxhdGqmXs8adqkopkFW', 'https://www.gravatar.com/avatar/b152b6df158c9f08717c67e1439dd4d7?s=400&d=identicon', 1, NULL, 'active', '2026-09-25 13:13:32', NULL, '2026-09-25 13:12:31', '2026-09-25 13:13:32', 0),
('b9b9ca53-1785-4170-9247-73ac4b1d28fd', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Cathlene Latoja', 'clatoja@kld.edu.ph', '2026-09-21 12:52:57', NULL, NULL, 0, NULL, '$2y$12$iHQJsPi7p3NIBMBddKK0redweCYJabtHWjkHLa7/Xd848RMuEQatC', 'https://lh3.googleusercontent.com/a/ACg8ocLMtkpFvrS_W2-gJfjTg5bb-q5WAv9i9tB7dMqAwHQgcE969A=s96-c', 1, NULL, 'active', '2026-09-21 12:52:57', NULL, '2026-09-21 12:52:57', '2026-09-21 12:53:21', 0),
('ba15f544-faf5-44bf-a36b-49ea4807b791', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JOHN MICHAEL ELERIA LLACER', 'jmellacer@kld.edu.ph', '2026-09-24 01:59:59', NULL, NULL, 0, NULL, '$2y$12$qLU7UUUzuFsPGt8sce5l7u6UucFbMyzIrKrqjVJ7KCmp7XfgE1bBS', 'https://lh3.googleusercontent.com/a/ACg8ocJsL_EAmA1dTq22Y5cl6OB68aIVzzONGhTeXdzF2z83Pqgzjw=s96-c', 1, NULL, 'active', '2026-09-24 02:00:41', NULL, '2026-09-24 01:59:59', '2026-09-24 02:00:41', 0),
('ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Laurence Raff Dacanay Valentino', 'lrdvalentino@kld.edu.ph', '2026-09-22 03:16:54', NULL, NULL, 0, NULL, '$2y$12$R7J8KtNsMk323KzzR6rDZOEdAf2Qu6k/aBHNlfK2aYGkQRFjDzMJ2', 'https://lh3.googleusercontent.com/a/ACg8ocKLiowmaeYfDBOxoCHNJBJzCcW3RGjEutlnO-cCpbOOemJdWA=s96-c', 1, NULL, 'active', '2026-09-22 03:17:28', NULL, '2026-09-22 03:16:54', '2026-09-22 03:17:28', 0),
('d7209b69-a8e5-4b85-9cb1-5170652db325', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JANE ROSE MARAÑA TADEO', 'jrmtadeo@kld.edu.ph', '2026-09-24 07:07:01', NULL, NULL, 0, NULL, '$2y$12$Yxca0fRpbYNE6QOoJE/Zk.E6JZGYOycpioQ8pVzutMeBn2tDAt7U2', 'https://lh3.googleusercontent.com/a/ACg8ocKUlBkKQypIfOpNJAQLDYkjTOjle7byuxJUkgPjrcXuZkzitQ=s96-c', 1, NULL, 'active', '2026-09-24 07:07:01', NULL, '2026-09-24 07:07:01', '2026-09-24 07:07:12', 0),
('e780674f-0e13-491f-9857-607d4977aff6', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JOHN MARK SAMORIN TIANGCO', 'jmstiangco@kld.edu.ph', '2026-09-24 00:22:04', NULL, NULL, 0, NULL, '$2y$12$lX6QsgEoFxxhpmJzPmdPauV2t4gPr6Ja90SS6W31acflh7eFbkxdG', 'https://lh3.googleusercontent.com/a/ACg8ocIwj5VjEKLEZhRPx5xdGDh_q1SYKL7V8KmZTW59o3hrIhAiL1E=s96-c', 1, NULL, 'active', '2026-09-24 00:22:04', NULL, '2026-09-24 00:22:04', '2026-09-24 00:22:48', 0),
('f2c4d064-6654-4cc5-99e4-094714cef15a', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Junaima Mangondaya', 'jmangodaya@kld.edu.ph', '2026-09-22 05:53:49', NULL, NULL, 0, NULL, '$2y$12$kwnz/97OcsLXF2MQZLCkG.jh/fYWiOMKT9D4fAan73advf6OmEOL6', 'https://lh3.googleusercontent.com/a/ACg8ocIGEsrroXbCZ50PkYMBmlL1y9_ugO9YETNh6W1yf3DR-qSskcY=s96-c', 1, NULL, 'active', '2026-09-22 05:55:12', NULL, '2026-09-22 05:53:49', '2026-09-22 05:55:12', 0),
('f7ef62d5-8133-4c7e-a487-c7e000210788', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Ian Jay Diamante Longos', 'ijdlongos@kld.edu.ph', '2026-09-22 03:18:12', NULL, NULL, 0, NULL, '$2y$12$3IxNeKDOR/22vjB9N6Gn3OtHZ6F6/kAr8VoV9xEA4BYFjxABeB4Zq', 'https://lh3.googleusercontent.com/a/ACg8ocK_L9YjGvak52j7LUHCD69dDWyjBdoiVUeKEUBqwd57du-HWSY=s96-c', 1, NULL, 'active', '2026-09-22 03:19:17', NULL, '2026-09-22 03:18:12', '2026-09-22 03:19:17', 0),
('fecf41cc-142d-4038-a152-8fa34718ad37', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Nilo Madridano', 'nmadridano@kld.edu.ph', '2026-09-22 05:51:48', NULL, NULL, 0, NULL, '$2y$12$N/7N8rC0tQQRykqQF5tKYufdpczGuIPUYv4ew5LgkRukB/09qRw3a', 'https://lh3.googleusercontent.com/a/ACg8ocLUpqkdNUheUNb5s0RyrDOwpeXewuaqaQXrJjv23hmDh_3msi0=s96-c', 1, NULL, 'active', '2026-09-22 05:51:48', NULL, '2026-09-22 05:51:48', '2026-09-22 05:52:16', 0),
('ff683ee5-e4a6-44fc-9bce-e33e54dff1e9', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Valerie Tadeos Lomarda', 'vtlomarda@kld.edu.ph', '2026-09-22 03:16:32', NULL, NULL, 0, NULL, '$2y$12$3Rg90XFnTT..8USsVB5BAeiTWzmQi9CmKZFNRZGBhThpWblje86lu', NULL, 1, NULL, 'active', '2026-09-22 03:16:32', NULL, '2026-09-22 03:16:32', '2026-09-22 03:16:50', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approval`
--
ALTER TABLE `approval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `approval_employee_id_foreign` (`employee_id`),
  ADD KEY `approval_project_id_foreign` (`project_id`);

--
-- Indexes for table `assets`
--
ALTER TABLE `assets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `assets_status_archive_index` (`status`,`archive`),
  ADD KEY `assets_source_ledger_entry_id_foreign` (`source_ledger_entry_id`),
  ADD KEY `assets_project_id_foreign` (`project_id`);

--
-- Indexes for table `asset_disposals`
--
ALTER TABLE `asset_disposals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `asset_disposals_asset_id_index` (`asset_id`),
  ADD KEY `asset_disposals_source_ledger_entry_id_index` (`source_ledger_entry_id`),
  ADD KEY `asset_disposals_disposed_by_foreign` (`disposed_by`);

--
-- Indexes for table `asset_usages`
--
ALTER TABLE `asset_usages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `asset_usages_asset_id_ledger_entry_id_unique` (`asset_id`,`ledger_entry_id`),
  ADD KEY `asset_usages_project_id_status_index` (`project_id`,`status`),
  ADD KEY `asset_usages_ledger_entry_id_foreign` (`ledger_entry_id`),
  ADD KEY `asset_usages_returned_by_foreign` (`returned_by`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_foreign` (`user_id`);

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
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `chain`
--
ALTER TABLE `chain`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chain_project_id_foreign` (`project_id`);

--
-- Indexes for table `concern`
--
ALTER TABLE `concern`
  ADD PRIMARY KEY (`id`),
  ADD KEY `concern_user_id_index` (`user_id`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_institute_id_foreign` (`institute_id`);

--
-- Indexes for table `date_change_requests`
--
ALTER TABLE `date_change_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date_change_requests_project_id_foreign` (`project_id`),
  ADD KEY `date_change_requests_requested_by_foreign` (`requested_by`),
  ADD KEY `date_change_requests_reviewed_by_foreign` (`reviewed_by`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `id_verifications`
--
ALTER TABLE `id_verifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_verifications_student_id_index` (`student_id`),
  ADD KEY `id_verifications_teacher_id_index` (`teacher_id`),
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
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ledger_entries`
--
ALTER TABLE `ledger_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ledger_entries_project_id_foreign` (`project_id`),
  ADD KEY `ledger_entries_approved_by_foreign` (`approved_by`),
  ADD KEY `ledger_entries_created_by_foreign` (`created_by`),
  ADD KEY `ledger_entries_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `meeting`
--
ALTER TABLE `meeting`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meeting_student_id_foreign` (`student_id`);

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
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD PRIMARY KEY (`notification_id`,`user_id`),
  ADD KEY `notification_reads_user_id_foreign` (`user_id`);

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
  ADD KEY `projects_student_id_foreign` (`student_id`);

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
  ADD KEY `ratings_user_id_foreign` (`user_id`);

--
-- Indexes for table `reset_password_token`
--
ALTER TABLE `reset_password_token`
  ADD PRIMARY KEY (`email`),
  ADD KEY `reset_password_token_user_id_foreign` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `roles_permission_id_foreign` (`permission_id`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_permission_user_id_foreign` (`user_id`),
  ADD KEY `role_permission_role_id_foreign` (`role_id`),
  ADD KEY `role_permission_permission_id_foreign` (`permission_id`),
  ADD KEY `role_permission_position_id_foreign` (`position_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_foreign` (`user_id`);

--
-- Indexes for table `student_csg_officers`
--
ALTER TABLE `student_csg_officers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_csg_officers_user_id_foreign` (`user_id`),
  ADD KEY `student_csg_officers_course_id_foreign` (`course_id`);

--
-- Indexes for table `teacher_adviser`
--
ALTER TABLE `teacher_adviser`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_adviser_user_id_foreign` (`user_id`),
  ADD KEY `teacher_adviser_institute_id_foreign` (`institute_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_invitation_token_unique` (`invitation_token`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_id_verification_id_foreign` (`id_verification_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

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
  ADD CONSTRAINT `approval_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `teacher_adviser` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `approval_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `assets`
--
ALTER TABLE `assets`
  ADD CONSTRAINT `assets_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assets_source_ledger_entry_id_foreign` FOREIGN KEY (`source_ledger_entry_id`) REFERENCES `ledger_entries` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `asset_disposals`
--
ALTER TABLE `asset_disposals`
  ADD CONSTRAINT `asset_disposals_disposed_by_foreign` FOREIGN KEY (`disposed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `asset_usages`
--
ALTER TABLE `asset_usages`
  ADD CONSTRAINT `asset_usages_asset_id_foreign` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `asset_usages_ledger_entry_id_foreign` FOREIGN KEY (`ledger_entry_id`) REFERENCES `ledger_entries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `asset_usages_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `asset_usages_returned_by_foreign` FOREIGN KEY (`returned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `badge_collected`
--
ALTER TABLE `badge_collected`
  ADD CONSTRAINT `badge_collected_badge_id_foreign` FOREIGN KEY (`badge_id`) REFERENCES `badge` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `badge_collected_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `chain`
--
ALTER TABLE `chain`
  ADD CONSTRAINT `chain_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_institute_id_foreign` FOREIGN KEY (`institute_id`) REFERENCES `institute` (`id`) ON DELETE CASCADE;

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
  ADD CONSTRAINT `ledger_entries_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ledger_entries_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ledger_entries_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ledger_entries_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `meeting`
--
ALTER TABLE `meeting`
  ADD CONSTRAINT `meeting_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `student_csg_officers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notification_reads`
--
ALTER TABLE `notification_reads`
  ADD CONSTRAINT `notification_reads_notification_id_foreign` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notification_reads_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `projects_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `student_csg_officers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `push_subscriptions`
--
ALTER TABLE `push_subscriptions`
  ADD CONSTRAINT `push_subscriptions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reset_password_token`
--
ALTER TABLE `reset_password_token`
  ADD CONSTRAINT `reset_password_token_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permission_position_id_foreign` FOREIGN KEY (`position_id`) REFERENCES `position` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `role_permission_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permission_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_csg_officers`
--
ALTER TABLE `student_csg_officers`
  ADD CONSTRAINT `student_csg_officers_course_id_foreign` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_csg_officers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_adviser`
--
ALTER TABLE `teacher_adviser`
  ADD CONSTRAINT `teacher_adviser_institute_id_foreign` FOREIGN KEY (`institute_id`) REFERENCES `institute` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `teacher_adviser_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_id_verification_id_foreign` FOREIGN KEY (`id_verification_id`) REFERENCES `id_verifications` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
