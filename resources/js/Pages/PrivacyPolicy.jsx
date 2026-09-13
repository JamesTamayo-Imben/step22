import { Shield, Database, Lock, UserCheck, FileText, Share2, AlertOctagon, Mail, RefreshCw, Scale } from 'lucide-react';
import { router } from '@inertiajs/react';

export default function PrivacyPolicy() {
  return (
    <main className="min-h-screen bg-slate-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w mx-auto bg-white border border-slate-200 shadow-lg rounded-2xl p-8 lg:p-12">
        <header className="mb-8">
          <h1 className="text-3xl lg:text-4xl font-bold text-slate-900">STEP System – Privacy Policy</h1>
          <p className="mt-2 text-sm text-slate-500">Last Updated: March 29, 2026</p>
          <div className="mt-4 flex gap-4">
                      <button
                        onClick={() => router.visit('/')}
                        className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                      >
                        Back to Home
                      </button>
                    </div>
        </header>

        <nav className="mb-8 border border-slate-100 rounded-lg bg-slate-50 p-4">
          <h2 className="text-sm font-semibold text-slate-700 mb-3">Quick Jump</h2>
          <ul className="flex flex-wrap gap-3 text-sm">
            <li><a href="#introduction" className="text-blue-700 hover:underline">Introduction</a></li>
            <li><a href="#information-collected" className="text-blue-700 hover:underline">Information Collected</a></li>
            <li><a href="#purpose" className="text-blue-700 hover:underline">Purpose</a></li>
            <li><a href="#processing-storage" className="text-blue-700 hover:underline">Processing & Storage</a></li>
            <li><a href="#data-subject-rights" className="text-blue-700 hover:underline">Data Subject Rights</a></li>
            <li><a href="#security" className="text-blue-700 hover:underline">Security</a></li>
            <li><a href="#data-sharing" className="text-blue-700 hover:underline">Data Sharing</a></li>
            <li><a href="#breach-notification" className="text-blue-700 hover:underline">Breach Notification</a></li>
            <li><a href="#contact" className="text-blue-700 hover:underline">Contact & Complaints</a></li>
          </ul>
        </nav>

        {/* 1. Introduction */}
        <section id="introduction" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
            1. Introduction
          </h2>
          <p>
            The School Transparency and Engagement Portal (STEP System) is fully committed to safeguarding user data privacy in compliance with Republic Act No. 10173, also known as the Data Privacy Act of 2012.
          </p>
        </section>

        {/* 2. Information Collected */}
        <section id="information-collected" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
           2. Information Collected
          </h2>
          <p>To maintain functional role-based access and system transparency, the platform may collect and process:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li><strong>Personal Identification Data:</strong> Full name, institutional email address, student/employee ID, and assigned role.</li>
            <li><strong>Authentication Credentials:</strong> Encrypted passwords and role-based access tokens.</li>
            <li><strong>Interaction Data:</strong> Submitted student feedback, project ratings, and comment submissions.</li>
            <li><strong>Governance Records:</strong> Project proposals, itemized financial transactions, supporting proof documents (receipts), and meeting schedules.</li>
          </ul>
          <p className="mt-2">
            Personal information refers to any data from which the identity of an individual can be directly or reasonably established.
          </p>
        </section>

        {/* 3. Purpose of Data Collection */}
        <section id="purpose" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
           3. Purpose of Data Collection
          </h2>
          <p>
            All personal data and operational records are collected strictly in accordance with the statutory principles of transparency, legitimate purpose, and proportionality for:
          </p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>User authentication and identity verification across assigned roles.</li>
            <li>Verifiable monitoring of organizational financial transparency and fund distribution.</li>
            <li>Streamlined management and auditing of CSG project proposals, approvals, and meetings.</li>
            <li>Continuous optimization of system performance, responsiveness, and user engagement.</li>
          </ul>
        </section>

        {/* 4. Data Processing and Storage */}
        <section id="processing-storage" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
            4. Data Processing and Storage
          </h2>
          <p>User data is:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Processed fairly, lawfully, and strictly for institutional governance objectives.</li>
            <li>Stored securely using role-based access controls, cryptographic data structures, and protected databases.</li>
            <li>Retained only for as long as necessary to fulfill active system operations, audit requirements, and legal compliance obligations.</li>
          </ul>
        </section>

        {/* 5. Data Subject Rights */}
        <section id="data-subject-rights" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
            5. Data Subject Rights
          </h2>
          <p>Under the Data Privacy Act of 2012, all users are recognized as data subjects and hold the right to:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li><strong>Be Informed:</strong> Know how their personal data is collected, processed, and stored.</li>
            <li><strong>Access:</strong> Access and review their personal information held within the portal.</li>
            <li><strong>Correction:</strong> Request the correction or updating of inaccurate or outdated data.</li>
            <li><strong>Withdrawal or Deletion:</strong> Withdraw consent or request account archiving/deletion, subject to institutional record retention policies.</li>
          </ul>
        </section>

        {/* 6. Data Security Measures */}
        <section id="security" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <div className="">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
              6. Data Security Measures
            </h2>
            <p>To prevent unauthorized access, accidental loss, or unlawful manipulation, the system incorporates technical security measures, including:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1">
              <li>Multi-tiered Role-Based Access Control (RBAC).</li>
              <li>Secure authentication mechanisms and encrypted session handling.</li>
              <li>Cryptographic hash verification to maintain tamper-evident audit logs.</li>
            </ul>
            <p className="mt-2">
              The institution maintains strict technical and organizational measures to safeguard processed personal data against security compromises.
            </p>
          </div>
        </section>

        {/* 7. Data Sharing */}
        <section id="data-sharing" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
            7. Data Sharing
          </h2>
          <p>Personal information processed by the STEP System will NOT be shared, leased, or disclosed to third parties unless:</p>
          <ul className="list-disc pl-6 mt-2 space-y-1">
            <li>Expressly mandated or permitted by applicable law.</li>
            <li>Explicit consent is granted by the data subject.</li>
            <li>Strictly required for essential system infrastructure and backend functionality.</li>
          </ul>
        </section>

        {/* 8. Data Breach Notification Policy */}
        <section id="breach-notification" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <div className="">
            <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
              8. Data Breach Notification Policy
            </h2>
            <p>In the event of a confirmed or suspected personal data breach affecting system integrity:</p>
            <ul className="list-disc pl-6 mt-2 space-y-1 ">
              <li>Affected users will be notified promptly in accordance with statutory requirements.</li>
              <li>Immediate technical mitigation and corrective protocols will be executed.</li>
              <li>Incident reports will be processed and filed in coordination with institutional officers and the National Privacy Commission (NPC).</li>
            </ul>
          </div>
        </section>

        {/* 9. Contact and Complaints */}
        <section id="contact" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
             9. Contact and Complaints
          </h2>
          <p>
            Users may raise inquiries, privacy concerns, or requests regarding their personal data through the STEP System Administrator or the institutional Data Protection Officer (DPO). Formal complaints may also be lodged with the National Privacy Commission (NPC).
          </p>
        </section>

        {/* 10. Policy Updates */}
        <section id="policy-updates" className="prose prose-slate max-w-none leading-relaxed mb-8">
          <h2 className="text-2xl font-semibold text-slate-900 flex items-center gap-2">
            10. Policy Updates
          </h2>
          <p>
            This Privacy Policy may be updated periodically to reflect technological enhancements or regulatory changes. Users will be informed of significant updates affecting their privacy rights through system-wide notices.
          </p>
        </section>
      </div>
    </main>
  );
}