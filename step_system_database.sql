-- ============================================================================
-- STEP Database Schema - Complete Version with Sample Data
-- Application: STEP System (Student Transparency and Engagement Platform)
-- Purpose: Student Governance & Transparency System for KLD College
-- Created: 2026-03-16
-- Database: MySQL 8.0+
-- ============================================================================

-- ============================================================================
-- DATABASE CONFIGURATION
-- ============================================================================
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- Drop existing database if exists (WARNING: This will delete all data)
-- DROP DATABASE IF EXISTS `step_database`;

-- ============================================================================
-- CREATE DATABASE
-- ============================================================================
CREATE DATABASE IF NOT EXISTS `step2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `step2`;

-- Disable foreign key checks during import to avoid constraint errors
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- TABLE: roles
-- Description: User roles in the system
-- Roles: Super Admin, Admin/Adviser, CSG Officer, Student, Ordinary Teacher
-- ============================================================================
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `description` text COLLATE utf8mb4_unicode_ci,
  `color` varchar(50) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_slug` (`slug`)
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_module` (`module`),
  KEY `idx_action` (`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: role_permission
-- Description: Junction table linking roles to permissions (Many-to-Many)
-- ============================================================================
CREATE TABLE `role_permission` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_role_permission` (`role_id`, `permission_id`),
  KEY `fk_role_permission_role_id` (`role_id`),
  KEY `fk_role_permission_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permission_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permission_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: institutes
-- Description: Educational institutions/departments
-- ============================================================================
CREATE TABLE `institutes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `description` text COLLATE utf8mb4_unicode_ci,
  `contact_email` varchar(255) COLLATE utf8mb4_unicode_ci,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci,
  `address` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`)
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
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci,
  `avatar_url` varchar(500) COLLATE utf8mb4_unicode_ci,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `institute_id` bigint unsigned,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_email` (`email`),
  KEY `fk_users_role_id` (`role_id`),
  KEY `fk_users_institute_id` (`institute_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_users_institute_id` FOREIGN KEY (`institute_id`) REFERENCES `institutes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: students
-- Description: Student-specific information
-- ============================================================================
CREATE TABLE `students` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `student_id` varchar(50) COLLATE utf8mb4_unicode_ci UNIQUE NOT NULL,
  `year_level` enum('1st Year','2nd Year','3rd Year','4th Year') COLLATE utf8mb4_unicode_ci,
  `course` varchar(100) COLLATE utf8mb4_unicode_ci,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci,
  `adviser_id` bigint unsigned,
  `gpa` decimal(3, 2),
  `enrollment_date` date,
  `expected_graduation` date,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_students_user_id` (`user_id`),
  KEY `fk_students_adviser_id` (`adviser_id`),
  KEY `idx_student_id` (`student_id`),
  CONSTRAINT `fk_students_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_students_adviser_id` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: teachers
-- Description: Teacher/Faculty information (Advisers & Ordinary Teachers)
-- ============================================================================
CREATE TABLE `teachers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `employee_id` varchar(50) COLLATE utf8mb4_unicode_ci UNIQUE NOT NULL,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci,
  `specialization` varchar(100) COLLATE utf8mb4_unicode_ci,
  `teacher_type` enum('Ordinary','Adviser','Both') COLLATE utf8mb4_unicode_ci DEFAULT 'Ordinary',
  `office_location` varchar(255) COLLATE utf8mb4_unicode_ci,
  `office_phone` varchar(20) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_teachers_user_id` (`user_id`),
  KEY `idx_employee_id` (`employee_id`),
  CONSTRAINT `fk_teachers_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: csg_officers
