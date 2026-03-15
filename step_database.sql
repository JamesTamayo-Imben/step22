-- ============================================================================
-- STEP Database Schema - COMPLETE VERSION
-- Application: STEP System (Student Transparency and Engagement Platform)
-- Framework: Laravel 11 with React/Inertia.js Frontend
-- Purpose: Student Governance & Transparency System for KLD College
-- Created: 2026-03-13
-- ============================================================================

-- Set default database properties
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- ============================================================================
-- CREATE DATABASE
-- ============================================================================
CREATE DATABASE IF NOT EXISTS `step_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `step_database`;

-- ============================================================================
-- TABLE: roles
-- Description: User roles in the system (Super Admin, Admin, CSG, Student)
-- ============================================================================
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(50) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: permissions
-- Description: Individual permissions that can be assigned to roles
-- ============================================================================
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: role_permission
-- Description: Junction table linking roles to permissions (Many-to-Many)
-- ============================================================================
CREATE TABLE `role_permission` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_permission_unique` (`role_id`, `permission_id`),
  KEY `role_permission_role_id` (`role_id`),
  KEY `role_permission_permission_id` (`permission_id`),
  CONSTRAINT `role_permission_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permission_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: users
-- Description: Core user table for authentication
-- Roles: Super Admin, Admin/Adviser, CSG Officer, Student, Ordinary Teacher
-- ============================================================================
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `status` enum('active','suspended','archived') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `last_login_at` timestamp NULL DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_role_id` (`role_id`),
  KEY `users_status` (`status`),
  CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: students
