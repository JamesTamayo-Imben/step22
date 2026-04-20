import React, { useState, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Input } from '@/Components/ui/input';
import { Button } from '@/Components/ui/button';
import {
  Search,
  Filter,
  Download,
  Activity,
  CheckCircle,
  XCircle,
  AlertCircle,
  Clock
} from 'lucide-react';

// Badge component
function Badge({ children, className = '' }) {
  return (
    <span className={['inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium', className].join(' ')}>
      {children}
    </span>
  );
}

// Select component
function Select({ value, onValueChange, children, className = '' }) {
  return (
    <select
      value={value}
      onChange={(e) => onValueChange(e.target.value)}
      className={['w-full px-3 py-2 border border-gray-200 rounded-xl bg-white', className].join(' ')}
    >
      {children}
    </select>
  );
}

function SelectItem({ value, children }) {
  return <option value={value}>{children}</option>;
}

// Table components
function Table({ children }) {
  return (
    <table className="w-full border-collapse">
      {children}
    </table>
  );
}

function TableHeader({ children }) {
  return <thead>{children}</thead>;
}

function TableBody({ children }) {
  return <tbody>{children}</tbody>;
}

function TableRow({ children, className = '' }) {
  return <tr className={['border-b border-gray-200', className].join(' ')}>{children}</tr>;
}

function TableHead({ children }) {
  return <th className="text-left py-3 px-4 font-semibold text-gray-900">{children}</th>;
}

function TableCell({ children, className = '' }) {
  return <td className={['py-3 px-4 text-sm', className].join(' ')}>{children}</td>;
}

