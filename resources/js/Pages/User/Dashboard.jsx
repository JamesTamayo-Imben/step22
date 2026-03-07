import { useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { StudentNavbar } from '@/Components/StudentNavbar';
import { StudentDashboardHome } from './pages/StudentDashboardHome';

export default function UserDashboard() {
  const [currentView, setCurrentView] = useState('dashboard');

  const handleNavigate = (view) => setCurrentView(view);
  const handleLogout = () => { /* your logout logic */ };
  const handleSwitchRole = () => { /* your role switch logic */ };
  const userData = { canSwitch: true };

  return (
    <>
      <StudentNavbar
        currentView={currentView}
        onNavigate={handleNavigate}
        onLogout={handleLogout}
        onSwitchRole={handleSwitchRole}
        userData={userData}
      />
      <AuthenticatedLayout
        header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Student Dashboard</h2>}
      >
        <Head title="Student Dashboard" />
        <div className="pt-20"> {/* adjust padding to match navbar height */}
          <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
            {currentView === 'dashboard' && <StudentDashboardHome onNavigate={handleNavigate} />}
          </div>
        </div>
      </AuthenticatedLayout>
    </>
  );
}