-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 24, 2026 at 07:05 PM
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
('5ac1b075-5775-4e9d-86df-4d9dde21894b', 'eaa08fc7-b66c-43d4-9e9f-c72dfb589230', '58f38625-3132-485e-a8a6-308436e56bf2', 'laptop', 'Electronic Devices', 'qwerty', 2, 2, 100.00, 'available', 0, '2026-09-24 06:51:07', '2026-09-24 06:52:00'),
('b0afb364-8905-4a7a-a351-7bcda0d732f9', '356b4022-a468-4372-9d7e-da357efb67cf', '924bb23e-8fe1-4c25-b238-124ac11daec3', 'Laptop', 'Electronic Devices', 'Laptop purchase', 2, 0, 1500.00, 'unavailable', 0, '2026-09-24 07:08:35', '2026-09-24 07:08:35');

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
('14db72f0-2f29-414d-ac34-25ded50cbc37', '5ac1b075-5775-4e9d-86df-4d9dde21894b', '58f38625-3132-485e-a8a6-308436e56bf2', 'eaa08fc7-b66c-43d4-9e9f-c72dfb589230', 2, 'returned', '2026-09-24 06:51:07', 2, '2026-09-24 06:52:00', NULL, '2026-09-24 06:51:07', '2026-09-24 06:52:00'),
('abf4f6bd-aa4c-4646-8fd1-f24b462d4607', 'b0afb364-8905-4a7a-a351-7bcda0d732f9', '924bb23e-8fe1-4c25-b238-124ac11daec3', '356b4022-a468-4372-9d7e-da357efb67cf', 2, 'assigned', '2026-09-24 07:08:35', 0, NULL, NULL, '2026-09-24 07:08:35', '2026-09-24 07:08:35');

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
('09781517-4b5f-45cd-89de-f05d8ff19570', 'bb139edb-de27-4548-bdb2-31e06d701716', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Approved', 'ledger', 'approve', NULL, 'test — KLD FOUNDATION WEEK 2025 (sample1)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 08:59:08', 0),
('11cf5109-05bb-4084-adbf-befc14c51a54', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:1:4823', NULL, NULL, '2026-09-22 23:29:46', 0),
('18fde0da-77d3-4aa8-aede-bdc33a4cf24c', 'bb139edb-de27-4548-bdb2-31e06d701716', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'test — TEST', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:09:29', 0),
('238926f5-c708-40b2-a131-8ded74c5fe32', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '58f38625-3132-485e-a8a6-308436e56bf2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"KLD FOUNDATION WEEK 2025 (sample1)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 07:55:00', 0),
('29080b6f-caae-4c02-81ca-e647f9187043', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 23:30:38', 0),
('2a3475c5-1595-4e99-a443-98e829b59e2a', 'bb139edb-de27-4548-bdb2-31e06d701716', 'eaa08fc7-b66c-43d4-9e9f-c72dfb589230', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'qwerty — KLD FOUNDATION WEEK 2025 (sample1)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 06:51:30', 0),
('2f11cbfe-2395-4aa5-b20a-99fe4783bd43', NULL, 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: HACKATON 2026 (sample 3) — Need more information for credibility', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:21:12', 0),
('3bc65066-33be-4ad2-b042-3c263d28700f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'd2f97975-322c-4cd4-aa14-6b302b71e7b8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SAMPLE\"', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 12:03:59', 0),
('3bf9485a-a530-4d00-bd78-a364dc1c8755', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, 'blockchain', 'Budget Mismatch Detected', 'blockchain', 'alert', 'Warning', '1 budget mismatch(es) detected across verified project chains.', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 23:29:46', 0),
('404fe3ce-f133-49e9-8160-031f6391e120', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '62946d3c-8596-4ca5-9927-21b63d1965bd', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:06:41', 0),
('417a0079-17a9-40cd-be68-17e87d4d6972', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:41', 0),
('43ac3dc8-7174-40aa-b2d7-7c3aec2433d4', NULL, '2804cc1f-55c4-4be6-9d30-bda126f19766', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:49:44', 0),
('485de113-de6c-44ab-9d57-07f8458b102c', NULL, '65f4072c-fca0-4a53-a99e-d7a2b8af29bf', 'date_change_request', 'Date Change Request Approved', 'approvals', NULL, NULL, 'Approved date change request for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 12:37:13', 0),
('4953a150-e952-425e-bf1a-04def159161e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '1ee4d579-9b41-468a-a691-b86ad5735c04', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"KULTURA\'T MUSIKA: Himig ng Kabataan, Tinig ng Kinabukasan 2026 (sample 2)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:18:34', 0),
('49e828c9-f441-4cc4-aaad-07aae89ba167', 'bb139edb-de27-4548-bdb2-31e06d701716', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'test — TEST', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:15:36', 0),
('4c7f57e6-0b82-4e58-b534-38627bc50b22', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '3d8e70fe-3a7d-4d59-8cd1-09685ac38cae', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 12:56:43', 0),
('57951b95-d200-448b-ad91-1d7be2e0a8bb', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '6b058e99-109b-413a-9d33-64314f658821', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (1 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('5dc94bcf-e599-43fe-813f-799ea0220989', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '02205088-ebd3-4d02-b7e4-42a9bd0473c3', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 14:33:38', 0),
('6cfeb7c3-0787-4d8e-9e32-2db40a30026e', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 02:50:05', 0),
('6dad0668-1ba5-4573-85ba-72a4bbd86943', 'bb139edb-de27-4548-bdb2-31e06d701716', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: SPORT FEST 2026', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 01:52:15', 0),
('6f5ca0f3-58d2-414b-8d12-c7498424182b', NULL, '6f6f7039-e6c3-4f82-9abf-5027970a4232', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:38', 0),
('7066e332-76ac-43dc-9ef7-14b6ef36a6ce', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '6f6f7039-e6c3-4f82-9abf-5027970a4232', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:08:37', 0),
('7a27761e-14e3-4d99-ac63-64d52248d4e7', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SAMPLE 7\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 10:58:52', 0),
('7b85a610-8703-4eee-90fe-f3fc6350825f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '210fed52-b72e-47cc-93d6-7d82740b45d8', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 04:24:04', 0),
('7de102c1-f563-4887-8a8f-ae7ac88912f9', 'bb139edb-de27-4548-bdb2-31e06d701716', 'fdc79177-c941-45a7-9c29-666a64c85e36', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', 'reject', NULL, 'Membership drive — adasd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 08:58:42', 0),
('8761393a-67c4-4150-b4e2-71c35bb6fa98', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'fdc79177-c941-45a7-9c29-666a64c85e36', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (1 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('890c128e-a7c5-4dc4-ae46-798cc3e4f2c9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '7f34c673-3de7-4386-9191-135ad6ea2666', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:30:36', 0),
('91024ae2-003c-437e-8f54-b1172355d98c', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:02:40', 0),
('9391d8cf-92b3-47d5-87fb-9b1f7cac162d', NULL, '62946d3c-8596-4ca5-9927-21b63d1965bd', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'This is the list of materials that we are buying for the event.\r\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below. — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:21', 0),
('940e441f-dd46-498f-bf0d-05fbe26fa493', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:09', 0),
('967811b3-ac44-4e00-944a-898ee6457772', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '98cf7626-6bff-4cbb-9cc3-43884ece691f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"BAKOD KO LINIS KO (sample 4)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:28:25', 0),
('971739b6-60bd-41b7-8b13-bdb0bd5ab659', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 02:07:38', 0),
('9a5c2d58-cf15-48f2-a791-a188bc5b9764', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f87b55c9-9f8e-42ca-897e-5f7b787ee0ef', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"sadfas\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 04:41:16', 0),
('9c616920-db39-44e4-a265-5b47b9d8aad3', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '38095f86-fe70-444c-a1d4-ca0669c0e593', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"QWERTY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 08:17:25', 0),
('a158d671-5006-4bb8-a24b-53b7cd12a524', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '46e6086e-090e-4c74-9798-07600cdc9aa4', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2 via CSV bulk import (2 item(s))', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:32:56', 0),
('a4d2f3ed-f3f2-40a0-94fd-951fbad8a8b3', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'b1fc0b20-9763-47cb-afde-e63045d059f0', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"asfsdaf\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 04:42:08', 0),
('a6037bc8-9cc3-434e-b18c-980e0db2d761', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SPORT FEST 2026\"', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 01:49:24', 0),
('a634c97e-262d-46c8-b62e-a36d0945c973', 'bb139edb-de27-4548-bdb2-31e06d701716', '1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'adsa — KLD FOUNDATION WEEK 2025 (sample1)', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:07:14', 0),
('a9d2a91e-b136-4203-bdc1-13bb0b224fbd', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '2405:8d40:4895:8417:11b3:8d1:8e3f:cb17', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-23 03:18:50', 0),
('adabad65-674e-479f-ad81-424d3cf546cd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2229be95-ea51-4ca6-8a55-cfb14218b8e7', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 13:20:43', 0),
('ade7edd8-e511-4a47-8db3-8f33a189ee45', '0e77b5d7-8a68-49e4-9b37-5f9bbb05429a', '356b4022-a468-4372-9d7e-da357efb67cf', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID 924bb23e-8fe1-4c25-b238-124ac11daec3', '127.0.0.1', 'Symfony', '2026-09-24 07:08:35', 0),
('af378725-73ce-4998-897a-23ea67b4c17a', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2804cc1f-55c4-4be6-9d30-bda126f19766', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sample 6\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:49:04', 0),
('af7c82e1-3492-4a13-8cd4-78c9981a96ac', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"HACKATON 2026 (sample 3)\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:20:41', 0),
('b0846c5e-99bb-4879-9a00-365611bd8684', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', '90f61bee-2f51-4194-97af-fc3ea4357d57', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 04:02:24', 0),
('b0933cc8-f231-4f0a-b2a0-368244259acf', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'f87b55c9-9f8e-42ca-897e-5f7b787ee0ef', 'project', 'Project Archived', 'project', 'archive', 'Success', 'Archived project \"sadfas\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 04:42:26', 0),
('bac05ab6-2c35-449a-801a-64d6467b1ec5', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'b1fc0b20-9763-47cb-afde-e63045d059f0', 'project', 'Project Created', 'project', 'create', 'Success', 'Created project \"asfsdaf\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-23 04:25:16', 0),
('bed92588-ae56-44ac-9c11-9d43a412f550', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '11047d70-5665-4c11-ae0a-a9d367ccdf8c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-19 10:14:01', 0),
('cd9f17d8-d7d9-4f49-a046-9a947d36802c', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:4523:4723', NULL, NULL, '2026-09-24 07:51:56', 0),
('d8a6bc9f-da93-4663-b4a8-2aa12a277443', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36 Edg/153.0.0.0', '2026-09-19 08:09:58', 0),
('d9a2891b-54e8-4a72-baff-e58b8390ed2d', NULL, '4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'The following materials is the list of canvas materials — too expensive', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-19 08:11:57', 0),
('db8b96ea-b8f5-4e7e-8839-3ca42b8f5e6c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.96', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-22 14:06:54', 0),
('dbb98611-ad88-4adf-a81b-7d278e2196b2', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '533308f1-dcba-4a77-9a1e-d454ef42fe73', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"SportFest 2026 - Event Planning Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:18:00', 0),
('dbca3475-e2f8-42cf-adc6-acc38fb4c2dd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '39e0396a-ff9c-48de-8752-5faa44d59980', 'meeting', 'Meeting Marked Completed', 'meetings', 'update', 'Success', 'Marked meeting as completed \"Monthly Routine Meeting\"', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 03:16:47', 0),
('ddeb8aee-f801-404a-a6e6-098a6aad7943', NULL, '58f38625-3132-485e-a8a6-308436e56bf2', 'blockchain', 'Budget mismatch - email delivered', 'blockchain', 'alert', 'Warning', 'budget_mismatch:1:4723', NULL, NULL, '2026-09-23 02:04:06', 0),
('e295363a-2fd8-4b68-b68c-534ff38cd214', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '11047d70-5665-4c11-ae0a-a9d367ccdf8c', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Sample\" for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/152.0.0.0 Mobile Safari/537.36', '2026-09-19 10:14:16', 0),
('e46bfdd1-3548-4caa-baa2-69c802e45200', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'e9f4fe95-4551-4536-8241-223f7111b422', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2804cc1f-55c4-4be6-9d30-bda126f19766', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 04:01:34', 0),
('ed240986-ba9c-43df-974b-4e5a8c1b0870', 'bb139edb-de27-4548-bdb2-31e06d701716', '38095f86-fe70-444c-a1d4-ca0669c0e593', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: QWERTY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 08:19:12', 0),
('ee5486e9-108e-40ba-8246-7399ec793ec4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'eaa08fc7-b66c-43d4-9e9f-c72dfb589230', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Asset ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-24 06:51:07', 0),
('fbc2bf00-8d84-4077-aa27-35c156cc8e96', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '65f4072c-fca0-4a53-a99e-d7a2b8af29bf', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sample 6', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 11:55:35', 0),
('fe1b697a-2274-42f3-ad98-b951740a6a56', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'deed10ed-dd6c-4ec5-bad6-d22eaa981632', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 58f38625-3132-485e-a8a6-308436e56bf2', '123.253.51.41', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', '2026-09-20 14:32:54', 0);

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
('step-platform-demo-cache-04496c75118e9073b52fe736beb615a92f1e4d2e', 'i:1;', 1790154596),
('step-platform-demo-cache-04496c75118e9073b52fe736beb615a92f1e4d2e:timer', 'i:1790154596;', 1790154596),
('step-platform-demo-cache-08550b68c1e6b361ec88fc856d36c64379381c03', 'i:3;', 1790054244),
('step-platform-demo-cache-08550b68c1e6b361ec88fc856d36c64379381c03:timer', 'i:1790054244;', 1790054244),
('step-platform-demo-cache-0fec28f8018ae8f9f89d3f43f692e172e4290603', 'i:2;', 1789989820),
('step-platform-demo-cache-0fec28f8018ae8f9f89d3f43f692e172e4290603:timer', 'i:1789989820;', 1789989820),
('step-platform-demo-cache-1668209783d46cf63d593e6dfb7eff2044d05248', 'i:1;', 1790058426),
('step-platform-demo-cache-1668209783d46cf63d593e6dfb7eff2044d05248:timer', 'i:1790058426;', 1790058426),
('step-platform-demo-cache-17b9201aac87bdadab4f86940fb7f7c5ad8490d4', 'i:1;', 1790047197),
('step-platform-demo-cache-17b9201aac87bdadab4f86940fb7f7c5ad8490d4:timer', 'i:1790047197;', 1790047197),
('step-platform-demo-cache-1a12472755dd3c82db0e4aec93a1034226d6a498', 'i:1;', 1790058084),
('step-platform-demo-cache-1a12472755dd3c82db0e4aec93a1034226d6a498:timer', 'i:1790058084;', 1790058084),
('step-platform-demo-cache-1f96eebd9b658d92b8b7329f628176ba6f9a2cc7', 'i:1;', 1790056658),
('step-platform-demo-cache-1f96eebd9b658d92b8b7329f628176ba6f9a2cc7:timer', 'i:1790056658;', 1790056658),
('step-platform-demo-cache-29988edb6df6082e8269df9696b41089972fc81b', 'i:2;', 1789995261),
('step-platform-demo-cache-29988edb6df6082e8269df9696b41089972fc81b:timer', 'i:1789995261;', 1789995261),
('step-platform-demo-cache-2a0b5eef597bb862d639a5d25177d85289a3ebdd', 'i:1;', 1790058530),
('step-platform-demo-cache-2a0b5eef597bb862d639a5d25177d85289a3ebdd:timer', 'i:1790058530;', 1790058530),
('step-platform-demo-cache-2a1b3122c034f8bf12c12a5610d0c2f7f77b6526', 'i:3;', 1790047080),
('step-platform-demo-cache-2a1b3122c034f8bf12c12a5610d0c2f7f77b6526:timer', 'i:1790047080;', 1790047080),
('step-platform-demo-cache-2a371a69bdb8e296fc602a781f68591a1af10588', 'i:1;', 1790047482),
('step-platform-demo-cache-2a371a69bdb8e296fc602a781f68591a1af10588:timer', 'i:1790047482;', 1790047482),
('step-platform-demo-cache-2b61eefff8942b13e63c75a5e3b8a38a6baa1a48', 'i:2;', 1790047302),
('step-platform-demo-cache-2b61eefff8942b13e63c75a5e3b8a38a6baa1a48:timer', 'i:1790047302;', 1790047302),
('step-platform-demo-cache-2fa1790a71cf6040e99101b375e85422b425c48d', 'i:2;', 1789623467),
('step-platform-demo-cache-2fa1790a71cf6040e99101b375e85422b425c48d:timer', 'i:1789623467;', 1789623467),
('step-platform-demo-cache-3008f434a0de2f601ed0916d00a48b9249d34614', 'i:1;', 1790120367),
('step-platform-demo-cache-3008f434a0de2f601ed0916d00a48b9249d34614:timer', 'i:1790120367;', 1790120367),
('step-platform-demo-cache-3113383fb6e47146ab6385cc7da8ed96eeeb9b67', 'i:1;', 1790046992),
('step-platform-demo-cache-3113383fb6e47146ab6385cc7da8ed96eeeb9b67:timer', 'i:1790046992;', 1790046992),
('step-platform-demo-cache-313abaeb4735b78e15deda3ac409d4511123f074', 'i:1;', 1790056596),
('step-platform-demo-cache-313abaeb4735b78e15deda3ac409d4511123f074:timer', 'i:1790056596;', 1790056596),
('step-platform-demo-cache-320c947c6e79d4bd63fc92799318b97bcaa8ef0b', 'i:1;', 1790137139),
('step-platform-demo-cache-320c947c6e79d4bd63fc92799318b97bcaa8ef0b:timer', 'i:1790137139;', 1790137139),
('step-platform-demo-cache-33896e45a516a1c22f5ba27305947d4a58e73733', 'i:3;', 1790059336),
('step-platform-demo-cache-33896e45a516a1c22f5ba27305947d4a58e73733:timer', 'i:1790059336;', 1790059336),
('step-platform-demo-cache-375e69d3bf44a355b2ebf9ecc3a8750be865fd1d', 'i:1;', 1789974143),
('step-platform-demo-cache-375e69d3bf44a355b2ebf9ecc3a8750be865fd1d:timer', 'i:1789974143;', 1789974143),
('step-platform-demo-cache-399e08af9c9acafe750cbf616df8ac6710facd8d', 'i:2;', 1790127589),
('step-platform-demo-cache-399e08af9c9acafe750cbf616df8ac6710facd8d:timer', 'i:1790127589;', 1790127589),
('step-platform-demo-cache-3d9d17901cd55c496ff35302f67f36866f558958', 'i:2;', 1790047088),
('step-platform-demo-cache-3d9d17901cd55c496ff35302f67f36866f558958:timer', 'i:1790047088;', 1790047088),
('step-platform-demo-cache-3e43551498d4806de5d3af71e5eb105753d95330', 'i:1;', 1790056489),
('step-platform-demo-cache-3e43551498d4806de5d3af71e5eb105753d95330:timer', 'i:1790056489;', 1790056489),
('step-platform-demo-cache-45148c3ec9a5a8ca4a1e0491bd7537541fc8e2f5', 'i:3;', 1789564623),
('step-platform-demo-cache-45148c3ec9a5a8ca4a1e0491bd7537541fc8e2f5:timer', 'i:1789564623;', 1789564623),
('step-platform-demo-cache-4878e5752be91b1947114f6d0789eea67cd4c485', 'i:4;', 1789973427),
('step-platform-demo-cache-4878e5752be91b1947114f6d0789eea67cd4c485:timer', 'i:1789973427;', 1789973427),
('step-platform-demo-cache-4cba461c84017848057576dc3597c10ed6fe3181', 'i:1;', 1790047194),
('step-platform-demo-cache-4cba461c84017848057576dc3597c10ed6fe3181:timer', 'i:1790047194;', 1790047194),
('step-platform-demo-cache-4e36387b27fa9d61c7b9c46ad657d52f3a8ffdf4', 'i:1;', 1790058101),
('step-platform-demo-cache-4e36387b27fa9d61c7b9c46ad657d52f3a8ffdf4:timer', 'i:1790058101;', 1790058101),
('step-platform-demo-cache-5861912462ed072253158a7ce15d457ef7b59bed', 'i:2;', 1790059400),
('step-platform-demo-cache-5861912462ed072253158a7ce15d457ef7b59bed:timer', 'i:1790059400;', 1790059400),
('step-platform-demo-cache-5e0780075cae7b52dc97556f15bb14753f5f342b', 'i:1;', 1790047015),
('step-platform-demo-cache-5e0780075cae7b52dc97556f15bb14753f5f342b:timer', 'i:1790047015;', 1790047015),
('step-platform-demo-cache-68161f69b599707aca6b07c8699e51b7526ecb93', 'i:1;', 1790058180),
('step-platform-demo-cache-68161f69b599707aca6b07c8699e51b7526ecb93:timer', 'i:1790058180;', 1790058180),
('step-platform-demo-cache-6e980a5fc65e24694539f161513c0896b8c73597', 'i:1;', 1790047261),
('step-platform-demo-cache-6e980a5fc65e24694539f161513c0896b8c73597:timer', 'i:1790047261;', 1790047261),
('step-platform-demo-cache-726db44d6d23d1f176ef63e1ae9a07ce42dda077', 'i:1;', 1790058571),
('step-platform-demo-cache-726db44d6d23d1f176ef63e1ae9a07ce42dda077:timer', 'i:1790058571;', 1790058571),
('step-platform-demo-cache-729854923f5cd4f93a608a84f7eb89f841cda74d', 'i:1;', 1790059349),
('step-platform-demo-cache-729854923f5cd4f93a608a84f7eb89f841cda74d:timer', 'i:1790059349;', 1790059349),
('step-platform-demo-cache-7b0a559341df54163029d2e707740813bdacd038', 'i:3;', 1790047153),
('step-platform-demo-cache-7b0a559341df54163029d2e707740813bdacd038:timer', 'i:1790047153;', 1790047153),
('step-platform-demo-cache-7b77161446fe1ee7633301145dcb4e8d966e0614', 'i:1;', 1789706821),
('step-platform-demo-cache-7b77161446fe1ee7633301145dcb4e8d966e0614:timer', 'i:1789706821;', 1789706821),
('step-platform-demo-cache-7f6594b47600cf8944e494e5356c161e5d49a5bc', 'i:1;', 1789989466),
('step-platform-demo-cache-7f6594b47600cf8944e494e5356c161e5d49a5bc:timer', 'i:1789989466;', 1789989466),
('step-platform-demo-cache-81bcc6bfcd71484321ea123b3b170adbf4f38272', 'i:1;', 1790055480),
('step-platform-demo-cache-81bcc6bfcd71484321ea123b3b170adbf4f38272:timer', 'i:1790055480;', 1790055480),
('step-platform-demo-cache-853ebad25c828e31bd3c77532fbc4bc3452cb3bc', 'i:1;', 1789989815),
('step-platform-demo-cache-853ebad25c828e31bd3c77532fbc4bc3452cb3bc:timer', 'i:1789989815;', 1789989815),
('step-platform-demo-cache-87484a900536cd9c2476cddf48b7e819fedbb799', 'i:2;', 1790138053),
('step-platform-demo-cache-87484a900536cd9c2476cddf48b7e819fedbb799:timer', 'i:1790138053;', 1790138053),
('step-platform-demo-cache-89ffefa649fe01f49a5a66486e11088e7eac59fd', 'i:4;', 1789562858),
('step-platform-demo-cache-89ffefa649fe01f49a5a66486e11088e7eac59fd:timer', 'i:1789562858;', 1789562858),
('step-platform-demo-cache-8c52eb22360d6e10478bbce6aff96b39faab2da2', 'i:2;', 1790056695),
('step-platform-demo-cache-8c52eb22360d6e10478bbce6aff96b39faab2da2:timer', 'i:1790056695;', 1790056695),
('step-platform-demo-cache-90b7ab1a1d4cf016bde22a17acd2e381fbc01c9f', 'i:1;', 1790054302),
('step-platform-demo-cache-90b7ab1a1d4cf016bde22a17acd2e381fbc01c9f:timer', 'i:1790054302;', 1790054302),
('step-platform-demo-cache-91fbb3ffd767a58f8cabb4c3f5833e8f9ed3223a', 'i:1;', 1790055719),
('step-platform-demo-cache-91fbb3ffd767a58f8cabb4c3f5833e8f9ed3223a:timer', 'i:1790055719;', 1790055719),
('step-platform-demo-cache-92efbe45930da81e89362158094245b8bdb170d9', 'i:1;', 1790056369),
('step-platform-demo-cache-92efbe45930da81e89362158094245b8bdb170d9:timer', 'i:1790056369;', 1790056369),
('step-platform-demo-cache-9c51821d0cc869f3124f9f520716b84d4cbb6b14', 'i:1;', 1790047270),
('step-platform-demo-cache-9c51821d0cc869f3124f9f520716b84d4cbb6b14:timer', 'i:1790047270;', 1790047270),
('step-platform-demo-cache-a6c902d3dd32299fa53261e2d9ed51ee972d47b8', 'i:1;', 1789995237),
('step-platform-demo-cache-a6c902d3dd32299fa53261e2d9ed51ee972d47b8:timer', 'i:1789995237;', 1789995237),
('step-platform-demo-cache-a886b4e3f6728d7c1c2578c2e72a4c62243f901f', 'i:1;', 1789973553),
('step-platform-demo-cache-a886b4e3f6728d7c1c2578c2e72a4c62243f901f:timer', 'i:1789973553;', 1789973553),
('step-platform-demo-cache-ab53a27093e4fa42e6c01411f81e171224937239', 'i:1;', 1790056647),
('step-platform-demo-cache-ab53a27093e4fa42e6c01411f81e171224937239:timer', 'i:1790056647;', 1790056647),
('step-platform-demo-cache-abc7442402557237ecdf7229189b2e9c7248e656', 'i:1;', 1789563350),
('step-platform-demo-cache-abc7442402557237ecdf7229189b2e9c7248e656:timer', 'i:1789563350;', 1789563350),
('step-platform-demo-cache-bd3c843b1d891a539104482754f9d27695785673', 'i:1;', 1790047062),
('step-platform-demo-cache-bd3c843b1d891a539104482754f9d27695785673:timer', 'i:1790047062;', 1790047062),
('step-platform-demo-cache-bdf5c8334e903efe71250cad23e87cc6c6e9f4c7', 'i:1;', 1789992105),
('step-platform-demo-cache-bdf5c8334e903efe71250cad23e87cc6c6e9f4c7:timer', 'i:1789992105;', 1789992105),
('step-platform-demo-cache-bec45b1830ad21fbccb9ad13e4db15f049e7d052', 'i:1;', 1789973927),
('step-platform-demo-cache-bec45b1830ad21fbccb9ad13e4db15f049e7d052:timer', 'i:1789973927;', 1789973927),
('step-platform-demo-cache-c0fb0462b90742d57f3a094605cdfc82819e82c1', 'i:2;', 1789570702),
('step-platform-demo-cache-c0fb0462b90742d57f3a094605cdfc82819e82c1:timer', 'i:1789570702;', 1789570702),
('step-platform-demo-cache-c4fd3ee5b8f2da6ec1d454ebb20d41639f750c97', 'i:2;', 1790047267),
('step-platform-demo-cache-c4fd3ee5b8f2da6ec1d454ebb20d41639f750c97:timer', 'i:1790047267;', 1790047267),
('step-platform-demo-cache-c67c1239939431c3e95a2e6c76ecf64cea843c07', 'i:1;', 1790048883),
('step-platform-demo-cache-c67c1239939431c3e95a2e6c76ecf64cea843c07:timer', 'i:1790048883;', 1790048883),
('step-platform-demo-cache-c9797c514aaf151122667725fac9d41a2f994db7', 'i:1;', 1790135690),
('step-platform-demo-cache-c9797c514aaf151122667725fac9d41a2f994db7:timer', 'i:1790135690;', 1790135690),
('step-platform-demo-cache-c9fa119f59d80d2f284939c724e8a83211d14bda', 'i:1;', 1789572760),
('step-platform-demo-cache-c9fa119f59d80d2f284939c724e8a83211d14bda:timer', 'i:1789572760;', 1789572760),
('step-platform-demo-cache-cc4f39f7a7bbfc37bce6b2d1597119e3ad798a95', 'i:1;', 1789656779),
('step-platform-demo-cache-cc4f39f7a7bbfc37bce6b2d1597119e3ad798a95:timer', 'i:1789656779;', 1789656779),
('step-platform-demo-cache-concern-submit:27eb2086-df63-4867-aeea-38ea4d50ef63', 'i:1;', 1789564634),
('step-platform-demo-cache-concern-submit:27eb2086-df63-4867-aeea-38ea4d50ef63:timer', 'i:1789564634;', 1789564634),
('step-platform-demo-cache-concern-submit:8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'i:1;', 1789643210),
('step-platform-demo-cache-concern-submit:8bb0f22a-65f5-402c-82a4-d7a60b79f5e9:timer', 'i:1789643210;', 1789643210),
('step-platform-demo-cache-concern-submit:b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'i:2;', 1789807033),
('step-platform-demo-cache-concern-submit:b01f59b1-814e-4400-a267-6e1edbd3bd2c:timer', 'i:1789807033;', 1789807033),
('step-platform-demo-cache-concern-submit:bb139edb-de27-4548-bdb2-31e06d701716', 'i:1;', 1790058571),
('step-platform-demo-cache-concern-submit:bb139edb-de27-4548-bdb2-31e06d701716:timer', 'i:1790058571;', 1790058571),
('step-platform-demo-cache-d28c12cdba3d48006294e2c48648170b1589dac7', 'i:1;', 1789995163),
('step-platform-demo-cache-d28c12cdba3d48006294e2c48648170b1589dac7:timer', 'i:1789995163;', 1789995163),
('step-platform-demo-cache-d3c8ddf1002f794c26b5312176c46232511f51da', 'i:1;', 1790047052),
('step-platform-demo-cache-d3c8ddf1002f794c26b5312176c46232511f51da:timer', 'i:1790047052;', 1790047052),
('step-platform-demo-cache-d406dd4e8f1ec2fb410000fbc9476ddc0b0f19cd', 'i:1;', 1790032399),
('step-platform-demo-cache-d406dd4e8f1ec2fb410000fbc9476ddc0b0f19cd:timer', 'i:1790032399;', 1790032399),
('step-platform-demo-cache-d745f344a15fa3bc75367b394ef295e3e1064ba5', 'i:2;', 1790047326),
('step-platform-demo-cache-d745f344a15fa3bc75367b394ef295e3e1064ba5:timer', 'i:1790047326;', 1790047326),
('step-platform-demo-cache-e0d5df27b9d140f93908019867541a958b380a12', 'i:1;', 1790047014),
('step-platform-demo-cache-e0d5df27b9d140f93908019867541a958b380a12:timer', 'i:1790047014;', 1790047014),
('step-platform-demo-cache-e4c3ec2315f88c5b04d6948a0e6300ec15da7be7', 'i:3;', 1790046922),
('step-platform-demo-cache-e4c3ec2315f88c5b04d6948a0e6300ec15da7be7:timer', 'i:1790046922;', 1790046922),
('step-platform-demo-cache-f077c4350d8fb565bdad2217c0d2ae205abbc2b1', 'i:2;', 1790128780),
('step-platform-demo-cache-f077c4350d8fb565bdad2217c0d2ae205abbc2b1:timer', 'i:1790128780;', 1790128780),
('step-platform-demo-cache-f3b76adf6eec654df39d9d6b2dae5bb82b32f05f', 'i:2;', 1790047286),
('step-platform-demo-cache-f3b76adf6eec654df39d9d6b2dae5bb82b32f05f:timer', 'i:1790047286;', 1790047286),
('step-platform-demo-cache-f3c660413789a04857cbab9d817d72c999eeb1be', 'i:1;', 1790059144),
('step-platform-demo-cache-f3c660413789a04857cbab9d817d72c999eeb1be:timer', 'i:1790059144;', 1790059144),
('step-platform-demo-cache-f4a59dc36b633de1bc769b7e48e8497f172c480a', 'i:1;', 1789960825),
('step-platform-demo-cache-f4a59dc36b633de1bc769b7e48e8497f172c480a:timer', 'i:1789960825;', 1789960825),
('step-platform-demo-cache-f4acc8ff5c8b7e7c75f177ad755eebdb385a02e9', 'i:3;', 1790047038),
('step-platform-demo-cache-f4acc8ff5c8b7e7c75f177ad755eebdb385a02e9:timer', 'i:1790047038;', 1790047038),
('step-platform-demo-cache-fe705b1d7d46f5e94260c9f5dc3e132964b2d84e', 'i:1;', 1789992126),
('step-platform-demo-cache-fe705b1d7d46f5e94260c9f5dc3e132964b2d84e:timer', 'i:1789992126;', 1789992126),
('step-platform-demo-cache-ff30c8ac52df3db11c2295d880a7d0203de37af1', 'i:1;', 1790127550),
('step-platform-demo-cache-ff30c8ac52df3db11c2295d880a7d0203de37af1:timer', 'i:1790127550;', 1790127550),
('step-platform-demo-cache-password_reset_otp_emdgquintos@kld.edu.ph', 'a:3:{s:3:\"otp\";s:6:\"483035\";s:7:\"user_id\";s:36:\"8bb0f22a-65f5-402c-82a4-d7a60b79f5e9\";s:10:\"created_at\";O:25:\"Illuminate\\Support\\Carbon\":4:{s:4:\"date\";s:26:\"2026-09-21 10:47:43.945486\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";s:18:\"dumpDateProperties\";a:2:{s:4:\"date\";s:26:\"2026-09-21 10:47:43.945486\";s:8:\"timezone\";s:3:\"UTC\";}}}', 1789988263),
('step-platform-demo-cache-password_reset_otp_lpcalibuso@kld.edu.ph', 'a:3:{s:3:\"otp\";s:6:\"923467\";s:7:\"user_id\";s:36:\"b01f59b1-814e-4400-a267-6e1edbd3bd2c\";s:10:\"created_at\";O:25:\"Illuminate\\Support\\Carbon\":4:{s:4:\"date\";s:26:\"2026-09-20 04:19:05.055608\";s:13:\"timezone_type\";i:3;s:8:\"timezone\";s:3:\"UTC\";s:18:\"dumpDateProperties\";a:2:{s:4:\"date\";s:26:\"2026-09-20 04:19:05.055608\";s:8:\"timezone\";s:3:\"UTC\";}}}', 1789878545);

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
('045979a3-ce8b-4491-9d4c-e98ab7ac5a73', '38095f86-fe70-444c-a1d4-ca0669c0e593', 1, '2f1f56497a02b3335c77f293d8a6d8ab151568b3426df70c2c8a3f457697fb31', '24263ce02e2f72fff0648bfbee209a53a2b34ff1faed996eb028d951e602c4af', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"4a63ded8-54c3-4c5d-8a0b-6f2d54c0f476\\\",\\\"project_id\\\":\\\"38095f86-fe70-444c-a1d4-ca0669c0e593\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-24T16:19:11+00:00\\\",\\\"snapshot_nonce\\\":\\\"f3dbfcf6b708db4b\\\"}\"', '2026-09-24 16:19:11'),
('4997e22d-28e1-4bbe-869c-d7b1571d1471', '38095f86-fe70-444c-a1d4-ca0669c0e593', 0, NULL, '2f1f56497a02b3335c77f293d8a6d8ab151568b3426df70c2c8a3f457697fb31', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"38095f86-fe70-444c-a1d4-ca0669c0e593\\\",\\\"title\\\":\\\"QWERTY\\\",\\\"description\\\":\\\"QWERTY\\\",\\\"amount\\\":\\\"100.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-24T16:19:11+00:00\\\"}\"', '2026-09-24 16:19:11'),
('68b3c240-eedd-46b2-9858-2d76fdee0685', '58f38625-3132-485e-a8a6-308436e56bf2', 3, '15be417d6d454e391aa81384f7e6fd6ec93a3038ac4d5fd6f0293ba08daae3a7', '419ed25c92438b9b34d46cee54c8d52d2dee3540d4a27b6d532d81428b7a9e3a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"6f6f7039-e6c3-4f82-9abf-5027970a4232\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"John Doe\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"500\\\\\\\",\\\\\\\"amount\\\\\\\":500}]\\\",\\\"amount\\\":\\\"500.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:11:38+00:00\\\",\\\"snapshot_nonce\\\":\\\"f91e96dc9ed0e1f9\\\"}\"', '2026-09-19 08:11:38'),
('6faa1011-5397-40f6-a2d0-4ecb6a03693e', '58f38625-3132-485e-a8a6-308436e56bf2', 6, 'd291331222c0a276f89b0cfab6a2d718242ce06ec0d63bb610a0bbd5c4f56a31', '1280bc874dffcdc884139a96e603f8aef9a99c9d15c6d3e79ab76da12658ef29', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"eaa08fc7-b66c-43d4-9e9f-c72dfb589230\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"qwerty\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"laptop\\\\\\\",\\\\\\\"qty\\\\\\\":\\\\\\\"2\\\\\\\",\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":200,\\\\\\\"asset_category\\\\\\\":\\\\\\\"Electronic Devices\\\\\\\"}]\\\",\\\"amount\\\":\\\"200.00\\\",\\\"entry_type\\\":\\\"Asset\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-24T14:51:30+00:00\\\",\\\"snapshot_nonce\\\":\\\"3a61b958baecb52d\\\"}\"', '2026-09-24 14:51:30'),
('75726d30-4175-4abf-a07c-10e48a9ee3f5', '58f38625-3132-485e-a8a6-308436e56bf2', 1, '25c0dce7a3b5a6312b86de5f07b69a3d24b040b777799eac1ee371ec8717bc99', '5174ea925c1e76feaaa8db189556e10a6e36cf3c260798cf84614fecdb2dbb29', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"75b8ee1d-b6bb-4dac-8f49-68cdbab157c5\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"5000.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:02:40+00:00\\\",\\\"snapshot_nonce\\\":\\\"028e3d4c5c408e2b\\\"}\"', '2026-09-19 08:02:40'),
('83cac12e-0c8c-4370-b572-a795d9467029', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 0, NULL, 'be3ec00d9658d69b254a5ffe35d3fbef0c8f8328f5922e619b748026c5aa756f', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"f4d91e54-e7bf-4606-ac18-5fed0125f690\\\",\\\"title\\\":\\\"SPORT FEST 2026\\\",\\\"description\\\":\\\"SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026\\\",\\\"amount\\\":\\\"100.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-23T01:52:15+00:00\\\"}\"', '2026-09-23 01:52:15'),
('871289ba-6911-4ff7-b49d-57fa4c0737ed', '58f38625-3132-485e-a8a6-308436e56bf2', 5, 'cda59b1b5599c83f4717808ecbb4d91296338bde72fc50d157af04c05d79d8f5', 'd291331222c0a276f89b0cfab6a2d718242ce06ec0d63bb610a0bbd5c4f56a31', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"63e0a0f6-f833-49bb-8bcb-ce78f564fbc7\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"Transferred to project \\\\\\\"SPORT FEST 2026\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-23T01:52:15+00:00\\\",\\\"snapshot_nonce\\\":\\\"2f47ed415d871294\\\"}\"', '2026-09-23 01:52:15'),
('99bcd241-36cf-4662-bef9-d156a4243962', '58f38625-3132-485e-a8a6-308436e56bf2', 0, NULL, '25c0dce7a3b5a6312b86de5f07b69a3d24b040b777799eac1ee371ec8717bc99', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"title\\\":\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\",\\\"description\\\":\\\"KLD Foundation Week 2025 marks the 5th founding anniversary celebration of Kolehiyo ng Lungsod ng Dasmari\\\\u00f1as. The celebration, themed \\\\\\\"Lima\'t Laya,\\\\\\\" commemorates five years of the institution\'s commitment to accessible education and community development in Dasmari\\\\u00f1as. The project has the currecnt budget of 5,000 php.\\\",\\\"amount\\\":\\\"5000.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:02:40+00:00\\\"}\"', '2026-09-19 08:02:40'),
('a5d6af2e-3452-430c-978a-61688cf026bd', '58f38625-3132-485e-a8a6-308436e56bf2', 2, '5174ea925c1e76feaaa8db189556e10a6e36cf3c260798cf84614fecdb2dbb29', '15be417d6d454e391aa81384f7e6fd6ec93a3038ac4d5fd6f0293ba08daae3a7', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"62946d3c-8596-4ca5-9927-21b63d1965bd\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"This is the list of materials that we are buying for the event.\\\\r\\\\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below.\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"chair\\\\\\\",\\\\\\\"qty\\\\\\\":\\\\\\\"50\\\\\\\",\\\\\\\"unitPrice\\\\\\\":\\\\\\\"5\\\\\\\",\\\\\\\"amount\\\\\\\":250},{\\\\\\\"id\\\\\\\":2,\\\\\\\"item\\\\\\\":\\\\\\\"balloons\\\\\\\",\\\\\\\"quantity\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"5\\\\\\\",\\\\\\\"amount\\\\\\\":250,\\\\\\\"qty\\\\\\\":\\\\\\\"50\\\\\\\"},{\\\\\\\"id\\\\\\\":3,\\\\\\\"item\\\\\\\":\\\\\\\"microphones\\\\\\\",\\\\\\\"quantity\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":300,\\\\\\\"qty\\\\\\\":\\\\\\\"3\\\\\\\"}]\\\",\\\"amount\\\":\\\"800.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-19T08:11:21+00:00\\\",\\\"snapshot_nonce\\\":\\\"468be75993dbb664\\\"}\"', '2026-09-19 08:11:21'),
('a8db28b8-9d43-440c-b361-707ec9b1469b', '58f38625-3132-485e-a8a6-308436e56bf2', 4, '419ed25c92438b9b34d46cee54c8d52d2dee3540d4a27b6d532d81428b7a9e3a', 'cda59b1b5599c83f4717808ecbb4d91296338bde72fc50d157af04c05d79d8f5', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"adsa\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"asfasd\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"amount\\\\\\\":123}]\\\",\\\"amount\\\":\\\"123.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-22T14:07:14+00:00\\\",\\\"snapshot_nonce\\\":\\\"d3dd2bd59db8007f\\\"}\"', '2026-09-22 14:07:14'),
('c9b5db7f-02a8-4973-ad32-5f6a42e3bdb6', '58f38625-3132-485e-a8a6-308436e56bf2', 7, '1280bc874dffcdc884139a96e603f8aef9a99c9d15c6d3e79ab76da12658ef29', '2ce626b8f9aeeee022df3482317455484ec540678f7a8e6aa7acc9f142ae7634', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"2229be95-ea51-4ca6-8a55-cfb14218b8e7\\\",\\\"project_id\\\":\\\"58f38625-3132-485e-a8a6-308436e56bf2\\\",\\\"description\\\":\\\"test\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"test\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"123\\\\\\\",\\\\\\\"amount\\\\\\\":123}]\\\",\\\"amount\\\":\\\"123.00\\\",\\\"entry_type\\\":\\\"Canvas\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-24T16:59:08+00:00\\\",\\\"snapshot_nonce\\\":\\\"74fb3eaae091d50a\\\"}\"', '2026-09-24 16:59:08'),
('df33bc56-6f71-453b-affa-4d3e6fdb6b59', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 1, 'be3ec00d9658d69b254a5ffe35d3fbef0c8f8328f5922e619b748026c5aa756f', '29895c40c04f63ef5e23feaa7a9fe694648334ee1d3a06e887564a1ed4a39a86', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"225e7086-013a-4908-9766-50b1021147d1\\\",\\\"project_id\\\":\\\"f4d91e54-e7bf-4606-ac18-5fed0125f690\\\",\\\"description\\\":\\\"Transferred from completed project \\\\\\\"KLD FOUNDATION WEEK 2025 (sample1)\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Initial Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-09-23T01:52:15+00:00\\\",\\\"snapshot_nonce\\\":\\\"2f351b37dbb03a94\\\"}\"', '2026-09-23 01:52:15');

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
('1fceb1d0-9996-4baa-ad3e-86a5bf5f9e8c', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 123.00, 'adsa', NULL, '\"[{\\\"item\\\":\\\"asfasd\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Approved', 0, 'safsd', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:07:14', NULL, 0, '2026-09-22 14:06:54', '2026-09-22 14:07:14', NULL),
('2229be95-ea51-4ca6-8a55-cfb14218b8e7', '58f38625-3132-485e-a8a6-308436e56bf2', 'Canvas', 123.00, 'test', NULL, '\"[{\\\"item\\\":\\\"test\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'safas', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-24 08:59:08', NULL, 0, '2026-09-22 13:20:43', '2026-09-24 08:59:08', NULL),
('225e7086-013a-4908-9766-50b1021147d1', 'f4d91e54-e7bf-4606-ac18-5fed0125f690', 'Initial Transfer', 100.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\"', 'Transfer', NULL, 'ledger_proofs/ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c.png', 'ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c', 'Approved', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"SPORT FEST 2026\"', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-23 01:52:15', NULL, 0, '2026-09-23 01:49:24', '2026-09-23 01:52:15', NULL),
('31a06c0b-7fdc-4f49-99a3-1d0d6138e746', '7f34c673-3de7-4386-9191-135ad6ea2666', 'Initial Transfer', 1000.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:30:36', '2026-09-19 08:30:48', NULL),
('356b4022-a468-4372-9d7e-da357efb67cf', '924bb23e-8fe1-4c25-b238-124ac11daec3', 'Asset', 0.00, 'Laptop purchase', NULL, '\"[{\\\"item\\\":\\\"Laptop\\\",\\\"qty\\\":2,\\\"unitPrice\\\":1500,\\\"asset_category\\\":\\\"Electronic Devices\\\"}]\"', 'ledger_proofs/e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855.pdf', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Draft', 0, NULL, NULL, '0e77b5d7-8a68-49e4-9b37-5f9bbb05429a', NULL, NULL, NULL, 0, '2026-09-24 07:08:35', '2026-09-24 07:08:35', 'proof.pdf'),
('46e6086e-090e-4c74-9798-07600cdc9aa4', '58f38625-3132-485e-a8a6-308436e56bf2', 'Expense', 2750.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Venue rental\\\",\\\"qty\\\":1,\\\"unitPrice\\\":1500,\\\"amount\\\":1500},{\\\"id\\\":2,\\\"item\\\":\\\"Snacks\\\",\\\"qty\\\":50,\\\"unitPrice\\\":25,\\\"amount\\\":1250}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-19 08:32:56', '2026-09-19 08:32:56', NULL),
('4a63ded8-54c3-4c5d-8a0b-6f2d54c0f476', '38095f86-fe70-444c-a1d4-ca0669c0e593', 'Initial', 100.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Approved', 0, 'Auto-generated baseline on project creation', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-24 08:19:12', NULL, 0, '2026-09-24 08:17:25', '2026-09-24 08:19:12', 'stepemail.png'),
('4fc7cb80-ee8e-4105-8d88-fb8dea81b0a0', '58f38625-3132-485e-a8a6-308436e56bf2', 'Canvas', 3060.00, 'The following materials is the list of canvas materials', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"tables\\\",\\\"qty\\\":\\\"3\\\",\\\"unitPrice\\\":\\\"20\\\",\\\"amount\\\":60},{\\\"id\\\":2,\\\"item\\\":\\\"food\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"30\\\",\\\"amount\\\":3000,\\\"qty\\\":\\\"100\\\"}]\"', 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Rejected', 0, 'too expensive', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, '2026-09-19 08:11:57', 0, '2026-09-19 08:09:58', '2026-09-22 11:37:15', NULL),
('62946d3c-8596-4ca5-9927-21b63d1965bd', '58f38625-3132-485e-a8a6-308436e56bf2', 'Expense', 800.00, 'This is the list of materials that we are buying for the event.\r\nThe following materials are brought on (details about the localtion). The following materials proof are compiled below.', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"chair\\\",\\\"qty\\\":\\\"50\\\",\\\"unitPrice\\\":\\\"5\\\",\\\"amount\\\":250},{\\\"id\\\":2,\\\"item\\\":\\\"balloons\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"5\\\",\\\"amount\\\":250,\\\"qty\\\":\\\"50\\\"},{\\\"id\\\":3,\\\"item\\\":\\\"microphones\\\",\\\"quantity\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":300,\\\"qty\\\":\\\"3\\\"}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'gow', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:11:21', NULL, 0, '2026-09-19 08:06:41', '2026-09-19 08:11:21', NULL),
('63e0a0f6-f833-49bb-8bcb-ce78f564fbc7', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 100.00, 'Transferred to project \"SPORT FEST 2026\"', 'Transfer', NULL, 'ledger_proofs/ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c.png', 'ad48d283baccb3b1204f31e2a290c900a3255b19f3195de5c0f2266de0a11f2c', 'Approved', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"f4d91e54-e7bf-4606-ac18-5fed0125f690\",\"transfer_destination_project_title\":\"SPORT FEST 2026\"}', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-23 01:52:15', NULL, 0, '2026-09-23 01:49:24', '2026-09-23 01:52:15', NULL),
('6b058e99-109b-413a-9d33-64314f658821', '58f38625-3132-485e-a8a6-308436e56bf2', 'Donation', 1000.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Alumni contribution\\\",\\\"qty\\\":1,\\\"unitPrice\\\":1000,\\\"amount\\\":1000}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-19 08:32:56', '2026-09-19 08:32:56', NULL),
('6f6f7039-e6c3-4f82-9abf-5027970a4232', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 500.00, 'During the canvas of the project for extra budget we talk to several people and got a deal. the receipt is attached below', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"John Doe\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"500\\\",\\\"amount\\\":500}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'alright!', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:11:38', NULL, 0, '2026-09-19 08:08:37', '2026-09-19 08:11:38', NULL),
('6fd8ac00-6021-4e4d-a6b6-ed2d6164d8b4', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 1000.00, 'Transferred to project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"7f34c673-3de7-4386-9191-135ad6ea2666\",\"transfer_destination_project_title\":\"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:30:36', '2026-09-19 08:30:48', NULL),
('747d3a40-7631-43ff-bce3-d21141732579', 'f87b55c9-9f8e-42ca-897e-5f7b787ee0ef', 'Initial', 1231.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-23 04:41:16', '2026-09-23 04:42:26', 'stepemail.png'),
('75b8ee1d-b6bb-4dac-8f49-68cdbab157c5', '58f38625-3132-485e-a8a6-308436e56bf2', 'Initial', 5000.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Approved', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, '2026-09-19 08:02:40', NULL, 0, '2026-09-19 07:55:00', '2026-09-19 08:02:40', NULL),
('7aa337c7-0177-496f-99d0-c7f33f8cd6fb', 'b1fc0b20-9763-47cb-afde-e63045d059f0', 'Initial', 123.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, NULL, NULL, 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 1, '2026-09-23 04:25:16', '2026-09-23 04:42:08', NULL),
('8d467bca-dff4-4f6b-90f4-e1818673f3c6', '98cf7626-6bff-4cbb-9cc3-43884ece691f', 'Initial Transfer', 700.00, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Transferred from completed project \"KLD FOUNDATION WEEK 2025 (sample1)\" to project \"BAKOD KO LINIS KO (sample 4)\"', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:28:25', '2026-09-19 08:28:26', NULL),
('abfe2481-d2a6-4a0e-8077-6c5eb60be2d9', '58f38625-3132-485e-a8a6-308436e56bf2', 'Transfer', 700.00, 'Transferred to project \"BAKOD KO LINIS KO (sample 4)\"', 'Transfer', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, '{\"transfer_source_project_id\":\"58f38625-3132-485e-a8a6-308436e56bf2\",\"transfer_source_project_title\":\"KLD FOUNDATION WEEK 2025 (sample1)\",\"transfer_destination_project_id\":\"98cf7626-6bff-4cbb-9cc3-43884ece691f\",\"transfer_destination_project_title\":\"BAKOD KO LINIS KO (sample 4)\"}', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:28:25', '2026-09-19 08:28:26', NULL),
('deed10ed-dd6c-4ec5-bad6-d22eaa981632', '58f38625-3132-485e-a8a6-308436e56bf2', 'Sponsorship', 500.00, 'Lawrence Calibuso sponsor 500 php', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Lawrence Calibuso sponsor 500 php\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"500\\\",\\\"amount\\\":500}]\"', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, NULL, NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, NULL, 0, '2026-09-20 14:32:54', '2026-09-20 14:33:01', NULL),
('e6926cfc-094f-4795-aeca-ae17a3b08357', 'bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Pending Adviser Approval', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 10:58:52', '2026-09-19 10:59:37', NULL),
('eaa08fc7-b66c-43d4-9e9f-c72dfb589230', '58f38625-3132-485e-a8a6-308436e56bf2', 'Asset', 200.00, 'qwerty', NULL, '\"[{\\\"item\\\":\\\"laptop\\\",\\\"qty\\\":\\\"2\\\",\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":200,\\\"asset_category\\\":\\\"Electronic Devices\\\"}]\"', 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', 'Approved', 0, 'safsadf', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-24 06:51:30', NULL, 0, '2026-09-24 06:51:07', '2026-09-24 06:51:30', 'stepemail.png'),
('eabd7350-2a2b-447f-a0b7-e6fcde83f17e', '1ee4d579-9b41-468a-a691-b86ad5735c04', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Draft', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-19 08:18:34', '2026-09-19 08:18:35', NULL),
('f31b217a-aa72-4a3c-ae89-92b5ad087bf5', '210fed52-b72e-47cc-93d6-7d82740b45d8', 'Initial', 100.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, NULL, NULL, 'Pending Adviser Approval', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, 0, '2026-09-23 04:24:04', '2026-09-23 04:24:09', NULL),
('fdc79177-c941-45a7-9c29-666a64c85e36', '58f38625-3132-485e-a8a6-308436e56bf2', 'Income', 2500.00, 'Membership drive', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"Registration fees\\\",\\\"qty\\\":1,\\\"unitPrice\\\":2500,\\\"amount\\\":2500}]\"', NULL, NULL, 'Rejected', 0, 'adasd', 'bb139edb-de27-4548-bdb2-31e06d701716', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', NULL, '2026-09-24 08:58:42', 0, '2026-09-19 08:32:56', '2026-09-24 08:58:42', NULL),
('fdfc27fe-7994-48c4-ab26-780f9baa1837', 'bb03cf78-cc39-4bf4-94ee-103a1049e777', 'Initial', 0.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', 'Rejected', 0, 'Auto-generated baseline on project creation', NULL, '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', NULL, NULL, '2026-09-19 08:21:12', 0, '2026-09-19 08:20:41', '2026-09-19 08:21:12', NULL);

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
('533308f1-dcba-4a77-9a1e-d454ef42fe73', NULL, 'SportFest 2026 - Event Planning Meeting', 'Meeting for sportfest 2026', '2026-09-16 23:37:00', '2026-09-20 03:18:00', 0, NULL, NULL, '10', '[\"CSG1\"]', NULL, NULL, '2026-09-20 03:18:00', 0),
('de6c7289-3aec-4d34-92af-6cc4b09a2e71', NULL, 'Monthly Routine Meeting', 'Monthly routine meeting dedicated for status checking and goal alignment of the council.', '2026-10-16 23:32:00', '2026-09-16 15:36:27', 1, NULL, NULL, '10', '[]', NULL, NULL, '2026-09-16 15:36:40', 0);

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
('065c16a6-4ab2-40b6-b949-8e36a0754e86', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:33:14', '2026-09-19 08:33:14', 0),
('10fd541d-35d5-4b5d-a7cf-e0484a32355d', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: TEST', 'ledger', 0, NULL, '2026-09-22 14:09:29', '2026-09-22 14:09:29', 0),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', NULL, 'Project Approved', 'Project \"sample 6\" has been approved.', 'project', 0, NULL, '2026-09-19 08:49:44', '2026-09-19 08:49:44', 0),
('152156dc-e5df-4685-85c7-9939611d35d4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"SAMPLE 7\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 10:59:37', '2026-09-19 10:59:37', 0),
('16028c11-c63a-4a57-8c95-b84c0e1a17ae', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 07:56:01', '2026-09-19 07:56:01', 0),
('18823688-f7f5-4898-9269-e9a1dd23a146', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Project submitted for approval', 'Project \"SPORT FEST 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 01:50:09', '2026-09-23 01:50:09', 0),
('1e4e3c93-5c69-44d5-a855-c6f97fcde5a9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-22 14:07:14', '2026-09-22 14:07:14', 0),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 02:50:05', '2026-09-23 02:50:05', 0),
('2a7f84b0-7e9e-4df4-b030-33263af7fe16', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project Rejected', 'Your project \"HACKATON 2026 (sample 3)\" was rejected. Reason: Need more information for credibility', 'project', 0, NULL, '2026-09-19 08:21:12', '2026-09-19 08:21:12', 0),
('3066db43-c54a-4ad8-977a-5fa45eb5261b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-24 06:51:30', '2026-09-24 06:51:30', 0),
('310855f7-f4b7-4398-a47a-8b7169a7d285', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-22 23:30:38', '2026-09-22 23:30:38', 0),
('349e8c7c-f789-470d-a5d3-8b6a7ef7e5cc', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:15:23', '2026-09-22 14:15:23', 0),
('3fe7d4e5-a8d4-4de0-ac06-bc42aa93bf23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Date Change Request Approved', 'Your date change request for project \"sample 6\" has been approved.', 'date_change', 0, NULL, '2026-09-20 12:37:13', '2026-09-20 12:37:13', 0),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', NULL, 'New Meeting Scheduled', 'A new meeting titled \'SportFest 2026 - Event Planning Meeting\' has been scheduled for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:18:00', '2026-09-20 03:18:00', 0),
('4b6c9f4f-3c99-4e98-a61b-ad3fe6c57e6c', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"SAMPLE 7\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 10:59:37', '2026-09-19 10:59:37', 0),
('50b1198f-e282-460f-9c30-8153893e219d', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:15:23', '2026-09-22 14:15:23', 0),
('53188840-6390-451d-948b-2eb727745106', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: adasd', 'ledger', 0, NULL, '2026-09-24 08:58:43', '2026-09-24 08:58:43', 0),
('56044327-85c1-4532-b9b4-4478d4e3337e', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"SPORT FEST 2026\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 01:50:09', '2026-09-23 01:50:09', 0),
('5626d442-b404-4dfd-8112-54738cbe0d1c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"HACKATON 2026 (sample 3)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:20:45', '2026-09-19 08:20:45', 0),
('5db1ad97-5365-4a2e-b521-6cbdb51aff6e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:15:23', '2026-09-22 14:15:23', 0),
('5f486a6a-92d5-4fb4-9035-ee530790fdf3', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"sample 6\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:49:10', '2026-09-19 08:49:10', 0),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', NULL, 'Meeting Updated', 'The meeting titled \'Monthly Routine Meeting\' was updated for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:16:09', '2026-09-20 03:16:09', 0),
('679cd334-03dc-427a-b118-c7d79981ebfe', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Project submitted for approval', 'Project \"qwerty\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 04:24:09', '2026-09-23 04:24:09', 0),
('6a021117-cff9-4dd7-93e3-45a34e14cc4d', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-24 08:59:08', '2026-09-24 08:59:08', 0),
('6cb4e16c-7edb-40d2-8f91-6b4ef5846368', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:16:57', '2026-09-22 14:16:57', 0),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', NULL, 'Meeting Updated', 'The meeting titled \'Monthly Routine Meeting\' was updated for September 16, 2026, 11:37 PM', 'meeting', 0, NULL, '2026-09-20 03:16:41', '2026-09-20 03:16:41', 0),
('724b7d3f-8c32-4eb9-a8d6-8c7e62e43018', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"qwerty\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 04:24:09', '2026-09-23 04:24:09', 0),
('765c3002-a2de-4668-806e-630ec3413506', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-19 08:11:38', '2026-09-19 08:11:38', 0),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', NULL, 'Project Approved', 'Project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'project', 0, NULL, '2026-09-19 08:02:40', '2026-09-19 08:02:40', 0),
('7a3ff097-e362-4c4d-a844-1720030afa3a', NULL, 'Project Approved', 'Project \"QWERTY\" has been approved.', 'project', 0, NULL, '2026-09-24 08:19:12', '2026-09-24 08:19:12', 0),
('7a43b301-71b5-4199-add2-4eb163a10ac8', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:16:57', '2026-09-22 14:16:57', 0),
('7b036218-8dd9-4e70-917a-71fae008f0e0', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"QWERTY\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-24 08:18:39', '2026-09-24 08:18:39', 0),
('7f22256e-cee8-4353-b233-59b6d0686561', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"SPORT FEST 2026\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 01:50:09', '2026-09-23 01:50:09', 0),
('847a4949-a370-4d9d-9365-b50327020994', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-24 06:51:13', '2026-09-24 06:51:13', 0),
('8681114c-7641-4593-b095-ca77872fe494', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:46', '2026-09-19 08:10:46', 0),
('87c8acc1-f724-4fdf-87bd-67fe3f0ed088', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:37', '2026-09-19 08:10:37', 0),
('8e7bbb43-dd50-4a86-8b44-cd6b2403e69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:09:13', '2026-09-22 14:09:13', 0),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', NULL, 'Project Approved', 'Project \"SPORT FEST 2026\" has been approved.', 'project', 0, NULL, '2026-09-23 01:52:15', '2026-09-23 01:52:15', 0),
('94ffe5ef-19f7-4ed9-ba8a-385d91586a46', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-20 14:33:01', '2026-09-20 14:33:01', 0),
('999f2a8f-b9a9-45e1-b87b-441caa4420c6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:16:57', '2026-09-22 14:16:57', 0),
('9a2182ca-ed9c-4d78-ad65-16c2084db640', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Project submitted for approval', 'Project \"QWERTY\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-24 08:18:39', '2026-09-24 08:18:39', 0),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 02:07:38', '2026-09-23 02:07:38', 0),
('add6b990-b807-4e29-b6e8-6b1207f473a2', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:07:03', '2026-09-22 14:07:03', 0),
('b29f8818-0a84-43ad-abf6-c373a16ead12', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-24 06:51:13', '2026-09-24 06:51:13', 0),
('b2fa05f2-d087-42e2-85d9-797c77199d28', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"qwerty\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-23 04:24:09', '2026-09-23 04:24:09', 0),
('b7c7745b-64b3-4119-afb4-970a3b55a055', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:30:48', '2026-09-19 08:30:48', 0),
('b9b21856-21dd-42c6-9d4b-93da76475785', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:46', '2026-09-19 08:10:46', 0),
('ba140221-b91e-4a9d-9630-848a3b85adb6', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-20 14:33:01', '2026-09-20 14:33:01', 0),
('c133e0bd-210a-4e5d-a956-aeb484417a35', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:09:13', '2026-09-22 14:09:13', 0),
('c9927155-5ea4-48a5-b498-330056f77c58', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 07:56:01', '2026-09-19 07:56:01', 0),
('ca5814c2-e76e-4c52-9efe-33448fe000a0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger entry submitted for approval', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-22 14:07:03', '2026-09-22 14:07:03', 0),
('d4a8acef-0f90-4389-8c38-5c9a2c648890', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Project submitted for approval', 'Project \"HACKATON 2026 (sample 3)\" was submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:20:45', '2026-09-19 08:20:45', 0),
('d6ebedeb-565f-47a2-bb06-d88b3bfb0b91', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:30:48', '2026-09-19 08:30:48', 0),
('df791218-11c9-471d-81a3-8544f3cc686b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Approved', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" has been approved.', 'ledger', 0, NULL, '2026-09-19 08:11:21', '2026-09-19 08:11:21', 0),
('e41c9425-5ccf-4f36-98c1-b655874ce5ff', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-24 06:51:13', '2026-09-24 06:51:13', 0),
('e5271b32-3659-4203-80b8-5f6930b5babb', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-09-23 03:18:50', '2026-09-23 03:18:50', 0),
('eaae5a15-6b1b-4fbb-86e2-a513a2548cdf', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:35', '2026-09-19 08:10:35', 0),
('ec5f2165-f975-4dbb-bb22-da5bbc9a1aa8', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:33:14', '2026-09-19 08:33:14', 0),
('ed440768-760b-4167-9ba2-fe5d2ae1c7f1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"sample 6\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-19 08:49:10', '2026-09-19 08:49:10', 0),
('f113232b-709c-497b-86e9-a82fb87c6ca0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: too expensive', 'ledger', 0, NULL, '2026-09-19 08:11:57', '2026-09-19 08:11:57', 0),
('f64422e6-8516-4f78-9845-a7346c1b964a', '82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'Ledger entry submitted for approval', 'A ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-09-19 08:10:37', '2026-09-19 08:10:37', 0),
('f76a1581-3c77-44dd-8d03-c96bcfe40b72', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Ledger Entry Rejected', 'Ledger entry for project \"KLD FOUNDATION WEEK 2025 (sample1)\" was rejected. Reason: TEST', 'ledger', 0, NULL, '2026-09-22 14:15:36', '2026-09-22 14:15:36', 0),
('ffb80ca9-eb27-451e-b21a-e9be7bab2f26', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'Project submitted for approval', 'Your project \"QWERTY\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-09-24 08:18:39', '2026-09-24 08:18:39', 0);

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
('04351f1a-1a98-413b-a0b3-ceb6749c2507', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('065c16a6-4ab2-40b6-b949-8e36a0754e86', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('10fd541d-35d5-4b5d-a7cf-e0484a32355d', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:22'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('1382c2ed-685a-4bb3-940b-fc07c4071b09', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:07'),
('152156dc-e5df-4685-85c7-9939611d35d4', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('16028c11-c63a-4a57-8c95-b84c0e1a17ae', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('1e4e3c93-5c69-44d5-a855-c6f97fcde5a9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('227b2801-5dc0-42c7-9164-e42f80b5b69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('2a7f84b0-7e9e-4df4-b030-33263af7fe16', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('3066db43-c54a-4ad8-977a-5fa45eb5261b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('310855f7-f4b7-4398-a47a-8b7169a7d285', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('3fe7d4e5-a8d4-4de0-ac06-bc42aa93bf23', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:18'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', '2026-09-22 05:55:58'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('45cc244f-9689-42fc-a574-0bddfb65f9e5', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:04'),
('50b1198f-e282-460f-9c30-8153893e219d', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('5626d442-b404-4dfd-8112-54738cbe0d1c', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('5db1ad97-5365-4a2e-b521-6cbdb51aff6e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:21'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('664af992-26ed-418e-bd8a-4ccdeb4dd38e', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:06'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:21'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', '2026-09-22 05:56:05'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('6f510204-3484-4c16-a0ec-cdc1c14968c1', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:05'),
('724b7d3f-8c32-4eb9-a8d6-8c7e62e43018', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('765c3002-a2de-4668-806e-630ec3413506', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '2f634388-8250-4c80-8d57-20e331c9de64', '2026-09-22 03:19:24'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('7675cf8d-74ee-4a8f-9016-4be3e6f1c6dd', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', '2026-09-22 03:19:07'),
('7a43b301-71b5-4199-add2-4eb163a10ac8', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('7f22256e-cee8-4353-b233-59b6d0686561', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('847a4949-a370-4d9d-9365-b50327020994', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('87c8acc1-f724-4fdf-87bd-67fe3f0ed088', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('8e7bbb43-dd50-4a86-8b44-cd6b2403e69f', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('907b4d82-3483-47d1-bd26-0e80bc42b94a', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('94ffe5ef-19f7-4ed9-ba8a-385d91586a46', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('999f2a8f-b9a9-45e1-b87b-441caa4420c6', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('a75e16d3-05e6-4504-b098-c4ce5713b9ef', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('add6b990-b807-4e29-b6e8-6b1207f473a2', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('b9b21856-21dd-42c6-9d4b-93da76475785', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('c133e0bd-210a-4e5d-a956-aeb484417a35', 'bb139edb-de27-4548-bdb2-31e06d701716', '2026-09-22 14:49:17'),
('ca5814c2-e76e-4c52-9efe-33448fe000a0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('d6ebedeb-565f-47a2-bb06-d88b3bfb0b91', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('df791218-11c9-471d-81a3-8544f3cc686b', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('e5271b32-3659-4203-80b8-5f6930b5babb', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('ed440768-760b-4167-9ba2-fe5d2ae1c7f1', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('f113232b-709c-497b-86e9-a82fb87c6ca0', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28'),
('f76a1581-3c77-44dd-8d03-c96bcfe40b72', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '2026-09-24 08:00:28');

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
('e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'Projects', 'submit', 'projects.submit', 'Submit access for Projects', '2026-09-07 17:55:19', '2026-09-07 17:55:19', 0);

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
('1ee4d579-9b41-468a-a691-b86ad5735c04', NULL, 'KULTURA\'T MUSIKA: Himig ng Kabataan, Tinig ng Kinabukasan 2026 (sample 2)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Objectives\r\n-Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\r\n-Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Cultural', 0.00, 0, 'City of Dasmarinas Arena', 'Draft', 'CSG1', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-09', '2026-10-09', NULL, 'Draft', NULL, '2026-09-19 08:18:34', '2026-09-19 08:18:35', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('210fed52-b72e-47cc-93d6-7d82740b45d8', NULL, 'qwerty', 'qwerty', 'qwerty', 'Social', 100.00, 1, 'qwerty', 'Draft', 'qwerty', NULL, NULL, NULL, '2026-10-21', '2026-10-28', NULL, 'Pending Adviser Approval', NULL, '2026-09-23 04:24:04', '2026-09-23 04:24:09', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('38095f86-fe70-444c-a1d4-ca0669c0e593', NULL, 'QWERTY', 'QWERTY', 'QWERTY', 'Sports', 100.00, 1, 'QWERTY', 'Draft', 'QWERTY', 'sadfasfas', 'project_approval/825355f51342e6035a181965fc85385423d64b86a6a96c0f40dc5da93563aa87.pdf', '825355f51342e6035a181965fc85385423d64b86a6a96c0f40dc5da93563aa87', '2026-10-16', '2026-10-21', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Approved', '2026-09-24 08:19:11', '2026-09-24 08:17:25', '2026-09-24 08:19:11', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', 0),
('58f38625-3132-485e-a8a6-308436e56bf2', NULL, 'KLD FOUNDATION WEEK 2025 (sample1)', 'KLD Foundation Week 2025 marks the 5th founding anniversary celebration of Kolehiyo ng Lungsod ng Dasmariñas. The celebration, themed \"Lima\'t Laya,\" commemorates five years of the institution\'s commitment to accessible education and community development in Dasmariñas. The project has the currecnt budget of 5,000 php.', 'Objectives\r\n-To honor the college\'s five-year journey of providing quality education to local students\r\n-To strengthen community bonds through festive activities and shared celebrations\r\n-To reaffirm KLD\'s mission of fostering academic excellence and social responsibility', 'Social', 4523.00, 1, 'KLD Gymnasium', 'Draft', 'CSG1, CSG2, CSG3, CSG4', 'Make sure all the requirements need is complete before the event.', 'project_approval/768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236.pdf', '768876a7f6027707c11919e06b40c4463d7718242a40d72ea2a6a9ede2487236', '2025-10-15', '2025-10-22', '62900437-3c5f-4652-b968-f2eac510ddad', 'Approved', '2026-09-19 08:02:40', '2026-09-19 07:55:00', '2026-09-24 06:51:30', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', 0),
('7f34c673-3de7-4386-9191-135ad6ea2666', NULL, 'DAPAT TAMA - Learning how to vote wisely (SAMPLE 5)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Education', 1000.00, 0, 'City of Dasmarinas Area', 'Draft', 'CSG6', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-30', '2026-10-30', NULL, 'Pending Adviser Approval', NULL, '2026-09-19 08:30:36', '2026-09-19 08:30:48', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('924bb23e-8fe1-4c25-b238-124ac11daec3', NULL, 'Project asset purchase', 'Asset must be tracked as in-use immediately', 'Testing asset usage', 'Social', 5000.00, 0, 'Main Hall', 'Draft', 'Test User', NULL, NULL, NULL, NULL, NULL, NULL, 'Draft', NULL, '2026-09-24 07:08:34', '2026-09-24 07:08:34', NULL, NULL, 0),
('98cf7626-6bff-4cbb-9cc3-43884ece691f', NULL, 'BAKOD KO LINIS KO (sample 4)', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.', 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'Education', 700.00, 0, 'San Lorenzo Area E', 'Draft', 'CSG1, 2, 3, 4, 5', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-12-15', '2026-12-16', NULL, 'Draft', NULL, '2026-09-19 08:28:25', '2026-09-19 08:28:26', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('b1fc0b20-9763-47cb-afde-e63045d059f0', NULL, 'asfsdaf', 'safsad', 'sdfsad', 'Social', 123.00, 1, 'asfasdf', 'Draft', 'dsgdf', NULL, NULL, NULL, '2026-10-20', '2026-10-27', NULL, 'Draft', NULL, '2026-09-23 04:25:16', '2026-09-23 04:42:08', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1),
('bb03cf78-cc39-4bf4-94ee-103a1049e777', NULL, 'HACKATON 2026 (sample 3)', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.', 'Technology', 0.00, 0, 'KLD Bldg1', 'Draft', 'CSG3', 'Need more information for credibility', 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-22', '2026-11-05', NULL, 'Rejected', NULL, '2026-09-19 08:20:41', '2026-09-19 08:21:12', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '62900437-3c5f-4652-b968-f2eac510ddad', 0),
('bdcb69b2-f911-41b3-82c9-5d2007ed2f1a', NULL, 'SAMPLE 7', 'SAMPLE 7', 'SAMPLE 7', 'Sports', 0.00, 0, 'SAMPLE 7', 'Draft', 'SAMPLE 7', NULL, 'ledger_proofs/b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722.png', 'b9652584164511792b8911ffee579a688b8da90fc6f0d3da92b1a5ad5967b722', '2026-10-21', '2026-10-28', NULL, 'Pending Adviser Approval', NULL, '2026-09-19 10:58:52', '2026-09-19 10:59:37', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('d2f97975-322c-4cd4-aa14-6b302b71e7b8', NULL, 'SAMPLE', 'SAMPLE', 'SAMPLE', 'Sports', 0.00, 0, 'SAMPLE', 'Draft', 'SAMPLE', NULL, NULL, NULL, '2026-10-20', '2026-10-28', NULL, 'Draft', NULL, '2026-09-22 12:03:59', '2026-09-22 12:03:59', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 0),
('f4d91e54-e7bf-4606-ac18-5fed0125f690', NULL, 'SPORT FEST 2026', 'SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026', 'SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026SPORT FEST 2026', 'Social', 100.00, 0, 'KLD GYM', 'Draft', 'SPORT FEST 2026', 'YES', 'project_approval/94c3684111d05ede541ff486b2c9d95226fa6cdf62ccd4dc204c19ad3c13d6ec.pdf', '94c3684111d05ede541ff486b2c9d95226fa6cdf62ccd4dc204c19ad3c13d6ec', '2026-10-14', '2026-10-29', 'bb139edb-de27-4548-bdb2-31e06d701716', 'Approved', '2026-09-23 01:52:15', '2026-09-23 01:49:24', '2026-09-23 01:52:15', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'bb139edb-de27-4548-bdb2-31e06d701716', 0),
('f87b55c9-9f8e-42ca-897e-5f7b787ee0ef', NULL, 'sadfas', 'safsda', 'safsa', 'Sports', 1231.00, 1, 'safsadf', 'Draft', 'safasd', NULL, 'ledger_proofs/947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f.png', '947a829c869eaddc103cfabf991909f15d5091eb60c4d201ffc9be9921c26c0f', '2026-10-14', '2026-10-21', NULL, 'Draft', NULL, '2026-09-23 04:41:16', '2026-09-23 04:42:26', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 1);

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
('0cd138d6-c87a-4175-a8b3-2025e22c4ae0', '58f38625-3132-485e-a8a6-308436e56bf2', '1532c8ff-88f3-46da-8222-9df946116efa', 4, 4, 4, 'It\'s good but need to improve in visual appeal', 0, '2026-09-22 06:42:04', 0),
('136aacc8-cc90-4db6-9295-384270eee896', '58f38625-3132-485e-a8a6-308436e56bf2', '952befae-6ce5-4ea7-a018-3bb3e638a90e', 5, 5, 5, 'Very Good!', 0, '2026-09-22 03:21:22', 0),
('1c45f2f1-0fab-467f-9805-630ec58c5da2', '58f38625-3132-485e-a8a6-308436e56bf2', '2685f8e1-10ae-4337-a650-70bd0b45a3ba', 5, 5, 5, 'NICE!', 0, '2026-09-22 03:20:32', 0),
('2f2174bf-d13d-4fc1-a5dc-1388f273081a', '58f38625-3132-485e-a8a6-308436e56bf2', '1957970f-e67f-4d9a-b773-94b81f84b937', 5, 5, 5, 'Good job!', 0, '2026-09-22 06:22:30', 0),
('316d40f0-1754-4f4d-b324-6e65a0229468', '58f38625-3132-485e-a8a6-308436e56bf2', 'ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', 5, 5, 5, 'A work of art and it shows transparency', 0, '2026-09-22 03:23:35', 0),
('32c614d1-d460-4d48-a54b-c7ea964c5f61', '58f38625-3132-485e-a8a6-308436e56bf2', '54ae97c2-c473-4975-aacc-d44d84591628', 5, 5, 5, 'Not fully aware of this, but I appreciate how this helps others:)', 0, '2026-09-21 11:24:23', 0),
('3dfc4d78-8157-4b02-99bc-c51b35aafb35', '58f38625-3132-485e-a8a6-308436e56bf2', '11a031e9-b7fb-42c5-b0f8-461c2e2ae827', 5, 4, 5, 'Keep it up', 0, '2026-09-22 05:17:58', 0),
('42e69303-6ee3-4585-82be-96075523b4fd', '58f38625-3132-485e-a8a6-308436e56bf2', '0acf2825-1aff-4bd5-b24b-3fd79375fd49', 4, 4, 4, 'great', 0, '2026-09-22 03:23:52', 0),
('4cfe0957-a4f0-44e1-ab64-41b3c45a0429', '58f38625-3132-485e-a8a6-308436e56bf2', '4364f571-2368-479e-8ec2-491d176c693a', 5, 5, 5, 'Easy to use and shows transparency.', 0, '2026-09-22 03:18:25', 0),
('54132efb-0668-4ac1-b9e1-66c4930e82c3', '58f38625-3132-485e-a8a6-308436e56bf2', 'f7ef62d5-8133-4c7e-a487-c7e000210788', 5, 5, 5, 'nice project!', 0, '2026-09-22 03:22:50', 0),
('70fc576a-ddac-42f4-8e69-4824f961f858', '58f38625-3132-485e-a8a6-308436e56bf2', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 5, 5, 5, 'Great system', 0, '2026-09-22 05:54:43', 0),
('84cdead7-a23a-4354-bd81-da714bafb971', '58f38625-3132-485e-a8a6-308436e56bf2', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', 5, 5, 5, 'I like it', 0, '2026-09-19 08:34:02', 0),
('904a6b35-bbd5-48ba-b5be-8ed8645a05b8', '58f38625-3132-485e-a8a6-308436e56bf2', 'fecf41cc-142d-4038-a152-8fa34718ad37', 4, 4, 2, 'Some reliable', 0, '2026-09-22 05:58:05', 0),
('a40abe88-71d3-4c05-a1be-bbcad115455b', '58f38625-3132-485e-a8a6-308436e56bf2', '7c1c5079-05ca-4468-800c-463b24e22030', 5, 5, 5, 'Smooth naman yung app and organized hindi nakakalito i-navigate', 0, '2026-09-22 05:40:33', 0),
('a5c2a5d4-d443-4f71-894d-7c8cf0ca17f3', '58f38625-3132-485e-a8a6-308436e56bf2', '00888baa-1ec4-4296-8de6-64a469963b14', 4, 4, 4, 'Unique', 0, '2026-09-22 06:22:40', 0),
('b0006e82-d4fe-4038-ad36-79bd76844aa9', '58f38625-3132-485e-a8a6-308436e56bf2', '2385bf74-ee55-482d-9dba-689532e3a949', 4, 5, 4, 'I really like the concept of this project', 0, '2026-09-23 01:41:53', 0),
('b9c037bd-5a8e-48bd-b35f-00c9b66fe51a', '58f38625-3132-485e-a8a6-308436e56bf2', '05f4c23e-a777-416d-b709-272a5ab75f9c', 5, 5, 5, 'Good', 0, '2026-09-21 12:02:08', 0),
('ca2cbea5-ebc3-406c-86c5-3423b13be235', '58f38625-3132-485e-a8a6-308436e56bf2', '2f634388-8250-4c80-8d57-20e331c9de64', 4, 4, 4, 'Wow', 0, '2026-09-22 03:21:47', 0),
('d4c886a5-8bb8-45cd-a601-fd0f1aade03f', '58f38625-3132-485e-a8a6-308436e56bf2', 'b9b9ca53-1785-4170-9247-73ac4b1d28fd', 5, 5, 5, 'Great initiative and a wonderful 5th anniversary celebration for Kolehiyo ng Lungsod ng Dasmariñas!', 0, '2026-09-21 12:57:41', 0),
('e9a505f2-29ab-40bf-a238-156003ffc905', '58f38625-3132-485e-a8a6-308436e56bf2', '01e1a005-fcbf-4e5b-af03-f060d50348fa', 4, 4, 5, 'More website appearance', 0, '2026-09-22 06:46:12', 0),
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
('48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10001-0000-4000-8000-000000000001', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-09-07 06:28:59', '2026-09-07 06:28:59', 0),
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
('01cda5d2-224e-41d1-a9b3-882b1d01a30a', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-07 06:28:58'),
('021cd261-20ab-4769-bbc3-a0e2f4a10977', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('0303b747-cc9a-4256-a3ea-cfbcc35f5830', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('0324b324-793b-4ed6-9e29-89212db7a620', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('03908900-8a63-4b4f-8212-415bf72f173a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('04761010-65f2-4bea-87e7-79d7df2cb09c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('0559fa4d-b41c-4dbd-b7db-d3ac8ac11bbe', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10016-0000-4000-8000-000000000016', NULL, '2026-09-07 06:28:58'),
('061371bf-e299-45df-834a-d927e447eac7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('063f190d-e885-4890-ae78-8b4f868cd504', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('064f2c42-d999-477e-a663-8d25b7792dd8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('08a2eed9-0a45-4851-8b7b-e65ae0f5960a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('091ddb2c-8eb4-4ed4-88e3-bf3cf977b3dc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('09bf72dd-ce1e-43bb-979d-eb4761705d64', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('0a733143-d3b7-4451-b515-85cf4ce825c3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('0b73f1ff-5db8-451a-be2e-0c896fcf02eb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('0bc05e2c-74b8-424a-9ddf-4a3299239f0a', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-09-07 06:28:58'),
('0bc9e77c-6a21-46b8-95d2-f4a70b90cfe0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('0ca0bebe-bed8-4732-8928-273f1af87a32', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('110287e5-d30b-48e0-99e4-c9ddb0f57ec1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('111a6108-9b9e-443b-88ba-43d655874c4b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('13e3c12f-6b3a-4f6c-a0f2-4c80cdb1e0d9', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('167a674b-e065-4648-a938-d906395b0d8b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('16f05dd9-2c8f-4469-b2d8-af34d368f405', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10034-0000-4000-8000-000000000034', NULL, '2026-09-07 06:28:58'),
('183ec155-e8d6-4548-b37a-fc10398d1e83', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('197ec481-a2e1-44ba-ac93-395db564534c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('19c1fe07-8d7f-45f4-a886-29efdc4c1f63', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-09-07 06:28:58'),
('1b74b6e2-7ecc-43bf-b67d-d8381ccc94a2', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-22 22:21:56'),
('1ba85089-423c-43f0-b539-749225e98d90', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:21'),
('1c3fbdcb-3992-48d6-86bb-0af6b92abdae', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10038-0000-4000-8000-000000000038', NULL, '2026-09-07 06:28:58'),
('1cc5c8d0-6c04-4be6-b30f-ca85347d12c6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('1cd99d38-ba78-484b-af86-98e530aef54a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('1ce12f5d-8597-47c9-980b-fbbbad689ae6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('1de9cd0a-6a20-44a2-aa2e-11f206329949', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('1f0ff18e-44c5-4178-9dd6-2031bb21cd66', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('21721a75-d887-4eb0-b215-fc957635a46e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('21dd5b59-667a-418a-b2f3-0f33b1101e7e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('2200a77a-b0a0-4afa-a028-b56195fdc560', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('22787662-5208-4cac-9059-3b01e48284ab', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('233a05d4-39df-4f45-9cb2-ba5de1aa1a55', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-09-07 06:28:58'),
('267940d9-92d5-4f82-b726-0bbf9978c9c3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('2752826b-37b9-4949-ae34-71e7edd28035', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10017-0000-4000-8000-000000000017', NULL, '2026-09-07 06:28:58'),
('275b90e3-67eb-4406-b89f-c9106159e567', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('277ed934-1fef-4a7e-b9b4-1d9e49f2babe', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('27e20b66-0af9-480b-ada9-241405f75009', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10030-0000-4000-8000-000000000030', NULL, '2026-09-07 06:28:58'),
('28d7b302-6436-46f2-ab2f-a5ae85fe837e', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('29610cfd-6453-4004-87a7-ae117f8283ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('2b2da59e-7ea2-4a92-95e6-7e700b5f6905', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('2bc99887-d666-4417-8174-8014c523db22', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('2caf457d-e04c-4876-9c3b-e9b750f33ace', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('2dc6c27d-30bf-41d5-b7b4-0c7d95a970b7', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10005-0000-4000-8000-000000000005', NULL, '2026-09-07 06:28:58'),
('2e62e3b7-9863-496f-b4f2-1da85c8d58ed', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:21'),
('2e64c09e-d309-402b-bc55-12c8273ddbbc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('2ee05084-2f0a-420e-ae71-029c9a8fd03b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-07 06:28:58'),
('2f2c37bb-3be9-4147-be21-9de746eb4f97', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('30f0b1ca-1ead-4394-ab9a-55320176a291', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('3136b57b-0c08-4902-9fe0-8c3f4a4a1004', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('31379aaf-a7ee-4295-97b6-9c7729a42c66', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('321675ea-877e-4383-8f71-a205d2bd4177', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10026-0000-4000-8000-000000000026', NULL, '2026-09-07 06:28:58'),
('33493259-b54c-4c91-870e-c2cff77c724a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('344abca3-1e5c-4ca3-a9be-13d039c8d895', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:20'),
('34916893-e75b-454c-bcf0-4ee437c50f82', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('350670a8-a316-43d2-a12e-b508850c7b2f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('355e9ed2-acfe-44c1-baed-4e800d272a70', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-07 06:28:58'),
('35fb75e9-87f4-4f33-b53e-1479c6c1cdaf', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10031-0000-4000-8000-000000000031', NULL, '2026-09-07 06:28:58'),
('368a7b28-acdc-475a-8303-a6a97bbd493a', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:58'),
('36efa530-c1f4-40fc-9a9f-d8f4ca9bb241', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('376be394-5be0-48fc-947d-c0a3086f4c00', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('385e4075-23c3-416f-a02a-9990db30b40a', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-07 06:28:58'),
('38a22b0f-9dc4-4161-85ac-f67069a35f52', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('38c5b452-664c-4520-8b82-33747a7269a0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('39172a38-f689-422e-81bd-cf47cb38eb45', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('3b04f9fe-f606-48fb-85bb-ee06eb592ceb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('3b4f0d22-a20e-43c4-9a7e-d4da0a743657', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('3cda93e9-d379-4ae8-ba81-fb294e57d41a', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-22 22:21:56'),
('3cf9cf28-df64-49bd-aea6-63fce9900cd7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('3d334b7d-6237-4149-a943-44a3368db8a7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-09-07 06:28:58'),
('3e1bd2c0-d740-4f45-822c-5bc79abf9418', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('3e6932e1-5380-4e69-9449-702edc6a2acc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('3f110bc6-e664-44d4-bab8-ca1928dfe72e', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-22 22:21:56'),
('3f9c03b6-301e-4148-bb39-bc83c58dfeb8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('404b546c-9a8a-4ada-a48f-0f5eddde987d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('409c082a-0cfd-41c5-addd-e2e018442948', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('40df72b3-2fdf-445b-a854-d472eb81df30', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-09-07 06:28:58'),
('414c823c-9900-453b-a2a2-8bfc039fc098', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('414d5426-ad87-4571-b117-55bbb1476457', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('4197f563-1220-4596-bff9-1e8f9323a5a6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('42755ec5-a9cd-4518-b5d7-c48260ab9746', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('4432cfca-cd70-4d46-889a-957a784f02fd', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10030-0000-4000-8000-000000000030', NULL, '2026-09-07 06:28:58'),
('456411d9-9c68-4870-9ac6-d862133c7cb3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('460dde59-6d86-4446-b587-9c27dc8a1028', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('46ce8b89-c488-454e-8990-6cfac930950b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('47d93b4f-dc0b-40e3-a5f8-7d6f92ebf093', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('484b176b-bd22-4f0f-aae6-236554645646', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10032-0000-4000-8000-000000000032', NULL, '2026-09-07 06:28:58'),
('4a3712fa-7d79-4c47-a3e7-e4837571e9a0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('4a896f3d-7416-423a-9678-85641875d60d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('4bc2d8d0-ae3a-452e-a5af-1f6889b0a1d6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('4ca34a8f-cbb1-4781-b9c9-1fd89912a102', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('4cbcf9aa-326e-4341-8684-8f651987d207', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('4cc59219-51b2-4f3c-abea-55c5272b819d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('4ce504d1-e34b-4e63-b169-e0ad5faa0e0f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('4db9f114-4074-400d-a74a-6f50fb84ab47', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:21'),
('4dca7b6e-a3a5-446b-a1e6-86512668129e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('4e3fa4f0-3093-4384-9686-8363dceadc19', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('4fd065ef-0cf8-4f0a-9d1b-236b38bbd368', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-09-07 06:28:58'),
('501ebbfe-0e18-4db0-8507-d177e1b7d326', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('50545e6b-ec13-4b51-890c-ed72d06a542b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('507fa95a-fe86-4e40-8ed8-4ce19bc39aed', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:20'),
('50f6e450-2b6f-41ad-898e-1dfded88162c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('5227c7ef-eb3d-4ea2-9a81-3d61830d35ad', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-09-07 06:28:58'),
('5256e086-e016-4450-959d-17e5319720e0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('52e5f230-05f6-4c1a-990f-a985f8a8b82d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('55409249-27e1-4686-bd4b-603891abbfff', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('556b8b6e-45c2-4d16-b664-9e27d1e318c5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('562f34b2-977f-4ed2-89b0-04a0a47504d0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('5656d4db-a411-4482-8192-8c333dcbee7a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('566241c7-02ff-40b8-88a5-fc05ca4b9021', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('56ccfd4a-e98f-478e-8a8b-199d8044f573', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('57f44a20-805f-4e83-9f4c-b45cdc9c8333', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-09-07 06:28:58'),
('580599dd-b1c8-41b8-813e-79377688af5d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('585127d6-55f7-44af-bcba-60f14da37c74', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:21'),
('58e5cb09-5185-4c71-bcd2-6884960fb69a', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('59c73647-9998-4d8f-9431-691e6326d611', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('5ae3fafa-b5ad-423b-91b9-df24764be1f1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-09-07 06:28:58'),
('5bc3062a-b36e-4656-95e3-183bb34bca15', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('5be04683-de0d-4c24-b608-bc1dd259ac20', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('5ceb949f-8aa0-4c5c-a865-c38d175818c3', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10009-0000-4000-8000-000000000009', NULL, '2026-09-07 06:28:58'),
('5f2ef5f6-94ce-4660-b16e-5b4961e360c6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('5f7cd7e1-e5dd-4f6a-be32-a8e69f338295', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('5faedf3b-ef16-4717-aafd-41217e862bc1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('5fcc0707-205b-4b8a-9622-f1fdd5019353', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:20'),
('6115091e-b0b2-4343-a263-2b51407db35d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('617262c8-8b3b-4575-97b8-1fe2ef4778b1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('61d5c429-23ee-415c-b164-d2d32901eb16', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('64aad84a-0b62-486d-9443-b59b676be3ed', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10027-0000-4000-8000-000000000027', NULL, '2026-09-07 06:28:58'),
('6618a45c-c4b9-4b50-a01c-f58b33890825', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('6834ff00-332b-4875-851d-5056159296de', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('688b3099-42cf-4977-a0cf-dc125d243ee6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('68b0054a-eabc-4464-975c-0c5b70981d1f', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10023-0000-4000-8000-000000000023', NULL, '2026-09-07 06:28:58'),
('68d9447e-2f72-4c11-9150-0f643549f2d4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('69c255c6-83a7-41a4-9245-b8a8c25df303', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('6adc5665-9a8d-40cf-b726-1ad24eff9c31', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10033-0000-4000-8000-000000000033', NULL, '2026-09-07 06:28:58'),
('6b46dadc-0baa-4576-81c3-27d2b735a156', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10032-0000-4000-8000-000000000032', NULL, '2026-09-07 06:28:58'),
('6b6ac999-0d42-4ee1-a50c-1ba804e0b402', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10042-0000-4000-8000-000000000042', NULL, '2026-09-07 06:28:58'),
('6d3087d1-2e16-4b86-ae7c-3b5c9a0875f6', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10040-0000-4000-8000-000000000040', NULL, '2026-09-07 06:28:58'),
('6e9fe40d-4b23-48d5-8409-b8b7717376dd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('6ed6b318-31a0-4aa4-af34-f87473d1d5d7', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10034-0000-4000-8000-000000000034', NULL, '2026-09-07 06:28:58'),
('6f20ac8c-61a5-4b26-944d-63b056e74abc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:58'),
('6f88d08a-4f60-4216-8bc6-a7b993822bfe', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('70859ca3-d209-41c4-a445-d809cd01c0a7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('722fe9f8-6fcf-49d2-9ffd-138125b89e73', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-09-07 06:28:58'),
('72322835-9b4c-438a-8abd-3b74b6f51b32', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('748ea996-c565-4d58-a22a-d3f815dbb234', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('7579f3ff-64bd-4213-83a5-f264113e7ec4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('7640c151-fcb5-4eb5-b145-61a93555c72d', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:58'),
('764df03d-a665-4ba5-a24a-8f716ab491e2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('76783f7a-8707-4b7f-8e49-0f29ea29aed6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('76beb0d8-a687-489b-b794-bcddbb7618ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10038-0000-4000-8000-000000000038', NULL, '2026-09-07 06:28:58'),
('779b198f-ec68-49cb-a994-4be0805306bf', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('77d6909e-da81-4725-828b-e1e4df59c0c8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('783bfd4b-2672-4567-9de5-066b7431d92f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('78a148bf-41c8-415c-992f-447e56523ef8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('79861add-a05a-4ec3-8b15-756aacc76cbe', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('7a0f82e2-da5a-4c53-a993-d8ba41b0dbf4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('7c406476-e9c0-4dc1-a1bb-93fe60a17442', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10003-0000-4000-8000-000000000003', NULL, '2026-09-07 06:28:58'),
('7c80e1a7-d69d-4b11-b168-95e449d4c3ce', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('7ca81bce-5100-44ce-95e0-fd3432abad57', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-07 06:28:58'),
('7cc5f208-0f9a-4568-8eaf-1187e7ce32e7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('7d12f6c4-59f9-4a60-a871-17bbba16565b', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10027-0000-4000-8000-000000000027', NULL, '2026-09-07 06:28:58'),
('7d7d444f-928b-4d83-92c5-417fb466deca', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('7dbdd15c-0b72-423c-b767-137498c19da1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('7dfe7446-cd2c-452e-bf1a-346f67f9af5f', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-22 22:21:56'),
('7e198f42-6347-4b57-87ef-cda8365b0692', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('7fa7e54e-7759-4f60-b670-9dfe6d6b5179', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('80107f01-ac8b-4c02-ac00-04a28455f54c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('812fe60d-19c4-4a0f-a378-92adc14c171a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('81b3163f-1d0c-47bd-96c2-8b9f3621962f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('82eb4d77-b646-49a7-9558-f0353ce58559', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('84d96b32-2add-424a-8840-94411982939b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-09-07 06:28:58'),
('85d80696-256f-463d-9350-b9d733b43887', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('8647af9d-3519-434d-894d-3fd9d0e1acde', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('864f8d5e-fd0d-4a7d-b09d-8a6f9b49386b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('86b5d71d-e8c9-4997-acad-9d78ca83949a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('87679e0d-e3a0-4840-84d7-6c5dbe6a0951', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-09-07 06:28:58'),
('878f0a7e-2ad6-4873-b1a1-d953cfa762c1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', NULL, '2026-09-07 06:28:58'),
('879cc565-159c-481a-a10e-add9d2812fcb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('87b2911d-bca7-49e2-bd55-8ff0403080f7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('87b3a69a-b29b-452f-b625-837d28386f5b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('887d227d-3979-4c51-ac48-b7f13e3215cb', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10029-0000-4000-8000-000000000029', NULL, '2026-09-07 06:28:58'),
('88d28953-559a-4cdd-a7dd-7eaa544b2230', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('8b4bcebc-e64e-4277-99e1-8007f64dd9bc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('8b62845a-1855-468d-98cc-23a659c4ec0f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('8c3ebf17-8fdd-41be-895b-d7d3c28395b5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('8c514342-588a-4dd7-9894-196fcb5a0676', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('8c7cbe52-76a0-4484-a8d5-730e3a3071e7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('8cd8fb1b-5367-4211-8b0f-6ccc9d85f246', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('8d28956a-2847-46e9-bd29-ed896953e138', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('8d755be2-de0b-4578-a993-8d362e5f2f0a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:21'),
('8dd0bb0d-be11-4fba-80ac-0af5e63b0726', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('8dd44c96-bdaf-4281-a3b0-07ea957ff261', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('8f83e318-e57c-4ee2-913f-c524ed285501', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('8f9a4fe0-a40c-4d4f-af39-d38235d894f4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('90d0eee0-6381-4646-8e59-8137353e8123', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('9127ac21-cc74-4e1a-9671-f097deebbd93', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('920b2bd7-267d-4426-8f94-ff59a72a05e6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('937a8da3-bade-405b-8861-bb064b09e545', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('95b754de-f643-4171-99cd-cceb2512c807', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('967cbf02-ca4e-4f10-8d1e-782909a65f5e', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10014-0000-4000-8000-000000000014', NULL, '2026-09-07 06:28:58'),
('976cfcb0-e448-4b5f-8d4d-851cc83652b1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('9782f909-9a68-44d0-9d99-4898d4fc91bf', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('980ed0c9-d2f0-459b-b533-b2e14a63329e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:22'),
('98b58433-be2c-4c8a-b782-d3922c8b51a4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('98d9d232-1d59-4a87-b96a-771c6b02fc32', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('9ddf652a-e0f6-4373-80ec-01d334723be1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:58'),
('9e16e7b0-5261-4c65-836b-0fca86dd60bd', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10031-0000-4000-8000-000000000031', NULL, '2026-09-07 06:28:58'),
('9e7166a6-e886-419d-8b8a-a52da3f7d6dc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('9eaf2e76-2bc3-4777-86f6-ec9bbdcec185', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('9f1909e1-943c-405b-9e96-7078591f6fe7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('9f35c56e-d508-4a1f-a75b-efe23642ff80', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('a026595d-c599-438e-9f92-342d83be001d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('a081c93f-780d-43e4-9756-c32f9e023ea0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('a0993971-03a2-4bce-935e-7164d364209e', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10039-0000-4000-8000-000000000039', NULL, '2026-09-07 06:28:58'),
('a105ea5e-439d-4d26-92ae-54746687db72', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('a111aa7f-461a-46d8-968b-695a4ee442cb', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10025-0000-4000-8000-000000000025', NULL, '2026-09-07 06:28:59'),
('a1c51776-9b3e-4020-b4e0-f2ea9de03c39', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('a3529d0b-f789-4301-a358-a85f65d1409c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:20'),
('a43eb923-4dba-447f-9517-abbc9a2e9c1c', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10024-0000-4000-8000-000000000024', NULL, '2026-09-22 22:21:56'),
('a479abea-a92b-4dbe-95ee-4b28e31ab044', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-09-07 06:28:58'),
('a6c969a9-68d0-4b9c-85e0-3f9572a883cd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('a7a1b937-60ba-4636-bfac-05e9369c4bc1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('a8813366-1075-475a-bc36-490246f467d1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10022-0000-4000-8000-000000000022', NULL, '2026-09-07 06:28:58'),
('a90f47cb-db39-4119-b45f-2d7c292ff193', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', '610ce578-e823-4977-8f79-28da28a168ae', NULL, '2026-09-22 22:21:56'),
('ab691e8f-89b7-4c79-a7e7-de3e8fceb150', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('ab8aa727-fb6d-4614-96df-33c6957a3378', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('ad3efa01-751f-4d8a-bae0-ea035442b6fc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('ae502612-b8bc-4ff6-a57d-0880dae2509d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('ae6d682f-4883-46f5-855f-1acb7996d674', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('afbc5c73-4c48-40b1-91b2-b3b9d887d2b3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('b04d8801-1a2a-4f04-b4d1-725b8819fe79', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('b12b3396-8282-4a3b-8f7a-7d05e2fe3085', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10018-0000-4000-8000-000000000018', NULL, '2026-09-07 06:28:58'),
('b226e51f-c041-41fc-98ce-912b4efbea3d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('b2c4a832-9dff-4009-bce4-4e33f71ec687', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('b36dae32-0da0-4af4-a822-46acec5521de', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('b549857e-50de-4857-b1cd-696df3a12919', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('b59637eb-a191-40ac-923d-2b8b6d0f3bcd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('b69f64f1-fa07-4613-8876-a946bb9a8cad', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10010-0000-4000-8000-000000000010', NULL, '2026-09-07 06:28:58'),
('b6c3fa57-a9ce-4b5c-b9be-81f796eb0163', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('b8e095ac-557a-4e14-be98-524ebdd37a69', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('bb14577c-6421-45aa-b3b7-5cb0e52fc70c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:22'),
('bb53d414-c750-4323-a41e-428cd1c9b62b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('bb83f934-ec93-47f8-8f4e-709e19de267f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', NULL, '2026-09-07 06:28:58'),
('bc53bac4-f495-4657-84d3-6b8a9df3354c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('bd2c3e2b-4d91-4176-9719-22f2a365fe83', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10029-0000-4000-8000-000000000029', NULL, '2026-09-07 06:28:58'),
('bd47f331-6613-4c09-8cfe-f13dbdc5c7be', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10026-0000-4000-8000-000000000026', NULL, '2026-09-07 06:28:58'),
('bdadc49f-0b83-451a-b937-446b2f7998e3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('bdb4dc03-20bc-41bb-acad-30d509018f9e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('be623455-b327-4308-8b06-4e84e4d0399f', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('bf819aa9-72e2-4f0d-bed1-182a6a77daed', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('bfc0e50e-d75f-4fc6-bc69-f6430ed28ea4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('bffa3e42-fd09-49f9-88bf-2f60404fc252', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('c003f06c-0c83-4865-baa9-771ab6093990', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('c0d983a4-8b87-4561-a386-d1692c790a7f', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-22 22:21:56'),
('c147be77-b666-4fe9-9bcd-3e3423d728e0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('c1babcad-6005-4e18-832f-1844bb2e4f43', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('c432cbcd-57a0-4a3d-baf9-8b0054a069e1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('c5206b6d-c6f3-4e3a-931f-ca9c9e0936a1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('c547bc84-4193-410b-b92e-efafc7d87ea3', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', NULL, '2026-09-07 06:28:58'),
('c5d41ee1-293c-46f6-af06-17dfeabe151c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'rcqgju2wsyaoilufnv0afwurkxop9oqt', '2026-09-07 17:55:22'),
('c7b53d5d-80ea-4873-8f2b-5758e3e347eb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('c7dca0cb-938f-412b-b965-074c0ff36c95', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('c879f002-88d3-4efd-a8e2-5b51ef07d22c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('c8809b43-96c1-441c-a10b-8673d94f136e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('c8aba475-bc54-452a-97df-8bc7a4682ad5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('c8ad2060-2a93-4298-adae-6b002eadccc8', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-09-07 06:28:58'),
('c9e8278a-16ab-4d17-936b-6308826fbad9', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('caffd4d5-89f4-4d5a-902e-f19728102cb2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('cd0ddd7e-c070-4cdc-8a81-592ff1b24ffe', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'b5624339-3f3a-439a-954f-88b2251f3b3b', NULL, '2026-09-22 22:21:56'),
('cd93afb4-6930-4a21-aa4b-5d051a899262', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('cde4dd1c-b8fe-4bc5-b875-00b6dae6265c', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:59');
INSERT INTO `role_permission` (`id`, `user_id`, `role_id`, `permission_id`, `position_id`, `created_at`) VALUES
('ced76e8b-7b8e-46ab-8162-6a15a6fdbf26', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10018-0000-4000-8000-000000000018', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('cfc8f5a2-00fc-42a7-b246-e358e3ba9db5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', '6nqdbkvxj7pj6ct6pcxmn78zerrzcbns', '2026-09-07 17:55:24'),
('d05285ac-55f1-4af6-baa3-ba9903c92f11', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('d16ce92c-7411-4fcd-ae41-d3acbc270ad7', NULL, '5124691a-b33f-4697-9c1a-d1701e22e31a', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-22 22:21:56'),
('d2284a1a-178b-4ea7-b116-57d051d215d7', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10008-0000-4000-8000-000000000008', NULL, '2026-09-07 06:28:58'),
('d3a3f7bc-ddfd-42ff-b360-57f3ca7cc180', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10011-0000-4000-8000-000000000011', NULL, '2026-09-07 06:28:58'),
('d3c30b2c-9c7b-4d8f-b220-77d42331540d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('d4cc50dd-308e-41ec-9d64-ffdf6b92270b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('d594f19d-c40b-4d06-9758-2a679f62144a', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('d733671a-4ffa-426d-aeb3-5b31c7c669da', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'qwef7qelcixo5hi3nrmmivevzvxkpwzs', '2026-09-23 01:42:21'),
('d83815fb-0326-4ea1-8d23-cb215b03d334', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10019-0000-4000-8000-000000000019', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('d877439c-e484-474b-a3cd-40d5ed4b52bd', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10036-0000-4000-8000-000000000036', NULL, '2026-09-07 06:28:58'),
('d9e88480-03fe-4fec-b53d-66d8561b2100', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('d9f20a19-2d94-4de8-a499-5f0f374050b9', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('da2c1f4e-04bc-4698-8de2-0b6082136f6d', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10039-0000-4000-8000-000000000039', NULL, '2026-09-07 06:28:58'),
('da5ab2cf-b673-4782-88dd-f6551e660cbe', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10043-0000-4000-8000-000000000043', NULL, '2026-09-07 06:28:58'),
('da91abe3-6abb-4e0b-91b1-fae497afc1e2', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10013-0000-4000-8000-000000000013', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('db0c4d93-d8ee-4fda-ad10-505f7df7f196', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10012-0000-4000-8000-000000000012', NULL, '2026-09-07 06:28:58'),
('de3c83ab-f1a3-4fcd-b094-2865f9944890', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10033-0000-4000-8000-000000000033', NULL, '2026-09-07 06:28:58'),
('deabbfce-a52f-4a40-8879-7e2215326d21', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('df34b0b8-e249-4440-9a68-cacc1e7456c8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('df9185cd-cdfd-4785-b662-271adb88a5f1', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('dfc698fe-8a02-4ddd-822d-204e9b812da1', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10041-0000-4000-8000-000000000041', NULL, '2026-09-07 06:28:58'),
('e0f601b9-5f60-4217-ad3f-cef71a10685e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('e162b16f-7983-44da-b41f-7db744f2d191', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('e23bbe69-0a68-43fb-8aac-f09d3c6a00dc', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10040-0000-4000-8000-000000000040', NULL, '2026-09-07 06:28:58'),
('e24a2e76-baca-41de-91df-94b4a72c3158', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('e2783f37-173a-484b-abdc-0d402b77efff', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10006-0000-4000-8000-000000000006', NULL, '2026-09-07 06:28:58'),
('e34219d0-bf32-41b1-98ed-a28c5d74f7a4', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10015-0000-4000-8000-000000000015', NULL, '2026-09-07 06:28:58'),
('e385c68a-1c1e-43f3-9631-f0ef169eeba5', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-07 06:28:58'),
('e3dfa70f-e220-4cde-8ad3-4ca1562a753c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('e51aa940-51ad-4fa9-81d1-5131e5fc2e02', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10017-0000-4000-8000-000000000017', NULL, '2026-09-07 06:28:58'),
('e53baafb-b49b-4b7f-8afd-751a3975e6c9', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('e591dd98-7129-4527-a412-463c2b3fdf96', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('e659d588-7bc1-4272-a1fd-492ed4eb087c', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10010-0000-4000-8000-000000000010', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('e749b0de-e0d1-4ddd-889b-346066017ba6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('e74e7958-aa58-4b84-b10d-6787a9a17a8b', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'e6c51d75-ffe3-490d-98f2-4cbef75ee378', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('e7d0cb85-bb26-492e-a470-b55660887cdc', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-07 06:28:58'),
('e86f0e1d-ed97-44de-ad7f-18a0b3da4f43', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('e997f3f5-cf8b-440f-9890-4b7329886da5', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'ytiqwugtxxbyorspbc1qbzq8xno7bvz0', '2026-09-07 17:55:24'),
('e9b901a5-d943-4742-ae6f-d9ad74dcf4b0', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('e9be7ca0-a0bf-473b-ab50-ef1f489c24ca', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10035-0000-4000-8000-000000000035', NULL, '2026-09-07 06:28:58'),
('ee11b588-08bd-4df2-a511-69f55f7158d7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('ee82ff9a-f242-452a-b1ad-716e5e44b8dd', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', NULL, '2026-09-07 06:28:58'),
('ef32ed57-e579-465a-b879-7cfa36f1c9ba', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-07 06:28:58'),
('efc14853-e844-4c5d-adba-7434a4f5e059', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'qjtim1ggjxclcljt5at73oetsntp5lm8', '2026-09-07 17:55:23'),
('f02a3c7d-4bc8-48a5-a3f7-6c5809f2820e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('f0d9d747-e8ee-4c8a-a906-0d41c6729fcc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('f154a1f6-764f-48ac-b461-b6940a9342b6', NULL, 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'a1b10001-0000-4000-8000-000000000001', NULL, '2026-09-07 06:28:58'),
('f1889716-f977-43fd-8bd3-90639cf67096', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10021-0000-4000-8000-000000000021', NULL, '2026-09-07 06:28:58'),
('f25b1843-1f3f-426b-9803-9ffb8a55a6d6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('f380bf95-e03b-4cd4-b321-65829a5b29d2', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10007-0000-4000-8000-000000000007', NULL, '2026-09-07 06:28:58'),
('f3c2f9e1-55c4-422b-8478-3b9281723e7e', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('f40f1b43-fa50-43dc-aea3-f32180818e94', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10024-0000-4000-8000-000000000024', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('f44ca044-44c9-42b1-b380-3bcf7c3fe2a1', NULL, '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'a1b10028-0000-4000-8000-000000000028', NULL, '2026-09-22 22:23:03'),
('f54ecac7-e253-43be-bd3a-8f1ae7488509', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'dwitgz3kzi1dljjik6ubuzvsbhoa7cyc', '2026-09-07 17:55:23'),
('f56496d5-a379-45fe-9afc-8a0050f74658', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10043-0000-4000-8000-000000000043', NULL, '2026-09-07 06:28:58'),
('f5d03703-6e84-4bae-a9d5-3042ec91d4e7', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10020-0000-4000-8000-000000000020', 'ymmwbp4nqedawvo2puiimcoabxj855wx', '2026-09-07 17:55:23'),
('f5d2ac4a-476d-4aa2-83d6-df6a6d574b9a', NULL, 'e7741b61-b586-4e21-bc3e-dea741d05ae6', 'a1b10016-0000-4000-8000-000000000016', NULL, '2026-09-07 06:28:58'),
('f7322908-6cc5-4554-b9aa-9cdfe8eb9930', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10012-0000-4000-8000-000000000012', 'a6gwfcioumlfbouuqrdg4uxh53b0vtj6', '2026-09-07 17:55:22'),
('f797ae98-abaf-4873-8e48-69984931c1a8', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10007-0000-4000-8000-000000000007', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('f7ceabc3-c81c-43b5-af7e-2cc0e2642648', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10004-0000-4000-8000-000000000004', '5uvqzamuyudnjelaat3eg9hqvkwsjjn0', '2026-09-07 17:55:24'),
('f908185f-4298-466b-843f-204c8fb254cc', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10002-0000-4000-8000-000000000002', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('f93d1bd6-f584-4eaf-b129-7ff580bdd37d', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('fb15e6f6-ada0-42ea-a475-af42c152992c', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10013-0000-4000-8000-000000000013', NULL, '2026-09-07 06:28:58'),
('fc529963-89e3-4ac7-8425-8c59a2ff67fe', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10003-0000-4000-8000-000000000003', 'f5ssbkxesaexrd5qddpvliuunl8xkzco', '2026-09-07 17:55:23'),
('fc9ae215-d05f-4528-bdb1-a0b581f4d624', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23'),
('fcd77549-79fd-448c-82be-1d24563006ad', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10008-0000-4000-8000-000000000008', 'd6zmpklwrr4bealvclya0sd7sspb4sn4', '2026-09-07 17:55:23'),
('fd930067-fd1d-4f7e-8679-ed8874a66532', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10021-0000-4000-8000-000000000021', 'nkvv7loq6oc6wctbk4ngck1jk3vcw938', '2026-09-07 17:55:22'),
('fe131d3f-ef42-44f4-a35f-e460610cd2bb', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'a1b10009-0000-4000-8000-000000000009', '5epndb4oho94dy81m5bvcmxizoxgxcn9', '2026-09-07 17:55:23'),
('ff04959d-0ddc-4765-a335-f14808de2fce', NULL, 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'a1b10037-0000-4000-8000-000000000037', NULL, '2026-09-07 06:28:58'),
('ff39ba65-2285-4527-9b3e-a4345b0b08a6', NULL, '86e5aeee-043c-4b27-af63-4a396ee956f6', 'acb7b197-cb89-4e0f-a135-2b3c64affffd', 'daqqum81lqom3w5lde5unsn3k54bymmn', '2026-09-07 17:55:23');

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
('irSP73bHB51JSmTDLtEmg42VIISDTtQd7RtZM4zw', 'bb139edb-de27-4548-bdb2-31e06d701716', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZnBaRGlsR3FDRngyWEI2ckE5Z2p2alM3eDI5RFh2ZTBGWDZOaUdTWCI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozNjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkdmlzZXIvbGVkZ2VyIjt9czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZHZpc2VyL2FwcHJvdmFscyI7czo1OiJyb3V0ZSI7czoxNzoiYWR2aXNlci5hcHByb3ZhbHMiO31zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiYmIxMzllZGItZGUyNy00NTQ4LWJkYjItMzFlMDZkNzAxNzE2Ijt9', 1790269536, 0),
('oXAFNZ9eTUTKBk6pBI0xIL0lEuoS3vLmhLZPahee', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/153.0.0.0 Safari/537.36', 'YTo2OntzOjY6Il90b2tlbiI7czo0MDoiemtZa0ROekxKd0RPeWNWNkg4WGtjSXA4cHlQaHdYMkJldDk4cUh1OSI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2NzZy9sZWRnZXIiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czoyNToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2NzZyI7czo1OiJyb3V0ZSI7czoxMzoiY3NnLmRhc2hib2FyZCI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtzOjM2OiI4YmIwZjIyYS02NWY1LTQwMmMtODJhNC1kN2E2MGI3OWY1ZTkiO3M6MTc6InBhc3N3b3JkX2hhc2hfd2ViIjtzOjY0OiJlMjUyMDUwYzUxOTlhNzAyZGMyZjRjYjllN2JhNjRmYjA2MzU0MWYyMDViNGZjMzdlMmUzZDA3ZGM5N2I0MTQ0Ijt9', 1790269532, 1);

-- --------------------------------------------------------

--
-- Table structure for table `student_csg_officer`
--

CREATE TABLE `student_csg_officer` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
('2023', '8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 1, 'President', '2026-09-14', '2027-07-19', 1, '2026-09-16 12:55:11', '2026-09-24 08:01:02', 0),
('2023-2-000743', 'b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, 'Member', NULL, NULL, 0, '2026-09-16 14:01:30', '2026-09-20 15:13:10', 0),
('2024-1-000094', 'fecf41cc-142d-4038-a152-8fa34718ad37', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-22 05:52:15', '2026-09-22 05:52:15', 0),
('2024-1-000189', 'f2c4d064-6654-4cc5-99e4-094714cef15a', '5b28cedf-abc5-4f97-a719-980bbcd1a9f5', 0, NULL, NULL, NULL, 1, '2026-09-22 05:54:07', '2026-09-22 05:54:07', 0),
('2024-1-000424', '11a031e9-b7fb-42c5-b0f8-461c2e2ae827', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-22 05:16:53', '2026-09-22 05:16:53', 0),
('2024-2-000263', '5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 'e133d759-1965-4cc4-b0ec-4890329e4edf', 0, NULL, NULL, NULL, 1, '2026-09-22 05:51:28', '2026-09-22 05:51:28', 0),
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
('2026-006981', '7c1c5079-05ca-4468-800c-463b24e22030', 'a7aab4e8-0f1f-4f62-96cf-78a219b925da', 0, NULL, NULL, NULL, 1, '2026-09-22 05:37:31', '2026-09-22 05:37:31', 0),
('2026-064857', '00888baa-1ec4-4296-8de6-64a469963b14', '19719e81-53c4-44d1-bbd3-927880ef12cd', 0, NULL, NULL, NULL, 1, '2026-09-22 06:21:20', '2026-09-22 06:21:20', 0),
('71717117', '24b9b9e9-113a-400f-b154-03d50737ca72', '6fa069d5-b9f1-439d-8b9f-522549aafb6a', 0, NULL, NULL, NULL, 1, '2026-09-21 07:02:20', '2026-09-21 07:02:20', 0),
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
('06830', '3f6576aa-c747-47c5-9f69-abe36b4ef100', '1d52bc53-b43e-4b7d-aea7-16fe042c1d79', 0, '2026-09-23 01:59:26', '2026-09-23 01:59:26', 0),
('T-676767', 'bb139edb-de27-4548-bdb2-31e06d701716', 'f4728bb1-154f-40c6-be2a-8e9804b57da2', 1, '2026-09-21 12:53:03', '2026-09-22 11:27:13', 0);

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
('01e1a005-fcbf-4e5b-af03-f060d50348fa', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JUSTINE JOHN LUCERO', 'jjlucero@kld.edu.ph', '2026-09-22 06:41:57', NULL, NULL, 0, NULL, '$2y$12$ECnjpYAbb0L15s54gDoPqemwj..wCXbmd2wnK7cFnIJ3WIOlDOyg6', 'https://www.gravatar.com/avatar/56ba9244209a27353483437ff4c6ab09?s=400&d=identicon', 1, NULL, 'active', '2026-09-22 06:42:13', NULL, '2026-09-22 06:41:57', '2026-09-22 06:42:13', 0),
('05f4c23e-a777-416d-b709-272a5ab75f9c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Seth Ebuña', 'asebuna@kld.edu.ph', '2026-09-21 12:00:04', NULL, NULL, 0, NULL, '$2y$12$bgd/e0pu4RhMoMFByPQQ2ujgbqIOeYfjDxXuNfvm9dVCTRtsmp8T.', 'https://www.gravatar.com/avatar/1eca587cfb0b9e06c71f87a8ff5895f6?s=400&d=identicon', 1, NULL, 'active', '2026-09-21 12:00:45', NULL, '2026-09-21 12:00:04', '2026-09-21 12:00:45', 0),
('0acf2825-1aff-4bd5-b24b-3fd79375fd49', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Elijah Joyce Dela Rama Vicente', 'ejdvicente@kld.edu.ph', '2026-09-22 03:18:54', NULL, NULL, 0, NULL, '$2y$12$R9dmtDiD8TaKX/Gc2A16MOWS2QgOVA0UhzeuE7kJc018t3tiyEXCO', 'https://lh3.googleusercontent.com/a/ACg8ocK-QnpQUyLG2x_5439_Gy1NvJ-JcEfmmx4VfBp1KHeoQT_c1g=s96-c', 1, NULL, 'active', '2026-09-22 03:18:54', NULL, '2026-09-22 03:18:54', '2026-09-22 03:19:07', 0),
('0e77b5d7-8a68-49e4-9b37-5f9bbb05429a', '86e5aeee-043c-4b27-af63-4a396ee956f6', 'Dr. Joseph Price V', 'ruthe.ferry@example.org', '2026-09-24 07:08:34', NULL, NULL, 0, NULL, '$2y$12$vqCf6igH8ES.y5.gbvAgAeTdjXqSP01wiGq/lJcBUKvXCt30xnCJW', NULL, 0, NULL, 'active', NULL, NULL, '2026-09-24 07:08:34', '2026-09-24 07:08:34', 0),
('11a031e9-b7fb-42c5-b0f8-461c2e2ae827', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Justine Sedricj Ramos', 'jsramos@kld.edu.ph', '2026-09-22 05:16:53', NULL, NULL, 0, NULL, '$2y$12$qXftKlazzCZ0lToBGKpBfuHQW8yKiLxcS2lvM8echSCx6gc5jhLyy', 'https://www.gravatar.com/avatar/0b1b863bd122d3d8bc50e9da8399c8b5?s=400&d=identicon', 1, NULL, 'active', '2026-09-22 05:17:20', NULL, '2026-09-22 05:16:53', '2026-09-22 05:17:20', 0),
('1532c8ff-88f3-46da-8222-9df946116efa', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Lim H. Roque', 'limroque@kld.edu.ph', '2026-09-22 06:38:03', NULL, NULL, 0, NULL, '$2y$12$YvTPy/X0SZJ/ryWw0rRmx.R8YhVQCQ7EIvcbryDJU65WcLk6K7IFS', 'https://lh3.googleusercontent.com/a/ACg8ocKtgHu0RktT8Y72GKNooJXL5ru0WWl2-35l25v9jp2x7tQS2WE=s96-c', 1, NULL, 'active', '2026-09-22 06:38:03', NULL, '2026-09-22 06:38:03', '2026-09-22 06:39:10', 0),
('1957970f-e67f-4d9a-b773-94b81f84b937', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Earl Vincent Tecson', 'evtecson@kld.edu.ph', '2026-09-22 06:20:24', NULL, NULL, 0, NULL, '$2y$12$ydyGsL4AbJRFn1aUO8HU8.trLGFo8kVDT2xyJER/MRs5yHZUQQmvq', 'https://lh3.googleusercontent.com/a/ACg8ocIcxh2TRpKMr8sNYPP2hqeaIWirnvkkmDllrEO-BeHCJH999pg=s96-c', 1, NULL, 'active', '2026-09-22 06:20:24', NULL, '2026-09-22 06:20:24', '2026-09-22 06:20:57', 0),
('2385bf74-ee55-482d-9dba-689532e3a949', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Maria Jovie Dolorzo', 'mjdolorzo@kld.edu.ph', '2026-09-23 01:38:09', NULL, NULL, 0, NULL, '$2y$12$neT2bnFImLKKPzfk6ODlLuUWG3EzBxhPZC39e/fZ3f9R2iDZrdT4y', 'https://lh3.googleusercontent.com/a/ACg8ocITNF8pdnK1jVh8iCDvvRw7s0YYGZyW_JJQewep7Ua7vBFgnA=s96-c', 1, NULL, 'active', '2026-09-23 01:38:09', NULL, '2026-09-23 01:38:09', '2026-09-23 01:38:49', 0),
('24b9b9e9-113a-400f-b154-03d50737ca72', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'JAMES TORILLAS TAMAYO', 'jttamayo@kld.edu.ph', '2026-09-21 07:01:23', NULL, NULL, 0, NULL, '$2y$12$I/KjxkuZyojfxtFZjdw3V.t3cw52.m/GP2IyeP5id2JDsGq9u9pPi', 'https://lh3.googleusercontent.com/a/ACg8ocJSq8gDznGQvQNLtVugx21hZN-Z40sehpu-m1mE9a1HhJkOGQ=s96-c', 1, NULL, 'active', '2026-09-22 12:30:50', NULL, '2026-09-21 07:01:23', '2026-09-22 12:30:50', 0),
('2685f8e1-10ae-4337-a650-70bd0b45a3ba', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Princess Gail Taupo Magbanua', 'pgtmagbanua@kld.edu.ph', '2026-09-22 03:15:53', NULL, NULL, 0, NULL, '$2y$12$r7WK0Y.jjXy4tYIIr.lZJ.1eabQBt1eYXI0DjNsYZHgmO5uNsB9AO', 'https://lh3.googleusercontent.com/a/ACg8ocL36T6JvxEDTsgI5xfJtbJHcreOnI3TIwDZdy9TnwfitP5B_PQ=s96-c', 1, NULL, 'active', '2026-09-22 03:15:53', NULL, '2026-09-22 03:15:53', '2026-09-22 03:16:18', 0),
('2f634388-8250-4c80-8d57-20e331c9de64', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Shekynah Maeley Calibuso Agapito', 'smcagapito@kld.edu.ph', '2026-09-22 03:16:42', NULL, NULL, 0, NULL, '$2y$12$8eYRXzCMGuakpLv92sehue93yhysXKHFk.6HCnRrWGoCdquVFc/Ja', 'https://lh3.googleusercontent.com/a/ACg8ocL4mNnVAL1o4uYhmyDCjaNZEL8cd4kUKak9XDkBJtXekLyTHw=s96-c', 1, NULL, 'active', '2026-09-22 03:19:41', NULL, '2026-09-22 03:16:42', '2026-09-22 03:19:41', 0),
('3f6576aa-c747-47c5-9f69-abe36b4ef100', '48fe948e-2140-4fc8-86d0-8b063a9068a5', 'MARK CHRISTOPHER BORJA', 'mcborja@kld.edu.ph', '2026-09-23 01:59:26', NULL, NULL, 0, NULL, '$2y$12$7.saGza8LjQNqRm8wXXKw.jWKve2uvCotgKNV6nho66Khe62fIs8a', NULL, 1, NULL, 'active', NULL, NULL, '2026-09-23 01:57:53', '2026-09-23 01:59:26', 0),
('4364f571-2368-479e-8ec2-491d176c693a', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Mark Ryan Pacoma Mendoza', 'mrpmendoza@kld.edu.ph', '2026-09-22 03:17:18', NULL, NULL, 0, NULL, '$2y$12$QKEYSYBoH/LpWUT9DbUWSu96qLWAFzuQNtv85XTi5bweCpGocqZO6', 'https://lh3.googleusercontent.com/a/ACg8ocJnDAc8wqPAWJdblKK_yEe3sSjWN67IDj45MU2SWzecrO51-zI=s96-c', 1, NULL, 'active', '2026-09-22 03:18:49', NULL, '2026-09-22 03:17:18', '2026-09-22 03:18:49', 0),
('54ae97c2-c473-4975-aacc-d44d84591628', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Juris Inocencio', 'jinocencio@kld.edu.ph', '2026-09-21 11:22:35', NULL, NULL, 0, NULL, '$2y$12$7qyJfAct44vzZmXiTAlzgOcqdd4wiAJe3UCjohDVeQgAQlWBvpYOO', 'https://lh3.googleusercontent.com/a/ACg8ocIby9qdcX6PW9K1m_Cw06USwQgsonYYZfOtULrTOSf0Ieyw0hU=s96-c', 1, NULL, 'active', '2026-09-21 11:22:35', NULL, '2026-09-21 11:22:35', '2026-09-21 11:22:40', 0),
('5eadaf08-ee9e-44e8-97e1-d4ce2a6f28db', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Alexander Sarita', 'asarita@kld.edu.ph', '2026-09-22 05:51:11', NULL, NULL, 0, NULL, '$2y$12$gA.qHbTgOAL.Vi.dVO.07uZaVFQfoiVoRn8J.37iwNOBmPjQUVimi', 'https://lh3.googleusercontent.com/a/ACg8ocIcwtrGYcXyQ4wdw8x_QZ3QtOth9bnWL0vFyj6pM15abN4bBeE=s96-c', 1, NULL, 'active', '2026-09-22 05:51:11', NULL, '2026-09-22 05:51:11', '2026-09-22 05:51:29', 0),
('7c1c5079-05ca-4468-800c-463b24e22030', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Karel Pormatelo', 'kcpormatelo@kld.edu.ph', '2026-09-22 05:37:00', NULL, NULL, 0, NULL, '$2y$12$Q5qEigSAyUldV3ECzapDgOBpeUirswzfVXzUIeIoIrXCICkcRfm26', 'https://lh3.googleusercontent.com/a/ACg8ocK50TqQHEsXdTPZYsWv9Azt9b9NM_W6YmqRyOdTmTciwq9EWA=s96-c', 1, NULL, 'active', '2026-09-22 05:37:00', NULL, '2026-09-22 05:37:00', '2026-09-22 05:37:31', 0),
('82a0e5a1-40cc-4940-a33e-4965da5f1aa8', 'dc048dd8-14a2-40f0-b29d-2b8fa3c0d91c', 'STEP Super Admin', 'superadmin@kld.edu.ph', '2026-09-07 06:28:59', NULL, NULL, 0, NULL, '$2y$12$3LoIn2J5DvBdb.et1cD0h.FgZLLZda0F8OxULsSd3vDAo.B83wQPi', NULL, 0, NULL, 'active', '2026-09-23 09:08:57', NULL, '2026-09-07 06:28:59', '2026-09-23 09:08:57', 0),
('89861b06-b0fc-4c57-89a8-fc17ebb7a240', '86e5aeee-043c-4b27-af63-4a396ee956f6', 'Keara Kemmer Sr.', 'jfarrell@example.com', '2026-09-23 04:30:27', NULL, NULL, 0, NULL, '$2y$12$Ffw2rXPLn5x32HU3wTzmV.DSCVJGNL/gqybulQgTCFoumSnzWG/66', NULL, 0, NULL, 'active', NULL, NULL, '2026-09-23 04:30:27', '2026-09-23 04:30:27', 0),
('8bb0f22a-65f5-402c-82a4-d7a60b79f5e9', '86e5aeee-043c-4b27-af63-4a396ee956f6', 'Edward Quintos', 'emdgquintos@kld.edu.ph', '2026-09-16 12:54:50', NULL, NULL, 0, NULL, '$2y$12$lOSPq.3OFDlYiTDtQ5do9O32ZGt1h0kOFOqE9IzeF3bPA2oJNoW4C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, NULL, 'active', '2026-09-24 06:50:27', NULL, '2026-09-16 12:54:50', '2026-09-24 08:01:02', 0),
('952befae-6ce5-4ea7-a018-3bb3e638a90e', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Amira Joanne Punzalan Magnanao', 'ajpmagnanao@kld.edu.ph', '2026-09-22 03:15:55', NULL, NULL, 0, NULL, '$2y$12$vRixX5thvjltQPwtnHiz9uu5cOkOmlclSzHSnKPV5Go9rG59sXxMK', 'https://lh3.googleusercontent.com/a/ACg8ocIZD8UvXPMvcIUwaGl9KZW9nHN5cB2L9tM34GcRDk4yEpue5w=s96-c', 1, NULL, 'active', '2026-09-22 03:16:25', NULL, '2026-09-22 03:15:55', '2026-09-22 03:16:25', 0),
('b01f59b1-814e-4400-a267-6e1edbd3bd2c', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Lawrence Calibuso', 'lpcalibuso@kld.edu.ph', '2026-09-16 14:01:10', NULL, NULL, 0, NULL, '$2y$12$hn.5Ddz45q0h1jggkgyUhuwQq/kGXxPJpQ4tZEtUnIOScHjHe5NgK', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, NULL, 'active', '2026-09-23 01:43:20', NULL, '2026-09-16 14:01:10', '2026-09-23 01:43:20', 0),
('b9b9ca53-1785-4170-9247-73ac4b1d28fd', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Cathlene Latoja', 'clatoja@kld.edu.ph', '2026-09-21 12:52:57', NULL, NULL, 0, NULL, '$2y$12$iHQJsPi7p3NIBMBddKK0redweCYJabtHWjkHLa7/Xd848RMuEQatC', 'https://lh3.googleusercontent.com/a/ACg8ocLMtkpFvrS_W2-gJfjTg5bb-q5WAv9i9tB7dMqAwHQgcE969A=s96-c', 1, NULL, 'active', '2026-09-21 12:52:57', NULL, '2026-09-21 12:52:57', '2026-09-21 12:53:21', 0),
('bb139edb-de27-4548-bdb2-31e06d701716', '5124691a-b33f-4697-9c1a-d1701e22e31a', 'JHONNY SUMULONG', 'jmsumulong@kld.edu.ph', '2026-09-21 12:53:03', NULL, NULL, 0, '09234234234', '$2y$12$T7pqE4DPlUfU1rfFoC2RWePxUdjVuoPQKS1LYEWH.v3.SDcQggi3a', 'https://lh3.googleusercontent.com/a/ACg8ocLXVrWI7RGw1OTDRtjF9lXO27fk8oBLR-ZI3irgbXl_7fS5sA=s96-c', 1, NULL, 'active', '2026-09-24 06:55:15', NULL, '2026-09-21 12:52:30', '2026-09-24 06:55:15', 0),
('ca30fd6a-d7ec-4f34-9e76-5e67bf9a9934', 'd8355788-14ce-4db6-b004-9dd26abfaccc', 'Laurence Raff Dacanay Valentino', 'lrdvalentino@kld.edu.ph', '2026-09-22 03:16:54', NULL, NULL, 0, NULL, '$2y$12$R7J8KtNsMk323KzzR6rDZOEdAf2Qu6k/aBHNlfK2aYGkQRFjDzMJ2', 'https://lh3.googleusercontent.com/a/ACg8ocKLiowmaeYfDBOxoCHNJBJzCcW3RGjEutlnO-cCpbOOemJdWA=s96-c', 1, NULL, 'active', '2026-09-22 03:17:28', NULL, '2026-09-22 03:16:54', '2026-09-22 03:17:28', 0),
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
-- Indexes for table `student_csg_officer`
--
ALTER TABLE `student_csg_officer`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `student_csg_officer`
--
ALTER TABLE `student_csg_officer`
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
