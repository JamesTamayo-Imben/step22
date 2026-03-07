import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';

export default function SAdminDashboard() {
  return (
    <AuthenticatedLayout
      header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Super Admin Dashboard</h2>}
    >
      <Head title="Super Admin" />

      <div className="py-12">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="overflow-hidden bg-white shadow-sm sm:rounded-lg">
            <div className="p-6 text-gray-900">
              Welcome, Super Admin!
            </div>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
