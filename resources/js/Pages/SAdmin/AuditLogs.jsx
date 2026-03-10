import React, { useState, useMemo } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge } from '@/Components/ui/badge';
import {
  Search,
  Download,
  Eye,
  X,
  User,
  Lock,
  FileText,
  CheckCircle,
  AlertCircle,
  XCircle,
  Clock,
  Filter,
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

function Modal({ open, onClose, title, children }) {
  React.useEffect(() => {
    if (!open) return undefined;
    const originalStyle = window.getComputedStyle(document.body).overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = originalStyle;
    };
  }, [open]);

  if (!open) return null;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
      role="dialog"
      aria-modal="true"
    >
      <div
        className="relative w-full max-w-2xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between p-6 border-b">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            <X className="w-6 h-6" />
          </button>
        </div>
        <div className="overflow-y-auto p-6">{children}</div>
      </div>
    </div>
  );
}

const mockAuditLogs = [
  {
    id: 1,
    user: { name: 'John Doe', email: 'john@example.com', avatar: 'JD' },
    action: 'User Created',
    module: 'User Management',
    type: 'create',
    status: 'success',
    details: 'New user account created for: Maria Santos',
    timestamp: new Date(Date.now() - 5 * 60000),
    ip: '192.168.1.100',
    browser: 'Chrome',
  },
  {
    id: 2,
    user: { name: 'Admin User', email: 'admin@example.com', avatar: 'AU' },
    action: 'Settings Updated',
    module: 'System Settings',
    type: 'update',
    status: 'success',
    details: 'System point rules updated: Rating project = 15 points',
    timestamp: new Date(Date.now() - 15 * 60000),
    ip: '192.168.1.50',
    browser: 'Firefox',
  },
  {
    id: 3,
    user: { name: 'Sarah Johnson', email: 'sarah@example.com', avatar: 'SJ' },
    action: 'Failed Login Attempt',
    module: 'Authentication',
    type: 'login',
    status: 'failed',
    details: 'Failed login attempt with incorrect credentials',
    timestamp: new Date(Date.now() - 30 * 60000),
    ip: '203.0.113.45',
    browser: 'Safari',
  },
  {
    id: 4,
    user: { name: 'John Doe', email: 'john@example.com', avatar: 'JD' },
    action: 'Badge Created',
    module: 'Engagement Rules',
    type: 'create',
    status: 'success',
    details: 'New badge created: Community Champion (Gold tier, 50 XP reward)',
    timestamp: new Date(Date.now() - 45 * 60000),
    ip: '192.168.1.100',
    browser: 'Chrome',
  },
  {
    id: 5,
    user: { name: 'Admin User', email: 'admin@example.com', avatar: 'AU' },
    action: 'Data Export',
    module: 'Reports',
    type: 'export',
    status: 'success',
    details: 'User report exported in CSV format (1,247 records)',
    timestamp: new Date(Date.now() - 60 * 60000),
    ip: '192.168.1.50',
    browser: 'Chrome',
  },
  {
    id: 6,
    user: { name: 'Sarah Johnson', email: 'sarah@example.com', avatar: 'SJ' },
    action: 'Role Permission Modified',
    module: 'Roles & Permissions',
    type: 'update',
    status: 'success',
    details: 'CSG Officer role permissions updated: Added Master Data access',
    timestamp: new Date(Date.now() - 90 * 60000),
    ip: '192.168.1.75',
    browser: 'Edge',
  },
  {
    id: 7,
    user: { name: 'John Doe', email: 'john@example.com', avatar: 'JD' },
    action: 'Organization Deleted',
    module: 'Organizations',
    type: 'delete',
    status: 'success',
    details: 'Organization "Tech Club 2024" deleted with 5 associated members',
    timestamp: new Date(Date.now() - 120 * 60000),
    ip: '192.168.1.100',
    browser: 'Chrome',
  },
  {
    id: 8,
    user: { name: 'Admin User', email: 'admin@example.com', avatar: 'AU' },
    action: 'Password Changed',
    module: 'User Management',
    type: 'update',
    status: 'success',
    details: 'Password changed for user: Jose Reyes',
    timestamp: new Date(Date.now() - 150 * 60000),
    ip: '192.168.1.50',
    browser: 'Firefox',
  },
  {
    id: 9,
    user: { name: 'Sarah Johnson', email: 'sarah@example.com', avatar: 'SJ' },
    action: 'Permission Denied',
    module: 'System Settings',
    type: 'access',
    status: 'failed',
    details: 'Unauthorized access attempt to System Settings configuration',
    timestamp: new Date(Date.now() - 180 * 60000),
    ip: '203.0.113.50',
    browser: 'Chrome',
  },
  {
    id: 10,
    user: { name: 'John Doe', email: 'john@example.com', avatar: 'JD' },
    action: 'Master Data Updated',
    module: 'Master Data',
    type: 'update',
    status: 'success',
    details: 'Added 2 new ledger categories: "Venue Rental", "Honorarium"',
    timestamp: new Date(Date.now() - 210 * 60000),
    ip: '192.168.1.100',
    browser: 'Chrome',
  },
];

