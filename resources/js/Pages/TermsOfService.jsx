import { Scale, ShieldCheck, FileText } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function TermsOfService() {
  const handlePrint = () => {
    window.print();
  };

  return (
    <main className="min-h-screen bg-slate-50 py-14 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">Terms of Service</h1>
          <p className="mt-2 text-lg text-slate-600">User Agreement</p>
          <div className="mt-4 flex gap-4">
            <button
              onClick={() => router.visit('/')}
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
            >
              Back to Home
            </button>
            <button
              onClick={handlePrint}
              className="px-4 py-2 bg-slate-600 text-white rounded-lg hover:bg-slate-700 transition"
            >
              Print Terms
            </button>
          </div>
        </header>

        <div className="prose prose-slate max-w-none leading-relaxed">
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><Scale className="w-5 h-5 text-sky-600" /> Acceptance of Terms</h2>
            <p>
              By accessing and using the School Transparency and Engagement Portal (STEP), you agree to abide by the school's transparency protocols and these terms of service. STEP is designed to promote governance and financial transparency within the institution.
            </p>
          </section>

          <section className="mb-8 border-l-4 border-amber-500 bg-amber-50 p-4 rounded-r-lg">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><ShieldCheck className="w-5 h-5 text-amber-600" /> The "No-Delete" Policy</h2>
            <p>
              All financial submissions, project updates, and meeting minutes are recorded on an immutable ledger. This append-only system ensures data integrity and auditability. Once a transaction is submitted, it cannot be deleted. Instead, corrections or updates are made by adding a new version, preserving the original for historical reference.
            </p>
            <p className="font-semibold text-amber-800">
              Users acknowledge that submissions are permanent and form part of the institutional record.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><FileText className="w-5 h-5 text-sky-600" /> User Accountability</h2>
            <p>
              Council members and Advisors are responsible for the accuracy of uploaded proofs, such as receipts and documentation. False reporting or inaccurate submissions are subject to school disciplinary action, including potential suspension or expulsion.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><ShieldCheck className="w-5 h-5 text-sky-600" /> Role-Based Access (RBAC)</h2>
            <p>
              Users must only access and interact with data permitted by their assigned role (Student, Council Member, Advisor, or Admin). Attempting to access unauthorized information may result in account restrictions or disciplinary measures.
            </p>
          </section>

          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2"><FileText className="w-5 h-5 text-sky-600" /> Account Termination</h2>
            <p>
              Accounts can be archived (marked as is_archived = TRUE) upon request or due to policy violations. However, all historical data and submissions remain part of the immutable institutional record and cannot be removed.
            </p>
          </section>
        </div>
      </div>
    </main>
  );
}