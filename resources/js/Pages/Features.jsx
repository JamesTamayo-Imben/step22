import { Shield, FileCheck, Users, Database, Lock, CheckCircle, Star, TrendingUp, Award, Bell, AlertCircle, CheckSquare, Building2 } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function Features() {
  return (
    <main className="min-h-screen bg-slate-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-6">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">STEP Features</h1>
          <p className="mt-2 text-lg text-slate-600">
            Discover the powerful tools that make STEP the leading platform for transparent student governance and financial accountability
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

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
          {/* Immutable Ledger */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Immutable Ledger</h3>
            <p className="text-slate-600 mb-4">
              Every transaction is permanently recorded with SHA256 cryptographic hashing. No edits, no deletions—only verifiable truth.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Complete audit trails</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Cryptographic verification</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Tamper-proof records</li>
            </ul>
          </div>

          {/* Verifiable Proof Upload */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Verifiable Proof Upload</h3>
            <p className="text-slate-600 mb-4">
              Upload receipts, documents, and evidence for every transaction with automatic integrity verification via Supabase S3.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> File authenticity checks</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Metadata preservation</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Secure cloud storage</li>
            </ul>
          </div>

          {/* Multi-Dimensional Ratings */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
           
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Multi-Dimensional Ratings</h3>
            <p className="text-slate-600 mb-4">
              Comprehensive feedback with satisfaction, completeness, and engagement ratings for every project.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Satisfaction ratings</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Completeness assessment</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Engagement metrics</li>
            </ul>
          </div>

          {/* Real-Time Notifications */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
           
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Real-Time Notifications</h3>
            <p className="text-slate-600 mb-4">
              Instant updates on ledger approvals, project submissions, ratings, and important system events.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Ledger notifications</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Project status updates</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Approval alerts</li>
            </ul>
          </div>

          {/* Approval Workflows */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Approval Workflows</h3>
            <p className="text-slate-600 mb-4">
              Structured approval chains for ledger entries, projects, and financial transactions with audit tracking.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Multi-level approvals</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Rejection with comments</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Bulk operations</li>
            </ul>
          </div>

          {/* Concerns & Issues Management */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
           
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Concerns & Issues Management</h3>
            <p className="text-slate-600 mb-4">
              Submit, track, and resolve concerns about projects, operations, and governance decisions.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Issue tracking</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Response management</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Resolution history</li>
            </ul>
          </div>

          {/* Role-Based Access Control */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
           
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Role-Based Access Control</h3>
            <p className="text-slate-600 mb-4">
              Secure, granular permissions for Students, Council Members, Advisors, and Administrators.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Granular permissions</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> OTP-based authentication</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Role switching support</li>
            </ul>
          </div>

          {/* Multi-Institute Support */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Multi-Institute Support</h3>
            <p className="text-slate-600 mb-4">
              Scale across multiple educational institutions with isolated data and shared governance frameworks.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Institution isolation</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Shared resources</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Centralized admin</li>
            </ul>
          </div>

          {/* Comprehensive Analytics */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Comprehensive Analytics</h3>
            <p className="text-slate-600 mb-4">
              Real-time dashboards tracking ledger activity, project performance, ratings trends, and governance metrics.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Live dashboards</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Financial reports</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-blue-500" /> Engagement trends</li>
            </ul>
          </div>
        </div>

        <section className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200 mb-8">
          <h2 className="text-3xl font-bold text-slate-900 mb-6">Why Choose STEP?</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
             Unmatched Transparency
              </h3>
              <p className="text-slate-600">
                STEP provides unprecedented visibility into student council operations. Every transaction, approval, and decision is permanently recorded and cryptographically verified for absolute accountability.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                Enterprise Security
              </h3>
              <p className="text-slate-600">
                Military-grade encryption, OTP-based authentication, and blockchain-inspired immutability ensure your data remains secure, tamper-proof, and compliant with data protection standards.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                Student-Centric Design
              </h3>
              <p className="text-slate-600">
                Built with students in mind, STEP makes governance accessible and engaging. Real-time notifications, multi-dimensional ratings, and intuitive workflows empower every member of the academic community.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
               Scalable & Extensible
              </h3>
              <p className="text-slate-600">
                Support for multiple institutions, flexible approval workflows, and comprehensive analytics. STEP grows with your organization while maintaining data integrity and performance.
              </p>
            </div>
          </div>
        </section>
      </div>
    </main>
  );
}