export function SystemLogsPage({ logs: initialLogs = { data: [] }, modules = [], filters = {} }) {
  const [searchQuery, setSearchQuery] = useState(filters.search || '');
  const [filterModule, setFilterModule] = useState(filters.module || 'all');
  const [filterStatus, setFilterStatus] = useState(filters.status || 'all');
  const [filterActionType, setFilterActionType] = useState(filters.actionType || 'all');
  const [isLoading, setIsLoading] = useState(false);

  const logs = initialLogs.data || [];

  const getStatusColor = (status) => {
    switch (status) {
      case 'Success':
        return 'bg-green-100 text-green-700';
      case 'Failed':
        return 'bg-red-100 text-red-700';
      case 'Warning':
        return 'bg-yellow-100 text-yellow-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Success':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'Failed':
        return <XCircle className="w-4 h-4 text-red-600" />;
      case 'Warning':
        return <AlertCircle className="w-4 h-4 text-yellow-600" />;
      default:
        return <Activity className="w-4 h-4 text-gray-600" />;
    }
  };

  const successCount = logs.filter(l => l.status === 'Success').length;
  const failedCount = logs.filter(l => l.status === 'Failed').length;
  const warningCount = logs.filter(l => l.status === 'Warning').length;

  const handleFilterChange = (filterName, value) => {
    setIsLoading(true);
    const params = {
      search: filterName === 'search' ? value : searchQuery,
      module: filterName === 'module' ? value : filterModule,
      status: filterName === 'status' ? value : filterStatus,
      actionType: filterName === 'actionType' ? value : filterActionType,
    };

    router.get(
      '/adviser/system-logs',
      params,
      {
        preserveState: true,
        onFinish: () => setIsLoading(false),
      }
    );
  };

  const handleExport = () => {
    const params = {
      search: searchQuery,
      module: filterModule,
      status: filterStatus,
      actionType: filterActionType,
    };

    window.location.href = `/adviser/system-logs/export?${new URLSearchParams(params).toString()}`;
  };

  useEffect(() => {
    setIsLoading(false);
  }, [logs]);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">System Logs</h1>
          <p className="text-gray-500">Monitor all system activities and user actions</p>
        </div>
        <button
          type="button"
          onClick={handleExport}
          disabled={isLoading}
          className="inline-flex items-center justify-center px-4 py-2 border bg-blue-600 rounded-xl text-sm font-medium text-white hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <Download className="w-4 h-4 mr-2" />
          Export CSV
        </button>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card className="rounded-[20px] p-4 border-0 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Total Logs</p>
              <p className="text-2xl text-gray-900">{logs.length}</p>
            </div>
            <Activity className="w-8 h-8 text-blue-600" />
          </div>
        </Card>

        <Card className="rounded-[20px] p-4 border-0 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-green-700">Success</p>
              <p className="text-2xl text-green-900">{successCount}</p>
            </div>
            <CheckCircle className="w-8 h-8 text-green-600" />
          </div>
        </Card>

        <Card className="rounded-[20px] p-4 border-0 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-yellow-700">Warnings</p>
              <p className="text-2xl text-yellow-900">{warningCount}</p>
            </div>
            <AlertCircle className="w-8 h-8 text-yellow-600" />
          </div>
        </Card>

        <Card className="rounded-[20px] p-4 border-0 shadow-sm ">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-red-700">Failed</p>
              <p className="text-2xl text-red-900">{failedCount}</p>
            </div>
            <XCircle className="w-8 h-8 text-red-600" />
          </div>
        </Card>
      </div>

      {/* Filters */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Search */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search logs..."
              value={searchQuery}
              onChange={(e) => {
                setSearchQuery(e.target.value);
                handleFilterChange('search', e.target.value);
              }}
              disabled={isLoading}
              className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
            />
          </div>

          {/* Module Filter */}
          <Select 
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
            value={filterModule}
            onValueChange={(value) => {
              setFilterModule(value);
              handleFilterChange('module', value);
            }}
          >
            <SelectItem value="all">All Modules</SelectItem>
            {modules.map((module) => (
              <SelectItem key={module} value={module}>
                {module}
              </SelectItem>
            ))}
          </Select>

          {/* Status Filter */}
          <Select 
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
            value={filterStatus}
            onValueChange={(value) => {
              setFilterStatus(value);
              handleFilterChange('status', value);
            }}
          >
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="Success">Success</SelectItem>
            <SelectItem value="Warning">Warning</SelectItem>
            <SelectItem value="Failed">Failed</SelectItem>
          </Select>

          {/* Action Type Filter */}
          <Select 
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
            value={filterActionType}
            onValueChange={(value) => {
              setFilterActionType(value);
              handleFilterChange('actionType', value);
            }}
          >
            <SelectItem value="all">All Actions</SelectItem>
            <SelectItem value="create">Create</SelectItem>
            <SelectItem value="update">Update</SelectItem>
            <SelectItem value="delete">Delete</SelectItem>
            <SelectItem value="view">View</SelectItem>
          </Select>
        </div>
      </Card>

      {/* Logs Table - Desktop */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6 hidden md:block">
        {logs.length > 0 ? (
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow className="bg-blue-50">
                  <TableHead>Timestamp</TableHead>
                  <TableHead>User</TableHead>
                  <TableHead>Action</TableHead>
                  <TableHead>Module</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>IP Address</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {logs.map((log) => (
                  <TableRow key={log.id} className="hover:bg-gray-50">
                    <TableCell className="font-mono text-xs text-gray-600">
                      <div className="flex items-center gap-2">
                        <Clock className="w-3 h-3" />
                      {log.timestamp}
                    </div>
                  </TableCell>
                  <TableCell className="text-gray-900">{log.user}</TableCell>
                  <TableCell className="max-w-xs">
                    <div>
                      <p className="text-sm text-gray-900">{log.action}</p>
                      {log.details && (
                        <p className="text-xs text-gray-500 mt-1">{log.details}</p>
                      )}
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{log.module}</Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      {getStatusIcon(log.status)}
                      <Badge className={getStatusColor(log.status)}>
                        {log.status}
                      </Badge>
                    </div>
                  </TableCell>
                  <TableCell className="font-mono text-xs text-gray-600">
                    {log.ipAddress}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          </div>
        ) : (
          <div className="py-8 text-center">
            <Activity className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-gray-500">No system logs found</p>
          </div>
        )}
      </Card>

      {/* Pagination - Backend handled */}
      {initialLogs.links && initialLogs.links.length > 3 && (
        <div className="flex items-center justify-center gap-2 p-4">
          {initialLogs.links.map((link, index) => (
            link.url ? (
              <button
                key={index}
                onClick={() => {
                  setIsLoading(true);
                  router.visit(link.url);
                }}
                className={`px-3 py-1 rounded text-sm font-medium transition-colors ${
                  link.active
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                }`}
                dangerouslySetInnerHTML={{ __html: link.label }}
              />
            ) : (
              <span key={index} className="px-3 py-1 text-sm text-gray-400">
                {link.label === '&laquo; Previous' ? '← Prev' : 'Next →'}
              </span>
            )
          ))}
        </div>
      )}

      {/* Logs Cards - Mobile */}
      <div className="md:hidden space-y-4">
        {logs.map((log) => (
          <Card key={log.id} className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="space-y-3">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-2">
                  {getStatusIcon(log.status)}
                  <Badge className={getStatusColor(log.status)}>
                    {log.status}
                  </Badge>
                </div>
                <Badge variant="outline">{log.module}</Badge>
              </div>

              <div>
                <p className="text-sm text-gray-900 mb-1">{log.action}</p>
                {log.details && (
                  <p className="text-xs text-gray-500">{log.details}</p>
                )}
              </div>

              <div className="flex items-center justify-between text-xs text-gray-500">
                <span>{log.user}</span>
              </div>

              <div className="flex items-center justify-between text-xs text-gray-500 pt-2 border-t border-gray-100">
                <span className="font-mono">{log.timestamp}</span>
                <span className="font-mono">{log.ipAddress}</span>
              </div>
            </div>
          </Card>
        ))}
      </div>

      {/* Empty State */}
      {logs.length === 0 && (
        <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
          <Activity className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-gray-900 mb-2">No logs found</h3>
          <p className="text-gray-600">Try adjusting your filters</p>
        </Card>
      )}
    </div>
  );
}

export default function AdviserSystemLogsPage(props) {
  return (
    <AuthenticatedLayout>
      <Head title="System Logs" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <SystemLogsPage {...props} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
