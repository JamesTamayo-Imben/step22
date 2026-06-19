import React, { useState, useMemo, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import ReactDOM from 'react-dom';
import { Clock, FolderKanban, DollarSign, FileText, Eye, CheckCircle, XCircle, Hash, Shield, Search, ChevronLeft, ChevronRight, Download } from 'lucide-react';

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
  const [showLedgerProofViewer, setShowLedgerProofViewer] = useState(false);

  const itemsPerPage = 5;

  useEffect(() => {
    setCurrentPage(1);
  }, [tab, searchQuery, sortOrder]);

  const totalPending = pendingProjects.length + pendingLedger.length;

  const counts = {
    'project proposals': pendingProjects.length,
    'ledger entries': pendingLedger.length,
    'approved items': approvedItems.length,
    'rejected items': rejectedItems.length,
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

    router.post(route('adviser.approvals.approve'), {
      type: item.approvalType,
      id: item.id,
      notes: notes.trim(),
    }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Approved successfully');
        setShowReview(false);
        setShowApprove(false);
        setSelectedItem(null);
        setApprovalNotes('');
      },
      onError: () => showToast('Could not approve', 'error'),
    });
  };

 const handleApproveClick = () => {
  if (!selectedItem) {
    showToast('No item selected', 'error');
    return;
  }
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
  }, [tab, pendingProjects, pendingLedger, approvedItems, rejectedItems]);

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

  return (
    <AuthenticatedLayout>
      <Head title="History" />
      
            <div className="py-8 px-4 lg:px-0 md:px-0">
              <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                  <div>
                    <h1 className="text-gray-900 text-2xl font-semibold">History</h1>
                    <p className="text-gray-500">Review approved and rejected submissions</p>
                  </div>
      
                  {/* <div className="flex items-center gap-3">
                    <div className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-full shadow">
                      <Clock className="w-4 h-4" />
                      <span className="text-sm font-medium">{totalPending} Pending</span>
                    </div>
                  </div> */}
                </div>
      
               
              </div>
            </div>

    </AuthenticatedLayout>
  );
}