import React, { useState, useEffect } from 'react';
import { Inertia } from '@inertiajs/inertia';
import { usePage, router } from '@inertiajs/react';
import {
  LayoutDashboard,
  CheckSquare,
  BookOpen,
  Bell,
  TrendingUp,
  FileText, 
  User,
  Menu,
  Layers,
  X,
  Clock,
  LogOut,
  ShieldCheck,
} from 'lucide-react';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';

// A reusable Admin/Adviser sidebar component. Plain JS (no TypeScript) so it's easy to reuse.
export default function AdminAdviserSidebar({ currentView = null, onNavigate = null, onLogout = null }) {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const page = usePage();
  const user = page.props.auth?.user;

  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
  
  // Helper function to get user initials
  const getInitials = (name) => {
    if (!name) return 'U';
    return name
      .split(' ')
      .map(part => part[0])
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  const navItems = [
    { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
    { id: 'approvals', label: 'Approvals', icon: CheckSquare },
    { id: 'history', label: 'History', icon: Layers },
    { id: 'ledger-view', label: 'Ledger Oversight', icon: BookOpen },
    { id: 'feedback-review', label: 'Role & Permissions', icon: ShieldCheck },
    { id: 'ratings-analytics', label: 'Ratings & Analytics', icon: TrendingUp },
    { id: 'system-logs', label: 'System Logs', icon: FileText },
     { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'profile', label: 'Profile', icon: User },
  ];
  // Derive active view from pathname when parent doesn't provide `currentView`.
  function getViewFromPath() {
    if (typeof window === 'undefined') return 'dashboard';
    const p = window.location.pathname;
    if (p.startsWith('/adviser/approvals')) return 'approvals';
    if (p.startsWith('/adviser/history')) return 'history';
    if (p.startsWith('/adviser/ledger')) return 'ledger-view';
    if (p.startsWith('/adviser/notifications')) return 'notifications';
    if (p.startsWith('/adviser/role-permissions')) return 'feedback-review';
    if (p.startsWith('/adviser/ratings')) return 'ratings-analytics';
    if (p.startsWith('/adviser/system-logs')) return 'system-logs';
    if (p.startsWith('/adviser/profile')) return 'profile';
    if (p === '/adviser' || p.startsWith('/adviser')) return 'dashboard';
    return 'dashboard';
  }

  const initialSelected = currentView || getViewFromPath();
  const [selectedView, setSelectedView] = useState(initialSelected);

  // Compute a tampered count from several possible props locations so the badge
  // appears when pages provide ledger data or when the backend sets a stats prop.
  const tamperedCount = (() => {
    try {
      const statsCount = page.props?.stats?.tamperedAlerts ?? page.props?.tamperedAlerts;
      if (typeof statsCount === 'number') return statsCount;
      const list = page.props?.ledgerEntries || page.props?.recentLedgerEntries || [];
      if (Array.isArray(list)) return list.filter(e => e && (e.tampered || e.verificationState?.tampered || (e.verification_state && e.verification_state.tampered))).length;
    } catch (err) {
      return 0;
    }
    return 0;
  })();

  // Keep selectedView in sync when Inertia's page URL changes or browser history changes
  const { url } = usePage();
  useEffect(() => {
    setSelectedView(getViewFromPath());
    const onPop = () => setSelectedView(getViewFromPath());
    window.addEventListener('popstate', onPop);
    return () => window.removeEventListener('popstate', onPop);
  }, [url]);

  return (
    <>
      {/* Mobile Header */}
      <div className="lg:hidden fixed top-0 left-0 right-0 h-16 bg-white border-b border-gray-200 flex items-center justify-between px-4 z-50">
        <button
          onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
          className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
        >
          {isMobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
        </button>
        <div className="flex items-center gap-2">
          <div className="w-8 h-8 rounded-lg flex items-center justify-center">
            {/* <span className="text-white text-sm">S</span> */}
            <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
          </div>
          <div className="w-10">
            <img
              src="/images/step_dark.png" alt="Step"
              className="w-full object-cover"/>
          </div>
          
          
        </div>
        <Avatar className="w-8 h-8">
          <AvatarFallback className="bg-[#2563EB] text-white text-xs">{getInitials(user?.name)}</AvatarFallback>
        </Avatar>
      </div>

      {/* Mobile Drawer Overlay */}
      {isMobileMenuOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/50 z-40"
          onClick={() => setIsMobileMenuOpen(false)}
        />
      )}

      {/* Mobile Drawer */}
      <aside className={`lg:hidden fixed top-0 left-0 h-full w-72 bg-white border-r border-gray-200 shadow-xl z-50 transform transition-transform duration-300 ${
        isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'
      }`}>
        <div className="p-6 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <div className="w-8 rounded-xl flex items-center justify-center">
              {/* <span className="text-white">S</span> */}
              <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
            </div>
            <div className="w-8">
              <img
              src="/images/step_dark.png" alt="Step"
              className="w-full object-cover"/>
              {/* <h1 className="text-[#2563EB]">STEP</h1> */}
              <p className="text-xs text-gray-500">Admin/Adviser</p>
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
                        onClick={() => {
                          setIsMobileMenuOpen(false);
                          setSelectedView(item.id);
                          // prefer parent handler if provided
                          if (typeof onNavigate === 'function') return onNavigate(item.id);
                          // otherwise navigate via Inertia to a sensible path
                          const map = {
                            dashboard: '/adviser',
                            approvals: '/adviser/approvals',
                            'ledger-view': '/adviser/ledger',
                            history: '/adviser/history',
                            notifications: '/adviser/notifications',
                            'feedback-review': '/adviser/role-permissions',
                            'ratings-analytics': '/adviser/ratings',
                            'system-logs': '/adviser/system-logs',
                            profile: '/adviser/profile',
                          };
                          const url = map[item.id] || '/adviser';
                          router.visit(url);
                          return null;
                        }}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
                      isActive ? `bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-md` : 'text-gray-600 hover:bg-blue-50'
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span className="flex items-center gap-2">
                      <span>{item.label}</span>
                      {item.id === 'ledger-view' && tamperedCount > 0 && (
                        <span className="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-700">
                          {tamperedCount}
                        </span>
                      )}
                    </span>
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
                    <img
              src="/images/step_dark.png" alt="Step"
              className="w-full object-cover"/>
                </div>
              
              <p className="text-xs text-gray-500">Admin/Adviser</p>
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
                    onClick={() => {
                      setSelectedView(item.id);
                      if (typeof onNavigate === 'function') return onNavigate(item.id);
                      const map = {
                        dashboard: '/adviser',
                        approvals: '/adviser/approvals',
                        'ledger-view': '/adviser/ledger',
                        history: '/adviser/history',
                        notifications: '/adviser/notifications',
                        'feedback-review': '/adviser/role-permissions',
                        'ratings-analytics': '/adviser/ratings',
                        'system-logs': '/adviser/system-logs',
                        profile: '/adviser/profile',
                      };
                      const url = map[item.id] || '/adviser';
                      router.visit(url);
                      return null;
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

        <div className="p-4 border-t border-gray-200 space-y-2">
          <div className="flex items-center gap-3 px-4 py-2">
            <Avatar className="w-8 h-8">
              <AvatarFallback className="bg-[#2563EB] text-white text-xs">{getInitials(user?.name)}</AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <p className="text-sm text-gray-900">{user?.name || 'User'}</p>
              <p className="text-xs text-gray-500">{user?.email || 'No email'}</p>
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
