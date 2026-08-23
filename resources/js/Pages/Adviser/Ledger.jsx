import { useState, useMemo, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { computeBudgetFromEntries, computeOrgBudgetFromLedger } from '@/utils/projectBudget';
import ReactDOM from 'react-dom';
import { Badge } from '@/Components/ui/badge';
import { Button } from '@/Components/ui/button';
import {
  FileText,
  Download,
  Eye,
  Inbox,
  CheckCircle2, 
  XCircle,
  AlertTriangle,
  Hash,
  Clock,
  CheckCircle,
  RotateCcw,
  Search,
  TrendingUp,
  TrendingDown,
  Activity,
  FileCheck,
  ChevronLeft,
  ChevronRight,
  Wallet,
  Shield,
  Verified,
  AlertCircle
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

function formatLimitedNumber(value, opts = {}) {
  const { minFractionDigits = 0, maxFractionDigits = 2 } = opts;
  const n = Number(value) || 0;
  const abs = Math.abs(n);
  if (abs >= 1000000) {
    return (n / 1000000).toLocaleString(undefined, { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits }) + 'M';
  }
  return n.toLocaleString(undefined, { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits });
}

// Helper function to parse budget breakdown (handles both string and object formats)
function parseBudgetBreakdown(budgetBreakdown) {
  if (!budgetBreakdown) return null;
  
  // If it's already an array
  if (Array.isArray(budgetBreakdown)) {
    return budgetBreakdown;
  }
  
  // If it's a string, try to parse it
  if (typeof budgetBreakdown === 'string') {
    try {
      const parsed = JSON.parse(budgetBreakdown);
      return Array.isArray(parsed) ? parsed : null;
    } catch (e) {
      return null;
    }
  }
  
  // If it's an object but not array
  if (typeof budgetBreakdown === 'object') {
    // Check if it has items property
    if (budgetBreakdown.items && Array.isArray(budgetBreakdown.items)) {
      return budgetBreakdown.items;
    }
    // If it's a single item object
    if (budgetBreakdown.item || budgetBreakdown.name) {
      return [budgetBreakdown];
    }
  }
  
  return null;
}

// Budget Breakdown Display Component
function BudgetBreakdownDisplay({ breakdown }) {
  const parsedBreakdown = parseBudgetBreakdown(breakdown);
  
  if (!parsedBreakdown || parsedBreakdown.length === 0) {
    return (
      <div className="p-4 bg-gray-50 rounded-lg">
        <p className="text-sm text-gray-500">No budget breakdown available for this transaction.</p>
      </div>
    );
  }

  const totalAmount = parsedBreakdown.reduce((sum, item) => {
    const amount = parseFloat(item.amount) || 
                   (parseFloat(item.qty) || 0) * (parseFloat(item.unitPrice) || 0) ||
                   0;
    return sum + amount;
  }, 0);

  return (
    <div className="bg-gray-50 rounded-lg p-4">
      {/* Header */}
      <div className="flex justify-between items-center pb-2 mb-3 border-b border-gray-200">
        <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Item (Unit Price × Quantity)</span>
        <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Amount</span>
      </div>
      
      {/* Items */}
      <div className="space-y-2">
        {parsedBreakdown.map((item, index) => {
          const itemName = item.item || item.name || `Item ${index + 1}`;
          const qty = parseFloat(item.qty) || parseFloat(item.quantity) || 1;
          const unitPrice = parseFloat(item.unitPrice) || parseFloat(item.rate) || 0;
          const amount = parseFloat(item.amount) || (qty * unitPrice) || 0;
          
          return (
            <div key={item.id || index} className="flex justify-between items-center py-1">
              <div className="flex-1">
                <span className="text-sm text-gray-900">{itemName}</span>
                {(qty > 0 || unitPrice > 0) && (
                  <span className="text-xs text-gray-500 ml-2">
                    (₱{formatLimitedNumber(unitPrice, { maxFractionDigits: 2 })} × {qty})
                  </span>
                )}
              </div>
              <span className="text-sm font-medium text-blue-600">
                ₱{formatLimitedNumber(amount, { maxFractionDigits: 2 })}
              </span>
            </div>
          );
        })}
      </div>
      
      {/* Total */}
      <div className="flex justify-between pt-3 mt-3 border-t border-gray-200 font-semibold">
        <span className="text-gray-700">Total</span>
        <span className="text-blue-600">
          ₱{formatLimitedNumber(totalAmount, { maxFractionDigits: 2 })}
        </span>
      </div>
    </div>
  );
}

// Return a row background class for tampered entries
function getRowClass(entry) {
  const tampered = !!(
    entry?.tampered ||
    entry?.verificationState?.tampered ||
    (entry && entry.verification_state && entry.verification_state.tampered)
  );
  return tampered ? 'bg-red-100 hover:bg-red-200' : 'bg-white';
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
        className="w-full max-w-3xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
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

function ConfirmRestoreModal({ isOpen, onClose, onConfirm, entry }) {
  if (!isOpen) return null;

  return ReactDOM.createPortal(
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
        <div className="p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-semibold text-gray-900">
              Restore Ledger Entry
            </h3>
            <button
              onClick={onClose}
              className="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          <div className="mb-6">
            <p className="text-gray-700 mb-2">
              This will restore the ledger entry to its approved blockchain state.
            </p>
            <p className="text-red-600 font-medium">
              Any recent changes will be lost. This action cannot be undone.
            </p>
            {entry && (
              <div className="mt-3 p-3 bg-gray-50 rounded-md">
                <p className="text-sm text-gray-600">
                  <span className="font-medium">Entry ID:</span> {entry.id}
                </p>
                <p className="text-sm text-gray-600 mt-1">
                  <span className="font-medium">Project:</span> {entry.projectName}
                </p>
                <p className="text-sm text-gray-600 mt-1">
                  <span className="font-medium">Amount:</span> ₱{formatLimitedNumber(Number(entry.amount))}
                </p>
              </div>
            )}
          </div>
           <p className="text-red-600 font-sm mb-2">
            * We advise that you take a screenshot of this tampering, which can be used as proof.
            </p>
          
          <div className="flex justify-end space-x-3">
            <button
              onClick={onClose}
              className="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={onConfirm}
              className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 transition-colors"
            >
              Restore Entry
            </button>
          </div>
        </div>
      </div>
    </div>,
    document.body
  );
}

function csvEscape(val) {
  const s = String(val ?? '');
  if (/[",\n\r]/.test(s)) return `"${s.replace(/"/g, '""')}"`;
  return s;
}

const TABLE_PAGE_SIZE = 10;

export default function LedgerApprovalsPage() {
  const { ledgerEntries = [], projectFilterOptions = [], totalProjectBudget = 0, userPermissions = [] } = usePage().props;

  const [selectedEntry, setSelectedEntry] = useState(null);

  const canViewLedger = userPermissions.includes('ledger.view');
  const canViewProof = userPermissions.includes('proof-documents.view');
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isRejectDialogOpen, setIsRejectDialogOpen] = useState(false);
  const [isCorrectionDialogOpen, setIsCorrectionDialogOpen] = useState(false);
  const [isRestoreModalOpen, setIsRestoreModalOpen] = useState(false);
  const [isBudgetMismatchModalOpen, setIsBudgetMismatchModalOpen] = useState(false);
  const [rejectionReason, setRejectionReason] = useState('');
  const [correctionReason, setCorrectionReason] = useState('');

  const [filterProject, setFilterProject] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterCategory, setFilterCategory] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  const [ledgerPage, setLedgerPage] = useState(1);
  const [showLedgerProofViewer, setShowLedgerProofViewer] = useState(false);

  useEffect(() => {
    setLedgerPage(1);
  }, [filterProject, filterStatus, searchQuery, filterCategory]);

  const stats = useMemo(() => {
    const approvedEntries = ledgerEntries.filter(
      (e) => e.status === 'Approved' && !e.archive
    );

    const totalIncome = approvedEntries
      .filter((e) => e.transactionType === 'Income')
      .reduce((sum, e) => sum + Number(e.amount), 0);
    const totalExpenses = approvedEntries
      .filter((e) => e.transactionType === 'Expense')
      .reduce((sum, e) => sum + Number(e.amount), 0);

    const computedBudgetFromLedger = computeOrgBudgetFromLedger(approvedEntries);

    const budgetDifference = (Number(totalProjectBudget) || 0) - computedBudgetFromLedger;
    const isBudgetTampered = ledgerEntries.length > 0 && Math.abs(budgetDifference) > 0.01;

    const uniqueProjects = new Set(
      approvedEntries
        .map((e) => e.projectName || e.projectId)
        .filter(Boolean)
    );
    const projectCount = uniqueProjects.size;

    return {
      totalIncome,
      totalExpenses,
      pendingApprovals: ledgerEntries.filter((e) => e.allowAdviserActions).length,
      correctionCount: ledgerEntries.filter((e) => e.status === 'Corrected').length,
      averageIncome: projectCount ? totalIncome / projectCount : 0,
      averageExpenses: projectCount ? totalExpenses / projectCount : 0,
      averageNet: projectCount ? (totalIncome - totalExpenses) / projectCount : 0,
      totalProjectBudget: Number(totalProjectBudget) || 0,
      computedBudgetFromLedger,
      budgetDifference,
      isBudgetTampered,
    };
  }, [ledgerEntries, totalProjectBudget]);

  const handleViewDetails = (entry) => {
    setSelectedEntry(entry);
    setIsDetailsOpen(true);
  };

  const handleOpenRejectDialog = (entry) => {
    setSelectedEntry(entry);
    setIsRejectDialogOpen(true);
  };

  const handleOpenCorrectionDialog = (entry) => {
    setSelectedEntry(entry);
    setIsCorrectionDialogOpen(true);
  };

  const getTypeColor = (type) => {
    switch (type) {
      case 'Expense': return 'bg-red-100 text-red-700';
      case 'Income': return 'bg-green-100 text-green-700';
      case 'Initial': return 'bg-indigo-100 text-indigo-700';
      case 'Initial Transfer': return 'bg-indigo-100 text-indigo-700';
      case 'Donation': return 'bg-blue-100 text-blue-700';
      case 'Sponsorship': return 'bg-purple-100 text-purple-700';
      case 'Canvas': return 'bg-gray-100 text-gray-700';
      case 'Transfer': return 'bg-yellow-100 text-yellow-700';
      default: return 'bg-gray-100 text-gray-700';
    }
  };

  const getTypeAmountColor = (type) => {
    switch (type) {
      case 'Expense': return 'text-red-700';
      case 'Income': return 'text-green-700';
      case 'Initial': return 'text-indigo-700';
      case 'Initial Transfer': return 'text-indigo-700';
      case 'Donation': return 'text-green-700';
      case 'Sponsorship': return 'text-green-700';
      case 'Canvas': return 'text-gray-700';
      case 'Transfer': return 'text-yellow-700';
      default: return 'text-gray-700';
    }
  };

  const handleApprove = (entry) => {
    if (!entry) return;
    if (!window.confirm('Approve this ledger entry?')) return;
    router.post(route('adviser.ledger.approve', entry.id), {}, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Ledger entry approved');
        setIsDetailsOpen(false);
        setSelectedEntry(null);
      },
      onError: () => showToast('Could not approve entry', 'error'),
    });
  };

  const handleReject = () => {
    if (!selectedEntry || !rejectionReason.trim()) {
      showToast('Please provide a rejection reason', 'error');
      return;
    }
    if (!window.confirm('Reject this ledger entry?')) return;
    router.post(route('adviser.ledger.reject', selectedEntry.id), { reason: rejectionReason.trim() }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Ledger entry rejected', 'error');
        setRejectionReason('');
        setIsRejectDialogOpen(false);
        setIsDetailsOpen(false);
        setSelectedEntry(null);
      },
      onError: () => showToast('Could not reject entry', 'error'),
    });
  };

  const handleFixTampered = (entry) => {
    if (!entry) return;
    setSelectedEntry(entry);
    setIsRestoreModalOpen(true);
  };

  const handleConfirmRestore = () => {
    if (!selectedEntry) return;
    
    router.post(route('adviser.ledger.fix-tampered', selectedEntry.id), {}, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Ledger entry restored from blockchain snapshot');
        setIsDetailsOpen(false);
        setSelectedEntry(null);
        setIsRestoreModalOpen(false);
      },
      onError: () => {
        showToast('Could not restore entry', 'error');
        setIsRestoreModalOpen(false);
      },
    });
  };

  const handleCorrection = () => {
    if (!correctionReason.trim()) {
      showToast('Please provide a correction reason', 'error');
      return;
    }
    if (!window.confirm('Request correction for this ledger entry?')) return;
    router.post(route('adviser.ledger.correction', selectedEntry.id), { reason: correctionReason.trim() }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Correction requested');
        setCorrectionReason('');
        setIsCorrectionDialogOpen(false);
        setIsDetailsOpen(false);
        setSelectedEntry(null);
      },
      onError: () => showToast('Could not request correction', 'error'),
    });
  };

//dont show the ledger entry if the status is pending, rejected or draft, only show approved and corrected entries
// const isVisibleEntry = (entry) => {
//   return entry.status === 'Approved' || entry.status === 'Corrected';
// };

  const handleFixBudgetMismatch = () => {
    router.post(route('adviser.ledger.fix-budget-mismatch'), {}, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Project budgets synchronized from ledger');
        setIsBudgetMismatchModalOpen(false);
      },
      onError: () => showToast('Could not synchronize project budgets', 'error'),
    });
  };

  const getStatusBadge = (status) => {
    const baseClasses = 'inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium';
    switch (status) {
      case 'Approved': return <span className={`${baseClasses} bg-green-100 text-green-700 gap-2`}> <CheckCircle className="w-4 h-4 text-green-600"/> Approved</span>;
      case 'Pending Adviser Approval': return <span className={`${baseClasses} bg-yellow-100 text-yellow-700 gap-2`}> <Clock className="w-4 h-4 text-yellow-600" /> Pending Adviser Approval</span>;
      case 'Rejected': return <span className={`${baseClasses} bg-red-100 text-red-700 gap-2`}> <AlertCircle className="w-4 h-4 text-red-600" /> Rejected</span>;
      // case 'Corrected': return <span className={`${baseClasses} bg-purple-100 text-purple-700`}> <Pencil className="w-4 h-4 text-purple-600" /> Corrected</span>;
      case 'Draft': return <span className={`${baseClasses} bg-gray-100 text-gray-700 gap-2`}> <Clock className="w-4 h-4 text-gray-600" /> Draft</span>;
      default: return <span className={`${baseClasses} bg-gray-100 text-gray-600`}>{status || '—'}</span>;
    }
  };

  const filteredEntries = useMemo(() => {
    const items = ledgerEntries.filter((entry) => {
      // if (!isVisibleEntry(entry)) return false;
      if (filterProject !== 'all' && entry.projectName !== filterProject) return false;
      if (filterStatus !== 'all') {
        if (filterStatus === 'Pending') {
          if (!entry.allowAdviserActions) return false;
        } else if (entry.status !== filterStatus) {
          return false;
        }
      }
      if (filterCategory !== 'all' && entry.transactionType !== filterCategory) return false;
      if (searchQuery) {
        const q = searchQuery.toLowerCase();
        const blob = [
          entry.id,
          entry.projectName,
          entry.enteredBy,
          entry.description,
          entry.transactionType,
          entry.ledgerHash,
        ].filter(Boolean).join(' ').toLowerCase();
        if (!blob.includes(q)) return false;
      }
      return true;
    });

    items.sort((a, b) => {
      const ta = a && a.verificationState && a.verificationState.tampered ? 1 : 0;
      const tb = b && b.verificationState && b.verificationState.tampered ? 1 : 0;
      if (ta !== tb) return tb - ta;
      return 0;
    });

    return items;
  }, [ledgerEntries, filterProject, filterStatus, searchQuery, filterCategory]);

  const tamperedEntriesCount = filteredEntries.filter(
    (entry) => entry && entry.verificationState && entry.verificationState.tampered
  ).length;

  const hasTamperAlert =
    stats.isBudgetTampered ||
    tamperedEntriesCount > 0;

  const integrityBadgeLabel = hasTamperAlert
    ? tamperedEntriesCount > 0
      ? 'Tampered Alert'
      : 'Budget Alert'
    : 'Verified';

  const integrityAlertMessage = tamperedEntriesCount > 0
    ? 'A ledger entry has been tampered. Please review the affected entries and contact system administrators immediately.'
    : stats.isBudgetTampered
      ? 'The project budget total does not match the ledger records. Please review and contact system administrators immediately.'
      : 'All ledger records appear verified.';

  const ledgerTotalPages = Math.max(1, Math.ceil(filteredEntries.length / TABLE_PAGE_SIZE));
  const pagedLedger = filteredEntries.slice((ledgerPage - 1) * TABLE_PAGE_SIZE, ledgerPage * TABLE_PAGE_SIZE);

  const handleExport = () => {
    const headers = ['Ledger ID', 'Project', 'Entered By', 'Amount', 'Type', 'Date', 'Status', 'SHA256 Hash'];
    const rows = filteredEntries.map((entry) => [
      csvEscape(entry.id),
      csvEscape(entry.projectName),
      csvEscape(entry.enteredBy),
      csvEscape(entry.amount),
      csvEscape(entry.transactionType),
      csvEscape(entry.date),
      csvEscape(entry.status),
      csvEscape(entry.ledgerHash),
    ]);
    const csvContent = [headers.join(','), ...rows.map((row) => row.join(','))].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', `ledger_entries_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    showToast('CSV file downloaded');
  };

  return (
    <AuthenticatedLayout>
      <Head title="Ledger" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex justify-between items-center">
            <div>
             <div className="flex items-center gap-2">
               <h1 className="text-2xl font-semibold text-blue-600">Admin Ledger Entries Center</h1>
               { hasTamperAlert ? (
                 <Badge className="bg-red-100 text-red-700 rounded-lg">
                   <AlertCircle className="w-3 h-3 mr-1" />
                   {integrityBadgeLabel}
                 </Badge>
               ) : (
                 <Badge className="bg-green-100 text-green-700 rounded-lg">
                   <Shield className="w-3 h-3 mr-1" />
                   {integrityBadgeLabel}
                 </Badge>
               )}
             </div>
              <p className="text-gray-500 mt-1">Review and verify financial ledger entries</p>

              {hasTamperAlert && (
                <div className="mt-3 p-3 bg-red-50 border border-red-200 rounded-lg">
                  <div className="flex items-start gap-2">
                    <AlertCircle className="w-4 h-4 text-red-600 mt-0.5 flex-shrink-0" />
                    <div>
                      <p className="text-sm font-medium text-red-800">
                        {tamperedEntriesCount > 0 ? 'Security Alert.' : 'Budget Alert.'}
                        <span className="text-xs text-red-600 ml-2">
                          {integrityAlertMessage}
                        </span>
                      </p>
                    </div>
                  </div>
                </div>
              )}
            </div>
            <button
              type="button"
              onClick={handleExport}
className="hidden md:inline-flex items-center justify-center px-4 py-2 border bg-blue-600 rounded-xl text-sm font-medium text-white hover:bg-blue-700 transition-colors"            >
              <Download className="w-4 h-4 mr-2" />
              Export CSV
            </button>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">Average Income</p>
                  <p className="text-2xl text-gray-800 mt-1">₱{formatLimitedNumber(stats.averageIncome, { maxFractionDigits: 2 })}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingUp className="w-3 h-3 text-green-600" />
                    <p className="text-xs text-green-600">Verified</p>
                  </div>
                </div>
                <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                  <TrendingUp className="w-6 h-6 text-green-600" />
                </div>
              </div>
            </div>
            <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">Average Expenses</p>
                  <p className="text-2xl text-gray-800 mt-1">₱{formatLimitedNumber(stats.averageExpenses, { maxFractionDigits: 2 })}</p>
                  <div className="flex items-center gap-1 mt-1">
                    <TrendingDown className="w-3 h-3 text-red-600" />
                    <p className="text-xs text-red-600">Tracked</p>
                  </div>
                </div>
                <div className="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                  <TrendingDown className="w-6 h-6 text-red-600" />
                </div>
              </div>
            </div>
            <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">Average Net Per Project</p>
                  <p className={`text-2xl mt-1 ${stats.averageNet >= 0 ? 'text-gray-800' : 'text-red-600'}`}>
                    ₱{formatLimitedNumber(stats.averageNet, { maxFractionDigits: 2 })}
                  </p>
                  <p className="text-xs text-gray-500 mt-1">Across all projects</p>
                </div>
                <div className="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center">
                  <Wallet className="w-6 h-6 text-gray-600" />
                </div>
              </div>
            </div>
            <div className={`p-6 rounded-[20px] border-0 shadow-sm ${stats.isBudgetTampered ? 'bg-red-50 border border-red-200' : 'bg-white'}`}>
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500">Total Project Budget</p>
                  <p className={`text-2xl mt-1 ${stats.isBudgetTampered ? 'text-red-700' : 'text-blue-600'}`}>
                    ₱{formatLimitedNumber(stats.totalProjectBudget, { maxFractionDigits: 2 })}
                  </p>
                  {stats.isBudgetTampered ? (
                    <>
                      <button
                        type="button"
                        onClick={() => setIsBudgetMismatchModalOpen(true)}
                        className="mt-2 inline-flex items-center px-3 py-1.5 text-xs font-medium rounded-lg bg-red-600 text-white hover:bg-red-700 transition-colors"
                      >
                        View Mismatch Details
                      </button>
                    </>
                  ) : (
                    <p className="text-xs text-gray-500 mt-1">Sum of budgets for projects</p>
                  )}
                </div>
                <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${stats.isBudgetTampered ? 'bg-red-100' : 'bg-blue-100'}`}>
                  <Wallet className={`w-6 h-6 ${stats.isBudgetTampered ? 'text-red-600' : 'text-blue-600'}`} />
                </div>
              </div>
            </div>
          </div>

          <>
            <div className="p-4 rounded-[20px] border-0 shadow-sm bg-white">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type="text"
                    placeholder="Search..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                </div>

                    <select
                  value={filterCategory}
                  onChange={(e) => setFilterCategory(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all" disabled>Select Type</option>
             <option value="all">All</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
            <option value="Initial">Initial</option>
            <option value="Initial Transfer">Initial Transfer</option>
             <option value="Transfer">Transfer</option>
                </select>

                <select
                  value={filterStatus}
                  onChange={(e) => setFilterStatus(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all" disabled>Select Status</option>
                  <option value="all">All</option>
                  <option value="Pending Adviser Approval">Pending Adviser Approval</option>
                  <option value="Approved">Approved</option>
                  <option value="Rejected">Rejected</option>
                </select>

   <select
                  value={filterProject}
                  onChange={(e) => setFilterProject(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all" disabled>Select Projects</option>
                  {projectFilterOptions.map((name) => (
                    <option key={name} value={name}>{name}</option>
                  ))}
                </select>
              
              </div>
            </div>

            <div className="rounded-[20px] border-0 shadow-sm bg-white overflow-hidden">
              <div>
                <div className="overflow-x-auto space-y-4 p-6">
                  <table className="w-full">
                    <thead className="bg-gray-50 border-b border-gray-200">
                      <tr>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Ledger ID</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Project</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Entered By</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Amount</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Type</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Date</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Status</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Verification</th>
                        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Proof</th>
                        {canViewLedger && (
                          <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Actions</th>
                        )}
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-200">
                      {pagedLedger.length === 0 ? (
                        <tr>
                          <td colSpan={canViewLedger ? 10 : 9} className="px-6 py-4 text-center">
                             <div className="text-center py-4">
                                                             <Inbox className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                                                             <p className="text-sm text-gray-500">No recent activity found</p>
                                                             <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
                                                           </div>
                          </td>
                        </tr>
                      ) : (
                        pagedLedger.map((entry) => (
                          <tr key={entry.id} className={`${getRowClass(entry)} hover:bg-gray-50 transition-colors`}>
                            <td className="px-6 py-4">
                              <div className="flex items-center gap-2 max-w-[100px]">
                                <span className="text-sm text-blue-600 truncate">{entry.id}</span>
                              </div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <p className="text-sm text-gray-900">{entry.projectName}</p>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <p className="text-sm text-gray-900">{entry.enteredBy}</p>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <p className={`text-sm ${getTypeAmountColor(entry.transactionType)}`}>
                                ₱{formatLimitedNumber(Number(entry.amount))}
                              </p>
                            </td>
                    
                            <td className="px-6 py-4 whitespace-nowrap">
                              <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${getTypeColor(entry.transactionType)}`}>
                                {entry.transactionType}
                              </span>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <p className="text-sm text-gray-600">{entry.date ? new Date(entry.date).toLocaleDateString() : '—'}</p>
                            </td>
                           {/* {isVisibleEntry(entry) && ( */}
                            <td className="px-6 py-4 whitespace-nowrap">
                              {getStatusBadge(entry.status)}
                            </td>
                           {/* )

        } */}
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="flex items-center gap-1">
                                {entry && entry.verificationState && entry.verificationState.tampered ? (
                                  <>
                                    <XCircle className="w-4 h-4 text-red-600" />
                                    <span className="text-xs text-red-600">Tampered</span>
                                  </>
                                ) : entry && entry.verificationState && entry.verificationState.blockchainValid ? (
                                  <>
                                    <CheckCircle2 className="w-4 h-4 text-green-600" />
                                    <span className="text-xs text-green-600">Verified</span>
                                  </>
                                ) : (
                                  <>
                                    <AlertTriangle className="w-4 h-4 text-yellow-600" />
                                    <span className="text-xs text-yellow-600">No Chain</span>
                                  </>
                                )}
                              </div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              <div className="flex items-center gap-1">
                                {entry.proofAttached ? (
                                  <>
                                    <FileCheck className="w-4 h-4 text-green-600" />
                                    <span className="text-xs text-green-600">{entry.proofFiles?.length || 0}</span>
                                  </>
                                ) : (
                                  <>
                                    <AlertTriangle className="w-4 h-4 text-red-600" />
                                    <span className="text-xs text-red-600">Missing</span>
                                  </>
                                )}
                              </div>
                            </td>
                            <td className="px-6 py-4 whitespace-nowrap">
                              {canViewLedger && (
                                <button
                                  type="button"
                                  onClick={() => handleViewDetails(entry)}
                                  className="text-blue-600 hover:text-blue-800 text-sm font-medium flex items-center gap-1"
                                >
                                  <Eye className="w-4 h-4" /> View
                                </button>
                              )}
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            {filteredEntries.length > TABLE_PAGE_SIZE && (
              <div className="flex items-center justify-center gap-4">
                <Button type="button" variant="outline" size="sm" className="rounded-xl" disabled={ledgerPage <= 1} onClick={() => setLedgerPage((p) => Math.max(1, p - 1))}>
                  <ChevronLeft className="w-4 h-4" />
                </Button>
                <span className="text-sm text-gray-600">Page {ledgerPage} of {ledgerTotalPages}</span>
                <Button type="button" variant="outline" size="sm" className="rounded-xl" disabled={ledgerPage >= ledgerTotalPages} onClick={() => setLedgerPage((p) => Math.min(ledgerTotalPages, p + 1))}>
                  <ChevronRight className="w-4 h-4" />
                </Button>
              </div>
            )}
          </>
        </div>
      </div>

      {/* Details Modal with Budget Breakdown */}
      <Modal open={isDetailsOpen} onClose={() => setIsDetailsOpen(false)} title="Ledger Entry Details">
        {selectedEntry && (
          <div className="space-y-6 pt-4">
            {selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.tampered && (
              <div className="border-t pt-6">
                <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                  <div className="flex items-start gap-3">
                    <XCircle className="w-5 h-5 text-red-600 mt-0.5" />
                    <div className="flex-1">
                      <h4 className="text-sm font-medium text-red-800">Data Tampering Detected</h4>
                      <p className="text-sm text-red-700 mt-1">
                        This entry has been modified after approval. You can restore it to its approved state using the blockchain snapshot. This includes restoring all fields such as amount, description, type, and budget breakdown.
                      </p>
                      <button
                        type="button"
                        onClick={() => handleFixTampered(selectedEntry)}
                        className="mt-3 px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors"
                      >
                        <RotateCcw className="w-4 h-4 mr-2 inline" /> Fix Tampered Data
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            )}
            
            <div>
              <h4 className="text-sm font-medium text-gray-500 mb-3">Basic Information</h4>
              <div className="space-y-3 pt-3">
                <div className='grid grid-cols-2 gap-2'>
                  <div>
                    <p className="text-xs text-gray-500">Ledger ID</p>
                    <p className="text-sm text-blue-600">{selectedEntry.id}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Project Title</p>
                    <p className="text-sm text-blue-600">{selectedEntry.projectName}</p>
                  </div>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Ledger Hash (SHA256)</p>
                  <code className="text-xs bg-blue-50 px-2 py-1 rounded block break-all">{selectedEntry.ledgerHash}</code>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Predecessor Hash</p>
                  <code className="text-xs bg-gray-50 px-2 py-1 rounded block break-all">{selectedEntry.predecessorHash || '—'}</code>
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <p className="text-xs text-gray-500">Entered By</p>
                    <p className="text-sm">{selectedEntry.enteredBy}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">CSG Position</p>
                    <p className="text-sm">{selectedEntry.csg_position}</p>
                  </div>
                </div>
              </div>
            </div>

            <div className="border-t pt-6">
              <h4 className="text-sm font-medium text-gray-500 mb-3">Financial Data</h4>
              <div className="space-y-3 pt-3">
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <p className="text-xs text-gray-500">Amount</p>
                    <p className={`text-xl ${getTypeAmountColor(selectedEntry.transactionType)}`}>
                      ₱{formatLimitedNumber(Number(selectedEntry.amount))}
                    </p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-500">Type</p>
                    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${getTypeColor(selectedEntry.transactionType)}`}>
                      {selectedEntry.transactionType}
                    </span>
                  </div>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Description</p>
                  <p className="text-sm text-gray-700">{selectedEntry.description}</p>
                </div>
                
                {/* Budget Breakdown Section */}
                {(selectedEntry.budgetBreakdown || selectedEntry.budget_breakdown) && (
                  <div>
                    <p className="text-xs text-gray-500 mb-2">Budget Breakdown Details</p>
                    <BudgetBreakdownDisplay breakdown={selectedEntry.budgetBreakdown || selectedEntry.budget_breakdown} />
                  </div>
                )}
              </div>
            </div>

            <div className="border-t pt-6">
              <h4 className="text-sm font-medium text-gray-500 mb-3">Proof Documents</h4>
              {selectedEntry.proofAttached ? (
                <div className="space-y-3">
                  {(selectedEntry.proofFiles || []).map((file) => (
                    <div key={file.id} className="p-3 border rounded-xl">
                      <div className="flex items-start justify-between gap-2">
                        <div className="flex items-start gap-2 flex-1 min-w-0">
                          <FileText className="w-5 h-5 text-blue-600 mt-0.5 flex-shrink-0" />
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-medium truncate">{file.name}</p>
                            <p className="text-xs text-gray-500 mt-1">SHA-256: <code className="text-xs break-all">{file.hash}</code></p>
                          </div>
                        </div>
                        {canViewProof && (
                          <Button 
                                             variant="outline" 
                                             size="sm" 
                                             onClick={() => {
                                               setSelectedEntry(selectedEntry);
                                               setShowLedgerProofViewer(true);
                                             }}
                                             className="rounded-lg bg-blue-600 hover:bg-blue-700 text-white"
                                           >
                                             <Eye className="w-4 h-4 mr-1" /> View
                                           </Button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                 <div className="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
                                    <FileText className="w-5 h-5 text-yellow-600 flex-shrink-0" />
                                    <p className="text-yellow-700 text-sm flex-1">No proof document provided</p>
                                  </div>
              )}
            </div>

            <div className="border-t pt-6">
              <h4 className="text-sm font-medium text-gray-500 mb-3">Verification Timeline</h4>
              <div className="space-y-3 pt-3">
                <div className="flex items-start gap-3">
                  <div className="w-2 h-2 bg-blue-600 rounded-full mt-1.5" />
                  <div>
                    <p className="text-sm font-medium">Submitted</p>
                    <p className="text-xs text-gray-500">{selectedEntry && selectedEntry.verificationState ? selectedEntry.verificationState.submitted : ''}</p>
                  </div>
                </div>
                {selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.reviewed && (
                  <div className="flex items-start gap-3">
                    <div className="w-2 h-2 bg-blue-600 rounded-full mt-1.5" />
                    <div>
                      <p className="text-sm font-medium">Reviewed</p>
                      <p className="text-xs text-gray-500">{selectedEntry.verificationState.reviewed}</p>
                    </div>
                  </div>
                )}
                <div className="flex items-start gap-3">
                  <div className={`w-2 h-2 rounded-full mt-1.5 ${
                    selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.tampered ? 'bg-red-600' :
                    selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.blockchainValid ? 'bg-green-600' : 'bg-gray-400'
                  }`} />
                  <div>
                    <p className="text-sm font-medium">Blockchain Verification</p>
                    <p className="text-xs text-gray-500">
                      {selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.tampered ? 'Data integrity compromised' :
                       selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.blockchainValid ? 'Verified and secure' :
                       'No blockchain record'}
                    </p>
                  </div>
                </div>
                {selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.approvedRejected && (
                  <div className="flex items-start gap-3">
                    <div className={`w-2 h-2 rounded-full mt-1.5 ${selectedEntry.status === 'Approved' ? 'bg-green-600' : 'bg-red-600'}`} />
                    <div>
                      <p className="text-sm font-medium">{selectedEntry.status}</p>
                      <p className="text-xs text-gray-500">{selectedEntry.verificationState.approvedRejected}</p>
                    </div>
                  </div>
                )}
                {selectedEntry && selectedEntry.verificationState && selectedEntry.verificationState.corrected && (
                  <div className="flex items-start gap-3">
                    <div className="w-2 h-2 bg-purple-600 rounded-full mt-1.5" />
                    <div>
                      <p className="text-sm font-medium">Corrected</p>
                      <p className="text-xs text-gray-500">{selectedEntry.verificationState.corrected}</p>
                      {selectedEntry.correctionReason && (
                        <p className="text-xs text-purple-600 mt-1">{selectedEntry.correctionReason}</p>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
      </Modal>

      {/* Reject Dialog */}
      <Modal open={isRejectDialogOpen} onClose={() => { setIsRejectDialogOpen(false); setRejectionReason(''); }} title="Reject Ledger Entry">
        <div className="space-y-4 pt-4">
          <p className="text-sm text-gray-600">Please provide a detailed reason for rejecting this entry.</p>
          <textarea
            rows={4}
            value={rejectionReason}
            onChange={(e) => setRejectionReason(e.target.value)}
            placeholder="Explain why..."
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
          />
          <div className="flex gap-3">
            <button
              type="button"
              onClick={() => { setIsRejectDialogOpen(false); setRejectionReason(''); }}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={handleReject}
              className="flex-1 px-4 py-2 bg-red-600 text-white rounded-xl text-sm font-medium hover:bg-red-700"
            >
              Confirm Rejection
            </button>
          </div>
        </div>
      </Modal>

      {/* Correction Dialog */}
      <Modal open={isCorrectionDialogOpen} onClose={() => { setIsCorrectionDialogOpen(false); setCorrectionReason(''); }} title="Request Correction">
        <div className="space-y-4 pt-4">
          <p className="text-sm text-gray-600">Explain what needs to be corrected. The officer will see this note on the pending entry.</p>
          <textarea
            rows={4}
            value={correctionReason}
            onChange={(e) => setCorrectionReason(e.target.value)}
            placeholder="Describe the correction..."
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
          />
          <div className="flex gap-3">
            <button
              type="button"
              onClick={() => { setIsCorrectionDialogOpen(false); setCorrectionReason(''); }}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Cancel
            </button>
            <button
              type="button"
              onClick={handleCorrection}
              className="flex-1 px-4 py-2 bg-purple-600 text-white rounded-xl text-sm font-medium hover:bg-purple-700"
            >
              Confirm Correction
            </button>
          </div>
        </div>
      </Modal>

      {/* Budget Mismatch Modal */}
      <Modal
        open={isBudgetMismatchModalOpen}
        onClose={() => setIsBudgetMismatchModalOpen(false)}
        title="Budget Mismatch Details"
      >
        <div className="space-y-4 pt-4">
          <div className="p-4 rounded-xl bg-red-50 border border-red-200">
            <p className="text-sm font-medium text-red-800">Tampering Alert</p>
            <p className="text-sm text-red-700 mt-1">
              The projects table budget total does not match the computed budget from approved ledger entries.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
            <div className="p-3 rounded-lg bg-gray-50 border">
              <p className="text-xs text-gray-500">Projects Table Total</p>
              <p className="text-sm font-semibold text-gray-900">
                ₱{formatLimitedNumber(stats.totalProjectBudget, { maxFractionDigits: 2 })}
              </p>
            </div>
            <div className="p-3 rounded-lg bg-gray-50 border">
              <p className="text-xs text-gray-500">Ledger Computed Total</p>
              <p className="text-sm font-semibold text-gray-900">
                ₱{formatLimitedNumber(stats.computedBudgetFromLedger, { maxFractionDigits: 2 })}
              </p>
            </div>
            <div className="p-3 rounded-lg bg-red-50 border border-red-200">
              <p className="text-xs text-red-600">Difference</p>
              <p className="text-sm font-semibold text-red-700">
                ₱{formatLimitedNumber(Math.abs(stats.budgetDifference), { maxFractionDigits: 2 })}
              </p>
            </div>
          </div>

          <div className="flex justify-end gap-3">
            <button
              type="button"
              onClick={() => setIsBudgetMismatchModalOpen(false)}
              className="px-4 py-2 text-sm font-medium text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 transition-colors"
            >
              Close
            </button>
            <button
              type="button"
              onClick={handleFixBudgetMismatch}
              className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-md hover:bg-red-700 transition-colors"
            >
              Fix Budget Mismatch
            </button>
          </div>
        </div>
      </Modal>

       {/* Modal for Ledger Proof Document Viewer */}
                  <Modal open={showLedgerProofViewer} onClose={() => { setShowLedgerProofViewer(false); }} title="Proof Document">
                    {selectedEntry?.proofAttached && selectedEntry?.proofFiles && selectedEntry?.proofFiles[0] && (
                      <div className="space-y-4 pt-6">
                        <div className="bg-gray-100 rounded-xl p-6 flex flex-col items-center justify-center min-h-96 max-h-96 overflow-auto">
                          {(() => {
                            const file = selectedEntry.proofFiles[0];
                            const proofUrl = file.url || (file.path ? (file.path.startsWith('/') ? file.path : `/${file.path}`) : '#');
                            const fileName = file.name || file.filename || '';
                            const fileExtension = fileName.split('.').pop().toLowerCase();
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
                                    {fileName}
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
                            <p className="text-sm text-gray-500 mb-1">Transaction ID</p>
                            <p className="font-mono text-sm text-gray-900 break-all">{selectedEntry.id}</p>
                          </div>
                          <div>
                            <p className="text-sm text-gray-500 mb-1">Amount</p>
                            <p className="text-gray-900">₱{formatLimitedNumber(parseFloat(selectedEntry.amount) || 0)}</p>
                          </div>
                        </div>
                        <div className="flex gap-3 pt-4">
                          <Button 
                            className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                            onClick={() => {
                              const file = selectedEntry.proofFiles[0];
                              const proofUrl = file.url || (file.path ? (file.path.startsWith('/') ? file.path : `/${file.path}`) : '#');
                              window.open(proofUrl, '_blank');
                            }}
                          >
                            <Download className="w-4 h-4 mr-2" />Download
                          </Button>
                          <Button onClick={() => setShowLedgerProofViewer(false)} variant="outline" className="flex-1 rounded-xl">Close</Button>
                        </div>
                      </div>
                    )}
                    {(!selectedEntry?.proofAttached || !selectedEntry?.proofFiles || !selectedEntry?.proofFiles[0]) && (
                      <div className="pt-6 text-center">
                        <AlertTriangle className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                        <p className="text-gray-600">No proof document available for this entry.</p>
                      </div>
                    )}
                  </Modal>

      {/* Restore Confirmation Modal */}
      <ConfirmRestoreModal
        isOpen={isRestoreModalOpen}
        onClose={() => {
          setIsRestoreModalOpen(false);
          setSelectedEntry(null);
        }}
        onConfirm={handleConfirmRestore}
        entry={selectedEntry}
      />
    </AuthenticatedLayout>
  );
}