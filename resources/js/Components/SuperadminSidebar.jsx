import React, { useState, useEffect } from 'react';
import { Inertia } from '@inertiajs/inertia';
import { usePage, router } from '@inertiajs/react';
import {
  LayoutDashboard,
  Users,
  Shield,
  Archive,
  BookOpenText,
  CalendarDays,
  FileText,
  Menu,
  Settings,
  X,
  LogOut,
} from 'lucide-react';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';

export default function SuperadminSidebar({ currentView = null, onNavigate = null, onLogout = null }) {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const { url } = usePage();

  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { id: 'user-management', label: 'User Management', icon: Users },
    { id: 'roles-permissions', label: 'Roles & Permissions', icon: Shield },
    { id: 'archived-projects', label: 'Archived Items', icon: Archive },
    // { id: 'ledger-entries', label: 'Ledger Entries', icon: BookOpenText },
    // { id: 'meetings', label: 'Meetings', icon: CalendarDays },
    { id: 'system-logs', label: 'System Logs', icon: FileText },
    { id: 'system-settings', label: 'Blockchain', icon: Settings },
    // { id: 'audit-logs', label: 'Audit Logs', icon: FileText },
    // { id: 'data-backup', label: 'Data & Backup', icon: Database },
    // { id: 'engagement-rules', label: 'Engagement Rules', icon: TrendingUp },
    // { id: 'master-data', label: 'Master Data', icon: Database },
    // { id: 'global-reports', label: 'Global Reports', icon: FileText },
    // { id: 'notifications', label: 'Notifications', icon: Bell },
    // { id: 'profile', label: 'Profile', icon: User },
  ];

  function getViewFromPath() {
    if (typeof window === 'undefined') return 'dashboard';
    const p = window.location.pathname;
    if (p === '/sadmin') return 'dashboard';
    if (p.startsWith('/sadmin/users')) return 'user-management';
    if (p.startsWith('/sadmin/roles')) return 'roles-permissions';
    if (p.startsWith('/sadmin/archived-projects')) return 'archived-projects';
    if (p.startsWith('/sadmin/ledger-entries')) return 'ledger-entries';
    if (p.startsWith('/sadmin/meetings')) return 'meetings';
    if (p.startsWith('/sadmin/system-logs')) return 'system-logs';
    if (p.startsWith('/sadmin/settings')) return 'system-settings';
    if (p.startsWith('/sadmin/audit-logs')) return 'audit-logs';
    if (p.startsWith('/sadmin/data-backup')) return 'data-backup';
    if (p.startsWith('/sadmin/engagement-rules')) return 'engagement-rules';
    if (p.startsWith('/sadmin/master-data')) return 'master-data';
    if (p.startsWith('/sadmin/global-reports')) return 'global-reports';
    if (p.startsWith('/sadmin/notifications')) return 'notifications';
    if (p.startsWith('/sadmin/profile')) return 'profile';
    return 'dashboard';
  }

  const initialSelected = currentView || getViewFromPath();
  const [selectedView, setSelectedView] = useState(initialSelected);

  useEffect(() => {
    setSelectedView(getViewFromPath());
    const onPop = () => setSelectedView(getViewFromPath());
    window.addEventListener('popstate', onPop);
    return () => window.removeEventListener('popstate', onPop);
  }, [url]);

  const viewToUrl = (viewId) => {
    const map = {
      dashboard: '/sadmin',
      'user-management': '/sadmin/users',
      'roles-permissions': '/sadmin/roles',
      'archived-projects': '/sadmin/archived-projects',
      'ledger-entries': '/sadmin/ledger-entries',
      meetings: '/sadmin/meetings',
      'system-logs': '/sadmin/system-logs',
      'system-settings': '/sadmin/settings',
      'audit-logs': '/sadmin/audit-logs',
      'data-backup': '/sadmin/data-backup',
      'engagement-rules': '/sadmin/engagement-rules',
      'master-data': '/sadmin/master-data',
      'global-reports': '/sadmin/global-reports',
      notifications: '/sadmin/notifications',
      profile: '/sadmin/profile',
    };
    return map[viewId] || '/sadmin';
  };

  const handleNavigate = (viewId) => {
    setSelectedView(viewId);
    if (typeof onNavigate === 'function') return onNavigate(viewId);
    router.visit(viewToUrl(viewId));
    return null;
  };

  const handleLogout = () => {
    if (typeof onLogout === 'function') return onLogout();
    Inertia.post('/logout', {}, { onSuccess: () => Inertia.visit('/') });
    return null;
  };

  return (
    <>
      {/* Mobile Header */}
      <div className="lg:hidden fixed top-0 left-0 right-0 h-16 bg-white border-b border-gray-200 flex items-center justify-between px-4 z-50">
        <button onClick={() => setIsMobileMenuOpen((v) => !v)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
          {isMobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg flex items-center justify-center">
            <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
          </div>
          <div className="w-10">
            <h1 className="text-[#3CC3FC] font-bold">STEP</h1>
          </div>
        </div>
        <Avatar className="w-8 h-8">
          <AvatarFallback className="bg-[#2563EB] text-white text-xs">SA</AvatarFallback>
        </Avatar>
      </div>

      {/* Mobile Drawer Overlay */}
      {isMobileMenuOpen && (
        <div className="lg:hidden fixed inset-0 bg-black/50 z-40" onClick={() => setIsMobileMenuOpen(false)} />
      )}

      {/* Mobile Drawer */}
      <aside
        className={`lg:hidden fixed top-0 left-0 h-full w-72 bg-white border-r border-gray-200 shadow-xl z-50 transform transition-transform duration-300 ${
          isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-8 rounded-xl flex items-center justify-center">
              <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
            </div>
            <div className="w-full">
                <div className="w-8">
                    <h1 className="text-[#3CC3FC] font-bold">STEP</h1>
                </div>
              
              <p className="text-xs text-gray-500">Super Admin</p>
            </div>
          </div>
        </div>

        <nav className="flex-1 p-4 overflow-y-auto h-[calc(100vh-180px)]">
          <ul className="space-y-2">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = (currentView ? currentView === item.id : selectedView === item.id);
              return (
                <li key={item.id}>
                  <button
                    type="button"
                    onClick={() => {
                      setIsMobileMenuOpen(false);
                      handleNavigate(item.id);
                    }}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
                      isActive ? `bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-md` : 'text-gray-600 hover:bg-blue-50'
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span>{item.label}</span>
                  </button>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="p-4 border-t border-gray-200">
          <button
           type="button"
           onClick={() => router.post('/logout')}
           className="w-full flex items-center gap-3 px-4 py-3 text-red-600 hover:bg-red-50 rounded-xl transition-all"
         >
           <LogOut className="w-5 h-5 pointer-events-none" />
           <span className="pointer-events-none">Logout</span>
         </button>
        </div>
      </aside>

      {/* Desktop Sidebar */}
      <aside className="hidden lg:flex fixed left-0 top-0 h-screen w-64 bg-white border-r border-gray-200 flex-col shadow-sm z-40">
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl flex items-center justify-center">
              <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
            </div>
            <div className="w-full">
                <div className="w-10">
                    <h1 className="text-[#3CC3FC] font-bold">STEP</h1>
                </div>
              
              <p className="text-xs text-gray-500">Super Admin</p>
            </div>
          </div>
        </div>

        <nav className="flex-1 p-4 overflow-y-auto">
          <ul className="space-y-2">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = (currentView ? currentView === item.id : selectedView === item.id);
              return (
                <li key={item.id}>
                  <button
                    type="button"
                    onClick={() => handleNavigate(item.id)}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
                      isActive ? `bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-md` : 'text-gray-600 hover:bg-blue-50'
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span>{item.label}</span>
                  </button>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="p-4 border-t border-gray-200 space-y-2">
          <div className="flex items-center gap-3 px-4 py-2">
            <Avatar className="w-8 h-8">
              <AvatarFallback className="bg-[#2563EB] text-white text-xs">SA</AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <p className="text-sm text-gray-900">Super Admin</p>
              <p className="text-xs text-gray-500">superadmin@kld.edu.ph</p>
            </div>
          </div>
          <button
           type="button"
           onClick={() => router.post('/logout')}
           className="w-full flex items-center gap-3 px-4 py-3 text-red-600 hover:bg-red-50 rounded-xl transition-all"
         >
           <LogOut className="w-5 h-5 pointer-events-none" />
           <span className="pointer-events-none">Logout</span>
         </button>
        </div>
      </aside>
    </>
  );
}
