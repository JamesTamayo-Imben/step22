import React from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';

export default function Error403() {
  return (
    <AuthenticatedLayout>
      <Head title="403 — Forbidden" />

      <div className="py-12 lg:ml-64">
        <div className="mx-auto max-w-5xl sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="hidden md:flex bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white rounded-2xl p-10 flex-col justify-center">
              <h1 className="text-3xl font-semibold mb-2">Access Denied</h1>
              <p className="text-white/80">You don't have permission to view this page.</p>
              <p className="mt-6 text-white/70">If you think this is a mistake, contact your administrator or request access.</p>
            </div>

            <Card className="p-10 rounded-2xl border-0 shadow-sm bg-white">
              <div className="flex flex-col items-center text-center">
                <div className="w-24 h-24 rounded-full bg-red-50 flex items-center justify-center mb-6">
                  <svg xmlns="http://www.w3.org/2000/svg" className="w-12 h-12 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>

                <h2 className="text-2xl font-semibold text-gray-900">403 — Forbidden</h2>
                <p className="text-sm text-gray-500 mt-2">Sorry — you don’t have access to this resource.</p>

                <div className="mt-6 flex flex-col sm:flex-row items-center justify-center gap-3">
                  <a href={route('adviser.dashboard')} className="inline-flex items-center justify-center px-5 py-2.5 rounded-lg bg-[#2563EB] text-white text-sm hover:bg-[#1e4fd6] transition">Go to Dashboard</a>
                  <a href="mailto:admin@example.com" className="inline-flex items-center justify-center px-5 py-2.5 rounded-lg border border-gray-200 text-sm text-gray-700 hover:bg-gray-50 transition">Contact Support</a>
                </div>

                <p className="text-xs text-gray-400 mt-6">Include the URL and steps you took when contacting support.</p>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
