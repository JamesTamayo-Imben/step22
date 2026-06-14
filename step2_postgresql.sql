-- PostgreSQL Database Export for STEP Platform
-- Converted from MySQL (step_system_database.sql)
-- Generated: June 10, 2026

BEGIN;

-- ============================================
-- Create ENUMS
-- ============================================

CREATE TYPE ledger_type AS ENUM ('Income', 'Expense', 'Donation', 'Sponsorship', 'Canvas', 'Initial');
CREATE TYPE approval_status_enum AS ENUM ('Draft', 'Pending Adviser Approval', 'Approved', 'Rejected');
CREATE TYPE user_role_enum AS ENUM ('student', 'teacher');
CREATE TYPE verification_status_enum AS ENUM ('pending', 'approved', 'rejected');
CREATE TYPE user_status_enum AS ENUM ('active', 'suspended', 'archived');

-- ============================================
-- Table: approval
-- ============================================

CREATE TABLE IF NOT EXISTS approval (
  id uuid PRIMARY KEY,
  employee_id varchar(100),
  project_id uuid,
  reference_type varchar(100),
  approvable_type varchar(100),
  status varchar(50),
  rejection_reason text,
  reviewed_at timestamp,
  officers_approved text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: audit_logs
-- ============================================

CREATE TABLE IF NOT EXISTS audit_logs (
  id uuid PRIMARY KEY,
  user_id uuid,
  actionable_id varchar(100),
  actionable_type varchar(100),
  action varchar(255),
  module varchar(100),
  action_type varchar(100),
  status varchar(50),
  details text,
  ip_address varchar(45),
  browser_info text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: badge
-- ============================================

CREATE TABLE IF NOT EXISTS badge (
  id uuid PRIMARY KEY,
  name varchar(255) NOT NULL,
  description text,
  icon varchar(255),
  category varchar(100),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_badge_category ON badge(category);

-- ============================================
-- Table: badge_collected
-- ============================================

CREATE TABLE IF NOT EXISTS badge_collected (
  id uuid PRIMARY KEY,
  badge_id uuid NOT NULL,
  user_id uuid NOT NULL,
  earned_date timestamp DEFAULT CURRENT_TIMESTAMP,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0,
  UNIQUE(badge_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_badge_collected_user ON badge_collected(user_id);
CREATE INDEX IF NOT EXISTS idx_badge_collected_badge ON badge_collected(badge_id);
CREATE INDEX IF NOT EXISTS idx_badge_collected_earned ON badge_collected(earned_date);

-- ============================================
-- Table: chain
-- ============================================

CREATE TABLE IF NOT EXISTS chain (
  id uuid PRIMARY KEY,
  project_id uuid,
  block_index integer DEFAULT 0,
  prev_hash varchar(255),
  hash varchar(255),
  data_snapshot text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: course
-- ============================================

CREATE TABLE IF NOT EXISTS course (
  id uuid PRIMARY KEY,
  institute_id uuid,
  name varchar(255),
  description text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: id_verifications
-- ============================================

CREATE TABLE IF NOT EXISTS id_verifications (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  role_type user_role_enum NOT NULL,
  student_id varchar(255),
  teacher_id varchar(255),
  proof_file_path varchar(255) NOT NULL,
  original_filename varchar(255) NOT NULL,
  file_mime_type varchar(255) NOT NULL,
  file_size bigint NOT NULL,
  status verification_status_enum DEFAULT 'pending',
  admin_notes text,
  verified_by uuid,
  verified_at timestamp,
  rejection_count integer DEFAULT 0,
  last_rejection_at timestamp,
  created_at timestamp,
  updated_at timestamp,
  deleted_at timestamp
);

CREATE INDEX IF NOT EXISTS idx_id_verifications_user ON id_verifications(user_id);
CREATE INDEX IF NOT EXISTS idx_id_verifications_role ON id_verifications(role_type);
CREATE INDEX IF NOT EXISTS idx_id_verifications_status ON id_verifications(status);

-- ============================================
-- Table: institute
-- ============================================

CREATE TABLE IF NOT EXISTS institute (
  id uuid PRIMARY KEY,
  name varchar(255),
  description text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: ledger_entries
-- ============================================

CREATE TABLE IF NOT EXISTS ledger_entries (
  id uuid PRIMARY KEY,
  project_id uuid NOT NULL,
  type ledger_type NOT NULL,
  amount numeric(15,2) NOT NULL,
  description text NOT NULL,
  category varchar(100),
  budget_breakdown text,
  ledger_proof varchar(500),
  file_content_hash varchar(64),
  approval_status approval_status_enum DEFAULT 'Draft',
  is_initial_entry smallint DEFAULT 0,
  note text,
  approved_by uuid,
  created_by uuid,
  updated_by uuid,
  approved_at timestamp,
  rejected_at timestamp,
  archive smallint DEFAULT 0,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ledger_project ON ledger_entries(project_id);
CREATE INDEX IF NOT EXISTS idx_ledger_approved_by ON ledger_entries(approved_by);
CREATE INDEX IF NOT EXISTS idx_ledger_created_by ON ledger_entries(created_by);

-- ============================================
-- Table: meeting
-- ============================================

CREATE TABLE IF NOT EXISTS meeting (
  id uuid PRIMARY KEY,
  student_id varchar(100),
  title varchar(255),
  description text,
  scheduled_date timestamp,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  is_done smallint DEFAULT 0,
  minutes_content text,
  action_items text,
  expected_attendees text,
  attendees text,
  meeting_proof varchar(255),
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: migrations
-- ============================================

CREATE TABLE IF NOT EXISTS migrations (
  id SERIAL PRIMARY KEY,
  migration varchar(255) NOT NULL,
  batch integer NOT NULL
);

-- ============================================
-- Table: notifications
-- ============================================

CREATE TABLE IF NOT EXISTS notifications (
  id uuid PRIMARY KEY,
  user_id uuid,
  title varchar(255),
  message text,
  type varchar(50),
  is_read smallint DEFAULT 0,
  read_at timestamp,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: permission
-- ============================================

CREATE TABLE IF NOT EXISTS permission (
  id uuid PRIMARY KEY,
  module varchar(255),
  action varchar(255),
  permission varchar(255),
  description text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: personal_access_tokens
-- ============================================

CREATE TABLE IF NOT EXISTS personal_access_tokens (
  id BIGSERIAL PRIMARY KEY,
  tokenable_type varchar(255) NOT NULL,
  tokenable_id bigint NOT NULL,
  name text NOT NULL,
  token varchar(64) NOT NULL UNIQUE,
  abilities text,
  last_used_at timestamp,
  expires_at timestamp,
  created_at timestamp,
  updated_at timestamp
);

CREATE INDEX IF NOT EXISTS idx_personal_access_tokens_tokenable ON personal_access_tokens(tokenable_type, tokenable_id);

-- ============================================
-- Table: position
-- ============================================

CREATE TABLE IF NOT EXISTS position (
  id char(32) PRIMARY KEY,
  position_name varchar(255),
  created_at date DEFAULT CURRENT_DATE,
  updated_at date DEFAULT CURRENT_DATE
);

-- ============================================
-- Table: projects
-- ============================================

CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY,
  student_id varchar(100),
  title varchar(255),
  description text,
  objective text,
  category varchar(100),
  budget numeric(15,2),
  is_initial smallint DEFAULT 0,
  venue varchar(255),
  status varchar(50),
  proposed_by varchar(255),
  note text,
  project_proof bytea,
  start_date date,
  end_date date,
  approve_by varchar(255),
  approval_status varchar(50),
  approved_at timestamp,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  created_by uuid,
  updated_by uuid,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: push_subscriptions
-- ============================================

CREATE TABLE IF NOT EXISTS push_subscriptions (
  id uuid PRIMARY KEY,
  user_id uuid NOT NULL,
  endpoint text NOT NULL,
  auth_key text NOT NULL,
  public_key text NOT NULL,
  is_active smallint DEFAULT 1,
  created_at timestamp,
  updated_at timestamp,
  archive smallint DEFAULT 0,
  UNIQUE(endpoint)
);

CREATE INDEX IF NOT EXISTS idx_push_subscriptions_user ON push_subscriptions(user_id, is_active);

-- ============================================
-- Table: ratings
-- ============================================

CREATE TABLE IF NOT EXISTS ratings (
  id uuid PRIMARY KEY,
  project_id uuid,
  user_id uuid,
  rating_score integer,
  comments text,
  helpful_count integer DEFAULT 0,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0,
  UNIQUE(project_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_ratings_project ON ratings(project_id);

-- ============================================
-- Table: reset_password_token
-- ============================================

CREATE TABLE IF NOT EXISTS reset_password_token (
  id uuid PRIMARY KEY,
  user_id uuid,
  token varchar(255) NOT NULL,
  expires_at timestamp DEFAULT CURRENT_TIMESTAMP,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table: roles
-- ============================================

CREATE TABLE IF NOT EXISTS roles (
  id uuid PRIMARY KEY,
  permission_id uuid,
  name varchar(255),
  slug varchar(255),
  description text,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

-- ============================================
-- Table: role_permission
-- ============================================

CREATE TABLE IF NOT EXISTS role_permission (
  id uuid PRIMARY KEY,
  user_id uuid,
  role_id uuid,
  permission_id uuid,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_role_permission_user ON role_permission(user_id);
CREATE INDEX IF NOT EXISTS idx_role_permission_role ON role_permission(role_id);

-- ============================================
-- Table: sessions
-- ============================================

CREATE TABLE IF NOT EXISTS sessions (
  id varchar(255) PRIMARY KEY,
  user_id uuid,
  ip_address varchar(45),
  user_agent text,
  payload text,
  last_activity integer,
  archive smallint DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions(user_id);

-- ============================================
-- Table: student_csg_officers
-- ============================================

CREATE TABLE IF NOT EXISTS student_csg_officers (
  id varchar(100) PRIMARY KEY,
  user_id uuid,
  course_id uuid,  -- FIXED: Changed from varchar(100) to uuid to match course.id
  is_csg smallint DEFAULT 0,
  csg_position varchar(100),
  csg_term_start date,
  csg_term_end date,
  csg_is_active smallint DEFAULT 1,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_student_csg_user ON student_csg_officers(user_id);

-- ============================================
-- Table: teacher_adviser
-- ============================================

CREATE TABLE IF NOT EXISTS teacher_adviser (
  id varchar(100) PRIMARY KEY,
  user_id uuid,
  institute_id uuid,
  is_adviser smallint DEFAULT 0,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_teacher_adviser_user ON teacher_adviser(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_adviser_institute ON teacher_adviser(institute_id);

-- ============================================
-- Table: users
-- ============================================

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY,
  role_id uuid,
  name varchar(255),
  email varchar(255),
  email_verified_at timestamp,
  invitation_token varchar(64) UNIQUE,
  token_expires_at timestamp,
  is_token_expired smallint DEFAULT 0,
  phone varchar(20),
  password varchar(255),
  avatar_url varchar(255),
  profile_completed smallint DEFAULT 0,
  id_verification_id uuid,
  status user_status_enum DEFAULT 'active',
  last_login_at timestamp,
  remember_token varchar(100),
  created_at timestamp DEFAULT CURRENT_TIMESTAMP,
  updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
  archive smallint DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_users_role ON users(role_id);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================
-- INSERT DATA
-- ============================================

INSERT INTO badge (id, name, description, icon, category, created_at, updated_at, archive) VALUES
('05aa4b9c-235d-11f1-9647-10683825ce81', 'Event Organizer', 'Successfully organized an event', 'star', 'achievement', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa4d10-235d-11f1-9647-10683825ce81', 'Active Member', 'Participated in 5+ events', 'flame', 'engagement', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5cdb-235d-11f1-9647-10683825ce81', 'Budget Master', 'Managed project budget efficiently', 'coins', 'financial', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5ddb-235d-11f1-9647-10683825ce81', 'Team Leader', 'Led a successful project', 'crown', 'leadership', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5e25-235d-11f1-9647-10683825ce81', 'Quick Approver', 'Approved projects within 24 hours', 'flash', 'performance', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5e68-235d-11f1-9647-10683825ce81', 'Documentation Pro', 'Submitted complete project documentation', 'document', 'quality', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('05aa5eac-235d-11f1-9647-10683825ce81', 'Community Hero', 'Contributed to community service', 'heart', 'community', '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0);

INSERT INTO course (id, institute_id, name, description, created_at, updated_at, archive) VALUES
('059d226e-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSIS', NULL, '2026-03-19 06:29:42', '2026-04-14 05:49:49', 0),
('059d2571-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSCS', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d2612-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSPSY', NULL, '2026-03-19 06:29:42', '2026-04-14 05:49:58', 0),
('059d267c-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSCE', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d26df-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSM', NULL, '2026-03-19 06:29:42', '2026-04-14 05:50:34', 0),
('059d2744-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSN', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059d279f-235d-11f1-9647-10683825ce81', '059bab0d-235d-11f1-9647-10683825ce81', 'BSocSc', NULL, '2026-03-19 06:29:42', '2026-04-14 05:52:23', 0);

INSERT INTO institute (id, name, description, created_at, updated_at, archive) VALUES
('059bab0d-235d-11f1-9647-10683825ce81', 'ICDI', NULL, '2026-03-19 06:29:42', '2026-04-14 07:48:48', 0),
('059bb26f-235d-11f1-9647-10683825ce81', 'IBS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:24', 0),
('059bb31d-235d-11f1-9647-10683825ce81', 'IE', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:38', 0),
('059bb359-235d-11f1-9647-10683825ce81', 'IFS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:45', 0),
('059bb388-235d-11f1-9647-10683825ce81', 'IGDS', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:51', 0),
('059bb3b0-235d-11f1-9647-10683825ce81', 'IM', NULL, '2026-03-19 06:29:42', '2026-04-14 07:49:59', 0),
('059bb3d9-235d-11f1-9647-10683825ce81', 'CCJ', NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('c062692a-37d6-11f1-81d0-0ee6e07d3d3d', 'ISM', NULL, '2026-04-14 07:51:27', '2026-04-14 07:51:27', 0);

INSERT INTO permission (id, module, action, permission, description, created_at, updated_at, archive) VALUES
('059e4bca-235d-11f1-9647-10683825ce81', 'Projects', 'Approve', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e56c0-235d-11f1-9647-10683825ce81', 'Users', 'Create', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e5761-235d-11f1-9647-10683825ce81', 'Meetings', 'Schedule', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e5794-235d-11f1-9647-10683825ce81', 'Reports', 'View', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e57be-235d-11f1-9647-10683825ce81', 'Settings', 'Update', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e57e6-235d-11f1-9647-10683825ce81', 'Audit', 'Export', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0),
('059e580c-235d-11f1-9647-10683825ce81', 'Roles', 'Assign', NULL, NULL, '2026-03-19 06:29:42', '2026-03-19 06:29:42', 0);

INSERT INTO roles (id, permission_id, name, slug, description, created_at, updated_at, archive) VALUES
('059ef3f9-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Super Admin', 'superadmin', 'Full system access with all permissions', '2026-03-19 06:29:42', '2026-03-19 06:32:19', 0),
('059ef712-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Admin/Adviser', 'admin', 'Oversight and approvals of projects and transactions', '2026-03-19 06:29:42', '2026-03-19 06:32:48', 0),
('059efde1-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'CSG Officer', 'csg', 'Organization operations and submissions', '2026-03-19 06:29:42', '2026-03-19 06:33:09', 0),
('059f4170-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Student', 'student', 'View, rate, and engage in projects', '2026-03-19 06:29:42', '2026-03-19 06:33:29', 0),
('059f4213-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Ordinary Teacher', 'teacher', 'Teaching staff without advisory responsibilities', '2026-03-19 06:29:42', '2026-03-19 06:33:46', 0),
('059f5000-235d-11f1-9647-10683825ce81', '059e4bca-235d-11f1-9647-10683825ce81', 'Admin/SADU', 'admin-sadu', 'Administrator with SADU (Student Affairs and Discipline Office) responsibilities - manages student discipline and welfare', '2026-05-30 20:36:18', '2026-05-30 20:36:18', 0);

INSERT INTO users (id, role_id, name, email, email_verified_at, phone, password, avatar_url, profile_completed, status, last_login_at, created_at, updated_at, archive) VALUES
('087ccbc9-efa8-44e0-8435-3310207554d7', '059ef712-235d-11f1-9647-10683825ce81', 'EDWARD QUINTOS', 'emdgquintos@kld.edu.ph', '2026-04-24 06:30:43', '09234234234', '$2y$12$ez57d.qwWe0NGNJYtU0oDer2hVL6c2HIhbVWDHtQn.0kRBPeFNv6C', 'https://lh3.googleusercontent.com/a/ACg8ocKNyOIz6fzUfGjTf5xJ08o0F1301E2IJ351GVMfd1BpsMEHbQ=s96-c', 1, 'active', '2026-05-31 09:54:41', '2026-04-24 06:30:08', '2026-05-31 10:53:59', 0),
('97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059ef3f9-235d-11f1-9647-10683825ce81', 'JHONNY MACAWILI SUMULONG', 'jmsumulong@kld.edu.ph', '2026-04-24 05:33:52', NULL, '$2y$12$0tiBxJWX3qRNRUOr.V0UAu6MEf4y0kXAAU68YpFQQawyIpV8vukli', 'https://lh3.googleusercontent.com/a/ACg8ocLXVrWI7RGw1OTDRtjF9lXO27fk8oBLR-ZI3irgbXl_7fS5sA=s96-c', 1, 'active', '2026-05-31 08:29:12', '2026-04-24 05:33:52', '2026-05-31 08:29:12', 0),
('b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059efde1-235d-11f1-9647-10683825ce81', 'LAWRECE CALIBUSO', 'lpcalibuso@kld.edu.ph', '2026-04-24 05:48:10', '09398331593', '$2y$12$./qxavDvVjZjFlfz4kxRLOdREWZJKpD76iNFbqwNLDATYRi3L3VKK', 'https://lh3.googleusercontent.com/a/ACg8ocLOknbW0osCP4Lh54xqyTvuiW46epCl9qPOyoQbc8GYXbLWhA=s96-c', 1, 'active', '2026-04-26 18:09:04', '2026-04-24 05:48:10', '2026-05-28 03:38:42', 0),
('f6b776d6-8d77-43e3-976a-fbb0daffa325', '059f4213-235d-11f1-9647-10683825ce81', 'JAMES TAMAYO', 'jttamayo@kld.edu.ph', NULL, NULL, '$2y$12$9MvKx3sc82BPlDGMYqxRaeybMw2Lwjp5GX3EsJY5nZ527Ahg528w6', NULL, 0, 'active', '2026-05-28 01:33:53', '2026-05-10 09:19:57', '2026-05-28 01:33:53', 0);

INSERT INTO position (id, position_name, created_at, updated_at) VALUES
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

INSERT INTO student_csg_officers (id, user_id, course_id, is_csg, csg_position, csg_term_start, csg_term_end, csg_is_active, created_at, updated_at, archive) VALUES
('123', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '059d226e-235d-11f1-9647-10683825ce81', 0, 'Member', '2026-05-13', '2026-05-30', 0, '2026-04-24 05:34:53', '2026-05-28 01:20:45', 0),
('12312', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '059d226e-235d-11f1-9647-10683825ce81', 1, 'President', '2026-05-28', '2026-09-18', 1, '2026-04-24 05:48:10', '2026-05-31 09:33:23', 0),
('123123', NULL, NULL, 0, NULL, NULL, NULL, 0, '2026-04-24 06:28:24', '2026-05-24 16:27:09', 0);

INSERT INTO teacher_adviser (id, user_id, institute_id, is_adviser, created_at, updated_at, archive) VALUES
('123', '087ccbc9-efa8-44e0-8435-3310207554d7', '059bb388-235d-11f1-9647-10683825ce81', 1, '2026-04-24 06:30:43', '2026-05-31 05:31:01', 0);

INSERT INTO projects (id, student_id, title, description, objective, category, budget, is_initial, venue, status, proposed_by, note, start_date, end_date, approve_by, approval_status, approved_at, created_at, updated_at, created_by, updated_by, archive) VALUES
('2e8dc2e7-5618-44b4-9230-a48658daf0a6', NULL, 'test2', 'test2', 'test2', 'Sports', 0.00, 0, 'test2', 'Draft', 'test2', 'emdgquintos', '2026-06-26', '2026-06-30', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-05-26 12:24:48', '2026-05-26 12:24:15', '2026-05-26 12:24:48', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '087ccbc9-efa8-44e0-8435-3310207554d7', 0),
('e6808957-5fca-42ef-813a-446935e61126', NULL, 'TESTING', 'TESTING', 'TESTING', 'Sports', 9012.00, 1, 'TESTING', 'Draft', 'TESTING', 'emdgquintos', '2026-06-25', '2026-06-25', '087ccbc9-efa8-44e0-8435-3310207554d7', 'Approved', '2026-05-26 09:54:23', '2026-05-26 09:44:07', '2026-05-26 10:28:00', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', 0);

INSERT INTO ledger_entries (id, project_id, type, amount, description, category, budget_breakdown, approval_status, is_initial_entry, note, approved_by, created_by, updated_by, approved_at, rejected_at, archive, created_at, updated_at) VALUES
('81f86e97-f3b4-4ab0-b437-9396875ac877', 'e6808957-5fca-42ef-813a-446935e61126', 'Expense', 23423.00, 'qwe', NULL, '"[{\"id\":1,\"item\":\"qwe\",\"qty\":1,\"unitPrice\":\"23423\",\"amount\":23423}]"', 'Pending Adviser Approval', 0, NULL, NULL, '97bf6c0e-420b-4627-be8b-31f37f5bed9f', NULL, NULL, NULL, 0, '2026-05-26 12:03:29', '2026-05-26 12:03:42'),
('b1be13a0-1aa8-4fca-bbef-e28771a65872', 'e6808957-5fca-42ef-813a-446935e61126', 'Income', 12.00, 'emdgquintos', NULL, '"[{\"id\":1,\"item\":\"emdgquintos\",\"qty\":1,\"unitPrice\":\"12\",\"amount\":12}]"', 'Approved', 0, '12', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-05-26 10:23:57', NULL, 0, '2026-05-26 09:56:17', '2026-05-26 10:23:57'),
('b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'e6808957-5fca-42ef-813a-446935e61126', 'Initial', 9000.00, 'Initial project budget baseline', 'Project Budget Baseline', NULL, 'Approved', 0, 'Auto-generated baseline on project creation', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', '087ccbc9-efa8-44e0-8435-3310207554d7', '2026-05-26 09:54:23', NULL, 0, '2026-05-26 09:44:07', '2026-05-26 10:27:57');

INSERT INTO chain (id, project_id, block_index, prev_hash, hash, data_snapshot, created_at) VALUES
('495a3be7-d8ca-4c57-b8fa-c4dd4e146663', 'e6808957-5fca-42ef-813a-446935e61126', 1, '77db84e18d6eed03125bd29254ecf915f80a95df10fbd20721937eceb72bf40e', '6ee3ddda0f513bd562f67b253346edf1a37b253e5f8bf9a5248901164df52e5c', '"{\"type\":\"ledger\",\"ledger_id\":\"b55d1a03-f4f8-4592-8573-eb3dc6de246d\",\"project_id\":\"e6808957-5fca-42ef-813a-446935e61126\",\"description\":\"Initial project budget baseline\",\"budget_breakdown\":null,\"amount\":\"9000.00\",\"entry_type\":\"Initial\",\"approval_status\":\"Approved\",\"approved_at\":\"2026-05-26T02:54:23+00:00\",\"snapshot_nonce\":\"30656874b281439f\"}"', '2026-05-26 02:54:23'),
('82988b23-941d-4131-bb89-4dc212e1671f', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 0, NULL, '58edf29a2345e763b7e5952b8f632f7cd1626829f7d9e4812731cbe672ea110d', '"{\"type\":\"project\",\"project_id\":\"2e8dc2e7-5618-44b4-9230-a48658daf0a6\",\"title\":\"test2\",\"description\":\"test2\",\"amount\":\"0.00\",\"approval_status\":\"Approved\",\"approved_at\":\"2026-05-26T05:24:48+00:00\"}"', '2026-05-26 05:24:48'),
('873ef469-f013-4577-8a06-4a62ecb0c7f3', 'e6808957-5fca-42ef-813a-446935e61126', 2, '6ee3ddda0f513bd562f67b253346edf1a37b253e5f8bf9a5248901164df52e5c', 'f5ca985927f6525375b6588fed17390a7575ad7f7c91ce9013636e1473a606df', '"{\"type\":\"ledger\",\"ledger_id\":\"b1be13a0-1aa8-4fca-bbef-e28771a65872\",\"project_id\":\"e6808957-5fca-42ef-813a-446935e61126\",\"description\":\"emdgquintos\",\"budget_breakdown\":\"[{\\\"id\\\":1,\\\"item\\\":\\\"emdgquintos\\\",\\\"qty\\\":1,\\\"unitPrice\\\":\\\"12\\\",\\\"amount\\\":12}]\",\"amount\":\"12.00\",\"entry_type\":\"Income\",\"approval_status\":\"Approved\",\"approved_at\":\"2026-05-26T03:23:57+00:00\",\"snapshot_nonce\":\"9fbe6f91a196e200\"}"', '2026-05-26 03:23:57'),
('9125283b-5a09-4fe7-912d-b88d87d62e80', 'e6808957-5fca-42ef-813a-446935e61126', 0, NULL, '77db84e18d6eed03125bd29254ecf915f80a95df10fbd20721937eceb72bf40e', '"{\"type\":\"project\",\"project_id\":\"e6808957-5fca-42ef-813a-446935e61126\",\"title\":\"TESTING\",\"description\":\"TESTING\",\"amount\":\"9000.00\",\"approval_status\":\"Approved\",\"approved_at\":\"2026-05-26T02:54:23+00:00\"}"', '2026-05-26 02:54:23');

INSERT INTO audit_logs (id, user_id, actionable_id, actionable_type, action, module, action_type, status, details, ip_address, browser_info, created_at, archive) VALUES
('26df601b-a438-49ff-b6d6-548d9e6faddc', '087ccbc9-efa8-44e0-8435-3310207554d7', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 09:54:23', 0),
('5d72cca0-211c-46e8-9d82-42c04a8734ce', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:39', 0),
('76890987-36b0-471e-9a76-ff6d2bdfbaf8', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'e6808957-5fca-42ef-813a-446935e61126', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project "TESTING"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:44:07', 0),
('966502e3-3aca-421e-b267-3a1fe5087ed6', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '81f86e97-f3b4-4ab0-b437-9396875ac877', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Expense ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:03:29', 0),
('a9a68477-43da-47b4-b69b-05fab089b10d', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Created', 'ledger', 'create', 'Success', 'Created Income ledger entry for project ID e6808957-5fca-42ef-813a-446935e61126', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 09:56:17', 0),
('a9ca6f4c-3b0b-49c6-bee2-bb4e1d52c5cb', '97bf6c0e-420b-4627-be8b-31f37f5bed9f', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Created', 'projects', 'create', 'Success', 'Created project "test2"', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 12:24:15', 0),
('aef0ce0a-7df2-422e-b7d1-6013f2fa3776', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b1be13a0-1aa8-4fca-bbef-e28771a65872', 'ledger_entry', 'Ledger Entry Approved', 'ledger', NULL, NULL, 'emdgquintos — TESTING', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:23:57', 0),
('e2e0b8b3-d4b1-4672-a2f5-06dd7dbb7877', '087ccbc9-efa8-44e0-8435-3310207554d7', 'b55d1a03-f4f8-4592-8573-eb3dc6de246d', 'ledger_entry', 'Ledger Entry Restored from Blockchain', 'ledger', NULL, NULL, 'Restored to approved state using blockchain snapshot', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:27:57', 0),
('e6e29f6b-9348-44a5-9ddc-aa7fddb999f0', '087ccbc9-efa8-44e0-8435-3310207554d7', NULL, 'project', 'Project Budget Synced from Ledger', 'ledger', NULL, NULL, 'Synchronized 1 project budget(s) with approved ledger totals', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-05-26 10:28:00', 0),
('ed821bc2-ec85-4c96-8405-77e2a0535329', '087ccbc9-efa8-44e0-8435-3310207554d7', '2e8dc2e7-5618-44b4-9230-a48658daf0a6', 'project', 'Project Approved', 'approvals', NULL, NULL, 'Approved project: test2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0', '2026-05-26 12:24:48', 0);

INSERT INTO ratings (id, project_id, user_id, rating_score, comments, helpful_count, created_at, archive) VALUES
('598910fc-5661-47ca-b1c9-938b5ea790c2', 'e6808957-5fca-42ef-813a-446935e61126', 'b09e5bfb-75fc-4b1f-9a37-4bf588bd6a1b', 5, '123', 0, '2026-05-26 10:29:00', 0);

INSERT INTO notifications (id, user_id, title, message, type, is_read, read_at, created_at, updated_at, archive) VALUES
('06d20008-235d-11f1-9647-10683825ce81', NULL, 'Welcome', 'Thank you for regitering with STEP Platform.', 'system', 0, NULL, '2026-03-20 13:30:00', '2026-04-14 03:55:02', 0);

INSERT INTO migrations (migration, batch) VALUES
('2026_04_09_050446_create_personal_access_tokens_table', 1),
('2026_04_09_120000_add_file_content_hash_to_ledger_entries', 2),
('2026_04_12_000001_add_profile_fields_to_users_table', 3),
('2026_04_14_000000_add_sample_upcoming_meetings', 4),
('2026_04_14_000001_fix_onboarding_foreign_keys', 4),
('2026_04_15_000000_fix_teacher_adviser_fk_constraint', 4),
('2026_04_16_000001_create_push_subscriptions_table', 5),
('2026_04_17_000001_create_id_verification_table', 6),
('2026_04_17_000002_add_id_verification_to_users', 7),
('2026_04_20_add_invitation_tokens_to_users', 8);

-- ============================================
-- ADD FOREIGN KEY CONSTRAINTS
-- ============================================

ALTER TABLE approval
  ADD CONSTRAINT fk_approval_employee FOREIGN KEY (employee_id) REFERENCES teacher_adviser(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_approval_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE;

ALTER TABLE audit_logs
  ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE badge_collected
  ADD CONSTRAINT fk_badge_collected_badge FOREIGN KEY (badge_id) REFERENCES badge(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_badge_collected_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE chain
  ADD CONSTRAINT fk_chain_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE;

ALTER TABLE course
  ADD CONSTRAINT fk_course_institute FOREIGN KEY (institute_id) REFERENCES institute(id) ON DELETE CASCADE;

ALTER TABLE id_verifications
  ADD CONSTRAINT fk_id_verifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_id_verifications_verified_by FOREIGN KEY (verified_by) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE ledger_entries
  ADD CONSTRAINT fk_ledger_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_ledger_approved_by FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_ledger_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_ledger_updated_by FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE meeting
  ADD CONSTRAINT fk_meeting_student FOREIGN KEY (student_id) REFERENCES student_csg_officers(id) ON DELETE SET NULL;

ALTER TABLE notifications
  ADD CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE projects
  ADD CONSTRAINT fk_projects_student FOREIGN KEY (student_id) REFERENCES student_csg_officers(id) ON DELETE SET NULL;

ALTER TABLE push_subscriptions
  ADD CONSTRAINT fk_push_subscriptions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ratings
  ADD CONSTRAINT fk_ratings_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE reset_password_token
  ADD CONSTRAINT fk_reset_password_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE roles
  ADD CONSTRAINT fk_roles_permission FOREIGN KEY (permission_id) REFERENCES permission(id) ON DELETE SET NULL;

ALTER TABLE role_permission
  ADD CONSTRAINT fk_role_permission_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_role_permission_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_role_permission_permission FOREIGN KEY (permission_id) REFERENCES permission(id) ON DELETE CASCADE;

ALTER TABLE sessions
  ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE student_csg_officers
  ADD CONSTRAINT fk_student_csg_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_student_csg_course FOREIGN KEY (course_id) REFERENCES course(id) ON DELETE SET NULL;

ALTER TABLE teacher_adviser
  ADD CONSTRAINT fk_teacher_adviser_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_teacher_adviser_institute FOREIGN KEY (institute_id) REFERENCES institute(id) ON DELETE SET NULL;

ALTER TABLE users
  ADD CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_users_id_verification FOREIGN KEY (id_verification_id) REFERENCES id_verifications(id) ON DELETE SET NULL;

COMMIT;