import { Shield, Database, Lock, UserCheck } from 'lucide-react';

export default function PrivacyPolicy() {
  return (
    <main className="min-h-screen bg-slate-50 py-14 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">Privacy Policy &amp; Data Governance</h1>
          <p className="mt-2 text-sm text-slate-500">Last Updated: March 29, 2026</p>
        </header>

        <nav className="mb-8 border border-slate-100 rounded-lg bg-slate-50 p-4">
          <h2 className="text-sm font-semibold text-slate-700 mb-3">Quick Jump</h2>
          <ul className="flex flex-wrap gap-3 text-sm">
            <li><a href="#data-collection" className="text-blue-700 hover:underline">Data Collection</a></li>
            <li><a href="#immutable-ledger" className="text-blue-700 hover:underline">Immutable Ledger Policy</a></li>
            <li><a href="#user-rights" className="text-blue-700 hover:underline">User Rights</a></li>
            <li><a href="#security" className="text-blue-700 hover:underline">Security</a></li>
          </ul>
        </nav>

        <section className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900">Introduction</h2>
          <p>
            STEP (School Transparency and Engagement Portal) is built on blockchain-inspired transparency and accountability principles. Our platform aims to ensure that school governance financial events are visible, auditable, and immutable.
          </p>
        </section>

        <section id="data-collection" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><Database className="w-5 h-5 text-sky-600" /> Data Collection</h2>
          <p>
            We collect the following data types to provide secure and personalized services:
          </p>
          <ul className="list-disc list-inside text-slate-700">
            <li>Name</li>
            <li>Email</li>
            <li>Role (student, adviser, officer, admin)</li>
            <li>Financial transaction data and uploaded receipts</li>
          </ul>
        </section>

        <section id="immutable-ledger" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <div className="p-5 rounded-xl border border-blue-200 bg-blue-50">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><Shield className="w-5 h-5 text-blue-700" /> Immutable Ledger Clause</h2>
            <p>
              For complete auditability and data integrity, all financial transactions and project updates are stored in an append-only ledger. Existing records are never deleted or overwritten. Instead:
            </p>
            <ul className="list-disc list-inside text-slate-700">
              <li>Records may be archived to control visibility while preserving history.</li>
              <li>Records may be superseded by a new version, but the original remains immutable.</li>
            </ul>
            <p>
              This ensures an unalterable historical trail for compliance, audit, and trust.
            </p>
          </div>
        </section>

        <section id="user-rights" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><UserCheck className="w-5 h-5 text-sky-600" /> User Rights</h2>
          <p>
            Users have rights to:
          </p>
          <ul className="list-disc list-inside text-slate-700">
            <li>Request data corrections; corrections are implemented via new ledger entries and not through data mutation.</li>
            <li>Request account deactivation; the account status is changed using an `is_archived = TRUE` field, preserving all past actions.</li>
          </ul>
        </section>

        <section id="security" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><Lock className="w-5 h-5 text-sky-600" /> Data Security</h2>
          <p>
            We use industry-grade security measures including SHA-256 hashing for file integrity and Supabase Auth for secure, role-based access control.
          </p>
          <p>
            All uploaded financial receipts and transaction documents are verified with cryptographic hashes to ensure they cannot be tampered with after submission.
          </p>
        </section>
      </div>
    </main>
  );
}
