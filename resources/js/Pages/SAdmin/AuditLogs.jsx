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
  ChevronRight,
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
  return <table className="w-full border-collapse">{children}</table>;
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

export function AuditLogsPage({ logs: initialLogs = { data: [] }, modules = [], filters = {}, basePath = '/sadmin/audit-logs', summary = {} }) {
  const [searchQuery, setSearchQuery] = useState(filters.search || '');
  const [filterModule, setFilterModule] = useState(filters.module || 'all');
  const [filterStatus, setFilterStatus] = useState(filters.status || 'all');
  const [filterActionType, setFilterActionType] = useState(filters.actionType || 'all');
  const [isLoading, setIsLoading] = useState(false);

  const logs = initialLogs.data || [];
  const normalizedModules = Array.from(new Set((modules || []).map((module) => String(module || '').trim()).filter(Boolean))).sort();
  const formatModuleName = (module) => String(module || '').replace(/[_-]+/g, ' ').replace(/\b\w/g, (char) => char.toUpperCase());
  const formatActionType = (actionType) => String(actionType || 'unknown').replace(/\b\w/g, (char) => char.toUpperCase());
  const totalCount = summary.total ?? logs.length;
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
    const params = {
      search: filterName === 'search' ? value : searchQuery,
      module: filterName === 'module' ? value : filterModule,
      status: filterName === 'status' ? value : filterStatus,
      actionType: filterName === 'actionType' ? value : filterActionType,
    };

    router.get(basePath, params, {
      preserveState: true,
      onFinish: () => setIsLoading(false),
    });
  };

  const handleExport = () => {
    const params = {
      search: searchQuery,
      module: filterModule,
      status: filterStatus,
      actionType: filterActionType,
    };

    window.location.href = `${basePath}/export?${new URLSearchParams(params).toString()}`;
  };

  useEffect(() => {
    setIsLoading(false);
  }, [logs]);

  // Helpers for pagination navigation
  const goToPrev = () => {
    const prevLink = initialLogs.links?.[0];
    if (prevLink?.url) {
      setIsLoading(true);
      router.visit(prevLink.url);
    }
  };

  const goToNext = () => {
    const nextLink = initialLogs.links?.[initialLogs.links.length - 1];
    if (nextLink?.url) {
      setIsLoading(true);
      router.visit(nextLink.url);
    }
  };

  const goToPage = (page) => {
    const link = initialLogs.links?.[page];
    if (link?.url) {
      setIsLoading(true);
      router.visit(link.url);
    }
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

      {/* Summary Cards */}
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

      {/* Logs Table - Desktop */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6 hidden md:block">
        {logs.length > 0 ? (
          <div className="overflow-x-auto">
            <Table className="w-full table-fixed">
              <TableHeader>
                <TableRow className="bg-blue-50">
                  <TableHead className="w-[130px]">Timestamp</TableHead>
                  <TableHead className="w-[120px]">User</TableHead>
                  <TableHead className="w-[220px]">Action</TableHead>
                  <TableHead className="w-[100px]">Module</TableHead>
                  <TableHead className="w-[90px]">Type</TableHead>
                  <TableHead className="w-[130px]">Linked Record</TableHead>
                  <TableHead className="w-[100px]">Status</TableHead>
                  <TableHead className="w-[180px]">Browser</TableHead>
                  <TableHead className="w-[120px]">IP Address</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {logs.map((log) => (
                  <TableRow key={log.id} className="hover:bg-gray-50">
                    <TableCell className="font-mono text-xs text-gray-600 truncate">
                      <div className="flex items-center gap-2">
                        <Clock className="w-3 h-3 flex-shrink-0" />
                        <span className="truncate">{log.timestamp}</span>
                      </div>
                    </TableCell>
                    <TableCell className="text-gray-900 truncate">{log.user}</TableCell>
                    <TableCell className="max-w-[220px]">
                      <div>
                        <p className="text-sm text-gray-900 break-words">{log.action}</p>
                        {log.details && (
                          <p className="text-xs text-gray-500 mt-1 break-words">{log.details}</p>
                        )}
                      </div>
                    </TableCell>
                    <TableCell className="truncate">
                      <Badge variant="outline">{formatModuleName(log.module)}</Badge>
                    </TableCell>
                    <TableCell className="truncate">
                      <Badge className="bg-blue-100 text-blue-700">{formatActionType(log.actionType)}</Badge>
                    </TableCell>
                    <TableCell className="text-xs text-gray-600 truncate">
                      {log.actionableType ? (
                        <div>
                          <div className="font-medium text-gray-900 uppercase truncate">{log.actionableType}</div>
                        </div>
                      ) : (
                        <span className="text-gray-400">N/A</span>
                      )}
                    </TableCell>
                    <TableCell className="truncate">
                      <div className="flex items-center gap-2">
                        {getStatusIcon(log.status)}
                        <Badge className={getStatusColor(log.status)}>
                          {log.status}
                        </Badge>
                      </div>
                    </TableCell>
                    <TableCell className="max-w-[180px] text-xs text-gray-600 truncate">
                      {log.browserInfo ? log.browserInfo : 'N/A'}
                    </TableCell>
                    <TableCell className="font-mono text-xs text-gray-600 truncate">
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
            <p className="text-gray-500">No audit logs found</p>
          </div>
        )}
      </Card>

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
                <Badge variant="outline">{formatModuleName(log.module)}</Badge>
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

      {/* Pagination - Shared for Mobile & Desktop */}
      {initialLogs.links && initialLogs.links.length > 3 && (
        <div className="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 rounded-lg">
          {/* Mobile pagination */}
          <div className="flex flex-1 justify-between sm:hidden">
            <Button
              onClick={goToPrev}
              disabled={!initialLogs.links[0]?.url}
              className="relative inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Previous
            </Button>
            <Button
              onClick={goToNext}
              disabled={!initialLogs.links[initialLogs.links.length - 1]?.url}
              className="relative ml-3 inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Next
            </Button>
          </div>

          {/* Desktop pagination */}
          <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
            <div>
              <p className="text-sm text-gray-700">
                Page <span className="font-medium">{initialLogs.current_page || 1}</span> of{' '}
                <span className="font-medium">{initialLogs.last_page || 1}</span>
              </p>
            </div>
            <div>
              <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                {/* Previous Button */}
                <Button
                  onClick={goToPrev}
                  disabled={!initialLogs.links[0]?.url}
                  className="relative inline-flex items-center rounded-l-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span className="sr-only">Previous</span>
                  <ChevronLeft className="h-5 w-5" />
                </Button>

                {/* Page Numbers */}
                {(() => {
                  const currentPage = initialLogs.current_page || 1;
                  const lastPage = initialLogs.last_page || 1;
                  const pages = [];

                  for (let page = 1; page <= lastPage; page++) {
                    const isCurrentPage = page === currentPage;

                    // Show first, last, and pages around current
                    const shouldShow =
                      page === 1 ||
                      page === lastPage ||
                      (page >= currentPage - 1 && page <= currentPage + 1);

                    if (shouldShow) {
                      // Laravel's links array: [Prev, 1, 2, 3, ..., Next]
                      // So index for page N is N (since index 0 is Prev)
                      const link = initialLogs.links[page];

                      pages.push(
                        <Button
                          key={page}
                          onClick={() => goToPage(page)}
                          disabled={!link?.url}
                          className={`relative inline-flex items-center border px-4 py-2 text-sm font-medium ${
                            isCurrentPage
                              ? 'z-10 bg-blue-600 text-white border-blue-600'
                              : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'
                          } disabled:opacity-50 disabled:cursor-not-allowed`}
                        >
                          {page}
                        </Button>
                      );
                    } else if (
                      // Show ellipsis only once before/after the visible range
                      (page === currentPage - 2 && currentPage - 2 > 1) ||
                      (page === currentPage + 2 && currentPage + 2 < lastPage)
                    ) {
                      pages.push(
                        <span
                          key={`ellipsis-${page}`}
                          className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700"
                        >
                          ...
                        </span>
                      );
                    }
                  }

                  return pages;
                })()}

                {/* Next Button */}
                <Button
                  onClick={goToNext}
                  disabled={!initialLogs.links[initialLogs.links.length - 1]?.url}
                  className="relative inline-flex items-center rounded-r-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span className="sr-only">Next</span>
                  <ChevronRight className="h-5 w-5" />
                </Button>
              </nav>
            </div>
          </div>
        </div>
      )}

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

export default function SAdminAuditLogsPage(props) {
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