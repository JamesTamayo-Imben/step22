import React from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import {
  Users,
  Shield,
  Activity,
  Database,
  TrendingUp,
  AlertCircle,
} from 'lucide-react';

export default function SAdminDashboard({ stats = {} }) {
  const s = {
    totalUsers: stats.totalUsers ?? 0,
    activeRoles: stats.activeRoles ?? 0,
    approvedProjects: stats.approvedProjects ?? 0,
    pendingApprovals: stats.pendingApprovals ?? 0,
    auditEventsWeek: stats.auditEventsWeek ?? 0,
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Super Admin</h2>}>
      <Head title="Super Admin" />


      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">Superadmin Dashboard</h1>
              <p className="text-gray-500">Complete system oversight and management</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Total Users</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.totalUsers.toLocaleString()}</p>
                    <p className="text-xs text-gray-500 mt-1">Active users (not archived)</p>
                  </div>
                  <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                    <Users className="w-6 h-6 text-purple-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Active Roles</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.activeRoles}</p>
                    <p className="text-xs text-gray-500 mt-1">Configured</p>
                  </div>
                  <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                    <Shield className="w-6 h-6 text-blue-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Approved Projects</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.approvedProjects}</p>
                    <p className="text-xs text-gray-500 mt-1">Approved and not archived</p>
                  </div>
                  <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                    <Activity className="w-6 h-6 text-green-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Pipeline</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.pendingApprovals}</p>
                    <p className="text-xs text-gray-500 mt-1">Projects + ledger pending approval</p>
                  </div>
                  <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                    <Database className="w-6 h-6 text-orange-600" />
                  </div>
                </div>
              </Card>
            </div>

            <Card className="p-5 rounded-[20px] border-0 shadow-sm bg-white flex flex-wrap items-center justify-between gap-3">
              <div className="flex items-center gap-3">
                <AlertCircle className="w-8 h-8 text-orange-500" />
                <div>
                  <p className="text-sm font-medium text-gray-900">Audit activity</p>
                  <p className="text-xs text-gray-500">Entries recorded in the last 7 days</p>
                </div>
              </div>
              <p className="text-2xl font-semibold text-gray-900 tabular-nums">{s.auditEventsWeek.toLocaleString()}</p>
            </Card>

            <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
              <h2 className="text-gray-900 font-semibold mb-4">Quick Actions</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {[
                  { href: '/sadmin/users', icon: Users, color: 'text-purple-600', border: 'hover:border-purple-300 hover:bg-purple-50', title: 'Manage Users', desc: 'Add, edit, or remove users' },
                  { href: '/sadmin/roles', icon: Shield, color: 'text-blue-600', border: 'hover:border-blue-300 hover:bg-blue-50', title: 'Roles & Permissions', desc: 'Configure access control' },
                  { href: '/sadmin/engagement-rules', icon: TrendingUp, color: 'text-green-600', border: 'hover:border-green-300 hover:bg-green-50', title: 'Engagement Rules', desc: 'Set point and badge rules' },
                  { href: '/sadmin/audit-logs', icon: AlertCircle, color: 'text-orange-600', border: 'hover:border-orange-300 hover:bg-orange-50', title: 'Audit Logs', desc: 'View system activity' },
                ].map((a) => {
                  const Icon = a.icon;
                  return (
                    <button
                      key={a.href}
                      onClick={() => (window.location.href = a.href)}
                      className={`p-4 border border-gray-200 rounded-xl transition-all text-left ${a.border}`}
                    >
                      <Icon className={`w-8 h-8 ${a.color} mb-2`} />
                      <p className="text-sm text-gray-900">{a.title}</p>
                      <p className="text-xs text-gray-500 mt-1">{a.desc}</p>
                    </button>
                  );
                })}
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
