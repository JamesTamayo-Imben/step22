import React, { useMemo, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import {
  Download,
  Users,
  FolderKanban,
  DollarSign,
  TrendingUp,
  BarChart3,
  Activity,
  FileText,
} from 'lucide-react';

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

export default function GlobalReportsPage() {
  const [dateRange, setDateRange] = useState('month');
  const [exportFormat, setExportFormat] = useState('pdf');
  const { reports = {} } = usePage().props;

  const userReports = useMemo(() => ({
    totalUsers: Number(reports.totalUsers ?? 0),
    activeUsers: Number(reports.activeUsers ?? 0),
    newUsersThisMonth: Number(reports.newUsersThisMonth ?? 0),
    byRole: reports.byRole ?? {},
    monthlyActive: reports.monthlyActive ?? [],
  }), [reports]);

  const projectReports = useMemo(() => ({
    totalProjects: Number(reports.totalProjects ?? 0),
    approved: Number(reports.approvedProjects ?? 0),
    pending: Number(reports.pendingProjects ?? 0),
    rejected: Number(reports.rejectedProjects ?? 0),
    avgApprovalTime: `${Number(reports.avgApprovalTime ?? 0)} days`,
    byCategory: reports.byCategory ?? {},
    successRate: Number(reports.successRate ?? 0),
  }), [reports]);

  const ledgerReports = useMemo(() => ({
    totalEntries: Number(reports.totalLedgerEntries ?? 0),
    totalIncome: Number(reports.totalIncome ?? 0),
    totalExpense: Number(reports.totalExpense ?? 0),
    balance: Number(reports.balance ?? 0),
    approved: Number(reports.approvedLedgerEntries ?? 0),
    pending: Number(reports.pendingLedgerEntries ?? 0),
    avgAccuracy: Number(reports.avgAccuracy ?? 0),
    proofCompliance: Number(reports.proofCompliance ?? 0),
  }), [reports]);

  const engagementReports = useMemo(() => ({
    totalRatings: Number(reports.totalRatings ?? 0),
    avgRating: Number(reports.avgRating ?? 0),
  }), [reports]);

  const staticProjectCategories = ['Social', 'Sports', 'Environmental', 'Technology', 'Cultural', 'Education', 'Health'];

  const categoryList = useMemo(() => {
    const byCategory = reports.byCategory ?? {};

    return staticProjectCategories.map((category) => ({
      category,
      count: Number(byCategory[category] ?? 0),
    }));
  }, [reports.byCategory]);

  const handleExport = (reportType) => {
    showToast(`Exporting ${reportType} report as ${exportFormat.toUpperCase()}...`, 'success');
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Global Reports</h2>}>
      <Head title="Global Reports" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header grid grid-cols-1 xl:grid-cols-2 gap-4 */}
            <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
              <div className='relative flex-1'>
                <div className="w-full">
                  <h1 className="text-2xl font-semibold text-gray-900">Global Reports</h1>
                  <p className="text-gray-500">Comprehensive system analytics and insights</p>
                </div>
                
              </div>
              <div className="flex flex-wrap gap-2 sm:justify-end">
                <select
                  value={dateRange}
                  onChange={(e) => setDateRange(e.target.value)}
                  className="px-3 py-2 border border-gray-200 rounded-xl bg-white min-w-[170px] w-full sm:w-[190px] h-10 border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
                >
                  <option value="week">Last Week</option>
                  <option value="month">Last Month</option>
                  <option value="quarter">Last Quarter</option>
                  <option value="year">Last Year</option>
                </select>

                <select
                  value={exportFormat}
                  onChange={(e) => setExportFormat(e.target.value)}
                  className="px-3 py-2 border border-gray-200 rounded-xl bg-white min-w-[120px] w-full sm:w-[130px] h-10 border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
                >
                  <option value="pdf">PDF</option>
                  <option value="csv">CSV</option>
                  <option value="xlsx">XLSX</option>
                </select>
              </div>
            </div>

            {/* User Reports */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-2">
                  <Users className="w-6 h-6 text-blue-600" />
                  <h2 className="text-lg font-semibold text-gray-900">User Reports</h2>
                </div>
                <Button
                  variant="outline"
                  onClick={() => handleExport('user')}
                  className="rounded-xl"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Export
                </Button>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div className="p-4 bg-purple-50 rounded-xl">
                  <p className="text-sm text-purple-700">Total Users</p>
                  <p className="text-2xl text-purple-900 mt-1">{userReports.totalUsers.toLocaleString()}</p>
                </div>
                <div className="p-4 bg-green-50 rounded-xl">
                  <p className="text-sm text-green-700">Active Users</p>
                  <p className="text-2xl text-green-900 mt-1">{userReports.activeUsers.toLocaleString()}</p>
                </div>
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-700">New This Month</p>
                  <p className="text-2xl text-blue-900 mt-1">+{userReports.newUsersThisMonth}</p>
                </div>
                <div className="p-4 bg-yellow-50 rounded-xl">
                  <p className="text-sm text-yellow-700">Activity Rate</p>
                  <p className="text-2xl text-yellow-900 mt-1">
                    {Math.round((userReports.activeUsers / userReports.totalUsers) * 100)}%
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 className="text-gray-900 font-semibold mb-4">Users by Role</h3>
                  <div className="space-y-3">
                    {Object.entries(userReports.byRole).map(([role, count]) => (
                      <div key={role} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <span className="text-sm text-gray-700 capitalize">
                          {role.replace(/([A-Z])/g, ' $1').trim()}
                        </span>
                        <Badge variant="outline">{Number(count || 0)}</Badge>
                      </div>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-gray-900 font-semibold mb-4">Monthly Active Users</h3>
                  <div className="space-y-2">
                    {userReports.monthlyActive.length ? userReports.monthlyActive.map((data) => {
                      const maxCount = Math.max(...userReports.monthlyActive.map((item) => Number(item.count || 0)), 1);
                      return (
                        <div key={data.month} className="flex items-center gap-3">
                          <span className="text-sm text-gray-600 w-12">{data.month}</span>
                          <div className="flex-1 h-8 bg-gray-100 rounded-lg overflow-hidden">
                            <div
                              className="h-full bg-blue-500 rounded-lg flex items-center justify-end pr-2"
                              style={{ width: `${(Number(data.count || 0) / maxCount) * 100}%` }}
                            >
                              <span className="text-xs text-white font-semibold">{data.count}</span>
                            </div>
                          </div>
                        </div>
                      );
                    }) : (
                      <p className="text-sm text-gray-500">No monthly user activity available.</p>
                    )}
                  </div>
                </div>
              </div>
            </Card>

            {/* Project Reports */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-2">
                  <FolderKanban className="w-6 h-6 text-blue-600" />
                  <h2 className="text-lg font-semibold text-gray-900">Project Reports</h2>
                </div>
                <Button
                  variant="outline"
                  onClick={() => handleExport('project')}
                  className="rounded-xl"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Export
                </Button>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-5 gap-4 mb-6">
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-700">Total Projects</p>
                  <p className="text-2xl text-blue-900 mt-1">{projectReports.totalProjects}</p>
                </div>
                <div className="p-4 bg-green-50 rounded-xl">
                  <p className="text-sm text-green-700">Approved</p>
                  <p className="text-2xl text-green-900 mt-1">{projectReports.approved}</p>
                </div>
                <div className="p-4 bg-yellow-50 rounded-xl">
                  <p className="text-sm text-yellow-700">Pending</p>
                  <p className="text-2xl text-yellow-900 mt-1">{projectReports.pending}</p>
                </div>
                <div className="p-4 bg-red-50 rounded-xl">
                  <p className="text-sm text-red-700">Rejected</p>
                  <p className="text-2xl text-red-900 mt-1">{projectReports.rejected}</p>
                </div>
                <div className="p-4 bg-purple-50 rounded-xl">
                  <p className="text-sm text-purple-700">Success Rate</p>
                  <p className="text-2xl text-purple-900 mt-1">{projectReports.successRate}%</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <h3 className="text-gray-900 font-semibold mb-4">Projects by Category</h3>
                  <div className="space-y-3">
                    {categoryList.map(({ category, count }) => (
                      <div key={category} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <span className="text-sm text-gray-700">{category}</span>
                        <Badge variant="outline">{Number(count || 0)} projects</Badge>
                      </div>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-gray-900 font-semibold mb-4">Approval Metrics</h3>
                  <div className="space-y-4">
                    <div className="p-4 bg-blue-50 rounded-xl">
                      <p className="text-sm text-blue-700">Average Approval Time</p>
                      <p className="text-xl text-blue-900 mt-1">{projectReports.avgApprovalTime}</p>
                    </div>
                    <div className="p-4 bg-green-50 rounded-xl">
                      <p className="text-sm text-green-700">Approval Rate</p>
                      <p className="text-xl text-green-900 mt-1">
                        {projectReports.totalProjects ? Math.round((projectReports.approved / projectReports.totalProjects) * 100) : 0}%
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </Card>

            {/* Ledger Reports */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-2">
                  <DollarSign className="w-6 h-6 text-green-600" />
                  <h2 className="text-lg font-semibold text-gray-900">Ledger & Financial Reports</h2>
                </div>
                <Button
                  variant="outline"
                  onClick={() => handleExport('ledger')}
                  className="rounded-xl"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Export
                </Button>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div className="p-4 bg-green-50 rounded-xl">
                  <p className="text-sm text-green-700">Total Income</p>
                  <p className="text-xl text-green-900 mt-1">₱{Number(ledgerReports.totalIncome || 0).toLocaleString()}</p>
                </div>
                <div className="p-4 bg-red-50 rounded-xl">
                  <p className="text-sm text-red-700">Total Expense</p>
                  <p className="text-xl text-red-900 mt-1">₱{Number(ledgerReports.totalExpense || 0).toLocaleString()}</p>
                </div>
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-700">Balance</p>
                  <p className="text-xl text-blue-900 mt-1">₱{Number(ledgerReports.balance || 0).toLocaleString()}</p>
                </div>
                <div className="p-4 bg-purple-50 rounded-xl">
                  <p className="text-sm text-purple-700">Total Entries</p>
                  <p className="text-xl text-purple-900 mt-1">{ledgerReports.totalEntries}</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="p-4 bg-gray-50 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <Activity className="w-5 h-5 text-gray-600" />
                    <p className="text-sm text-gray-700 font-medium">Data Accuracy</p>
                  </div>
                  <p className="text-2xl text-gray-900">{ledgerReports.avgAccuracy}%</p>
                </div>

                <div className="p-4 bg-gray-50 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <FileText className="w-5 h-5 text-gray-600" />
                    <p className="text-sm text-gray-700 font-medium">Proof Compliance</p>
                  </div>
                  <p className="text-2xl text-gray-900">{ledgerReports.proofCompliance}%</p>
                </div>

                <div className="p-4 bg-gray-50 rounded-xl">
                  <div className="flex items-center gap-2 mb-2">
                    <TrendingUp className="w-5 h-5 text-gray-600" />
                    <p className="text-sm text-gray-700 font-medium">Approved</p>
                  </div>
                  <p className="text-2xl text-gray-900">
                    {ledgerReports.approved}/{ledgerReports.totalEntries}
                  </p>
                </div>
              </div>
            </Card>

            {/* Export Summary */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-r from-blue-50 to-blue-50">
              <div className="flex items-start gap-4">
                <div className="w-12 h-12 bg-blue-600 rounded-xl flex items-center justify-center flex-shrink-0">
                  <BarChart3 className="w-6 h-6 text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-gray-900 font-semibold mb-2">Export All Reports</h3>
                  <p className="text-sm text-gray-600 mb-4">
                    Generate a comprehensive report including all sections above
                  </p>
                  <Button
                    onClick={() => handleExport('comprehensive')}
                    className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                  >
                    <Download className="w-4 h-4 mr-2" />
                    Export Comprehensive Report
                  </Button>
                </div>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

