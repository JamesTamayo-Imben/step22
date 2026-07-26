import React, { useState, useMemo, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';

export default function AdviserProjectsPage() {
     // Minimal Projects page — expand as needed
     return (
          <AuthenticatedLayout>
               <Head title="Projects" />
               <div className="py-8 px-4 lg:px-0 md:px-0">
                    <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
                         <h1 className="text-2xl font-semibold text-gray-900">Projects</h1>
                         <p className="text-sm text-gray-500 mt-1">Project listing will appear here.</p>
                    </div>
               </div>
          </AuthenticatedLayout>
     );
}