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
  Clock,
  ChevronLeft,
  ChevronRight
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

export function AuditLogsPage({ logs: initialLogs = { data: [] }, modules = [], filters = {}, summary = {} }) {
  const [searchQuery, setSearchQuery] = useState(filters.search || '');
  const [filterModule, setFilterModule] = useState(filters.module || 'all');
  const [filterStatus, setFilterStatus] = useState(filters.status || 'all');
  const [filterActionType, setFilterActionType] = useState(filters.actionType || 'all');
  const [isLoading, setIsLoading] = useState(false);
  const [currentPage, setCurrentPage] = useState(initialLogs.current_page || 1);

  const logs = initialLogs.data || [];
  const normalizedModules = Array.from(new Set((modules || []).map((module) => String(module || '').trim()).filter(Boolean))).sort();
  const formatModuleName = (module) => String(module || '').replace(/[_-]+/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
  const formatActionType = (actionType) => String(actionType || 'unknown').replace(/\b\w/g, (char) => char.toUpperCase());
  const totalPages = initialLogs.last_page || 1;
  const perPage = initialLogs.per_page || 10;
  const total = initialLogs.total || 0;
  const totalCount = summary.total ?? total;
  const successCount = summary.success ?? logs.filter(l => l.status === 'Success').length;
  const failedCount = summary.failed ?? logs.filter(l => l.status === 'Failed').length;
  const warningCount = summary.warning ?? logs.filter(l => l.status === 'Warning').length;

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

  const handleFilterChange = (filterName, value) => {
    setIsLoading(true);
    setCurrentPage(1);
    const params = {
      search: filterName === 'search' ? value : searchQuery,
      module: filterName === 'module' ? value : filterModule,
      status: filterName === 'status' ? value : filterStatus,
      actionType: filterName === 'actionType' ? value : filterActionType,
      page: 1
    };

    router.get(
      '/adviser/audit-logs',
      params,
      {
        preserveState: true,
        onFinish: () => setIsLoading(false),
      }
    );
  };

  const handlePageChange = (page) => {
    if (page === currentPage || page < 1 || page > totalPages) return;
    
    setIsLoading(true);
    setCurrentPage(page);
    
    const params = {
      search: searchQuery,
      module: filterModule,
      status: filterStatus,
      actionType: filterActionType,
      page: page
    };

    router.get(
      '/adviser/audit-logs',
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

    window.location.href = `/adviser/audit-logs/export?${new URLSearchParams(params).toString()}`;
  };

  useEffect(() => {
    setIsLoading(false);
  }, [logs]);

  // Generate page numbers to display
  const getPageNumbers = () => {
    const pages = [];
    const maxVisible = 5;
    let start = Math.max(1, currentPage - Math.floor(maxVisible / 2));
    let end = Math.min(totalPages, start + maxVisible - 1);
    
    if (end - start + 1 < maxVisible) {
      start = Math.max(1, end - maxVisible + 1);
    }
    
    for (let i = start; i <= end; i++) {
      pages.push(i);
    }
    
    return pages;
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-blue-600">Audit Logs</h1>
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

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <Card className="rounded-[20px] p-4 border-0 shadow-sm">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-600">Total Logs</p>
              <p className="text-2xl text-gray-900">{totalCount}</p>
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
        <Card className="rounded-[20px] p-4 border-0 shadow-sm">
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
            {normalizedModules.map((module) => (
              <SelectItem key={module} value={module}>
                {formatModuleName(module)}
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
            <SelectItem value="archive">Archive</SelectItem>
            <SelectItem value="restore">Restore</SelectItem>
            <SelectItem value="alert">Alert</SelectItem>
          </Select>
        </div>
      </Card>

      {/* Pagination Info */}
      {total > 0 && (
        <div className="flex justify-between items-center text-sm text-gray-600 px-2">
          <span>Showing {((currentPage - 1) * perPage) + 1} to {Math.min(currentPage * perPage, total)} of {total} logs</span>
          <span>Page {currentPage} of {totalPages}</span>
        </div>
      )}

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
                  <TableHead>Type</TableHead>
                  <TableHead>Linked Record</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead>Browser</TableHead>
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
                      <Badge className="bg-gray-100 text-gray-700">{formatModuleName(log.module)}</Badge>
                    </TableCell>
                    <TableCell>
                      <Badge className="bg-blue-100 text-blue-700">{formatActionType(log.actionType)}</Badge>
                    </TableCell>
                    <TableCell className="text-xs text-gray-600">
                      {log.actionableType ? (
                        <div>
                          <div className="font-medium text-gray-900 uppercase">{log.actionableType}</div>
                          <div className="text-gray-500">ID: {log.actionableId ?? 'N/A'}</div>
                        </div>
                      ) : (
                        <span className="text-gray-400">N/A</span>
                      )}
                    </TableCell>
                    <TableCell>
                      <div className="flex items-center gap-2">
                        {getStatusIcon(log.status)}
                        <Badge className={getStatusColor(log.status)}>
                          {log.status}
                        </Badge>
                      </div>
                    </TableCell>
                    <TableCell className="max-w-[200px] text-xs text-gray-600">
                      {log.browserInfo ? log.browserInfo : 'N/A'}
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
         <div className="text-center">
          <Activity className="w-12 h-12 text-gray-300 mx-auto mb-3" />
             <p className="text-sm text-gray-500">No audit logs found</p>
             <p className="text-xs text-gray-400 mt-1 mb-4">
              Try adjusting your search or filters
             </p>
         </div>
        )}
      </Card>

      {/* Pagination Component */}
     {totalPages > 1 && (
  <div className="flex items-center justify-between border-t border-gray-200 mt-4 pt-4">
    <div className="flex flex-1 justify-between sm:hidden">
      <Button
        onClick={() => handlePageChange(currentPage - 1)}
        disabled={currentPage === 1}
        variant="outline"
        className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
      >
        Previous
      </Button>
      <Button
        onClick={() => handlePageChange(currentPage + 1)}
        disabled={currentPage === totalPages}
        variant="outline"
        className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
      >
        Next
      </Button>
    </div>
    <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
      <p className="text-sm text-gray-700">
        Page <span className="font-medium">{currentPage}</span> of{' '}
        <span className="font-medium">{totalPages}</span>
      </p>
      <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Notifications pagination">
        <Button
          onClick={() => handlePageChange(currentPage - 1)}
          disabled={currentPage === 1}
          variant="outline"
          className="relative inline-flex items-center rounded-l-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span className="sr-only">Previous</span>
          <ChevronLeft className="h-5 w-5" />
        </Button>
        {[...Array(totalPages)].map((_, i) => {
          const page = i + 1;
          const isCurrentPage = page === currentPage;
          if (page === 1 || page === totalPages || (page >= currentPage - 1 && page <= currentPage + 1)) {
            return (
              <Button
                key={page}
                onClick={() => handlePageChange(page)}
                variant="outline"
                className={`relative inline-flex items-center px-4 py-2 text-sm font-medium ${
                  isCurrentPage
                    ? 'z-10 bg-blue-600 text-white border-blue-600 hover:bg-blue-700'
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                }`}
              >
                {page}
              </Button>
            );
          }
          if (page === currentPage - 2 || page === currentPage + 2) {
            return (
              <span key={page} className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700">
                ...
              </span>
            );
          }
          return null;
        })}
        <Button
          onClick={() => handlePageChange(currentPage + 1)}
          disabled={currentPage === totalPages}
          variant="outline"
          className="relative inline-flex items-center rounded-r-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span className="sr-only">Next</span>
          <ChevronRight className="h-5 w-5" />
        </Button>
      </nav>
    </div>
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
                <Badge className="bg-gray-100 text-gray-700">{formatModuleName(log.module)}</Badge>
              </div>

              <div>
                <p className="text-sm text-gray-900 mb-1">{log.action}</p>
                <p className="text-[11px] text-blue-700 font-medium uppercase">{formatActionType(log.actionType)}</p>
                {log.details && (
                  <p className="text-xs text-gray-500">{log.details}</p>
                )}
              </div>

              {log.actionableType && (
                <div className="text-xs text-gray-500">
                  Linked: <span className="font-medium text-gray-700 uppercase">{log.actionableType}</span> #{log.actionableId ?? 'N/A'}
                </div>
              )}

              {log.browserInfo && (
                <div className="text-[11px] text-gray-500 break-all">Browser: {log.browserInfo}</div>
              )}

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
      {/* {logs.length === 0 && (
        <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
          <Activity className="w-12 h-12 text-gray-400 mx-auto mb-4" />
          <h3 className="text-gray-900 mb-2">No logs found</h3>
          <p className="text-gray-600">Try adjusting your filters</p>
        </Card>
      )} */}
    </div>
  );
}

export default function AdviserAuditLogsPage(props) {
  return (
    <AuthenticatedLayout>
      <Head title="Audit Logs" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <AuditLogsPage {...props} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}