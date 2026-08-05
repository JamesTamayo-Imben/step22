-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 04, 2026 at 07:55 PM
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
('003b99fa-a6fb-4213-a8df-a389bb7185f5', NULL, '8fb791ab-0b43-485b-a1e2-4257a133501f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:19:00', 0),
('00667182-0c6c-4120-adda-ae66ab07a98c', '087ccbc9-efa8-44e0-8435-3310207554d7', '9a7f0d48-2551-46a0-af17-0eb3e067bd0a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'asfsda — dfgsdfs', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:00:56', 0),
('0148d75a-7160-4442-8327-4d7b431fe3a1', '31fcedfb-f507-44bd-ad89-336c55539fea', '0a0a0805-5c74-471f-a79c-9e06d7e023cc', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID d01968a8-3a78-449a-959d-b50575c9351f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:11:18', 0),
('01516cef-b7e4-423a-b6c0-f36bcfaebcf5', NULL, '1931ee21-d300-47cf-8a30-da6d25ecd87d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"INTIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:44:26', 0),
('01f616dc-2182-4cbc-8df6-b8e435d36265', NULL, '17ca062a-87e2-483b-97cb-683bff711cb7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 13:32:26', 0),
('03053ea6-c6fc-428f-a66d-398cc024c4a3', NULL, '4f84dd08-5a1f-4c57-b5de-716ba6ddfc6d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:38:56', 0),
('03251ee1-4cbd-4a58-bc08-a86f727cd497', NULL, 'e62fb4ba-1bf6-49cb-b69c-b48a3ffcab20', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerrty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 14:31:21', 0),
('039ed88a-e59d-4f83-9782-b925001ad582', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ba0a15cb-eb83-4fc0-bee6-5b196d691e1d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 12', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:38:03', 0),
('04875dec-8231-48a2-874a-8e6ef25073d7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c0578485-b459-42d5-a130-50b9fe92aca9', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 02:00:59', 0),
('04ef2412-f7fe-4080-bc09-1123d3659f63', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:05:21', 0),
('0589682a-882b-45d0-9280-84215d1a5fb1', NULL, '29b2965e-f05a-4626-b0d0-78d982165725', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ddddddddddddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:25:43', 0),
('0598c20a-d6c0-4337-b8f6-2f17a9eb30c4', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd3ab57ac-3ffa-4a7f-94f7-0896e815a3d0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:00:52', 0),
('05e99d41-b95f-4144-a5f2-7d3e71fcab0e', '087ccbc9-efa8-44e0-8435-3310207554d7', '78db131f-e83e-4758-851d-2eeb4a7d04fa', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - ADDING LEDGER ENTRY — TEST A - START UP MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 01:30:11', 0),
('060c7203-d88e-4183-b608-10c208c112b0', NULL, '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 77c95044-68c8-4ac5-aa6f-6e20437047ea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:51:31', 0),
('06570619-3ef7-4a22-adbc-fdd2c6b68535', NULL, 'ce97f462-8d9d-4941-be93-91976f027512', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:52:38', 0),
('06ca03a1-572c-4ac0-9431-53df0184ee31', NULL, 'ee37254b-b985-4a8f-832b-e894aa30397e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:17:38', 0),
('08b054cc-9052-47d1-8a55-47e840c486af', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b5da8c88-1d30-454e-b4f7-2c98b0014416', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hi', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:08:28', 0),
('099db2ce-a7f9-4478-aa22-17c51ef86e32', NULL, '3eead227-7e20-413c-9c1a-a1d9103bf463', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:39', 0),
('0aa9520e-e5e0-4ce1-ad2f-2bc70f059e40', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:08:34', 0),
('0ace6ad7-00bc-4fce-a372-96f50e0090e8', '31fcedfb-f507-44bd-ad89-336c55539fea', 'fe38de78-dd42-4e6d-adfb-e6da63a711fa', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:07:51', 0),
('0c059c20-2e52-4ee7-909a-7bcc9e88166e', NULL, '08a38a8d-9635-4203-a5b4-37c3995ab13f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST G - PROJECT INITIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 02:09:14', 0),
('0c3f457b-20b5-4acd-ae1a-44c9ff53c342', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:25:06', 0),
('0c9d2684-5af5-422f-b4a1-78ad6645dc10', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:25:01', 0),
('0d173cd9-5c4b-4e41-9649-8eaa0f2d410d', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:14:10', 0),
('0daa7fd6-7725-4c01-bb7b-91c6d6db65d9', '087ccbc9-efa8-44e0-8435-3310207554d7', '69fd9f32-3048-4792-acb8-8bf2ebe03536', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: h', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:05:36', 0),
('0dc76f91-db3e-4eee-9bac-d965bfd208a1', '087ccbc9-efa8-44e0-8435-3310207554d7', '296ab788-40e6-434d-b4ce-3489280b6c6f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 11', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:37:13', 0),
('0de84e8d-f718-4a38-935d-e7ea43fe297d', NULL, 'b2380680-7033-4db1-a223-e45bf473afc5', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"errr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:08:01', 0),
('0e1ea823-8e58-412d-ba8d-57d77c0c65b9', '087ccbc9-efa8-44e0-8435-3310207554d7', '4f84dd08-5a1f-4c57-b5de-716ba6ddfc6d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 04:42:56', 0),
('0e206815-486b-407c-b6f7-9caec137d4ea', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:32', 0),
('0e40dd33-fc25-4b1a-80c5-e733f6f48fa4', '087ccbc9-efa8-44e0-8435-3310207554d7', '573e6dc3-bb44-4427-a02d-1d66c9898157', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:17:05', 0),
('0ec91b40-9284-43b5-938b-0dd4df9adc31', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:11', 0),
('0f15f3cf-fbb9-443a-826a-8c3f692b9629', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:34:22', 0),
('0fefa7e6-2c68-4a43-987b-051c2dbba4d4', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:10', 0),
('100b8623-7dca-4045-bad9-b25e8df81d7b', NULL, 'ac25a3f2-fba8-4a11-a84d-c13807febe07', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eeeeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:08:31', 0),
('10685a1b-1595-44e4-9bbc-1d5ca5c53ab7', '6373498c-903e-43a9-bb1d-b67a496aee24', '1d3ec754-568b-46e4-a487-ab684cb2a09d', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:32:23', 0),
('10d137ab-9ca2-4bec-9965-cac036cb808e', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:04', 0),
('1135bc9f-c022-4969-a11f-2fb0647be7c7', '087ccbc9-efa8-44e0-8435-3310207554d7', '556d3b58-be3e-4b98-831e-bb8691bbc4c4', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A2 — TEST A - START MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:45:53', 0),
('11c30957-cff6-422d-9999-adf376e11258', NULL, 'f7f8b067-e630-4809-959b-77360c366108', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-01 02:11:55', 0),
('1299d849-d07a-4ae8-9add-09cd60a31159', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:28:30', 0),
('12ae3859-1a3f-4a2b-8331-46683fb2d117', NULL, '8d6c9dee-a764-49b5-ab9b-5bb36610fc61', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ppppp\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:57', 0),
('12cfc6bc-8a3f-4802-a0e2-8a4dbd1d7bf2', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:25:10', 0),
('1312b35f-7bf6-47ef-8b0f-ee2c4e5153b6', NULL, '8f0f19d0-9bea-4cf4-b5b7-e5dd74a6272e', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 3931908d-9593-4be4-b232-f858ac87013b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:26:45', 0),
('134e3101-3b9d-4b73-8956-3b5ff9b43ced', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b2380680-7033-4db1-a223-e45bf473afc5', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: errr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:08:21', 0),
('137bb6cc-b401-423c-afcf-8cd530144d86', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:28:23', 0),
('138f492d-2237-4c5e-9f74-45742fdea19c', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e766c3e9-d708-4f59-8831-b84f399c0396', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'asdasdasd — runnnnnnnn', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 01:33:46', 0),
('13e2da6c-4b27-44d2-b788-541c875570e3', '087ccbc9-efa8-44e0-8435-3310207554d7', '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: test — test', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:40:50', 0),
('14d6fdaa-fdef-4491-8ac9-3d7d9d2ee31c', NULL, '29b2965e-f05a-4626-b0d0-78d982165725', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ddddddddddddddddddd\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:48', 0),
('14f22059-84ff-4587-ae51-a031991c68d8', NULL, 'e221e2d3-3f41-41ed-9ebe-825b9f4f0360', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST B\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:31:58', 0),
('161e6a07-6107-45c5-884a-6f59be0b3eea', '31fcedfb-f507-44bd-ad89-336c55539fea', '9d9ae6ca-3335-4e35-a2a7-7e312f1ee04f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dsgfd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 12:36:49', 0),
('161f7b0d-7ec9-47f8-b02d-f5a375036ff0', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:17:29', 0),
('166389d8-77bc-4801-aed3-c0cc2916936e', NULL, '0073af4a-6de3-4d23-97d1-d9bcc04ea7b9', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:04:02', 0),
('166a5039-6729-4371-8ddd-83fce78fac53', NULL, '215e6893-65a4-4565-93a7-2863657702ee', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"transfer\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:05', 0),
('167c93ce-f0b0-4b00-976e-81ba63b04671', NULL, 'e766c3e9-d708-4f59-8831-b84f399c0396', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 93edfe34-9d26-4eb8-a0af-aaf09057a98a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:33:25', 0),
('18309140-731e-4e84-b4cc-f157b7bb3060', NULL, '3931908d-9593-4be4-b232-f858ac87013b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A - START UP MONEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:25:59', 0),
('18834ce3-ccca-4279-abe2-76d895d16246', '087ccbc9-efa8-44e0-8435-3310207554d7', '6b5f34f5-2d45-4ac5-8e18-f8376a8cd21f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:01', 0),
('18ce4c3a-172c-43a3-a380-c4345478769c', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b492548d-def9-4420-b2f8-ad38e0db6d53', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dvvvvv', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:13:04', 0),
('1976594e-8378-4724-aa22-2c9cad69cef7', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:41:32', 0),
('198f2a03-11cf-4dd6-be90-99d57a3a36d4', '087ccbc9-efa8-44e0-8435-3310207554d7', '7ba9ccbd-e9b9-438a-9553-ab6c8e82cc82', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:28:38', 0),
('19911f80-8c04-4913-b789-2c9c8be64be9', NULL, 'd5ab3cc7-e984-4ebd-8291-43ea368fa687', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"yyyyy\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:04:11', 0),
('1a4258e8-2d41-4192-9a63-54780a0b17ec', '6373498c-903e-43a9-bb1d-b67a496aee24', '2edebf73-fd8d-43ed-90a1-df79c678b689', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:30', 0),
('1aeae960-b42f-4226-99ac-f3822490f2b8', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e03af9c0-6876-48b8-9fa5-2eb28af3004d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwer', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:06:24', 0),
('1b842702-ae59-45b2-aa98-07ddd13c0a30', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:32:37', 0),
('1ba3af1b-9036-4054-9610-3b42fd47c713', NULL, 'f4578a05-c1a5-44b5-80a1-08c2bdeb3414', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST D - PROJECT REJECTING\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 01:47:35', 0),
('1cce0092-b7c4-4cdd-a809-4c7a34480fcb', '087ccbc9-efa8-44e0-8435-3310207554d7', '9a27b840-f156-48e4-9dd1-07d5c5412c35', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:31', 0),
('1cf3d4bb-72e2-40b7-afc6-e2cb96fcbcfc', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:17:55', 0),
('1d7031a3-7803-4d8c-a502-c75f6a8424d1', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 3 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:12', 0),
('1f37ae8f-775a-4dd6-b318-77682b96ac8f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e221e2d3-3f41-41ed-9ebe-825b9f4f0360', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST B', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:54:51', 0),
('1fbddcc5-df00-4d07-839e-ae4dc3545370', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:15', 0),
('20652b1e-12d3-47d9-b593-9158b0c77bf2', '087ccbc9-efa8-44e0-8435-3310207554d7', '7636b4f6-185d-48a1-91fa-5cd122e790bf', 'date_change_request', 'Date Change Request Approved', 'approvals', NULL, NULL, 'Approved date change request for project: TEST G - PROJECT INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:26:18', 0),
('20a85581-03ab-4656-80d6-f2fab4014844', '31fcedfb-f507-44bd-ad89-336c55539fea', '2edebf73-fd8d-43ed-90a1-df79c678b689', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID d01968a8-3a78-449a-959d-b50575c9351f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:10:47', 0),
('20fd9868-2303-4ef8-bd5a-b3348a4ac297', NULL, '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 23711f86-7260-4866-80e7-9dd4d7394111', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:13:38', 0),
('221adfa9-2a79-40aa-9b97-d7e1af3f83c1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c21eebd9-e1f4-444f-bc9f-561d3b9eec0b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 06:13:07', 0),
('224c9c31-767a-4a92-9c13-f5d87d0b58c0', NULL, '56e80990-28e3-4964-ae27-dd20eb106bbc', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"pahingi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 10:23:35', 0),
('2268f6a0-5153-46d3-b6e7-3e86cfe15f18', NULL, '37e3a348-1a58-43f5-9e52-b3ea22a80c51', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:29:07', 0),
('259badec-3f90-44d9-bdee-89460de3cf38', '087ccbc9-efa8-44e0-8435-3310207554d7', '99c9bdd9-aea0-4294-8777-ecd8169a51d4', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:20', 0),
('2600da2b-bac0-4dca-98cd-9add020e2e00', NULL, 'ead30135-7760-4b82-b0de-7b7fa7a2a96b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ssssssssss\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:07:15', 0),
('26df601b-a438-49ff-b6d6-548d9e6faddc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 09:54:23', 0),
('270ca499-e88c-42ba-850e-ef9e11ccbdf6', '087ccbc9-efa8-44e0-8435-3310207554d7', '1ee1b6e1-7945-4ce3-8172-37ab645dca24', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 06:06:15', 0),
('27a2cb6c-9d28-4643-bfb8-bddf25438a21', '31fcedfb-f507-44bd-ad89-336c55539fea', 'ceefdb0e-b529-421e-b928-332b657f033a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID d01968a8-3a78-449a-959d-b50575c9351f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:11:03', 0),
('28b7b7fd-735b-47ea-8108-edc251ca0f03', '31fcedfb-f507-44bd-ad89-336c55539fea', '00afbf20-9ae4-4178-ab06-63e0751bb15a', 'meeting', 'Meeting Marked Completed', 'meetings', 'update', 'Success', 'Marked meeting as completed \"wow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 14:34:58', 0),
('29910041-b7fe-4f1b-ab90-e17ec31b7314', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e62fb4ba-1bf6-49cb-b69c-b48a3ffcab20', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerrty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:31:38', 0),
('2b4bd139-7caa-460d-99e6-8df2f41b197f', '087ccbc9-efa8-44e0-8435-3310207554d7', '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:50', 0),
('2cee67d7-4de4-41a0-ab55-070eded068f0', NULL, '2a175fcd-d5e9-440f-b741-543b45cf3917', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:56:32', 0),
('2d149afb-1606-4a40-96ef-765650657b0f', NULL, '59c224bc-1c29-4056-8e02-c9c7cd459e7e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"3\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:59:11', 0),
('2d7beab5-31e7-4747-9ffe-269766f6b563', NULL, 'd9be1369-1426-4874-897f-522f39736607', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: wqerwqe', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:57:32', 0),
('2d827e2e-766d-4bda-bbe7-46e3d7b89941', NULL, 'c3d325e1-6042-4e8a-9860-9f2f0980a307', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"transfer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:44', 0),
('2d946b58-1a77-4fc7-b4ab-63c27fbb1c3d', NULL, 'ad310c33-b917-42b9-8f33-910b4217c7f2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweert\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:40:24', 0),
('2db66bc5-e352-4807-9271-dad2b508a246', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:19:36', 0),
('2dd8ca1a-9dd1-4580-b1d3-1d10d667be3e', '087ccbc9-efa8-44e0-8435-3310207554d7', '2151523c-1df3-479d-b69f-14e678600d5b', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:21', 0),
('2ec559bf-e6fc-4922-a490-af64af304c71', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 10:21:53', 0),
('2f3681f7-74c4-4041-9bc5-49e84d91ec3b', NULL, 'f5a10049-0b7e-4ad2-862a-299bc00fb283', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"xxxxx\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:42:27', 0),
('3000e83b-9a2b-46ac-9001-fc0ed2718ded', NULL, '1acce8d8-b86f-427b-9622-d1969c270e9e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:40:40', 0),
('30434a57-f955-454c-9735-bc164f8a766f', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:14:45', 0),
('30615fea-60cf-45b8-884f-41fba084e07f', '087ccbc9-efa8-44e0-8435-3310207554d7', '63086e74-6f31-4a27-ae3c-75101d57ad7c', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'TEST C - REJECTING THE LEDGER — TEST C - REJECTING THE LEDGER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 01:38:15', 0),
('312dbf5d-53ba-4f74-b221-9a268538fad9', NULL, '72028d4d-92ce-46be-ae54-27304f4efd39', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"adasd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:43:51', 0),
('3183d562-681a-4fff-87a0-1913b5d24f4b', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ad6a047d-d42e-43c2-9c4e-c25f617d22b7', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST G - PROJECT INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:01:02', 0),
('32061ffd-c275-4323-ac51-d5f08d315193', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:38', 0),
('33c2d720-472b-473b-b158-161d71b31f71', '087ccbc9-efa8-44e0-8435-3310207554d7', '551a7994-afde-43f0-acf4-45d040321a3c', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'safsda — sdaf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:31:50', 0),
('356d3080-0786-4771-aae0-78847e1f3a65', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:37:33', 0),
('357fcf8f-0541-44fe-ab3b-1d5952e87e9b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:08', 0),
('35d4572f-0796-4d4a-96ee-6f2f443e018e', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:28:45', 0),
('35df7796-0553-413b-b68b-16c5365921db', NULL, '6df32d92-9dff-4766-b700-2ac28c379f22', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:05:36', 0),
('362d3a03-bd71-4669-8e4c-d79514f99f54', NULL, '34b1be0b-7f23-4544-8056-be53c6f14f66', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 77c95044-68c8-4ac5-aa6f-6e20437047ea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:50:01', 0),
('363566d3-598e-40cb-8974-1395c47dbccb', NULL, '66cbf8fc-86da-41a0-9fb1-76f3806cbd8d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ffffffffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:33', 0),
('3667dcb7-9b91-487c-9284-b52de4869af2', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:26:43', 0),
('367ac2d7-78d2-4aed-b615-55edcc648ae5', NULL, '517f49d4-ca74-467c-982a-7788bb150bca', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"oooooooooo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:42:45', 0),
('36810bbd-61a1-4dad-a389-398de62bf45a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:31', 0),
('36d70402-9281-41a0-ab13-0739c9f73c32', NULL, '6f8c694b-0e8e-49ad-905a-55041e32f254', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"wowo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:00:47', 0),
('37197ae6-00e3-4531-ba1e-b7d333579655', NULL, '25558800-12fc-4109-98ca-31c13f1fabd3', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A - START MONEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:43:06', 0),
('3731ca74-9df3-4cc8-b6ea-c853b4ad82f3', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:00:45', 0),
('374047a8-80e9-43b8-95a3-222e37f5c549', '087ccbc9-efa8-44e0-8435-3310207554d7', '2abce95d-e63b-4594-acf3-c3cc2130d10a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:01:04', 0),
('3744f772-20a9-4b0b-aa62-dd132602fa17', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:19:03', 0),
('37b07e48-2c21-48d6-b02e-57e3d136f8a9', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:23', 0),
('37d0764f-3e96-4f67-87c6-450a4dda11bc', '31fcedfb-f507-44bd-ad89-336c55539fea', '46208cc3-1f4d-437f-932a-5306d4d1c2cd', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdafsd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:22:04', 0),
('385aca2f-d84a-44b2-a854-507380756f23', NULL, '7cf3bfa7-8ba3-4a2b-a3e0-f9a585918653', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqqqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:26:28', 0),
('390cb980-f98b-4541-b1d6-6b8d9f1cea7f', '087ccbc9-efa8-44e0-8435-3310207554d7', '7cf3bfa7-8ba3-4a2b-a3e0-f9a585918653', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qqqqqqqqqqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 10:28:24', 0),
('396caedb-9a99-4e28-bf05-447a7076f471', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f79601bb-f699-4283-a21a-a5074cd31f2c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:34:01', 0),
('39f359bb-90c0-48df-a845-e6dc22838edf', '087ccbc9-efa8-44e0-8435-3310207554d7', '58d0c0e8-6f16-4ed8-a9fc-ecb6cc9c827a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST G - INTIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:47:19', 0),
('3a916dc7-7b58-4654-a4a7-b7c92aa05047', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd873870b-6daf-4e55-b1fc-c1a828278d81', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:14:25', 0),
('3a9b1b20-fa0d-4cec-a168-66530b21cdf4', '087ccbc9-efa8-44e0-8435-3310207554d7', '9117d38a-5560-4d05-a80e-cc72a0a85691', 'date_change_request', 'Date Change Request Approved', 'approvals', NULL, NULL, 'Approved date change request for project: TEST E - SAMPLE PROJECT (WITHOUT PROOF)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:31:32', 0),
('3b1d7e51-9c8f-4e32-bc3c-14da8a803193', '087ccbc9-efa8-44e0-8435-3310207554d7', '57f4219b-7c6b-4fd7-afdc-29da8c54440a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, '1312 — LASt - A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:02:31', 0),
('3c3acb8b-81b7-4ed8-9dbe-45c9df9e5e48', NULL, '1b88fc43-fbeb-4f9a-99b9-396762e7e484', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:11:36', 0),
('3c95ce23-deb1-4b2c-aa7f-f75c708208d5', NULL, 'ad6a047d-d42e-43c2-9c4e-c25f617d22b7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST G - PROJECT INITIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 02:58:54', 0),
('3cc2b7dc-0e21-4929-ade4-3c2e179e397e', '087ccbc9-efa8-44e0-8435-3310207554d7', '55ed9f2b-250f-4e15-a422-2dc738642c14', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: tttttttttttt — truncate', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:37:11', 0),
('3d2330a3-1309-41d9-9f08-82f933d29b11', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:29', 0),
('3d5f76e9-ab95-4673-9bd3-99b58c96b736', '087ccbc9-efa8-44e0-8435-3310207554d7', '7337947a-bd00-49ee-87ca-91627949d454', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:01:12', 0),
('3d9ebdb0-b1eb-4085-97fd-f971b766c5e8', '087ccbc9-efa8-44e0-8435-3310207554d7', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: LAST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:32:07', 0),
('3e49a7d0-42e5-4eeb-a34e-94577a5341ce', '087ccbc9-efa8-44e0-8435-3310207554d7', 'feab8fbb-12b8-4131-9ee3-295fdbcef0a0', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sfgdsg', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 13:06:01', 0),
('3eefe0bd-28b5-4c83-9e1c-a090d4f76ad0', '087ccbc9-efa8-44e0-8435-3310207554d7', '34b1be0b-7f23-4544-8056-be53c6f14f66', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:57', 0),
('3f51b1ef-c978-4e30-b378-022f505f5c01', NULL, 'c2ec0cad-bfb9-409b-aa39-8b2a8faaa410', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"fffff\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:02:38', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('3fc21f5a-1cc7-4c73-9688-d8ae460d9563', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a62125a0-49a6-4b38-8ffb-57a93ab1cf4b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:13:24', 0),
('3ff7e1dd-6f0b-447f-995a-caa1c727ae19', NULL, '99fcee4e-48d4-4f28-97bf-04473e3dfc24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:42:46', 0),
('408ade1a-2590-46ef-b652-09794ac3e5f6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'de194365-e159-4a2c-be81-1385cfc5e651', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: UPLOAD', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 09:31:18', 0),
('40a37531-1f3b-4501-b0f2-9ded35d926fc', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:44:08', 0),
('4103676e-e29a-4f80-b56c-069147659ee5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:18:04', 0),
('4151d9d1-7896-4c8e-ad74-a35933f81022', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ead30135-7760-4b82-b0de-7b7fa7a2a96b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: ssssssssss', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:07:25', 0),
('415ae193-c8d9-461c-9514-220646f25f54', NULL, '9a7f0d48-2551-46a0-af17-0eb3e067bd0a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 8fe916ae-a629-4a5f-bff4-10eace77b15b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:00:44', 0),
('41a9d91e-a640-4252-b9ea-37735270d22e', NULL, 'c0578485-b459-42d5-a130-50b9fe92aca9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"c\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:00:08', 0),
('421ffa5b-2d35-442f-b207-6060239dc5de', NULL, '928851e9-3d0a-4701-8607-906fd2a2f7cf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 06:57:03', 0),
('4225982e-1420-4d4c-a5d8-927b99ea5e4e', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:15:25', 0),
('441a11bf-54e4-40cd-95ed-85e67cf8611d', NULL, 'd873870b-6daf-4e55-b1fc-c1a828278d81', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:58:08', 0),
('4453ae6d-259a-4809-9d62-1242a8938004', NULL, '2b0f20d9-b259-49c7-a9cc-b0a76decbe5a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"5555555\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:16:31', 0),
('4488cb8b-cb44-4035-9050-08f018933d16', '087ccbc9-efa8-44e0-8435-3310207554d7', '84f1d33a-c881-41ce-ae7f-efd7269ec3a4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:18:14', 0),
('449057b6-9529-4e57-9cfa-f1dd4df6b0e0', NULL, 'e03af9c0-6876-48b8-9fa5-2eb28af3004d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:06:07', 0),
('44aafe91-9e4a-4025-be59-10c15386e9c7', '31fcedfb-f507-44bd-ad89-336c55539fea', '7f739e97-a163-468f-a2a2-3af1d0b1608a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdfgds\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:25:03', 0),
('44ce5e23-d496-4f4b-8471-f217d9300b73', NULL, '20f2d9c4-a503-4afa-a44e-fbb107bc271c', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"qweee\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:56', 0),
('4548e0a2-1066-4da9-9c1e-8fe88062ed9a', '087ccbc9-efa8-44e0-8435-3310207554d7', '4ad70ff1-8559-4057-a8a6-f0cdc3f62a49', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:38', 0),
('45b98d9b-ba9f-4393-93b0-c956f0664663', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 3 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:06', 0),
('46785e26-9d48-4da9-951a-62b90837b1ac', NULL, '2bf8362b-7350-41f8-9773-0272bd797818', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"run\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:19:26', 0),
('46a61707-77da-4f85-86e6-630fe3422783', '087ccbc9-efa8-44e0-8435-3310207554d7', '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: 123 — qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 09:34:07', 0),
('471902ed-09d7-4591-884f-d45b3e461181', NULL, 'ad72e1f7-aa03-4cf2-8813-0b6ccd5a88bb', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"123\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:54', 0),
('474013d3-5b20-4ba0-bc21-e29fe4eec3b1', '31fcedfb-f507-44bd-ad89-336c55539fea', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST E\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:42:43', 0),
('474d5f1c-f571-40bd-9a6d-ff56fe109144', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:31:30', 0),
('4861104b-7dc7-4990-9f33-ab4a1140edd2', '31fcedfb-f507-44bd-ad89-336c55539fea', 'bab90eae-e72d-4e70-86ed-3bd09d7f6e8d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"safsdf\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 12:25:51', 0),
('4a67c494-7fa6-448a-9332-fc1ed20b3eab', '087ccbc9-efa8-44e0-8435-3310207554d7', '1467012c-d2ee-457d-966a-b987dd2a1d02', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:50', 0),
('4a82f8c6-9e6c-4682-81ed-e11f461c6db7', NULL, '44cd0e36-b2f4-4242-8041-f6431e05bc91', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MOENYYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:36:52', 0),
('4c6ff2e2-91eb-41af-b9c8-1f13706468d1', '087ccbc9-efa8-44e0-8435-3310207554d7', '188301d3-cac7-413b-b080-bae23c7c8ef8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:34:48', 0),
('4ca8b22a-a28d-46c6-a0d2-2d6071bd909d', '087ccbc9-efa8-44e0-8435-3310207554d7', '78c5e726-6131-4f82-91f3-01b47acf83c0', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: wqerwqe', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:57:21', 0),
('4cbfc9fc-91f3-495a-85b6-8d208bd47634', '087ccbc9-efa8-44e0-8435-3310207554d7', '24f47424-8eaf-49d5-8639-f7d25220e6ca', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:23', 0),
('4d35a247-ee0c-4c06-9f89-06383ca0cfab', '087ccbc9-efa8-44e0-8435-3310207554d7', '23711f86-7260-4866-80e7-9dd4d7394111', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:13:22', 0),
('4e224d3e-5a3f-41ee-891c-5876311c3687', '087ccbc9-efa8-44e0-8435-3310207554d7', 'fe28e89f-0d81-4e46-9188-1c3b12f2428a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C — TEST C - INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:59:05', 0),
('4f302ce0-6812-4098-8ae6-eda47e21a742', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:22', 0),
('4f968b26-9a6c-47e1-a0f9-c4aa304014ef', NULL, 'eba5f2f8-31c8-4c7a-a445-9d5f73c6569b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"testtt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:22:16', 0),
('4f9f441f-2a46-4650-b650-2fc822f2068a', NULL, '8fe916ae-a629-4a5f-bff4-10eace77b15b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dfgsdfs\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:59:48', 0),
('4fd94dbc-620b-41bd-9045-e5086409e173', NULL, '916b852b-7b65-4525-bbc2-b714d6feb050', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:03:23', 0),
('4ff26bc4-cbb2-401a-b77a-2b0b8b67a10f', NULL, 'e6603f21-367a-4a08-95d8-d724d4fa252f', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 3931908d-9593-4be4-b232-f858ac87013b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:27:01', 0),
('50b574d2-1aac-46e9-9da8-91fc9755e0db', NULL, '7ba704f9-d6ab-4266-bc4c-bccf5df86919', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST F - PROJECT WITHOUT PROOF\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 01:52:23', 0),
('51794c9c-bc74-4307-9080-e377e0bc35b9', '087ccbc9-efa8-44e0-8435-3310207554d7', '7eaa2f66-1fef-4baf-99cd-70a13bd4ad56', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'asfsda — sadfsdaf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:23:28', 0),
('51d97eb6-4beb-4630-8f5a-e880d36be246', '087ccbc9-efa8-44e0-8435-3310207554d7', '78db131f-e83e-4758-851d-2eeb4a7d04fa', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:38:01', 0),
('52bdefb7-b1e3-4bba-b970-79de980a320d', NULL, '116b8cac-d9e1-43ab-9f8c-074aabb1549a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 77c95044-68c8-4ac5-aa6f-6e20437047ea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:51:48', 0),
('52ccfefb-3cc2-4c92-9e53-49ea307b87ff', NULL, 'cdcb60c1-c59c-4a92-8bec-ec66ee1d4143', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"qwqwqwqwqwqw\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:06', 0),
('531ef145-9ebd-4042-a059-3593c79ab491', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:14:06', 0),
('5357a6c7-a1a1-4b13-a958-487e67499123', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:26:38', 0),
('53640bfc-8113-4145-83a1-b607791335fa', NULL, 'e77a70cd-f3bd-4776-9a03-05f88dfdd960', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-10 08:02:18', 0),
('537283dd-3691-408f-af98-f74a5de0021b', '087ccbc9-efa8-44e0-8435-3310207554d7', '116b8cac-d9e1-43ab-9f8c-074aabb1549a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:12:33', 0),
('5403932a-26db-4a82-abe1-5e9c2e29c402', NULL, '0a52df93-d420-42b6-852c-75141a59d35b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:16:27', 0),
('55113e92-f745-4f34-a83a-8d4e1cb0007b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:48:36', 0),
('558d9fa1-e862-4f51-afb1-e0dd9baf70a9', NULL, 'c664cc87-1040-49e7-9d80-ee85ee9e7d18', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:33:52', 0),
('558dfc37-1419-4818-8c56-3ec2e770ffa3', NULL, '5ce475d7-7efa-41af-ada9-5bba2069fc8b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TESTb\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:26:00', 0),
('55f0521d-d21e-4239-be0e-7aa4180c530a', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:13', 0),
('56812e4b-2439-422d-9a76-b98b408cade9', NULL, '3397d634-4b91-40d7-8727-3ac093aa27ce', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:42:45', 0),
('56e536b3-a532-4be5-9acf-67e0bec09cc2', '087ccbc9-efa8-44e0-8435-3310207554d7', '17ca062a-87e2-483b-97cb-683bff711cb7', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 13:35:21', 0),
('56f0d2c4-4e51-4c6d-8dd2-1c8bc2a1d79d', '6373498c-903e-43a9-bb1d-b67a496aee24', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST E', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:44:43', 0),
('57073fa1-7701-4d7c-85cd-17f97c9952c5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:11:23', 0),
('57a0d017-6399-43b3-b321-f6e777aad8e1', '087ccbc9-efa8-44e0-8435-3310207554d7', '7ba422cf-ea47-420f-a17c-cf37f15b67ea', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:05:07', 0),
('57d54d99-d5ed-4fad-ba35-c2412111d3cc', '087ccbc9-efa8-44e0-8435-3310207554d7', '76615760-7ff6-452d-a528-9164118855de', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:10:51', 0),
('5808e146-f02e-485f-948b-3c41bbb0bbd5', NULL, '9efb9c55-572b-480f-8975-f81f71f3291b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"asdas\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:39:14', 0),
('58d71b18-89a9-4d97-8b8f-2544f53d0cc5', NULL, 'ab96c388-1175-4799-b417-bb5321a32894', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 06:13:52', 0),
('599affd7-fac8-4654-8823-ec359ede8961', '087ccbc9-efa8-44e0-8435-3310207554d7', '48b7ff8b-5e01-4029-9dc9-261653ac28df', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST B - INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:49:07', 0),
('5a783cf6-a1f7-4343-a26f-13939d5df841', NULL, 'ea06eeaa-7d27-4912-a511-a5559b1c72a9', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 3e79a958-802c-4597-ad7f-14ec50c492b1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:46:49', 0),
('5a8807c1-022c-4b13-80fa-5edda4c81f3b', NULL, '48b7ff8b-5e01-4029-9dc9-261653ac28df', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST B - INITIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:48:18', 0),
('5b1d5973-6991-40bc-ac5f-626376601f39', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:32:49', 0),
('5b22d622-e12e-4cc0-ae23-d33b565c4cc4', NULL, '0bf0003a-4aeb-4e44-9d71-8898f801445b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 10:24:56', 0),
('5b7c0f28-0b0a-4a84-ac91-f4507d493573', '6373498c-903e-43a9-bb1d-b67a496aee24', 'd01968a8-3a78-449a-959d-b50575c9351f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:07:08', 0),
('5c0eb828-566f-491e-ba7b-a00dcc3d2e1d', NULL, '810b05e4-7266-4f5a-b460-e7a492862f84', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"4\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:00:51', 0),
('5cbae19c-b99c-48cb-a046-78be902fa6a5', NULL, '0c85f2ce-8d55-4a54-b788-d5a4b78d864f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"iiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:42:46', 0),
('5d72cca0-211c-46e8-9d82-42c04a8734ce', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:39', 0),
('5e8a3029-c073-421b-a93a-54ddeac2d504', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:07', 0),
('5f362669-f4d5-439e-a280-242c4c9b976e', NULL, '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"adasda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:46:36', 0),
('5f6dea96-92e9-40dc-9b87-837556e8786d', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e69dd1c1-2e90-48f2-a557-af412e5adbe0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: weee — weee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:54:44', 0),
('5f79422c-b47a-4808-a85b-a6af05d2afc9', '087ccbc9-efa8-44e0-8435-3310207554d7', '116b8cac-d9e1-43ab-9f8c-074aabb1549a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:44', 0),
('5ff5ddd7-f453-4907-99cf-a514879f6ca3', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 03:08:19', 0),
('6053e4df-87a1-4a9a-ab1b-ec39971ea70a', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd7746fb6-6ba1-4e20-86b3-75f136e31aba', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:35:29', 0),
('6058f5b9-971d-4771-9a23-3e9a9cd0c4e8', NULL, 'b37c5ad1-556a-4af9-96ce-5bdc6bec810d', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:06:39', 0),
('614bf33a-d1a8-4d4f-97ed-49ba3366b819', NULL, '5ebebeae-bb1e-42a4-b39d-90dde6ab15f4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:47:16', 0),
('6177089b-dcfd-4f00-bfd4-59d02ec22d1e', NULL, '215e6893-65a4-4565-93a7-2863657702ee', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"transfer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:52:37', 0),
('61be2574-32fe-4114-81cb-8859121dd828', NULL, '8983a130-a81e-4f75-8d12-117c3887f100', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"maney\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 14:29:57', 0),
('61ce232d-9ae8-4bfb-8a01-a2bb456ad63a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:20:10', 0),
('61efeb2c-d100-4b7c-ae83-40bee7917c2b', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ea8c108b-7868-4189-8ab6-2846ff3ac757', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:04:35', 0),
('61fd786b-7ae6-4118-aed2-73f7c496b535', NULL, 'b492548d-def9-4420-b2f8-ad38e0db6d53', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dvvvvv\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:10:52', 0),
('620cf792-21a2-4253-9ddb-3b78df54d30c', NULL, '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"adasda\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:47:13', 0),
('62691ec1-c258-4e98-8c2e-b6a42eb3c586', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f4efd930-4ef2-4a46-b9de-b6c13fe0c556', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 11:11:10', 0),
('62e16e13-5eb8-4b0c-a9f2-a691056039d7', '31fcedfb-f507-44bd-ad89-336c55539fea', '4a681c0a-ba34-4e4d-8027-092104f33b9f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dsfgfdsgsd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:47:58', 0),
('6379d478-c423-4cf7-b8ad-f329ae0391a0', '087ccbc9-efa8-44e0-8435-3310207554d7', '3475c3f9-ed35-42f3-8559-0f77da4757ff', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: PAHINGII — PAHINGII', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 05:20:07', 0),
('63debb6e-7ec3-4182-b889-e28e37697a04', '087ccbc9-efa8-44e0-8435-3310207554d7', '93edfe34-9d26-4eb8-a0af-aaf09057a98a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: runnnnnnnn', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 01:32:58', 0),
('64c42f6a-2812-43d9-8b46-c073b0eedfc5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:15', 0),
('6557c4f9-a494-4f2e-add6-79be1a00281b', '087ccbc9-efa8-44e0-8435-3310207554d7', 'eba5f2f8-31c8-4c7a-a445-9d5f73c6569b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: testtt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:22:54', 0),
('662101d0-3873-420e-af10-7914c007a0f1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'bab90eae-e72d-4e70-86ed-3bd09d7f6e8d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: safsdf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 12:31:51', 0),
('66cba088-2c7c-43ca-ab8e-22472de11ad0', NULL, '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"sdafsda\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-12 10:18:03', 0),
('6761fdb5-0a5a-4e20-a47c-277a1165b890', NULL, '551a7994-afde-43f0-acf4-45d040321a3c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:15:24', 0),
('67993eaa-2caf-4f96-9f78-23b9d0a91021', '087ccbc9-efa8-44e0-8435-3310207554d7', 'fe28e89f-0d81-4e46-9188-1c3b12f2428a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:01:09', 0),
('67d0456b-4ce5-46e5-8383-9ba167eb8fc3', '31fcedfb-f507-44bd-ad89-336c55539fea', '4cd8c141-3191-45c9-8646-bc9660a5fdf3', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID d01968a8-3a78-449a-959d-b50575c9351f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:11:36', 0),
('695365c5-9645-42dd-b445-4a5453d9a46a', NULL, '3bd9f824-3450-465b-a1a7-ef1d1f4abdaf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:31:42', 0),
('698c962d-a95b-4350-9f01-f7a6e413fdf7', NULL, '0b8b2dc6-3641-4dac-8d70-4eaf4e8b9fdb', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST E - SAMPLE PROJECT (WITHOUT PROOF)\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:27:00', 0),
('6ab1be4d-fb83-4367-a256-0daf59766b56', '6373498c-903e-43a9-bb1d-b67a496aee24', '2edebf73-fd8d-43ed-90a1-df79c678b689', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:31:02', 0),
('6af058de-3204-4a38-b1be-ea22eb0cc2af', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:52', 0),
('6b4bc433-4322-4415-9bd2-7ce4cb89a25f', NULL, 'f2731d34-76b0-4f05-921e-2aba9d0bf098', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"jani\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:41:57', 0),
('6b7fd6e2-3faa-49b9-bc99-4462f439956b', NULL, '7f49d6e7-b124-46ee-96de-3eb287080bcc', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:32:08', 0),
('6bb7ce00-7abb-4023-9ea4-6e3bb31f314a', NULL, '9aa6264e-d475-4793-84e4-def023b32774', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: TEST E - SAMPLE PROJECT (WITHOUT PROOF)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:31:52', 0),
('6c4a86a9-5bf8-4873-a4cc-998cded1514f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: LASt - A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:33:09', 0),
('6d326fa4-411d-44ce-903a-d66ee6836b32', '087ccbc9-efa8-44e0-8435-3310207554d7', '3e4a11c4-a079-4af0-a35a-0f848cdf0e5c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:09:54', 0),
('6d70b877-1e93-4598-bf99-89c98f4f6f06', NULL, '76615760-7ff6-452d-a528-9164118855de', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:10:39', 0),
('6dc4b48d-a318-4ebd-94dd-ede1cb46f606', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:19:41', 0),
('6dca0174-c173-458c-bbbc-73b23b408a3c', NULL, 'd3ab57ac-3ffa-4a7f-94f7-0896e815a3d0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 25558800-12fc-4109-98ca-31c13f1fabd3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:43:59', 0),
('6e1a701f-821e-4839-afef-00df32e40f8c', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:37:40', 0),
('6eef37bb-0770-4786-bf61-46b327f2cfc2', NULL, '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"JANIII\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:55', 0),
('6f516344-d02a-4491-a86a-6a4072a76840', '087ccbc9-efa8-44e0-8435-3310207554d7', '5b1d6bd5-d923-4b60-ad40-00604ba2ee66', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:25', 0),
('6fa65279-f4b4-4367-894c-1468765c9518', NULL, '7987240f-af1e-4cd3-bd3c-cff3b55ef5af', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:54:11', 0),
('6fc24788-fadd-426d-b96e-36617ea2cf39', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:58:13', 0),
('6ff6fe3f-482f-48f2-a149-e446d2cdead4', NULL, '296ab788-40e6-434d-b4ce-3489280b6c6f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"11\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:37:03', 0),
('700085df-f2d5-4ba6-b876-9fd859b9a71b', NULL, 'ee37254b-b985-4a8f-832b-e894aa30397e', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"dd\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:03', 0),
('7072866e-3abd-46a5-b384-bec3472ef2a6', NULL, '4ddbd5db-65fa-4ab7-95eb-6e65522fb607', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:45:58', 0),
('70748c56-05fe-4319-b353-e2512323dc6d', NULL, '93edfe34-9d26-4eb8-a0af-aaf09057a98a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"runnnnnnnn\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:27:28', 0),
('70785db5-8abe-446a-bfc4-7846cbe78b37', '087ccbc9-efa8-44e0-8435-3310207554d7', '833e9ec6-cedf-474f-aec1-c44c5cc49a5f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:30', 0),
('7082adf4-1c79-4615-9116-1b6b146252d1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:23:55', 0),
('70963e0c-c62e-404e-892f-a818fdd9cf10', NULL, 'a05478a0-5f7f-4863-9fff-a83684a60b32', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEYYYYYYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:54:42', 0),
('7288d938-f24b-422b-84a9-c2de5dccdd5e', '087ccbc9-efa8-44e0-8435-3310207554d7', '116b8cac-d9e1-43ab-9f8c-074aabb1549a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:43', 0),
('72b772c9-a09d-404b-8807-1cd271379885', NULL, '7636b4f6-185d-48a1-91fa-5cd122e790bf', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: TEST G - PROJECT INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:02:12', 0),
('72edcea4-7112-4c9e-8147-f2a9c84f7d09', '6373498c-903e-43a9-bb1d-b67a496aee24', 'fe38de78-dd42-4e6d-adfb-e6da63a711fa', 'date_change_request', 'Date Change Request Approved', 'approvals', NULL, NULL, 'Approved date change request for project: TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:08:09', 0),
('732c133f-c30f-4b9c-8014-862e1c9dcdef', NULL, '919ab241-e8ef-4a5b-84fe-b46bbb2603ce', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:36:55', 0),
('7337a9fd-260a-45b8-b013-6e534a59d0de', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:00', 0),
('73882386-5fe7-429a-9c9c-0adac7bd6f04', NULL, '4df69e79-086c-476b-907c-7fc2350b0361', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sadfsad\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:38:46', 0),
('73b3d93d-dfe9-408b-82e3-b46d9aa7b5cd', NULL, 'ae12aab1-5af5-4e46-afe3-865fa0c354e0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ettt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:18:02', 0),
('741e7074-2434-4434-b418-0e1ac74b9c96', NULL, 'e3a9c3c9-0ea9-4a0b-9398-05aa2a3d174c', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"xxxxx\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:45', 0),
('7457211b-e340-4a41-acc1-620293ffbdd7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd0e73905-28fb-46db-854f-3f1e3d51dcf2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: wwowow', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 09:38:42', 0),
('752c9265-7651-4cfe-ac5a-5f58a35021fb', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e5c50101-d30c-4ea8-b864-1e88d8a25eb0', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - LEDGER ENTRY — TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:56:22', 0),
('757423ad-a1cb-4b9a-82db-1968cd82896f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a4d73cf4-5aa8-44de-a394-67ad95946496', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TETSTTT', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:36:27', 0),
('75752203-5f09-4073-a96e-8b5864483ad6', '087ccbc9-efa8-44e0-8435-3310207554d7', '919ab241-e8ef-4a5b-84fe-b46bbb2603ce', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:37:43', 0),
('76081f26-e83c-4777-a0da-bc84c8a90dd0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:27:37', 0),
('761b6768-0c0f-4505-86a5-eb90f91d7427', NULL, 'dbf34bca-61d1-4ce2-b162-2a551bf003c9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:49:04', 0),
('763e21c2-415e-45a6-b321-27d09e9a76e2', NULL, '4e4e0a3e-ad37-404d-af03-d6034cd3c6fa', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:31:27', 0),
('76890987-36b0-471e-9a76-ff6d2bdfbaf8', NULL, 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TESTING\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:44:07', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('76d0a928-e3c7-4682-94e4-4eeac95f7f6d', NULL, '3475c3f9-ed35-42f3-8559-0f77da4757ff', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"PAHINGII\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:57:08', 0),
('771cf96a-9e28-469b-83f4-c4442bda9ab0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ac35bd25-b940-41ba-b0c1-7a45d1622671', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:35:08', 0),
('77320786-36c0-4507-bb3d-2fa474c8d8ac', NULL, '78db131f-e83e-4758-851d-2eeb4a7d04fa', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID bd1d311c-804d-4604-b37e-92a493eb559c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 01:29:17', 0),
('774288ff-1da0-44b8-b683-092ea1e32b86', NULL, '7ef75326-490b-482e-882f-98642ef569c6', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"case \'Initial\': return \'text-indigo-700\';\" for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:27', 0),
('7762c7fa-28e2-40d1-8a21-896a76be2652', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ac25a3f2-fba8-4a11-a84d-c13807febe07', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: eeeeeeeee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:09:29', 0),
('77c7f223-d061-498e-8abd-e6df6ee9e596', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:39', 0),
('78f66830-7667-4e12-b518-167a5ffaa0f6', '087ccbc9-efa8-44e0-8435-3310207554d7', '2a9b70a6-b8c4-4e43-be6e-fde43d9893e8', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: uuuuuuuuuu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:19:40', 0),
('790224fd-730d-4764-955e-2804fab5214d', NULL, 'd61966bc-34fc-4921-b375-b1da21842101', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: asdas', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:49:58', 0),
('799efc4e-cfb1-47da-b780-4785ffd5673d', NULL, '315f678c-73ed-4feb-8f4f-94554a05e54b', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"ddddddddddddddddddd\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:42:25', 0),
('79cf84b7-ca9d-423b-8510-35fdc2170717', '087ccbc9-efa8-44e0-8435-3310207554d7', 'efcceb0d-1006-462c-a975-deb909bfd0ad', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'dfsgfdsg — dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:16:52', 0),
('7a8ac692-6b1a-41d1-8a06-aa9306524779', NULL, 'e43c6e38-5949-42ff-8158-3607ad77fee8', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 3e79a958-802c-4597-ad7f-14ec50c492b1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 02:15:47', 0),
('7d1aa18d-34c7-4866-b34a-59af3acd33f0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:46:41', 0),
('7d8b7084-c046-43db-ae54-4660c9f36f9a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:26', 0),
('7d9f42b4-40f3-44bd-80e1-ceb2c65fc53e', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:57:58', 0),
('7ea62a20-57ea-4c32-8e78-c1f7d0c75e98', '087ccbc9-efa8-44e0-8435-3310207554d7', '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - LEDGER ENTRY — TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:56:13', 0),
('7edf508f-f88b-46ee-bdb8-f3477e79d92c', NULL, '3dfa91ae-4090-46ad-8cc5-918f6e48ce31', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"vvvv\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:34:50', 0),
('7f1ff075-7534-477d-b952-1cc1a3549f3f', NULL, '0a52df93-d420-42b6-852c-75141a59d35b', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"dddddddddda\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:34:35', 0),
('7fdf63df-f05b-4e47-ad13-a07405b2af48', NULL, 'd609674a-6787-4060-8451-353093cbf042', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"rrrrrr\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:49', 0),
('80a09497-a2e9-40d4-bbb2-2f7ce6b4fa1f', NULL, '1fb9085e-9880-4d79-959b-67822b0d445d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"fffffffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:40:05', 0),
('8165f39c-1c9b-4154-b598-a5b47024ec11', NULL, 'd0e73905-28fb-46db-854f-3f1e3d51dcf2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"wwowow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 09:38:16', 0),
('821cc2c2-bc8a-462f-aa20-58144e0f1bd6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'fed10a9d-6f6b-4644-861d-aaf49f9fa570', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: oooooo', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:28:35', 0),
('828705b5-722b-4c17-8a68-ff40a630d211', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:17', 0),
('82fd0bc9-43e0-4458-9cc1-f439638346e1', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:31:45', 0),
('8340d5ac-0eb3-41df-8c2e-39876f0dd692', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:24', 0),
('8427cd5f-9f11-4f2a-8161-a725daa868f1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f4578a05-c1a5-44b5-80a1-08c2bdeb3414', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: TEST D - PROJECT REJECTING — TEST D - PROJECT REJECTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 01:47:48', 0),
('842fd96a-ea6a-4cce-bc48-95331f25710a', '087ccbc9-efa8-44e0-8435-3310207554d7', '9aa6264e-d475-4793-84e4-def023b32774', 'date_change_request', 'Date Change Request Rejected', 'approvals', NULL, NULL, 'Rejected date change request for project: TEST E - SAMPLE PROJECT (WITHOUT PROOF) — TEST E - SAMPLE PROJECT (WITHOUT PROOF)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:32:01', 0),
('8440501b-3ea5-4cd4-b630-1ca59bae19b3', '087ccbc9-efa8-44e0-8435-3310207554d7', '3bd9f824-3450-465b-a1a7-ef1d1f4abdaf', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 09:32:36', 0),
('844aac16-50bd-4a53-9fdd-6d2b2a8df743', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ccdb8a20-20f1-4054-b7fc-a12c807463ce', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 11:15:30', 0),
('847b3f2b-9906-442c-9a24-5d1bcfa8e6a3', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:24', 0),
('852e4ef5-87c7-4dc0-a62b-f3ccaaf09efb', NULL, '84f1d33a-c881-41ce-ae7f-efd7269ec3a4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"8\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:18:04', 0),
('85c8ec50-6663-433f-acb9-4c2c38933381', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd259555c-d776-4f4e-ae02-0c9b287aa4f8', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MANEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:32:49', 0),
('867a1424-aa84-41b9-b28d-f54bd124daff', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:53:50', 0),
('86a4d6c3-5d4f-4760-9b54-3b6aae6d4f5e', NULL, '00843bdb-9ee2-420d-9c01-c72cd30f8bcf', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"jjjjjj\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:42', 0),
('86d5e464-1e67-4164-ad63-8fde60ce591c', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:32:28', 0),
('87264e5b-0950-419b-ae37-68e91993b1e0', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:19:27', 0),
('87cba6ff-d001-4134-b089-7d81c69ba2e3', NULL, '6a6eff52-c388-4d62-a5a3-c8907bff8eb0', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"TEST G - INTIAL TRANSFERS\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:37:44', 0),
('8815559e-95af-432d-9ae2-054f7d8a94e7', NULL, 'a869ac41-4b2a-433c-aa66-13a9f000417b', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"ffffffffff\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:57:04', 0),
('889f4ce7-3626-42ed-a43d-4aecac0f1722', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:21', 0),
('8afae5ad-1563-4ca7-9395-b9f66804261a', '087ccbc9-efa8-44e0-8435-3310207554d7', '433836b0-9061-4ffe-bea2-4c6e202bfb3b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 1234', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:43:15', 0),
('8b787154-269c-430f-a650-3ef7fc4024db', '087ccbc9-efa8-44e0-8435-3310207554d7', 'bd1d311c-804d-4604-b37e-92a493eb559c', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A - START UP MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 01:22:00', 0),
('8ba48ddc-392b-45ad-adc3-502e2ebdebb0', NULL, 'bd1d311c-804d-4604-b37e-92a493eb559c', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A - START UP MONEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 00:41:25', 0),
('8c8fdbec-b359-4d28-95d9-8f71ffab82fc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f665c1cb-d9bc-4964-8318-684757fb0b57', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sadfsdaf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:22:58', 0),
('8d303649-922a-494d-b782-3a38ee40bff1', '087ccbc9-efa8-44e0-8435-3310207554d7', '2c672cf1-8f77-449c-ba12-f1ed266497ac', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: SPIDERRR', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:49:46', 0),
('8d4c7855-b31d-40a4-8655-ffd9f05a1396', '087ccbc9-efa8-44e0-8435-3310207554d7', '28abfc90-e1d7-4100-b2e4-001f8b42c7b9', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: rttt — rttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:56:02', 0),
('8e79194c-ad39-4e67-a43c-795960d58867', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:19', 0),
('8f549bfb-2a33-414e-9625-021a08191719', NULL, '55ed9f2b-250f-4e15-a422-2dc738642c14', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"tttttttttttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:35:04', 0),
('8f792f5f-5c1f-4fbb-a5c3-9c463df7cc7a', '087ccbc9-efa8-44e0-8435-3310207554d7', '9efb9c55-572b-480f-8975-f81f71f3291b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: asdas', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:39:32', 0),
('8f7ffcb3-139f-4584-b4b0-bbb779ea864b', NULL, 'c115366e-1d81-46eb-87db-e4927bada365', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"money\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:41:47', 0),
('8f9a6ad3-5091-4f94-8aec-4551a301d05d', '087ccbc9-efa8-44e0-8435-3310207554d7', '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdafsda', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-14 10:30:48', 0),
('8fbc6d02-334e-43dc-9ff3-3f888840b300', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:19', 0),
('90349396-cf8c-4765-9f16-a4cd7c691581', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e5cc2d7b-f225-4a39-8fbe-c2cd584039c7', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'qwqewqweqwe — janiiiiii', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:24:01', 0),
('9086e62c-31c3-4fa3-8ff8-a1a502871dbc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:36', 0),
('908c71bd-e0a4-475a-9e77-9d2366a1f9f3', NULL, 'd7d8f4a6-01b5-4a26-ab7a-f0926677f87c', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"pppppppppp\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:28:29', 0),
('908f4f23-1f41-494e-838e-2a7da8deb40a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:17', 0),
('90d43ffd-ac29-4c92-a4d8-338266654500', '087ccbc9-efa8-44e0-8435-3310207554d7', '6b5f34f5-2d45-4ac5-8e18-f8376a8cd21f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:16', 0),
('911de43f-d423-41cd-8932-9f7fdba5f010', '087ccbc9-efa8-44e0-8435-3310207554d7', '7f739e97-a163-468f-a2a2-3af1d0b1608a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdfgds', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 13:25:25', 0),
('91824922-9055-448e-94d4-83221b63702b', NULL, 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 23711f86-7260-4866-80e7-9dd4d7394111', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:13:55', 0),
('9186c127-0edb-4d4e-b750-1c419c277981', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f79601bb-f699-4283-a21a-a5074cd31f2c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:28:51', 0),
('92e7861b-9dbe-4b68-bcf2-48e27233aa20', NULL, '274d8d6e-a47a-41ac-aff0-f812fee85bb7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"aaaaaaa\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:05:02', 0),
('93175d91-abe4-4b2c-9f41-7fa093cb7c29', '087ccbc9-efa8-44e0-8435-3310207554d7', '56cfd012-e4b7-49d5-8095-d398b50fde20', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST C - INITIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:58:01', 0),
('9337603c-b816-4a56-aff2-25d4b035639d', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:15:44', 0),
('936336e0-a59e-4e32-ab40-bada53964cd7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c115366e-1d81-46eb-87db-e4927bada365', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: money', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 06:41:57', 0),
('947f34d5-1576-49d8-98da-a15430336c12', '087ccbc9-efa8-44e0-8435-3310207554d7', '108a8139-72c7-4f49-b115-de7577a93ddd', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: asfasd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:53:28', 0),
('94ce086e-1813-498e-975c-62fdff2fbf9a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:40:59', 0),
('94e4aaa9-2f05-41df-b4aa-406963ab6a49', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:18:08', 0),
('9536f7f6-b17d-48e7-826c-364cfe6f4370', NULL, '77c95044-68c8-4ac5-aa6f-6e20437047ea', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A - START UP MONEY (WITH PROOF)\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:45:42', 0),
('956e693c-c5b4-4bab-9622-e2c42cdb833a', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:28:34', 0),
('95a4f23f-b21f-4be2-9702-0cc8e87c5099', NULL, '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:24:18', 0),
('95bf8f26-137b-4fef-b114-0b4e2e18b81f', '087ccbc9-efa8-44e0-8435-3310207554d7', '810b05e4-7266-4f5a-b460-e7a492862f84', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:01:04', 0),
('9613d158-6175-4520-ac6f-2872bb53a150', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:38:06', 0),
('966502e3-3aca-421e-b267-3a1fe5087ed6', NULL, '81f86e97-f3b4-4ab0-b437-9396875ac877', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:03:29', 0),
('96c691d0-d4e3-41a9-8956-bdf88e7fe2b7', '31fcedfb-f507-44bd-ad89-336c55539fea', '890e3836-1065-46fa-8830-354a6f430684', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID d473b3b9-28bc-4ed0-911d-5b7cdee90b60', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:45:56', 0),
('9724a089-7cf5-4b75-9252-e0d5152a884c', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:24:50', 0),
('9731e779-a005-4163-8917-7f25feec1a14', '31fcedfb-f507-44bd-ad89-336c55539fea', '00afbf20-9ae4-4178-ab06-63e0751bb15a', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"wow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 14:33:27', 0),
('973653dd-5a2b-4be2-b716-04bd38db69a7', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:12:22', 0),
('9738fd38-df1e-4a67-af83-bc1840239df2', NULL, 'a4d73cf4-5aa8-44de-a394-67ad95946496', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TETSTTT\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:36:18', 0),
('97c2f2be-2c46-4eaf-b277-fbea141983c8', '087ccbc9-efa8-44e0-8435-3310207554d7', '0b8b2dc6-3641-4dac-8d70-4eaf4e8b9fdb', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST E - SAMPLE PROJECT (WITHOUT PROOF)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:27:18', 0),
('97f1b6aa-a0ae-4da0-8c78-9535fa51e075', '6373498c-903e-43a9-bb1d-b67a496aee24', '1d3ec754-568b-46e4-a487-ab684cb2a09d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:52', 0),
('980e0c18-2620-4b25-8ae0-0258887fae42', NULL, 'cb8e7a7b-bced-4314-b7a8-004cbf21bed3', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"transfer\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:57', 0),
('98245401-aeb4-4291-958c-fa88a5ebeb40', '087ccbc9-efa8-44e0-8435-3310207554d7', '556d3b58-be3e-4b98-831e-bb8691bbc4c4', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:00:58', 0),
('986421a8-3787-4f5a-b50e-0840cb2df9cb', '087ccbc9-efa8-44e0-8435-3310207554d7', '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: adasda — weee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:46:54', 0),
('9a12004b-4570-4a8c-b62c-c93e7bfa31c9', '087ccbc9-efa8-44e0-8435-3310207554d7', '7987240f-af1e-4cd3-bd3c-cff3b55ef5af', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrrrrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:54:30', 0),
('9afb644b-70ae-492a-a224-83a385055188', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dd6d28ef-4127-427b-a1e3-235c6b9dbabf', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:56:00', 0),
('9b98b479-89ef-41ca-b587-666de61770c6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:53:54', 0),
('9bd003c6-cdbb-4345-8b6a-5219a4ec3b84', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 10:29:27', 0),
('9be8eea1-a9de-435c-b615-afb11ce716e1', '087ccbc9-efa8-44e0-8435-3310207554d7', '12968484-4272-4a95-b360-0a8c8c6e94d6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:08:46', 0),
('9bea76fc-9eb0-403f-9633-b794c00687c2', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:38:22', 0),
('9c2c4f48-1931-4315-a4f0-eb18cf52b067', NULL, 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"LASt - A\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:32:55', 0),
('9ce36243-9d00-416f-8335-3be77e1729e0', '31fcedfb-f507-44bd-ad89-336c55539fea', 'e26305fa-2caa-4709-87c0-93a699271e2a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dfgds\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:27:29', 0),
('9d2c217e-0fee-47b7-a793-f74135dbb972', NULL, 'f665c1cb-d9bc-4964-8318-684757fb0b57', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sadfsdaf\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:22:43', 0),
('9d9fb30d-152c-4b3b-a91f-415aa465688b', '087ccbc9-efa8-44e0-8435-3310207554d7', '789a4a17-b81d-4c74-aac3-bb98b4afee8d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: tttttttttttttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:42:39', 0),
('9dce3c56-5f6b-449a-89b6-435fd7862551', NULL, '37fb5351-b278-4f19-afba-fc06f6662fe3', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"iiiiii\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:51', 0),
('9df102b2-47fd-47e2-9f31-efcd8bca0506', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:44:09', 0),
('9e700b1f-721e-46ba-b87e-6830cc21feb1', '31fcedfb-f507-44bd-ad89-336c55539fea', 'fa48ba0a-aca5-4dc4-90d8-95ed587a69af', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdfdsa\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:51:09', 0),
('9ea3ff70-b713-4875-aaf2-b700ef17ef67', '087ccbc9-efa8-44e0-8435-3310207554d7', '9d9ae6ca-3335-4e35-a2a7-7e312f1ee04f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dsgfd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 13:15:25', 0),
('9ebd682f-612c-4a28-b8c2-f9b66cebba64', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:44', 0),
('9f3a7656-3095-42dd-a0d9-52fdce0fd40d', NULL, '0350b52e-801e-450c-8b41-9346d7d65bbc', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: asfasd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:53:42', 0),
('9f3c8cb3-2ccf-4774-bb08-8050e013ca60', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:19', 0),
('9f70ac40-3786-43a9-b93c-69f2f3723658', NULL, '00843bdb-9ee2-420d-9c01-c72cd30f8bcf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"jjjjjj\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:27', 0),
('9f835efa-2b11-429b-b469-9271de83abe5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:37:36', 0),
('9f8a4c93-6231-4fa6-b05d-a7055e994569', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:16:18', 0),
('9fc583f8-3a27-4785-8818-83b499f319b5', NULL, 'a62125a0-49a6-4b38-8ffb-57a93ab1cf4b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:13:15', 0),
('9ffba03e-b007-4eeb-a8e7-910e32fb4f7d', '087ccbc9-efa8-44e0-8435-3310207554d7', '6df32d92-9dff-4766-b700-2ac28c379f22', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qqqqqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:06:05', 0),
('a00db2bb-255e-4b07-b896-46aac71368a4', NULL, 'c2ec0cad-bfb9-409b-aa39-8b2a8faaa410', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"fffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:26:54', 0),
('a0740621-21b9-47c3-a506-79abe8f935a8', NULL, '876f35e5-fc11-4d1b-ac48-c1a7fd1d9d30', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"testttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:38:19', 0),
('a088c090-fa49-4d7a-bb4c-d337dc5ef130', NULL, '56cfd012-e4b7-49d5-8095-d398b50fde20', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST C - INITIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:56:46', 0),
('a1ed2601-2339-42f2-8383-730e3362710f', '087ccbc9-efa8-44e0-8435-3310207554d7', '4ddbd5db-65fa-4ab7-95eb-6e65522fb607', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'case \'Initial\': return \'text-indigo-700\'; — adsa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:31:55', 0),
('a1fd42e0-3372-45d5-be13-293c4904d224', NULL, '11cb18be-962b-41fe-a59f-45d7057638e7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qoqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:20:26', 0),
('a28e7cd8-f74e-4e88-979e-2a0c1a797f0f', NULL, 'f4efd930-4ef2-4a46-b9de-b6c13fe0c556', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 11:09:29', 0),
('a2d580a4-31bf-43e2-99b4-b4ec237b802c', '6373498c-903e-43a9-bb1d-b67a496aee24', 'ceefdb0e-b529-421e-b928-332b657f033a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:32:15', 0),
('a353cb92-fe55-41aa-af35-e083da9f8374', '087ccbc9-efa8-44e0-8435-3310207554d7', '4d4359fa-acfd-4259-b20a-dbbcacce32bc', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST G - INTIAL TRANSFER — TEST G - INTIAL TRANSFER', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:47:57', 0),
('a40a298a-2122-4aaa-9cfb-25e594fa5c95', NULL, 'e69dd1c1-2e90-48f2-a557-af412e5adbe0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"weee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:44:47', 0),
('a4dfdb1a-5318-45fa-b37a-7119b488c2a1', '087ccbc9-efa8-44e0-8435-3310207554d7', '25558800-12fc-4109-98ca-31c13f1fabd3', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A - START MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:43:32', 0),
('a5e2dda6-07ca-483c-94ed-0366e1c242ad', NULL, '7eaa2f66-1fef-4baf-99cd-70a13bd4ad56', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID f665c1cb-d9bc-4964-8318-684757fb0b57', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:23:18', 0),
('a6baac37-6f92-4a6c-bb6c-86063187331c', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:23:07', 0),
('a75aa213-2db5-44b7-b846-d86cd40cf137', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:31', 0),
('a783924c-66cf-4b66-9cf3-07fbc44dd07b', '31fcedfb-f507-44bd-ad89-336c55539fea', 'eea8ffac-76e0-4243-a9fe-b87c9b9c2cd6', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"TEST J\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:49:30', 0),
('a7efef72-a708-4ef4-80d8-0e53cb9a822b', NULL, 'dd6d28ef-4127-427b-a1e3-235c6b9dbabf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"1\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:55:44', 0),
('a89b71d0-b98d-469d-a5fc-87011f6fe008', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:29', 0),
('a912269f-a04a-4a32-95d2-e25d7a40700f', '6373498c-903e-43a9-bb1d-b67a496aee24', '0a0a0805-5c74-471f-a79c-9e06d7e023cc', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:32:18', 0),
('a9a68477-43da-47b4-b69b-05fab089b10d', NULL, 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:56:17', 0),
('a9b86410-f0c7-4e42-a2ff-7f8a7ce484bc', '087ccbc9-efa8-44e0-8435-3310207554d7', '587cb113-55f7-4006-a935-ee2cb7bc3049', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:38', 0),
('a9ca6f4c-3b0b-49c6-bee2-bb4e1d52c5cb', NULL, '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:24:15', 0),
('aaaa8bb4-33cd-4ebb-92d1-20a0cbcf3b3e', '31fcedfb-f507-44bd-ad89-336c55539fea', '3aaf2024-635d-41d4-994c-bae101e92809', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"asdas\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 14:45:49', 0),
('aae498f6-83b0-4e56-97e3-3754132f0244', '087ccbc9-efa8-44e0-8435-3310207554d7', '6b5f34f5-2d45-4ac5-8e18-f8376a8cd21f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:11:32', 0),
('ab030ba8-44ef-455c-8e3d-2ac57bcb7c7b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:36:54', 0),
('abcfcb9e-aecc-4888-b14e-73a994eaf190', '087ccbc9-efa8-44e0-8435-3310207554d7', '44cd0e36-b2f4-4242-8041-f6431e05bc91', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MOENYYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:42:10', 0),
('ac801ee3-7bea-4ff6-858a-72a1e0213b56', NULL, '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdafsda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-12 10:17:51', 0),
('add8d2c8-6f30-4381-a2f2-4d1f0728f5c6', NULL, '1a70eb6d-ce63-4d86-a2e1-baafbf5a59a1', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2a175fcd-d5e9-440f-b741-543b45cf3917', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:38:21', 0),
('ae0af81c-f801-480e-831e-300ff20e1cd4', '087ccbc9-efa8-44e0-8435-3310207554d7', '3dfa91ae-4090-46ad-8cc5-918f6e48ce31', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: vvvv', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 01:58:23', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('ae135cc5-3d7d-4a10-a571-01aeaa708816', NULL, 'f9284c06-e432-4185-b84e-1364c2eeeb45', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"Hingi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:46:53', 0),
('ae22b573-3aec-40b4-bf5c-5ddc5aa2b627', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f7f8b067-e630-4809-959b-77360c366108', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-01 02:12:15', 0),
('aea878b1-c7c8-4dd2-b6d2-c40ed11c85a0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:24', 0),
('aeedca32-da20-400e-a6fb-acccdc111ac1', NULL, '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"JANIII\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:43:40', 0),
('aef0ce0a-7df2-422e-b7d1-6013f2fa3776', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'emdgquintos — TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:23:57', 0),
('af323234-ef8d-4cf2-8c3c-47480fbb3bef', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ad310c33-b917-42b9-8f33-910b4217c7f2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qweert', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:40:35', 0),
('afca4f53-bf4b-4f7e-850e-9fe67fa27285', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:19:32', 0),
('b1592f47-2e8e-4813-a120-f5148b63594c', NULL, '6a6eff52-c388-4d62-a5a3-c8907bff8eb0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST G - INTIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:34:03', 0),
('b1886959-3502-4f7c-b7c7-09928bd7c666', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:41', 0),
('b1e3de84-1246-47a1-b482-1c00f00277aa', NULL, 'cdcb60c1-c59c-4a92-8bec-ec66ee1d4143', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwqwqwqwqwqw\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:30:16', 0),
('b1ef38d1-1b15-4da8-a61f-04a4a9e13f88', NULL, 'c3d325e1-6042-4e8a-9860-9f2f0980a307', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"transfer\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:51', 0),
('b220d3c8-d67d-432a-b787-19d2950a27a0', NULL, '7ef75326-490b-482e-882f-98642ef569c6', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:10', 0),
('b274477b-d9df-41a5-ae07-d8feb320b176', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b30cbac7-93f4-4186-a11d-5035bdf4d31e', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'asdasd — TEST B', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:55:23', 0),
('b284e523-9f8a-458f-8f4d-6f110e72b97a', NULL, '58d0c0e8-6f16-4ed8-a9fc-ecb6cc9c827a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST G - INTIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:46:46', 0),
('b2aaa5a8-2930-41d9-8121-4ee8d11a66ec', '31fcedfb-f507-44bd-ad89-336c55539fea', '119a1a4e-aa2d-480c-9ba4-09462b5f9d9d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdfsd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:56:43', 0),
('b4ad2f63-5879-45fb-b202-d1c65cbc0cbc', NULL, '928851e9-3d0a-4701-8607-906fd2a2f7cf', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"qweee\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:44', 0),
('b5116ee9-a402-4eed-8086-5a9e65eea631', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:12', 0),
('b598decc-8b53-4683-ad77-a803da863128', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c6b22578-a47d-409d-b5f7-2559e6681d96', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:21:57', 0),
('b6d09da7-9477-4d1d-80fe-af2b591bf606', '31fcedfb-f507-44bd-ad89-336c55539fea', '1d3ec754-568b-46e4-a487-ab684cb2a09d', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID d01968a8-3a78-449a-959d-b50575c9351f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:11:26', 0),
('b7dbaad7-b7e3-4f01-823a-f320ff2684fd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:14', 0),
('b8243b9e-decb-44e4-9eb1-3d7ffa3b1426', NULL, '8d6c9dee-a764-49b5-ab9b-5bb36610fc61', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ppppp\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:17:56', 0),
('b97c32d9-bda4-4dc2-b7f9-e56f3136a59c', '087ccbc9-efa8-44e0-8435-3310207554d7', '8983a130-a81e-4f75-8d12-117c3887f100', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: maney', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:30:06', 0),
('b9ea389e-5b67-4f57-95b1-06b6b761f6d3', '087ccbc9-efa8-44e0-8435-3310207554d7', '587cb113-55f7-4006-a935-ee2cb7bc3049', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - LEDGER ENTRY — TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:56:01', 0),
('b9ee6c1d-7569-4437-b0fc-24a89c27af4c', NULL, '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"LAST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:31:53', 0),
('ba62ac2f-f793-45ea-9216-b1fd1971c4af', NULL, '853b412a-16a3-48a1-8f56-a29fd3c9c2c0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 5ce475d7-7efa-41af-ada9-5bba2069fc8b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:38:05', 0),
('ba9658fd-429c-4915-8b8c-616a89623c71', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6603f21-367a-4a08-95d8-d724d4fa252f', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A — TEST A - START UP MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:27:24', 0),
('bae831d5-8f0a-45b2-99ed-bf369c13e800', '087ccbc9-efa8-44e0-8435-3310207554d7', '4d4359fa-acfd-4259-b20a-dbbcacce32bc', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:32', 0),
('bb06145c-8cb4-4979-aff1-263f60dc42e0', '31fcedfb-f507-44bd-ad89-336c55539fea', 'eea8ffac-76e0-4243-a9fe-b87c9b9c2cd6', 'meeting', 'Meeting Marked Completed', 'meetings', 'update', 'Success', 'Marked meeting as completed \"TEST J\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:51:57', 0),
('bb0d3393-4488-442e-92ff-b0368ad08bb9', NULL, 'ccdb8a20-20f1-4054-b7fc-a12c807463ce', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 11:12:15', 0),
('bb1b0fa3-a60e-4272-9207-08e466b1e72b', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:24:54', 0),
('bb23d175-2634-4c46-9544-bb75cef6158a', '087ccbc9-efa8-44e0-8435-3310207554d7', '34b1be0b-7f23-4544-8056-be53c6f14f66', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - LEDGER ENTRY — TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:56:18', 0),
('bb7be40b-182e-44cf-b29a-88337278ef42', NULL, '274d8d6e-a47a-41ac-aff0-f812fee85bb7', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"aaaaaaa\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:48', 0),
('bbf6da58-a017-4849-acbb-f0651ad18215', '087ccbc9-efa8-44e0-8435-3310207554d7', '0977799a-13fe-47e5-b41d-8a2afe55d5ce', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:37', 0),
('bbfaa2bf-7006-4733-9fbf-276214b2cce9', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:24:25', 0),
('bc685239-eb7e-4d1d-893b-7c21a56e4918', NULL, 'e3a9c3c9-0ea9-4a0b-9398-05aa2a3d174c', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"xxxxx\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:19:25', 0),
('bcde41cf-7531-4f2b-af57-8cf857e975ad', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:23', 0),
('bceff184-d20e-4f03-82f2-b93aff507187', NULL, 'c4b7b832-f09a-4df6-b477-ab13a1425d92', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"123\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:22', 0),
('bd9724e1-189f-4e59-8a33-000d9f1e963b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:28:22', 0),
('bdab1b96-d57c-4179-82e6-c97c459877ef', NULL, 'abfc3dcd-efd2-4f6a-878e-47eb0e22ed00', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-01 23:38:49', 0),
('bde1e660-6201-45fd-9f2c-e7e1b088b159', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:36:18', 0),
('be3c662c-a434-48e2-b53b-ffef9c0514a7', '31fcedfb-f507-44bd-ad89-336c55539fea', 'feab8fbb-12b8-4131-9ee3-295fdbcef0a0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sfgdsg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 12:46:52', 0),
('be3cc804-6f23-4ace-afdf-70cfbcb6d2dc', NULL, '2c672cf1-8f77-449c-ba12-f1ed266497ac', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SPIDERRR\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:47:36', 0),
('beb0e774-5499-41b6-8855-b02b04c16f3c', NULL, 'b30cbac7-93f4-4186-a11d-5035bdf4d31e', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID e221e2d3-3f41-41ed-9ebe-825b9f4f0360', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:55:11', 0),
('befff347-6e1a-4307-a25b-4322cc145762', NULL, '27beff6b-58c0-4d02-b88a-45c745e73999', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:52:35', 0),
('bf0923b9-443f-4c48-b6c2-5277ada10b35', NULL, '99fcee4e-48d4-4f28-97bf-04473e3dfc24', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:08', 0),
('bf4565ac-5fcc-473d-82e0-0547fd91f75d', NULL, 'c144e59a-4597-462a-bbb9-d3ef5a104d75', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"naji\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:21:41', 0),
('bf4d42a3-b8ce-4949-a648-e9bb94f73062', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fe916ae-a629-4a5f-bff4-10eace77b15b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dfgsdfs', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:00:02', 0),
('bf5f27ec-8ba7-411a-9acf-da55f51d6968', '087ccbc9-efa8-44e0-8435-3310207554d7', '6cec1bbd-f9f0-4674-a525-a54e304880f0', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:37:34', 0),
('c0574993-4835-476f-8603-16082cdac49c', NULL, 'e4ea3411-3a63-4923-aff3-c9f37dde7878', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:06:59', 0),
('c24fedb1-12a3-4898-9910-c10f2410bdf9', '087ccbc9-efa8-44e0-8435-3310207554d7', '1acce8d8-b86f-427b-9622-d1969c270e9e', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:40:57', 0),
('c259ce05-cc58-4347-9955-a7dd75f6af2f', '087ccbc9-efa8-44e0-8435-3310207554d7', '3931908d-9593-4be4-b232-f858ac87013b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A - START UP MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:26:13', 0),
('c313cfea-838c-4f7e-aaa4-b75eccba3e12', NULL, '9bba96cc-0eac-4906-9557-e5d4258faae0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST G - PROJECT INITIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 02:49:05', 0),
('c34560d0-1e4f-4954-ba9f-8f7ae1e2f4ff', NULL, '88d3aa5e-0a13-4f92-b4c1-e4fec8720e24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"janiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:30:45', 0),
('c40384ae-d527-4ba6-a333-f66043b875b9', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dbf34bca-61d1-4ce2-b162-2a551bf003c9', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 13:01:40', 0),
('c46c25a1-4d77-4a2f-9936-42265dae7de1', NULL, '127a9561-5a92-4e46-8cfc-2573710d8b16', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"adas\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 06:13:30', 0),
('c4dcb50b-0047-468a-b7b0-3e54074d4513', NULL, '8766fbb5-62ec-41fd-a2b5-1e48afc37d24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SADFSDA\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 06:02:00', 0),
('c4dde003-0b6e-47a8-97b1-3396876fc3b9', '6373498c-903e-43a9-bb1d-b67a496aee24', '49705332-4c85-4574-9b64-d421a8a38adc', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:24', 0),
('c5084356-d7d6-4a7c-b16c-f2d66318a4fb', NULL, '63086e74-6f31-4a27-ae3c-75101d57ad7c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID bd1d311c-804d-4604-b37e-92a493eb559c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 01:31:23', 0),
('c670a9b3-dd60-426e-9633-88636151275f', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:26', 0),
('c70c7d16-b690-4e74-933b-d4fc93905371', NULL, '433836b0-9061-4ffe-bea2-4c6e202bfb3b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"1234\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:43:04', 0),
('c75dc859-c1d3-415e-9bb2-9e8c59967493', '087ccbc9-efa8-44e0-8435-3310207554d7', '8fcd907b-a0cf-49b6-9df1-281c7dcadf86', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:49:12', 0),
('c819dca8-8626-4d67-8ebd-bbaf8520e884', NULL, '69fd9f32-3048-4792-acb8-8bf2ebe03536', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"h\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:56:45', 0),
('c82dbdfd-8ed0-4913-9488-f24bef7bec7b', NULL, 'e5cc2d7b-f225-4a39-8fbe-c2cd584039c7', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 4670d8f5-aec5-4340-90b1-6170bab480b4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:23:44', 0),
('c86f8918-4c0f-4d23-ad99-dd7aa6d3c02f', '6373498c-903e-43a9-bb1d-b67a496aee24', '890e3836-1065-46fa-8830-354a6f430684', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST G — TEST E', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:47:16', 0),
('c8f72162-1af9-4d6c-b61a-173d1da8b108', '087ccbc9-efa8-44e0-8435-3310207554d7', '77c95044-68c8-4ac5-aa6f-6e20437047ea', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:49:15', 0),
('c95cfe98-da92-4a60-b014-0a8a9964633e', NULL, 'ba7b1f2e-8e12-4f49-8ca6-b06b3b8db59c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:29:39', 0),
('c96f6635-0d3e-417e-b957-8eadd50aaf33', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:32:53', 0),
('c9cee7e9-9a31-447a-a5f3-72b29e50c64e', NULL, '78c5e726-6131-4f82-91f3-01b47acf83c0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"wqerwqe\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:57:07', 0),
('ca77c26e-58c0-4072-9599-c3ac1f1a3c0c', NULL, '4670d8f5-aec5-4340-90b1-6170bab480b4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"janiiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:03:16', 0),
('cb6ddc1b-8b25-420e-a50b-af54d8f1277c', NULL, '9aa1179b-7233-4feb-8ea8-f8429914b486', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID dd6d28ef-4127-427b-a1e3-235c6b9dbabf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:57:19', 0),
('cbaee0fc-bb5a-4a86-b0a1-8453e9ffe9f5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'fa48ba0a-aca5-4dc4-90d8-95ed587a69af', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdfdsa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 13:52:38', 0),
('cbb2ec44-e35b-408b-8899-83cf79c09754', NULL, 'e5c50101-d30c-4ea8-b864-1e88d8a25eb0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 77c95044-68c8-4ac5-aa6f-6e20437047ea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:51:13', 0),
('cc6b6a0e-f0ce-405e-a0b5-e9239f66e34c', '087ccbc9-efa8-44e0-8435-3310207554d7', '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:25:37', 0),
('cc70abbb-54c1-495f-89d7-b8c10b9fd72f', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:50:40', 0),
('cc763643-8159-4f97-8cbd-7c432d8e5b96', '31fcedfb-f507-44bd-ad89-336c55539fea', '74a30d10-a0ee-4e80-bceb-bf24c04f40c9', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID d473b3b9-28bc-4ed0-911d-5b7cdee90b60', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:46:14', 0),
('cc9473b3-ea47-486c-be05-ebf218e5a255', NULL, 'de194365-e159-4a2c-be81-1385cfc5e651', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"UPLOAD\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 09:26:30', 0),
('cdfa8212-2cec-47a0-af49-d618bd6c854d', '087ccbc9-efa8-44e0-8435-3310207554d7', '11cb18be-962b-41fe-a59f-45d7057638e7', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qoqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:20:41', 0),
('ce7cb503-fa0e-4389-8aac-a8f9599d1249', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc1fb7a3-ce6e-47a8-845e-a188138f0238', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: aaaaaaa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:05:00', 0),
('ce9dda4a-d984-4030-83f5-28b608e656c3', NULL, 'de90732f-3615-4e07-bbb4-49f9c91b3031', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"10\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:28:23', 0),
('cf9e58a9-9c6f-48ad-b2f9-d2b585a75f19', '087ccbc9-efa8-44e0-8435-3310207554d7', '250178a0-a6a3-4c38-8a6a-d1a9af085359', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: eeeeeeeeeee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:48:30', 0),
('cfe97d3e-f04c-41f2-b213-dfc557e15fa9', NULL, '539f56cd-5214-4940-9144-e809e5682ee8', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:48:35', 0),
('d1579722-f7bb-46e7-8fb0-b8f00ad1bee5', '6373498c-903e-43a9-bb1d-b67a496aee24', '74a30d10-a0ee-4e80-bceb-bf24c04f40c9', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'TEST G1 — TEST I', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:47:25', 0),
('d1603921-fbaa-4aca-a574-b71476e04ff3', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:21', 0),
('d1b6de75-08bb-4744-9558-0ee7ffe37131', NULL, 'fe28e89f-0d81-4e46-9188-1c3b12f2428a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 56cfd012-e4b7-49d5-8095-d398b50fde20', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:58:38', 0),
('d1d8d7aa-aef6-498e-ab3f-13737f251f69', NULL, '573e6dc3-bb44-4427-a02d-1d66c9898157', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"7\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:16:55', 0),
('d1ef0111-010c-4b05-a368-fda12d70ef08', NULL, '11a87ddc-3e66-48e5-9b80-4a0e03e96869', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:37:56', 0),
('d2017af8-aad5-4b7d-9171-08973b35f59f', NULL, '2a9b70a6-b8c4-4e43-be6e-fde43d9893e8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"uuuuuuuuuu\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:05:54', 0),
('d27a996b-4548-4d39-bdaf-7cf2b91a853f', '087ccbc9-efa8-44e0-8435-3310207554d7', '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:12:28', 0),
('d28aa508-036f-482d-94db-24007800807f', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:12:15', 0),
('d32f2067-8c7f-4b04-86a6-df96ed6252e6', '087ccbc9-efa8-44e0-8435-3310207554d7', '5ce475d7-7efa-41af-ada9-5bba2069fc8b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:26:39', 0),
('d3be6878-16ce-4d65-a14f-bbc32e8b2261', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f9284c06-e432-4185-b84e-1364c2eeeb45', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: Hingi', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:47:18', 0),
('d3bff5e3-afe4-4a43-900d-2e8b74948e02', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6603f21-367a-4a08-95d8-d724d4fa252f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:34:09', 0),
('d4776ca6-9142-4aa9-abe0-ac75ab4226a0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a05478a0-5f7f-4863-9fff-a83684a60b32', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEYYYYYYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 04:54:56', 0),
('d4faa0ce-a31d-445b-927e-4d4ef29cf5dd', NULL, 'c21eebd9-e1f4-444f-bc9f-561d3b9eec0b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 06:12:52', 0),
('d53885e7-041e-4612-bbd5-db9d40c7a5e0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:41:48', 0),
('d55ce07e-d954-48e8-8edd-72c72eae5adb', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:35:27', 0),
('d602938f-9c83-48b8-b8a9-2cf16792850c', NULL, 'c6b22578-a47d-409d-b5f7-2559e6681d96', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"9\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:21:47', 0),
('d6803df8-7c3b-4771-8a39-ca9c902320fd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:18', 0),
('d724034b-a084-4330-bf07-4afebda77888', NULL, '9117d38a-5560-4d05-a80e-cc72a0a85691', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: TEST E - SAMPLE PROJECT (WITHOUT PROOF)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:28:35', 0),
('d819ea84-5b13-4005-b031-6124306da42c', NULL, 'ea8c108b-7868-4189-8ab6-2846ff3ac757', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:04:25', 0),
('d8389cd3-8125-492c-9e81-106e668e9016', '31fcedfb-f507-44bd-ad89-336c55539fea', '8ebed55a-8385-4797-ad87-f2e8b8d02146', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdgfdsg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 13:20:15', 0),
('d862512d-d01d-4998-8064-85bc1f0bf2bd', NULL, '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 11:40:08', 0),
('d8d47d92-b529-4280-a18b-e9eedc071ec8', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:53:58', 0),
('da19ff84-b5db-4679-a14c-0f916cb5d474', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:17:59', 0),
('da690d0d-0ad1-4e9f-8198-098eb95e05ac', NULL, 'cc28e369-b452-42b1-93ff-ff5ed6a6e947', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ggggggggg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:23:57', 0),
('daf4b0b6-6890-42d6-b93f-3a0503580492', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd3ab57ac-3ffa-4a7f-94f7-0896e815a3d0', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A1 — TEST A - START MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:45:57', 0),
('db0f774e-d884-4a2a-8cd2-8623f618b7cb', NULL, '28abfc90-e1d7-4100-b2e4-001f8b42c7b9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:55:36', 0),
('db2dd72b-d61f-4b81-a9ec-c893097b8a9a', '087ccbc9-efa8-44e0-8435-3310207554d7', '5ebebeae-bb1e-42a4-b39d-90dde6ab15f4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:47:28', 0),
('db48f9a1-495e-4537-911d-a613fa04056b', '087ccbc9-efa8-44e0-8435-3310207554d7', '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: JANIII — etretw', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-24 01:25:59', 0),
('dd8545ee-8f80-4f12-952d-a4a632afe42d', '087ccbc9-efa8-44e0-8435-3310207554d7', '2151523c-1df3-479d-b69f-14e678600d5b', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:11:25', 0),
('dd8ee350-22d9-42ef-8727-a05f951eb752', '087ccbc9-efa8-44e0-8435-3310207554d7', 'aa2860db-d074-47e5-8942-731c4cb0c598', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dsfgfdg', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-14 10:36:04', 0),
('ddc6d776-ac5a-43be-9c41-78f9d3c1fa4c', '087ccbc9-efa8-44e0-8435-3310207554d7', '2b0f20d9-b259-49c7-a9cc-b0a76decbe5a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 5555555', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:16:47', 0),
('de1b16c7-39d9-4b72-a500-4b2ea5361ec1', NULL, 'b5da8c88-1d30-454e-b4f7-2c98b0014416', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:07:15', 0),
('de2cceae-60ff-42d7-aab9-b957ef5e3b42', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6603f21-367a-4a08-95d8-d724d4fa252f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:50:54', 0),
('de4cd263-9db2-4cc7-8ea7-d33ba3cec1e3', '6373498c-903e-43a9-bb1d-b67a496aee24', '0a0a0805-5c74-471f-a79c-9e06d7e023cc', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:40', 0),
('dee92025-ce7a-4c5c-bad3-3c681b41825d', '087ccbc9-efa8-44e0-8435-3310207554d7', '8f0f19d0-9bea-4cf4-b5b7-e5dd74a6272e', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'TEST A — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:27:30', 0),
('df60b73d-4a2f-4bfa-ab74-19d193fc65a3', '087ccbc9-efa8-44e0-8435-3310207554d7', '4ec63d64-632a-4e60-8b37-f7077e5cdd8f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:25:47', 0),
('df7f5570-16c0-4beb-b5d4-e5bacfaaf3c3', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e4ea3411-3a63-4923-aff3-c9f37dde7878', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:07:09', 0),
('df9958cb-21d1-48cf-b453-9fa4ae555067', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6603f21-367a-4a08-95d8-d724d4fa252f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:28:58', 0),
('dfd7e533-c2ac-4bec-aa0c-52e07bc264a2', NULL, '47ea1447-42ec-4694-a660-f1fcaab78aff', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 08:59:13', 0),
('e0078de8-c875-4a38-872f-bf307b3e38bd', NULL, '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:34:14', 0),
('e0736ca8-a2ed-4203-b86b-c0d3e7e63406', '087ccbc9-efa8-44e0-8435-3310207554d7', '32e7963b-e977-4524-9bfd-f954a760dd20', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dfgds', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 14:09:14', 0),
('e076bc11-2458-4425-b183-67548766821d', NULL, '23711f86-7260-4866-80e7-9dd4d7394111', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:13:07', 0),
('e150711d-e4ca-4f2d-9336-7a8494fd47b8', '31fcedfb-f507-44bd-ad89-336c55539fea', 'd01968a8-3a78-449a-959d-b50575c9351f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST A\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:05:08', 0),
('e18748d0-e04d-424d-9b51-313f3aab469f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f658bfe7-15b5-4509-83e4-afcc010ce143', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:24:19', 0),
('e1aefd38-b3af-4724-af59-e61662e389ed', '087ccbc9-efa8-44e0-8435-3310207554d7', '46208cc3-1f4d-437f-932a-5306d4d1c2cd', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdafsd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 13:23:23', 0),
('e1c3db02-ceb0-4597-a72f-e4cc9d6802d2', NULL, '12968484-4272-4a95-b360-0a8c8c6e94d6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"6\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:08:33', 0),
('e1f1acc9-4b6e-496e-96cb-19feffaaa79d', NULL, 'ba0a15cb-eb83-4fc0-bee6-5b196d691e1d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"12\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:37:54', 0),
('e2e0b8b3-d4b1-4672-a2f5-06dd7dbb7877', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:57', 0),
('e2eb2b75-9d17-44b3-ac41-73beffc120a5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:55', 0),
('e3164b76-c167-48dd-943c-d425a56b96a8', NULL, '6a7630bb-c6c4-4ff6-a06b-b1899e410591', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID bd1d311c-804d-4604-b37e-92a493eb559c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 01:48:34', 0),
('e351cff1-cff6-44f4-a177-742473c1570a', NULL, '250178a0-a6a3-4c38-8a6a-d1a9af085359', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eeeeeeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:47:29', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('e3b296b7-f75b-4ad5-a825-23af4b5784b1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:13', 0),
('e4593e5f-b1c8-497f-b400-2146d3a030a0', NULL, '57f4219b-7c6b-4fd7-afdc-29da8c54440a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:01:16', 0),
('e46adb17-b3f6-44c3-8452-38b5e374b667', '087ccbc9-efa8-44e0-8435-3310207554d7', '4670d8f5-aec5-4340-90b1-6170bab480b4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: janiiiiii', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 02:04:00', 0),
('e48f66f6-870b-4df4-91c4-965f68865a07', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:44:18', 0),
('e552dff7-cf7d-4849-8baf-6a3a7f704127', NULL, '00afbf20-9ae4-4178-ab06-63e0751bb15a', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"wow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 03:14:28', 0),
('e580cbde-c3d2-4aee-8f70-0c907ef23030', NULL, 'ae95c603-c101-4a1a-9a81-25eb83d722ee', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"transfer\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:20', 0),
('e68516d0-6931-4423-a574-9c2a1e1ef12f', '087ccbc9-efa8-44e0-8435-3310207554d7', '0bf0003a-4aeb-4e44-9d71-8898f801445b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 10:29:12', 0),
('e6b9f312-3505-45c2-8d2b-be095106539f', '087ccbc9-efa8-44e0-8435-3310207554d7', '8766fbb5-62ec-41fd-a2b5-1e48afc37d24', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: SADFSDA', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 06:02:18', 0),
('e6e29f6b-9348-44a5-9ddc-aa7fddb999f0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:28:00', 0),
('e801881b-01bd-4830-8f75-28b7742e22c2', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f79601bb-f699-4283-a21a-a5074cd31f2c', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST A — TEST A - START UP MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:27:19', 0),
('e80235f7-c7c0-44f3-8337-5b8a6c110839', '087ccbc9-efa8-44e0-8435-3310207554d7', '522abf36-60f9-45b8-b146-50ff88eb1e1e', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 11:51:00', 0),
('e85150cb-6219-4397-ab10-7bc31dae0df2', '087ccbc9-efa8-44e0-8435-3310207554d7', '60b5a674-5fc9-4875-8071-ec1b7c424137', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:00:07', 0),
('e8599645-4dea-486d-b7e4-3da3bca3acdb', NULL, 'ac35bd25-b940-41ba-b0c1-7a45d1622671', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:34:22', 0),
('e8e91c3c-f501-4759-9618-70b3d425f009', '087ccbc9-efa8-44e0-8435-3310207554d7', '4da7028f-ea1c-4842-99d5-b46d10e2bb0c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:23:50', 0),
('e9e33e5e-a266-43ec-a3f7-130e4863250b', NULL, 'fed10a9d-6f6b-4644-861d-aaf49f9fa570', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"oooooo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:27:09', 0),
('ea57f2ad-9396-46dd-843c-959ab3f160ca', '6373498c-903e-43a9-bb1d-b67a496aee24', '4cd8c141-3191-45c9-8646-bc9660a5fdf3', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:47', 0),
('ea6f74dd-8d48-4fda-bde8-e1adb0f46126', NULL, 'd259555c-d776-4f4e-ae02-0c9b287aa4f8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MANEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:32:28', 0),
('eacec914-74bb-4de6-8ce1-69df8e7c8ecb', '6373498c-903e-43a9-bb1d-b67a496aee24', '4cd8c141-3191-45c9-8646-bc9660a5fdf3', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST C1 — TEST A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:32:27', 0),
('eb101f59-1460-4313-9c94-40576690d7e9', NULL, 'ae12aab1-5af5-4e46-afe3-865fa0c354e0', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ettt\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:00', 0),
('eb3b5906-91c1-4f46-aa78-99cebdd63f8c', NULL, 'a15adcfd-da7c-4470-8e61-c9853096baa0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:34:28', 0),
('eb58ae32-acc6-4b27-89f7-e1f91439bebd', NULL, '7ba422cf-ea47-420f-a17c-cf37f15b67ea', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"5\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:04:52', 0),
('eb71013b-df55-4901-805c-53eebc84d6f3', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f41d3ac9-f358-4a0e-9d2c-d88e6739b88d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:31:37', 0),
('eb98b8a9-ab52-402f-9057-19343c6fa4e4', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f79601bb-f699-4283-a21a-a5074cd31f2c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:50:47', 0),
('ed467b45-3e87-4356-847f-969b776c1f9a', NULL, '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"test\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:21:58', 0),
('ed821bc2-ec85-4c96-8405-77e2a0535329', '087ccbc9-efa8-44e0-8435-3310207554d7', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 12:24:48', 0),
('ed92b58e-adb6-4922-ae98-4f48fa8632dd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:27:39', 0),
('ee0285db-b198-4885-81ef-215f054b1876', NULL, '4d4359fa-acfd-4259-b20a-dbbcacce32bc', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 58d0c0e8-6f16-4ed8-a9fc-ecb6cc9c827a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 11:47:45', 0),
('ee20afe7-b561-4776-87a5-5657928cb97b', NULL, 'f658bfe7-15b5-4509-83e4-afcc010ce143', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST1\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:24:04', 0),
('ee7c782b-4c25-49b6-9114-7cf385193ca1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e735c646-4e69-4244-95c3-5eaebe738808', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'safsadf — dfgds', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 14:10:32', 0),
('ee870ada-079e-42df-a00f-cfa5281e2f9d', '087ccbc9-efa8-44e0-8435-3310207554d7', '116b8cac-d9e1-43ab-9f8c-074aabb1549a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TEST B - LEDGER ENTRY — TEST A - START UP MONEY (WITH PROOFS)', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 10:56:06', 0),
('ef57938f-4d81-4c49-aa66-e5a3eb1048c5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a15adcfd-da7c-4470-8e61-c9853096baa0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: eee — truncate', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:36:10', 0),
('ef6ca54b-5ffc-4854-b37c-0b80e0fdb923', NULL, '789a4a17-b81d-4c74-aac3-bb98b4afee8d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"tttttttttttttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:41:09', 0),
('ef992bcb-29da-4121-819a-ac73f804ec83', '087ccbc9-efa8-44e0-8435-3310207554d7', 'de90732f-3615-4e07-bbb4-49f9c91b3031', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 10', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:28:36', 0),
('efd57bbf-13c6-4b95-899d-93e857b84b9b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:32', 0),
('f0455813-0e9a-4c27-becb-c30a0a71bb88', NULL, 'efcceb0d-1006-462c-a975-deb909bfd0ad', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID d873870b-6daf-4e55-b1fc-c1a828278d81', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:16:33', 0),
('f0ee153d-1856-499c-96a9-74b39307ba5c', '087ccbc9-efa8-44e0-8435-3310207554d7', '876f35e5-fc11-4d1b-ac48-c1a7fd1d9d30', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: testttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:38:42', 0),
('f1cde9bb-00f1-47f4-a343-7ce12e5ed607', '31fcedfb-f507-44bd-ad89-336c55539fea', '32e7963b-e977-4524-9bfd-f954a760dd20', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dfgds\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 14:08:16', 0),
('f1d7cb12-ec8f-432c-bcb6-3ca4e1d452d1', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 04:50:05', 0),
('f4b4defd-5056-401f-9ce3-21f7257f4e09', '6373498c-903e-43a9-bb1d-b67a496aee24', 'ceefdb0e-b529-421e-b928-332b657f033a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-05 00:35:35', 0),
('f5aaa242-603d-4984-a251-cf6607d33b75', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:12:11', 0),
('f65f41b8-0445-42e8-8799-5d82256cdcdd', '087ccbc9-efa8-44e0-8435-3310207554d7', '2a175fcd-d5e9-440f-b741-543b45cf3917', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:56:43', 0),
('f68a880d-5593-490d-abef-a58ee8bcc05d', '087ccbc9-efa8-44e0-8435-3310207554d7', '2151523c-1df3-479d-b69f-14e678600d5b', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 05:10:08', 0),
('f692c578-18a4-48df-a5e7-4f7813c48553', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c664cc87-1040-49e7-9d80-ee85ee9e7d18', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:34:08', 0),
('f75aa1bb-4ee8-48a5-81d6-8c1f01292d59', NULL, '47ea1447-42ec-4694-a660-f1fcaab78aff', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:48', 0),
('f785ad6a-5c7e-4cd9-b281-ccbf802149df', '087ccbc9-efa8-44e0-8435-3310207554d7', '59c224bc-1c29-4056-8e02-c9c7cd459e7e', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:59:20', 0),
('f7e56c84-8d42-4a30-866c-a7b65f302920', '087ccbc9-efa8-44e0-8435-3310207554d7', '9aa1179b-7233-4feb-8ea8-f8429914b486', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, '2 — 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:57:30', 0),
('f7eda665-415f-4ec1-915f-edacd0949210', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 00:44:30', 0),
('f868d167-5efb-42a5-9641-2c112649cb6d', '31fcedfb-f507-44bd-ad89-336c55539fea', 'eea8ffac-76e0-4243-a9fe-b87c9b9c2cd6', 'meeting', 'Meeting Updated', 'meetings', 'update', 'Success', 'Updated meeting \"TEST J\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-05 00:50:01', 0),
('f8e035e3-e68c-4df5-ac01-1631d3c85ec3', NULL, 'ed6bb5b3-8dbe-45f6-83c6-7be07ae7cd29', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sdafsda', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 02:38:21', 0),
('f928ef02-8c93-4910-a32a-4dd963892ac7', NULL, 'a3a9f6ca-32f2-4c43-b8ae-5c99dfc24405', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:09:26', 0),
('f93b416c-7c98-4445-8bd8-8325ec1d0c5a', '087ccbc9-efa8-44e0-8435-3310207554d7', '11a87ddc-3e66-48e5-9b80-4a0e03e96869', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qweee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 06:39:49', 0),
('f9a41141-c8bf-486d-a7a1-1e4e63d833ca', NULL, '108a8139-72c7-4f49-b115-de7577a93ddd', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"asfasd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 05:53:12', 0),
('f9d119d5-6ced-4633-8a06-32dba7821ae2', NULL, 'f79601bb-f699-4283-a21a-a5074cd31f2c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 3931908d-9593-4be4-b232-f858ac87013b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 04:26:34', 0),
('faa8e3a2-0fed-4b91-9c28-06cbfeae5ea3', NULL, '4ec63d64-632a-4e60-8b37-f7077e5cdd8f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:23:38', 0),
('fad8eb4d-e672-44f2-b413-a3a8c20e6f78', NULL, 'c4ee54b9-63cc-4b14-b087-27517c051254', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqqqqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:38:42', 0),
('fb02541f-b01f-4d09-873b-b8a7fb0d6ab0', NULL, 'dc1fb7a3-ce6e-47a8-845e-a188138f0238', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"aaaaaaa\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:04:46', 0),
('fb8a8bab-42cd-41d1-ac8b-593881052d26', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-04 03:40:44', 0),
('fcf77c7b-5484-49b9-9c9e-b4f54a5f2eda', NULL, '587cb113-55f7-4006-a935-ee2cb7bc3049', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 77c95044-68c8-4ac5-aa6f-6e20437047ea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 10:51:58', 0),
('fd984d30-7bc5-41be-9c37-d560a727cc1b', NULL, 'aa2860db-d074-47e5-8942-731c4cb0c598', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dsfgfdg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 10:31:45', 0),
('fda1207d-bd72-459a-a742-d09b83173207', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:13', 0),
('fdd8b5c7-5e97-4528-92e7-f67a8235c5a7', '31fcedfb-f507-44bd-ad89-336c55539fea', 'e735c646-4e69-4244-95c3-5eaebe738808', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 32e7963b-e977-4524-9bfd-f954a760dd20', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 14:10:20', 0),
('fee4bf1f-7590-4b49-adbe-709fb705a329', NULL, '556d3b58-be3e-4b98-831e-bb8691bbc4c4', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 25558800-12fc-4109-98ca-31c13f1fabd3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 03:45:38', 0),
('ff8f6b1a-f142-4088-89f6-9212354aac06', '087ccbc9-efa8-44e0-8435-3310207554d7', '853b412a-16a3-48a1-8f56-a29fd3c9c2c0', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TESTb — TESTb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:39:17', 0),
('fff013a9-499b-4de9-8699-bfc92a3b400f', NULL, '1ee1b6e1-7945-4ce3-8172-37ab645dca24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-04 06:05:57', 0);

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
('04e088a6-da86-4d1a-a69a-9cd3be01053e', 'd01968a8-3a78-449a-959d-b50575c9351f', 6, '6d5122b8c7c1ac4064c05d34d0bbf8470bce73e05d1fb570da8d46155755a7f5', '61661e92ebf709a1cb80d3a2bdfb6714782a50aa22b5feb09c028dcdbd8aca7a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"4cd8c141-3191-45c9-8646-bc9660a5fdf3\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"TEST C1\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST C\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"10\\\\\\\",\\\\\\\"amount\\\\\\\":10}]\\\",\\\"amount\\\":\\\"10.00\\\",\\\"entry_type\\\":\\\"Canvas\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:32:27+00:00\\\",\\\"snapshot_nonce\\\":\\\"2586e7b47de78e00\\\"}\"', '2026-08-04 17:32:27'),
('1dd1a0da-c9dc-42bc-88f3-d030905dc80a', 'd01968a8-3a78-449a-959d-b50575c9351f', 2, '425e1463184469e056560eb05a3687ee1d90aef377c4ba1bb3a840ece09fbeaa', '6c43c84757f64a9976cdefcf689474da0ec0431d7408a87102ea6fe8f9d19e60', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"2edebf73-fd8d-43ed-90a1-df79c678b689\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"TEST C\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST C\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:31:02+00:00\\\",\\\"snapshot_nonce\\\":\\\"2675b06dd685b01b\\\"}\"', '2026-08-04 17:31:02'),
('237a9ba6-53c3-46ac-869f-05319f27515c', 'd01968a8-3a78-449a-959d-b50575c9351f', 5, '48947f12dc5bc71cd4ebe2a18a45a1a0e6fd2074de124b2890083b1a1387c00a', '6d5122b8c7c1ac4064c05d34d0bbf8470bce73e05d1fb570da8d46155755a7f5', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"1d3ec754-568b-46e4-a487-ab684cb2a09d\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"TEST C\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST C\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Sponsorship\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:32:23+00:00\\\",\\\"snapshot_nonce\\\":\\\"2e7b023a4c79bbf9\\\"}\"', '2026-08-04 17:32:23'),
('30db7bd4-76ae-498f-9aaf-4013f2f51944', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 2, '34b9a9555ec06a4a52b4464c3aafee4bbef7d90cbf39efe4ef906eefab9d26a0', '76776208283c85df009dc502a548cdcd1eb3c4c979fab9dfb6048269dc431a8a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"890e3836-1065-46fa-8830-354a6f430684\\\",\\\"project_id\\\":\\\"d473b3b9-28bc-4ed0-911d-5b7cdee90b60\\\",\\\"description\\\":\\\"TEST G\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST G\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:47:16+00:00\\\",\\\"snapshot_nonce\\\":\\\"9d3943693c24e8da\\\"}\"', '2026-08-04 17:47:16'),
('337ff4ed-98de-4029-89d3-ba3dd939a3db', 'd01968a8-3a78-449a-959d-b50575c9351f', 3, '6c43c84757f64a9976cdefcf689474da0ec0431d7408a87102ea6fe8f9d19e60', '3aea64960eff77dfc9b1b57604b5653c03d7d469604df8897d612f74676d51a5', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"ceefdb0e-b529-421e-b928-332b657f033a\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"TEST C\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST C\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Income\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:32:15+00:00\\\",\\\"snapshot_nonce\\\":\\\"5c8ba1e18c97adc0\\\"}\"', '2026-08-04 17:32:15'),
('5853659c-2221-43e7-9a49-42ac2570e35b', 'd01968a8-3a78-449a-959d-b50575c9351f', 4, '3aea64960eff77dfc9b1b57604b5653c03d7d469604df8897d612f74676d51a5', '48947f12dc5bc71cd4ebe2a18a45a1a0e6fd2074de124b2890083b1a1387c00a', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"0a0a0805-5c74-471f-a79c-9e06d7e023cc\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"TEST C\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"id\\\\\\\":1,\\\\\\\"item\\\\\\\":\\\\\\\"TEST C\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Donation\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:32:18+00:00\\\",\\\"snapshot_nonce\\\":\\\"02587849f621dc65\\\"}\"', '2026-08-04 17:32:18'),
('591d7d5a-80aa-4c42-8656-beb9af56b1a7', 'd01968a8-3a78-449a-959d-b50575c9351f', 0, NULL, '27145be6458a637572cdba4c169b7edb85434b3dd54db69caf4f46653126e3d4', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"title\\\":\\\"TEST A\\\",\\\"description\\\":\\\"TEST A\\\",\\\"amount\\\":\\\"500.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:07:08+00:00\\\"}\"', '2026-08-04 17:07:08'),
('72459aa8-3736-42fc-8e09-48c8179551ff', 'd01968a8-3a78-449a-959d-b50575c9351f', 1, '27145be6458a637572cdba4c169b7edb85434b3dd54db69caf4f46653126e3d4', '425e1463184469e056560eb05a3687ee1d90aef377c4ba1bb3a840ece09fbeaa', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"49705332-4c85-4574-9b64-d421a8a38adc\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"Initial project budget baseline\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"500.00\\\",\\\"entry_type\\\":\\\"Initial\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:07:08+00:00\\\",\\\"snapshot_nonce\\\":\\\"1711a45eb2938f22\\\"}\"', '2026-08-04 17:07:08'),
('8d220507-24f2-4224-a600-2a0e1710a627', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 0, NULL, '3a73570acd0c69e01a9f437a5fc5dfe19535954b9374c7d8d4f2bd963de92174', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"d473b3b9-28bc-4ed0-911d-5b7cdee90b60\\\",\\\"title\\\":\\\"TEST E\\\",\\\"description\\\":\\\"TEST E\\\",\\\"amount\\\":\\\"200.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:44:43+00:00\\\"}\"', '2026-08-04 17:44:43'),
('d40f96ac-f1bb-4b81-b4c6-bfd63acc2c99', 'd01968a8-3a78-449a-959d-b50575c9351f', 7, '61661e92ebf709a1cb80d3a2bdfb6714782a50aa22b5feb09c028dcdbd8aca7a', '6737f9d2e845dea2e9bed84b8b1bef116669b98d2e472f47ae420b6237b03cbd', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"f4f04006-40d9-4372-9e24-c987bcd0dcbc\\\",\\\"project_id\\\":\\\"d01968a8-3a78-449a-959d-b50575c9351f\\\",\\\"description\\\":\\\"Transferred to project \\\\\\\"TEST E\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"200.00\\\",\\\"entry_type\\\":\\\"Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:44:43+00:00\\\",\\\"snapshot_nonce\\\":\\\"6627cf58e71a6541\\\"}\"', '2026-08-04 17:44:43'),
('f2f2bf0c-0486-4cb9-992e-3998e3d39cdd', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 1, '3a73570acd0c69e01a9f437a5fc5dfe19535954b9374c7d8d4f2bd963de92174', '34b9a9555ec06a4a52b4464c3aafee4bbef7d90cbf39efe4ef906eefab9d26a0', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"d8feeada-1121-43fc-ab1e-3241e73be75f\\\",\\\"project_id\\\":\\\"d473b3b9-28bc-4ed0-911d-5b7cdee90b60\\\",\\\"description\\\":\\\"Transferred from completed project \\\\\\\"TEST A\\\\\\\" to project \\\\\\\"TEST E\\\\\\\"\\\",\\\"budget_breakdown\\\":null,\\\"amount\\\":\\\"200.00\\\",\\\"entry_type\\\":\\\"Initial Transfer\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-04T17:44:43+00:00\\\",\\\"snapshot_nonce\\\":\\\"d1f2d3121adeaa34\\\"}\"', '2026-08-04 17:44:43');

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
('fe38de78-dd42-4e6d-adfb-e6da63a711fa', 'd01968a8-3a78-449a-959d-b50575c9351f', '31fcedfb-f507-44bd-ad89-336c55539fea', '2026-08-26', '2026-09-02', '2026-08-27', '2026-08-29', 'TEST B', 'approved', NULL, NULL, 'TEST B', '2026-08-05 00:07:51', '2026-08-05 00:08:09');

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
('0a0a0805-5c74-471f-a79c-9e06d7e023cc', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Donation', 100.00, 'TEST C', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST C\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'TEST D', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:32:18', NULL, 0, '2026-08-05 00:11:18', '2026-08-05 00:35:40'),
('1d3ec754-568b-46e4-a487-ab684cb2a09d', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Sponsorship', 100.00, 'TEST C', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST C\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', NULL, NULL, 'Approved', 0, 'TEST D', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:32:23', NULL, 0, '2026-08-05 00:11:26', '2026-08-05 00:35:52'),
('2edebf73-fd8d-43ed-90a1-df79c678b689', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Expense', 100.00, 'TEST C', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST C\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'TEST D', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:31:02', NULL, 0, '2026-08-05 00:10:47', '2026-08-05 00:35:30'),
('49705332-4c85-4574-9b64-d421a8a38adc', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Initial', 500.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'storage/ledger_proofs/779ab46cead9877761e73996801ad36e4e06bd81b5ae2cdbe30711800a5a7350.jpg', '779ab46cead9877761e73996801ad36e4e06bd81b5ae2cdbe30711800a5a7350', 'Approved', 0, 'Auto-generated baseline on project creation', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:07:08', NULL, 0, '2026-08-05 00:05:08', '2026-08-05 00:35:24'),
('4cd8c141-3191-45c9-8646-bc9660a5fdf3', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Canvas', 10.00, 'TEST C1', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST C\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"10\\\",\\\"amount\\\":10}]\"', 'storage/ledger_proofs/57d39691aa88f968af14f3d29ef6bf7fc2c0127e62db7401eb95f9884bb363be.png', '57d39691aa88f968af14f3d29ef6bf7fc2c0127e62db7401eb95f9884bb363be', 'Approved', 0, 'TEST D', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:32:27', NULL, 0, '2026-08-05 00:11:36', '2026-08-05 00:35:47'),
('74a30d10-a0ee-4e80-bceb-bf24c04f40c9', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 'Income', 100.00, 'TEST G1', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST G\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/8a6f9c4106a25d628945562f802f1ed124d47802bb0df84d9f61e25a4ce9a5ab.png', '8a6f9c4106a25d628945562f802f1ed124d47802bb0df84d9f61e25a4ce9a5ab', 'Rejected', 0, 'TEST I', NULL, '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', NULL, '2026-08-05 00:47:25', 0, '2026-08-05 00:46:14', '2026-08-05 00:47:25'),
('890e3836-1065-46fa-8830-354a6f430684', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 'Expense', 100.00, 'TEST G', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST G\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'TEST H', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:47:16', NULL, 0, '2026-08-05 00:45:56', '2026-08-05 00:47:16'),
('ceefdb0e-b529-421e-b928-332b657f033a', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Income', 100.00, 'TEST C', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"TEST C\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'TEST D', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:32:15', NULL, 0, '2026-08-05 00:11:03', '2026-08-05 00:35:35'),
('d8feeada-1121-43fc-ab1e-3241e73be75f', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', 'Initial Transfer', 200.00, 'Transferred from completed project \"TEST A\" to project \"TEST E\"', 'Transfer', NULL, 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'Transferred from completed project \"TEST A\" to project \"TEST E\"', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:44:43', NULL, 0, '2026-08-05 00:42:43', '2026-08-05 00:44:43'),
('f4f04006-40d9-4372-9e24-c987bcd0dcbc', 'd01968a8-3a78-449a-959d-b50575c9351f', 'Transfer', 200.00, 'Transferred to project \"TEST E\"', 'Transfer', NULL, 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, '{\"transfer_source_project_id\":\"d01968a8-3a78-449a-959d-b50575c9351f\",\"transfer_source_project_title\":\"TEST A\",\"transfer_destination_project_id\":\"d473b3b9-28bc-4ed0-911d-5b7cdee90b60\",\"transfer_destination_project_title\":\"TEST E\"}', '6373498c-903e-43a9-bb1d-b67a496aee24', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', '2026-08-05 00:44:43', NULL, 0, '2026-08-05 00:42:43', '2026-08-05 00:44:43');

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
('eea8ffac-76e0-4243-a9fe-b87c9b9c2cd6', NULL, 'TEST J', 'TEST J', '2026-08-07 10:51:00', '2026-08-05 00:49:30', 1, NULL, NULL, '100', '[\"TEST K\",\"TEST K\",\"TEST K\"]', 'meeting_proofs/bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053.pdf', 'bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053', '2026-08-05 00:51:57', 0);

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
('00399add-f6c7-4477-8967-35966da085ac', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:28:34', '2026-08-04 06:16:01', 0),
('02e5e176-b5b5-48b4-bb57-07463e07a840', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:32', '2026-08-03 09:13:44', 0),
('03b9cf40-2a2f-4598-9991-d384bd7c10df', NULL, 'Project Approved', 'Project \"dvvvvv\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:13:04', '2026-07-27 02:08:37', 0),
('068984a0-3fb8-465e-abc4-246b6ebba3b0', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:38', '2026-08-04 23:58:59', 0),
('06d20008-235d-11f1-9647-10683825ce81', NULL, 'Welcome', 'Thank you for regitering with STEP Platform.', 'system', 1, '2026-07-27 02:08:37', '2026-03-20 13:30:00', '2026-07-27 02:08:37', 0),
('06d33eb0-9160-4c2f-93f0-7b7fbb31e1c9', NULL, 'Project Approved', 'Project \"2\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:56:43', '2026-07-27 02:08:37', 0),
('07b52a56-b72d-418c-878e-0d0436a0a255', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:40', '2026-08-05 00:52:33', 0),
('07e83bf1-57af-4d02-ae9b-8d4c1179a263', NULL, 'Project Approved', 'Project \"10\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:28:36', '2026-07-27 02:08:37', 0),
('08c2488b-2549-4754-876a-fc6c6277ba29', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:21', '2026-08-03 09:13:44', 0),
('0a5fd17e-9d5d-45cb-9c26-700abd25463e', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST A\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:27:50', '2026-08-05 00:52:33', 0),
('0b9494e0-c54b-42dd-84c3-2db75c2b9252', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:31', '2026-08-03 09:13:44', 0),
('0bcbb15f-8980-4d70-9d8c-80d004f47f0c', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:38:22', '2026-08-04 06:16:01', 0),
('0cfc03df-6847-48ce-a9b8-b342f432c3bf', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST A\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:32:15', '2026-08-05 00:52:33', 0),
('0ec2460e-9a85-4b32-9cf0-bd88de49ef24', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST E - SAMPLE PROJECT (WITHOUT PROOF)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:38', '2026-08-04 23:58:59', 0),
('0f06f896-71a3-4031-ab15-4127b694df81', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Rejected', 'Ledger entry for project \"TEST E\" was rejected. Reason: TEST I', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:47:25', '2026-08-05 00:52:33', 0),
('0fb830d5-b4d2-40a7-83db-8d2b15f2f358', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:55', '2026-08-03 09:13:44', 0),
('0fbaf4aa-e8cd-4dd9-a724-2f221badf1f7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:40:59', '2026-08-03 09:13:44', 0),
('118af6bc-94a3-4826-99eb-ffe080d2c943', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:08', '2026-08-03 09:13:44', 0),
('12c1bd22-468f-4e9c-a003-d47329010c70', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:37:34', '2026-08-04 06:16:01', 0),
('13acb6a4-746e-4123-9d8f-ae3e91d8b60e', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:37:40', '2026-08-04 06:16:01', 0),
('140d773a-3dff-4f37-8bd6-6b468f5036b0', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - ADDING LEDGER ENTRY\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 03:38:01', '2026-08-04 06:16:01', 0),
('14a9976c-1c08-42cf-b2d7-e3643685e79e', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:25:06', '2026-08-04 06:16:01', 0),
('1549aafa-fd12-40c0-9297-67e3afa4aa56', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:25', '2026-08-04 23:58:59', 0),
('15f93216-d2d0-4b53-8a57-00b08c76beaa', NULL, 'Project Approved', 'Project \"TEST1\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 13:24:19', '2026-08-04 06:16:01', 0),
('16aa38eb-2be1-470f-9883-fc3d881b4fa7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 3 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:06', '2026-08-04 23:58:59', 0),
('16c0bb85-5bd6-423c-8eb2-5f9123674950', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:31:45', '2026-08-04 06:16:01', 0),
('1732259e-d6e6-44cf-9bc7-beab7ad63164', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:32:53', '2026-08-03 09:13:44', 0),
('1a9a3160-8f3e-4448-a9e1-ee38fe74f0bf', NULL, 'Project Approved', 'Project \"janiiiiii\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:04:00', '2026-07-27 02:08:37', 0),
('1b265e33-8bcb-4429-a423-62203e705cb7', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:50', '2026-08-04 23:58:59', 0),
('1c458a65-96ab-4da4-8976-1c1f9376f7d3', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:23:55', '2026-08-04 06:16:01', 0),
('1c46baad-9e03-4a96-b407-6189bf15b78c', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:15:30', '2026-08-03 09:13:44', 0),
('1cd062c0-7be3-42ba-8ffa-733111c406d2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:36:54', '2026-08-03 09:13:44', 0),
('1da238b5-bf04-46e1-bf63-de3556a2d245', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" in project \"hi\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:23', '2026-08-03 09:13:44', 0),
('1dc7fa94-fec8-4ef6-9492-c258a01509cc', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:27:37', '2026-08-04 06:16:01', 0),
('1e3a2a6c-218c-4382-b24b-93fdd7b550c3', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:19:41', '2026-08-04 06:16:01', 0),
('1f59e9c5-8a0d-485e-964d-89a713b069df', NULL, 'Project Approved', 'Project \"asdas\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 05:39:32', '2026-08-04 06:16:01', 0),
('20e7ce1a-83c4-4123-905a-d71577aeac56', NULL, 'Project Approved', 'Project \"TETSTTT\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:36:27', '2026-08-03 09:13:44', 0),
('2144078f-5922-42e1-985c-29788210dd94', NULL, 'Project Approved', 'Project \"rrrrrr\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:37:43', '2026-07-27 02:08:37', 0),
('24e1ab65-59d4-4d1c-92ee-071edf56d9b2', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:51:00', '2026-08-04 23:58:59', 0),
('25bed074-7ba7-4ffa-99d9-027eadfd108b', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B\" in project \"TEST B\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:21', '2026-08-04 06:16:01', 0),
('25f37ee6-233e-4565-876f-d7b58970185f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:38', '2026-08-03 09:13:44', 0),
('278949cb-d74b-4882-9ee8-e87c035c2e14', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:25:01', '2026-08-04 06:16:01', 0),
('2851353f-2104-43a9-8d4b-2c7b28790b19', NULL, 'Project Approved', 'Project \"MONEY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:47:28', '2026-08-03 09:13:44', 0),
('2972cb7e-056c-4395-9195-b626e0fbf1c6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A - START UP MONEY\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:11:32', '2026-08-04 06:16:01', 0),
('297bf9c0-80a5-4c9e-b298-d34ab129d003', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:12', '2026-08-03 09:13:44', 0),
('2aea737b-bf82-4086-906b-708bab0e381f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-03 13:36:18', '2026-08-04 06:16:01', 0),
('2b0e325e-270f-4b3f-a3ec-2578a023ea71', NULL, 'Project Approved', 'Project \"MONEYY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:11:10', '2026-08-03 09:13:44', 0),
('2b99357b-f3a9-443b-87b0-2128bb04151b', NULL, 'Project Approved', 'Project \"eeeeeeeeeee\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:48:30', '2026-07-27 02:08:37', 0),
('2c29e5be-4de1-45d5-9add-53c9ec954a85', NULL, 'Project Approved', 'Project \"maney\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:30:06', '2026-08-03 09:13:44', 0),
('2d01c542-ad9d-427b-b451-b42dedb3f15f', NULL, 'Project Approved', 'Project \"MONEYYYYYYY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:54:56', '2026-08-03 09:13:44', 0),
('2d66ab65-64b5-459e-814d-d0af4a9e0f85', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"dsgfd\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:15:13', '2026-08-04 23:58:59', 0),
('2faca93e-c753-49ca-8dd5-e904a0ee53a8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-03 14:53:58', '2026-08-04 06:16:01', 0),
('3025da93-aecc-4ea9-ad02-2baf4f78cdab', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:25:10', '2026-08-04 06:16:01', 0),
('305ee023-14fe-4864-9343-dcaec4d11a7b', NULL, 'Project Approved', 'Project \"8\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:18:14', '2026-07-27 02:08:37', 0),
('31ca38a2-c267-43ee-a91f-b4187c692faa', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:22', '2026-08-03 09:13:44', 0),
('3375fa9a-4eaf-44d1-a078-a83532fb87fc', NULL, 'Project Approved', 'Project \"1234\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:43:15', '2026-08-03 09:13:44', 0),
('3485719f-9dfb-472f-a4ef-e02c9c39cd53', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:43', '2026-08-04 23:58:59', 0),
('34ce47b0-9876-4b64-ae67-939fcb28ce34', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:17:55', '2026-08-04 06:16:01', 0),
('34e4ecb4-f5e3-4311-9c67-aa1e636f0935', NULL, 'Project Approved', 'Project \"eeeeeeeee\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:09:29', '2026-07-27 02:08:37', 0),
('3714b063-95ea-47a3-8a00-8e2e54a4f653', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:44', '2026-08-04 23:58:59', 0),
('38d54a1f-92e9-43ee-9bea-32c2ca6daeed', NULL, 'Project Approved', 'Project \"ssssssssss\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:07:25', '2026-07-27 02:08:37', 0),
('39227088-1d98-4897-9c6f-3654464a67df', NULL, 'Project Approved', 'Project \"money\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:41:57', '2026-08-03 09:13:44', 0),
('395259a1-8ffd-4c1c-8e4c-3b187d85525e', NULL, 'Project Approved', 'Project \"TEST A - START UP MONEY\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 04:26:13', '2026-08-04 06:16:01', 0),
('3b10641c-4dee-44f4-8279-4af34ff124bf', NULL, 'Project Approved', 'Project \"qwer\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:06:24', '2026-08-04 06:16:01', 0),
('3b59ddb3-9647-46b1-9660-351ec5024ca8', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:05:22', '2026-08-04 23:58:59', 0),
('3c480327-1f1e-4646-9188-22eaa027991a', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:35', '2026-08-05 00:52:33', 0),
('3da905a2-ddc1-4bca-bb70-7faab00e491b', NULL, 'Project Approved', 'Project \"TEST E\" has been approved.', 'project', 1, '2026-08-05 00:52:33', '2026-08-05 00:44:43', '2026-08-05 00:52:33', 0),
('3e15dd33-2d19-4f15-9209-36fbbc3cd858', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:39', '2026-08-03 09:13:44', 0),
('3e24a41d-7946-4519-aa38-400ae6abe2d8', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 06:06:15', '2026-08-04 06:16:01', 0),
('3e732a11-7ba8-4db3-8b82-c4f2226daf4f', NULL, 'Project Approved', 'Project \"5\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:05:07', '2026-07-27 02:08:37', 0),
('3fca6aaf-cb3f-4c2d-ac04-05b50ec822e7', NULL, 'Project Approved', 'Project \"12\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:38:03', '2026-07-27 02:08:37', 0),
('3fe4cd9d-6220-42e4-b249-4dca906b5ed2', NULL, 'Project Approved', 'Project \"TEST E - SAMPLE PROJECT (WITHOUT PROOF)\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 11:27:18', '2026-08-04 23:58:59', 0),
('407c6481-9596-47f7-a94d-48024b00e99d', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"Hingi\"\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:31', '2026-08-03 09:13:44', 0),
('408c9248-7886-4e68-a1c2-2a009482be7c', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:00', '2026-08-03 09:13:44', 0),
('42699c67-12c0-4c54-8126-d26083fb9751', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:07', '2026-08-03 09:13:44', 0),
('427813ec-f3fa-4b37-aa9d-0978e913bd0d', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:07:09', '2026-08-03 09:13:44', 0),
('43e59aa4-1c7b-4e4d-8c75-41e306bbcedd', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:52', '2026-08-03 09:13:44', 0),
('4465fe79-ea56-4fd1-86bd-c6062594e2d9', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST A\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:32:18', '2026-08-05 00:52:33', 0),
('45f5e9a5-badb-44f8-9c1b-5e8f7dedc9cd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST E - SAMPLE PROJECT (WITHOUT PROOF)\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:38', '2026-08-04 23:58:59', 0),
('478aa822-c4ff-42cd-b509-9d3fd4701443', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:28:51', '2026-08-04 06:16:01', 0),
('49007828-c158-4f24-a1f9-e31d47e780ad', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST A\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:32:27', '2026-08-05 00:52:33', 0),
('4959dbf3-0ed8-461a-976d-19e0119cc67c', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:34:08', '2026-08-03 09:13:44', 0),
('496c80a4-7f52-4d84-9ea4-7d4d35ff8abd', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:24:54', '2026-08-04 06:16:01', 0),
('49b6701c-2155-499c-bf69-5490affa3f9a', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:19:32', '2026-08-04 06:16:01', 0),
('4a31bd6b-8071-4e19-88be-9f451df78a15', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:04', '2026-08-03 09:13:44', 0),
('4cb8638e-b203-4a35-9cda-e8e315d82d44', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-03 10:29:27', '2026-08-04 06:16:01', 0),
('4cda3955-5eab-4db2-9f53-e25a8ca6c951', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:50:05', '2026-08-04 06:16:01', 0),
('4d41b49f-dc63-48e1-b81c-e818b4025643', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:32:37', '2026-08-04 06:16:01', 0),
('4d6d8b61-3b12-4fce-b793-fa4facf18d42', NULL, 'Project Approved', 'Project \"TEST A - START UP MONEY\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 01:22:01', '2026-08-04 06:16:01', 0),
('4da6cf49-0776-4840-a41b-0a1e715265e4', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 10:21:53', '2026-08-03 09:13:44', 0),
('500770c5-1ba0-442e-8a59-40aefc703966', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:37:33', '2026-08-03 09:13:44', 0),
('512eca02-b9cd-46c2-9319-1378f599c9e3', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:52', '2026-08-05 00:52:33', 0),
('51a18cf4-04a5-483a-9d92-a7bca4f6a278', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST A\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:27:46', '2026-08-05 00:52:33', 0),
('52644321-2b3f-4f75-8f60-a0f5fd3d8523', NULL, 'Project Approved', 'Project \"TEST A\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 05:13:22', '2026-08-04 06:16:01', 0),
('52a6885b-e9f7-419c-a400-f58241e75880', NULL, 'Project Approved', 'Project \"LASt - A\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:33:09', '2026-08-04 06:16:01', 0),
('52fdd4ae-dd63-42c9-8a24-ef6a74af17d5', NULL, 'Project Approved', 'Project \"c\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:00:59', '2026-07-27 02:08:37', 0),
('53a76c7e-09f4-4e01-b500-2aa4bc42d785', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:36', '2026-08-03 09:13:44', 0),
('55d3d5f4-bcca-43ff-b258-976780e505fe', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:40:57', '2026-08-03 09:13:44', 0),
('59101862-f1b5-4673-bd28-b89e0139444e', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:19:27', '2026-08-04 06:16:01', 0),
('5980a462-678c-41ab-b0eb-449644399637', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:17:29', '2026-08-04 06:16:01', 0),
('59c60ac3-7a77-4502-9e8d-ed18799174d7', NULL, 'Project Approved', 'Project \"dsgfd\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:15:25', '2026-08-04 23:58:59', 0),
('5a0251b9-895e-406e-aefb-cf98d5eed023', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:12:11', '2026-08-04 06:16:01', 0),
('5be6f8dc-59be-4ecb-a278-c45183d23abf', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:26:38', '2026-08-04 06:16:01', 0),
('5c8951ab-73e8-4fac-9b50-f65d3747f9e8', NULL, 'Project Approved', 'Project \"oooooo\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:28:35', '2026-07-27 02:08:37', 0),
('5c8f6baa-5f3c-4072-a385-674073d9a9e6', NULL, 'Project Approved', 'Project \"dddddddddd\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:13:24', '2026-07-27 02:08:37', 0),
('5d4a2b1d-141a-4a80-a714-68747556766e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:24:50', '2026-08-04 06:16:01', 0),
('5e17ad3d-5e6f-4d56-8a5c-7ffe6a6b6953', NULL, 'Project Approved', 'Project \"qqqqqqqqqqq\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 10:28:24', '2026-08-04 06:16:01', 0),
('5f16d0b3-7839-475f-82f3-8ac06734b2b8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:15', '2026-08-03 09:13:44', 0),
('5f336e46-9d76-416f-b67a-08708617fdaf', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 09:32:36', '2026-08-03 09:13:44', 0),
('5f337a8e-8432-496e-a904-16a0c22fb905', NULL, 'Project Approved', 'Project \"hi\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:08:28', '2026-08-03 09:13:44', 0),
('5f63faf9-bfda-437d-adff-49407c1fd149', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:14:45', '2026-08-04 06:16:01', 0),
('608a1ee3-b558-4ec0-9fbb-4eb360aab43f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:37:36', '2026-08-03 09:13:44', 0),
('6211cc57-5279-4e7c-9572-a6ee944f8dbe', NULL, 'Project Approved', 'Project \"5555555\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:16:47', '2026-08-04 06:16:01', 0),
('63017b8e-b62b-4515-ac36-96a872a22aef', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"safsdf\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 12:31:34', '2026-08-04 23:58:59', 0),
('63a044a7-7f2e-44e8-b5cd-bea39d438b97', NULL, 'Project Approved', 'Project \"sadfsdaf\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 11:22:58', '2026-08-04 23:58:59', 0),
('63bde57c-3224-4cc2-8e0d-92ca285283d6', NULL, 'Project Approved', 'Project \"rrrrrrrr\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 13:54:30', '2026-08-04 06:16:01', 0),
('63cea05a-719a-4ad4-a312-78c4f03e8898', NULL, 'Project Approved', 'Project \"TEST B\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 04:54:52', '2026-08-04 06:16:01', 0),
('6703a856-8ec1-496a-9483-c9a5eea089a2', NULL, 'Project Approved', 'Project \"7\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:17:05', '2026-07-27 02:08:37', 0),
('67b40e2c-cbdd-4011-9a05-8d19d3a11266', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:19', '2026-08-03 09:13:44', 0),
('6867479d-789d-4bb7-9960-7c0dac98f721', NULL, 'Project Approved', 'Project \"rrrr\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 12:35:08', '2026-08-04 06:16:01', 0),
('68d0d279-0da4-46fd-947c-232309061950', NULL, 'Project Approved', 'Project \"sdfgds\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:25:25', '2026-08-04 23:58:59', 0),
('69d468aa-a2ad-4dda-aa63-45f378734185', NULL, 'Project Approved', 'Project \"wwowow\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 09:38:42', '2026-08-04 06:16:01', 0),
('6b4a9f00-1bfd-4a85-ab8a-3a67dc6b511f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:17', '2026-08-03 09:13:44', 0),
('6be78fa1-cdcf-47e9-bea8-f8aaff94e3bc', NULL, 'Project Approved', 'Project \"LAST\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:32:07', '2026-08-04 06:16:01', 0),
('6beaaddb-52f7-4519-b64c-35cdae9fce43', NULL, 'Project Approved', 'Project \"9\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:21:57', '2026-07-27 02:08:37', 0),
('6dc1422c-9938-48bb-8a6f-8574e33259b4', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"TEST C - INITIAL TRANSFER\"\" in project \"TEST A - START MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:01:04', '2026-08-04 06:16:01', 0),
('6e522913-1b5e-406d-8509-c0d2788ef4f2', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:16:18', '2026-08-04 06:16:01', 0),
('6e65f7c7-5f43-461b-b761-8800ef29476b', NULL, 'Project Approved', 'Project \"TEST G - INTIAL TRANSFER\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 11:47:19', '2026-08-04 23:58:59', 0),
('6e78a0ee-eb34-4957-a37d-7f58fc7de45a', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:11:23', '2026-08-03 09:13:44', 0),
('6f18effd-2ed9-4924-839f-8aa36b064744', NULL, 'Project Approved', 'Project \"TEST A\" has been approved.', 'project', 1, '2026-08-05 00:52:33', '2026-08-05 00:07:08', '2026-08-05 00:52:33', 0),
('70c6687e-1bfc-49c8-ac87-bbe783c0cb2c', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:18', '2026-08-03 09:13:44', 0),
('71f3cd73-675e-4d00-a31e-7e94eb3ffa2d', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:31:37', '2026-08-04 06:16:01', 0),
('72b323ca-a86e-4e54-b5df-d44dcdba9fdc', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:25:37', '2026-08-04 23:58:59', 0),
('72c42d98-a964-4d40-a87f-5dc9aeb5adcc', NULL, 'Project Approved', 'Project \"TEST A - START UP MONEY (WITH PROOFS)\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 10:49:15', '2026-08-04 23:58:59', 0),
('736d2d71-a2d9-4aaa-81ce-9b5dbfca5421', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:35:27', '2026-08-03 09:13:44', 0),
('73d01fe1-86fd-47f8-8b10-3e88418e8cd4', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST G - INTIAL TRANSFER\" in project \"TEST G - INTIAL TRANSFER\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:32', '2026-08-04 23:58:59', 0),
('76368d67-302a-4993-93a1-094b2bde2a6b', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST A\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:27:44', '2026-08-05 00:52:33', 0),
('77ed509f-c7e5-4593-b5ee-4c5c2afbf8d0', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:32:28', '2026-08-03 09:13:44', 0),
('78b0e9bf-f1d5-4195-8d04-0a7f2e674fc4', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:13', '2026-08-03 09:13:44', 0),
('78b52de9-7418-4059-a988-0ca710c9b57c', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST A\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:27:42', '2026-08-05 00:52:33', 0),
('78b95d62-ae62-4c43-b688-2921704d0d41', NULL, 'New Meeting Scheduled', 'A new meeting titled \'wow\' has been scheduled for July 31, 2026, 1:16 PM', 'meeting', 1, '2026-08-03 09:13:44', '2026-08-03 03:14:28', '2026-08-03 09:13:44', 0),
('78f3d02c-55a2-4c0b-847d-5a8b32b4f9ce', NULL, 'Project Approved', 'Project \"TEST A - START MONEY\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 03:43:32', '2026-08-04 06:16:01', 0),
('7a373d80-45c6-4845-9f04-b6560afa91d0', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:50:47', '2026-08-04 06:16:01', 0),
('7a52e7c2-526c-411e-9956-18d6bd20cfdb', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"sdfdsa\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:51:36', '2026-08-04 23:58:59', 0),
('7bcb2b40-9615-4e03-be57-01baf3c289ad', NULL, 'Project Approved', 'Project \"safsdf\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 12:31:51', '2026-08-04 23:58:59', 0),
('7cc565c6-ab98-4df8-b0a8-d70f30298ecf', NULL, 'Project Approved', 'Project \"h\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:05:36', '2026-07-27 02:08:37', 0),
('7d2ade05-4179-45fd-94b6-37a9df84c785', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"hi\"\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:26', '2026-08-03 09:13:44', 0),
('7dccf9ff-7802-4a74-8974-095d4d5996c9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:12:15', '2026-08-04 23:58:59', 0),
('7f40804d-439a-4ef1-acfd-e392114bd7ea', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A1\" in project \"TEST A - START MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:00:52', '2026-08-04 06:16:01', 0),
('7f4242c6-4ecf-43a3-8318-95bcc50ed463', NULL, 'Project Approved', 'Project \"qweert\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:40:35', '2026-08-03 09:13:44', 0),
('82775baa-fa43-44c2-9831-417c68b7746f', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:57', '2026-08-04 23:58:59', 0),
('829e30f1-3d00-4c8a-93e6-689a31c558b0', NULL, 'Project Approved', 'Project \"sfgdsg\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:06:01', '2026-08-04 23:58:59', 0),
('834e0830-0c59-4fc0-8e19-e61dc6c9cb24', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:04:35', '2026-08-03 09:13:44', 0),
('85c5312f-7611-4e9d-bd99-988d72d41e7b', NULL, 'Project Approved', 'Project \"qoqq\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:20:41', '2026-08-04 06:16:01', 0),
('86016520-2344-4279-97ef-f22bf4b685d6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:29', '2026-08-03 09:13:44', 0),
('8623b962-b6f7-46fb-ac64-22f6bf539d36', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"TEST G - INTIAL TRANSFER\"\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:35:29', '2026-08-04 23:58:59', 0),
('86ab746a-ff9d-4f99-a429-6850d8e7c00d', NULL, 'Meeting Updated', 'The meeting titled \'TEST J\' was updated for August 7, 2026, 10:51 AM', 'meeting', 1, '2026-08-05 00:52:33', '2026-08-05 00:50:01', '2026-08-05 00:52:33', 0),
('8796fcbe-c95a-4a35-aee8-40043986fef2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:21', '2026-08-03 09:13:44', 0),
('89df77be-0142-45f7-9f02-d99810ff46bc', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:34:10', '2026-08-04 06:16:01', 0),
('8a571654-f104-4e6b-b99c-3c10c88d95e5', NULL, 'Project Approved', 'Project \"MOENYYY\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 12:42:10', '2026-08-04 06:16:01', 0),
('8aa91e62-dd9b-408f-af30-3347dd8b8d35', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:24', '2026-08-05 00:52:33', 0),
('8b87da40-112c-4a89-88ef-47831caba71e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:13', '2026-08-03 09:13:44', 0),
('8bdb35da-c25d-4053-98c1-95cd07d5349e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-03 14:15:25', '2026-08-04 06:16:01', 0),
('8bf37ad4-4fd0-4b27-9108-d900edf36525', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:29', '2026-08-03 09:13:44', 0),
('8ddc6815-32c7-4686-9d03-57155520a0a8', NULL, 'Project Approved', 'Project \"testtt\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 12:22:54', '2026-08-04 06:16:01', 0),
('8ebb94be-4be1-4b6b-94de-43cb813fb9f6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"MONEYY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:50', '2026-08-03 09:13:44', 0),
('8fe8b8e5-ce1d-4891-86f9-1ea18c5ffa51', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"6\"\" in project \"3\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:37', '2026-08-03 09:13:44', 0),
('90c3314a-7181-4882-a982-2cd516f5e1ee', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:24', '2026-08-04 06:16:01', 0),
('90e779a0-3c7f-450d-8a41-d6ebb4cb1b9f', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:13', '2026-08-03 09:13:44', 0),
('90e9487e-65bd-4dbb-a2e4-6e4e3fb569e8', NULL, 'Project Approved', 'Project \"SADFSDA\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 06:02:18', '2026-08-04 06:16:01', 0),
('9112eee8-4627-4e1b-b6e1-e419b37231a6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:30', '2026-08-03 09:13:44', 0),
('916e82f2-4913-4e36-bc71-b13d34a1d3be', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:18', '2026-08-03 09:13:44', 0),
('92a6b15a-8f20-40a9-be66-8fde0b6c5f63', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST E\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:46:52', '2026-08-05 00:52:33', 0),
('9349cca7-203d-4a31-a096-15009a13ea0f', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"dsfgfdsgsd\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:49:39', '2026-08-04 23:58:59', 0),
('9516584e-0611-4482-abcb-b07f0fe33127', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:19:03', '2026-08-04 06:16:01', 0),
('974fc355-1c12-40de-8d72-99e8e29b3a70', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:23:50', '2026-08-04 06:16:01', 0),
('978318e9-6c95-4d7a-bb44-01cf0701b2a5', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:17:59', '2026-08-04 06:16:01', 0),
('97a40d8a-a58f-407b-bf9b-13c435a74ca8', NULL, 'Project Approved', 'Project \"aaaaaaa\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:05:00', '2026-07-27 02:08:37', 0),
('97b3b00a-6c89-41eb-99a7-a86fecadce1e', NULL, 'Project Approved', 'Project \"qweee\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:39:49', '2026-08-03 09:13:44', 0),
('993dd1de-2533-49c3-97b8-094e05fb5052', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:24', '2026-08-03 09:13:44', 0),
('9a257088-04cd-472c-bbae-985ed5330ca7', NULL, 'Project Approved', 'Project \"TEST C - INITIAL TRANSFER\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 03:58:01', '2026-08-04 06:16:01', 0),
('9b345f8c-58af-4403-a5a8-3b64669786f3', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST A\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:31:02', '2026-08-05 00:52:33', 0),
('9bc1f017-b640-4b90-a6c8-3d4cb0431e84', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:52', '2026-08-05 00:52:33', 0),
('9bc42710-8cbb-474c-a3e9-bde34ce8751f', NULL, 'Project Approved', 'Project \"qqqqqq\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:06:05', '2026-07-27 02:08:37', 0),
('9bcce144-0902-45a5-ae2e-4155ecb0efb7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 03:40:44', '2026-08-04 06:16:01', 0),
('9c158d37-2343-495a-a611-480af3ad473d', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:11', '2026-08-04 06:16:01', 0),
('9c831018-11a2-4d9d-881f-e4d4820875d9', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:28:30', '2026-08-04 06:16:01', 0),
('9eeb8768-3c0c-4394-9836-11334cfb5516', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:32:49', '2026-08-04 06:16:01', 0),
('9ef5b4cb-a246-491e-8e43-a4207b824ec5', NULL, 'Project Approved', 'Project \"UPLOAD\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 09:31:18', '2026-08-04 06:16:01', 0),
('a015ea8a-7740-4881-b5f3-a49c347f598d', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:28:22', '2026-08-03 09:13:44', 0),
('a067fca0-85fa-44b9-a8ff-caf1c109d525', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C1\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:47', '2026-08-05 00:52:33', 0),
('a0ef13c8-bebf-44bf-acdd-74b2cf208fa8', NULL, 'Project Approved', 'Project \"test2\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:42:56', '2026-08-03 09:13:44', 0),
('a122c480-588d-49e0-bcfe-55652a09a7c2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:26', '2026-08-03 09:13:44', 0),
('a1616fd4-3146-46c8-99b4-c47b24d0dbe2', NULL, 'Project Approved', 'Project \"TEST G - PROJECT INITIAL TRANSFER\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 03:01:02', '2026-08-04 06:16:01', 0),
('a1fc453f-da95-4b30-8668-6e235e3d7b85', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" in project \"TEST C - INITIAL TRANSFER\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:01:09', '2026-08-04 06:16:01', 0),
('a287955b-4f0e-45a8-91d1-50599c071e02', NULL, 'Project Approved', 'Project \"Hingi\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:47:18', '2026-08-03 09:13:44', 0),
('a2e47db4-d442-48ee-9e18-d0a4825b3142', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:24:31', '2026-08-04 23:58:59', 0),
('a31ccf1b-37b4-4f50-a767-6c3e37862731', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST A - START UP MONEY\"\" in project \"TEST B\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:08', '2026-08-04 06:16:01', 0),
('a390d36a-bf80-4871-bbdf-75e4e282abb9', NULL, 'Project Approved', 'Project \"dfgds\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 14:09:14', '2026-08-04 23:58:59', 0),
('a5532c61-99a4-45a9-a7d7-9c08f5ac3473', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 03:38:06', '2026-08-04 06:16:01', 0),
('a55eacac-93c0-4770-974f-48bd23d0eeeb', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:12:33', '2026-08-04 23:58:59', 0),
('a5872754-1672-4edf-b4fc-ed8d7d7d63f6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:50:54', '2026-08-04 06:16:01', 0),
('a6c5e9db-c6b4-410a-a1ea-de57f64e0c79', NULL, 'Project Approved', 'Project \"TEST B - INITIAL TRANSFER\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 03:49:07', '2026-08-04 06:16:01', 0),
('a7a4842b-389a-4f1c-9e1e-82de7bf7dc62', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:26:43', '2026-08-04 06:16:01', 0),
('a7fc0b9c-ad9f-4e71-8757-5c40a92abed6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:31:30', '2026-08-04 06:16:01', 0),
('a934e89f-8f4d-4df7-a4bd-c73bd9b09cb9', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:46:41', '2026-08-03 09:13:44', 0),
('a95bf204-51f1-403c-b30e-b0e98e351a12', NULL, 'Project Approved', 'Project \"sdfdsa\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:52:38', '2026-08-04 23:58:59', 0),
('ac4bd50d-6764-4271-aa2a-d4ce0cb29ae5', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:28:45', '2026-08-04 06:16:01', 0),
('ae1869a1-c265-40f9-9645-8b4bcc31bb86', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:23:07', '2026-08-03 09:13:44', 0);
INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `read_at`, `created_at`, `updated_at`, `archive`) VALUES
('ae693e68-ee00-4e44-848f-52c245c62b1e', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:26', '2026-08-03 09:13:44', 0),
('af76151e-8c1d-4d2e-aabe-488ef9f54eb1', NULL, 'Project Approved', 'Project \"errr\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:08:21', '2026-08-04 06:16:01', 0),
('b0c7a21e-c3b7-46ff-825b-11c05e887f4b', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST E\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:47:16', '2026-08-05 00:52:33', 0),
('b0d6250d-cc21-4c14-a32c-66ef0c938e14', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:50:40', '2026-08-04 06:16:01', 0),
('b0e942cb-a8e7-4365-9bd2-65da44cb0f2f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:10', '2026-08-03 09:13:44', 0),
('b1613224-a5c6-47c3-a7a1-72b7a27e35b8', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:35', '2026-08-05 00:52:33', 0),
('b1cab41d-dfa7-4096-9a8b-064974facb67', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:23', '2026-08-03 09:13:44', 0),
('b2723076-aed1-432d-b5ea-30297bb17a15', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:17', '2026-08-03 09:13:44', 0),
('b3e89ddf-ead7-4a67-bc37-96e9ef71fc80', NULL, 'Meeting Updated', 'The meeting titled \'wow\' was updated for July 31, 2026, 1:16 PM', 'meeting', 1, '2026-08-04 23:58:59', '2026-08-04 14:33:27', '2026-08-04 23:58:59', 0),
('b46457df-a9ae-48c5-9963-439339b69b51', NULL, 'Project Approved', 'Project \"uuuuuuuuuu\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 13:19:40', '2026-08-04 06:16:01', 0),
('b4929146-01b5-4913-86af-d1cab7c4fa38', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:53:54', '2026-08-03 09:13:44', 0),
('b4a00878-3879-4e2b-ad90-22fb0ebaeac5', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:09', '2026-08-03 09:13:44', 0),
('b6953002-ed94-45e4-a562-550956886d6f', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:12', '2026-08-04 23:58:59', 0),
('b6a2c00f-3bb5-45b0-bcab-a14b8fd37731', NULL, 'New Meeting Scheduled', 'A new meeting titled \'TEST J\' has been scheduled for August 7, 2026, 10:51 AM', 'meeting', 1, '2026-08-05 00:52:33', '2026-08-05 00:49:30', '2026-08-05 00:52:33', 0),
('b86c8916-629f-4102-a187-04bd0f2ac681', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"sdafsd\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:23:13', '2026-08-04 23:58:59', 0),
('b87bd253-dc78-4614-bcc7-59af2ed0a515', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:41', '2026-08-03 09:13:44', 0),
('b94ce305-f736-41b5-bf3d-a2ace5d6c38f', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:24', '2026-08-05 00:52:33', 0),
('b9582ac5-6c5f-4ad6-bb5f-7547b4ea2bdb', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:27:39', '2026-08-03 09:13:44', 0),
('b9ff62b5-8f39-4fb1-a495-25c84384b929', NULL, 'Project Approved', 'Project \"tttttttttttttt\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:42:39', '2026-07-27 02:08:37', 0),
('bb2a5258-79f3-4667-9f46-b4831f4c2b60', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 00:44:30', '2026-08-03 09:13:44', 0),
('bc740666-e3f5-48c9-8058-b47ef14fbbc4', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:19:36', '2026-08-04 06:16:01', 0),
('bccdf98b-ef7d-4f7b-a521-dfd9898d047c', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"TEST A\" has been approved.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:32:23', '2026-08-05 00:52:33', 0),
('bd0666b0-013d-4f79-a483-be080dff9e92', NULL, 'Project Approved', 'Project \"wqerwqe\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 05:57:21', '2026-08-04 06:16:01', 0),
('bdd68846-53ef-4e56-972c-c303b958fd62', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:53:50', '2026-08-03 09:13:44', 0),
('be07f7e0-d8e6-4bc1-8e70-154c8a011aea', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A - START UP MONEY\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:16', '2026-08-04 06:16:01', 0),
('be4bb7c4-3541-4fb9-ae83-6ec5edf62217', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 10:29:12', '2026-08-03 09:13:44', 0),
('be8d6e05-0758-4c15-95ec-15908e98fe45', NULL, 'Project Approved', 'Project \"dddddddddd\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:14:25', '2026-08-03 09:13:44', 0),
('beef9a49-757c-4002-b609-6e11a451bba5', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"TEST B\"\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:00:07', '2026-08-04 06:16:01', 0),
('bf6ee14f-7d70-4150-a85b-a1fb3dab5715', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A2\" in project \"TEST A - START MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:00:58', '2026-08-04 06:16:01', 0),
('bfcc245b-7360-48a8-9f9e-562e9a2f360c', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST A\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:27:51', '2026-08-05 00:52:33', 0),
('c043dba2-21ac-4c5b-8b27-0a7efe02490e', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Entry Approved', 'Ledger entry for project \"dfgds\" has been approved.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 14:10:32', '2026-08-04 23:58:59', 0),
('c08b644b-197f-406f-91ac-6a4563faf40a', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"dfgsdfs\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:01:12', '2026-08-04 23:58:59', 0),
('c24a7ef0-6f72-49da-a8e7-f2248d1d9f30', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:19', '2026-08-03 09:13:44', 0),
('c4bbd58e-f78d-4edd-9133-210b1ceab3a9', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"sfgdsg\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:05:43', '2026-08-04 23:58:59', 0),
('c5bc4822-e4e8-4b43-86c0-53e4f5f4800e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-03 14:34:22', '2026-08-04 06:16:01', 0),
('c5f6257c-86d8-43dd-83a5-eaa213759e92', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:18:08', '2026-08-04 06:16:01', 0),
('c622772a-7163-4f03-b5f2-9874b8ef0fec', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:28:38', '2026-08-03 09:13:44', 0),
('c6ed9b2a-555c-4525-bed1-48bfbf842cfd', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 06:13:07', '2026-08-04 06:16:01', 0),
('c6f62d84-f093-421a-8008-2b4538f47e81', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B - LEDGER ENTRY\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:12:28', '2026-08-04 23:58:59', 0),
('ca52e7c1-9158-46c0-bb4a-3f370c131bba', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" for project \"TEST A\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:30', '2026-08-05 00:52:33', 0),
('cb0f42ce-4260-40b4-9a4f-0b969fa357d7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:41:32', '2026-08-03 09:13:44', 0),
('cb5065cc-2a6b-4f11-90e1-2490bb6c5022', NULL, 'Project Approved', 'Project \"6\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:08:46', '2026-07-27 02:08:37', 0),
('cb8cd436-b8d0-462c-9b83-2f6fb537c0c2', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:18:04', '2026-08-04 06:16:01', 0),
('cc0b6d8b-53db-485c-99db-b25fe79ec9c5', NULL, 'Project Approved', 'Project \"11\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:37:13', '2026-07-27 02:08:37', 0),
('cccff49b-16f8-4975-853f-2d8c2d12e6cf', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 14:25:47', '2026-08-04 06:16:01', 0),
('cde97799-e329-4cc5-97f8-87bca9ce8172', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST B\" in project \"TEST B\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:11:25', '2026-08-04 06:16:01', 0),
('cef542f5-eeb3-49ad-ae85-688cc1407a43', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"TEST E\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:46:57', '2026-08-05 00:52:33', 0),
('d0b1e7b6-22e8-4e02-be26-21ae11571372', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"dfgds\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 14:08:58', '2026-08-04 23:58:59', 0),
('d0b8f550-1f99-4235-87be-c61b2b10a974', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:28:58', '2026-08-04 06:16:01', 0),
('d3607e1a-7ca7-4025-9ed6-77a0cdda610e', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"TEST E\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-05 00:52:33', '2026-08-05 00:44:03', '2026-08-05 00:52:33', 0),
('d419aeb3-2e2d-4577-b20a-fa6ff96cebd9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:20:10', '2026-08-03 09:13:44', 0),
('d51f1483-96c3-4991-a5c7-ed3c6f237798', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:19', '2026-08-03 09:13:44', 0),
('d581d275-4465-4780-82a0-61bcaa3bda5a', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 10:58:13', '2026-08-04 23:58:59', 0),
('d6c437a1-c989-4777-a0ab-3b976cceece2', NULL, 'Project Approved', 'Project \"MANEY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:32:50', '2026-08-03 09:13:44', 0),
('d8306ee6-abb6-494a-9e01-9fa34704be16', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 03:08:19', '2026-08-03 09:13:44', 0),
('d8acb13a-9ac5-40a9-8427-a11e2be599cc', NULL, 'Project Budget Synced from Ledger', 'Synchronized 3 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:12', '2026-08-03 09:13:44', 0),
('d9ca93f6-1682-41d8-a379-482fbef813eb', NULL, 'Project Approved', 'Project \"runnnnnnnn\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 01:32:58', '2026-08-03 09:13:44', 0),
('da4b9b37-66f5-4823-8e55-c71baab745c2', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:30', '2026-08-05 00:52:33', 0),
('daf5382d-5928-4e72-aafc-431251e5918f', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:01:40', '2026-08-03 09:13:44', 0),
('dbb877b6-6a34-456d-9a66-87fb5bc78cac', NULL, 'Project Approved', 'Project \"1\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:56:00', '2026-07-27 02:08:37', 0),
('dbcf5608-c497-44e0-bfc1-042c4c7202b0', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:40', '2026-08-05 00:52:33', 0),
('dcceded4-8859-4efc-9373-ff789b840344', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:15:44', '2026-08-04 06:16:01', 0),
('dd016282-f6f5-4bc3-8a27-7a393f13aa42', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:15', '2026-08-03 09:13:44', 0),
('e17f97e7-f327-4f61-a7ad-906ce3066496', NULL, 'Project Approved', 'Project \"3\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:59:20', '2026-07-27 02:08:37', 0),
('e18b6042-0110-48aa-93e2-0d645de51d10', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"TEST G - INTIAL TRANSFER\"\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:49:20', '2026-08-04 23:58:59', 0),
('e272d42f-6c9b-4c3b-b853-9ce40cf7af8c', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Ledger entry submitted for approval', 'Ledger entry for project \"dfgds\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 14:10:24', '2026-08-04 23:58:59', 0),
('e3badef0-f583-4b82-97bc-985ca58140e9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:44:08', '2026-08-03 09:13:44', 0),
('e3eb6677-662f-4801-b622-16767807da3e', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Date Change Request Approved', 'Your date change request for project \"TEST A\" has been approved.', 'date_change', 1, '2026-08-05 00:52:33', '2026-08-05 00:08:09', '2026-08-05 00:52:33', 0),
('e3f38fd1-6121-42c5-917d-8852312cc5df', NULL, 'Project Approved', 'Project \"testttt\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:38:42', '2026-08-03 09:13:44', 0),
('e464fd4f-11aa-44ee-98a6-e73188bc45af', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:08:34', '2026-08-03 09:13:44', 0),
('e6f9f51c-e5bf-4aa5-83be-3ba7ad13f26b', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 04:34:01', '2026-08-04 06:16:01', 0),
('e7d81340-9623-4708-a79b-0970d8743202', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:41:48', '2026-08-03 09:13:44', 0),
('e88012e9-1e56-4a1f-9bd5-7b64a5de4f50', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"sdfgds\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:25:13', '2026-08-04 23:58:59', 0),
('ed8f1506-31b8-428e-8a32-04c070e2b651', NULL, 'Project Approved', 'Project \"4\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:01:04', '2026-07-27 02:08:37', 0),
('efa154b9-1b71-45f1-89eb-0c52709395b9', NULL, 'Project Approved', 'Project \"TESTb\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-03 13:26:39', '2026-08-04 06:16:01', 0),
('f0273b75-131d-4a95-bd58-c8bff45f9d09', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:32', '2026-08-03 09:13:44', 0),
('f246670d-172a-491e-9f9e-548df8d3e5b8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:24', '2026-08-03 09:13:44', 0),
('f256c0e7-1a64-43c3-b542-9eec18fbebe3', NULL, 'Project Approved', 'Project \"sdafsd\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 13:23:23', '2026-08-04 23:58:59', 0),
('f3258a42-dbd9-4ef5-9d45-75fa49efd20b', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:10:01', '2026-08-04 06:16:01', 0),
('f37e0866-3aae-41fd-9a2e-d77d47459120', NULL, 'Project Approved', 'Project \"dfgsdfs\" has been approved.', 'project', 1, '2026-08-04 23:58:59', '2026-08-04 11:00:02', '2026-08-04 23:58:59', 0),
('f3840922-b909-45a1-bd4d-e5a2bb3f712a', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:09:54', '2026-08-03 09:13:44', 0),
('f39e585d-9b89-4b80-aa12-1f7b3f0cbfbc', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST C1\" in project \"TEST A\" was restored by LARENCE jhgjgh.', 'ledger', 1, '2026-08-05 00:52:33', '2026-08-05 00:35:47', '2026-08-05 00:52:33', 0),
('f3f4356e-7b5c-4ff1-84af-749a61dc603d', NULL, 'Project Approved', 'Project \"asfasd\" has been approved.', 'project', 1, '2026-08-04 06:16:01', '2026-08-04 05:53:28', '2026-08-04 06:16:01', 0),
('f40c0f78-45e4-4029-8b8c-5caf27087992', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:48:36', '2026-08-03 09:13:44', 0),
('f4a06818-c30d-4a83-8f2a-71084f667ca7', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:10:51', '2026-08-03 09:13:44', 0),
('f5e467a0-4d6a-4da4-aab3-0d1ac92928ba', NULL, 'Project Approved', 'Project \"qwerrty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:31:38', '2026-08-03 09:13:44', 0),
('f5ee309d-d381-4517-af20-a5972e001bae', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:00:45', '2026-08-04 06:16:01', 0),
('f68813ca-3561-44f1-81f0-4a2341149e5c', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:44', '2026-08-03 09:13:44', 0),
('f767238a-baf5-412b-9976-40c4ab33e157', '31fcedfb-f507-44bd-ad89-336c55539fea', 'Project submitted for approval', 'Your project \"TEST A\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-05 00:52:33', '2026-08-05 00:06:20', '2026-08-05 00:52:33', 0),
('f917945a-d454-424d-821a-ece203c27702', NULL, 'New Meeting Scheduled', 'A new meeting titled \'asdas\' has been scheduled for August 8, 2026, 12:47 PM', 'meeting', 1, '2026-08-04 23:58:59', '2026-08-04 14:45:49', '2026-08-04 23:58:59', 0),
('fa2b8b96-2705-4180-98f9-f992189ec3a8', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"1234\"\" in project \"Hingi\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:34:48', '2026-08-03 09:13:44', 0),
('fbded78f-b9a2-4863-8951-5f1a130710ec', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:23', '2026-08-03 09:13:44', 0),
('fc73eb2a-5c42-4f9d-878d-a983d3c2057d', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 10:57:58', '2026-08-04 23:58:59', 0),
('fd5bebc2-7dc9-45bb-87b8-147eb5a71eee', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"TEST A\" in project \"TEST A\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 06:16:01', '2026-08-04 05:28:23', '2026-08-04 06:16:01', 0),
('fe1862ed-5530-4671-94bb-62929a2585f9', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST A - START UP MONEY (WITH PROOFS)\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-04 23:58:59', '2026-08-04 11:12:22', '2026-08-04 23:58:59', 0),
('feccd99f-be19-4bd7-be95-d28333005f8a', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:35:21', '2026-08-03 09:13:44', 0),
('ff31af7f-3ea8-456c-b49e-6991b554d454', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:14', '2026-08-03 09:13:44', 0),
('ff531b79-da83-4e4d-bccd-6b170efe9d04', NULL, 'Project Approved', 'Project \"vvvv\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 01:58:23', '2026-07-27 02:08:37', 0),
('ffb214cd-2c7b-4291-9deb-301f4ec9aab5', NULL, 'Project Approved', 'Project \"SPIDERRR\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 00:49:46', '2026-08-03 09:13:44', 0);

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
('a1b10043-0000-4000-8000-000000000043', 'System Settings', 'logs', 'system-settings.logs', 'Logs access for System Settings', '2026-08-05 00:00:00', '2026-08-05 00:00:00', 0);

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
('d01968a8-3a78-449a-959d-b50575c9351f', NULL, 'TEST A', 'TEST A', 'TEST A1', 'Sports', 500.00, 1, 'TEST A', 'Draft', 'TEST A', 'TEST A', 'storage/ledger_proofs/bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053.pdf', 'bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053', '2026-06-01', '2026-06-17', '6373498c-903e-43a9-bb1d-b67a496aee24', 'Approved', '2026-08-05 00:07:08', '2026-08-05 00:05:08', '2026-08-05 00:44:43', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', 0),
('d473b3b9-28bc-4ed0-911d-5b7cdee90b60', NULL, 'TEST E', 'TEST E', 'TEST E1', 'Environmental', 100.00, 0, 'TEST E1', 'Draft', 'TEST E', 'TEST F', 'storage/ledger_proofs/bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053.pdf', 'bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053', '2026-08-26', '2026-09-02', '6373498c-903e-43a9-bb1d-b67a496aee24', 'Approved', '2026-08-05 00:44:43', '2026-08-05 00:42:43', '2026-08-05 00:47:16', '31fcedfb-f507-44bd-ad89-336c55539fea', '6373498c-903e-43a9-bb1d-b67a496aee24', 0);

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
('0c81e945-056c-40a0-82ad-7a8fe138b3fb', 'd473b3b9-28bc-4ed0-911d-5b7cdee90b60', '31fcedfb-f507-44bd-ad89-336c55539fea', 3, 2, 1, 'TEST L', 0, '2026-08-05 00:54:46', 0),
('2f8e8d5c-e771-46cb-b6ef-0a5eabc8e9e7', 'd01968a8-3a78-449a-959d-b50575c9351f', '31fcedfb-f507-44bd-ad89-336c55539fea', 5, 4, 2, 'TEST L', 0, '2026-08-05 00:53:33', 0);

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

INSERT INTO `role_permission` (`id`, `user_id`, `role_id`, `permission_id`, `created_at`) VALUES
('b2c20001-0000-4000-8000-000000000001', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20002-0000-4000-8000-000000000002', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '2026-08-05 00:00:00'),
('b2c20003-0000-4000-8000-000000000003', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '2026-08-05 00:00:00'),
('b2c20004-0000-4000-8000-000000000004', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '2026-08-05 00:00:00'),
('b2c20005-0000-4000-8000-000000000005', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', '2026-08-05 00:00:00'),
('b2c20006-0000-4000-8000-000000000006', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', '2026-08-05 00:00:00'),
('b2c20007-0000-4000-8000-000000000007', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '2026-08-05 00:00:00'),
('b2c20008-0000-4000-8000-000000000008', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '2026-08-05 00:00:00'),
('b2c20009-0000-4000-8000-000000000009', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '2026-08-05 00:00:00'),
('b2c20010-0000-4000-8000-000000000010', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10010-0000-4000-8000-000000000010', '2026-08-05 00:00:00'),
('b2c20011-0000-4000-8000-000000000011', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', '2026-08-05 00:00:00'),
('b2c20012-0000-4000-8000-000000000012', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '2026-08-05 00:00:00'),
('b2c20013-0000-4000-8000-000000000013', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '2026-08-05 00:00:00'),
('b2c20014-0000-4000-8000-000000000014', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10014-0000-4000-8000-000000000014', '2026-08-05 00:00:00'),
('b2c20015-0000-4000-8000-000000000015', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10015-0000-4000-8000-000000000015', '2026-08-05 00:00:00'),
('b2c20016-0000-4000-8000-000000000016', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10016-0000-4000-8000-000000000016', '2026-08-05 00:00:00'),
('b2c20017-0000-4000-8000-000000000017', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10017-0000-4000-8000-000000000017', '2026-08-05 00:00:00'),
('b2c20018-0000-4000-8000-000000000018', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20019-0000-4000-8000-000000000019', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '2026-08-05 00:00:00'),
('b2c20020-0000-4000-8000-000000000020', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '2026-08-05 00:00:00'),
('b2c20021-0000-4000-8000-000000000021', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10021-0000-4000-8000-000000000021', '2026-08-05 00:00:00'),
('b2c20022-0000-4000-8000-000000000022', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10022-0000-4000-8000-000000000022', '2026-08-05 00:00:00'),
('b2c20023-0000-4000-8000-000000000023', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10023-0000-4000-8000-000000000023', '2026-08-05 00:00:00'),
('b2c20024-0000-4000-8000-000000000024', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20025-0000-4000-8000-000000000025', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', '2026-08-05 00:00:00'),
('b2c20026-0000-4000-8000-000000000026', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10026-0000-4000-8000-000000000026', '2026-08-05 00:00:00'),
('b2c20027-0000-4000-8000-000000000027', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10027-0000-4000-8000-000000000027', '2026-08-05 00:00:00'),
('b2c20028-0000-4000-8000-000000000028', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00'),
('b2c20029-0000-4000-8000-000000000029', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10029-0000-4000-8000-000000000029', '2026-08-05 00:00:00'),
('b2c20030-0000-4000-8000-000000000030', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10030-0000-4000-8000-000000000030', '2026-08-05 00:00:00'),
('b2c20031-0000-4000-8000-000000000031', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10031-0000-4000-8000-000000000031', '2026-08-05 00:00:00'),
('b2c20032-0000-4000-8000-000000000032', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10032-0000-4000-8000-000000000032', '2026-08-05 00:00:00'),
('b2c20033-0000-4000-8000-000000000033', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10033-0000-4000-8000-000000000033', '2026-08-05 00:00:00'),
('b2c20034-0000-4000-8000-000000000034', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10034-0000-4000-8000-000000000034', '2026-08-05 00:00:00'),
('b2c20035-0000-4000-8000-000000000035', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10035-0000-4000-8000-000000000035', '2026-08-05 00:00:00'),
('b2c20036-0000-4000-8000-000000000036', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', '2026-08-05 00:00:00'),
('b2c20037-0000-4000-8000-000000000037', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10037-0000-4000-8000-000000000037', '2026-08-05 00:00:00'),
('b2c20038-0000-4000-8000-000000000038', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10038-0000-4000-8000-000000000038', '2026-08-05 00:00:00'),
('b2c20039-0000-4000-8000-000000000039', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10039-0000-4000-8000-000000000039', '2026-08-05 00:00:00'),
('b2c20040-0000-4000-8000-000000000040', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10040-0000-4000-8000-000000000040', '2026-08-05 00:00:00'),
('b2c20041-0000-4000-8000-000000000041', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10041-0000-4000-8000-000000000041', '2026-08-05 00:00:00'),
('b2c20042-0000-4000-8000-000000000042', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10042-0000-4000-8000-000000000042', '2026-08-05 00:00:00'),
('b2c20043-0000-4000-8000-000000000043', NULL, '059ef3f9-235d-11f1-9647-10683825ce81', 'a1b10043-0000-4000-8000-000000000043', '2026-08-05 00:00:00'),
('b2c20044-0000-4000-8000-000000000044', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20045-0000-4000-8000-000000000045', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', '2026-08-05 00:00:00'),
('b2c20046-0000-4000-8000-000000000046', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', '2026-08-05 00:00:00'),
('b2c20047-0000-4000-8000-000000000047', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '2026-08-05 00:00:00'),
('b2c20048-0000-4000-8000-000000000048', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', '2026-08-05 00:00:00'),
('b2c20049-0000-4000-8000-000000000049', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '2026-08-05 00:00:00'),
('b2c20050-0000-4000-8000-000000000050', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10016-0000-4000-8000-000000000016', '2026-08-05 00:00:00'),
('b2c20051-0000-4000-8000-000000000051', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10017-0000-4000-8000-000000000017', '2026-08-05 00:00:00'),
('b2c20052-0000-4000-8000-000000000052', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20053-0000-4000-8000-000000000053', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10023-0000-4000-8000-000000000023', '2026-08-05 00:00:00'),
('b2c20054-0000-4000-8000-000000000054', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20055-0000-4000-8000-000000000055', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10026-0000-4000-8000-000000000026', '2026-08-05 00:00:00'),
('b2c20056-0000-4000-8000-000000000056', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10027-0000-4000-8000-000000000027', '2026-08-05 00:00:00'),
('b2c20057-0000-4000-8000-000000000057', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00'),
('b2c20058-0000-4000-8000-000000000058', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10029-0000-4000-8000-000000000029', '2026-08-05 00:00:00'),
('b2c20059-0000-4000-8000-000000000059', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10031-0000-4000-8000-000000000031', '2026-08-05 00:00:00'),
('b2c20060-0000-4000-8000-000000000060', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', '2026-08-05 00:00:00'),
('b2c20061-0000-4000-8000-000000000061', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10038-0000-4000-8000-000000000038', '2026-08-05 00:00:00'),
('b2c20062-0000-4000-8000-000000000062', NULL, '059ef712-235d-11f1-9647-10683825ce81', 'a1b10040-0000-4000-8000-000000000040', '2026-08-05 00:00:00'),
('b2c20063-0000-4000-8000-000000000063', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20064-0000-4000-8000-000000000064', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10005-0000-4000-8000-000000000005', '2026-08-05 00:00:00'),
('b2c20065-0000-4000-8000-000000000065', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '2026-08-05 00:00:00'),
('b2c20066-0000-4000-8000-000000000066', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10011-0000-4000-8000-000000000011', '2026-08-05 00:00:00'),
('b2c20067-0000-4000-8000-000000000067', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '2026-08-05 00:00:00'),
('b2c20068-0000-4000-8000-000000000068', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10016-0000-4000-8000-000000000016', '2026-08-05 00:00:00'),
('b2c20069-0000-4000-8000-000000000069', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10017-0000-4000-8000-000000000017', '2026-08-05 00:00:00'),
('b2c20070-0000-4000-8000-000000000070', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20071-0000-4000-8000-000000000071', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10023-0000-4000-8000-000000000023', '2026-08-05 00:00:00'),
('b2c20072-0000-4000-8000-000000000072', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20073-0000-4000-8000-000000000073', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10026-0000-4000-8000-000000000026', '2026-08-05 00:00:00'),
('b2c20074-0000-4000-8000-000000000074', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10027-0000-4000-8000-000000000027', '2026-08-05 00:00:00'),
('b2c20075-0000-4000-8000-000000000075', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00'),
('b2c20076-0000-4000-8000-000000000076', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10029-0000-4000-8000-000000000029', '2026-08-05 00:00:00'),
('b2c20077-0000-4000-8000-000000000077', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10030-0000-4000-8000-000000000030', '2026-08-05 00:00:00'),
('b2c20078-0000-4000-8000-000000000078', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10031-0000-4000-8000-000000000031', '2026-08-05 00:00:00'),
('b2c20079-0000-4000-8000-000000000079', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10032-0000-4000-8000-000000000032', '2026-08-05 00:00:00'),
('b2c20080-0000-4000-8000-000000000080', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10033-0000-4000-8000-000000000033', '2026-08-05 00:00:00'),
('b2c20081-0000-4000-8000-000000000081', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10034-0000-4000-8000-000000000034', '2026-08-05 00:00:00'),
('b2c20082-0000-4000-8000-000000000082', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', '2026-08-05 00:00:00'),
('b2c20083-0000-4000-8000-000000000083', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10038-0000-4000-8000-000000000038', '2026-08-05 00:00:00'),
('b2c20084-0000-4000-8000-000000000084', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10039-0000-4000-8000-000000000039', '2026-08-05 00:00:00'),
('b2c20085-0000-4000-8000-000000000085', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10040-0000-4000-8000-000000000040', '2026-08-05 00:00:00'),
('b2c20086-0000-4000-8000-000000000086', NULL, '059f5000-235d-11f1-9647-10683825ce81', 'a1b10043-0000-4000-8000-000000000043', '2026-08-05 00:00:00'),
('b2c20087-0000-4000-8000-000000000087', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20088-0000-4000-8000-000000000088', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10002-0000-4000-8000-000000000002', '2026-08-05 00:00:00'),
('b2c20089-0000-4000-8000-000000000089', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10003-0000-4000-8000-000000000003', '2026-08-05 00:00:00'),
('b2c20090-0000-4000-8000-000000000090', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10004-0000-4000-8000-000000000004', '2026-08-05 00:00:00'),
('b2c20091-0000-4000-8000-000000000091', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10007-0000-4000-8000-000000000007', '2026-08-05 00:00:00'),
('b2c20092-0000-4000-8000-000000000092', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10008-0000-4000-8000-000000000008', '2026-08-05 00:00:00'),
('b2c20093-0000-4000-8000-000000000093', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10009-0000-4000-8000-000000000009', '2026-08-05 00:00:00'),
('b2c20094-0000-4000-8000-000000000094', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10012-0000-4000-8000-000000000012', '2026-08-05 00:00:00'),
('b2c20095-0000-4000-8000-000000000095', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10013-0000-4000-8000-000000000013', '2026-08-05 00:00:00'),
('b2c20096-0000-4000-8000-000000000096', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10014-0000-4000-8000-000000000014', '2026-08-05 00:00:00'),
('b2c20097-0000-4000-8000-000000000097', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10015-0000-4000-8000-000000000015', '2026-08-05 00:00:00'),
('b2c20098-0000-4000-8000-000000000098', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20099-0000-4000-8000-000000000099', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10019-0000-4000-8000-000000000019', '2026-08-05 00:00:00'),
('b2c20100-0000-4000-8000-000000000100', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10020-0000-4000-8000-000000000020', '2026-08-05 00:00:00'),
('b2c20101-0000-4000-8000-000000000101', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10022-0000-4000-8000-000000000022', '2026-08-05 00:00:00'),
('b2c20102-0000-4000-8000-000000000102', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20103-0000-4000-8000-000000000103', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', '2026-08-05 00:00:00'),
('b2c20104-0000-4000-8000-000000000104', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00'),
('b2c20105-0000-4000-8000-000000000105', NULL, '059efde1-235d-11f1-9647-10683825ce81', 'a1b10036-0000-4000-8000-000000000036', '2026-08-05 00:00:00'),
('b2c20106-0000-4000-8000-000000000106', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20107-0000-4000-8000-000000000107', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', '2026-08-05 00:00:00'),
('b2c20108-0000-4000-8000-000000000108', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20109-0000-4000-8000-000000000109', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20110-0000-4000-8000-000000000110', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', '2026-08-05 00:00:00'),
('b2c20111-0000-4000-8000-000000000111', NULL, '059f4170-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00'),
('b2c20112-0000-4000-8000-000000000112', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10001-0000-4000-8000-000000000001', '2026-08-05 00:00:00'),
('b2c20113-0000-4000-8000-000000000113', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10006-0000-4000-8000-000000000006', '2026-08-05 00:00:00'),
('b2c20114-0000-4000-8000-000000000114', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10018-0000-4000-8000-000000000018', '2026-08-05 00:00:00'),
('b2c20115-0000-4000-8000-000000000115', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10024-0000-4000-8000-000000000024', '2026-08-05 00:00:00'),
('b2c20116-0000-4000-8000-000000000116', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10025-0000-4000-8000-000000000025', '2026-08-05 00:00:00'),
('b2c20117-0000-4000-8000-000000000117', NULL, '059f4213-235d-11f1-9647-10683825ce81', 'a1b10028-0000-4000-8000-000000000028', '2026-08-05 00:00:00');


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
('cHdYl657AU1kgaoW07FcX47MAZCkjPUejbBfvZl3', '31fcedfb-f507-44bd-ad89-336c55539fea', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiRDZ6eWQ2RXBDb3VLcWlsUFp2VFJ6dVQyMzVPQWdoSjN5ejBMVlVseiI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyNjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3VzZXIiO31zOjk6Il9wcmV2aW91cyI7YToyOntzOjM6InVybCI7czo3MjoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL3VzZXIvcHJvamVjdHMvZDQ3M2IzYjktMjhiYy00ZWQwLTkxMWQtNWI3Y2RlZTkwYjYwIjtzOjU6InJvdXRlIjtzOjIwOiJ1c2VyLnByb2plY3QtZGV0YWlscyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtzOjM2OiIzMWZjZWRmYi1mNTA3LTQ0YmQtYWQ4OS0zMzZjNTU1MzlmZWEiO30=', 1785866086, 1),
('JxKgO8CUamFyldUsxUHklnFlONWlB3Umq1vkFhhM', '6373498c-903e-43a9-bb1d-b67a496aee24', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiZG5zN3pVZjBObWFyeThWQjlETktNR2s4WlRMZ0Q3bEhLYXZYY3ZvRCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NjM6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZHZpc2VyL3JvbGUtcGVybWlzc2lvbnMvZ2V0LWNvdW5jaWwtdGVybSI7czo1OiJyb3V0ZSI7czo0MToiYWR2aXNlci5yb2xlLXBlcm1pc3Npb25zLmdldC1jb3VuY2lsLXRlcm0iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjM6InVybCI7YToxOntzOjg6ImludGVuZGVkIjtzOjM1OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvY3NnL2Rhc2hib2FyZCI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtzOjM2OiI2MzczNDk4Yy05MDNlLTQzYTktYmIxZC1iNjdhNDk2YWVlMjQiO30=', 1785866128, 0),
('n2DDw8Aq8beB1Kr5XGRI6QF9lWe9ig6ZWRsnqIIm', '087ccbc9-efa8-44e0-8435-3310207554d7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoib0Z1VTcwODZaVENNOTNnZ1ZUWWIydnk1Um1HMnc5VEF6c3BMZUlLQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTQ6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZG1pbi9yb2xlLXBlcm1pc3Npb25zL3Bvc2l0aW9ucyI7czo1OiJyb3V0ZSI7czozMjoiYWRtaW4ucm9sZS1wZXJtaXNzaW9ucy5wb3NpdGlvbnMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiMDg3Y2NiYzktZWZhOC00NGUwLTg0MzUtMzMxMDIwNzU1NGQ3Ijt9', 1785863662, 0);

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
('11111', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-08-04 11:56:30', '2026-08-04 11:56:30', 0),
('111111111', NULL, '059d2612-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-08-04 12:03:28', '2026-08-04 12:03:28', 0),
('123', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, 'Member', '2026-05-13', '2026-05-30', 0, '2026-04-24 05:34:53', '2026-07-27 00:46:02', 0),
('12312', NULL, '059d226e-235d-11f1-9647-10683825ce81', 1, 'Vice President for External Affairs', '2026-05-28', '2026-09-18', 1, '2026-04-24 05:48:10', '2026-07-26 10:47:37', 0),
('123123', NULL, NULL, 0, NULL, NULL, NULL, 0, '2026-04-24 06:28:24', '2026-05-24 16:27:09', 0),
('33333333', '31fcedfb-f507-44bd-ad89-336c55539fea', '059d2571-235d-11f1-9647-10683825ce81', 0, 'Member', NULL, NULL, 0, '2026-08-04 12:23:02', '2026-08-05 00:52:57', 0),
('5555555', NULL, '059d226e-235d-11f1-9647-10683825ce81', 0, NULL, NULL, NULL, 1, '2026-08-04 23:46:13', '2026-08-04 23:46:13', 0),
('88888888', NULL, NULL, 0, NULL, NULL, NULL, 1, '2026-08-04 23:50:37', '2026-08-04 23:50:37', 0);

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
('123', '087ccbc9-efa8-44e0-8435-3310207554d7', '059bb388-235d-11f1-9647-10683825ce81', 1, '2026-04-24 06:30:43', '2026-05-31 11:46:27', 0),
('897987', '6373498c-903e-43a9-bb1d-b67a496aee24', '059bb3b0-235d-11f1-9647-10683825ce81', 1, '2026-08-04 23:52:28', '2026-08-05 00:04:21', 0);

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
('087ccbc9-efa8-44e0-8435-3310207554d7', '059ef3f9-235d-11f1-9647-10683825ce81', 'EDWARD QUINTOS', 'emdgquintos@kld.edu.ph', '2026-04-24 06:30:43', NULL, NULL, 0, '09234234234', '$2y$12$ez57d.qwWe0NGNJYtU0oDer2hVL6c2HIhbVWDHtQn.0kRBPeFNv6C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, NULL, 'active', '2026-08-04 23:44:17', NULL, '2026-04-24 06:30:08', '2026-08-04 16:44:49', 0),
('31fcedfb-f507-44bd-ad89-336c55539fea', '059f4170-235d-11f1-9647-10683825ce81', 'LAWRENCE PHILIP CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-08-04 12:22:57', NULL, NULL, 0, NULL, '$2y$12$Xj6Ox1AFFJGnY08ixwWkYuxTPC8U6Shi4Foh2.qTPKgrLT6v.QvXu', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, NULL, 'active', '2026-08-04 23:58:44', NULL, '2026-08-04 12:22:57', '2026-08-05 00:52:57', 0),
('6373498c-903e-43a9-bb1d-b67a496aee24', '059ef712-235d-11f1-9647-10683825ce81', 'LARENCE jhgjgh', 'jmsumulong@kld.edu.ph', '2026-08-04 23:52:28', NULL, NULL, 0, NULL, '$2y$12$f3.xbygNSC3HZnB.KZHEAe8/Is4sba5o5GvuXo0IaSN.tnEFjvaOi', NULL, 1, NULL, 'active', '2026-08-04 23:57:55', NULL, '2026-08-04 23:51:52', '2026-08-05 00:04:21', 0),
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
