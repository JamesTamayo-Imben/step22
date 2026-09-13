import { BookOpen, User, Users, FileText, CheckCircle, ArrowRight, Shield, Upload, Eye, MessageSquare, Star, Lock, TrendingUp } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function UserGuide() {
  return (
    <main className="min-h-screen bg-slate-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-6">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">STEP User Guide</h1>
          <p className="mt-2 text-lg text-slate-600">
            Master the School Transparency and Engagement Portal – your comprehensive platform for CSG governance, financial transparency, and community engagement at Kolehiyo ng Lungsod ng Dasmariñas
          </p>
          <div className="mt-6">
            <button
              onClick={() => router.visit('/')}
              className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
            >
              Back to Home
            </button>
          </div>
        </header>

        <nav className="mb-6 bg-white p-6 rounded-2xl shadow-lg border border-slate-200">
          <h2 className="text-lg font-semibold text-slate-900 mb-4">Quick Navigation</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-4">
            <a href="#getting-started" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              Getting Started
            </a>
            <a href="#user-roles" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              User Roles
            </a>
            <a href="#csg-projects" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              CSG Projects
            </a>
            <a href="#ledger-integrity" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
               Financial Ledger
            </a>
            <a href="#ratings-engagement" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              Ratings & Engagement
            </a>
            <a href="#council-positions" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              Council Structure
            </a>
          </div>
        </nav>

        <div className="space-y-12">
          <section id="getting-started" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
             Getting Started with STEP
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">1. Google OAuth Login</h3>
                <p className="text-slate-600 mb-4">
                  STEP uses secure Google authentication for seamless access. Log in with your @kld.edu.ph email address to access the platform.
                </p>
                <div className="bg-blue-50 p-4 rounded-lg border-l-4 border-blue-500">
                  <p className="text-sm text-blue-800">
                    <strong>Required:</strong> You must use an institutional email (@kld.edu.ph) to register. Personal Gmail accounts will be rejected.
                  </p>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">2. Profile Onboarding</h3>
                <p className="text-slate-600 mb-4">
                  Upon first login, you'll complete a role-based profile setup:
                </p>
                <ul className="list-disc list-inside space-y-2 text-slate-700 ml-4">
                  <li>Select your role (Student, Teacher, CSG Officer, or Adviser)</li>
                  <li>Provide your institutional ID (Student ID or Employee ID)</li>
                  <li>Complete your contact information</li>
                  <li>Confirm your institutional affiliation</li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">3. Your Personal Dashboard</h3>
                <p className="text-slate-600 mb-4">
                  Your dashboard displays role-specific information:
                </p>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Active Projects</h4>
                    <p className="text-sm text-slate-600">View CSG projects you're involved with and their approval status</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Financial Summary</h4>
                    <p className="text-sm text-slate-600">Track project budgets, expenses, and ledger transactions</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Engagement Points</h4>
                    <p className="text-sm text-slate-600">Earn points by submitting ratings and participating in governance</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2"> Notifications</h4>
                    <p className="text-sm text-slate-600">Receive updates on project approvals, ratings, and council activities</p>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <section id="user-roles" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
               Understanding User Roles
            </h2>
            <p className="text-slate-600 mb-6">STEP has four distinct roles, each with specific permissions and responsibilities tailored to the institutional governance structure.</p>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <span className='text-blue-600'>MEMBER</span> / Student
                </h3>
                <p className="text-slate-600 mb-3">General student access for viewing and engaging with projects.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ View all CSG projects and their status</li>
                  <li>✓ Submit ratings and feedback on projects</li>
                  <li>✓ View public financial summaries</li>
                  <li>✓ Submit concerns and suggestions</li>
                  <li>✓ View CSG upcomming and past meetings</li>
                </ul>
              </div>

              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                <span className='text-blue-600'>MEMBER</span> / Ordinary Teacher
                </h3>
                <p className="text-slate-600 mb-3">Instructors with oversight and advisory capabilities.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ View projects and transactions</li>
                  <li>✓ Submit ratings and observations</li>
                  <li>✓ View public financial summaries</li>
                  <li>✓ Submit concerns and suggestions</li>
                  <li>✓ View CSG upcomming and past meetings</li>
                </ul>
              </div>

              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                   <span className='text-blue-600'>COUNCIL</span> / CSG Officer
                </h3>
                <p className="text-slate-600 mb-3">Council members responsible for project execution and finance.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ Create, edit, and delete CSG projects</li>
                  <li>✓ Record financial ledger entries</li>
                  <li>✓ Upload proof documents (receipts, photos)</li>
                  <li>✓ Submit projects for adviser approval</li>
                  <li>✓ View integrity chain for own projects</li>
                  <li>✓ Position-based permissions (President, Treasurer, etc.)</li>
                  <li>✓ Schedule and manage CSG meetings</li>
                </ul>
              </div>

              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                 <span className='text-blue-600'>ADMIN</span> / Council Adviser
                </h3>
                <p className="text-slate-600 mb-3">Faculty advisers with project and transaction approval authority.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ Review and approve/reject CSG projects</li>
                  <li>✓ Approve or reject ledger entries</li>
                  <li>✓ View complete project audit trails</li>
                  <li>✓ Verify blockchain integrity chains</li>
                  <li>✓ Generate institutional reports</li>
                  <li>✓ Moderate ratings and feedback</li>
                </ul>
              </div>

              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                   <span className='text-blue-600'>ADMIN</span> / SADU Adviser
                </h3>
                <p className="text-slate-600 mb-3">Student Affairs & Discipline Office oversight role.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ Similar to Adviser with SADU-specific scope</li>
                  <li>✓ Discipline-related project oversight</li>
                  <li>✓ Access to SADU-filtered reports</li>
                  <li>✓ Approve discipline and conduct matters</li>
                </ul>
              </div>

              <div className="border-2 border-blue-200 rounded-lg p-6 bg-blue-50">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <span className='text-blue-600'>SUPERADMIN</span> / IT Administrator
                </h3>
                <p className="text-slate-600 mb-3">System administrators with complete platform control.</p>
                <ul className="text-sm text-slate-700 space-y-2 ml-2">
                  <li>✓ Manage all users and roles</li>
                  <li>✓ Edit system permissions and grants</li>
                  <li>✓ Configure CSG positions and terms</li>
                  <li>✓ View system-wide audit logs</li>
                  <li>✓ System configuration and settings</li>
                  <li>✓ Full platform access and override</li>
                </ul>
              </div>
            </div>
          </section>

          <section id="csg-projects" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              CSG Projects & Governance
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Project Lifecycle</h3>
                <p className="text-slate-600 mb-4">
                  CSG projects follow a structured approval workflow to ensure transparency and accountability.
                </p>
                <div className="bg-slate-50 p-6 rounded-lg space-y-3">
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold flex-shrink-0">1</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Create Project</h4>
                      <p className="text-slate-600 text-sm">CSG Officers create projects with title, description, objectives, timeline, and initial budget.</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold flex-shrink-0">2</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Submit for Review</h4>
                      <p className="text-slate-600 text-sm">Once complete, submit the project to the Adviser for review and approval. All supporting documents must be attached.</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold flex-shrink-0">3</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Adviser Review</h4>
                      <p className="text-slate-600 text-sm">The Adviser reviews all details and may approve, request changes, or reject. Feedback is documented.</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold flex-shrink-0">4</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Project Approved</h4>
                      <p className="text-slate-600 text-sm">Once approved, the project's ledger integrity chain is initialized. Financial tracking and progress updates can now begin.</p>
                    </div>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Project Information Required</h3>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Basic Details</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Project title</li>
                      <li>• Detailed description</li>
                      <li>• Project objectives</li>
                      <li>• Target beneficiaries</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2"> Planning & Budget</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Start and end dates</li>
                      <li>• Total budget allocation</li>
                      <li>• Budget breakdown</li>
                      <li>• Resource requirements</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">Supporting Documents</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Project proposal</li>
                      <li>• Detailed budget plan</li>
                      <li>• Organizational approvals</li>
                      <li>• Risk assessment</li>
                    </ul>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2"> Progress Tracking</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Milestone definitions</li>
                      <li>• Completion percentage</li>
                      <li>• Status updates</li>
                      <li>• Photo documentation</li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <section id="ledger-integrity" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
               Financial Ledger & Integrity Chain
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Understanding the Ledger System</h3>
                <p className="text-slate-600 mb-4">
                  STEP maintains an immutable financial record for every approved project using a tamper-evident integrity chain. Once a transaction is recorded, it becomes part of a permanent audit trail.
                </p>
                <div className="bg-blue-50 p-4 rounded-lg border-l-4 border-blue-500">
                  <p className="text-sm text-blue-800">
                    <strong>Key Principle:</strong> All ledger entries are permanent. No transactions can be edited or deleted once recorded. Corrections are made through new entries that supersede previous ones.
                  </p>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Blockchain Integrity Chain</h3>
                <p className="text-slate-600 mb-4">
                  Each approved project gets a cryptographic integrity chain that ensures all financial transactions are tamper-evident:
                </p>
                <div className="bg-blue-50 p-6 rounded-lg space-y-4">
                  <div className="flex gap-4">
                    <div className="flex-shrink-0">
                      <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold text-sm">G</div>
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Genesis Block</h4>
                      <p className="text-slate-600 text-sm">Created when the project is approved. Contains a cryptographic snapshot of the project's core details (title, budget, approval date).</p>
                    </div>
                  </div>
                  <div className="flex gap-4">
                    <div className="flex-shrink-0">
                      <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold text-sm">L</div>
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Ledger Blocks</h4>
                      <p className="text-slate-600 text-sm">Each financial transaction creates a new block. Every block includes its own data plus a hash of the previous block, creating an unbreakable chain.</p>
                    </div>
                  </div>
                  <div className="flex gap-4">
                    <div className="flex-shrink-0">
                      <div className="w-8 h-8 bg-red-600 text-white rounded-full flex items-center justify-center font-bold text-sm">✓</div>
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Tamper Evidence</h4>
                      <p className="text-slate-600 text-sm">If any historical transaction is altered (even by 1 character), all subsequent block hashes become invalid — immediately exposing tampering.</p>
                    </div>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Recording Transactions</h3>
                <p className="text-slate-600 mb-4">CSG Officers record financial transactions with complete documentation:</p>
                <div className="space-y-3">
                  <div className="flex items-start gap-3">
                    <Upload className="w-5 h-5 text-blue-600 mt-1 flex-shrink-0" />
                    <div>
                      <strong className="text-slate-900">Transaction Type:</strong> Expense or income associated with the project
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <Upload className="w-5 h-5 text-blue-600 mt-1 flex-shrink-0" />
                    <div>
                      <strong className="text-slate-900">Amount & Description:</strong> Clear details of what was purchased/received and the amount
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <Upload className="w-5 h-5 text-blue-600 mt-1 flex-shrink-0" />
                    <div>
                      <strong className="text-slate-900">Proof Documents:</strong> Receipts, invoices, or photos confirming the transaction
                    </div>
                  </div>
                  <div className="flex items-start gap-3">
                    <Upload className="w-5 h-5 text-blue-600 mt-1 flex-shrink-0" />
                    <div>
                      <strong className="text-slate-900">Category:</strong> Classify the expense (supplies, services, travel, etc.)
                    </div>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Approval Workflow</h3>
                <div className="flex flex-col md:flex-row items-center gap-4">
                  <div className="flex-1 text-center p-4 bg-blue-50 rounded-lg">
                    <div className="w-12 h-12 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">1</div>
                    <p className="text-sm text-slate-600"><strong>CSG Officer</strong><br/>Records & Submits</p>
                  </div>
                  <ArrowRight className="w-6 h-6 text-slate-400 hidden md:block" />
                  <div className="flex-1 text-center p-4 bg-blue-50 rounded-lg">
                    <div className="w-12 h-12 bg-blue-500 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">2</div>
                    <p className="text-sm text-slate-600"><strong>Adviser</strong><br/>Reviews & Approves</p>
                  </div>
                  <ArrowRight className="w-6 h-6 text-slate-400 hidden md:block" />
                  <div className="flex-1 text-center p-4 bg-blue-50 rounded-lg">
                    <div className="w-12 h-12 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">3</div>
                    <p className="text-sm text-slate-600"><strong>Ledger</strong><br/>Added to Chain</p>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Verifying Ledger Integrity</h3>
                <p className="text-slate-600 mb-4">
                  CSG Officers and Advisers can verify that a project's ledger hasn't been tampered with:
                </p>
                <div className="bg-blue-50 p-4 rounded-lg border-l-4 border-blue-500">
                  <p className="text-sm text-blue-800">
                    ✓ <strong>Verification Report:</strong> Shows all blocks in the chain, their hashes, and whether the chain is intact. Any mismatch indicates tampering and triggers an audit.
                  </p>
                </div>
              </div>
            </div>
          </section>

          <section id="ratings-engagement" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              Ratings & Community Engagement
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Submitting Project Ratings</h3>
                <p className="text-slate-600 mb-4">
                  Students and teachers can rate and provide feedback on CSG projects. Your ratings help the community evaluate project success and impact.
                </p>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
                    <h4 className="font-semibold text-slate-900 mb-2">Quality Rating</h4>
                    <p className="text-sm text-slate-600">Rate the overall quality and execution of the project (1-5 stars)</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
                    <h4 className="font-semibold text-slate-900 mb-2">Written Feedback</h4>
                    <p className="text-sm text-slate-600">Provide constructive comments about what worked well and areas for improvement</p>
                  </div>
                  <div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
                    <h4 className="font-semibold text-slate-900 mb-2">Impact Assessment</h4>
                    <p className="text-sm text-slate-600">Evaluate how well the project met its stated objectives and benefited the community</p>
                  </div>
                </div>
              </div>

              {/* <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Gamification System</h3>
                <p className="text-slate-600 mb-4">
                  STEP includes engagement gamification to encourage participation and reward active community members:
                </p>
                <div className="space-y-3">
                  <div className="flex items-start gap-3 p-3 bg-slate-50 rounded-lg">
                    <TrendingUp className="w-5 h-5 text-blue-600 flex-shrink-0 mt-1" />
                    <div>
                      <strong className="text-slate-900">Engagement Points:</strong> Earn points by submitting ratings, providing feedback, and participating in governance
                    </div>
                  </div>
                  <div className="flex items-start gap-3 p-3 bg-slate-50 rounded-lg">
                    <Star className="w-5 h-5 text-yellow-500 flex-shrink-0 mt-1" />
                    <div>
                      <strong className="text-slate-900">Achievements & Badges:</strong> Unlock special badges for milestones (10 ratings, helpful feedback, etc.)
                    </div>
                  </div>
                  <div className="flex items-start gap-3 p-3 bg-slate-50 rounded-lg">
                    <Users className="w-5 h-5 text-purple-600 flex-shrink-0 mt-1" />
                    <div>
                      <strong className="text-slate-900">Leaderboard:</strong> See how your engagement compares to other community members
                    </div>
                  </div>
                </div>
              </div> */}

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Rating Moderation</h3>
                <p className="text-slate-600 mb-4">
                  Advisers and administrators monitor ratings to maintain community standards and prevent abuse. All ratings are moderated to ensure constructiveness.
                </p>
              </div>
            </div>
          </section>

          {/* <section id="council-positions" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              <Users className="w-8 h-8 text-purple-600" /> Council Structure & Positions
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Standard CSG Positions</h3>
                <p className="text-slate-600 mb-4">
                  CSG Officers can hold specific council positions, each with distinct permissions and responsibilities:
                </p>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="p-4 border-2 border-purple-200 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">👑 President</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Full project and ledger management</li>
                      <li>• Authority to approve transactions</li>
                      <li>• Meeting coordination</li>
                      <li>• Council representation</li>
                    </ul>
                  </div>
                  <div className="p-4 border-2 border-purple-200 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">💰 Treasurer</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Primary ledger entry responsibility</li>
                      <li>• Financial record management</li>
                      <li>• Budget tracking and reporting</li>
                      <li>• Proof document uploads</li>
                    </ul>
                  </div>
                  <div className="p-4 border-2 border-purple-200 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">📋 Secretary</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Meeting minutes documentation</li>
                      <li>• Record keeping</li>
                      <li>• Communication coordination</li>
                      <li>• Project documentation</li>
                    </ul>
                  </div>
                  <div className="p-4 border-2 border-purple-200 rounded-lg">
                    <h4 className="font-semibold text-slate-900 mb-2">👥 Officer / Member</h4>
                    <ul className="text-sm text-slate-600 space-y-1">
                      <li>• Limited project permissions</li>
                      <li>• Support financial tracking</li>
                      <li>• Assist with project execution</li>
                      <li>• Participate in decisions</li>
                    </ul>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Position-Based Permissions</h3>
                <p className="text-slate-600 mb-4">
                  Each position has a specific set of permissions configured by the Superadmin. These can be customized per term to match your council's structure.
                </p>
                <div className="bg-blue-50 p-4 rounded-lg border-l-4 border-blue-500">
                  <p className="text-sm text-blue-800">
                    <strong>Council Terms:</strong> Positions and permissions can change each academic term. Advisers and Superadmin manage position assignments and term dates.
                  </p>
                </div>
              </div>
            </div>
          </section> */}

          <section className="bg-gradient-to-r from-blue-50 to-blue-50 p-8 rounded-2xl border-2 border-blue-300">
            <h2 className="text-2xl font-bold text-slate-900 mb-4 flex items-center gap-2">
              Best Practices for STEP Users
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div className="space-y-3">
                <h3 className="font-semibold text-slate-900">For CSG Officers</h3>
                <ul className="text-sm text-slate-700 space-y-2">
                  <li>✓ Record ledger entries immediately after transactions — don't batch them later</li>
                  <li>✓ Always attach proof documents (photos, receipts) with each entry</li>
                  <li>✓ Review the integrity chain regularly to ensure no tampering</li>
                  <li>✓ Communicate project updates frequently for transparency</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-slate-900">For Advisers</h3>
                <ul className="text-sm text-slate-700 space-y-2">
                  <li>✓ Review and approve transactions promptly to keep projects moving</li>
                  <li>✓ Check the blockchain integrity chain before approving large transactions</li>
                  <li>✓ Monitor ratings to maintain community constructiveness</li>
                  <li>✓ Document approval decisions in the system for audit purposes</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-slate-900">For Students</h3>
                <ul className="text-sm text-slate-700 space-y-2">
                  <li>✓ Provide constructive, specific feedback when rating projects</li>
                  <li>✓ Monitor your engagement points and pursue badges</li>
                  <li>✓ Review project details and financial summaries regularly</li>
                  <li>✓ Participate in council meetings and governance discussions</li>
                </ul>
              </div>
              <div className="space-y-3">
                <h3 className="font-semibold text-slate-900">General Tips</h3>
                <ul className="text-sm text-slate-700 space-y-2">
                  <li>✓ Check notifications regularly for updates on your projects</li>
                  <li>✓ Use clear, professional language in all submissions</li>
                  <li>✓ Keep meeting minutes and documentation thorough and timely</li>
                  <li>✓ Report issues to your Adviser or Superadmin immediately</li>
                </ul>
              </div>
            </div>
          </section>

          {/* <section className="bg-blue-50 p-8 rounded-2xl border border-blue-200">
            <h2 className="text-2xl font-bold text-slate-900 mb-4">❓ Need Help or Have Questions?</h2>
            <p className="text-slate-600 mb-6">
              If you encounter any issues or have questions about using STEP, reach out to your CSG Adviser, Council Administrator, or contact the Superadmin for system-level support.
            </p>
            <div className="space-y-4 mb-6">
              <div className="p-4 bg-white rounded-lg border border-blue-200">
                <h3 className="font-semibold text-slate-900 mb-2">🔍 Common Issues</h3>
                <ul className="text-sm text-slate-600 space-y-1">
                  <li>• <strong>Can't log in?</strong> Ensure you're using your @kld.edu.ph email</li>
                  <li>• <strong>Project won't submit?</strong> Check that all required fields are completed</li>
                  <li>• <strong>Ledger entry rejected?</strong> Review the feedback and resubmit with corrections</li>
                  <li>• <strong>Missing notification?</strong> Check your email spam folder and system notifications</li>
                </ul>
              </div>
            </div>
            <div className="flex flex-col sm:flex-row gap-4">
              <button
                onClick={() => router.visit('/')}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
              >
                Back to Home
              </button>
              <button
                onClick={() => window.location.href = 'mailto:support@kld.edu.ph'}
                className="px-6 py-3 border border-blue-600 text-blue-600 rounded-lg hover:bg-blue-50 transition"
              >
                Email Support
              </button>
            </div>
          </section> */}
        </div>
      </div>
      </main>
    // </AuthenticatedLayout>
  );
}