-- Description: Student-specific information
-- ============================================================================
CREATE TABLE `students` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `student_id` varchar(50) COLLATE utf8mb4_unicode_ci UNIQUE,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year') COLLATE utf8mb4_unicode_ci,
  `course` varchar(100) COLLATE utf8mb4_unicode_ci,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci,
  `adviser_id` bigint unsigned,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `students_user_id` (`user_id`),
  KEY `students_adviser_id` (`adviser_id`),
  CONSTRAINT `students_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `students_adviser_id_foreign` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: teachers
-- Description: Teacher/Faculty information (Advisers & Ordinary Teachers)
-- ============================================================================
CREATE TABLE `teachers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `employee_id` varchar(50) COLLATE utf8mb4_unicode_ci UNIQUE,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci,
  `specialization` varchar(100) COLLATE utf8mb4_unicode_ci,
  `teacher_type` enum('Ordinary','Adviser','Both') COLLATE utf8mb4_unicode_ci DEFAULT 'Ordinary',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `teachers_user_id` (`user_id`),
  CONSTRAINT `teachers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: csg_officers
-- Description: CSG (Council of Student Government) Officer information
-- ============================================================================
CREATE TABLE `csg_officers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `position` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `term_start` date,
  `term_end` date,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `csg_officers_user_id` (`user_id`),
  CONSTRAINT `csg_officers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: password_reset_tokens
-- Description: Stores password reset tokens for security
-- ============================================================================
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: sessions
-- Description: Laravel session storage table
-- ============================================================================
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`),
  CONSTRAINT `sessions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: projects
-- Description: CSG projects managed by CSG officers
-- ============================================================================
CREATE TABLE `projects` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `csg_officer_id` bigint unsigned NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci,
  `budget` decimal(12, 2),
  `spent_amount` decimal(12, 2) DEFAULT 0,
  `status` enum('planning','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'planning',
  `start_date` date,
  `deadline` date,
  `progress_percentage` tinyint DEFAULT 0,
  `members_count` int DEFAULT 0,
  `approved_by` bigint unsigned,
  `approval_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `projects_csg_officer_id` (`csg_officer_id`),
  KEY `projects_approved_by` (`approved_by`),
  KEY `projects_status` (`status`),
  CONSTRAINT `projects_csg_officer_id_foreign` FOREIGN KEY (`csg_officer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `projects_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: project_members
-- Description: Students participating in projects
-- ============================================================================
CREATE TABLE `project_members` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `student_id` bigint unsigned NOT NULL,
  `role` varchar(100) COLLATE utf8mb4_unicode_ci,
  `joined_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_members_unique` (`project_id`, `student_id`),
  KEY `project_members_project_id` (`project_id`),
  KEY `project_members_student_id` (`student_id`),
  CONSTRAINT `project_members_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `project_members_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: ledger
-- Description: Financial ledger for project expenses and budget tracking
-- ============================================================================
CREATE TABLE `ledger` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `transaction_type` enum('expense','income','adjustment') COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci,
  `amount` decimal(12, 2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned,
  `approval_status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `transaction_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ledger_project_id` (`project_id`),
  KEY `ledger_recorded_by` (`recorded_by`),
  KEY `ledger_approved_by` (`approved_by`),
  KEY `ledger_approval_status` (`approval_status`),
  CONSTRAINT `ledger_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ledger_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `ledger_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: proof_documents
-- Description: Supporting documents for project transactions and approvals
-- ============================================================================
CREATE TABLE `proof_documents` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ledger_id` bigint unsigned NOT NULL,
  `document_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(50) COLLATE utf8mb4_unicode_ci,
  `file_size` bigint,
  `uploaded_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `proof_documents_ledger_id` (`ledger_id`),
  KEY `proof_documents_uploaded_by` (`uploaded_by`),
  CONSTRAINT `proof_documents_ledger_id_foreign` FOREIGN KEY (`ledger_id`) REFERENCES `ledger` (`id`) ON DELETE CASCADE,
  CONSTRAINT `proof_documents_uploaded_by_foreign` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: ratings
-- Description: Student ratings for projects and CSG performance
-- ============================================================================
CREATE TABLE `ratings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `student_id` bigint unsigned NOT NULL,
  `rating_score` tinyint NOT NULL CHECK (`rating_score` >= 1 AND `rating_score` <= 5),
  `feedback` text COLLATE utf8mb4_unicode_ci,
  `helpful_count` int DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ratings_unique` (`project_id`, `student_id`),
  KEY `ratings_project_id` (`project_id`),
  KEY `ratings_student_id` (`student_id`),
  CONSTRAINT `ratings_project_id_foreign` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ratings_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: approvals
-- Description: Workflow approvals for projects and transactions (Adviser verification)
-- ============================================================================
CREATE TABLE `approvals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `approvable_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approvable_id` bigint unsigned NOT NULL,
  `adviser_id` bigint unsigned NOT NULL,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `approvals_adviser_id` (`adviser_id`),
  KEY `approvals_status` (`status`),
  KEY `approvals_approvable` (`approvable_type`, `approvable_id`),
  CONSTRAINT `approvals_adviser_id_foreign` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: meetings
-- Description: CSG meetings and minutes
-- ============================================================================
CREATE TABLE `meetings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `scheduled_date` datetime NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci,
  `status` enum('scheduled','in_progress','completed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'scheduled',
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meetings_created_by` (`created_by`),
  KEY `meetings_status` (`status`),
  CONSTRAINT `meetings_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: meeting_minutes
-- Description: Meeting minutes and documentation
-- ============================================================================
CREATE TABLE `meeting_minutes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meeting_id` bigint unsigned NOT NULL UNIQUE,
  `minutes_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_items` text COLLATE utf8mb4_unicode_ci,
  `attendees` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned,
  `approval_status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `meeting_minutes_meeting_id` (`meeting_id`),
  KEY `meeting_minutes_recorded_by` (`recorded_by`),
  KEY `meeting_minutes_approved_by` (`approved_by`),
  CONSTRAINT `meeting_minutes_meeting_id_foreign` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `meeting_minutes_recorded_by_foreign` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `meeting_minutes_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: notifications
-- Description: User notifications for system events
-- ============================================================================
CREATE TABLE `notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci,
  `related_type` varchar(100) COLLATE utf8mb4_unicode_ci,
  `related_id` bigint unsigned,
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_user_id` (`user_id`),
  KEY `notifications_is_read` (`is_read`),
  KEY `notifications_created_at` (`created_at`),
  CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: audit_logs
-- Description: System activity logs for compliance and auditing
-- ============================================================================
CREATE TABLE `audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned,
  `action` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_type` enum('create','read','update','delete','approve','reject') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('success','failure') COLLATE utf8mb4_unicode_ci DEFAULT 'success',
  `actionable_type` varchar(100) COLLATE utf8mb4_unicode_ci,
  `actionable_id` bigint unsigned,
  `details` json,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci,
  `browser_info` varchar(255) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_logs_user_id` (`user_id`),
  KEY `audit_logs_module` (`module`),
  KEY `audit_logs_action_type` (`action_type`),
  KEY `audit_logs_created_at` (`created_at`),
  CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: engagement_rules
-- Description: System rules for student engagement and point calculation
-- ============================================================================
CREATE TABLE `engagement_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activity_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_awarded` int NOT NULL DEFAULT 0,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `engagement_rules_activity_type` (`activity_type`),
  KEY `engagement_rules_is_active` (`is_active`),
  CONSTRAINT `engagement_rules_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: student_badges
-- Description: Badges earned by students for achievements
-- ============================================================================
CREATE TABLE `student_badges` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint unsigned NOT NULL,
  `badge_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `badge_description` text COLLATE utf8mb4_unicode_ci,
  `badge_icon` varchar(255) COLLATE utf8mb4_unicode_ci,
  `earned_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_badges_student_id` (`student_id`),
  CONSTRAINT `student_badges_student_id_foreign` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: system_settings
-- Description: Configurable system settings
-- ============================================================================
CREATE TABLE `system_settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `setting_value` text COLLATE utf8mb4_unicode_ci,
  `setting_type` varchar(50) COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: cache
-- Description: Laravel cache storage table
-- ============================================================================
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: cache_locks
-- Description: Cache locks for atomic operations
-- ============================================================================
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: jobs
-- Description: Background job queue table
-- ============================================================================
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned NULL DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: job_batches
-- Description: Batch processing for jobs
-- ============================================================================
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci NULL,
  `cancelled_at` int NULL DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: failed_jobs
-- Description: Failed background jobs for debugging
-- ============================================================================
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SAMPLE DATA - ROLES
-- ============================================================================
INSERT INTO `roles` (`name`, `slug`, `description`, `color`) VALUES
('Super Admin', 'superadmin', 'Full system access with all permissions', 'bg-purple-100 text-purple-700'),
('Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', 'bg-blue-100 text-blue-700'),
('CSG Officer', 'csg', 'Organization operations and submissions', 'bg-green-100 text-green-700'),
('Student', 'student', 'View, rate, and engage in projects', 'bg-gray-100 text-gray-700'),
('Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', 'bg-indigo-100 text-indigo-700');

-- ============================================================================
-- SAMPLE DATA - PERMISSIONS
-- ============================================================================
INSERT INTO `permissions` (`module`, `action`, `permission`, `description`) VALUES
('projects', 'view', 'projects.view', 'View projects'),
('projects', 'create', 'projects.create', 'Create new projects'),
('projects', 'edit', 'projects.edit', 'Edit projects'),
('projects', 'delete', 'projects.delete', 'Delete projects'),
('projects', 'approve', 'projects.approve', 'Approve projects'),
('projects', 'rate', 'projects.rate', 'Rate projects'),
('ledger', 'view', 'ledger.view', 'View financial ledger'),
('ledger', 'create', 'ledger.create', 'Create ledger entries'),
('ledger', 'edit', 'ledger.edit', 'Edit ledger entries'),
('ledger', 'approve', 'ledger.approve', 'Approve transactions'),
('proof', 'view', 'proof.view', 'View proof documents'),
('proof', 'upload', 'proof.upload', 'Upload proof documents'),
('proof', 'delete', 'proof.delete', 'Delete proof documents'),
('proof', 'approve', 'proof.approve', 'Approve documents'),
('meetings', 'view', 'meetings.view', 'View meetings'),
('meetings', 'create', 'meetings.create', 'Create meetings'),
('meetings', 'edit', 'meetings.edit', 'Edit meetings'),
('meetings', 'approve_minutes', 'meetings.approve_minutes', 'Approve meeting minutes'),
('ratings', 'view', 'ratings.view', 'View ratings'),
('ratings', 'submit', 'ratings.submit', 'Submit ratings'),
('ratings', 'moderate', 'ratings.moderate', 'Moderate ratings'),
('notifications', 'view', 'notifications.view', 'View notifications'),
('notifications', 'send', 'notifications.send', 'Send notifications'),
('users', 'view', 'users.view', 'View users'),
('users', 'create', 'users.create', 'Create users'),
('users', 'edit', 'users.edit', 'Edit users'),
('users', 'suspend', 'users.suspend', 'Suspend users'),
('users', 'delete', 'users.delete', 'Delete users'),
('system', 'view', 'system.view', 'View system settings'),
('system', 'configure', 'system.configure', 'Configure system settings'),
('system', 'backup', 'system.backup', 'Backup system'),
('system', 'logs', 'system.logs', 'View system logs');

-- ============================================================================
-- SAMPLE DATA - ROLE PERMISSIONS (Super Admin gets all)
-- ============================================================================
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 1, `id` FROM `permissions`;

-- ============================================================================
-- SAMPLE DATA - USERS
-- ============================================================================
INSERT INTO `users` (`name`, `email`, `password`, `role_id`, `status`, `email_verified_at`, `created_at`, `updated_at`) VALUES
('Super Admin', 'superadmin@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8cR8cR8cR8cR8cR8cR8', 1, 'active', NOW(), NOW(), NOW()),
('Dr. Maria Santos', 'maria.santos@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 2, 'active', NOW(), NOW(), NOW()),
('Prof. John Reyes', 'john.reyes@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 2, 'active', NOW(), NOW(), NOW()),
('Sarah Chen', 'sarah.chen@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 3, 'active', NOW(), NOW(), NOW()),
('Michael Torres', 'michael.torres@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 3, 'active', NOW(), NOW(), NOW()),
('Emma Johnson', 'emma.johnson@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 4, 'active', NOW(), NOW(), NOW()),
('Juan Dela Cruz', 'juan.delacruz@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 4, 'active', NOW(), NOW(), NOW()),
('Anna Martinez', 'anna.martinez@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 4, 'active', NOW(), NOW(), NOW()),
('Prof. Ricardo Lopez', 'ricardo.lopez@kld.edu.ph', '$2y$12$OkjJKqJKqJKqJKqJKqJKqeRuT1s8cR8R8cR8R8cR8R8cR8R8cR8cR8', 5, 'active', NOW(), NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - STUDENTS
-- ============================================================================
INSERT INTO `students` (`user_id`, `student_id`, `year_level`, `course`, `department`, `adviser_id`, `created_at`, `updated_at`) VALUES
(6, 'STU-2023-001', '3rd Year', 'BS Information Technology', 'College of Engineering', 2, NOW(), NOW()),
(7, 'STU-2023-002', '2nd Year', 'BS Information Technology', 'College of Engineering', 2, NOW(), NOW()),
(8, 'STU-2023-003', '4th Year', 'BS Business Administration', 'College of Business', 3, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - TEACHERS
-- ============================================================================
INSERT INTO `teachers` (`user_id`, `employee_id`, `department`, `specialization`, `teacher_type`, `created_at`, `updated_at`) VALUES
(2, 'EMP-2020-001', 'College of Engineering', 'Systems Design', 'Adviser', NOW(), NOW()),
(3, 'EMP-2020-002', 'College of Business', 'Business Management', 'Adviser', NOW(), NOW()),
(9, 'EMP-2021-003', 'College of Engineering', 'Database Management', 'Ordinary', NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - CSG OFFICERS
-- ============================================================================
INSERT INTO `csg_officers` (`user_id`, `position`, `term_start`, `term_end`, `is_active`, `created_at`, `updated_at`) VALUES
(4, 'President', '2024-06-01', '2025-05-31', 1, NOW(), NOW()),
(5, 'Vice President', '2024-06-01', '2025-05-31', 1, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - PROJECTS
-- ============================================================================
INSERT INTO `projects` (`title`, `description`, `csg_officer_id`, `category`, `budget`, `spent_amount`, `status`, `start_date`, `deadline`, `progress_percentage`, `members_count`, `approved_by`, `approval_date`, `created_at`, `updated_at`) VALUES
('Community Outreach Program', 'Community service initiative to help underprivileged families', 4, 'Community Outreach', 25000.00, 18500.00, 'in_progress', '2024-11-01', '2024-12-15', 74, 12, 2, NOW(), NOW(), NOW()),
('Annual Sports Fest', 'Inter-school sports competition and activities', 5, 'Sports & Recreation', 35000.00, 5200.00, 'planning', '2024-12-01', '2025-01-20', 15, 8, NULL, NULL, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - RATINGS
-- ============================================================================
INSERT INTO `ratings` (`project_id`, `student_id`, `rating_score`, `feedback`, `helpful_count`, `created_at`, `updated_at`) VALUES
(1, 6, 5, 'Great project! Very well-organized and impactful.', 8, NOW(), NOW()),
(1, 7, 4, 'Good execution, but could have better communication.', 3, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - SYSTEM SETTINGS
-- ============================================================================
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`) VALUES
('app_name', 'STEP - Student Transparency & Engagement Platform', 'string', 'Application name'),
('app_version', '1.0.0', 'string', 'Application version'),
('school_name', 'KLD College', 'string', 'Institution name'),
('default_currency', 'PHP', 'string', 'Default currency for transactions'),
('enable_ratings', '1', 'boolean', 'Enable student ratings feature'),
('enable_notifications', '1', 'boolean', 'Enable notification system'),
('max_project_budget', '100000', 'number', 'Maximum project budget allowed'),
('points_per_project_rating', '15', 'number', 'Points awarded for rating a project');

COMMIT;
