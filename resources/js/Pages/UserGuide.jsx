import { BookOpen, User, Users, FileText, CheckCircle, ArrowRight, Shield, Upload, Eye, MessageSquare } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function UserGuide() {
  return (
    <main className="min-h-screen bg-slate-50 py-14 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto">
        <header className="text-center mb-12">
          <h1 className="text-4xl lg:text-5xl font-bold text-slate-900 mb-4">STEP User Guide</h1>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto">
            Your comprehensive guide to using the School Transparency and Engagement Portal effectively
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

        <nav className="mb-12 bg-white p-6 rounded-2xl shadow-lg border border-slate-200">
          <h2 className="text-lg font-semibold text-slate-900 mb-4">Quick Navigation</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <a href="#getting-started" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              <BookOpen className="w-4 h-4" /> Getting Started
            </a>
            <a href="#user-roles" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              <Users className="w-4 h-4" /> User Roles
            </a>
            <a href="#creating-projects" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              <FileText className="w-4 h-4" /> Creating Projects
            </a>
            <a href="#managing-transactions" className="flex items-center gap-2 text-blue-600 hover:text-blue-800 transition">
              <CheckCircle className="w-4 h-4" /> Managing Transactions
            </a>
          </div>
        </nav>

        <div className="space-y-12">
          <section id="getting-started" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              <BookOpen className="w-8 h-8 text-blue-600" /> Getting Started
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">1. Account Registration</h3>
                <p className="text-slate-600 mb-4">
                  New users must register with their student ID and email. Your account will be assigned a role based on your position in the student council hierarchy.
                </p>
                <div className="bg-blue-50 p-4 rounded-lg border-l-4 border-blue-500">
                  <p className="text-sm text-blue-800">
                    <strong>Note:</strong> Account verification may take 24-48 hours. You'll receive an email confirmation once approved.
                  </p>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">2. Dashboard Overview</h3>
                <p className="text-slate-600 mb-4">
                  After logging in, you'll be directed to your personalized dashboard. Here you can view:
                </p>
                <ul className="list-disc list-inside space-y-2 text-slate-700 ml-4">
                  <li>Active projects and their progress</li>
                  <li>Recent transactions and ledger entries</li>
                  <li>Pending approvals and notifications</li>
                  <li>Your engagement points and achievements</li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">3. Navigation Basics</h3>
                <p className="text-slate-600">
                  Use the sidebar menu to navigate between different sections. The main areas include Projects, Ledger, Ratings, and Profile settings.
                </p>
              </div>
            </div>
          </section>

          <section id="user-roles" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              <Users className="w-8 h-8 text-green-600" /> Understanding User Roles
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="border border-slate-200 rounded-lg p-6">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <User className="w-5 h-5 text-blue-600" /> Student
                </h3>
                <p className="text-slate-600 mb-3">Basic user access for viewing projects and providing feedback.</p>
                <ul className="text-sm text-slate-700 space-y-1">
                  <li>• View public projects and transactions</li>
                  <li>• Rate and comment on projects</li>
                  <li>• Access public reports</li>
                  <li>• Earn engagement points</li>
                </ul>
              </div>

              <div className="border border-slate-200 rounded-lg p-6">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <Users className="w-5 h-5 text-purple-600" /> Council Member
                </h3>
                <p className="text-slate-600 mb-3">Active participants in student governance with project creation rights.</p>
                <ul className="text-sm text-slate-700 space-y-1">
                  <li>• Create and manage projects</li>
                  <li>• Record transactions with proofs</li>
                  <li>• Submit for adviser approval</li>
                  <li>• Moderate project discussions</li>
                </ul>
              </div>

              <div className="border border-slate-200 rounded-lg p-6">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <Shield className="w-5 h-5 text-orange-600" /> Adviser
                </h3>
                <p className="text-slate-600 mb-3">Faculty supervisors with approval and oversight authority.</p>
                <ul className="text-sm text-slate-700 space-y-1">
                  <li>• Review and approve transactions</li>
                  <li>• Access all project data</li>
                  <li>• Generate audit reports</li>
                  <li>• Manage user permissions</li>
                </ul>
              </div>

              <div className="border border-slate-200 rounded-lg p-6">
                <h3 className="text-lg font-semibold text-slate-900 mb-3 flex items-center gap-2">
                  <Shield className="w-5 h-5 text-red-600" /> Administrator
                </h3>
                <p className="text-slate-600 mb-3">System administrators with full access and configuration rights.</p>
                <ul className="text-sm text-slate-700 space-y-1">
                  <li>• Full system configuration</li>
                  <li>• User management and roles</li>
                  <li>• System maintenance</li>
                  <li>• Advanced reporting</li>
                </ul>
              </div>
            </div>
          </section>

          <section id="creating-projects" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              <FileText className="w-8 h-8 text-indigo-600" /> Creating and Managing Projects
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Project Creation Process</h3>
                <div className="bg-slate-50 p-6 rounded-lg">
                  <div className="flex items-start gap-4 mb-4">
                    <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold">1</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Define Project Details</h4>
                      <p className="text-slate-600">Enter project name, description, budget, timeline, and objectives.</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-4 mb-4">
                    <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold">2</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Upload Supporting Documents</h4>
                      <p className="text-slate-600">Attach proposals, budgets, and approval documents.</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-4">
                    <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold">3</div>
                    <div>
                      <h4 className="font-semibold text-slate-900">Submit for Approval</h4>
                      <p className="text-slate-600">Send to adviser for review and approval.</p>
                    </div>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Project Management</h3>
                <p className="text-slate-600 mb-4">
                  Once approved, you can update project progress, add milestones, and track expenses.
                </p>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <div className="text-center p-4 bg-green-50 rounded-lg">
                    <CheckCircle className="w-8 h-8 text-green-600 mx-auto mb-2" />
                    <h4 className="font-semibold text-slate-900">Track Progress</h4>
                    <p className="text-sm text-slate-600">Update completion status and milestones</p>
                  </div>
                  <div className="text-center p-4 bg-blue-50 rounded-lg">
                    <Upload className="w-8 h-8 text-blue-600 mx-auto mb-2" />
                    <h4 className="font-semibold text-slate-900">Upload Proofs</h4>
                    <p className="text-sm text-slate-600">Add receipts and documentation</p>
                  </div>
                  <div className="text-center p-4 bg-purple-50 rounded-lg">
                    <MessageSquare className="w-8 h-8 text-purple-600 mx-auto mb-2" />
                    <h4 className="font-semibold text-slate-900">Engage Community</h4>
                    <p className="text-sm text-slate-600">Respond to student feedback</p>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <section id="managing-transactions" className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <h2 className="text-3xl font-bold text-slate-900 mb-6 flex items-center gap-3">
              <CheckCircle className="w-8 h-8 text-teal-600" /> Managing Transactions
            </h2>
            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Recording Transactions</h3>
                <p className="text-slate-600 mb-4">
                  All financial transactions must be recorded immediately with supporting documentation.
                </p>
                <div className="bg-amber-50 p-4 rounded-lg border-l-4 border-amber-500">
                  <p className="text-sm text-amber-800">
                    <strong>Important:</strong> Transactions cannot be edited or deleted once recorded. Only new entries can supersede previous ones for corrections.
                  </p>
                </div>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Required Documentation</h3>
                <ul className="space-y-3">
                  <li className="flex items-start gap-3">
                    <ArrowRight className="w-5 h-5 text-blue-600 mt-0.5" />
                    <div>
                      <strong className="text-slate-900">Receipts:</strong> Original receipts for all expenses
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <ArrowRight className="w-5 h-5 text-blue-600 mt-0.5" />
                    <div>
                      <strong className="text-slate-900">Invoices:</strong> For services and supplies
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <ArrowRight className="w-5 h-5 text-blue-600 mt-0.5" />
                    <div>
                      <strong className="text-slate-900">Approval Forms:</strong> Signed authorization for expenditures
                    </div>
                  </li>
                  <li className="flex items-start gap-3">
                    <ArrowRight className="w-5 h-5 text-blue-600 mt-0.5" />
                    <div>
                      <strong className="text-slate-900">Photos:</strong> Documentation of project deliverables
                    </div>
                  </li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-slate-900 mb-3">Approval Workflow</h3>
                <div className="flex flex-col md:flex-row items-center gap-4">
                  <div className="flex-1 text-center">
                    <div className="w-12 h-12 bg-blue-600 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">1</div>
                    <p className="text-sm text-slate-600">Council Member Records Transaction</p>
                  </div>
                  <ArrowRight className="w-6 h-6 text-slate-400 hidden md:block" />
                  <div className="flex-1 text-center">
                    <div className="w-12 h-12 bg-yellow-500 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">2</div>
                    <p className="text-sm text-slate-600">Adviser Reviews Documentation</p>
                  </div>
                  <ArrowRight className="w-6 h-6 text-slate-400 hidden md:block" />
                  <div className="flex-1 text-center">
                    <div className="w-12 h-12 bg-green-600 text-white rounded-full flex items-center justify-center font-bold mx-auto mb-2">3</div>
                    <p className="text-sm text-slate-600">Transaction Added to Immutable Ledger</p>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <section className="bg-blue-50 p-8 rounded-2xl border border-blue-200">
            <h2 className="text-2xl font-bold text-slate-900 mb-4">Need Help?</h2>
            <p className="text-slate-600 mb-6">
              If you encounter any issues or have questions about using STEP, don't hesitate to reach out.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <button
                onClick={() => router.visit(route('contact'))}
                className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
              >
                Contact Support
              </button>
              <button
                onClick={() => router.visit('/')}
                className="px-6 py-3 border border-blue-600 text-blue-600 rounded-lg hover:bg-blue-50 transition"
              >
                Back to Home
              </button>
            </div>
          </section>
        </div>
      </div>
    </main>
  );
}