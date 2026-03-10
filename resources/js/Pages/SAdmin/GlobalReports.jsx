import React, { useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import { Input } from '@/Components/ui/input';
import {
  Download,
  Users,
  FolderKanban,
  DollarSign,
  TrendingUp,
  BarChart3,
  Activity,
  FileText,
  Award,
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

  const userReports = {
    totalUsers: 1247,
    activeUsers: 892,
    newUsersThisMonth: 45,
    byRole: {
      students: 1150,
      csgOfficers: 35,
      admins: 12,
      superadmins: 2,
    },
    monthlyActive: [
      { month: 'Jun', count: 720 },
      { month: 'Jul', count: 780 },
      { month: 'Aug', count: 845 },
      { month: 'Sep', count: 820 },
      { month: 'Oct', count: 870 },
      { month: 'Nov', count: 892 },
    ],
  };

  const projectReports = {
    totalProjects: 48,
    approved: 42,
    pending: 4,
    rejected: 2,
    avgApprovalTime: '2.3 days',
    byCategory: {
      'Community Outreach': 15,
      Academic: 12,
      Sports: 8,
      Wellness: 7,
      Cultural: 6,
    },
    successRate: 87.5,
  };

  const ledgerReports = {
    totalEntries: 245,
    totalIncome: 850000,
    totalExpense: 625000,
    balance: 225000,
    approved: 238,
    pending: 7,
    avgAccuracy: 98.4,
    proofCompliance: 96.7,
  };

  const engagementReports = {
    totalXP: 48500,
    avgXPPerStudent: 42,
    badgesUnlocked: 327,
    totalRatings: 892,
    avgRating: 4.6,
    leaderboardEntries: 150,
  };

  const handleExport = (reportType) => {
    showToast(`Exporting ${reportType} report as ${exportFormat.toUpperCase()}...`, 'success');
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Global Reports</h2>}>
      <Head title="Global Reports" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">Global Reports</h1>
                <p className="text-gray-500">Comprehensive system analytics and insights</p>
              </div>
              <div className="flex gap-3 w-full sm:w-auto">
                <select
                  value={dateRange}
                  onChange={(e) => setDateRange(e.target.value)}
                  className="px-3 py-2 h-10 border border-gray-300 rounded-xl bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 text-sm"
                >
                  <option value="week">Last Week</option>
                  <option value="month">Last Month</option>
                  <option value="quarter">Last Quarter</option>
                  <option value="year">Last Year</option>
                </select>

                <select
                  value={exportFormat}
                  onChange={(e) => setExportFormat(e.target.value)}
                  className="px-3 py-2 h-10 border border-gray-300 rounded-xl bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 text-sm"
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
                        <Badge variant="outline">{count}</Badge>
                      </div>
                    ))}
                  </div>
                </div>

                <div>
                  <h3 className="text-gray-900 font-semibold mb-4">Monthly Active Users</h3>
                  <div className="space-y-2">
                    {userReports.monthlyActive.map((data) => (
                      <div key={data.month} className="flex items-center gap-3">
                        <span className="text-sm text-gray-600 w-12">{data.month}</span>
                        <div className="flex-1 h-8 bg-gray-100 rounded-lg overflow-hidden">
                          <div
                            className="h-full bg-blue-500 rounded-lg flex items-center justify-end pr-2"
                            style={{ width: `${(data.count / 1000) * 100}%` }}
                          >
                            <span className="text-xs text-white font-semibold">{data.count}</span>
                          </div>
                        </div>
                      </div>
                    ))}
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
                    {Object.entries(projectReports.byCategory).map(([category, count]) => (
                      <div key={category} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                        <span className="text-sm text-gray-700">{category}</span>
                        <Badge variant="outline">{count} projects</Badge>
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
                        {Math.round((projectReports.approved / projectReports.totalProjects) * 100)}%
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
                  <p className="text-xl text-green-900 mt-1">₱{(ledgerReports.totalIncome / 1000).toFixed(0)}K</p>
                </div>
                <div className="p-4 bg-red-50 rounded-xl">
                  <p className="text-sm text-red-700">Total Expense</p>
                  <p className="text-xl text-red-900 mt-1">₱{(ledgerReports.totalExpense / 1000).toFixed(0)}K</p>
                </div>
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-700">Balance</p>
                  <p className="text-xl text-blue-900 mt-1">₱{(ledgerReports.balance / 1000).toFixed(0)}K</p>
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

            {/* Engagement Reports */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-2">
                  <Award className="w-6 h-6 text-yellow-600" />
                  <h2 className="text-lg font-semibold text-gray-900">Engagement Reports</h2>
                </div>
                <Button
                  variant="outline"
                  onClick={() => handleExport('engagement')}
                  className="rounded-xl"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Export
                </Button>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                <div className="p-4 bg-yellow-50 rounded-xl">
                  <p className="text-sm text-yellow-700">Total XP</p>
                  <p className="text-2xl text-yellow-900 mt-1">{engagementReports.totalXP.toLocaleString()}</p>
                </div>
                <div className="p-4 bg-orange-50 rounded-xl">
                  <p className="text-sm text-orange-700">Avg XP/Student</p>
                  <p className="text-2xl text-orange-900 mt-1">{engagementReports.avgXPPerStudent}</p>
                </div>
                <div className="p-4 bg-purple-50 rounded-xl">
                  <p className="text-sm text-purple-700">Badges Unlocked</p>
                  <p className="text-2xl text-purple-900 mt-1">{engagementReports.badgesUnlocked}</p>
                </div>
                <div className="p-4 bg-blue-50 rounded-xl">
                  <p className="text-sm text-blue-700">Total Ratings</p>
                  <p className="text-2xl text-blue-900 mt-1">{engagementReports.totalRatings}</p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="p-6 bg-gradient-to-br from-yellow-50 to-orange-50 rounded-xl border border-yellow-200">
                  <div className="flex items-center gap-2 mb-2">
                    <Award className="w-6 h-6 text-yellow-600" />
                    <h3 className="text-gray-900 font-semibold">Average Rating</h3>
                  </div>
                  <p className="text-4xl text-gray-900 mb-2">{engagementReports.avgRating}</p>
                  <p className="text-sm text-gray-600">out of 5.0 stars</p>
                </div>

                <div className="p-6 bg-gradient-to-br from-purple-50 to-blue-50 rounded-xl border border-purple-200">
                  <div className="flex items-center gap-2 mb-2">
                    <TrendingUp className="w-6 h-6 text-purple-600" />
                    <h3 className="text-gray-900 font-semibold">Leaderboard Activity</h3>
                  </div>
                  <p className="text-4xl text-gray-900 mb-2">{engagementReports.leaderboardEntries}</p>
                  <p className="text-sm text-gray-600">active participants</p>
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

