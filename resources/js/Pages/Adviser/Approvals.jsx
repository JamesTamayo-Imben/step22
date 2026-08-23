import React, { useState, useMemo, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import ReactDOM from 'react-dom';
import { Clock, Upload, FolderKanban, DollarSign, FileText, Eye, CheckCircle, XCircle, Hash, Shield, Search, ChevronLeft, ChevronRight, Download, Calendar } from 'lucide-react';

function formatLimitedNumber(value, opts = {}) {
  const { minFractionDigits = 0, maxFractionDigits = 2 } = opts;
  const n = Number(value) || 0;
  const abs = Math.abs(n);
  if (abs >= 1000000) {
    return (n / 1000000).toLocaleString('en-US', { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits }) + 'M';
  }
  return n.toLocaleString('en-US', { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits });
}

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.style.color = 'white';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

function Modal({ open, onClose, title, children }) {
  useEffect(() => {
    if (open) {
      const originalStyle = window.getComputedStyle(document.body).overflow;
      document.body.style.overflow = 'hidden';
      return () => {
        document.body.style.overflow = originalStyle;
      };
    }
  }, [open]);

  if (!open) return null;

  return ReactDOM.createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
    >
      <div
        className="relative w-full max-w-3xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between p-6 border-b">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button type="button" onClick={onClose} className="text-gray-500 hover:text-gray-700">✕</button>
        </div>
        <div className="overflow-y-auto p-6 pt-0">
          {children}
        </div>
      </div>
    </div>,
    document.body
  );
}