export default function AuditLogsPage() {
  const [searchTerm, setSearchTerm] = useState('');
  const [moduleFilter, setModuleFilter] = useState('all');
  const [statusFilter, setStatusFilter] = useState('all');
  const [typeFilter, setTypeFilter] = useState('all');
  const [selectedLog, setSelectedLog] = useState(null);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 5;

  const uniqueModules = [...new Set(mockAuditLogs.map((log) => log.module))];

  const filteredLogs = useMemo(() => {
    return mockAuditLogs.filter((log) => {
      const matchesSearch =
        log.action.toLowerCase().includes(searchTerm.toLowerCase()) ||
        log.user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        log.details.toLowerCase().includes(searchTerm.toLowerCase());

      const matchesModule = moduleFilter === 'all' || log.module === moduleFilter;
      const matchesStatus = statusFilter === 'all' || log.status === statusFilter;
      const matchesType = typeFilter === 'all' || log.type === typeFilter;

      return matchesSearch && matchesModule && matchesStatus && matchesType;
    });
  }, [searchTerm, moduleFilter, statusFilter, typeFilter]);

  const totalPages = Math.ceil(filteredLogs.length / itemsPerPage);
  const paginatedLogs = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    return filteredLogs.slice(startIndex, startIndex + itemsPerPage);
  }, [filteredLogs, currentPage, itemsPerPage]);

  // Reset to page 1 when filters change
  React.useEffect(() => {
    setCurrentPage(1);
  }, [searchTerm, moduleFilter, statusFilter, typeFilter]);

  const getStatusIcon = (status) => {
    switch (status) {
      case 'success':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'failed':
        return <XCircle className="w-4 h-4 text-red-600" />;
      default:
        return <AlertCircle className="w-4 h-4 text-yellow-600" />;
    }
  };

  const getStatusBadge = (status) => {
    switch (status) {
      case 'success':
        return <Badge className="bg-green-100 text-green-700">Success</Badge>;
      case 'failed':
        return <Badge className="bg-red-100 text-red-700">Failed</Badge>;
      default:
        return <Badge className="bg-yellow-100 text-yellow-700">Pending</Badge>;
    }
  };

  const getTypeIcon = (type) => {
    switch (type) {
      case 'create':
        return <FileText className="w-4 h-4" />;
      case 'update':
        return <FileText className="w-4 h-4" />;
      case 'delete':
        return <FileText className="w-4 h-4" />;
      case 'login':
        return <Lock className="w-4 h-4" />;
      case 'access':
        return <Lock className="w-4 h-4" />;
      case 'export':
        return <Download className="w-4 h-4" />;
      default:
        return <FileText className="w-4 h-4" />;
    }
  };

  const getTypeColor = (type) => {
    switch (type) {
      case 'delete':
        return 'bg-red-100 text-red-700';
      case 'login':
      case 'access':
        return 'bg-purple-100 text-purple-700';
      case 'export':
        return 'bg-blue-100 text-blue-700';
      case 'create':  
        return 'bg-green-100 text-green-700';
      case 'update':
        return 'bg-yellow-100 text-yellow-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const formatTime = (timestamp) => {
    const now = new Date();
    const diff = now - timestamp;
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);

    if (minutes < 60) return `${minutes}m ago`;
    if (hours < 24) return `${hours}h ago`;
    if (days < 7) return `${days}d ago`;

    return timestamp.toLocaleDateString();
  };

  const handleExport = () => {
    const csv = [
      ['Timestamp', 'User', 'Action', 'Module', 'Status', 'IP Address', 'Details'],
      ...filteredLogs.map((log) => [
        log.timestamp.toISOString(),
        log.user.name,
        log.action,
        log.module,
        log.status,
        log.ip,
        log.details,
      ]),
    ]
      .map((row) => row.map((cell) => `"${cell}"`).join(','))
      .join('\n');

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `audit-logs-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
    showToast('Audit logs exported successfully', 'success');
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Audit Logs</h2>}>
      <Head title="Audit Logs" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between flex-col sm:flex-row gap-4">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">Audit Logs</h1>
                <p className="text-gray-500">Monitor system-wide activity and access logs</p>
              </div>
              <Button
                onClick={handleExport}
                className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white  lg:w-auto w-full"
              >
                <Download className="w-4 h-4 mr-2" />
                Export CSV
              </Button>
            </div>

            {/* Search and Filters */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="space-y-4">
                {/* Search Bar */}
                <div className="relative">
                  <Search className="absolute left-3 top-3 w-5 h-5 text-gray-400" />
                  <Input
                    placeholder="Search by action, user, or details..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                  />
                </div>

                {/* Filter Controls */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Module</label>
                    <select
                      value={moduleFilter}
                      onChange={(e) => setModuleFilter(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 text-sm"
                    >
                      <option value="all">All Modules</option>
                      {uniqueModules.map((module) => (
                        <option key={module} value={module}>
                          {module}
                        </option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Status</label>
                    <select
                      value={statusFilter}
                      onChange={(e) => setStatusFilter(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 text-sm"
                    >
                      <option value="all">All Status</option>
                      <option value="success">Success</option>
                      <option value="failed">Failed</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Type</label>
                    <select
                      value={typeFilter}
                      onChange={(e) => setTypeFilter(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 text-sm"
                    >
                      <option value="all">All Types</option>
                      <option value="create">Create</option>
                      <option value="update">Update</option>
                      <option value="delete">Delete</option>
                      <option value="login">Login</option>
                      <option value="access">Access</option>
                      <option value="export">Export</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Results</label>
                    <div className="px-3 py-2 bg-blue-50 rounded-xl text-sm font-medium text-blue-700">
                      {filteredLogs.length} entries
                    </div>
                  </div>
                </div>
              </div>
            </Card>

            {/* Logs Table */}
            <Card className="rounded-[20px] border-0 shadow-sm overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">Timestamp</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">User</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">Action</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">Module</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">Type</th>
                      <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700">Status</th>
                      <th className="px-6 py-3 text-center text-xs font-semibold text-gray-700">Action</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {filteredLogs.length > 0 ? (
                      paginatedLogs.map((log) => (
                        <tr key={log.id} className="hover:bg-gray-50 transition-colors">
                          <td className="px-6 py-4 text-sm text-gray-900">
                            <div className="flex items-center gap-2">
                              <Clock className="w-4 h-4 text-gray-400" />
                              <span>{formatTime(log.timestamp)}</span>
                            </div>
                          </td>
                          <td className="px-6 py-4 text-sm text-gray-900">
                            <div className="flex items-center gap-2">
                              <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                                <span className="text-xs font-semibold text-blue-700">{log.user.avatar}</span>
                              </div>
                              <div>
                                <p className="font-medium">{log.user.name}</p>
                                <p className="text-xs text-gray-500">{log.user.email}</p>
                              </div>
                            </div>
                          </td>
                          <td className="px-6 py-4 text-sm font-medium text-gray-900">{log.action}</td>
                          <td className="px-6 py-4 text-sm text-gray-600">{log.module}</td>
                          <td className="px-6 py-4 text-sm">
                            <Badge className={getTypeColor(log.type)}>
                              {log.type.charAt(0).toUpperCase() + log.type.slice(1)}
                            </Badge>
                          </td>
                          <td className="px-6 py-4 text-sm">
                            <div className="flex items-center gap-2">{getStatusBadge(log.status)}</div>
                          </td>
                          <td className="px-6 py-4 text-sm text-center">
                            <button
                              onClick={() => {
                                setSelectedLog(log);
                                setShowDetailModal(true);
                              }}
                              className="inline-flex items-center justify-center w-8 h-8 rounded-lg text-blue-600 hover:bg-blue-50 transition-colors"
                              title="View details"
                            >
                              <Eye className="w-4 h-4" />
                            </button>
                          </td>
                        </tr>
                      ))
                    ) : (
                      <tr>
                        <td colSpan="7" className="px-6 py-12 text-center">
                          <p className="text-gray-500">No audit logs found matching your filters</p>
                          <Button
                            variant="outline"
                            onClick={() => {
                              setSearchTerm('');
                              setModuleFilter('all');
                              setStatusFilter('all');
                              setTypeFilter('all');
                              setCurrentPage(1);
                            }}
                            className="mt-4 rounded-xl"
                          >
                            Clear Filters
                          </Button>
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>

              {/* Pagination */}
              {filteredLogs.length > itemsPerPage && (
                <div className="flex flex-col sm:flex-row gap-2 items-center justify-between border-t border-gray-200 px-6 py-4">
                  <div className="text-sm text-gray-600">
                    Showing <span className="font-medium">{(currentPage - 1) * itemsPerPage + 1}</span> to{' '}
                    <span className="font-medium">
                      {Math.min(currentPage * itemsPerPage, filteredLogs.length)}
                    </span>{' '}
                    of <span className="font-medium">{filteredLogs.length}</span> results
                  </div>
                  <div className="flex gap-2">
                    <Button
                      onClick={() => setCurrentPage(Math.max(1, currentPage - 1))}
                      disabled={currentPage === 1}
                      variant="outline"
                      className="rounded-lg"
                    >
                      Previous
                    </Button>
                    <div className="flex gap-1">
                      {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => (
                        <button
                          key={page}
                          onClick={() => setCurrentPage(page)}
                          className={`w-8 h-8 rounded-lg transition-colors ${
                            currentPage === page
                              ? 'bg-blue-600 text-white'
                              : 'bg-gray-50 text-gray-700 hover:bg-gray-100'
                          }`}
                        >
                          {page}
                        </button>
                      ))}
                    </div>
                    <Button
                      onClick={() => setCurrentPage(Math.min(totalPages, currentPage + 1))}
                      disabled={currentPage === totalPages}
                      variant="outline"
                      className="rounded-lg"
                    >
                      Next
                    </Button>
                  </div>
                </div>
              )}
            </Card>

            {/* Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-blue-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-blue-700">Total Logs</p>
                    <p className="text-2xl font-bold text-blue-900">{mockAuditLogs.length}</p>
                  </div>
                  <FileText className="w-8 h-8 text-blue-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-green-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-green-700">Successful</p>
                    <p className="text-2xl font-bold text-green-900">
                      {mockAuditLogs.filter((l) => l.status === 'success').length}
                    </p>
                  </div>
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-red-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-red-700">Failed</p>
                    <p className="text-2xl font-bold text-red-900">
                      {mockAuditLogs.filter((l) => l.status === 'failed').length}
                    </p>
                  </div>
                  <XCircle className="w-8 h-8 text-red-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-purple-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-purple-700">Success Rate</p>
                    <p className="text-2xl font-bold text-purple-900">
                      {Math.round(
                        (mockAuditLogs.filter((l) => l.status === 'success').length / mockAuditLogs.length) * 100
                      )}
                      %
                    </p>
                  </div>
                  <User className="w-8 h-8 text-purple-600" />
                </div>
              </Card>
            </div>
          </div>
        </div>
      </div>

      {/* Detail Modal */}
      <Modal
        open={showDetailModal}
        onClose={() => setShowDetailModal(false)}
        title="Audit Log Details"
      >
        {selectedLog && (
          <div className="space-y-6">
            {/* User Info */}
            <div>
              <h4 className="text-sm font-semibold text-gray-700 mb-3">User Information</h4>
              <div className="bg-gray-50 rounded-xl p-4">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                    <span className="text-sm font-bold text-blue-700">{selectedLog.user.avatar}</span>
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">{selectedLog.user.name}</p>
                    <p className="text-sm text-gray-600">{selectedLog.user.email}</p>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-gray-600">IP Address</p>
                    <p className="font-medium text-gray-900">{selectedLog.ip}</p>
                  </div>
                  <div>
                    <p className="text-gray-600">Browser</p>
                    <p className="font-medium text-gray-900">{selectedLog.browser}</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Activity Info */}
            <div>
              <h4 className="text-sm font-semibold text-gray-700 mb-3">Activity Information</h4>
              <div className="bg-gray-50 rounded-xl p-4 space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-sm text-gray-600">Action</p>
                    <p className="font-medium text-gray-900">{selectedLog.action}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Module</p>
                    <p className="font-medium text-gray-900">{selectedLog.module}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Type</p>
                    <Badge className={getTypeColor(selectedLog.type)}>
                      {selectedLog.type.charAt(0).toUpperCase() + selectedLog.type.slice(1)}
                    </Badge>
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Status</p>
                    {getStatusBadge(selectedLog.status)}
                  </div>
                </div>

                <div>
                  <p className="text-sm text-gray-600 mb-2">Timestamp</p>
                  <p className="font-medium text-gray-900">{selectedLog.timestamp.toLocaleString()}</p>
                </div>
              </div>
            </div>

            {/* Details */}
            <div>
              <h4 className="text-sm font-semibold text-gray-700 mb-3">Activity Details</h4>
              <div className="bg-gray-50 rounded-xl p-4">
                <p className="text-gray-900 text-sm leading-relaxed">{selectedLog.details}</p>
              </div>
            </div>

            <div className="flex gap-3 pt-4">
              <Button
                onClick={() => setShowDetailModal(false)}
                className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
              >
                Close
              </Button>
            </div>
          </div>
        )}
      </Modal>
    </AuthenticatedLayout>
  );
}