-- Description: CSG (Council of Student Government) Officer information
-- ============================================================================
CREATE TABLE `csg_officers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL UNIQUE,
  `position` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `term_start` date NOT NULL,
  `term_end` date NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `department` varchar(100) COLLATE utf8mb4_unicode_ci,
  `contact_number` varchar(20) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_csg_officers_user_id` (`user_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `fk_csg_officers_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: password_reset_tokens
-- Description: Stores password reset tokens for security
-- ============================================================================
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`email`),
  KEY `idx_created_at` (`created_at`)
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
  KEY `idx_user_id` (`user_id`),
  KEY `idx_last_activity` (`last_activity`),
  CONSTRAINT `fk_sessions_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
  `status` enum('planning','in_progress','completed','cancelled','on_hold') COLLATE utf8mb4_unicode_ci DEFAULT 'planning',
  `start_date` date,
  `deadline` date,
  `completion_date` date,
  `progress_percentage` tinyint DEFAULT 0,
  `members_count` int DEFAULT 0,
  `approved_by` bigint unsigned,
  `approval_date` timestamp NULL DEFAULT NULL,
  `visibility` enum('public','restricted','private') DEFAULT 'public',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_projects_csg_officer_id` (`csg_officer_id`),
  KEY `fk_projects_approved_by` (`approved_by`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `fk_projects_csg_officer_id` FOREIGN KEY (`csg_officer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_projects_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
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
  `hours_contributed` int DEFAULT 0,
  `joined_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_project_student` (`project_id`, `student_id`),
  KEY `fk_project_members_project_id` (`project_id`),
  KEY `fk_project_members_student_id` (`student_id`),
  CONSTRAINT `fk_project_members_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_project_members_student_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: ledger
-- Description: Financial ledger for project expenses and budget tracking
-- ============================================================================
CREATE TABLE `ledger` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `project_id` bigint unsigned NOT NULL,
  `transaction_type` enum('expense','income','adjustment','refund') COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(100) COLLATE utf8mb4_unicode_ci,
  `amount` decimal(12, 2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `recorded_by` bigint unsigned NOT NULL,
  `approved_by` bigint unsigned,
  `approval_status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `transaction_date` date NOT NULL,
  `reference_number` varchar(100) COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_ledger_project_id` (`project_id`),
  KEY `fk_ledger_recorded_by` (`recorded_by`),
  KEY `fk_ledger_approved_by` (`approved_by`),
  KEY `idx_approval_status` (`approval_status`),
  KEY `idx_transaction_type` (`transaction_type`),
  CONSTRAINT `fk_ledger_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ledger_recorded_by` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_ledger_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_proof_documents_ledger_id` (`ledger_id`),
  KEY `fk_proof_documents_uploaded_by` (`uploaded_by`),
  CONSTRAINT `fk_proof_documents_ledger_id` FOREIGN KEY (`ledger_id`) REFERENCES `ledger` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_proof_documents_uploaded_by` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_project_student_rating` (`project_id`, `student_id`),
  KEY `fk_ratings_project_id` (`project_id`),
  KEY `fk_ratings_student_id` (`student_id`),
  CONSTRAINT `fk_ratings_project_id` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ratings_student_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: approvals
-- Description: Workflow approvals for projects and transactions
-- ============================================================================
CREATE TABLE `approvals` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `approvable_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approvable_id` bigint unsigned NOT NULL,
  `adviser_id` bigint unsigned NOT NULL,
  `status` enum('pending','approved','rejected','revised') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_approvals_adviser_id` (`adviser_id`),
  KEY `idx_status` (`status`),
  KEY `idx_approvable` (`approvable_type`, `approvable_id`),
  CONSTRAINT `fk_approvals_adviser_id` FOREIGN KEY (`adviser_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
  `meeting_type` enum('regular','emergency','planning','review') DEFAULT 'regular',
  `status` enum('scheduled','in_progress','completed','cancelled','postponed') COLLATE utf8mb4_unicode_ci DEFAULT 'scheduled',
  `created_by` bigint unsigned NOT NULL,
  `attendee_count` int DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_meetings_created_by` (`created_by`),
  KEY `idx_status` (`status`),
  KEY `idx_scheduled_date` (`scheduled_date`),
  CONSTRAINT `fk_meetings_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_meeting_minutes_meeting_id` (`meeting_id`),
  KEY `fk_meeting_minutes_recorded_by` (`recorded_by`),
  KEY `fk_meeting_minutes_approved_by` (`approved_by`),
  CONSTRAINT `fk_meeting_minutes_meeting_id` FOREIGN KEY (`meeting_id`) REFERENCES `meetings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_meeting_minutes_recorded_by` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_meeting_minutes_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notifications_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_notifications_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_audit_logs_user_id` (`user_id`),
  KEY `idx_module` (`module`),
  KEY `idx_action_type` (`action_type`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_audit_logs_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TABLE: engagement_rules
-- Description: System rules for student engagement and point calculation
-- ============================================================================
CREATE TABLE `engagement_rules` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL UNIQUE,
  `activity_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `points_awarded` int NOT NULL DEFAULT 0,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activity_type` (`activity_type`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `fk_engagement_rules_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE RESTRICT
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
  `category` varchar(50) COLLATE utf8mb4_unicode_ci,
  `earned_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_student_badges_student_id` (`student_id`),
  KEY `idx_category` (`category`),
  CONSTRAINT `fk_student_badges_student_id` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_setting_key` (`setting_key`)
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
  KEY `idx_expiration` (`expiration`)
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
  KEY `idx_expiration` (`expiration`)
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
  KEY `idx_queue` (`queue`)
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
  PRIMARY KEY (`id`),
  KEY `idx_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SAMPLE DATA - ROLES
-- ============================================================================
INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `color`) VALUES
(1, 'Super Admin', 'superadmin', 'Full system access with all permissions', '#9C27B0'),
(2, 'Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', '#2196F3'),
(3, 'CSG Officer', 'csg', 'Organization operations and submissions', '#4CAF50'),
(4, 'Student', 'student', 'View, rate, and engage in projects', '#757575'),
(5, 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '#673AB7');

-- ============================================================================
-- SAMPLE DATA - PERMISSIONS (31 total)
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
('system', 'logs', 'system.logs', 'View system logs');

-- ============================================================================
-- SAMPLE DATA - ROLE PERMISSIONS (Super Admin gets all permissions)
-- ============================================================================
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 1, `id` FROM `permissions`;

-- Admin/Adviser gets project, ledger, proof, meetings, and ratings permissions
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 2, `id` FROM `permissions` 
WHERE `module` IN ('projects', 'ledger', 'proof', 'meetings', 'ratings', 'notifications', 'users')
AND `action` NOT IN ('delete');

-- CSG Officer gets projects, ledger, proof, and meetings permissions (limited)
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 3, `id` FROM `permissions` 
WHERE `permission` IN ('projects.view', 'projects.create', 'projects.edit', 'ledger.view', 
'ledger.create', 'proof.view', 'proof.upload', 'meetings.view', 'meetings.create',
'ratings.view', 'notifications.view');

-- Student gets view and rate permissions
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 4, `id` FROM `permissions` 
WHERE `permission` IN ('projects.view', 'projects.rate', 'ledger.view', 'meetings.view',
'ratings.view', 'ratings.submit', 'notifications.view');

-- Ordinary Teacher gets view permissions
INSERT INTO `role_permission` (`role_id`, `permission_id`) 
SELECT 5, `id` FROM `permissions` 
WHERE `action` = 'view';

-- ============================================================================
-- SAMPLE DATA - INSTITUTES
-- ============================================================================
INSERT INTO `institutes` (`id`, `name`, `description`, `contact_email`, `phone`, `address`, `is_active`) VALUES
(1, 'Institute of Behavioral Sciences', 'Department of Psychology and Social Sciences', 'ibs@kld.edu.ph', '(02) 8234-5678', 'BehavioralSciences Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(2, 'Institute of Computing and Digital Innovation', 'Department of Computer Science and IT', 'icdi@kld.edu.ph', '(02) 8234-5679', 'Computing Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(3, 'Institute of Engineering', 'Department of Engineering and Technology', 'ie@kld.edu.ph', '(02) 8234-5680', 'Engineering Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(4, 'Institute of Foundational Studies', 'Department of General Education', 'ifs@kld.edu.ph', '(02) 8234-5681', 'Foundational Studies Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(5, 'Institute of Governance and Development Studies', 'Department of Public Administration', 'igds@kld.edu.ph', '(02) 8234-5682', 'Governance Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(6, 'Institute of Midwifery', 'Department of Midwifery and Health Sciences', 'im@kld.edu.ph', '(02) 8234-5683', 'Midwifery Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(7, 'Institute of Nursing', 'Department of Nursing and Healthcare', 'in@kld.edu.ph', '(02) 8234-5684', 'Nursing Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1),
(8, 'Institute of Science and Mathematics', 'Department of Natural Sciences', 'ism@kld.edu.ph', '(02) 8234-5685', 'Science and Mathematics Building, Brgy. Burol Main, City of Dasmariñas, Cavite', 1);

-- ============================================================================
-- SAMPLE DATA - USERS (Super Admin, Advisers, CSG Officers, Students, Teachers)
-- ============================================================================
-- Password: 'password' (hashed with bcrypt) - All users use the same password for testing
-- Test Credentials:
-- 1. superadmin@kld.edu.ph / password (Super Admin)
-- 2. maria.santos@kld.edu.ph / password (Admin/Adviser)
-- 3. juan.reyes@kld.edu.ph / password (Admin/Adviser)
-- 4. anna.cruz@kld.edu.ph / password (Admin/Adviser)
-- 5. sarah.chen@kld.edu.ph / password (CSG Officer)
-- 6. michael.torres@kld.edu.ph / password (CSG Officer)
-- 7. emma.johnson@kld.edu.ph / password (Student)
-- 8. juan.delacruz@kld.edu.ph / password (Student)
-- 9. anna.martinez@kld.edu.ph / password (Student)
-- 10. carlos.mendoza@kld.edu.ph / password (Student)
-- 11. maria.santos.jr@kld.edu.ph / password (Student)
-- 12. ramon.garcia@kld.edu.ph / password (Ordinary Teacher)
-- 13. lisa.wong@kld.edu.ph / password (Ordinary Teacher)
-- 14. daniel.fernandez@kld.edu.ph / password (Ordinary Teacher)
INSERT INTO `users` (`name`, `email`, `password`, `role_id`, `status`, `phone`, `institute_id`, `email_verified_at`, `created_at`, `updated_at`) VALUES
('Super Admin', 'superadmin@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 1, 'active', '09991234567', 1, NOW(), NOW(), NOW()),
('Dr. Maria Santos', 'maria.santos@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 2, 'active', '09991234568', 1, NOW(), NOW(), NOW()),
('Prof. Juan Reyes', 'juan.reyes@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 2, 'active', '09991234569', 2, NOW(), NOW(), NOW()),
('Prof. Anna Cruz', 'anna.cruz@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 2, 'active', '09991234570', 3, NOW(), NOW(), NOW()),
('Sarah Chen', 'sarah.chen@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 3, 'active', '09991234571', 1, NOW(), NOW(), NOW()),
('Michael Torres', 'michael.torres@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 3, 'active', '09991234572', 1, NOW(), NOW(), NOW()),
('Emma Johnson', 'emma.johnson@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 4, 'active', '09991234573', 1, NOW(), NOW(), NOW()),
('Juan Dela Cruz', 'juan.delacruz@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 4, 'active', '09991234574', 1, NOW(), NOW(), NOW()),
('Anna Martinez', 'anna.martinez@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 4, 'active', '09991234575', 1, NOW(), NOW(), NOW()),
('Carlos Mendoza', 'carlos.mendoza@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 4, 'active', '09991234576', 1, NOW(), NOW(), NOW()),
('Maria Santos Jr.', 'maria.santos.jr@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 4, 'active', '09991234577', 2, NOW(), NOW(), NOW()),
('Prof. Ramon Garcia', 'ramon.garcia@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 5, 'active', '09991234578', 2, NOW(), NOW(), NOW()),
('Prof. Lisa Wong', 'lisa.wong@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 5, 'active', '09991234579', 1, NOW(), NOW(), NOW()),
('Prof. Daniel Fernandez', 'daniel.fernandez@kld.edu.ph', '$2y$12$M3Q5rdVHYK06ZRzBwajIieZ3LecJICvPnilXwVfJ/toq1//nI/rNm', 5, 'active', '09991234580', 1, NOW(), NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - STUDENTS (linked to users)
-- ============================================================================
INSERT INTO `students` (`user_id`, `student_id`, `year_level`, `course`, `department`, `adviser_id`, `enrollment_date`, `expected_graduation`) VALUES
(7, 'STU-2023-0001', '3rd Year', 'BS Information System', 'Institute of Computing and Digital Innovation', 2, '2021-06-01', '2025-05-31'),
(8, 'STU-2023-0002', '2nd Year', 'BS Computer Science', 'Institute of Computing and Digital Innovation', 2, '2022-06-01', '2026-05-31'),
(9, 'STU-2023-0003', '4th Year', 'BS Civil Engineering', 'Institute of Engineering', 3, '2020-06-01', '2024-05-31'),
(10, 'STU-2023-0004', '1st Year', 'BS Nursing', 'Institute of Nursing', 2, '2023-06-01', '2027-05-31'),
(11, 'STU-2023-0005', '2nd Year', 'BS Psychology', 'Institute of Behavioral Sciences', 3, '2022-06-01', '2026-05-31');
-- ============================================================================
-- SAMPLE DATA - TEACHERS (linked to users)
-- ============================================================================
INSERT INTO `teachers` (`user_id`, `employee_id`, `department`, `specialization`, `teacher_type`, `office_location`, `office_phone`) VALUES
(2, 'EMP-2015-001', 'College of Engineering', 'Systems Design & Architecture', 'Adviser', 'Engineering Building, Room 301', '(02) 8234-5601'),
(3, 'EMP-2015-002', 'College of Business', 'Business Management', 'Adviser', 'Business Building, Room 201', '(02) 8234-5602'),
(4, 'EMP-2016-003', 'College of Education', 'Curriculum Design', 'Both', 'Education Building, Room 105', '(02) 8234-5603'),
(12, 'EMP-2018-004', 'College of Engineering', 'Database Management', 'Ordinary', 'Engineering Building, Room 302', '(02) 8234-5604'),
(13, 'EMP-2018-005', 'College of Engineering', 'Web Development', 'Ordinary', 'Engineering Building, Room 303', '(02) 8234-5605'),
(14, 'EMP-2019-006', 'College of Business', 'Finance', 'Ordinary', 'Business Building, Room 202', '(02) 8234-5606');

-- ============================================================================
-- SAMPLE DATA - CSG OFFICERS
-- ============================================================================
INSERT INTO `csg_officers` (`user_id`, `position`, `term_start`, `term_end`, `is_active`, `department`, `contact_number`) VALUES
(5, 'President', '2024-06-01', '2025-05-31', 1, 'College of Engineering', '09991234571'),
(6, 'Vice President', '2024-06-01', '2025-05-31', 1, 'College of Engineering', '09991234572');

-- ============================================================================
-- SAMPLE DATA - PROJECTS
-- ============================================================================
INSERT INTO `projects` (`title`, `description`, `csg_officer_id`, `category`, `budget`, `spent_amount`, `status`, `start_date`, `deadline`, `completion_date`, `progress_percentage`, `members_count`, `approved_by`, `approval_date`, `visibility`, `created_at`, `updated_at`) VALUES
('Community Outreach Program 2025', 'Community service initiative to help underprivileged families in Manila. Focus on education and healthcare assistance.', 5, 'Community Service', 25000.00, 18500.00, 'in_progress', '2024-11-01', '2024-12-15', NULL, 74, 12, 2, NOW(), 'public', NOW(), NOW()),
('Annual Sports Festival 2025', 'Inter-school sports competition featuring basketball, volleyball, badminton and track & field events.', 6, 'Sports & Recreation', 35000.00, 5200.00, 'planning', '2024-12-01', '2025-01-20', NULL, 15, 8, NULL, NULL, 'public', NOW(), NOW()),
('Environmental Cleanup Drive', 'Campus and surrounding area cleanup initiative to promote environmental awareness among students.', 5, 'Environmental', 8000.00, 2500.00, 'in_progress', '2024-10-15', '2025-01-31', NULL, 35, 4, 3, NOW(), 'public', NOW(), NOW()),
('Tech Innovation Summit', 'Annual technology conference bringing together students, faculty and industry professionals.', 6, 'Academics', 50000.00, 0.00, 'planning', '2025-02-01', '2025-03-31', NULL, 0, 0, NULL, NULL, 'public', NOW(), NOW()),
('Mental Health Awareness Campaign', 'Campaign to promote mental health awareness and student wellness across campus.', 5, 'Wellness', 15000.00, 10000.00, 'completed', '2024-09-01', '2024-10-31', '2024-10-31', 100, 18, 2, NOW(), 'public', NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - PROJECT MEMBERS
-- ============================================================================
INSERT INTO `project_members` (`project_id`, `student_id`, `role`, `hours_contributed`, `joined_at`, `created_at`, `updated_at`) VALUES
(1, 7, 'Team Lead', 40, NOW(), NOW(), NOW()),
(1, 8, 'Volunteer', 20, NOW(), NOW(), NOW()),
(1, 9, 'Coordinator', 35, NOW(), NOW(), NOW()),
(1, 10, 'Volunteer', 15, NOW(), NOW(), NOW()),
(2, 7, 'Coordinator', 25, NOW(), NOW(), NOW()),
(2, 11, 'Volunteer', 10, NOW(), NOW(), NOW()),
(3, 8, 'Team Lead', 30, NOW(), NOW(), NOW()),
(3, 10, 'Volunteer', 20, NOW(), NOW(), NOW()),
(5, 9, 'Team Lead', 50, NOW(), NOW(), NOW()),
(5, 7, 'Volunteer', 35, NOW(), NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - LEDGER ENTRIES
-- ============================================================================
INSERT INTO `ledger` (`project_id`, `transaction_type`, `category`, `amount`, `description`, `recorded_by`, `approved_by`, `approval_status`, `transaction_date`, `reference_number`, `created_at`, `updated_at`) VALUES
(1, 'expense', 'Supplies', 5000.00, 'School supplies for distribution', 5, 2, 'approved', '2024-11-10', 'REF-001-2024', NOW(), NOW()),
(1, 'expense', 'Food & Beverages', 8500.00, 'Meals for volunteers and beneficiaries', 5, 2, 'approved', '2024-11-15', 'REF-002-2024', NOW(), NOW()),
(1, 'expense', 'Transportation', 5000.00, 'Travel and transport expenses', 5, 2, 'approved', '2024-11-20', 'REF-003-2024', NOW(), NOW()),
(1, 'income', 'Donation', 3000.00, 'Corporate donation from ABC Corp', 5, 2, 'approved', '2024-11-05', 'REF-004-2024', NOW(), NOW()),
(2, 'expense', 'Equipment Rental', 3000.00, 'Sports equipment rental', 6, 3, 'pending', '2024-12-10', 'REF-005-2024', NOW(), NOW()),
(2, 'expense', 'Venue Rental', 2200.00, 'Stadium rental and permits', 6, 3, 'pending', '2024-12-10', 'REF-006-2024', NOW(), NOW()),
(3, 'expense', 'Materials', 1500.00, 'Cleaning supplies and waste bins', 5, 3, 'approved', '2024-10-20', 'REF-007-2024', NOW(), NOW()),
(3, 'expense', 'Meals', 1000.00, 'Snacks for volunteers', 5, 3, 'approved', '2024-10-20', 'REF-008-2024', NOW(), NOW()),
(5, 'expense', 'Marketing', 6000.00, 'Posters, banners and promotional materials', 5, 2, 'approved', '2024-09-10', 'REF-009-2024', NOW(), NOW()),
(5, 'expense', 'Speakers', 4000.00, 'Guest speaker honorarium', 5, 2, 'approved', '2024-09-15', 'REF-010-2024', NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - RATINGS
-- ============================================================================
INSERT INTO `ratings` (`project_id`, `student_id`, `rating_score`, `feedback`, `helpful_count`, `created_at`, `updated_at`) VALUES
(1, 7, 5, 'Excellent project! Very well-organized and impactful. Loved being part of the team.', 12, NOW(), NOW()),
(1, 8, 4, 'Good execution and meaningful cause. Could have better communication before events.', 5, NOW(), NOW()),
(1, 10, 5, 'Amazing experience helping the community. Would definitely join again!', 8, NOW(), NOW()),
(5, 9, 5, 'Great campaign that really raised awareness about mental health. Highly impactful!', 15, NOW(), NOW()),
(5, 11, 4, 'Useful information shared but could have more interactive sessions.', 3, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - MEETINGS
-- ============================================================================
INSERT INTO `meetings` (`title`, `description`, `scheduled_date`, `location`, `meeting_type`, `status`, `created_by`, `attendee_count`, `created_at`, `updated_at`) VALUES
('CSG General Meeting - November', 'Monthly general meeting to discuss ongoing projects and allocations.', '2024-11-15 10:00:00', 'Student Center, Conference Room A', 'regular', 'completed', 5, 28, NOW(), NOW()),
('Project Planning Session', 'Planning meeting for Q1 2025 projects and budget allocation.', '2024-12-05 14:00:00', 'Student Center, Conference Room B', 'planning', 'scheduled', 6, 15, NOW(), NOW()),
('Emergency Meeting - Budget Review', 'Emergency meeting to review project budget allocations.', '2024-11-20 09:00:00', 'Admin Office, Meeting Room', 'emergency', 'completed', 2, 8, NOW(), NOW()),
('CSG Quarterly Review', 'Review of CSG performance and member feedback.', '2025-01-10 13:00:00', 'Student Center, Main Hall', 'review', 'scheduled', 5, 0, NOW(), NOW()),
('Joint Meeting with Student Advisers', 'Meeting with student advisers to discuss support for projects.', '2024-12-20 10:30:00', 'Student Center, Conference Room A', 'regular', 'scheduled', 2, 12, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - MEETING MINUTES
-- ============================================================================
INSERT INTO `meeting_minutes` (`meeting_id`, `minutes_content`, `action_items`, `attendees`, `recorded_by`, `approved_by`, `approval_status`, `created_at`, `updated_at`) VALUES
(1, 'Discussion on completion of Community Outreach Program. Budget review for Q4. Approval of new project proposals. Updates on sports festival planning.', 
'1. Finalize Community Outreach Program report by Nov 30\n2. Submit Sports Festival budget by Dec 1\n3. Prepare year-end financial summary by Dec 15', 
'Sarah Chen, Michael Torres, Emma Johnson, Juan Dela Cruz, Anna Martinez, Carlos Mendoza, Prof. Maria Santos', 5, 2, 'approved', NOW(), NOW()),

(3, 'Discussion on project budget concerns. Review of payment procedures and expense tracking. Implementation of new financial controls.', 
'1. Update financial management procedures by Nov 25\n2. Conduct audit of previous transactions\n3. Provide training on expense documentation', 
'Sarah Chen, Michael Torres, Dr. Maria Santos, Prof. Juan Reyes', 5, 2, 'approved', NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - NOTIFICATIONS
-- ============================================================================
INSERT INTO `notifications` (`user_id`, `title`, `message`, `type`, `related_type`, `related_id`, `is_read`, `created_at`, `updated_at`) VALUES
(7, 'Project Approved', 'Your participation in Community Outreach Program has been confirmed.', 'approval', 'project', 1, 1, NOW(), NOW()),
(8, 'New Rating Received', 'Your feedback on the Community Outreach Program has been recorded.', 'rating', 'project', 1, 0, NOW(), NOW()),
(5, 'Budget Adjustment Needed', 'Sports Festival budget needs to be adjusted. Please review and update.', 'alert', 'project', 2, 0, NOW(), NOW()),
(9, 'Meeting Scheduled', 'New meeting scheduled: Quarterly Review on January 10, 2025', 'reminder', 'meeting', 4, 0, NOW(), NOW()),
(6, 'Document Approval Pending', 'Meeting minutes from November General Meeting require your approval.', 'action_required', 'meeting', 1, 0, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - AUDIT LOGS
-- ============================================================================
INSERT INTO `audit_logs` (`user_id`, `action`, `module`, `action_type`, `status`, `actionable_type`, `actionable_id`, `details`, `ip_address`, `browser_info`, `created_at`) VALUES
(1, 'Created new project', 'projects', 'create', 'success', 'Project', 1, '{"title":"Community Outreach Program 2025","budget":25000}', '192.168.1.100', 'Chrome/Windows', NOW()),
(2, 'Approved project budget', 'projects', 'approve', 'success', 'Project', 1, '{"status":"approved"}', '192.168.1.101', 'Firefox/Windows', NOW()),
(5, 'Created ledger entry', 'ledger', 'create', 'success', 'Ledger', 1, '{"amount":5000,"category":"Supplies"}', '192.168.1.102', 'Chrome/Windows', NOW()),
(2, 'Approved transaction', 'ledger', 'approve', 'success', 'Ledger', 1, '{"status":"approved"}', '192.168.1.101', 'Safari/MacOS', NOW()),
(5, 'Created meeting', 'meetings', 'create', 'success', 'Meeting', 1, '{"title":"CSG General Meeting"}', '192.168.1.102', 'Chrome/Windows', NOW());

-- ============================================================================
-- SAMPLE DATA - ENGAGEMENT RULES
-- ============================================================================
INSERT INTO `engagement_rules` (`rule_name`, `activity_type`, `points_awarded`, `description`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
('Project Participation', 'project_participation', 25, 'Points awarded for participating in a CSG project', 1, 1, NOW(), NOW()),
('Project Leadership', 'project_leadership', 50, 'Points awarded for leading a CSG project', 1, 1, NOW(), NOW()),
('Rating Submission', 'rating_submission', 5, 'Points awarded for submitting a project rating', 1, 1, NOW(), NOW()),
('Meeting Attendance', 'meeting_attendance', 10, 'Points awarded for attending CSG meetings', 1, 1, NOW(), NOW()),
('Volunteer Hour', 'volunteer_hour', 2, 'Points awarded per volunteer hour contributed', 1, 1, NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - STUDENT BADGES
-- ============================================================================
INSERT INTO `student_badges` (`student_id`, `badge_name`, `badge_description`, `badge_icon`, `category`, `earned_date`, `created_at`, `updated_at`) VALUES
(7, 'Project Champion', 'Participated in 3 or more CSG projects', 'badge-champion.png', 'Participation', '2024-11-20', NOW(), NOW()),
(9, 'Community Hero', 'Completed the Community Outreach Program', 'badge-hero.png', 'Community', '2024-10-31', NOW(), NOW()),
(9, 'Feedback Master', 'Submitted 5 or more project ratings', 'badge-feedback.png', 'Engagement', '2024-11-25', NOW(), NOW()),
(7, 'Team Player', 'Participated in team-based projects', 'badge-team.png', 'Collaboration', '2024-11-15', NOW(), NOW());

-- ============================================================================
-- SAMPLE DATA - SYSTEM SETTINGS
-- ============================================================================
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `setting_type`, `description`, `created_at`, `updated_at`) VALUES
('app_name', 'STEP - Student Transparency & Engagement Platform', 'string', 'Application name', NOW(), NOW()),
('app_version', '1.0.0', 'string', 'Application version', NOW(), NOW()),
('school_name', 'KLD College', 'string', 'Institution name', NOW(), NOW()),
('school_code', 'KLD-2024', 'string', 'Institution code', NOW(), NOW()),
('default_currency', 'PHP', 'string', 'Default currency for transactions', NOW(), NOW()),
('enable_ratings', '1', 'boolean', 'Enable student ratings feature', NOW(), NOW()),
('enable_notifications', '1', 'boolean', 'Enable notification system', NOW(), NOW()),
('max_project_budget', '100000', 'number', 'Maximum project budget allowed', NOW(), NOW()),
('min_project_budget', '500', 'number', 'Minimum project budget allowed', NOW(), NOW()),
('points_per_project_rating', '15', 'number', 'Points awarded for rating a project', NOW(), NOW()),
('points_per_participation', '25', 'number', 'Points awarded for project participation', NOW(), NOW()),
('approval_required', '1', 'boolean', 'Require adviser approval for projects', NOW(), NOW()),
('fiscal_year_start', '06-01', 'string', 'Fiscal year start date (MM-DD)', NOW(), NOW()),
('max_projects_per_csg', '5', 'number', 'Maximum active projects per CSG officer', NOW(), NOW()),
('timezone', 'Asia/Manila', 'string', 'System timezone', NOW(), NOW());

-- ============================================================================
-- COMMIT TRANSACTION
-- ============================================================================
-- Re-enable foreign key checks after all data is imported
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- ============================================================================
-- DATABASE SUMMARY
-- ============================================================================
-- Total Tables: 27
-- Total Rows (Sample Data): 100+
-- Roles: 5 (Super Admin, Admin, CSG Officer, Student, Teacher)
-- Users: 14 (1 Admin, 3 Advisers, 2 CSG Officers, 5 Students, 3 Teachers)
-- Projects: 5 (Various statuses: planning, in_progress, completed)
-- Transactions: 10 ledger entries with various statuses
-- Meetings: 5 meetings with minutes
-- Ratings: 5 project ratings from students
-- Badges: 4 achievement badges
-- Settings: 15 system configuration entries
-- ============================================================================
