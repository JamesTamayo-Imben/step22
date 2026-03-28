import { Shield, FileCheck, Users, Database, Lock, CheckCircle, Star, TrendingUp, Award } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function Features() {
  return (
    <main className="min-h-screen bg-slate-50 py-14 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto">
        <header className="text-center mb-12">
          <h1 className="text-4xl lg:text-5xl font-bold text-slate-900 mb-4">STEP Features</h1>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto">
            Discover the powerful tools that make STEP the leading platform for transparent student governance
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
            <div className="w-16 h-16 bg-blue-100 rounded-xl flex items-center justify-center mb-6">
              <Shield className="w-8 h-8 text-blue-600" />
            </div>
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Immutable Ledger</h3>
            <p className="text-slate-600 mb-4">
              Every transaction is permanently recorded with SHA256 cryptographic hashing. No edits, no deletions—only verifiable truth.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Complete audit trails</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Cryptographic verification</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Tamper-proof records</li>
            </ul>
          </div>

          {/* Verifiable Proof Upload */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <div className="w-16 h-16 bg-green-100 rounded-xl flex items-center justify-center mb-6">
              <FileCheck className="w-8 h-8 text-green-600" />
            </div>
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Verifiable Proof Upload</h3>
            <p className="text-slate-600 mb-4">
              Upload receipts, documents, and evidence for every transaction with automatic integrity verification.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> File authenticity checks</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Metadata preservation</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Secure cloud storage</li>
            </ul>
          </div>

          {/* Student Engagement & Ratings */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <div className="w-16 h-16 bg-purple-100 rounded-xl flex items-center justify-center mb-6">
              <Users className="w-8 h-8 text-purple-600" />
            </div>
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Student Engagement & Ratings</h3>
            <p className="text-slate-600 mb-4">
              Gamified system with points, badges, and leaderboards to encourage active participation.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Real-time feedback</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Project rating system</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Achievement rewards</li>
            </ul>
          </div>

          {/* Role-Based Access Control */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <div className="w-16 h-16 bg-orange-100 rounded-xl flex items-center justify-center mb-6">
              <Lock className="w-8 h-8 text-orange-600" />
            </div>
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Role-Based Access Control</h3>
            <p className="text-slate-600 mb-4">
              Secure access levels for Students, Council Members, Advisors, and Administrators.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Granular permissions</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Audit logging</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Secure authentication</li>
            </ul>
          </div>

          {/* Real-Time Analytics */}
          <div className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <div className="w-16 h-16 bg-indigo-100 rounded-xl flex items-center justify-center mb-6">
              <TrendingUp className="w-8 h-8 text-indigo-600" />
            </div>
            <h3 className="text-2xl font-semibold text-slate-900 mb-4">Real-Time Analytics</h3>
            <p className="text-slate-600 mb-4">
              Comprehensive dashboards with live data visualization and performance metrics.
            </p>
            <ul className="space-y-2 text-sm text-slate-700">
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Live dashboards</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Custom reports</li>
              <li className="flex items-center gap-2"><CheckCircle className="w-4 h-4 text-green-500" /> Trend analysis</li>
            </ul>
          </div>
        </div>

        <section className="bg-white p-8 rounded-2xl shadow-lg border border-slate-200 mb-8">
          <h2 className="text-3xl font-bold text-slate-900 mb-6 text-center">Why Choose STEP?</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Award className="w-6 h-6 text-yellow-500" /> Unmatched Transparency
              </h3>
              <p className="text-slate-600">
                STEP provides unprecedented visibility into student council operations, ensuring every decision and transaction is transparent and accountable.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Star className="w-6 h-6 text-yellow-500" /> Student-Centric Design
              </h3>
              <p className="text-slate-600">
                Built with students in mind, STEP makes governance accessible and engaging for everyone in the academic community.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <Shield className="w-6 h-6 text-blue-500" /> Enterprise Security
              </h3>
              <p className="text-slate-600">
                Military-grade encryption and blockchain-inspired immutability ensure your data remains secure and tamper-proof.
              </p>
            </div>
            <div>
              <h3 className="text-xl font-semibold text-slate-900 mb-4 flex items-center gap-2">
                <TrendingUp className="w-6 h-6 text-green-500" /> Continuous Innovation
              </h3>
              <p className="text-slate-600">
                Regular updates with cutting-edge features to enhance governance efficiency.
              </p>
            </div>
          </div>
        </section>
      </div>
    </main>
  );
}