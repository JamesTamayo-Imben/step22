-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 03, 2026 at 10:32 AM
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
('003b99fa-a6fb-4213-a8df-a389bb7185f5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '8fb791ab-0b43-485b-a1e2-4257a133501f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:19:00', 0),
('01516cef-b7e4-423a-b6c0-f36bcfaebcf5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1931ee21-d300-47cf-8a30-da6d25ecd87d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"INTIAL TRANSFER\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:44:26', 0),
('01f616dc-2182-4cbc-8df6-b8e435d36265', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '17ca062a-87e2-483b-97cb-683bff711cb7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 13:32:26', 0),
('03053ea6-c6fc-428f-a66d-398cc024c4a3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4f84dd08-5a1f-4c57-b5de-716ba6ddfc6d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:38:56', 0),
('03251ee1-4cbd-4a58-bc08-a86f727cd497', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e62fb4ba-1bf6-49cb-b69c-b48a3ffcab20', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerrty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 14:31:21', 0),
('039ed88a-e59d-4f83-9782-b925001ad582', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ba0a15cb-eb83-4fc0-bee6-5b196d691e1d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 12', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:38:03', 0),
('04875dec-8231-48a2-874a-8e6ef25073d7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c0578485-b459-42d5-a130-50b9fe92aca9', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: c', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 02:00:59', 0),
('0589682a-882b-45d0-9280-84215d1a5fb1', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '29b2965e-f05a-4626-b0d0-78d982165725', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ddddddddddddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:25:43', 0),
('06570619-3ef7-4a22-adbc-fdd2c6b68535', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ce97f462-8d9d-4941-be93-91976f027512', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:52:38', 0),
('06ca03a1-572c-4ac0-9431-53df0184ee31', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ee37254b-b985-4a8f-832b-e894aa30397e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:17:38', 0),
('08b054cc-9052-47d1-8a55-47e840c486af', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b5da8c88-1d30-454e-b4f7-2c98b0014416', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hi', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:08:28', 0),
('099db2ce-a7f9-4478-aa22-17c51ef86e32', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3eead227-7e20-413c-9c1a-a1d9103bf463', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:39', 0),
('0aa9520e-e5e0-4ce1-ad2f-2bc70f059e40', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:08:34', 0),
('0daa7fd6-7725-4c01-bb7b-91c6d6db65d9', '087ccbc9-efa8-44e0-8435-3310207554d7', '69fd9f32-3048-4792-acb8-8bf2ebe03536', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: h', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:05:36', 0),
('0dc76f91-db3e-4eee-9bac-d965bfd208a1', '087ccbc9-efa8-44e0-8435-3310207554d7', '296ab788-40e6-434d-b4ce-3489280b6c6f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 11', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:37:13', 0),
('0de84e8d-f718-4a38-935d-e7ea43fe297d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b2380680-7033-4db1-a223-e45bf473afc5', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"errr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:08:01', 0),
('0e1ea823-8e58-412d-ba8d-57d77c0c65b9', '087ccbc9-efa8-44e0-8435-3310207554d7', '4f84dd08-5a1f-4c57-b5de-716ba6ddfc6d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 04:42:56', 0),
('0e206815-486b-407c-b6f7-9caec137d4ea', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:32', 0),
('0e40dd33-fc25-4b1a-80c5-e733f6f48fa4', '087ccbc9-efa8-44e0-8435-3310207554d7', '573e6dc3-bb44-4427-a02d-1d66c9898157', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:17:05', 0),
('0f15f3cf-fbb9-443a-826a-8c3f692b9629', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:34:22', 0),
('0fefa7e6-2c68-4a43-987b-051c2dbba4d4', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:10', 0),
('100b8623-7dca-4045-bad9-b25e8df81d7b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ac25a3f2-fba8-4a11-a84d-c13807febe07', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eeeeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:08:31', 0),
('10d137ab-9ca2-4bec-9965-cac036cb808e', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:04', 0),
('11c30957-cff6-422d-9999-adf376e11258', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f7f8b067-e630-4809-959b-77360c366108', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-01 02:11:55', 0),
('12ae3859-1a3f-4a2b-8331-46683fb2d117', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '8d6c9dee-a764-49b5-ab9b-5bb36610fc61', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ppppp\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:57', 0),
('134e3101-3b9d-4b73-8956-3b5ff9b43ced', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b2380680-7033-4db1-a223-e45bf473afc5', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: errr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:08:21', 0),
('138f492d-2237-4c5e-9f74-45742fdea19c', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e766c3e9-d708-4f59-8831-b84f399c0396', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'asdasdasd — runnnnnnnn', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 01:33:46', 0),
('13e2da6c-4b27-44d2-b788-541c875570e3', '087ccbc9-efa8-44e0-8435-3310207554d7', '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: test — test', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:40:50', 0),
('14d6fdaa-fdef-4491-8ac9-3d7d9d2ee31c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '29b2965e-f05a-4626-b0d0-78d982165725', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ddddddddddddddddddd\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:48', 0),
('166389d8-77bc-4801-aed3-c0cc2916936e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '0073af4a-6de3-4d23-97d1-d9bcc04ea7b9', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:04:02', 0),
('166a5039-6729-4371-8ddd-83fce78fac53', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '215e6893-65a4-4565-93a7-2863657702ee', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"transfer\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:05', 0),
('167c93ce-f0b0-4b00-976e-81ba63b04671', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e766c3e9-d708-4f59-8831-b84f399c0396', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 93edfe34-9d26-4eb8-a0af-aaf09057a98a', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:33:25', 0),
('18ce4c3a-172c-43a3-a380-c4345478769c', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b492548d-def9-4420-b2f8-ad38e0db6d53', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dvvvvv', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:13:04', 0),
('1976594e-8378-4724-aa22-2c9cad69cef7', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:41:32', 0),
('198f2a03-11cf-4dd6-be90-99d57a3a36d4', '087ccbc9-efa8-44e0-8435-3310207554d7', '7ba9ccbd-e9b9-438a-9553-ab6c8e82cc82', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:28:38', 0),
('19911f80-8c04-4913-b789-2c9c8be64be9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd5ab3cc7-e984-4ebd-8291-43ea368fa687', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"yyyyy\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:04:11', 0),
('1aeae960-b42f-4226-99ac-f3822490f2b8', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e03af9c0-6876-48b8-9fa5-2eb28af3004d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwer', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:06:24', 0),
('1cce0092-b7c4-4cdd-a809-4c7a34480fcb', '087ccbc9-efa8-44e0-8435-3310207554d7', '9a27b840-f156-48e4-9dd1-07d5c5412c35', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:31', 0),
('1d7031a3-7803-4d8c-a502-c75f6a8424d1', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 3 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:12', 0),
('1fbddcc5-df00-4d07-839e-ae4dc3545370', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:15', 0),
('224c9c31-767a-4a92-9c13-f5d87d0b58c0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '56e80990-28e3-4964-ae27-dd20eb106bbc', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"pahingi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 10:23:35', 0),
('2268f6a0-5153-46d3-b6e7-3e86cfe15f18', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '37e3a348-1a58-43f5-9e52-b3ea22a80c51', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:29:07', 0),
('2600da2b-bac0-4dca-98cd-9add020e2e00', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ead30135-7760-4b82-b0de-7b7fa7a2a96b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ssssssssss\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:07:15', 0),
('26df601b-a438-49ff-b6d6-548d9e6faddc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 09:54:23', 0),
('29910041-b7fe-4f1b-ab90-e17ec31b7314', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e62fb4ba-1bf6-49cb-b69c-b48a3ffcab20', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerrty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:31:38', 0),
('2cee67d7-4de4-41a0-ab55-070eded068f0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '2a175fcd-d5e9-440f-b741-543b45cf3917', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:56:32', 0),
('2d149afb-1606-4a40-96ef-765650657b0f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '59c224bc-1c29-4056-8e02-c9c7cd459e7e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"3\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:59:11', 0),
('2d827e2e-766d-4bda-bbe7-46e3d7b89941', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c3d325e1-6042-4e8a-9860-9f2f0980a307', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"transfer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:44', 0),
('2d946b58-1a77-4fc7-b4ab-63c27fbb1c3d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ad310c33-b917-42b9-8f33-910b4217c7f2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweert\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:40:24', 0),
('2ec559bf-e6fc-4922-a490-af64af304c71', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 10:21:53', 0),
('2f3681f7-74c4-4041-9bc5-49e84d91ec3b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f5a10049-0b7e-4ad2-862a-299bc00fb283', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"xxxxx\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:42:27', 0),
('3000e83b-9a2b-46ac-9001-fc0ed2718ded', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1acce8d8-b86f-427b-9622-d1969c270e9e', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:40:40', 0),
('32061ffd-c275-4323-ac51-d5f08d315193', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:38', 0),
('33c2d720-472b-473b-b158-161d71b31f71', '087ccbc9-efa8-44e0-8435-3310207554d7', '551a7994-afde-43f0-acf4-45d040321a3c', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'safsda — sdaf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:31:50', 0),
('356d3080-0786-4771-aae0-78847e1f3a65', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:37:33', 0),
('357fcf8f-0541-44fe-ab3b-1d5952e87e9b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 2 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:08', 0),
('35df7796-0553-413b-b68b-16c5365921db', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '6df32d92-9dff-4766-b700-2ac28c379f22', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:05:36', 0),
('363566d3-598e-40cb-8974-1395c47dbccb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '66cbf8fc-86da-41a0-9fb1-76f3806cbd8d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ffffffffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:33', 0),
('367ac2d7-78d2-4aed-b615-55edcc648ae5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '517f49d4-ca74-467c-982a-7788bb150bca', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"oooooooooo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:42:45', 0),
('36810bbd-61a1-4dad-a389-398de62bf45a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:31', 0),
('36d70402-9281-41a0-ab13-0739c9f73c32', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '6f8c694b-0e8e-49ad-905a-55041e32f254', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"wowo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:00:47', 0),
('37b07e48-2c21-48d6-b02e-57e3d136f8a9', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:23', 0),
('385aca2f-d84a-44b2-a854-507380756f23', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7cf3bfa7-8ba3-4a2b-a3e0-f9a585918653', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqqqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:26:28', 0),
('390cb980-f98b-4541-b1d6-6b8d9f1cea7f', '087ccbc9-efa8-44e0-8435-3310207554d7', '7cf3bfa7-8ba3-4a2b-a3e0-f9a585918653', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qqqqqqqqqqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 10:28:24', 0),
('3a916dc7-7b58-4654-a4a7-b7c92aa05047', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd873870b-6daf-4e55-b1fc-c1a828278d81', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:14:25', 0),
('3b1d7e51-9c8f-4e32-bc3c-14da8a803193', '087ccbc9-efa8-44e0-8435-3310207554d7', '57f4219b-7c6b-4fd7-afdc-29da8c54440a', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, '1312 — LASt - A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:02:31', 0),
('3c3acb8b-81b7-4ed8-9dbe-45c9df9e5e48', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1b88fc43-fbeb-4f9a-99b9-396762e7e484', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:11:36', 0),
('3cc2b7dc-0e21-4929-ade4-3c2e179e397e', '087ccbc9-efa8-44e0-8435-3310207554d7', '55ed9f2b-250f-4e15-a422-2dc738642c14', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: tttttttttttt — truncate', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:37:11', 0),
('3d2330a3-1309-41d9-9f08-82f933d29b11', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:29', 0),
('3d9ebdb0-b1eb-4085-97fd-f971b766c5e8', '087ccbc9-efa8-44e0-8435-3310207554d7', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: LAST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:32:07', 0),
('3f51b1ef-c978-4e30-b378-022f505f5c01', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c2ec0cad-bfb9-409b-aa39-8b2a8faaa410', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"fffff\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:02:38', 0),
('3fc21f5a-1cc7-4c73-9688-d8ae460d9563', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a62125a0-49a6-4b38-8ffb-57a93ab1cf4b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:13:24', 0),
('3ff7e1dd-6f0b-447f-995a-caa1c727ae19', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '99fcee4e-48d4-4f28-97bf-04473e3dfc24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:42:46', 0),
('408ade1a-2590-46ef-b652-09794ac3e5f6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'de194365-e159-4a2c-be81-1385cfc5e651', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: UPLOAD', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 09:31:18', 0),
('40a37531-1f3b-4501-b0f2-9ded35d926fc', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:44:08', 0),
('4151d9d1-7896-4c8e-ad74-a35933f81022', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ead30135-7760-4b82-b0de-7b7fa7a2a96b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: ssssssssss', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:07:25', 0),
('41a9d91e-a640-4252-b9ea-37735270d22e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c0578485-b459-42d5-a130-50b9fe92aca9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"c\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:00:08', 0),
('421ffa5b-2d35-442f-b207-6060239dc5de', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '928851e9-3d0a-4701-8607-906fd2a2f7cf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 06:57:03', 0),
('4225982e-1420-4d4c-a5d8-927b99ea5e4e', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:15:25', 0),
('441a11bf-54e4-40cd-95ed-85e67cf8611d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd873870b-6daf-4e55-b1fc-c1a828278d81', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:58:08', 0),
('4453ae6d-259a-4809-9d62-1242a8938004', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '2b0f20d9-b259-49c7-a9cc-b0a76decbe5a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"5555555\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:16:31', 0),
('4488cb8b-cb44-4035-9050-08f018933d16', '087ccbc9-efa8-44e0-8435-3310207554d7', '84f1d33a-c881-41ce-ae7f-efd7269ec3a4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:18:14', 0),
('449057b6-9529-4e57-9cfa-f1dd4df6b0e0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e03af9c0-6876-48b8-9fa5-2eb28af3004d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:06:07', 0),
('44ce5e23-d496-4f4b-8471-f217d9300b73', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '20f2d9c4-a503-4afa-a44e-fbb107bc271c', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"qweee\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:56', 0),
('46785e26-9d48-4da9-951a-62b90837b1ac', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '2bf8362b-7350-41f8-9773-0272bd797818', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"run\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:19:26', 0),
('46a61707-77da-4f85-86e6-630fe3422783', '087ccbc9-efa8-44e0-8435-3310207554d7', '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: 123 — qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 09:34:07', 0),
('471902ed-09d7-4591-884f-d45b3e461181', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ad72e1f7-aa03-4cf2-8813-0b6ccd5a88bb', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"123\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:54', 0),
('4a67c494-7fa6-448a-9332-fc1ed20b3eab', '087ccbc9-efa8-44e0-8435-3310207554d7', '1467012c-d2ee-457d-966a-b987dd2a1d02', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:50', 0),
('4a82f8c6-9e6c-4682-81ed-e11f461c6db7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '44cd0e36-b2f4-4242-8041-f6431e05bc91', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MOENYYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:36:52', 0),
('4c6ff2e2-91eb-41af-b9c8-1f13706468d1', '087ccbc9-efa8-44e0-8435-3310207554d7', '188301d3-cac7-413b-b080-bae23c7c8ef8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:34:48', 0),
('4cbfc9fc-91f3-495a-85b6-8d208bd47634', '087ccbc9-efa8-44e0-8435-3310207554d7', '24f47424-8eaf-49d5-8639-f7d25220e6ca', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:23', 0),
('4f302ce0-6812-4098-8ae6-eda47e21a742', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:22', 0),
('4f968b26-9a6c-47e1-a0f9-c4aa304014ef', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'eba5f2f8-31c8-4c7a-a445-9d5f73c6569b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"testtt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:22:16', 0),
('4fd94dbc-620b-41bd-9045-e5086409e173', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '916b852b-7b65-4525-bbc2-b714d6feb050', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:03:23', 0),
('52ccfefb-3cc2-4c92-9e53-49ea307b87ff', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'cdcb60c1-c59c-4a92-8bec-ec66ee1d4143', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"qwqwqwqwqwqw\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:06', 0),
('53640bfc-8113-4145-83a1-b607791335fa', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e77a70cd-f3bd-4776-9a03-05f88dfdd960', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-10 08:02:18', 0),
('5403932a-26db-4a82-abe1-5e9c2e29c402', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '0a52df93-d420-42b6-852c-75141a59d35b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:16:27', 0),
('55113e92-f745-4f34-a83a-8d4e1cb0007b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:48:36', 0),
('558d9fa1-e862-4f51-afb1-e0dd9baf70a9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c664cc87-1040-49e7-9d80-ee85ee9e7d18', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:33:52', 0),
('558dfc37-1419-4818-8c56-3ec2e770ffa3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '5ce475d7-7efa-41af-ada9-5bba2069fc8b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TESTb\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:26:00', 0),
('55f0521d-d21e-4239-be0e-7aa4180c530a', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:13', 0),
('56812e4b-2439-422d-9a76-b98b408cade9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3397d634-4b91-40d7-8727-3ac093aa27ce', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:42:45', 0),
('56e536b3-a532-4be5-9acf-67e0bec09cc2', '087ccbc9-efa8-44e0-8435-3310207554d7', '17ca062a-87e2-483b-97cb-683bff711cb7', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 13:35:21', 0),
('57073fa1-7701-4d7c-85cd-17f97c9952c5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:11:23', 0),
('57a0d017-6399-43b3-b321-f6e777aad8e1', '087ccbc9-efa8-44e0-8435-3310207554d7', '7ba422cf-ea47-420f-a17c-cf37f15b67ea', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 5', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:05:07', 0),
('57d54d99-d5ed-4fad-ba35-c2412111d3cc', '087ccbc9-efa8-44e0-8435-3310207554d7', '76615760-7ff6-452d-a528-9164118855de', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:10:51', 0),
('5a783cf6-a1f7-4343-a26f-13939d5df841', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ea06eeaa-7d27-4912-a511-a5559b1c72a9', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 3e79a958-802c-4597-ad7f-14ec50c492b1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:46:49', 0),
('5b22d622-e12e-4cc0-ae23-d33b565c4cc4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '0bf0003a-4aeb-4e44-9d71-8898f801445b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 10:24:56', 0),
('5c0eb828-566f-491e-ba7b-a00dcc3d2e1d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '810b05e4-7266-4f5a-b460-e7a492862f84', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"4\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:00:51', 0),
('5cbae19c-b99c-48cb-a046-78be902fa6a5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '0c85f2ce-8d55-4a54-b788-d5a4b78d864f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"iiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:42:46', 0),
('5d72cca0-211c-46e8-9d82-42c04a8734ce', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:39', 0),
('5e8a3029-c073-421b-a93a-54ddeac2d504', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:07', 0),
('5f362669-f4d5-439e-a280-242c4c9b976e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"adasda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:46:36', 0),
('5f6dea96-92e9-40dc-9b87-837556e8786d', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e69dd1c1-2e90-48f2-a557-af412e5adbe0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: weee — weee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:54:44', 0),
('5ff5ddd7-f453-4907-99cf-a514879f6ca3', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 03:08:19', 0),
('6058f5b9-971d-4771-9a23-3e9a9cd0c4e8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b37c5ad1-556a-4af9-96ce-5bdc6bec810d', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:06:39', 0),
('614bf33a-d1a8-4d4f-97ed-49ba3366b819', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '5ebebeae-bb1e-42a4-b39d-90dde6ab15f4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:47:16', 0),
('6177089b-dcfd-4f00-bfd4-59d02ec22d1e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '215e6893-65a4-4565-93a7-2863657702ee', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"transfer\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:52:37', 0),
('61be2574-32fe-4114-81cb-8859121dd828', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '8983a130-a81e-4f75-8d12-117c3887f100', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"maney\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 14:29:57', 0),
('61ce232d-9ae8-4bfb-8a01-a2bb456ad63a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:20:10', 0),
('61efeb2c-d100-4b7c-ae83-40bee7917c2b', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ea8c108b-7868-4189-8ab6-2846ff3ac757', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:04:35', 0),
('61fd786b-7ae6-4118-aed2-73f7c496b535', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b492548d-def9-4420-b2f8-ad38e0db6d53', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dvvvvv\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:10:52', 0),
('620cf792-21a2-4253-9ddb-3b78df54d30c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"adasda\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:47:13', 0),
('62691ec1-c258-4e98-8c2e-b6a42eb3c586', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f4efd930-4ef2-4a46-b9de-b6c13fe0c556', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 11:11:10', 0),
('6379d478-c423-4cf7-b8ad-f329ae0391a0', '087ccbc9-efa8-44e0-8435-3310207554d7', '3475c3f9-ed35-42f3-8559-0f77da4757ff', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: PAHINGII — PAHINGII', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 05:20:07', 0),
('63debb6e-7ec3-4182-b889-e28e37697a04', '087ccbc9-efa8-44e0-8435-3310207554d7', '93edfe34-9d26-4eb8-a0af-aaf09057a98a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: runnnnnnnn', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 01:32:58', 0),
('64c42f6a-2812-43d9-8b46-c073b0eedfc5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:15', 0),
('6557c4f9-a494-4f2e-add6-79be1a00281b', '087ccbc9-efa8-44e0-8435-3310207554d7', 'eba5f2f8-31c8-4c7a-a445-9d5f73c6569b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: testtt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:22:54', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('66cba088-2c7c-43ca-ab8e-22472de11ad0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"sdafsda\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-12 10:18:03', 0),
('6761fdb5-0a5a-4e20-a47c-277a1165b890', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '551a7994-afde-43f0-acf4-45d040321a3c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Canvas ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:15:24', 0),
('695365c5-9645-42dd-b445-4a5453d9a46a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3bd9f824-3450-465b-a1a7-ef1d1f4abdaf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:31:42', 0),
('6af058de-3204-4a38-b1be-ea22eb0cc2af', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:52', 0),
('6b4bc433-4322-4415-9bd2-7ce4cb89a25f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f2731d34-76b0-4f05-921e-2aba9d0bf098', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"jani\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:41:57', 0),
('6b7fd6e2-3faa-49b9-bc99-4462f439956b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7f49d6e7-b124-46ee-96de-3eb287080bcc', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:32:08', 0),
('6c4a86a9-5bf8-4873-a4cc-998cded1514f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: LASt - A', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:33:09', 0),
('6d326fa4-411d-44ce-903a-d66ee6836b32', '087ccbc9-efa8-44e0-8435-3310207554d7', '3e4a11c4-a079-4af0-a35a-0f848cdf0e5c', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:09:54', 0),
('6d70b877-1e93-4598-bf99-89c98f4f6f06', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '76615760-7ff6-452d-a528-9164118855de', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwerty\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:10:39', 0),
('6eef37bb-0770-4786-bf61-46b327f2cfc2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"JANIII\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:55', 0),
('6f516344-d02a-4491-a86a-6a4072a76840', '087ccbc9-efa8-44e0-8435-3310207554d7', '5b1d6bd5-d923-4b60-ad40-00604ba2ee66', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:25', 0),
('6fa65279-f4b4-4367-894c-1468765c9518', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7987240f-af1e-4cd3-bd3c-cff3b55ef5af', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:54:11', 0),
('6ff6fe3f-482f-48f2-a149-e446d2cdead4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '296ab788-40e6-434d-b4ce-3489280b6c6f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"11\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:37:03', 0),
('700085df-f2d5-4ba6-b876-9fd859b9a71b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ee37254b-b985-4a8f-832b-e894aa30397e', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"dd\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:03', 0),
('7072866e-3abd-46a5-b384-bec3472ef2a6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4ddbd5db-65fa-4ab7-95eb-6e65522fb607', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:45:58', 0),
('70748c56-05fe-4319-b353-e2512323dc6d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '93edfe34-9d26-4eb8-a0af-aaf09057a98a', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"runnnnnnnn\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:27:28', 0),
('70785db5-8abe-446a-bfc4-7846cbe78b37', '087ccbc9-efa8-44e0-8435-3310207554d7', '833e9ec6-cedf-474f-aec1-c44c5cc49a5f', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:06:30', 0),
('70963e0c-c62e-404e-892f-a818fdd9cf10', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a05478a0-5f7f-4863-9fff-a83684a60b32', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEYYYYYYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:54:42', 0),
('732c133f-c30f-4b9c-8014-862e1c9dcdef', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '919ab241-e8ef-4a5b-84fe-b46bbb2603ce', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:36:55', 0),
('7337a9fd-260a-45b8-b013-6e534a59d0de', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:50:00', 0),
('73882386-5fe7-429a-9c9c-0adac7bd6f04', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4df69e79-086c-476b-907c-7fc2350b0361', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sadfsad\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:38:46', 0),
('73b3d93d-dfe9-408b-82e3-b46d9aa7b5cd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ae12aab1-5af5-4e46-afe3-865fa0c354e0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ettt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:18:02', 0),
('741e7074-2434-4434-b418-0e1ac74b9c96', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e3a9c3c9-0ea9-4a0b-9398-05aa2a3d174c', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"xxxxx\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:50:45', 0),
('7457211b-e340-4a41-acc1-620293ffbdd7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd0e73905-28fb-46db-854f-3f1e3d51dcf2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: wwowow', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 09:38:42', 0),
('757423ad-a1cb-4b9a-82db-1968cd82896f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a4d73cf4-5aa8-44de-a394-67ad95946496', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TETSTTT', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:36:27', 0),
('75752203-5f09-4073-a96e-8b5864483ad6', '087ccbc9-efa8-44e0-8435-3310207554d7', '919ab241-e8ef-4a5b-84fe-b46bbb2603ce', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:37:43', 0),
('761b6768-0c0f-4505-86a5-eb90f91d7427', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'dbf34bca-61d1-4ce2-b162-2a551bf003c9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:49:04', 0),
('763e21c2-415e-45a6-b321-27d09e9a76e2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4e4e0a3e-ad37-404d-af03-d6034cd3c6fa', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Donation ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:31:27', 0),
('76890987-36b0-471e-9a76-ff6d2bdfbaf8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TESTING\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:44:07', 0),
('76d0a928-e3c7-4682-94e4-4eeac95f7f6d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3475c3f9-ed35-42f3-8559-0f77da4757ff', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"PAHINGII\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 04:57:08', 0),
('771cf96a-9e28-469b-83f4-c4442bda9ab0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ac35bd25-b940-41ba-b0c1-7a45d1622671', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:35:08', 0),
('774288ff-1da0-44b8-b683-092ea1e32b86', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7ef75326-490b-482e-882f-98642ef569c6', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"case \'Initial\': return \'text-indigo-700\';\" for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:27', 0),
('7762c7fa-28e2-40d1-8a21-896a76be2652', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ac25a3f2-fba8-4a11-a84d-c13807febe07', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: eeeeeeeee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:09:29', 0),
('77c7f223-d061-498e-8abd-e6df6ee9e596', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:39', 0),
('78f66830-7667-4e12-b518-167a5ffaa0f6', '087ccbc9-efa8-44e0-8435-3310207554d7', '2a9b70a6-b8c4-4e43-be6e-fde43d9893e8', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: uuuuuuuuuu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:19:40', 0),
('799efc4e-cfb1-47da-b780-4785ffd5673d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '315f678c-73ed-4feb-8f4f-94554a05e54b', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"ddddddddddddddddddd\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:42:25', 0),
('79cf84b7-ca9d-423b-8510-35fdc2170717', '087ccbc9-efa8-44e0-8435-3310207554d7', 'efcceb0d-1006-462c-a975-deb909bfd0ad', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'dfsgfdsg — dddddddddd', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:16:52', 0),
('7a8ac692-6b1a-41d1-8a06-aa9306524779', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e43c6e38-5949-42ff-8158-3607ad77fee8', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 3e79a958-802c-4597-ad7f-14ec50c492b1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 02:15:47', 0),
('7d1aa18d-34c7-4866-b34a-59af3acd33f0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:46:41', 0),
('7d8b7084-c046-43db-ae54-4660c9f36f9a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:26', 0),
('7edf508f-f88b-46ee-bdb8-f3477e79d92c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3dfa91ae-4090-46ad-8cc5-918f6e48ce31', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"vvvv\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:34:50', 0),
('7f1ff075-7534-477d-b952-1cc1a3549f3f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '0a52df93-d420-42b6-852c-75141a59d35b', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"dddddddddda\" and 2 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:34:35', 0),
('7fdf63df-f05b-4e47-ad13-a07405b2af48', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd609674a-6787-4060-8451-353093cbf042', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"rrrrrr\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:49', 0),
('80a09497-a2e9-40d4-bbb2-2f7ce6b4fa1f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1fb9085e-9880-4d79-959b-67822b0d445d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"fffffffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:40:05', 0),
('8165f39c-1c9b-4154-b598-a5b47024ec11', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd0e73905-28fb-46db-854f-3f1e3d51dcf2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"wwowow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 09:38:16', 0),
('821cc2c2-bc8a-462f-aa20-58144e0f1bd6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'fed10a9d-6f6b-4644-861d-aaf49f9fa570', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: oooooo', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:28:35', 0),
('828705b5-722b-4c17-8a68-ff40a630d211', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:19:17', 0),
('8440501b-3ea5-4cd4-b630-1ca59bae19b3', '087ccbc9-efa8-44e0-8435-3310207554d7', '3bd9f824-3450-465b-a1a7-ef1d1f4abdaf', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 09:32:36', 0),
('844aac16-50bd-4a53-9fdd-6d2b2a8df743', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ccdb8a20-20f1-4054-b7fc-a12c807463ce', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 11:15:30', 0),
('847b3f2b-9906-442c-9a24-5d1bcfa8e6a3', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:24', 0),
('852e4ef5-87c7-4dc0-a62b-f3ccaaf09efb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '84f1d33a-c881-41ce-ae7f-efd7269ec3a4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"8\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:18:04', 0),
('85c8ec50-6663-433f-acb9-4c2c38933381', '087ccbc9-efa8-44e0-8435-3310207554d7', 'd259555c-d776-4f4e-ae02-0c9b287aa4f8', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MANEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:32:49', 0),
('867a1424-aa84-41b9-b28d-f54bd124daff', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:53:50', 0),
('86a4d6c3-5d4f-4760-9b54-3b6aae6d4f5e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '00843bdb-9ee2-420d-9c01-c72cd30f8bcf', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"jjjjjj\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:42', 0),
('86d5e464-1e67-4164-ad63-8fde60ce591c', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:32:28', 0),
('8815559e-95af-432d-9ae2-054f7d8a94e7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a869ac41-4b2a-433c-aa66-13a9f000417b', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"ffffffffff\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:57:04', 0),
('889f4ce7-3626-42ed-a43d-4aecac0f1722', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:21', 0),
('8afae5ad-1563-4ca7-9395-b9f66804261a', '087ccbc9-efa8-44e0-8435-3310207554d7', '433836b0-9061-4ffe-bea2-4c6e202bfb3b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 1234', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:43:15', 0),
('8d303649-922a-494d-b782-3a38ee40bff1', '087ccbc9-efa8-44e0-8435-3310207554d7', '2c672cf1-8f77-449c-ba12-f1ed266497ac', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: SPIDERRR', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:49:46', 0),
('8d4c7855-b31d-40a4-8655-ffd9f05a1396', '087ccbc9-efa8-44e0-8435-3310207554d7', '28abfc90-e1d7-4100-b2e4-001f8b42c7b9', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: rttt — rttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:56:02', 0),
('8e79194c-ad39-4e67-a43c-795960d58867', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:19', 0),
('8f549bfb-2a33-414e-9625-021a08191719', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '55ed9f2b-250f-4e15-a422-2dc738642c14', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"tttttttttttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:35:04', 0),
('8f7ffcb3-139f-4584-b4b0-bbb779ea864b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c115366e-1d81-46eb-87db-e4927bada365', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"money\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:41:47', 0),
('8f9a6ad3-5091-4f94-8aec-4551a301d05d', '087ccbc9-efa8-44e0-8435-3310207554d7', '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: sdafsda', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-14 10:30:48', 0),
('8fbc6d02-334e-43dc-9ff3-3f888840b300', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:19', 0),
('90349396-cf8c-4765-9f16-a4cd7c691581', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e5cc2d7b-f225-4a39-8fbe-c2cd584039c7', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'qwqewqweqwe — janiiiiii', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:24:01', 0),
('9086e62c-31c3-4fa3-8ff8-a1a502871dbc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c151858f-9472-460e-ac47-1e7a2253a2b2', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:36', 0),
('908c71bd-e0a4-475a-9e77-9d2366a1f9f3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd7d8f4a6-01b5-4a26-ab7a-f0926677f87c', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"pppppppppp\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:28:29', 0),
('908f4f23-1f41-494e-838e-2a7da8deb40a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:17', 0),
('92e7861b-9dbe-4b68-bcf2-48e27233aa20', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '274d8d6e-a47a-41ac-aff0-f812fee85bb7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"aaaaaaa\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:05:02', 0),
('936336e0-a59e-4e32-ab40-bada53964cd7', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c115366e-1d81-46eb-87db-e4927bada365', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: money', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 06:41:57', 0),
('94ce086e-1813-498e-975c-62fdff2fbf9a', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:40:59', 0),
('95a4f23f-b21f-4be2-9702-0cc8e87c5099', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:24:18', 0),
('95bf8f26-137b-4fef-b114-0b4e2e18b81f', '087ccbc9-efa8-44e0-8435-3310207554d7', '810b05e4-7266-4f5a-b460-e7a492862f84', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:01:04', 0),
('966502e3-3aca-421e-b267-3a1fe5087ed6', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '81f86e97-f3b4-4ab0-b437-9396875ac877', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:03:29', 0),
('9738fd38-df1e-4a67-af83-bc1840239df2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a4d73cf4-5aa8-44de-a394-67ad95946496', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TETSTTT\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:36:18', 0),
('980e0c18-2620-4b25-8ae0-0258887fae42', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'cb8e7a7b-bced-4314-b7a8-004cbf21bed3', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"transfer\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:57', 0),
('986421a8-3787-4f5a-b50e-0840cb2df9cb', '087ccbc9-efa8-44e0-8435-3310207554d7', '45ca02b8-4ddd-4be9-9293-c465ba9c8b0b', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: adasda — weee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:46:54', 0),
('9a12004b-4570-4a8c-b62c-c93e7bfa31c9', '087ccbc9-efa8-44e0-8435-3310207554d7', '7987240f-af1e-4cd3-bd3c-cff3b55ef5af', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: rrrrrrrr', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:54:30', 0),
('9afb644b-70ae-492a-a224-83a385055188', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dd6d28ef-4127-427b-a1e3-235c6b9dbabf', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:56:00', 0),
('9b98b479-89ef-41ca-b587-666de61770c6', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 23:53:54', 0),
('9bd003c6-cdbb-4345-8b6a-5219a4ec3b84', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 10:29:27', 0),
('9be8eea1-a9de-435c-b615-afb11ce716e1', '087ccbc9-efa8-44e0-8435-3310207554d7', '12968484-4272-4a95-b360-0a8c8c6e94d6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:08:46', 0),
('9c2c4f48-1931-4315-a4f0-eb18cf52b067', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"LASt - A\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:32:55', 0),
('9d9fb30d-152c-4b3b-a91f-415aa465688b', '087ccbc9-efa8-44e0-8435-3310207554d7', '789a4a17-b81d-4c74-aac3-bb98b4afee8d', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: tttttttttttttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:42:39', 0),
('9dce3c56-5f6b-449a-89b6-435fd7862551', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '37fb5351-b278-4f19-afba-fc06f6662fe3', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"iiiiii\"\" for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:47:51', 0),
('9df102b2-47fd-47e2-9f31-efcd8bca0506', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:44:09', 0),
('9ebd682f-612c-4a28-b8c2-f9b66cebba64', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:44', 0),
('9f3c8cb3-2ccf-4774-bb08-8050e013ca60', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:19', 0),
('9f70ac40-3786-43a9-b93c-69f2f3723658', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '00843bdb-9ee2-420d-9c01-c72cd30f8bcf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"jjjjjj\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:27', 0),
('9f835efa-2b11-429b-b469-9271de83abe5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:37:36', 0),
('9fc583f8-3a27-4785-8818-83b499f319b5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a62125a0-49a6-4b38-8ffb-57a93ab1cf4b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dddddddddd\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:13:15', 0),
('9ffba03e-b007-4eeb-a8e7-910e32fb4f7d', '087ccbc9-efa8-44e0-8435-3310207554d7', '6df32d92-9dff-4766-b700-2ac28c379f22', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qqqqqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 11:06:05', 0),
('a00db2bb-255e-4b07-b896-46aac71368a4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c2ec0cad-bfb9-409b-aa39-8b2a8faaa410', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"fffff\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 01:26:54', 0),
('a0740621-21b9-47c3-a506-79abe8f935a8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '876f35e5-fc11-4d1b-ac48-c1a7fd1d9d30', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"testttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:38:19', 0),
('a1ed2601-2339-42f2-8383-730e3362710f', '087ccbc9-efa8-44e0-8435-3310207554d7', '4ddbd5db-65fa-4ab7-95eb-6e65522fb607', 'ledger_entry', 'Ledger Entry Rejected', 'ledger', NULL, NULL, 'case \'Initial\': return \'text-indigo-700\'; — adsa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 15:31:55', 0),
('a1fd42e0-3372-45d5-be13-293c4904d224', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '11cb18be-962b-41fe-a59f-45d7057638e7', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qoqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:20:26', 0),
('a28e7cd8-f74e-4e88-979e-2a0c1a797f0f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f4efd930-4ef2-4a46-b9de-b6c13fe0c556', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MONEYY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 11:09:29', 0),
('a40a298a-2122-4aaa-9cfb-25e594fa5c95', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e69dd1c1-2e90-48f2-a557-af412e5adbe0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"weee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:44:47', 0),
('a6baac37-6f92-4a6c-bb6c-86063187331c', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:23:07', 0),
('a7efef72-a708-4ef4-80d8-0e53cb9a822b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'dd6d28ef-4127-427b-a1e3-235c6b9dbabf', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"1\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:55:44', 0),
('a89b71d0-b98d-469d-a5fc-87011f6fe008', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:29', 0),
('a9a68477-43da-47b4-b69b-05fab089b10d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:56:17', 0),
('a9ca6f4c-3b0b-49c6-bee2-bb4e1d52c5cb', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test2\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:24:15', 0),
('ab030ba8-44ef-455c-8e3d-2ac57bcb7c7b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:36:54', 0),
('abcfcb9e-aecc-4888-b14e-73a994eaf190', '087ccbc9-efa8-44e0-8435-3310207554d7', '44cd0e36-b2f4-4242-8041-f6431e05bc91', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MOENYYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 12:42:10', 0),
('ac801ee3-7bea-4ff6-858a-72a1e0213b56', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '3e79a958-802c-4597-ad7f-14ec50c492b1', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"sdafsda\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-12 10:17:51', 0),
('add8d2c8-6f30-4381-a2f2-4d1f0728f5c6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1a70eb6d-ce63-4d86-a2e1-baafbf5a59a1', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2a175fcd-d5e9-440f-b741-543b45cf3917', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:38:21', 0),
('ae0af81c-f801-480e-831e-300ff20e1cd4', '087ccbc9-efa8-44e0-8435-3310207554d7', '3dfa91ae-4090-46ad-8cc5-918f6e48ce31', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: vvvv', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 01:58:23', 0),
('ae135cc5-3d7d-4a10-a571-01aeaa708816', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f9284c06-e432-4185-b84e-1364c2eeeb45', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"Hingi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:46:53', 0),
('ae22b573-3aec-40b4-bf5c-5ddc5aa2b627', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f7f8b067-e630-4809-959b-77360c366108', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-01 02:12:15', 0),
('aea878b1-c7c8-4dd2-b6d2-c40ed11c85a0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:24', 0),
('aeedca32-da20-400e-a6fb-acccdc111ac1', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"JANIII\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:43:40', 0),
('aef0ce0a-7df2-422e-b7d1-6013f2fa3776', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'emdgquintos — TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:23:57', 0),
('af323234-ef8d-4cf2-8c3c-47480fbb3bef', '087ccbc9-efa8-44e0-8435-3310207554d7', 'ad310c33-b917-42b9-8f33-910b4217c7f2', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qweert', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:40:35', 0),
('b1886959-3502-4f7c-b7c7-09928bd7c666', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:43:41', 0),
('b1e3de84-1246-47a1-b482-1c00f00277aa', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'cdcb60c1-c59c-4a92-8bec-ec66ee1d4143', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qwqwqwqwqwqw\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:30:16', 0),
('b1ef38d1-1b15-4da8-a61f-04a4a9e13f88', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c3d325e1-6042-4e8a-9860-9f2f0980a307', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"transfer\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:51', 0),
('b220d3c8-d67d-432a-b787-19d2950a27a0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7ef75326-490b-482e-882f-98642ef569c6', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:44:10', 0),
('b4ad2f63-5879-45fb-b202-d1c65cbc0cbc', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '928851e9-3d0a-4701-8607-906fd2a2f7cf', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"qweee\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:44', 0),
('b5116ee9-a402-4eed-8086-5a9e65eea631', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:12', 0),
('b598decc-8b53-4683-ad77-a803da863128', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c6b22578-a47d-409d-b5f7-2559e6681d96', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 9', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:21:57', 0),
('b7dbaad7-b7e3-4f01-823a-f320ff2684fd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:51:14', 0),
('b8243b9e-decb-44e4-9eb1-3d7ffa3b1426', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '8d6c9dee-a764-49b5-ab9b-5bb36610fc61', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ppppp\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:17:56', 0),
('b97c32d9-bda4-4dc2-b7f9-e56f3136a59c', '087ccbc9-efa8-44e0-8435-3310207554d7', '8983a130-a81e-4f75-8d12-117c3887f100', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: maney', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:30:06', 0),
('b9ee6c1d-7569-4437-b0fc-24a89c27af4c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"LAST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:31:53', 0),
('ba62ac2f-f793-45ea-9216-b1fd1971c4af', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '853b412a-16a3-48a1-8f56-a29fd3c9c2c0', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Sponsorship ledger entry for project ID 5ce475d7-7efa-41af-ada9-5bba2069fc8b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:38:05', 0);
INSERT INTO `audit_logs` (`id`, `user_id`, `actionable_id`, `actionable_type`, `action`, `module`, `action_type`, `status`, `details`, `ip_address`, `browser_info`, `created_at`, `archive`) VALUES
('bb0d3393-4488-442e-92ff-b0368ad08bb9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ccdb8a20-20f1-4054-b7fc-a12c807463ce', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hiram\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 11:12:15', 0),
('bb7be40b-182e-44cf-b29a-88337278ef42', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '274d8d6e-a47a-41ac-aff0-f812fee85bb7', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"aaaaaaa\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:18:48', 0),
('bbf6da58-a017-4849-acbb-f0651ad18215', '087ccbc9-efa8-44e0-8435-3310207554d7', '0977799a-13fe-47e5-b41d-8a2afe55d5ce', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:37', 0),
('bc685239-eb7e-4d1d-893b-7c21a56e4918', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e3a9c3c9-0ea9-4a0b-9398-05aa2a3d174c', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"xxxxx\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:19:25', 0),
('bcde41cf-7531-4f2b-af57-8cf857e975ad', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:53:23', 0),
('bceff184-d20e-4f03-82f2-b93aff507187', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c4b7b832-f09a-4df6-b477-ab13a1425d92', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"123\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:22', 0),
('bd9724e1-189f-4e59-8a33-000d9f1e963b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:28:22', 0),
('bdab1b96-d57c-4179-82e6-c97c459877ef', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'abfc3dcd-efd2-4f6a-878e-47eb0e22ed00', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-01 23:38:49', 0),
('bde1e660-6201-45fd-9f2c-e7e1b088b159', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:36:18', 0),
('be3cc804-6f23-4ace-afdf-70cfbcb6d2dc', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '2c672cf1-8f77-449c-ba12-f1ed266497ac', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"SPIDERRR\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:47:36', 0),
('befff347-6e1a-4307-a25b-4322cc145762', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '27beff6b-58c0-4d02-b88a-45c745e73999', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:52:35', 0),
('bf0923b9-443f-4c48-b6c2-5277ada10b35', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '99fcee4e-48d4-4f28-97bf-04473e3dfc24', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:08', 0),
('bf4565ac-5fcc-473d-82e0-0547fd91f75d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c144e59a-4597-462a-bbb9-d3ef5a104d75', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"naji\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:21:41', 0),
('c0574993-4835-476f-8603-16082cdac49c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e4ea3411-3a63-4923-aff3-c9f37dde7878', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:06:59', 0),
('c24fedb1-12a3-4898-9910-c10f2410bdf9', '087ccbc9-efa8-44e0-8435-3310207554d7', '1acce8d8-b86f-427b-9622-d1969c270e9e', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qwerty', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:40:57', 0),
('c34560d0-1e4f-4954-ba9f-8f7ae1e2f4ff', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '88d3aa5e-0a13-4f92-b4c1-e4fec8720e24', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"janiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 01:30:45', 0),
('c40384ae-d527-4ba6-a333-f66043b875b9', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dbf34bca-61d1-4ce2-b162-2a551bf003c9', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 13:01:40', 0),
('c670a9b3-dd60-426e-9633-88636151275f', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 02:30:26', 0),
('c70c7d16-b690-4e74-933b-d4fc93905371', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '433836b0-9061-4ffe-bea2-4c6e202bfb3b', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"1234\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 01:43:04', 0),
('c819dca8-8626-4d67-8ebd-bbaf8520e884', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '69fd9f32-3048-4792-acb8-8bf2ebe03536', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"h\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:56:45', 0),
('c82dbdfd-8ed0-4913-9488-f24bef7bec7b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e5cc2d7b-f225-4a39-8fbe-c2cd584039c7', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID 4670d8f5-aec5-4340-90b1-6170bab480b4', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 00:23:44', 0),
('c95cfe98-da92-4a60-b014-0a8a9964633e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ba7b1f2e-8e12-4f49-8ca6-b06b3b8db59c', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:29:39', 0),
('c96f6635-0d3e-417e-b957-8eadd50aaf33', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 14:32:53', 0),
('ca77c26e-58c0-4072-9599-c3ac1f1a3c0c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4670d8f5-aec5-4340-90b1-6170bab480b4', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"janiiiiii\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-27 02:03:16', 0),
('cb6ddc1b-8b25-420e-a50b-af54d8f1277c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '9aa1179b-7233-4feb-8ea8-f8429914b486', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID dd6d28ef-4127-427b-a1e3-235c6b9dbabf', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:57:19', 0),
('cc9473b3-ea47-486c-be05-ebf218e5a255', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'de194365-e159-4a2c-be81-1385cfc5e651', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"UPLOAD\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 09:26:30', 0),
('cdfa8212-2cec-47a0-af49-d618bd6c854d', '087ccbc9-efa8-44e0-8435-3310207554d7', '11cb18be-962b-41fe-a59f-45d7057638e7', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qoqq', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:20:41', 0),
('ce7cb503-fa0e-4389-8aac-a8f9599d1249', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc1fb7a3-ce6e-47a8-845e-a188138f0238', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: aaaaaaa', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 14:05:00', 0),
('ce9dda4a-d984-4030-83f5-28b608e656c3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'de90732f-3615-4e07-bbb4-49f9c91b3031', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"10\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:28:23', 0),
('cf9e58a9-9c6f-48ad-b2f9-d2b585a75f19', '087ccbc9-efa8-44e0-8435-3310207554d7', '250178a0-a6a3-4c38-8a6a-d1a9af085359', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: eeeeeeeeeee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:48:30', 0),
('cfe97d3e-f04c-41f2-b213-dfc557e15fa9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '539f56cd-5214-4940-9144-e809e5682ee8', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID 2e8dc2e7-5618-44b4-9230-a48658daf0a6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 01:48:35', 0),
('d1603921-fbaa-4aca-a574-b71476e04ff3', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:34:21', 0),
('d1d8d7aa-aef6-498e-ab3f-13737f251f69', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '573e6dc3-bb44-4427-a02d-1d66c9898157', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"7\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:16:55', 0),
('d1ef0111-010c-4b05-a368-fda12d70ef08', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '11a87ddc-3e66-48e5-9b80-4a0e03e96869', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qweee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:37:56', 0),
('d2017af8-aad5-4b7d-9171-08973b35f59f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '2a9b70a6-b8c4-4e43-be6e-fde43d9893e8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"uuuuuuuuuu\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:05:54', 0),
('d32f2067-8c7f-4b04-86a6-df96ed6252e6', '087ccbc9-efa8-44e0-8435-3310207554d7', '5ce475d7-7efa-41af-ada9-5bba2069fc8b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:26:39', 0),
('d3be6878-16ce-4d65-a14f-bbc32e8b2261', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f9284c06-e432-4185-b84e-1364c2eeeb45', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: Hingi', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:47:18', 0),
('d4776ca6-9142-4aa9-abe0-ac75ab4226a0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a05478a0-5f7f-4863-9fff-a83684a60b32', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEYYYYYYY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 04:54:56', 0),
('d53885e7-041e-4612-bbd5-db9d40c7a5e0', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b56a9197-29df-4122-a66c-bda6239b7f92', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:41:48', 0),
('d55ce07e-d954-48e8-8edd-72c72eae5adb', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:35:27', 0),
('d602938f-9c83-48b8-b8a9-2cf16792850c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c6b22578-a47d-409d-b5f7-2559e6681d96', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"9\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:21:47', 0),
('d6803df8-7c3b-4771-8a39-ca9c902320fd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'cdf60581-6153-4fde-87a4-19a0a938929a', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:18', 0),
('d819ea84-5b13-4005-b031-6124306da42c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ea8c108b-7868-4189-8ab6-2846ff3ac757', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:04:25', 0),
('d862512d-d01d-4998-8064-85bc1f0bf2bd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"test\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 11:40:08', 0),
('d8d47d92-b529-4280-a18b-e9eedc071ec8', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:53:58', 0),
('da690d0d-0ad1-4e9f-8198-098eb95e05ac', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'cc28e369-b452-42b1-93ff-ff5ed6a6e947', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"ggggggggg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 02:23:57', 0),
('db0f774e-d884-4a2a-8cd2-8623f618b7cb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '28abfc90-e1d7-4100-b2e4-001f8b42c7b9', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:55:36', 0),
('db2dd72b-d61f-4b81-a9ec-c893097b8a9a', '087ccbc9-efa8-44e0-8435-3310207554d7', '5ebebeae-bb1e-42a4-b39d-90dde6ab15f4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: MONEY', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:47:28', 0),
('db48f9a1-495e-4537-911d-a613fa04056b', '087ccbc9-efa8-44e0-8435-3310207554d7', '6b733448-bb6b-4a3c-96c9-a90cc7cb17e2', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: JANIII — etretw', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-24 01:25:59', 0),
('dd8ee350-22d9-42ef-8727-a05f951eb752', '087ccbc9-efa8-44e0-8435-3310207554d7', 'aa2860db-d074-47e5-8942-731c4cb0c598', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: dsfgfdg', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-14 10:36:04', 0),
('ddc6d776-ac5a-43be-9c41-78f9d3c1fa4c', '087ccbc9-efa8-44e0-8435-3310207554d7', '2b0f20d9-b259-49c7-a9cc-b0a76decbe5a', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 5555555', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:16:47', 0),
('de1b16c7-39d9-4b72-a500-4b2ea5361ec1', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b5da8c88-1d30-454e-b4f7-2c98b0014416', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"hi\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 22:07:15', 0),
('df60b73d-4a2f-4bfa-ab74-19d193fc65a3', '087ccbc9-efa8-44e0-8435-3310207554d7', '4ec63d64-632a-4e60-8b37-f7077e5cdd8f', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 14:25:47', 0),
('df7f5570-16c0-4beb-b5d4-e5bacfaaf3c3', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e4ea3411-3a63-4923-aff3-c9f37dde7878', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:07:09', 0),
('dfd7e533-c2ac-4bec-aa0c-52e07bc264a2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '47ea1447-42ec-4694-a660-f1fcaab78aff', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 08:59:13', 0),
('e0078de8-c875-4a38-872f-bf307b3e38bd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '1322b02f-02e9-4f63-ae7c-4892ca66a680', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:34:14', 0),
('e18748d0-e04d-424d-9b51-313f3aab469f', '087ccbc9-efa8-44e0-8435-3310207554d7', 'f658bfe7-15b5-4509-83e4-afcc010ce143', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TEST1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:24:19', 0),
('e1c3db02-ceb0-4597-a72f-e4cc9d6802d2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '12968484-4272-4a95-b360-0a8c8c6e94d6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"6\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:08:33', 0),
('e1f1acc9-4b6e-496e-96cb-19feffaaa79d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ba0a15cb-eb83-4fc0-bee6-5b196d691e1d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"12\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:37:54', 0),
('e2e0b8b3-d4b1-4672-a2f5-06dd7dbb7877', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:57', 0),
('e2eb2b75-9d17-44b3-ac41-73beffc120a5', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 0 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:06:55', 0),
('e351cff1-cff6-44f4-a177-742473c1570a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '250178a0-a6a3-4c38-8a6a-d1a9af085359', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eeeeeeeeeee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:47:29', 0),
('e3b296b7-f75b-4ad5-a825-23af4b5784b1', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:42:13', 0),
('e4593e5f-b1c8-497f-b400-2146d3a030a0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '57f4219b-7c6b-4fd7-afdc-29da8c54440a', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:01:16', 0),
('e46adb17-b3f6-44c3-8452-38b5e374b667', '087ccbc9-efa8-44e0-8435-3310207554d7', '4670d8f5-aec5-4340-90b1-6170bab480b4', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: janiiiiii', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-27 02:04:00', 0),
('e48f66f6-870b-4df4-91c4-965f68865a07', '087ccbc9-efa8-44e0-8435-3310207554d7', '97ee6f1f-677e-4644-8026-a18a3368eb55', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 01:44:18', 0),
('e552dff7-cf7d-4849-8baf-6a3a7f704127', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '00afbf20-9ae4-4178-ab06-63e0751bb15a', 'meeting', 'Meeting Created', 'meetings', 'create', 'Success', 'Created meeting \"wow\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-03 03:14:28', 0),
('e580cbde-c3d2-4aee-8f70-0c907ef23030', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ae95c603-c101-4a1a-9a81-25eb83d722ee', 'ledger_entry', 'Ledger Entry Archived', 'ledger', 'delete', 'Success', 'Archived ledger entry \"Transferred to project \"transfer\"\" for project ID c115366e-1d81-46eb-87db-e4927bada365', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:55:20', 0),
('e68516d0-6931-4423-a574-9c2a1e1ef12f', '087ccbc9-efa8-44e0-8435-3310207554d7', '0bf0003a-4aeb-4e44-9d71-8898f801445b', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 10:29:12', 0),
('e6e29f6b-9348-44a5-9ddc-aa7fddb999f0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:28:00', 0),
('e8599645-4dea-486d-b7e4-3da3bca3acdb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ac35bd25-b940-41ba-b0c1-7a45d1622671', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"rrrr\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:34:22', 0),
('e9e33e5e-a266-43ec-a3f7-130e4863250b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'fed10a9d-6f6b-4644-861d-aaf49f9fa570', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"oooooo\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 11:27:09', 0),
('ea6f74dd-8d48-4fda-bde8-e1adb0f46126', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'd259555c-d776-4f4e-ae02-0c9b287aa4f8', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"MANEY\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 12:32:28', 0),
('eb101f59-1460-4313-9c94-40576690d7e9', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ae12aab1-5af5-4e46-afe3-865fa0c354e0', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"ettt\" and 0 related ledger entries', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:51:00', 0),
('eb3b5906-91c1-4f46-aa78-99cebdd63f8c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a15adcfd-da7c-4470-8e61-c9853096baa0', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"eee\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 10:34:28', 0),
('eb58ae32-acc6-4b27-89f7-e1f91439bebd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '7ba422cf-ea47-420f-a17c-cf37f15b67ea', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"5\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 13:04:52', 0),
('ed467b45-3e87-4356-847f-969b776c1f9a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '82c267bd-8608-437f-8097-cf65be565ae0', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"test\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 12:21:58', 0),
('ed821bc2-ec85-4c96-8405-77e2a0535329', '087ccbc9-efa8-44e0-8435-3310207554d7', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 12:24:48', 0),
('ed92b58e-adb6-4922-ae98-4f48fa8632dd', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e66a69ff-9f28-4c63-80f7-26379c98b3e8', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:27:39', 0),
('ee20afe7-b561-4776-87a5-5657928cb97b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'f658bfe7-15b5-4509-83e4-afcc010ce143', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"TEST1\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 13:24:04', 0),
('ef57938f-4d81-4c49-aa66-e5a3eb1048c5', '087ccbc9-efa8-44e0-8435-3310207554d7', 'a15adcfd-da7c-4470-8e61-c9853096baa0', 'project', 'Project Rejected', 'approvals', NULL, NULL, 'Rejected project: eee — truncate', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 11:36:10', 0),
('ef6ca54b-5ffc-4854-b37c-0b80e0fdb923', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '789a4a17-b81d-4c74-aac3-bb98b4afee8d', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"tttttttttttttt\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 12:41:09', 0),
('ef992bcb-29da-4121-819a-ac73f804ec83', '087ccbc9-efa8-44e0-8435-3310207554d7', 'de90732f-3615-4e07-bbb4-49f9c91b3031', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 10', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 13:28:36', 0),
('efd57bbf-13c6-4b95-899d-93e857b84b9b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 00:50:32', 0),
('f0455813-0e9a-4c27-becb-c30a0a71bb88', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'efcceb0d-1006-462c-a975-deb909bfd0ad', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID d873870b-6daf-4e55-b1fc-c1a828278d81', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 03:16:33', 0),
('f0ee153d-1856-499c-96a9-74b39307ba5c', '087ccbc9-efa8-44e0-8435-3310207554d7', '876f35e5-fc11-4d1b-ac48-c1a7fd1d9d30', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: testttt', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 03:38:42', 0),
('f65f41b8-0445-42e8-8799-5d82256cdcdd', '087ccbc9-efa8-44e0-8435-3310207554d7', '2a175fcd-d5e9-440f-b741-543b45cf3917', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:56:43', 0),
('f692c578-18a4-48df-a5e7-4f7813c48553', '087ccbc9-efa8-44e0-8435-3310207554d7', 'c664cc87-1040-49e7-9d80-ee85ee9e7d18', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: hiram', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 12:34:08', 0),
('f75aa1bb-4ee8-48a5-81d6-8c1f01292d59', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '47ea1447-42ec-4694-a660-f1fcaab78aff', 'project', 'Project Archived', 'projects', 'delete', 'Success', 'Archived project \"123\" and 1 related ledger entry', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', '2026-08-02 09:23:48', 0),
('f785ad6a-5c7e-4cd9-b281-ccbf802149df', '087ccbc9-efa8-44e0-8435-3310207554d7', '59c224bc-1c29-4056-8e02-c9c7cd459e7e', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: 3', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:59:20', 0),
('f7e56c84-8d42-4a30-866c-a7b65f302920', '087ccbc9-efa8-44e0-8435-3310207554d7', '9aa1179b-7233-4feb-8ea8-f8429914b486', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, '2 — 1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-07-26 12:57:30', 0),
('f7eda665-415f-4ec1-915f-edacd0949210', '087ccbc9-efa8-44e0-8435-3310207554d7', 'dc615d50-58cc-436c-8a7e-263d4f3713eb', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-03 00:44:30', 0),
('f8e035e3-e68c-4df5-ac01-1631d3c85ec3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'ed6bb5b3-8dbe-45f6-83c6-7be07ae7cd29', 'date_change_request', 'Date Change Requested', 'project', 'create', 'Success', 'Requested date change for project: sdafsda', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 02:38:21', 0),
('f928ef02-8c93-4910-a32a-4dd963892ac7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'a3a9f6ca-32f2-4c43-b8ae-5c99dfc24405', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID a85a7b3a-2495-4098-9c6e-6dee08de3f99', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 15:09:26', 0),
('f93b416c-7c98-4445-8bd8-8325ec1d0c5a', '087ccbc9-efa8-44e0-8435-3310207554d7', '11a87ddc-3e66-48e5-9b80-4a0e03e96869', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: qweee', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 06:39:49', 0),
('faa8e3a2-0fed-4b91-9c28-06cbfeae5ea3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '4ec63d64-632a-4e60-8b37-f7077e5cdd8f', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"123\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-03 14:23:38', 0),
('fad8eb4d-e672-44f2-b413-a3a8c20e6f78', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'c4ee54b9-63cc-4b14-b087-27517c051254', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"qqqqqqqqqqqq\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-08-02 06:38:42', 0),
('fb02541f-b01f-4d09-873b-b8a7fb0d6ab0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'dc1fb7a3-ce6e-47a8-845e-a188138f0238', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"aaaaaaa\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', '2026-07-26 14:04:46', 0),
('fd984d30-7bc5-41be-9c37-d560a727cc1b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'aa2860db-d074-47e5-8942-731c4cb0c598', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project \"dsfgfdg\"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 10:31:45', 0),
('fda1207d-bd72-459a-a742-d09b83173207', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36 Edg/150.0.0.0', '2026-08-02 22:25:13', 0),
('ff8f6b1a-f142-4088-89f6-9212354aac06', '087ccbc9-efa8-44e0-8435-3310207554d7', '853b412a-16a3-48a1-8f56-a29fd3c9c2c0', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'TESTb — TESTb', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', '2026-08-03 13:39:17', 0);

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
('2fc9ce81-ea02-4375-a1f4-a335c61c1d81', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 1, 'a289432dcac838b234d90922f0da7b5b628bc6e364dfa1b63f603d9c73a84f05', '5ec2f4794aad549e147e61b928330f3f6845d045c56271be4029b64f5b8a7daf', '\"{\\\"type\\\":\\\"ledger\\\",\\\"ledger_id\\\":\\\"57f4219b-7c6b-4fd7-afdc-29da8c54440a\\\",\\\"project_id\\\":\\\"a85a7b3a-2495-4098-9c6e-6dee08de3f99\\\",\\\"description\\\":\\\"1312\\\",\\\"budget_breakdown\\\":\\\"[{\\\\\\\"item\\\\\\\":\\\\\\\"adas\\\\\\\",\\\\\\\"qty\\\\\\\":1,\\\\\\\"unitPrice\\\\\\\":\\\\\\\"100\\\\\\\",\\\\\\\"amount\\\\\\\":100}]\\\",\\\"amount\\\":\\\"100.00\\\",\\\"entry_type\\\":\\\"Expense\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-03T08:02:31+00:00\\\",\\\"snapshot_nonce\\\":\\\"b9838bf7189ac991\\\"}\"', '2026-08-03 08:02:31'),
('84bbf0c1-8695-4f4f-8fd8-2bc338a95292', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 0, NULL, '5c634ae9e386f8017d7ec582679549dc101fad13f5dee98bb36ad87d2ed3a198', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"09cb10ae-6c3d-44f0-bf92-6bbaece7c6de\\\",\\\"title\\\":\\\"LAST\\\",\\\"description\\\":\\\"LAST\\\",\\\"amount\\\":\\\"100.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-03T07:32:07+00:00\\\"}\"', '2026-08-03 07:32:07'),
('cfd4d325-2f26-49a3-85d0-c26d749a1fb1', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 0, NULL, 'a289432dcac838b234d90922f0da7b5b628bc6e364dfa1b63f603d9c73a84f05', '\"{\\\"type\\\":\\\"project\\\",\\\"project_id\\\":\\\"a85a7b3a-2495-4098-9c6e-6dee08de3f99\\\",\\\"title\\\":\\\"LASt - A\\\",\\\"description\\\":\\\"LASt - A\\\",\\\"amount\\\":\\\"1.00\\\",\\\"approval_status\\\":\\\"Approved\\\",\\\"approved_at\\\":\\\"2026-08-03T07:33:09+00:00\\\"}\"', '2026-08-03 07:33:09');

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
('0073af4a-6de3-4d23-97d1-d9bcc04ea7b9', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Expense', 1231.00, 'adasd', NULL, '\"[{\\\"item\\\":\\\"adas\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"1231\\\",\\\"amount\\\":1231}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:04:02', '2026-08-03 15:04:02'),
('05a8c7fb-e9e6-4f72-ae96-a7153c3e704c', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Initial Transfer', 1.00, 'Transferred from completed project \"LAST\"', 'Transfer', NULL, 'storage/ledger_proofs/bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053.pdf', 'bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053', 'Approved', 0, 'Transferred from completed project \"LAST\" to project \"LASt - A\"', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-08-03 14:33:09', NULL, 0, '2026-08-03 14:32:55', '2026-08-03 14:33:09'),
('1148f668-a766-4431-b336-e22c408bc9b1', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Initial', 1.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'storage/ledger_proofs/262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a.pdf', '262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a', 'Approved', 0, 'Auto-generated baseline on project creation', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-08-03 14:32:07', NULL, 0, '2026-08-03 14:31:53', '2026-08-03 07:53:34'),
('1b88fc43-fbeb-4f9a-99b9-396762e7e484', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Donation', 131.00, 'das', NULL, '\"[{\\\"id\\\":1,\\\"item\\\":\\\"dasda\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"131\\\",\\\"amount\\\":131}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:11:36', '2026-08-03 15:11:36'),
('27beff6b-58c0-4d02-b88a-45c745e73999', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Expense', 123123.00, 'type: newEntry.type || ledgerForm.type,', NULL, '\"[{\\\"item\\\":\\\"dads\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123123\\\",\\\"amount\\\":123123}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 14:52:35', '2026-08-03 14:52:35'),
('3ae62241-00b5-4f8a-bad1-f5ea79317870', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Transfer', 1.00, 'Transferred to project \"LASt - A\"', 'Transfer', NULL, NULL, NULL, 'Approved', 0, '{\"transfer_source_project_id\":\"09cb10ae-6c3d-44f0-bf92-6bbaece7c6de\",\"transfer_source_project_title\":\"LAST\",\"transfer_destination_project_id\":\"a85a7b3a-2495-4098-9c6e-6dee08de3f99\",\"transfer_destination_project_title\":\"LASt - A\"}', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-08-03 14:33:09', NULL, 0, '2026-08-03 14:32:55', '2026-08-03 14:33:09'),
('3eead227-7e20-413c-9c1a-a1d9103bf463', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Expense', 111.00, '123123', NULL, '\"[{\\\"item\\\":\\\"123123\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"111\\\",\\\"amount\\\":111}]\"', NULL, NULL, 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 14:44:39', '2026-08-03 14:44:39'),
('4ddbd5db-65fa-4ab7-95eb-6e65522fb607', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Sponsorship', 111.00, 'case \'Initial\': return \'text-indigo-700\';', NULL, '\"[{\\\"item\\\":\\\"1312\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"111\\\",\\\"amount\\\":111}]\"', NULL, NULL, 'Rejected', 0, 'adsa', NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, '2026-08-03 15:31:55', 0, '2026-08-03 14:45:58', '2026-08-03 15:31:55'),
('4e4e0a3e-ad37-404d-af03-d6034cd3c6fa', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Donation', 1231.00, 'xzvxz', NULL, '\"[{\\\"item\\\":\\\"xzvzx\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"1231\\\",\\\"amount\\\":1231}]\"', 'storage/ledger_proofs/262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a.pdf', '262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:31:27', '2026-08-03 15:31:27'),
('551a7994-afde-43f0-acf4-45d040321a3c', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Canvas', 1231231.00, 'safsda', NULL, '\"[{\\\"item\\\":\\\"fsafs\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"1231231\\\",\\\"amount\\\":1231231}]\"', NULL, NULL, 'Rejected', 0, 'sdaf', NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, '2026-08-03 15:31:50', 0, '2026-08-03 15:15:24', '2026-08-03 15:31:50'),
('57f4219b-7c6b-4fd7-afdc-29da8c54440a', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Expense', 100.00, '1312', NULL, '\"[{\\\"item\\\":\\\"adas\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"100\\\",\\\"amount\\\":100}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Approved', 0, 'type: newEntry.type || ledgerForm.type,', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-08-03 15:02:31', NULL, 0, '2026-08-03 15:01:16', '2026-08-03 15:02:31'),
('7ef75326-490b-482e-882f-98642ef569c6', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Expense', 111.00, 'case \'Initial\': return \'text-indigo-700\';', NULL, '\"[{\\\"item\\\":\\\"123\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"111\\\",\\\"amount\\\":111}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 1, '2026-08-03 14:44:10', '2026-08-03 14:44:27'),
('7f49d6e7-b124-46ee-96de-3eb287080bcc', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Donation', 123.00, 'safsda', NULL, '\"[{\\\"item\\\":\\\"safsa\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', NULL, NULL, 'Pending Adviser Approval', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:32:08', '2026-08-03 15:32:10'),
('916b852b-7b65-4525-bbc2-b714d6feb050', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Expense', 13.00, 'asdas', NULL, '\"[{\\\"item\\\":\\\"daas\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"13\\\",\\\"amount\\\":13}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:03:23', '2026-08-03 15:03:23'),
('a3a9f6ca-32f2-4c43-b8ae-5c99dfc24405', 'a85a7b3a-2495-4098-9c6e-6dee08de3f99', 'Expense', 132.00, 'ledger_proof: newEntry.ledger_proof || null,', NULL, '\"[{\\\"item\\\":\\\"adas\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"132\\\",\\\"amount\\\":132}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:09:26', '2026-08-03 15:09:26'),
('b37c5ad1-556a-4af9-96ce-5bdc6bec810d', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Donation', 123.00, 'safsda', NULL, '\"[{\\\"item\\\":\\\"safas\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:06:39', '2026-08-03 15:06:39'),
('ba7b1f2e-8e12-4f49-8ca6-b06b3b8db59c', '09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', 'Expense', 123.00, 'sdafsad', NULL, '\"[{\\\"item\\\":\\\"sfsadf\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"123\\\",\\\"amount\\\":123}]\"', 'storage/ledger_proofs/63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56.jpg', '63e6cf6036c972d85ffecb0fc1c643f10125445d0dc3e950381b797222f23c56', 'Draft', 0, NULL, NULL, 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', NULL, NULL, NULL, 0, '2026-08-03 15:29:39', '2026-08-03 15:29:39');

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
('00afbf20-9ae4-4178-ab06-63e0751bb15a', NULL, 'wow', 'wow', '2026-07-31 13:16:00', '2026-08-03 03:14:28', 0, NULL, NULL, '100', '[]', NULL, NULL, '2026-08-03 03:14:28', 0);

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
('01a03dc0-bf61-4a99-bed0-86f5fa2d675a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"1\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:55:51', '2026-07-27 02:08:37', 0),
('0255d758-8a81-41db-8cb7-fcbff099c49b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"MONEYY\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:09:40', '2026-08-03 09:13:44', 0),
('02e5e176-b5b5-48b4-bb57-07463e07a840', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:32', '2026-08-03 09:13:44', 0),
('03b9cf40-2a2f-4598-9991-d384bd7c10df', NULL, 'Project Approved', 'Project \"dvvvvv\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:13:04', '2026-07-27 02:08:37', 0),
('044a0d63-1746-4a66-b52c-eff9a86ba8d6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qqqqqqqqqqq\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 10:26:46', '2026-08-03 10:26:46', 0),
('05644e8b-9795-4744-8d09-0658e4b1809a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"10\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:28:27', '2026-07-27 02:08:37', 0),
('062dacff-8d5c-4208-ace7-26e1e65f90b5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:13', '2026-08-03 09:13:44', 0),
('0667cd41-1ca1-4279-a944-a13a856e0b08', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"ssssssssss\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:07:17', '2026-07-27 02:08:37', 0),
('06d20008-235d-11f1-9647-10683825ce81', NULL, 'Welcome', 'Thank you for regitering with STEP Platform.', 'system', 1, '2026-07-27 02:08:37', '2026-03-20 13:30:00', '2026-07-27 02:08:37', 0),
('06d33eb0-9160-4c2f-93f0-7b7fbb31e1c9', NULL, 'Project Approved', 'Project \"2\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:56:43', '2026-07-27 02:08:37', 0),
('072fa45b-bd91-4607-934e-884171940d4e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" for project \"qwerty\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:19', '2026-08-03 09:13:44', 0),
('07e83bf1-57af-4d02-ae9b-8d4c1179a263', NULL, 'Project Approved', 'Project \"10\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:28:36', '2026-07-27 02:08:37', 0),
('0810ecb3-1dd8-4ac4-895b-2f769fdbad7e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"test\" was rejected. Reason: test', 'project', 0, NULL, '2026-08-03 11:40:50', '2026-08-03 11:40:50', 0),
('08c2488b-2549-4754-876a-fc6c6277ba29', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:21', '2026-08-03 09:13:44', 0),
('097bc388-d05b-4820-aafd-3522d03516ba', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"3\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-07-27 02:08:37', '2026-07-26 14:05:12', '2026-07-27 02:08:37', 0),
('0a114bdf-909e-4714-aa4f-3a4a145a5391', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"dddddddddd\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 03:16:37', '2026-08-03 09:13:44', 0),
('0a2cf050-9231-4d0f-83ba-695917a586e0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"TESTb\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-08-03 13:38:07', '2026-08-03 13:38:07', 0),
('0b9494e0-c54b-42dd-84c3-2db75c2b9252', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:31', '2026-08-03 09:13:44', 0),
('0cf4fcda-16a0-4a26-ab15-49cd414a0a71', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" for project \"qwerty\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:13', '2026-08-03 09:13:44', 0),
('0fb830d5-b4d2-40a7-83db-8d2b15f2f358', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:55', '2026-08-03 09:13:44', 0),
('0fbaf4aa-e8cd-4dd9-a724-2f221badf1f7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:40:59', '2026-08-03 09:13:44', 0),
('108391e7-97a9-4bc5-acb9-7c184e198c34', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"LAST\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:31:55', '2026-08-03 14:31:55', 0),
('11801b50-75aa-4857-ba2b-61869e4d2a88', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"qweert\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:09', '2026-08-03 09:13:44', 0),
('118af6bc-94a3-4826-99eb-ffe080d2c943', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:08', '2026-08-03 09:13:44', 0),
('14cece7e-748c-4c93-b7ab-6aaf75186086', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwerrty\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:31:28', '2026-08-03 09:13:44', 0),
('15f93216-d2d0-4b53-8a57-00b08c76beaa', NULL, 'Project Approved', 'Project \"TEST1\" has been approved.', 'project', 0, NULL, '2026-08-03 13:24:19', '2026-08-03 13:24:19', 0),
('1732259e-d6e6-44cf-9bc7-beab7ad63164', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:32:53', '2026-08-03 09:13:44', 0),
('174966c8-5528-4b8c-bb0e-b7ab5a0531ef', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"5\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:04:55', '2026-07-27 02:08:37', 0),
('18ca3bc7-07e7-42e5-b595-b374332b1960', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:12', '2026-08-03 09:13:44', 0),
('1916b2b7-9ffd-4cd6-8e5d-079dffa0a032', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"1234\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:18', '2026-08-03 09:13:44', 0),
('19b23520-23e4-4378-a20d-a8c3dcf21731', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"2\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:56:36', '2026-07-27 02:08:37', 0),
('1a4c7bf9-e6d7-46eb-b169-7c9dc1718c77', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"tttttttttttt\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 11:36:59', '2026-08-03 11:36:59', 0),
('1a94b4db-827d-4117-bb36-dcf977a117f2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Rejected', 'Ledger entry for project \"LAST\" was rejected. Reason: adsa', 'ledger', 0, NULL, '2026-08-03 15:31:55', '2026-08-03 15:31:55', 0),
('1a9a3160-8f3e-4448-a9e1-ee38fe74f0bf', NULL, 'Project Approved', 'Project \"janiiiiii\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:04:00', '2026-07-27 02:08:37', 0),
('1b5d7da4-c24b-407b-acf0-9653facb1359', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"1234\"\" for project \"Hingi\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:34:48', '2026-08-03 09:13:44', 0),
('1b8b34fd-7542-438f-b06c-15e0e3e15bac', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" for project \"qwerty\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:28:38', '2026-08-03 09:13:44', 0),
('1c46baad-9e03-4a96-b407-6189bf15b78c', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:15:30', '2026-08-03 09:13:44', 0),
('1cd062c0-7be3-42ba-8ffa-733111c406d2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:36:54', '2026-08-03 09:13:44', 0),
('1d00ddd3-6e49-4937-8dda-de0a064b7a55', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qweert\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:40:27', '2026-08-03 09:13:44', 0),
('1da238b5-bf04-46e1-bf63-de3556a2d245', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" in project \"hi\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:23', '2026-08-03 09:13:44', 0),
('20e7ce1a-83c4-4123-905a-d71577aeac56', NULL, 'Project Approved', 'Project \"TETSTTT\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:36:27', '2026-08-03 09:13:44', 0),
('21436872-a24a-4b86-ae70-7f194242c0e6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:04', '2026-08-03 09:13:44', 0),
('2144078f-5922-42e1-985c-29788210dd94', NULL, 'Project Approved', 'Project \"rrrrrr\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:37:43', '2026-07-27 02:08:37', 0),
('22d111dd-a092-4e50-bb80-5483d3463e45', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:19', '2026-08-03 09:13:44', 0),
('23d38d00-b663-42f7-9a92-36485a216e85', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwerrr\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:20:49', '2026-08-03 09:13:44', 0),
('2493f7b6-32ed-45d9-915e-d7799a2189af', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"rttt\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:55:45', '2026-08-03 12:55:45', 0),
('25dfd386-a911-4e45-a192-3d898247148f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"run\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 01:19:39', '2026-08-03 09:13:44', 0),
('25f37ee6-233e-4565-876f-d7b58970185f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:38', '2026-08-03 09:13:44', 0),
('272f041b-80dd-4bb9-858d-f281e6a08306', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qweee\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:39:35', '2026-08-03 09:13:44', 0),
('278b0b64-30e7-49fc-9423-94f3f85493ee', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"LASt - A\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-08-03 15:32:10', '2026-08-03 15:32:10', 0),
('27c2dae8-af36-4b82-a479-05d5c5cebd3e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"tttttttttttttt\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:42:03', '2026-07-27 02:08:37', 0),
('2851353f-2104-43a9-8d4b-2c7b28790b19', NULL, 'Project Approved', 'Project \"MONEY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:47:28', '2026-08-03 09:13:44', 0),
('28e60ac7-2eae-40d6-a938-be78e36454e0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"123\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 09:30:50', '2026-08-03 09:13:44', 0),
('297bf9c0-80a5-4c9e-b298-d34ab129d003', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:12', '2026-08-03 09:13:44', 0),
('2aea737b-bf82-4086-906b-708bab0e381f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-08-03 13:36:18', '2026-08-03 13:36:18', 0),
('2b0e325e-270f-4b3f-a3ec-2578a023ea71', NULL, 'Project Approved', 'Project \"MONEYY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:11:10', '2026-08-03 09:13:44', 0),
('2b99357b-f3a9-443b-87b0-2128bb04151b', NULL, 'Project Approved', 'Project \"eeeeeeeeeee\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:48:30', '2026-07-27 02:08:37', 0),
('2c29e5be-4de1-45d5-9add-53c9ec954a85', NULL, 'Project Approved', 'Project \"maney\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:30:06', '2026-08-03 09:13:44', 0),
('2d01c542-ad9d-427b-b451-b42dedb3f15f', NULL, 'Project Approved', 'Project \"MONEYYYYYYY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:54:56', '2026-08-03 09:13:44', 0),
('2daecd19-1319-41a9-b470-a8fd679c9751', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"PAHINGII\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:57:29', '2026-08-03 09:13:44', 0),
('2effda0b-b552-4999-9850-9a6ce5387adc', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwerty\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 09:32:22', '2026-08-03 09:13:44', 0),
('2faca93e-c753-49ca-8dd5-e904a0ee53a8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-08-03 14:53:58', '2026-08-03 14:53:58', 0),
('30563b05-5639-4b0c-a87c-c01df6c82faf', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"1234\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:26', '2026-08-03 09:13:44', 0),
('305ee023-14fe-4864-9343-dcaec4d11a7b', NULL, 'Project Approved', 'Project \"8\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:18:14', '2026-07-27 02:08:37', 0),
('309e1c05-394a-4587-a49e-856b76ad7969', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:00', '2026-08-03 09:13:44', 0),
('31ca38a2-c267-43ee-a91f-b4187c692faa', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:22', '2026-08-03 09:13:44', 0),
('3375fa9a-4eaf-44d1-a078-a83532fb87fc', NULL, 'Project Approved', 'Project \"1234\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:43:15', '2026-08-03 09:13:44', 0),
('34164232-e126-4493-8551-d10bf76ebff8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:24', '2026-08-03 09:13:44', 0),
('3428330f-da21-4a42-befa-a0f6af57d387', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"4\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:00:55', '2026-07-27 02:08:37', 0),
('34e4ecb4-f5e3-4311-9c67-aa1e636f0935', NULL, 'Project Approved', 'Project \"eeeeeeeee\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:09:29', '2026-07-27 02:08:37', 0),
('34f4f2d6-1229-4329-a0c7-58f28f609013', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"123\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:25:34', '2026-08-03 14:25:34', 0),
('37f9c37f-dd1d-4b5c-b8e9-e902a236bfe5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:23', '2026-08-03 09:13:44', 0),
('38d54a1f-92e9-43ee-9bea-32c2ca6daeed', NULL, 'Project Approved', 'Project \"ssssssssss\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:07:25', '2026-07-27 02:08:37', 0),
('39227088-1d98-4897-9c6f-3654464a67df', NULL, 'Project Approved', 'Project \"money\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:41:57', '2026-08-03 09:13:44', 0),
('3b10641c-4dee-44f4-8279-4af34ff124bf', NULL, 'Project Approved', 'Project \"qwer\" has been approved.', 'project', 0, NULL, '2026-08-03 14:06:24', '2026-08-03 14:06:24', 0),
('3ba6e704-2c32-41c6-92b3-8ee691d4fcb0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"qweert\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:22', '2026-08-03 09:13:44', 0),
('3bee610c-7b39-4039-bac1-8534f4ce9792', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"naji\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 01:21:48', '2026-08-03 09:13:44', 0),
('3e15dd33-2d19-4f15-9209-36fbbc3cd858', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:39', '2026-08-03 09:13:44', 0),
('3e732a11-7ba8-4db3-8b82-c4f2226daf4f', NULL, 'Project Approved', 'Project \"5\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:05:07', '2026-07-27 02:08:37', 0),
('3f51c983-3f7f-4419-9c96-1f5c1c0f8804', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:53:54', '2026-08-03 09:13:44', 0),
('3fca6aaf-cb3f-4c2d-ac04-05b50ec822e7', NULL, 'Project Approved', 'Project \"12\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:38:03', '2026-07-27 02:08:37', 0),
('407c6481-9596-47f7-a94d-48024b00e99d', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"Hingi\"\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:31', '2026-08-03 09:13:44', 0),
('408c9248-7886-4e68-a1c2-2a009482be7c', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:00', '2026-08-03 09:13:44', 0),
('424d9c83-e091-406c-9cf6-fb1c21129f81', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:18', '2026-08-03 09:13:44', 0),
('42699c67-12c0-4c54-8126-d26083fb9751', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:07', '2026-08-03 09:13:44', 0),
('427813ec-f3fa-4b37-aa9d-0978e913bd0d', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:07:09', '2026-08-03 09:13:44', 0),
('436a16c9-a402-4986-b97c-5e7bf3622e8d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"1234\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:43:06', '2026-08-03 09:13:44', 0),
('43e59aa4-1c7b-4e4d-8c75-41e306bbcedd', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:52', '2026-08-03 09:13:44', 0),
('45208772-d3bf-430e-b59f-172f482d73cf', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"7\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:16:58', '2026-07-27 02:08:37', 0),
('49412f60-6148-4c31-abd1-ee6a2b40b667', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"TEST\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:07:01', '2026-08-03 09:13:44', 0),
('4959dbf3-0ed8-461a-976d-19e0119cc67c', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:34:08', '2026-08-03 09:13:44', 0),
('4a13322a-9752-41ef-929b-e3c0a6d7290f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"hi\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:07:23', '2026-08-03 09:13:44', 0),
('4a31bd6b-8071-4e19-88be-9f451df78a15', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:04', '2026-08-03 09:13:44', 0),
('4b32b640-34b1-4cf8-8ef4-72332fcc5ca7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"testttt\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:38:33', '2026-08-03 09:13:44', 0),
('4c37f69c-3069-4ea1-8142-aa5c073b58ee', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"TEST1\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 13:24:07', '2026-08-03 13:24:07', 0),
('4cb8638e-b203-4a35-9cda-e8e315d82d44', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-08-03 10:29:27', '2026-08-03 10:29:27', 0),
('4cdeded0-c166-43f2-9615-8fefdeab296a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"Hingi\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:46:57', '2026-08-03 09:13:44', 0),
('4da6cf49-0776-4840-a41b-0a1e715265e4', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 10:21:53', '2026-08-03 09:13:44', 0),
('4dbd25bc-e5e3-4ed4-b50f-aa589404a643', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwerty\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:10:43', '2026-08-03 09:13:44', 0),
('4e28dca5-5459-41ff-95a8-e9208732691c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"TEST\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:04:27', '2026-08-03 09:13:44', 0),
('500770c5-1ba0-442e-8a59-40aefc703966', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:37:33', '2026-08-03 09:13:44', 0),
('50d24c96-38bd-4dcd-99db-105442de8908', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qweeeeeee\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-01 23:58:40', '2026-08-03 09:13:44', 0),
('517d34b6-406d-4432-bf86-dce49c9e141a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"hiram\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 11:12:48', '2026-08-03 09:13:44', 0),
('51fe8bbe-be86-4508-be1f-cd34e110513e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:19', '2026-08-03 09:13:44', 0),
('52a6885b-e9f7-419c-a400-f58241e75880', NULL, 'Project Approved', 'Project \"LASt - A\" has been approved.', 'project', 0, NULL, '2026-08-03 14:33:09', '2026-08-03 14:33:09', 0),
('52e5db5c-8715-439e-91bc-a6b1458f6610', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"testtt\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:22:25', '2026-08-03 12:22:25', 0),
('52fdd4ae-dd63-42c9-8a24-ef6a74af17d5', NULL, 'Project Approved', 'Project \"c\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:00:59', '2026-07-27 02:08:37', 0),
('53a76c7e-09f4-4e01-b500-2aa4bc42d785', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:36', '2026-08-03 09:13:44', 0),
('53a810ca-c2f6-4486-9567-aa10ce53a10f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"6\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:08:36', '2026-07-27 02:08:37', 0),
('54a2aaa2-a0f7-45ce-a9ab-ede180942526', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"h\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:05:06', '2026-07-27 02:08:37', 0),
('55c0140c-2594-4747-9014-447464b7b0a4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"MONEY\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:30', '2026-08-03 09:13:44', 0),
('55d3d5f4-bcca-43ff-b258-976780e505fe', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:40:57', '2026-08-03 09:13:44', 0),
('55f788c0-cb11-4202-a0a4-5a464baf2dff', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"adasda\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:46:43', '2026-08-03 12:46:43', 0),
('56e6441f-8029-4bac-bd4d-4a1861a59a21', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"weee\" was rejected. Reason: weee', 'project', 0, NULL, '2026-08-03 12:54:44', '2026-08-03 12:54:44', 0),
('5c8951ab-73e8-4fac-9b50-f65d3747f9e8', NULL, 'Project Approved', 'Project \"oooooo\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:28:35', '2026-07-27 02:08:37', 0),
('5c8f6baa-5f3c-4072-a385-674073d9a9e6', NULL, 'Project Approved', 'Project \"dddddddddd\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:13:24', '2026-07-27 02:08:37', 0),
('5e17ad3d-5e6f-4d56-8a5c-7ffe6a6b6953', NULL, 'Project Approved', 'Project \"qqqqqqqqqqq\" has been approved.', 'project', 0, NULL, '2026-08-03 10:28:24', '2026-08-03 10:28:24', 0),
('5f16d0b3-7839-475f-82f3-8ac06734b2b8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:15', '2026-08-03 09:13:44', 0),
('5f336e46-9d76-416f-b67a-08708617fdaf', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 09:32:36', '2026-08-03 09:13:44', 0),
('5f337a8e-8432-496e-a904-16a0c22fb905', NULL, 'Project Approved', 'Project \"hi\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:08:28', '2026-08-03 09:13:44', 0),
('5fd9405c-9295-4a2e-b494-363e7e0f323c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"1234\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 03:08:19', '2026-08-03 09:13:44', 0),
('608a1ee3-b558-4ec0-9fbb-4eb360aab43f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:37:36', '2026-08-03 09:13:44', 0),
('608e76b2-953b-49ca-afcd-2324ebf77744', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"123\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 10:28:54', '2026-08-03 09:13:44', 0),
('616a2de6-1f13-445c-8178-a996215fd5b4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"weee\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:44:53', '2026-08-03 12:44:53', 0),
('6211cc57-5279-4e7c-9572-a6ee944f8dbe', NULL, 'Project Approved', 'Project \"5555555\" has been approved.', 'project', 0, NULL, '2026-08-03 14:16:47', '2026-08-03 14:16:47', 0),
('63bde57c-3224-4cc2-8e0d-92ca285283d6', NULL, 'Project Approved', 'Project \"rrrrrrrr\" has been approved.', 'project', 0, NULL, '2026-08-03 13:54:30', '2026-08-03 13:54:30', 0),
('66faa930-473f-4a82-b35f-c301933ca00b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" for project \"hi\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:23', '2026-08-03 09:13:44', 0),
('6703a856-8ec1-496a-9483-c9a5eea089a2', NULL, 'Project Approved', 'Project \"7\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:17:05', '2026-07-27 02:08:37', 0),
('67208edf-45c9-4c6b-850b-be6564789928', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"runnnnnnnn\" has been approved.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 01:33:46', '2026-08-03 09:13:44', 0),
('67a93054-dfb8-4275-8dba-f04263ce8c25', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"UPLOAD\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 09:26:38', '2026-08-03 09:26:38', 0),
('67b40e2c-cbdd-4011-9a05-8d19d3a11266', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:19', '2026-08-03 09:13:44', 0),
('6831e653-0ddc-4a27-8986-816e0434775c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwerty\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:40:43', '2026-08-03 09:13:44', 0),
('6867479d-789d-4bb7-9960-7c0dac98f721', NULL, 'Project Approved', 'Project \"rrrr\" has been approved.', 'project', 0, NULL, '2026-08-03 12:35:08', '2026-08-03 12:35:08', 0),
('69066518-9d5a-4004-93e0-d220e49124cb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"12\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:37:56', '2026-07-27 02:08:37', 0),
('69d468aa-a2ad-4dda-aa63-45f378734185', NULL, 'Project Approved', 'Project \"wwowow\" has been approved.', 'project', 0, NULL, '2026-08-03 09:38:42', '2026-08-03 09:38:42', 0),
('6b4a9f00-1bfd-4a85-ab8a-3a67dc6b511f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:17', '2026-08-03 09:13:44', 0),
('6be78fa1-cdcf-47e9-bea8-f8aaff94e3bc', NULL, 'Project Approved', 'Project \"LAST\" has been approved.', 'project', 0, NULL, '2026-08-03 14:32:07', '2026-08-03 14:32:07', 0),
('6beaaddb-52f7-4519-b64c-35cdae9fce43', NULL, 'Project Approved', 'Project \"9\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:21:57', '2026-07-27 02:08:37', 0),
('6e78a0ee-eb34-4957-a37d-7f58fc7de45a', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:11:23', '2026-08-03 09:13:44', 0),
('708af490-14bb-4edd-9eb2-eec12308befe', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"hiram\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:01:31', '2026-08-03 09:13:44', 0),
('70c6687e-1bfc-49c8-ac87-bbe783c0cb2c', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:18', '2026-08-03 09:13:44', 0),
('71fb52b5-5f67-4fe3-9028-b1bec755bd10', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"sadfsad\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 00:38:49', '2026-08-03 09:13:44', 0),
('736d2d71-a2d9-4aaa-81ce-9b5dbfca5421', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:35:27', '2026-08-03 09:13:44', 0),
('738b8734-312a-41af-8a7a-04f724d0959f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"TESTb\" has been approved.', 'ledger', 0, NULL, '2026-08-03 13:39:17', '2026-08-03 13:39:17', 0),
('74e2d911-25a9-4bb7-b953-3ff8d0b09c71', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"5555555\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:16:34', '2026-08-03 14:16:34', 0),
('7760a24c-a83b-457c-b384-75268802cfa5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"hiram\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:33:59', '2026-08-03 09:13:44', 0),
('77ed509f-c7e5-4593-b5ee-4c5c2afbf8d0', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:32:28', '2026-08-03 09:13:44', 0),
('78b0e9bf-f1d5-4195-8d04-0a7f2e674fc4', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:42:13', '2026-08-03 09:13:44', 0),
('78b95d62-ae62-4c43-b688-2921704d0d41', NULL, 'New Meeting Scheduled', 'A new meeting titled \'wow\' has been scheduled for July 31, 2026, 1:16 PM', 'meeting', 1, '2026-08-03 09:13:44', '2026-08-03 03:14:28', '2026-08-03 09:13:44', 0),
('7caacb72-340d-46d7-a244-c972ce67c9a3', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"11\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:37:06', '2026-07-27 02:08:37', 0),
('7cc565c6-ab98-4df8-b0a8-d70f30298ecf', NULL, 'Project Approved', 'Project \"h\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:05:36', '2026-07-27 02:08:37', 0),
('7d2ade05-4179-45fd-94b6-37a9df84c785', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"hi\"\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:26', '2026-08-03 09:13:44', 0),
('7d3fb232-8a7b-421e-9007-406a153cc5fe', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"aaaaaaa\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:04:51', '2026-07-27 02:08:37', 0),
('7d448e11-1df0-49e5-93b5-182afa48f860', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"ffffffffff\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:47:59', '2026-07-27 02:08:37', 0),
('7f4242c6-4ecf-43a3-8318-95bcc50ed463', NULL, 'Project Approved', 'Project \"qweert\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:40:35', '2026-08-03 09:13:44', 0),
('7f5af4a7-534b-44a3-9078-b54c54ee8f88', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:27:39', '2026-08-03 09:13:44', 0),
('81ceca17-7058-43ef-8517-01a7c3de14fa', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"eeeeeeeeeee\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:47:51', '2026-07-27 02:08:37', 0),
('834e0830-0c59-4fc0-8e19-e61dc6c9cb24', NULL, 'Project Approved', 'Project \"TEST\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:04:35', '2026-08-03 09:13:44', 0),
('83b8df3a-368a-4ab4-924b-fae197f5ed7b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"MONEYYYYYYY\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:54:45', '2026-08-03 09:13:44', 0),
('8421ead9-11a9-4484-ac5c-45a8de313eda', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"test\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 11:40:11', '2026-08-03 11:40:11', 0),
('85c5312f-7611-4e9d-bd99-988d72d41e7b', NULL, 'Project Approved', 'Project \"qoqq\" has been approved.', 'project', 0, NULL, '2026-08-03 14:20:41', '2026-08-03 14:20:41', 0),
('86016520-2344-4279-97ef-f22bf4b685d6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:29', '2026-08-03 09:13:44', 0),
('86986c7e-14f2-4267-930c-9c232e9d8010', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"MANEY\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:32:37', '2026-08-03 09:13:44', 0),
('8796fcbe-c95a-4a35-aee8-40043986fef2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:21', '2026-08-03 09:13:44', 0),
('899e7866-88b4-4e54-967b-a70635e9e805', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"MONEY\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:47:18', '2026-08-03 09:13:44', 0),
('8a571654-f104-4e6b-b99c-3c10c88d95e5', NULL, 'Project Approved', 'Project \"MOENYYY\" has been approved.', 'project', 0, NULL, '2026-08-03 12:42:10', '2026-08-03 12:42:10', 0),
('8a9a2859-72fb-4169-be60-231f010df63d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"eee\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 10:34:30', '2026-08-03 10:34:30', 0),
('8b87da40-112c-4a89-88ef-47831caba71e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:13', '2026-08-03 09:13:44', 0),
('8bdb35da-c25d-4053-98c1-95cd07d5349e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-08-03 14:15:25', '2026-08-03 14:15:25', 0),
('8bf37ad4-4fd0-4b27-9108-d900edf36525', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:29', '2026-08-03 09:13:44', 0),
('8c14d2c5-84d4-461d-aae2-9cc18beb1055', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qqqqqq\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:05:44', '2026-07-27 02:08:37', 0),
('8ddc6815-32c7-4686-9d03-57155520a0a8', NULL, 'Project Approved', 'Project \"testtt\" has been approved.', 'project', 0, NULL, '2026-08-03 12:22:54', '2026-08-03 12:22:54', 0),
('8ebb94be-4be1-4b6b-94de-43cb813fb9f6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"MONEYY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:50', '2026-08-03 09:13:44', 0),
('8fe8b8e5-ce1d-4891-86f9-1ea18c5ffa51', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"6\"\" in project \"3\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:37', '2026-08-03 09:13:44', 0),
('90e779a0-3c7f-450d-8a41-d6ebb4cb1b9f', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:50:13', '2026-08-03 09:13:44', 0),
('9112eee8-4627-4e1b-b6e1-e419b37231a6', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"MONEY\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:30', '2026-08-03 09:13:44', 0),
('916e82f2-4913-4e36-bc71-b13d34a1d3be', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:18', '2026-08-03 09:13:44', 0),
('93d44420-4256-489f-800a-2137b622ba93', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"test2\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:39:13', '2026-08-03 09:13:44', 0),
('94008543-43d3-4ae9-b880-eb85a1abb115', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"6\"\" for project \"3\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:37', '2026-08-03 09:13:44', 0),
('94df3500-8279-4a41-9fff-b793ae77931b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"TESTb\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 13:26:07', '2026-08-03 13:26:07', 0),
('9650b858-3f09-4717-a4bd-5a754f8108c5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:37:33', '2026-08-03 09:13:44', 0),
('97a40d8a-a58f-407b-bf9b-13c435a74ca8', NULL, 'Project Approved', 'Project \"aaaaaaa\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:05:00', '2026-07-27 02:08:37', 0),
('97b3b00a-6c89-41eb-99a7-a86fecadce1e', NULL, 'Project Approved', 'Project \"qweee\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:39:49', '2026-08-03 09:13:44', 0),
('9804da7c-13fc-49ec-955e-8bca79d8ded2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"c\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:00:52', '2026-07-27 02:08:37', 0),
('982b1b62-45bd-4483-9a47-4ec5c3dd3b2c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"wwowow\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 09:38:25', '2026-08-03 09:38:25', 0),
('985eba39-d07f-4213-ae3f-292b40eee106', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"MOENYYY\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:37:01', '2026-08-03 12:37:01', 0),
('993dd1de-2533-49c3-97b8-094e05fb5052', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:24', '2026-08-03 09:13:44', 0),
('9b7d32a2-59af-4312-8116-36a895f29bfb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:46:41', '2026-08-03 09:13:44', 0),
('9bc42710-8cbb-474c-a3e9-bde34ce8751f', NULL, 'Project Approved', 'Project \"qqqqqq\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:06:05', '2026-07-27 02:08:37', 0),
('9c922650-2ce0-4d62-b797-2f43ae795e90', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"LAST\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-08-03 15:15:27', '2026-08-03 15:15:27', 0),
('9e8189f6-a9c6-441f-a5fd-a463cad28989', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"8\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:18:07', '2026-07-27 02:08:37', 0),
('9ef5b4cb-a246-491e-8e43-a4207b824ec5', NULL, 'Project Approved', 'Project \"UPLOAD\" has been approved.', 'project', 0, NULL, '2026-08-03 09:31:18', '2026-08-03 09:31:18', 0),
('9f96a345-44a1-4b9b-aa00-bac70557a5bb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"LASt - A\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-08-03 15:01:31', '2026-08-03 15:01:31', 0),
('a015ea8a-7740-4881-b5f3-a49c347f598d', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:28:22', '2026-08-03 09:13:44', 0),
('a0ef13c8-bebf-44bf-acdd-74b2cf208fa8', NULL, 'Project Approved', 'Project \"test2\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 04:42:56', '2026-08-03 09:13:44', 0),
('a122c480-588d-49e0-bcfe-55652a09a7c2', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:26', '2026-08-03 09:13:44', 0),
('a14a6f64-675b-4481-998d-f99b5089941b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"jani\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:42:41', '2026-08-03 09:13:44', 0),
('a287955b-4f0e-45a8-91d1-50599c071e02', NULL, 'Project Approved', 'Project \"Hingi\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:47:18', '2026-08-03 09:13:44', 0);
INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `read_at`, `created_at`, `updated_at`, `archive`) VALUES
('a47c2ec8-b7a5-43e8-a9d0-9ebbc87c2361', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 00:44:30', '2026-08-03 09:13:44', 0),
('a56ae726-88a2-496d-b179-4d0017935251', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"runnnnnnnn\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 01:27:31', '2026-08-03 09:13:44', 0),
('a5a3e787-e8bf-42ab-8198-17bb49bfb19a', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"vvvv\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 01:57:41', '2026-07-27 02:08:37', 0),
('a6a7982a-b474-4b33-bf6c-0a5b6d5e22cd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"eeeeeeeee\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:08:44', '2026-07-27 02:08:37', 0),
('a6bee51e-8908-4a89-b136-969d7ee4afb2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"rrrrrrrr\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 13:54:17', '2026-08-03 13:54:17', 0),
('a934e89f-8f4d-4df7-a4bd-c73bd9b09cb9', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:46:41', '2026-08-03 09:13:44', 0),
('a97972ca-d92f-4717-b0cc-ff5475245f66', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"9\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:21:49', '2026-07-27 02:08:37', 0),
('abcf70b8-d485-4de0-8785-4a13faaf5d90', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:15', '2026-08-03 09:13:44', 0),
('acc3a3f8-3993-4fc5-b2d2-c83b1987b799', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"dddddddddd\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 14:13:17', '2026-07-27 02:08:37', 0),
('adcd9086-e384-47a4-bfd3-f40a69b0e72b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"1\" has been approved.', 'ledger', 1, '2026-07-27 02:08:37', '2026-07-26 12:57:30', '2026-07-27 02:08:37', 0),
('ae025615-997e-49bc-8d40-35f2240857f1', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:23', '2026-08-03 09:13:44', 0),
('ae1869a1-c265-40f9-9645-8b4bcc31bb86', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:23:07', '2026-08-03 09:13:44', 0),
('ae693e68-ee00-4e44-848f-52c245c62b1e', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:26', '2026-08-03 09:13:44', 0),
('af76151e-8c1d-4d2e-aabe-488ef9f54eb1', NULL, 'Project Approved', 'Project \"errr\" has been approved.', 'project', 0, NULL, '2026-08-03 14:08:21', '2026-08-03 14:08:21', 0),
('b0e942cb-a8e7-4365-9bd2-65da44cb0f2f', NULL, 'Project Budget Synced from Ledger', 'Synchronized 2 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:10', '2026-08-03 09:13:44', 0),
('b1cab41d-dfa7-4096-9a8b-064974facb67', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:23', '2026-08-03 09:13:44', 0),
('b2723076-aed1-432d-b5ea-30297bb17a15', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:19:17', '2026-08-03 09:13:44', 0),
('b4433f6c-a920-415d-b559-414ab86c46fc', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"Hingi\"\" for project \"1234\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:30:31', '2026-08-03 09:13:44', 0),
('b46457df-a9ae-48c5-9963-439339b69b51', NULL, 'Project Approved', 'Project \"uuuuuuuuuu\" has been approved.', 'project', 0, NULL, '2026-08-03 13:19:40', '2026-08-03 13:19:40', 0),
('b4929146-01b5-4913-86af-d1cab7c4fa38', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:53:54', '2026-08-03 09:13:44', 0),
('b4a00878-3879-4e2b-ad90-22fb0ebaeac5', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:44:09', '2026-08-03 09:13:44', 0),
('b5e824c4-6751-469c-bebb-085b088ecede', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"eee\" was rejected. Reason: truncate', 'project', 0, NULL, '2026-08-03 11:36:10', '2026-08-03 11:36:10', 0),
('b6a23ac9-c7bb-4003-ad0b-f9c237705a7c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"rttt\" was rejected. Reason: rttt', 'project', 0, NULL, '2026-08-03 12:56:02', '2026-08-03 12:56:02', 0),
('b8508dd1-ff96-4ddf-9902-f7382c04d35e', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"maney\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:29:59', '2026-08-03 09:13:44', 0),
('b87bd253-dc78-4614-bcc7-59af2ed0a515', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:41', '2026-08-03 09:13:44', 0),
('b8d80f8e-e316-4c6d-9f28-41ce3a80f860', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"TEST\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:09:54', '2026-08-03 09:13:44', 0),
('b942b787-0f2e-4d18-9664-c841c9fe0eb4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" for project \"qwerty\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:53:29', '2026-08-03 09:13:44', 0),
('b9582ac5-6c5f-4ad6-bb5f-7547b4ea2bdb', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:27:39', '2026-08-03 09:13:44', 0),
('b9ff62b5-8f39-4fb1-a495-25c84384b929', NULL, 'Project Approved', 'Project \"tttttttttttttt\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:42:39', '2026-07-27 02:08:37', 0),
('bb2a5258-79f3-4667-9f46-b4831f4c2b60', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 00:44:30', '2026-08-03 09:13:44', 0),
('bdd68846-53ef-4e56-972c-c303b958fd62', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 23:53:50', '2026-08-03 09:13:44', 0),
('be4bb7c4-3541-4fb9-ae83-6ec5edf62217', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 10:29:12', '2026-08-03 09:13:44', 0),
('be8d6e05-0758-4c15-95ec-15908e98fe45', NULL, 'Project Approved', 'Project \"dddddddddd\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:14:25', '2026-08-03 09:13:44', 0),
('c02b33da-9208-4a44-8107-488175e6e0cb', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" for project \"TETSTTT\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:14', '2026-08-03 09:13:44', 0),
('c24a7ef0-6f72-49da-a8e7-f2248d1d9f30', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:19', '2026-08-03 09:13:44', 0),
('c5ac1e84-31f7-40d2-bfbf-0ec98f8f676f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"123\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:35:10', '2026-08-03 09:13:44', 0),
('c5bc4822-e4e8-4b43-86c0-53e4f5f4800e', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 0, NULL, '2026-08-03 14:34:22', '2026-08-03 14:34:22', 0),
('c622772a-7163-4f03-b5f2-9874b8ef0fec', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TEST\"\" in project \"qwerty\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:28:38', '2026-08-03 09:13:44', 0),
('c634fbf0-dbfd-46af-a322-cc3b002fc95c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"hi\"\" for project \"TEST\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:25:25', '2026-08-03 09:13:44', 0),
('cb0f42ce-4260-40b4-9a4f-0b969fa357d7', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:41:32', '2026-08-03 09:13:44', 0),
('cb5065cc-2a6b-4f11-90e1-2490bb6c5022', NULL, 'Project Approved', 'Project \"6\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:08:46', '2026-07-27 02:08:37', 0),
('cc0b6d8b-53db-485c-99db-b25fe79ec9c5', NULL, 'Project Approved', 'Project \"11\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:37:13', '2026-07-27 02:08:37', 0),
('cc4b1660-c431-4e2b-a902-9c053632e2d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"tttttttttttt\" was rejected. Reason: truncate', 'project', 0, NULL, '2026-08-03 11:37:11', '2026-08-03 11:37:11', 0),
('cccff49b-16f8-4975-853f-2d8c2d12e6cf', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 0, NULL, '2026-08-03 14:25:47', '2026-08-03 14:25:47', 0),
('cda8dfb2-39cf-40d0-9b35-051ace79ae44', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"123\" was rejected. Reason: qwerty', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 09:34:07', '2026-08-03 09:13:44', 0),
('cf2ae4f8-9f6d-4c0d-8f0e-f9fbce9ce1e0', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"money\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 06:41:50', '2026-08-03 09:13:44', 0),
('cf33d77c-fb26-46a5-a685-dfe8867f2078', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"2\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:38:24', '2026-08-03 09:13:44', 0),
('d1f665cc-a994-4718-a8c2-f28242f6e494', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qoqq\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:20:28', '2026-08-03 14:20:28', 0),
('d2deb2db-fa96-4aa8-8023-a0ab09ad7eca', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"runnnnnnnn\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 01:33:27', '2026-08-03 09:13:44', 0),
('d419aeb3-2e2d-4577-b20a-fa6ff96cebd9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:20:10', '2026-08-03 09:13:44', 0),
('d51f1483-96c3-4991-a5c7-ed3c6f237798', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:19', '2026-08-03 09:13:44', 0),
('d5cbb432-79fe-4e0e-91bf-6ace92c33dc6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"TETSTTT\"\" for project \"qwerty\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:36', '2026-08-03 09:13:44', 0),
('d66fdf23-b05d-4062-992b-569e86ad9d1c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"dvvvvv\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:12:49', '2026-07-27 02:08:37', 0),
('d6c437a1-c989-4777-a0ab-3b976cceece2', NULL, 'Project Approved', 'Project \"MANEY\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 12:32:50', '2026-08-03 09:13:44', 0),
('d6e1ae84-0c29-4b11-ba22-a07c5b7a2f23', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"iiiiii\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:43:17', '2026-07-27 02:08:37', 0),
('d825ceff-9b1e-4dc8-a7a1-80b44ebcdfe5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"dddddddddd\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 02:58:36', '2026-08-03 09:13:44', 0),
('d8306ee6-abb6-494a-9e01-9fa34704be16', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"1234\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 03:08:19', '2026-08-03 09:13:44', 0),
('d8acb13a-9ac5-40a9-8427-a11e2be599cc', NULL, 'Project Budget Synced from Ledger', 'Synchronized 3 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 14:06:12', '2026-08-03 09:13:44', 0),
('d9883633-daed-4144-b861-c4203a27da86', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"1\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-07-27 02:08:37', '2026-07-26 12:57:21', '2026-07-27 02:08:37', 0),
('d9ca93f6-1682-41d8-a379-482fbef813eb', NULL, 'Project Approved', 'Project \"runnnnnnnn\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 01:32:58', '2026-08-03 09:13:44', 0),
('da4f769d-cdbe-442d-beb5-ecd119acc5cd', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"LAST\" was submitted and is pending adviser approval.', 'ledger', 0, NULL, '2026-08-03 14:46:15', '2026-08-03 14:46:15', 0),
('dabc581a-2ce8-4831-85b8-a1906f9fd68f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"adasda\" was rejected. Reason: weee', 'project', 0, NULL, '2026-08-03 12:46:54', '2026-08-03 12:46:54', 0),
('daf5382d-5928-4e72-aafc-431251e5918f', NULL, 'Project Approved', 'Project \"hiram\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:01:40', '2026-08-03 09:13:44', 0),
('db2269ef-7990-445e-8d73-e45be1cce67c', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"rrrrrr\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:37:24', '2026-07-27 02:08:37', 0),
('dbb877b6-6a34-456d-9a66-87fb5bc78cac', NULL, 'Project Approved', 'Project \"1\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:56:00', '2026-07-27 02:08:37', 0),
('dccbcc29-5934-462d-a8cb-be4e820241c5', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"rrrr\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 12:34:29', '2026-08-03 12:34:29', 0),
('dd016282-f6f5-4bc3-8a27-7a393f13aa42', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:15', '2026-08-03 09:13:44', 0),
('dfec5384-c54f-489c-b967-6d4f3de6ae0d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"SPIDERRR\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 00:49:36', '2026-08-03 09:13:44', 0),
('e05846b2-bf2b-4680-94ab-fa8dea3a49d2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"MONEYY\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:50', '2026-08-03 09:13:44', 0),
('e17f97e7-f327-4f61-a7ad-906ce3066496', NULL, 'Project Approved', 'Project \"3\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:59:20', '2026-07-27 02:08:37', 0),
('e3badef0-f583-4b82-97bc-985ca58140e9', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:44:08', '2026-08-03 09:13:44', 0),
('e3f38fd1-6121-42c5-917d-8852312cc5df', NULL, 'Project Approved', 'Project \"testttt\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 03:38:42', '2026-08-03 09:13:44', 0),
('e464fd4f-11aa-44ee-98a6-e73188bc45af', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:08:34', '2026-08-03 09:13:44', 0),
('e6555053-3c6d-43d3-a47e-aee7d2212e06', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"LASt - A\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:32:57', '2026-08-03 14:32:57', 0),
('e7ba0e99-d273-4f62-a9d0-2c831de163b7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"dddddddddd\" has been approved.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 03:16:52', '2026-08-03 09:13:44', 0),
('e7d81340-9623-4708-a79b-0970d8743202', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"qweert\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:41:48', '2026-08-03 09:13:44', 0),
('e9ba0fce-2925-4954-9c9d-8ef00c707137', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"pahingi\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 10:24:23', '2026-08-03 09:13:44', 0),
('e9bc4cab-4e6c-49da-84e9-049afece8b4b', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project Rejected', 'Your project \"PAHINGII\" was rejected. Reason: PAHINGII', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 05:20:07', '2026-08-03 09:13:44', 0),
('ea78c0a4-2320-4664-961c-bfa48aca6228', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"TETSTTT\" has been submitted and is pending adviser approval.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 22:36:20', '2026-08-03 09:13:44', 0),
('ec9a9c1a-1d0b-4c1e-8a61-7fb84f6dc905', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"errr\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:08:07', '2026-08-03 14:08:07', 0),
('ed8f1506-31b8-428e-8a32-04c070e2b651', NULL, 'Project Approved', 'Project \"4\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 13:01:04', '2026-07-27 02:08:37', 0),
('ef459da0-8df6-43c2-84ef-454c29a08fd4', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"uuuuuuuuuu\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 13:06:02', '2026-08-03 13:06:02', 0),
('efa154b9-1b71-45f1-89eb-0c52709395b9', NULL, 'Project Approved', 'Project \"TESTb\" has been approved.', 'project', 0, NULL, '2026-08-03 13:26:39', '2026-08-03 13:26:39', 0),
('f0273b75-131d-4a95-bd58-c8bff45f9d09', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:50:32', '2026-08-03 09:13:44', 0),
('f0e84f2d-2a7f-4c49-9caa-0bd38ebfca79', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"janiiiiii\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 02:03:40', '2026-07-27 02:08:37', 0),
('f1602675-95b7-46a6-b281-7714c6ea3859', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"3\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 12:59:14', '2026-07-27 02:08:37', 0),
('f246670d-172a-491e-9f9e-548df8d3e5b8', NULL, 'Project Budget Synced from Ledger', 'Synchronized 0 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:34:24', '2026-08-03 09:13:44', 0),
('f289e7ee-bad7-427f-810f-2cc3a52bdbdf', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"LASt - A\" has been approved.', 'ledger', 0, NULL, '2026-08-03 15:02:31', '2026-08-03 15:02:31', 0),
('f36874cf-85b6-4c3a-95b6-9aa5f893f0ac', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"qwer\" has been submitted and is pending adviser approval.', 'project', 0, NULL, '2026-08-03 14:06:09', '2026-08-03 14:06:09', 0),
('f3840922-b909-45a1-bd4d-e5a2bb3f712a', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" in project \"TEST\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:09:54', '2026-08-03 09:13:44', 0),
('f40c0f78-45e4-4029-8b8c-5caf27087992', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:48:36', '2026-08-03 09:13:44', 0),
('f4a06818-c30d-4a83-8f2a-71084f667ca7', NULL, 'Project Approved', 'Project \"qwerty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-03 01:10:51', '2026-08-03 09:13:44', 0),
('f5e467a0-4d6a-4da4-aab3-0d1ac92928ba', NULL, 'Project Approved', 'Project \"qwerrty\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 14:31:38', '2026-08-03 09:13:44', 0),
('f65318c3-4825-4473-9d2f-317200dc3132', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Tampering Resolved', 'Tampered ledger entry \"Initial project budget baseline\" for project \"qweert\" was restored from the blockchain snapshot.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 01:41:48', '2026-08-03 09:13:44', 0),
('f68813ca-3561-44f1-81f0-4a2341149e5c', NULL, 'Project Budget Synced from Ledger', 'Synchronized 1 project budget(s) with approved ledger totals', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 12:06:44', '2026-08-03 09:13:44', 0),
('fa2b8b96-2705-4180-98f9-f992189ec3a8', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred from completed project \"1234\"\" in project \"Hingi\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-03 02:34:48', '2026-08-03 09:13:44', 0),
('fa8b7822-d668-4db6-828c-4f9ecb4f9f8f', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Rejected', 'Ledger entry for project \"LAST\" was rejected. Reason: sdaf', 'ledger', 0, NULL, '2026-08-03 15:31:50', '2026-08-03 15:31:50', 0),
('fbded78f-b9a2-4863-8951-5f1a130710ec', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:43:23', '2026-08-03 09:13:44', 0),
('fc7e499c-c6a4-4d3d-b274-1276cfa990aa', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger entry submitted for approval', 'Ledger entry for project \"janiiiiii\" was submitted and is pending adviser approval.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:23:49', '2026-08-03 09:13:44', 0),
('fdf24943-f024-492f-af47-de3017dfc1f2', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"oooooo\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:28:16', '2026-07-27 02:08:37', 0),
('feccd99f-be19-4bd7-be95-d28333005f8a', NULL, 'Project Approved', 'Project \"123\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 13:35:21', '2026-08-03 09:13:44', 0),
('ff31af7f-3ea8-456c-b49e-6991b554d454', NULL, 'Ledger Tampering Resolved', 'Tampered ledger entry \"Transferred to project \"qwerty\"\" in project \"TETSTTT\" was restored by EDWARD QUINTOS.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 22:51:14', '2026-08-03 09:13:44', 0),
('ff3cd146-70b0-47c6-a28d-7f00a03720d6', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Ledger Entry Approved', 'Ledger entry for project \"janiiiiii\" has been approved.', 'ledger', 1, '2026-08-03 09:13:44', '2026-08-02 00:24:01', '2026-08-03 09:13:44', 0),
('ff531b79-da83-4e4d-bccd-6b170efe9d04', NULL, 'Project Approved', 'Project \"vvvv\" has been approved.', 'project', 1, '2026-07-27 02:08:37', '2026-07-27 01:58:23', '2026-07-27 02:08:37', 0),
('ffb214cd-2c7b-4291-9deb-301f4ec9aab5', NULL, 'Project Approved', 'Project \"SPIDERRR\" has been approved.', 'project', 1, '2026-08-03 09:13:44', '2026-08-02 00:49:46', '2026-08-03 09:13:44', 0),
('ffbc6bb0-368e-4208-85a4-22ec95909e87', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'Project submitted for approval', 'Your project \"yyyyy\" has been submitted and is pending adviser approval.', 'project', 1, '2026-07-27 02:08:37', '2026-07-26 11:04:19', '2026-07-27 02:08:37', 0);

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
('09cb10ae-6c3d-44f0-bf92-6bbaece7c6de', NULL, 'LAST', 'LAST', 'LAST', 'Sports', 0.00, 1, 'LAST', 'Draft', 'LAST', 'LAST', 'storage/ledger_proofs/262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a.pdf', '262ab664e28bc3c32458a26f0a8f2f5b947160c5f0d9462e2f0b8c7c3580498a', '2026-07-01', '2026-07-08', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-08-03 14:32:07', '2026-08-03 14:31:53', '2026-08-03 14:53:58', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', 0),
('a85a7b3a-2495-4098-9c6e-6dee08de3f99', NULL, 'LASt - A', 'LASt - A', 'LASt - A', 'Sports', -99.00, 0, 'LASt - A', 'Draft', 'LASt - A', 'LASt - A', 'storage/ledger_proofs/bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053.pdf', 'bb6d6e612deffd5ccebdf938aa7f30d7269c2795931cead669c6ddeed3536053', '2026-09-10', '2026-09-30', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-08-03 14:33:09', '2026-08-03 14:32:55', '2026-08-03 15:02:31', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', 0);

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
('059f4213-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-03-19 06:29:42', '2026-03-19 06:33:46', 0),
('059f5000-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Admin/SADU', 'admin-sadu', 'Administrator with SADU (Student Affairs and Discipline Office) responsibilities - manages student discipline and welfare', '2026-05-30 20:36:18', '2026-05-31 04:47:47', 0);

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
('G0vtmM3smU8RpzkeimIi8LZkZvQBO1B8H7a2euJh', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiRFFSMkE1Wk5CRmV4Y2lFWVlKV3F2TTFWTUVQNWJjZmxsa01keGZvSyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czoyNToiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2NzZyI7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjQwOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xlZGdlci1lbnRyaWVzIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiYjA5ZTViZmItNzVmYy00YjFmLTlhMzctNGJmNTg4YmQ2YTFiIjt9', 1785745948, 1),
('qUXucCd81hDGojtDNT1dhASKqoXiP60SnJTe1qWW', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiUUp2MVBKY25JbjBzWnBoZ1k0dDJ5T2xnQkFzZHhrUDNlS21tRGgwciI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozNDoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2NzZy9wcm9qZWN0cyI7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjM1OiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvdXNlci9wcm9qZWN0cyI7czo1OiJyb3V0ZSI7czoxMzoidXNlci5wcm9qZWN0cyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtzOjM2OiI5N2JmNmMwZS00MjBiLTQ2MjctYmU4Yi0zMWYzN2Y1YmVkOWYiO30=', 1785744053, 0),
('zukfvdDjJI45yuV0Y6iIDZW7ZbSHrq0MS0S0uc0D', '087ccbc9-efa8-44e0-8435-3310207554d7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/151.0.0.0 Safari/537.36 Edg/151.0.0.0', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoid2REa082ajI4MkhhRlFLN093cmhnTkI1Q2ZnNldiZ01oSFhNMndwayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9hZHZpc2VyL2FwcHJvdmFscyI7czo1OiJyb3V0ZSI7czoxNzoiYWR2aXNlci5hcHByb3ZhbHMiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7czozNjoiMDg3Y2NiYzktZWZhOC00NGUwLTg0MzUtMzMxMDIwNzU1NGQ3Ijt9', 1785745937, 0);

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
('123', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059d226e-235d-11f1-9647-10683825ce81', 0, 'Member', '2026-05-13', '2026-05-30', 0, '2026-04-24 05:34:53', '2026-07-27 00:46:02', 0),
('12312', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059d226e-235d-11f1-9647-10683825ce81', 1, 'Vice President for External Affairs', '2026-05-28', '2026-09-18', 1, '2026-04-24 05:48:10', '2026-07-26 10:47:37', 0),
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
('123', '087ccbc9-efa8-44e0-8435-3310207554d7', '059bb388-235d-11f1-9647-10683825ce81', 1, '2026-04-24 06:30:43', '2026-05-31 11:46:27', 0);

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
('087ccbc9-efa8-44e0-8435-3310207554d7', '059ef712-235d-11f1-9647-10683825ce81', 'EDWARD QUINTOS', 'emdgquintos@kld.edu.ph', '2026-04-24 06:30:43', NULL, NULL, 0, '09234234234', '$2y$12$ez57d.qwWe0NGNJYtU0oDer2hVL6c2HIhbVWDHtQn.0kRBPeFNv6C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, NULL, 'active', '2026-08-03 09:02:24', NULL, '2026-04-24 06:30:08', '2026-08-03 09:02:24', 0),
('97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059f4170-235d-11f1-9647-10683825ce81', 'JHONNY MACAWILI SUMULONG', 'jmsumulong@kld.edu.ph', '2026-04-24 05:33:52', NULL, NULL, 0, NULL, '$2y$12$0tiBxJWX3qRNRUOr.V0UAu6MEf4y0kXAAU68YpFQQawyIpV8vukli', 'https://lh3.googleusercontent.com/a/ACg8ocLXVrWI7RGw1OTDRtjF9lXO27fk8oBLR-ZI3irgbXl_7fS5sA=s96-c', 1, NULL, 'active', '2026-08-03 09:52:18', NULL, '2026-04-24 05:33:52', '2026-08-03 09:52:18', 0),
('b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059efde1-235d-11f1-9647-10683825ce81', 'LAWRECE CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-04-24 05:48:10', NULL, NULL, 0, '09398331593', '$2y$12$./qxavDvVjZjFlfz4kxRLOdREWZJKpD76iNFbqwNLDATYRi3L3VKK', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, NULL, 'active', '2026-08-03 10:10:53', NULL, '2026-04-24 05:48:10', '2026-08-03 10:10:53', 0),
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
