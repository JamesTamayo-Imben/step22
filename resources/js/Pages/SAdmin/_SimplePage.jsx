import React from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Database } from 'lucide-react';

export default function SimpleSAdminPage({ title, subtitle }) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">{title}</h2>}>
      <Head title={title} />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">{title}</h1>
              {subtitle ? <p className="text-gray-500">{subtitle}</p> : null}
            </div>

            <Card className="p-8 rounded-[20px] border-0 shadow-sm bg-white text-center">
              <div className="max-w-md mx-auto">
                <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Database className="w-8 h-8 text-blue-600" />
                </div>
                <h2 className="text-gray-900 font-semibold mb-2">Coming Soon</h2>
                <p className="text-gray-500">This section is available as a JSX page and can be expanded next.</p>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