export default function AdviserApprovalsPage() {
  const {
    pendingProjects = [],
    pendingLedger = [],
    approvedItems = [],
    rejectedItems = [],
    changeRequests = [],
  } = usePage().props;

  const [tab, setTab] = useState('project proposals');
  const [searchQuery, setSearchQuery] = useState('');
  const [sortOrder, setSortOrder] = useState('newest');
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedItem, setSelectedItem] = useState(null);
  const [showReview, setShowReview] = useState(false);
  const [showReject, setShowReject] = useState(false);
  const [showApprove, setShowApprove] = useState(false);
  const [showConfirmReject, setShowConfirmReject] = useState(false);
  const [rejectReason, setRejectReason] = useState('');
  const [approvalNotes, setApprovalNotes] = useState('');
  const [approvalFile, setApprovalFile] = useState(null);
  const [showLedgerProofViewer, setShowLedgerProofViewer] = useState(false);


  const itemsPerPage = 5;

  useEffect(() => {
    setCurrentPage(1);
  }, [tab, searchQuery, sortOrder]);

  const totalPending = pendingProjects.length + pendingLedger.length;

  const counts = {
    'project proposals': pendingProjects.length,
    'ledger entries': pendingLedger.length,
    'Change Requests': changeRequests.length,
  };

  // Calculate project statistics from approved ledger entries
  const projectStats = useMemo(() => {
    const stats = {};
    const allApprovedLedger = approvedItems.filter(item => item.approvalType === 'ledger' || item.entry_type);
    
    allApprovedLedger.forEach(entry => {
      const projectName = entry.project || 'Unknown Project';
      if (!stats[projectName]) {
        stats[projectName] = { income: 0, expense: 0, net: 0, count: 0 };
      }
      
      const amount = parseFloat(entry.amount) || 0;
      const entryType = entry.entry_type || entry.type || 'Expense';
      
      if (entryType === 'Income' || entryType === 'Donation' || entryType === 'Sponsorship') {
        stats[projectName].income += amount;
      } else {
        stats[projectName].expense += amount;
      }
      
      stats[projectName].net = stats[projectName].income - stats[projectName].expense;
      stats[projectName].count += 1;
    });
    
    return stats;
  }, [approvedItems]);

  const projectCount = Object.keys(projectStats).length;
  const averageIncome = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.income, 0) / projectCount : 0;
  const averageExpense = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.expense, 0) / projectCount : 0;
  const averageNet = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.net, 0) / projectCount : 0;

  const runApprove = (item, notes = '') => {
    if (!item) return showToast('No item selected', 'error');

    if (item.approvalType === 'project' && !approvalFile && !item.project_proof) {
      showToast('Please upload the approved proposal PDF before confirming', 'error');
      return;
    }

    const formData = new FormData();
    formData.append('type', item.approvalType);
    formData.append('id', item.id);
    formData.append('notes', notes.trim());

    if (item.approvalType === 'project' && approvalFile) {
      formData.append('approval_copy', approvalFile);
    }

    router.post(route('adviser.approvals.approve'), formData, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Approved successfully');
        setShowReview(false);
        setShowApprove(false);
        setSelectedItem(null);
        setApprovalNotes('');
        setApprovalFile(null);
      },
      onError: () => showToast('Could not approve', 'error'),
    });
  };

  const formatDateRange = (startDate, endDate) => {
  const formatOptions = { month: 'short', day: 'numeric', year: 'numeric' };
  // Or use date-fns:
  // return `${format(new Date(startDate), 'MMM d, yyyy')} to ${format(new Date(endDate), 'MMM d, yyyy')}`;
  
  return new Date(startDate).toLocaleDateString('en-US', formatOptions) + 
         ' to ' + 
         new Date(endDate).toLocaleDateString('en-US', formatOptions);
};


 const handleApproveClick = () => {
  if (!selectedItem) {
    showToast('No item selected', 'error');
    return;
  }
  setApprovalFile(null);
  setShowReview(false);
  setShowApprove(true);
};

  const handleRejectClick = () => {
  if (!rejectReason.trim()) {
    showToast('Please provide a rejection reason before continuing', 'error');
    return;
  }
  setShowConfirmReject(true);
};

  const runReject = () => {
    if (!selectedItem) return showToast('No item selected', 'error');
    if (!rejectReason.trim()) return showToast('Provide a reason', 'error');

    router.post(route('adviser.approvals.reject'), {
      type: selectedItem.approvalType,
      id: selectedItem.id,
      reason: rejectReason.trim(),
    }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Rejected');
        setShowConfirmReject(false);
        setShowReject(false);
        setShowReview(false);
        setSelectedItem(null);
        setRejectReason('');
      },
      onError: () => showToast('Could not reject', 'error'),
    });
  };

  const getApprovalStatusColor = (status) => {
    switch (status) {
      case 'Approved':
        return 'bg-green-100 text-green-700';
      case 'Rejected':
        return 'bg-red-100 text-red-700';
      case 'Pending Adviser Approval':
        return 'bg-yellow-100 text-yellow-700';
      case 'Pending Approval':
        return 'bg-yellow-100 text-yellow-700';
      case 'Draft':
        return 'bg-gray-100 text-gray-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getTypeIcon = (approvalType) => {
    switch (approvalType) {
      case 'project': return <FolderKanban className="w-5 h-5 text-blue-600" />;
      case 'ledger': return <DollarSign className="w-5 h-5 text-green-600" />;
      case 'date_change': return <Calendar className="w-5 h-5 text-purple-600" />;
      default: return <FileText className="w-5 h-5 text-gray-600" />;
    }
  };

  const formatDate = (dateString) => {
  if (!dateString) return 'Not specified';
  
  const date = new Date(dateString);
  if (isNaN(date.getTime())) return 'Not specified';
  
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  });
};

  const itemsForTab = useMemo(() => {
    switch (tab) {
      case 'project proposals': 
        return pendingProjects.map(item => ({ ...item, approvalType: 'project', status: item.status || 'Pending Adviser Approval' }));
      case 'ledger entries': 
        return pendingLedger.map(item => ({ ...item, approvalType: 'ledger', status: item.status || 'Pending Adviser Approval' }));
      case 'Change Requests':
        return changeRequests.map(item => ({ ...item, approvalType: 'date_change', status: 'Pending Approval' }));
      case 'approved items': 
        return approvedItems.map(item => ({
          ...item,
          approvalType: item.approvalType || item.type || (item.entry_type ? 'ledger' : 'project'),
          status: 'Approved'
        }));
      case 'rejected items': 
        return rejectedItems.map(item => ({
          ...item,
          approvalType: item.approvalType || item.type || (item.entry_type ? 'ledger' : 'project'),
          status: 'Rejected'
        }));
      default: 
        return [];
    }
  }, [tab, pendingProjects, pendingLedger, approvedItems, rejectedItems, changeRequests]);

  const filteredEntries = useMemo(() => {
    let filtered = itemsForTab.filter((i) => {
      if (!searchQuery) return true;
      const q = searchQuery.toLowerCase();
      return (
        (i.title || '').toLowerCase().includes(q) ||
        (i.id?.toString() || '').toLowerCase().includes(q) ||
        (i.submittedBy || '').toLowerCase().includes(q) ||
        (i.project || '').toLowerCase().includes(q) ||
        (i.category || '').toLowerCase().includes(q)
      );
    });

    filtered.sort((a, b) => {
      const da = new Date(a.submittedDate || a.created_at || 0).getTime();
      const db = new Date(b.submittedDate || b.created_at || 0).getTime();
      return sortOrder === 'newest' ? db - da : da - db;
    });

    return filtered;
  }, [itemsForTab, searchQuery, sortOrder]);

  const totalPages = Math.ceil(filteredEntries.length / itemsPerPage);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredEntries.slice(indexOfFirstItem, indexOfLastItem);

  const renderItem = (item) => (
    <Card key={`${item.approvalType}-${item.id}`} className="rounded-[20px] border-0 shadow-sm p-4 hover:shadow-md transition-all">
      <div className="flex items-start gap-4">
        <div className="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0">{getTypeIcon(item.approvalType)}</div>
        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between gap-2 mb-2">
            <div className="flex-1 min-w-0">
              <h3 className="text-gray-900 mb-1 truncate">{item.title}</h3>
              <p className="text-xs text-gray-500">ID: {item.id}</p>
            </div>
            <div className={`text-xs px-3 py-1 rounded-full ${getApprovalStatusColor(item.status)}`}>
              {item.status}
            </div>
          </div>

          <div className="space-y-1 mb-3">
            <p className="text-sm text-gray-600">Submitted by: {item.submittedBy}</p>
            <p className="text-sm text-gray-600">Date: {item.submittedDate || item.created_at}</p>
            {item.project && <p className="text-sm text-gray-600">Project Title: {item.project}</p>}
            
            {/* Show date details for date change requests */}
            {/* {item.approvalType === 'date_change' && (
              <div className="mt-2 p-2 bg-purple-50 rounded border border-purple-200">
                <p className="text-sm font-medium text-purple-900 mb-1">Date Change Details:</p>
                <p className="text-xs text-purple-700">Current: {item.currentStartDate} to {item.currentEndDate}</p>
                <p className="text-xs text-purple-700">Proposed: {item.proposedStartDate} to {item.proposedEndDate}</p>
                <p className="text-xs text-purple-600 mt-1 italic">Reason: {item.reason}</p>
              </div>
            )} */}
          </div>

          {(item.status === 'Pending Approval' || item.status === 'Pending Adviser Approval') && (
            <div className="flex gap-2">
              <Button variant="outline" size="sm" className="flex-1 rounded-xl bg-blue-600 text-white hover:bg-blue-700" onClick={() => { setSelectedItem(item); setShowReview(true); }}>
                <Eye className="w-4 h-4 mr-1" /> Review
              </Button>
            </div>
          )}
        </div>
      </div>
    </Card>
  );

  return (
    <AuthenticatedLayout>
      <Head title="Approvals" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-blue-600 text-2xl font-semibold">Admin Approval Center</h1>
              <p className="text-gray-500">Review and approve pending submissions</p>
            </div>

            {/* <div className="flex items-center gap-3">
              <div className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-full shadow">
                <Clock className="w-4 h-4" />
                <span className="text-sm font-medium">{totalPending} Pending</span>
              </div>
            </div> */}
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Project Proposals</p>
                  <p className="text-2xl text-gray-900">{pendingProjects.length}</p>
                </div>
                <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
                  <FolderKanban className="w-8 h-8 text-blue-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Ledger Entries</p>
                  <p className="text-2xl text-gray-900">{pendingLedger.length}</p>
                </div>
                <div className="w-12 h-12 bg-yellow-50 rounded-xl flex items-center justify-center">
                  <DollarSign className="w-8 h-8 text-yellow-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Approved Count</p>
                  <p className="text-2xl text-gray-900">{approvedItems.length}</p>
                </div>
                <div className="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
                  <CheckCircle className="w-8 h-8 text-green-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Rejected Count</p>
                  <p className="text-2xl text-gray-900">{rejectedItems.length}</p>
                </div>
                <div className="w-12 h-12 bg-red-50 rounded-xl flex items-center justify-center">
                  <XCircle className="w-8 h-8 text-red-600" />
                </div>
              </div>
            </Card>
          </div>

          <Card className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="relative md:col-span-2">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Search submissions..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
              <div>
                <select
                  value={sortOrder}
                  onChange={(e) => setSortOrder(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="newest">Newest First</option>
                  <option value="oldest">Oldest First</option>
                </select>
              </div>
            </div>
          </Card>

          <div className="space-y-6">
            <div className="bg-white w-full rounded-xl p-2 shadow-sm grid grid-cols-3 gap-4">
              {/* {['project proposals', 'ledger entries', 'approved items', 'rejected items'].map((t) => ( */}
               {['project proposals', 'ledger entries', 'Change Requests'].map((t) => (
                <button
                  key={t}
                  type="button"
                  onClick={() => setTab(t)}
                  className={`justify-center gap-2 flex items-center text-sm md:text-base gap-2 px-3 py-2 rounded-lg transition-colors ${tab === t ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`}
                >
                  <span className="capitalize">{t}</span>
                  <span className={`text-xs px-2 py-0.5 rounded-full ${tab === t ? 'bg-white/20 text-white' : 'bg-gray-100 text-gray-700'}`}>{counts[t]}</span>
                </button>
              ))}
            </div>

            <div className="space-y-4 grid grid-cols-1 md:grid-cols-2 gap-4">
              {currentItems.length === 0 ? (
                <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center md:col-span-2">
                  <div className="text-center py-4">
                    <Clock className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                    <p className="text-sm text-gray-500">No recent activity found</p>
                    <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
                  </div>
                </Card>
              ) : (
                currentItems.map((item) => renderItem(item))
              )}
            </div>

            {/* Pagination */}
            {filteredEntries.length > 0 && totalPages > 1 && (
              <div className="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 rounded-lg">
                <div className="flex flex-1 justify-between sm:hidden">
                  <Button
                    onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                    disabled={currentPage === 1}
                    className="relative inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Previous
                  </Button>
                  <Button
                    onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                    disabled={currentPage === totalPages}
                    className="relative ml-3 inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Next
                  </Button>
                </div>
                <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                  <div>
                    <p className="text-sm text-gray-700">
                      Page <span className="font-medium">{currentPage}</span> of{' '}
                      <span className="font-medium">{totalPages}</span>
                    </p>
                  </div>
                  <div>
                    <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                      <Button
                        onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                        disabled={currentPage === 1}
                        className="relative inline-flex items-center rounded-l-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        <span className="sr-only">Previous</span>
                        <ChevronLeft className="h-5 w-5" />
                      </Button>
                      
                      {[...Array(totalPages)].map((_, i) => {
                        const page = i + 1;
                        const isCurrentPage = page === currentPage;
                        
                        if (
                          page === 1 ||
                          page === totalPages ||
                          (page >= currentPage - 1 && page <= currentPage + 1)
                        ) {
                          return (
                            <Button
                              key={page}
                              onClick={() => setCurrentPage(page)}
                              className={`relative inline-flex items-center border px-4 py-2 text-sm font-medium ${
                                isCurrentPage
                                  ? 'z-10 bg-blue-600 text-white border-blue-600'
                                  : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'
                              }`}
                            >
                              {page}
                            </Button>
                          );
                        }
                        
                        if (page === currentPage - 2 || page === currentPage + 2) {
                          return (
                            <span
                              key={page}
                              className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700"
                            >
                              ...
                            </span>
                          );
                        }
                        
                        return null;
                      })}
                      
                      <Button
                        onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                        disabled={currentPage === totalPages}
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
          </div>
        </div>
      </div>

            {/* Review Change Date Request Modal */}
      <Modal open={showReview && selectedItem?.approvalType === 'date_change'} onClose={() => setShowReview(false)} title="Review Date Change Request">
        {selectedItem && selectedItem.approvalType === 'date_change' && (
          <div className="space-y-4 pt-6">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500 mb-1">ID *</p>
                <p className="font-mono text-sm text-gray-900 break-all">{selectedItem.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Status *</p>
                <Badge className={`rounded-lg ${getApprovalStatusColor(selectedItem.status)}`}>
                  {selectedItem.status}
                </Badge>
              </div>
              <div className="]">
                <p className="text-sm text-gray-500 mb-1">Project Title *</p>
                <p className="text-gray-900">{selectedItem.project || 'N/A'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Submitted By *</p>
                <p className="text-sm text-gray-900">{selectedItem.submittedBy || 'Unknown'}</p>
              </div>
              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Submitted At *</p>
                <p className="text-sm text-gray-900">{selectedItem.submittedDate || selectedItem.created_at || 'N/A'}</p>
              </div>
               <div>
                <p className="text-sm text-gray-500 mb-1">Current Date *</p>
               <p className="text-sm text-blue-700">{formatDateRange(selectedItem.currentStartDate, selectedItem.currentEndDate)}</p>
              </div>
               <div>
                <p className="text-sm text-gray-500 mb-1">Proposed Date Change*</p>
               <p className="text-sm text-blue-700">{formatDateRange(selectedItem.proposedStartDate, selectedItem.proposedEndDate)}</p>
              </div>
            </div>

            <div className="mt-4">
              <p className="text-sm font-medium text-gray-900">Reason why it was changed:</p>
              <p className="text-sm text-blue-600 ">{selectedItem.reason || 'No reason provided'}</p>
            </div>

          </div>
          
        )}
         
              <div className="flex gap-3 pt-4 border-t">
                <Button variant="outline" className="flex-1 rounded-xl"  onClick={() => setShowReview(false)} >
                  Cancel
                </Button>
                <Button variant="outline" className="flex-1 rounded-xl text-red-600 hover:bg-red-50" onClick={() => { setShowReview(false); setShowReject(true); }} >
                   {/* <XCircle className="w-4 h-4 text-red-600" /> */}
                  Reject
                </Button>
                <Button className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700" onClick={handleApproveClick}>
                  {/* <CheckCircle className="w-4 h-4 text-white-600" /> */}
                  Approve
                </Button>
              </div>
           
      </Modal> 

      {/* Review Project Modal */}
      <Modal open={showReview && selectedItem?.approvalType === 'project'} onClose={() => setShowReview(false)} title="Review Project">
        {selectedItem && selectedItem.type === 'project' && (
          <div className="space-y-4 pt-6">
            {/* Header Info */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500 mb-1">ID *</p>
                <p className="font-mono text-sm text-gray-900 break-all">{selectedItem.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Status *</p>
                <Badge className={`rounded-lg ${getApprovalStatusColor(selectedItem.status)}`}>
                  {selectedItem.status}
                </Badge>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Total Amount *</p>
                <p className="text-xl font-semibold text-blue-600">
                  {selectedItem.amount != null ? `₱${Number(selectedItem.amount).toLocaleString()}` : 'N/A'}
                </p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Category *</p>
                <p className="text-gray-900">{selectedItem.category || 'Not specified'}</p>
              </div>
            </div>

            {/* Project Information */}
            <div className="grid grid-cols-2 gap-4">
              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Project Title *</p>
                <p className="text-gray-900">{selectedItem.title || 'N/A'}</p>
              </div>
              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Objective *</p>
                <p className="text-gray-900">{selectedItem.objective || 'No objective provided'}</p>
              </div>
              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Description *</p>
                <p className="text-gray-900 whitespace-pre-wrap">{selectedItem.description || 'No description provided'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Venue *</p>
                <p className="text-gray-900">{selectedItem.venue || 'Not specified'}</p>
              </div>
               <div>
                <p className="text-sm text-gray-500 mb-1">Timeline *</p>
                <p className="text-gray-900">{formatDate(selectedItem.start_date)} to {formatDate(selectedItem.end_date)}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Created By *</p>
                <p className="text-sm text-gray-900">{selectedItem.created_by || 'Unknown'}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Created At *</p>
                <p className="text-sm text-gray-900">{selectedItem.created_at || 'N/A'}</p>
              </div>
               <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Proposed By *</p>
                <p className="text-gray-900">{selectedItem.proposed_by || 'Not specified'}</p>
              </div>
            </div>

            {/* Proof */}
             <div className="grid grid-cols-2 gap-4">
              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Proof Document *</p>
                {selectedItem.project_proof || selectedItem.ledger_proof ? (
                    <div className="flex items-center justify-between">
                                     <div className="flex items-center gap-3">
                                       <FileText className="w-8 h-8 text-blue-600" />
                                       <div>
                                         <p className="text-sm font-medium text-gray-900">
                                           {(selectedItem.project_proof || selectedItem.ledger_proof).split('/').pop()}
                                         </p>
                                         <p className="text-xs text-gray-500">
                                           {(selectedItem.project_proof || selectedItem.ledger_proof).split('.').pop().toUpperCase()} file
                                         </p>
                                       </div>
                                     </div>
                                     <Button 
                                       variant="outline" 
                                       size="sm" 
                                       onClick={() => {
                                         setSelectedItem(selectedItem);
                                         setShowLedgerProofViewer(true);
                                       }}
                                       className="rounded-lg bg-blue-600 hover:bg-blue-700 text-white"
                                     >
                                       <Eye className="w-4 h-4 mr-1" /> View
                                     </Button>
                                   </div>
                ) : (
                  <div className="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
                    <FileText className="w-5 h-5 text-yellow-600 flex-shrink-0" />
                    <p className="text-yellow-700 text-sm flex-1">No proof document provided</p>
                  </div>
                )}
              </div>

             </div>

            {/* Action Buttons */}
            {(selectedItem.status === 'Pending Approval' || selectedItem.status === 'Pending Adviser Approval') && (
              <div className="flex gap-3 pt-4 border-t">
                
                <Button variant="outline" className="flex-1 rounded-xl"  onClick={() => setShowReview(false)}>
                  Cancel
                </Button>
                <Button variant="outline" className="flex-1 rounded-xl text-red-600 hover:bg-red-50" onClick={() => { setShowReview(false); setShowReject(true); }}>
                   <XCircle className="w-4 h-4 text-red-600" />
                  Reject
                </Button>
                <Button className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700" onClick={handleApproveClick}>
                  <CheckCircle className="w-4 h-4 text-white-600" />
                  Approve
                </Button>
              </div>
            )}
          </div>
        )}
      </Modal>

      {/* Review Ledger Entry Modal */}
      <Modal open={showReview && selectedItem?.approvalType === 'ledger'} onClose={() => setShowReview(false)} title="Review Ledger Entry">
        {selectedItem && selectedItem.approvalType === 'ledger' && (
          <div className="space-y-4 pt-6">
            {/* Header Info */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500 mb-1">Transaction ID *</p>
                <p className="font-mono text-sm text-gray-900 break-all">{selectedItem.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Status *</p>
                <Badge className={`rounded-lg ${getApprovalStatusColor(selectedItem.status)}`}>
                  {selectedItem.status}
                </Badge>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Total Amount *</p>
                <p className="text-xl font-semibold text-blue-600">
                  ₱{selectedItem.amount != null ? Number(selectedItem.amount).toLocaleString() : '0'}
                </p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Type *</p>
                <Badge className={`rounded-lg ${selectedItem.entry_type === 'Income' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                  {selectedItem.entry_type || 'Expense'}
                </Badge>
              </div>
            </div>

            {/* Ledger Entry Information */}
<div className="grid grid-cols-2 gap-4">
  <div className="col-span-2">
    <p className="text-sm text-gray-500 mb-1">Project Title *</p>
    <p className="text-gray-900">{selectedItem.project || 'N/A'}</p>
  </div>
  <div className="col-span-2">
    <p className="text-sm text-gray-500 mb-1">Description *</p>
    <p className="text-gray-900 whitespace-pre-wrap">{selectedItem.description || 'No description provided'}</p>
  </div>

  {/* ADD THIS BLOCK */}
  <div className="col-span-2">
    <p className="text-sm text-gray-500 mb-1">Budget Breakdown *</p>
    {selectedItem.budget_breakdown && selectedItem.budget_breakdown.length > 0 ? (
      <div className="bg-gray-50 rounded-lg p-3">
        <div className="flex justify-between items-center pb-2 mb-2 border-b border-gray-300">
          <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Item (Unit Price × Quantity)</span>
          <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Amount</span>
        </div>
        <div className="space-y-1">
          {selectedItem.budget_breakdown.map((item, index) => (
            <div key={item.id || index} className="flex justify-between items-center py-1">
              <div className="flex-1">
                <span className="text-sm text-gray-900">{item.item || item.name || 'Unnamed Item'}</span>
                {(item.qty || item.quantity) && (
                  <span className="text-xs text-gray-500 ml-2">
                    (₱{(parseFloat(item.unitPrice) || 0).toLocaleString()} × {item.qty || item.quantity})
                  </span>
                )}
              </div>
              <span className="text-sm font-medium text-blue-600">
                ₱{(parseFloat(item.amount) || 0).toLocaleString()}
              </span>
            </div>
          ))}
        </div>
        <div className="flex justify-between pt-2 mt-2 border-t border-gray-300 font-semibold">
          <span className="text-gray-700">Total</span>
          <span className="text-blue-600">
            ₱{selectedItem.budget_breakdown.reduce((sum, item) => sum + (parseFloat(item.amount) || 0), 0).toLocaleString()}
          </span>
        </div>
      </div>
    ) : (
      <p className="text-gray-500">No budget breakdown available.</p>
    )}
  </div>
  {/* END OF ADDED BLOCK */}

  <div>
    <p className="text-sm text-gray-500 mb-1">Created By *</p>
    <p className="text-sm text-gray-900">{selectedItem.created_by || 'Unknown'}</p>
  </div>
  <div>
    <p className="text-sm text-gray-500 mb-1">Created At *</p>
    <p className="text-sm text-gray-900">{selectedItem.created_at || 'N/A'}</p>
  </div>
</div>

              <div className="col-span-2">
                <p className="text-sm text-gray-500 mb-1">Proof Document *</p>
                {selectedItem?.ledger_proof ? (
                   <div className="flex items-center justify-between">
                                     <div className="flex items-center gap-3 min-w-0">
                                       <FileText className="w-8 h-8 text-blue-600" />
                                       <div className="min-w-0">
                                         <p className="text-sm font-medium text-gray-900 truncate">
                                           {selectedItem.ledger_proof.split('/').pop()}
                                         </p>
                                         <p className="text-xs text-gray-500">
                                           {selectedItem.ledger_proof.split('.').pop().toUpperCase()} file
                                         </p>
                                       </div>
                                     </div>
                                     <Button 
                                       variant="outline" 
                                       size="sm" 
                                       onClick={() => {
                                         setSelectedItem(selectedItem);
                                         setShowLedgerProofViewer(true);
                                       }}
                                       className="rounded-lg bg-blue-600 hover:bg-blue-700 text-white"
                                     >
                                       <Eye className="w-4 h-4 mr-1" /> View
                                     </Button>
                                   </div>
                ) : (
                  <div className="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
                    <FileText className="w-5 h-5 text-yellow-600 flex-shrink-0" />
                    <p className="text-yellow-700 text-sm flex-1">No proof document provided</p>
                  </div>
                )}
              </div>

            {/* Action Buttons */}
            {(selectedItem.status === 'Pending Approval' || selectedItem.status === 'Pending Adviser Approval') && (
              <div className="flex gap-3 pt-4 border-t">
                <Button variant="outline" className="flex-1 rounded-xl" onClick={() => setShowReview(false)}>
                  Cancel
                </Button>
                <Button variant="outline" className="flex-1 rounded-xl text-red-600 hover:bg-red-50" onClick={() => { setShowReview(false); setShowReject(true); }}>
                  Reject
                </Button>
                <Button className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700" onClick={handleApproveClick}>
                  Approve
                </Button>
              </div>
            )}
          </div>
        )}
      </Modal>

      <Modal open={showReject} onClose={() => setShowReject(false)} title="Reject Submission">
        <div className="space-y-4 pt-4">
          <p className="text-sm text-gray-600">Please provide a reason for rejecting this submission.</p>
          <textarea value={rejectReason} onChange={(e) => setRejectReason(e.target.value)} rows={4} className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:border-blue-300 focus:ring-2 focus:ring-blue-200 outline-none transition" />
          <div className="flex gap-3">
            <Button variant="outline" className="flex-1 rounded-xl" onClick={() => { setShowReject(false); setRejectReason(''); }}>Cancel</Button>
            <Button className="text-white flex-1 rounded-xl bg-red-600 hover:bg-red-700" onClick={handleRejectClick}>Continue</Button>
          </div>
        </div>
      </Modal>

      {/* Approve Submission Modal */}
<Modal open={showApprove} onClose={() => { setShowApprove(false); setApprovalNotes(''); }} title="Approve Submission">
  <div className="space-y-4 pt-4">
    <div>
      <p className="text-sm text-gray-600 mb-2">
        Please provide approval notes <span className="text-red-500">*</span>
      </p>
      <textarea
        value={approvalNotes}
        onChange={(e) => setApprovalNotes(e.target.value)}
        rows={4}
        placeholder="Enter approval notes (required)..."
        className={`w-full rounded-xl border ${!approvalNotes.trim() ? 'border-gray-300 bg-gray-50' : 'border-gray-300 bg-gray-50'} focus:bg-white focus:border-blue-300 focus:ring-2 focus:ring-blue-200 outline-none transition`}
      />
      {selectedItem?.approvalType === 'project' && (
        <>
          <p className="text-sm text-gray-600 mb-2">Upload the final approved proposal PDF <span className="text-red-500">*</span></p>
          <div className="border-2 border-dashed border-gray-300 rounded-xl p-4 text-center">
            <Upload className="w-8 h-8 text-gray-400 mx-auto mb-2" />
            <p className="text-sm text-gray-500">Select the final approved proposal PDF</p>
            <p className="text-xs text-gray-400">PDF only · max 10MB</p>
            <label className="mt-3 inline-flex cursor-pointer rounded-lg border border-blue-300 bg-blue-50 px-3 py-2 text-sm font-medium text-blue-700 hover:bg-blue-100">
              <input
                type="file"
                accept="application/pdf"
                className="hidden"
                onChange={(e) => setApprovalFile(e.target.files?.[0] || null)}
              />
              Browse Files
            </label>
            {approvalFile ? (
              <p className="mt-2 text-sm text-green-700">Selected: {approvalFile.name}</p>
            ) : (
              <p className="mt-2 text-sm text-gray-500">No file selected yet</p>
            )}
          </div>
        </>
      )}
    </div>
    <div className="flex gap-3">
      <Button variant="outline" className="flex-1 rounded-xl" onClick={() => { setShowApprove(false); setApprovalNotes(''); }}>
        Cancel
      </Button>
      <Button 
        className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed" 
        onClick={() => {
          if (!approvalNotes.trim()) {
            showToast('Please provide approval notes before confirming', 'error');
            return;
          }
          runApprove(selectedItem, approvalNotes);
        }}
        disabled={!approvalNotes.trim()}
      >
        Confirm Approval
      </Button>
    </div>
  </div>
</Modal>

{/* Modal for Proof Document Viewer - Project or Ledger */}
            <Modal open={showLedgerProofViewer} onClose={() => { setShowLedgerProofViewer(false); }} title="Proof Document">
              {selectedItem && (selectedItem?.approvalType === 'ledger' ? selectedItem?.ledger_proof : selectedItem?.project_proof) && (
                <div className="space-y-4 pt-6">
                  <div className="bg-gray-100 rounded-xl p-6 flex flex-col items-center justify-center min-h-96 max-h-96 overflow-auto">
                    {(() => {
                      const proofPath = selectedItem?.approvalType === 'ledger' ? selectedItem?.ledger_proof : selectedItem?.project_proof;
                      const proofUrl = proofPath.startsWith('/') 
                        ? proofPath 
                        : `/${proofPath}`;
                      const fileExtension = proofPath.split('.').pop().toLowerCase();
                      const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
                      
                      if (imageExtensions.includes(fileExtension)) {
                        return (
                          <img 
                            src={proofUrl} 
                            alt="Proof Document" 
                            className="max-w-full max-h-96 object-contain rounded-lg"
                            onError={() => {
                              console.error('Failed to load image:', proofUrl);
                            }}
                          />
                        );
                      } else if (fileExtension === 'pdf') {
                        return (
                          <iframe 
                            src={proofUrl} 
                            className="w-full h-96 rounded-lg border-0"
                            title="PDF Preview"
                          />
                        );
                      } else {
                        return (
                          <div className="text-center">
                            <FileText className="w-16 h-16 text-blue-600 mb-4 mx-auto" />
                            <p className="text-gray-600 mb-2 font-medium">
                              {proofPath.split('/').pop()}
                            </p>
                            <p className="text-sm text-gray-500">
                              {fileExtension.toUpperCase()} file
                            </p>
                          </div>
                        );
                      }
                    })()}
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <p className="text-sm text-gray-500 mb-1">{selectedItem.approvalType === 'ledger' ? 'Transaction' : 'Project'} ID</p>
                      <p className="font-mono text-sm text-gray-900 break-all">{selectedItem.id}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500 mb-1">Amount</p>
                      <p className="text-gray-900">₱{formatLimitedNumber(parseFloat(selectedItem.amount) || 0)}</p>
                    </div>
                  </div>
                  <div className="flex gap-3 pt-4">
                    <Button 
                      className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                      onClick={() => {
                        const proofPath = selectedItem?.approvalType === 'ledger' ? selectedItem?.ledger_proof : selectedItem?.project_proof;
                        const proofUrl = proofPath.startsWith('/') 
                          ? proofPath 
                          : `/${proofPath}`;
                        window.open(proofUrl, '_blank');
                      }}
                    >
                      <Download className="w-4 h-4 mr-2" />Download
                    </Button>
                    <Button onClick={() => setShowLedgerProofViewer(false)} variant="outline" className="flex-1 rounded-xl">Close</Button>
                  </div>
                </div>
              )}
            </Modal>

     {/* Reject Confirmation Modal */}
<Modal open={showConfirmReject} onClose={() => setShowConfirmReject(false)} title="Confirm Rejection">
  <div className="pt-4">
    <p className="font-semibold text-gray-900">Are you sure?</p>
    
    <p className="text-sm text-gray-700">
          This submission will be rejected with the reason: 
          <span className="font-medium block mt-1 p-2 bg-white rounded border border-red-200 mt-2 text-red-600">
            "{rejectReason}"
          </span>
        </p>
    <div className="flex gap-3 mt-4">
      <Button variant="outline" className="flex-1 rounded-xl" onClick={() => setShowConfirmReject(false)}>
        Cancel
      </Button>
      <Button className="text-white flex-1 rounded-xl bg-red-600 hover:bg-red-700" onClick={runReject}>
        Yes, Reject It
      </Button>
    </div>
  </div>
</Modal>
    </AuthenticatedLayout>
  );
}