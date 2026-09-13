import { Scale, ShieldCheck, FileText, Users, Lock, Server, Copyright, AlertTriangle, Gavel, RefreshCw } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function TermsOfService() {
  const handlePrint = () => {
    window.print();
  };

  return (
    <main className="min-h-screen bg-slate-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">STEP System – Terms & Conditions</h1>
          <p className="mt-2 text-lg text-slate-600">User Agreement</p>
          <div className="mt-4 flex gap-4">
            <button
              onClick={() => router.visit('/register')}
              className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
            >
              Back
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
          {/* 1. Acceptance of Terms */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
               1. Acceptance of Terms
            </h2>
            <p>
              By accessing and using the School Transparency and Engagement Portal (STEP System), users agree to comply with and be bound by these Terms and Conditions. If the user does not agree to these terms, they must refrain from using the system.
            </p>
          </section>

          {/* 2. User Roles and Responsibilities */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
               2. User Roles and Responsibilities
            </h2>
            <p>
              The system provides Role-Based Access Control (RBAC) for Students (Members), CSG Officers (Council), Advisers, and Super Administrators. Each user is responsible for:
            </p>
            <ul className="list-disc pl-6 mt-2 space-y-1">
              <li><strong>Credential Security:</strong> Maintaining the strict confidentiality of their login credentials.</li>
              <li><strong>Data Accuracy:</strong> Ensuring that all information submitted to the portal is accurate, truthful, and lawful.</li>
              <li><strong>Authorized Usage:</strong> Using the system exclusively for authorized academic, organizational, and governance purposes.</li>
            </ul>
          </section>

          {/* 3. Proper Use of the System */}
          <section className="mb-8 rounded-r-lg">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
               3. Proper Use of the System
            </h2>
            <p className="font-semibold ">Users agree NOT to:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1 ">
              <li>Upload false, misleading, manipulated, or unauthorized data.</li>
              <li>Attempt unauthorized access to restricted features, roles, or administrative functions.</li>
              <li>Disrupt, overload, or interfere with system operations, network security, or database integrity.</li>
            </ul>
            <p className="mt-3 font-semibold ">
              Any misuse of the platform may result in immediate account suspension or permanent termination.
            </p>
          </section>

          {/* 4. System Functions */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
             4. System Functions
            </h2>
            <p>The STEP System enables key institutional governance capabilities, including:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1">
              <li><strong>Feedback & Evaluation:</strong> Submission of ratings, comments, and constructive feedback on completed CSG projects.</li>
              <li><strong>Public Visibility:</strong> Direct viewing of verified project status updates, financial ledger records, and meeting minutes.</li>
              <li><strong>Operational Workflows:</strong> Scheduling of council meetings, project proposal processing, and multi-level approval tracking.</li>
              <li><strong>Administrative Governance:</strong> System health monitoring, role permissions management, and audit trail oversight.</li>
            </ul>
            <p className="mt-2">
              All data processed within the system must strictly comply with institutional policies.
            </p>
          </section>

          {/* 5. Intellectual Property */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
              5. Intellectual Property
            </h2>
            <p>
              All system content, including software source code, underlying data structures, interface designs, graphic elements, and system outputs, remains the exclusive intellectual property of the institution. Unauthorized copying, redistribution, reverse engineering, or commercial extraction is strictly prohibited.
            </p>
          </section>

          {/* 6. Limitation of Liability */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
              6. Limitation of Liability
            </h2>
            <p>The system administrators, developers, and institutional officers shall not be held liable for:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1">
              <li>Temporary system downtime, network latency, or unexpected technical disruptions.</li>
              <li>Inaccuracies or omissions originating from user-generated content prior to verification.</li>
              <li>Unforeseen data loss or service degradation caused by force majeure or factors beyond reasonable control.</li>
            </ul>
          </section>

          {/* 7. Account Suspension and Termination */}
          <section className="mb-8 rounded-r-lg">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
             7. Account Suspension and Termination
            </h2>
            <p className="font-semibold">System access privileges may be suspended or permanently revoked for:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1 ">
              <li>Direct violation of these Terms and Conditions.</li>
              <li>Unauthorized attempts to breach system access controls or bypass security layers.</li>
              <li>Abuse of system roles, permissions, or public interaction channels.</li>
            </ul>
          </section>

          {/* 8. Amendments */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
             8. Amendments
            </h2>
            <p>
              These Terms and Conditions may be revised or updated as institutional requirements evolve. Continued access to and use of the system following any modifications constitute explicit acceptance of the revised terms.
            </p>
          </section>

          {/* 9. Governing Law */}
          <section className="mb-8">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
             9. Governing Law
            </h2>
            <p>
              These Terms and Conditions shall be governed by and construed in accordance with the laws of the Republic of the Philippines.
            </p>
          </section>
        </div>
      </div>
    </main>
  );
}