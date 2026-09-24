import React, { useEffect, useRef, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { usePage } from '@inertiajs/react';
import { Head } from '@inertiajs/react';
import { computeBudgetFromEntries, computeOrgBudgetFromLedger, projectBudgetMismatch } from '@/utils/projectBudget';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge } from '@/Components/ui/badge';
import AssetActionFields from '@/Components/AssetActionFields';
import {
  Plus,
  Search,
  Filter,
  Download,
  Eye,
  Edit,
  Trash2,
  Send,
  Upload,
  Hash,
  Shield,
  Wallet,
  TrendingUp,
  TrendingDown,
  X,
  Folder,
  FileText,
  CheckCircle,
  Clock,
  XCircle,
  AlertCircle,
  Lock,
  ChevronLeft,
  ChevronRight,
  RefreshCw,
  MoreVertical,
} from 'lucide-react';

function proofDetails(value) {
  const url = new URL(value, window.location.origin);
  const fileName = decodeURIComponent(url.pathname.split('/').pop() || 'Proof document');
  const extension = fileName.includes('.') ? fileName.split('.').pop().toLowerCase() : '';

  return { url: url.toString(), fileName, extension };
}

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

function Modal({ open, onClose, title, description, children }) {
  useEffect(() => {
    if (!open) return undefined;
    const originalStyle = window.getComputedStyle(document.body).overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = originalStyle;
    };
  }, [open]);

  if (!open) return null;

  return ReactDOM.createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
      role="dialog"
      aria-modal="true"
    >
      <div
        className="relative w-full max-w-3xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between p-6 border-b">
          <div>
            <h3 className="text-lg font-semibold">{title}</h3>
            {description ? <p className="text-sm text-gray-500 mt-1">{description}</p> : null}
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            ✕
          </button>
        </div>
        <div className="overflow-y-auto p-6 pt-0">{children}</div>
      </div>
    </div>,
    document.body
  );
}

function FieldLabel({ children }) {
  return <label className="block text-sm text-gray-700 mb-1">{children}</label>;
}

function Textarea({ className = '', rows = 4, ...props }) {
  return (
    <textarea
      rows={rows}
      className={[
        'w-full px-3 py-2 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      {...props}
    />
  );
}

function Select({ className = '', children, ...props }) {
  return (
    <select
      className={[
        'w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      {...props}
    >
      {children}
    </select>
  );
}

const ASSET_CATEGORIES = ['Furniture', 'Electronic Devices', 'Tools', 'Office Equipment', 'Other'];

function normalizeLedgerEntry(entry) {
  return {
    ...entry,
    status: entry.approval_status || entry.status || 'Draft',
    projectName: entry.project?.title || entry.project?.name || entry.project_name || entry.project || '—',
    project: entry.project?.title || entry.project?.name || entry.project_name || entry.project || '—',
    amount: Number(entry.amount) || 0,
    createdAt: entry.created_at ? entry.created_at.split('T')[0] : entry.createdAt,
    createdBy: entry.created_by || entry.createdBy || 'N/A',
    budgetBreakdown: entry.budget_breakdown || [],
    verificationState: entry.verificationState || {
      tampered: false,
      blockchainStatus: 'no_chain',
      blockchainValid: false,
      submitted: '',
      reviewed: '',
      approvedRejected: '',
      corrected: '',
    },
  };
}

function Switch({ checked, onCheckedChange, label }) {
  return (
    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
      <span className="text-sm text-gray-700">{label}</span>
      <button
        type="button"
        role="switch"
        aria-checked={checked}
        onClick={() => onCheckedChange(!checked)}
        className={`
          relative inline-flex h-6 w-11 items-center rounded-full transition-colors
          ${checked ? 'bg-blue-600' : 'bg-gray-300'}
        `}
      >
        <span
          className={`
            inline-block h-4 w-4 transform rounded-full bg-white transition-transform
            ${checked ? 'translate-x-6' : 'translate-x-1'}
          `}
        />
      </button>
    </div>
  );
}

function LedgerPageInner() {
  const page = usePage();
  const { ledgerEntries: initialLedgerEntries = [], projects: initialProjects = [] } = page.props;
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDetailsModal, setShowDetailsModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [showUploadModal, setShowUploadModal] = useState(false);
  const [showBulkModal, setShowBulkModal] = useState(false);
  const [showAssetsModal, setShowAssetsModal] = useState(false);
  const [assetInventory, setAssetInventory] = useState([]);
  const [bulkProjectId, setBulkProjectId] = useState('');
  const [bulkCsvFile, setBulkCsvFile] = useState(null);
  const [bulkProofFile, setBulkProofFile] = useState(null);
  const [bulkPreview, setBulkPreview] = useState(null); // response from bulk-preview endpoint
  const [isBulkPreviewing, setIsBulkPreviewing] = useState(false);
  const [isBulkUploading, setIsBulkUploading] = useState(false);
  const bulkCsvInputRef = useRef(null);
  const bulkProofInputRef = useRef(null);
  const [selectedEntry, setSelectedEntry] = useState(null);
  const [filePreview, setFilePreview] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const fileInputRef = useRef(null);
  const [showLedgerProofViewer, setShowLedgerProofViewer] = useState(false);

  // Can Ledger
  const userPermissions = Array.isArray(page.props.userPermissions)
    ? page.props.userPermissions
    : Array.isArray(page.props.auth?.permissions)
      ? page.props.auth.permissions
      : [];

  const canCreateLedgers = userPermissions.includes('ledger.create');
  const canEditLedgers = userPermissions.includes('ledger.edit');
  const canViewLedgers = userPermissions.includes('ledger.view');
  const canDeleteLedgers = userPermissions.includes('ledger.delete');
  const canSubmitLedgers = userPermissions.includes('ledger.submit');

  // Pagination
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 10;

  // Filters
  const [searchQuery, setSearchQuery] = useState('');
  const [filterType, setFilterType] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterProject, setFilterProject] = useState('all');
  const [isLoading, setIsLoading] = useState(false);
  const [isDataLoaded, setIsDataLoaded] = useState(true);

  const [ledgerEntries, setLedgerEntries] = useState(() => (
    Array.isArray(initialLedgerEntries) ? initialLedgerEntries.map(normalizeLedgerEntry) : []
  ));
  const [allProjects, setAllProjects] = useState(() => (
    Array.isArray(initialProjects)
      ? initialProjects.filter((project) => (
          (project.approval_status || project.status || '').toString().toLowerCase() === 'approved'
        ))
      : []
  ));
  const [editBudgetItems, setEditBudgetItems] = useState([{ id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }]);
  const [isUploading, setIsUploading] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);

  const fetchAssetInventory = async () => {
    try {
      const response = await fetch('/api/ledger-entries/assets?mode=return', {
        headers: {
          Accept: 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch asset inventory');
      }

      const data = await response.json();
      setAssetInventory(Array.isArray(data) ? data : []);
    } catch (error) {
      console.error('Failed to load asset inventory', error);
      setAssetInventory([]);
    }
  };

  const fetchLedgerEntries = () => {
    return fetch('/api/ledger-entries')
      .then((response) => response.json())
      .then((data) => {
        const processedData = data.map(normalizeLedgerEntry);
        console.log('Processed ledger entries:', processedData);
        setLedgerEntries(processedData);
        return processedData;
      })
      .catch((err) => {
        console.error('Failed to fetch ledger entries', err);
        showToast('Unable to load ledger entries', 'error');
        throw err;
      });
  };

  //computation of total budget in all prjects getting it from the project table budget column
  // const totalBudget = allProjects.reduce((sum, project) => sum + (Number(project.budget) || 0), 0);
  // const totalBudget = allProjects.reduce((sum, project) => sum + Math.max(0, Number(project.budget) || 0), 0);
const rawTotalBudget = allProjects.reduce((sum, project) => sum + (Number(project.budget) || 0), 0);
const totalBudget = Math.max(0, rawTotalBudget);
const totalShortfall = Math.max(0, -rawTotalBudget);


  // Compute ledger-derived budget (sum of APPROVED entries only).
  // Draft/Pending/Rejected entries must not count toward the org total,
  // otherwise this drifts from `totalBudget` (which only sums approved
  // projects) and falsely triggers the tampered/mismatch alert.
  const approvedLedgerEntries = ledgerEntries.filter((e) => (e.status || e.approval_status) === 'Approved');
  const computedBudgetFromLedger = computeOrgBudgetFromLedger(approvedLedgerEntries);

  const budgetDifference = (Number(totalBudget) || 0) - computedBudgetFromLedger;
  const isBudgetTampered = isDataLoaded && approvedLedgerEntries.length > 0 && Math.abs(budgetDifference) > 0.01;

  //if the ledger entry is a initial, initial transfer or transfer it should not be edited directly in the ledger entry
  const isEditable = (entry) => {
    return !['Initial', 'Initial Transfer', 'Transfer'].includes(entry.type);
  };

  useEffect(() => {
    let isMounted = true;

    const fetchProjects = () => {
      return fetch('/api/projects', {
        headers: {
          Accept: 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (Array.isArray(data) && isMounted) {
            setAllProjects(
              data.filter((p) => ((p.approval_status || p.status || '').toString().toLowerCase() === 'approved'))
            );
          }
          return data;
        })
        .catch((err) => {
          console.error('Failed to fetch projects', err);
          showToast('Unable to load projects', 'error');
          throw err;
        });
    };

    const loadInitialData = async () => {
      setIsDataLoaded(false);
      try {
        await Promise.all([fetchLedgerEntries(), fetchProjects()]);
      } finally {
        if (isMounted) {
          setIsDataLoaded(true);
        }
      }
    };

    loadInitialData();

    return () => {
      isMounted = false;
    };
  }, []);

  const projectStats = ledgerEntries
    .filter((entry) => entry.approval_status === 'Approved')  // Only include approved entries
    .reduce((acc, entry) => {
      const projectName = entry.project || 'Unknown Project';
      if (!acc[projectName]) {
        acc[projectName] = { income: 0, expense: 0, net: 0, count: 0 };
      }
      if (entry.type === 'Income') {
        acc[projectName].income += entry.amount || 0;
      } else if (entry.type === 'Expense' || entry.type === 'Asset') {
        acc[projectName].expense += entry.amount || 0;
      }
      acc[projectName].net = acc[projectName].income - acc[projectName].expense;
      acc[projectName].count += 1;
      return acc;
    }, {});

  const projectCount = Object.keys(projectStats).length;
  const averageIncome = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.income, 0) / projectCount : 0;
  const averageExpense = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.expense, 0) / projectCount : 0;
  const averageNet = projectCount > 0 ? Object.values(projectStats).reduce((sum, s) => sum + s.net, 0) / projectCount : 0;

  const [ledgerForm, setLedgerForm] = useState({
    type: 'Expense',
    amount: '',
    description: '',
    category: '',
    project_id: '',
    referenceNumber: '',
    requiresProof: true,
  });
  const [assetMode, setAssetMode] = useState('purchase');
  const [assetUsages, setAssetUsages] = useState([]);



  const projects = allProjects.length > 0 ? allProjects : [
    { id: '1', title: 'Create a Project First' },
  ];

  const filteredEntries = (() => {
    const items = ledgerEntries.filter(entry => {
      const matchesSearch = entry.projectName?.toLowerCase().includes(searchQuery.toLowerCase()) ||
                           entry.id?.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesType = filterType === 'all' || entry.type === filterType;
      const matchesStatus = filterStatus === 'all' || entry.status === filterStatus;
      const matchesProject = filterProject === 'all' || entry.project === filterProject;
      return matchesSearch && matchesType && matchesStatus && matchesProject;
    });

    // Put tampered entries first for easier visibility
    items.sort((a, b) => {
      const ta = a?.verificationState?.tampered ? 1 : 0;
      const tb = b?.verificationState?.tampered ? 1 : 0;
      if (ta !== tb) return tb - ta; // tampered (1) before non-tampered (0)
      return 0;
    });

    return items;
  })();

  // Check if project has budget mismatch (same rules as Adviser ledger / ProjectBudgetCalculator)
  const getProjectBudgetStatus = (projectId) => {
    const projectLedgers = ledgerEntries.filter(
      (entry) =>
        String(entry?.project_id || entry?.projectId || '') === String(projectId || '') &&
        (entry?.status || entry?.approval_status) === 'Approved'
    );

    const project = allProjects.find((p) => p.id === projectId);
    if (!project) return { isMismatched: false };

    if (ledgerEntries.length > 0 && projectLedgers.length === 0) {
      return { isMismatched: false };
    }

    const displayBudget = parseFloat(project.budget) || 0;
    const computedFromLedger = computeBudgetFromEntries(projectLedgers);
    const isMismatched = projectBudgetMismatch(displayBudget, computedFromLedger, projectLedgers.length > 0);

    return { isMismatched };
  };

  const tamperedProjectIds = new Set(
    ledgerEntries
      .filter((entry) => entry?.verificationState?.tampered)
      .map((entry) => String(entry?.project_id || ''))
      .filter(Boolean)
  );
  const mismatchedProjectIds = new Set(
    allProjects
      .filter((p) => getProjectBudgetStatus(p.id).isMismatched)
      .map((p) => String(p.id || ''))
      .filter(Boolean)
  );
  const hasTamperedEntries = isDataLoaded && tamperedProjectIds.size > 0;
  const hasBudgetMismatchAlert = isDataLoaded && (mismatchedProjectIds.size > 0 || isBudgetTampered);
  const isProjectLocked = (projectId) => tamperedProjectIds.has(String(projectId || ''));

  // ─── Bulk CSV Upload ──────────────────────────────────────────────────────

  const resetBulkModal = () => {
    setBulkProjectId('');
    setBulkCsvFile(null);
    setBulkProofFile(null);
    setBulkPreview(null);
    if (bulkCsvInputRef.current) bulkCsvInputRef.current.value = '';
    if (bulkProofInputRef.current) bulkProofInputRef.current.value = '';
  };

  const handleCloseBulkModal = () => {
    resetBulkModal();
    setShowBulkModal(false);
  };

  const downloadBulkCsvTemplate = () => {
    const sample = [
      'type,item,qty,unit_price,description',
      'Income,Registration fees,1,2500,Membership drive',
      'Expense,Venue rental,1,1500,Membership drive',
      'Expense,Snacks,50,25,Membership drive',
      'Donation,Alumni contribution,1,1000,',
    ].join('\n');
    const blob = new Blob([sample], { type: 'text/csv' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'ledger_bulk_upload_template.csv';
    document.body.appendChild(a);
    a.click();
    a.remove();
    URL.revokeObjectURL(url);
  };

  const handleBulkCsvSelect = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!/\.(csv|txt)$/i.test(file.name)) {
      showToast('Please select a .csv file', 'error');
      return;
    }
    setBulkCsvFile(file);
    setBulkPreview(null); // require re-preview after picking a new file
  };

  const handleBulkProofSelect = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      showToast('Proof file must be less than 2MB due to the lack of storage space', 'error');
      return;
    }
    setBulkProofFile(file);
  };

  const handleBulkPreviewClick = async () => {
    if (!bulkProjectId) {
      showToast('Please select a project first', 'error');
      return;
    }
    if (!bulkCsvFile) {
      showToast('Please choose a CSV file to upload', 'error');
      return;
    }

    setIsBulkPreviewing(true);
    try {
      const formData = new FormData();
      formData.append('project_id', bulkProjectId);
      formData.append('csv_file', bulkCsvFile);

      const res = await fetch('/api/ledger-entries/bulk-preview', {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: formData,
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) {
        const errList = data.errors
          ? Object.values(data.errors).flat().join('\n')
          : (data.message || 'Could not preview this CSV file.');
        showToast(errList, 'error');
        return;
      }

      setBulkPreview(data);
      if (data.entries_to_create === 0) {
        showToast('No valid rows found — check the CSV format and try again', 'error');
      }
    } catch (err) {
      showToast('Network error while previewing the CSV: ' + (err.message || ''), 'error');
    } finally {
      setIsBulkPreviewing(false);
    }
  };

  const handleBulkSubmit = async () => {
    if (!bulkPreview || bulkPreview.entries_to_create === 0) {
      showToast('Preview the CSV first', 'error');
      return;
    }

    setIsBulkUploading(true);
    try {
      const formData = new FormData();
      formData.append('project_id', bulkProjectId);
      formData.append('csv_file', bulkCsvFile);
      if (bulkProofFile) {
        formData.append('proof_file', bulkProofFile);
      }

      const res = await fetch('/api/ledger-entries/bulk-upload', {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: formData,
      });

      const data = await res.json().catch(() => ({}));

      if (!res.ok) {
        const errList = data.errors
          ? Object.values(data.errors).flat().join('\n')
          : (data.message || 'Bulk upload failed.');
        showToast(errList, 'error');
        return;
      }

      showToast(data.message || 'Ledger entries created from CSV', 'success');
      await fetchLedgerEntries();
      handleCloseBulkModal();
    } catch (err) {
      showToast('Network error while uploading: ' + (err.message || ''), 'error');
    } finally {
      setIsBulkUploading(false);
    }
  };
  const hasSecurityAlert = hasTamperedEntries || hasBudgetMismatchAlert;
  const integrityBadgeLabel = hasTamperedEntries
    ? 'Tampered Alert'
    : hasBudgetMismatchAlert
      ? 'Budget Alert'
      : isDataLoaded
        ? 'Verified'
        : 'Checking Integrity';
  const integrityAlertMessage = hasTamperedEntries
    ? 'A ledger entry has been tampered with. Please review the affected entries and contact system administrators immediately.'
    : hasBudgetMismatchAlert
      ? 'A budget mismatch was detected between the project budgets and approved ledger entries. Please review the data before assuming tampering.'
      : isDataLoaded
        ? 'All ledger records appear verified.'
        : 'Loading ledger integrity data...';

  // Pagination logic
  const totalPages = Math.ceil(filteredEntries.length / itemsPerPage);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredEntries.slice(indexOfFirstItem, indexOfLastItem);

  // Reset to first page when filters change
  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, filterType, filterStatus, filterProject]);

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Approved':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'Rejected':
        return <XCircle className="w-4 h-4 text-red-600" />;
      case 'Pending Adviser Approval':
      case 'Pending Approval':
      case 'Pending':
        return <Clock className="w-4 h-4 text-yellow-600" />;
      case 'Draft':
        return <AlertCircle className="w-4 h-4 text-gray-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Approved':
        return 'bg-green-100 text-green-700';
      case 'Rejected':
        return 'bg-red-100 text-red-700';
      case 'Pending Adviser Approval':
      case 'Pending Approval':
      case 'Pending':
        return 'bg-yellow-100 text-yellow-700';
      case 'Draft':
        return 'bg-gray-100 text-gray-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

 // Replace your current handleAddEntry with this:
const handleAddEntry = async () => {
  if (!ledgerForm.description || !ledgerForm.project_id) {
    showToast('Please fill in required fields', 'error');
    return;
  }

  // Check if amount is valid (either from budget breakdown or manual entry)
    const isAssetUsage = ledgerForm.type === 'Asset' && assetMode === 'use';
    const totalAmount = calculateTotalBudget();
    if (!isAssetUsage && totalAmount <= 0) {
    showToast('Please add at least one budget item with a valid amount', 'error');
    return;
  }

    if (!isAssetUsage && !selectedFile) {
    showToast('Please attach proof for this ledger entry', 'error');
    return;
  }

  try {
    // Get project ID directly from form
    const projectId = ledgerForm.project_id;
    
    if (!projectId) {
      showToast('Invalid project selected', 'error');
      return;
    }

setIsLoading(true);    

    // Prepare budget breakdown
    const budgetBreakdown = budgetItems.map(item => ({
      item: item.item,
      qty: item.qty,
      unitPrice: item.unitPrice,
      amount: item.amount || 0
    }));
    const submittedBudgetBreakdown = ledgerForm.type === 'Asset' && ['use', 'return'].includes(assetMode)
      ? assetUsages.map((usage) => ({ item: usage.asset_name || 'Asset', qty: Number(usage.quantity) || 0, quantity: Number(usage.quantity) || 0, unitPrice: 0, amount: 0 }))
      : budgetBreakdown.map((item) => ({
          ...item,
          asset_category: ledgerForm.type === 'Asset' && assetMode === 'purchase' ? (item.asset_category || 'Other') : undefined,
        }));

    // Create form data for file upload
    const formData = new FormData();
    formData.append('project_id', projectId);
    formData.append('type', ledgerForm.type);
    formData.append('amount', ledgerForm.type === 'Asset' && ['use', 'return'].includes(assetMode) ? '0' : totalAmount.toString());
    formData.append('description', ledgerForm.description);
    formData.append('approval_status', 'Draft');
    formData.append('asset_mode', assetMode);
    formData.append('asset_usages', JSON.stringify(assetUsages));
    formData.append('budget_breakdown', JSON.stringify(submittedBudgetBreakdown));
    
    formData.append('ledger_proof', selectedFile);

    // Make API call to store the ledger entry
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content || '';
    const response = await fetch('/api/ledger-entries', {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': csrfToken,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: formData,
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error('Validation errors:', errorData.errors || errorData);
      throw new Error(errorData.message || JSON.stringify(errorData.errors) || 'Failed to create ledger entry');
    }

    await response.json();
    
    // Refresh the ledger list so the newly created entry has complete details
    await fetchLedgerEntries();

    // Reset form
    setShowAddModal(false);
    setLedgerForm({
      type: 'Expense',
      amount: '',
      description: '',
      category: '',
      project_id: '',
      referenceNumber: '',
      requiresProof: true,
    });
    setBudgetItems([{ id: 1, item: '', qty: 1, asset_category: 'Furniture', unitPrice: '', amount: 0 }]);
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    
    showToast('Ledger entry added successfully', 'success');
    
  } catch (error) {
    console.error('Error adding ledger entry:', error);
    showToast(error.message || 'Failed to add ledger entry', 'error');
  } finally {
      setIsLoading(false);
    }
};

// Update handleEditEntry to use API
const handleEditEntry = async () => {
  if (!selectedEntry) return;

  if (!ledgerForm.description || !ledgerForm.project_id) {
    showToast('Please fill in required fields', 'error');
    return;
  }

  const totalAmount = calculateGrandTotal();

  if (totalAmount <= 0) {
    showToast('Please specify budget items with valid amounts', 'error');
    return;
  }

  setIsUploading(true);

  try {
    const formData = new FormData();
    formData.append('type', ledgerForm.type);
    formData.append('description', ledgerForm.description);
    formData.append('category', ledgerForm.category || '');
    formData.append('project_id', ledgerForm.project_id);
    formData.append('amount', totalAmount.toString());
    formData.append('budget_breakdown', JSON.stringify(editBudgetItems));
    if (selectedFile) {
      formData.append('ledger_proof', selectedFile);
    }

    formData.append('_method', 'PUT');

    const response = await fetch(`/api/ledger-entries/${selectedEntry.id}`, {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: formData,
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      console.error('Update error:', errorData);
      throw new Error(errorData.message || 'Failed to update ledger entry');
    }

    const updatedEntry = await response.json();

    await fetchLedgerEntries();
    setShowEditModal(false);
    setSelectedEntry(null);
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';

    showToast('Ledger entry updated successfully', 'success');
  } catch (error) {
    console.error('Error updating ledger entry:', error);
    showToast(error.message || 'Failed to update ledger entry', 'error');
  } finally {
    setIsUploading(false);
  }
};

//show notes if the entry is approved is approved
// const shouldshowNotes = (entry) => {entry.status === 'Approved'};

// Update handleDeleteEntry to use API
const handleDeleteEntry = async () => {
  if (!selectedEntry) return;

  try {
    const response = await fetch(`/api/ledger-entries/${selectedEntry.id}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    });

    if (!response.ok) {
      throw new Error('Failed to delete ledger entry');
    }

    // Remove the deleted entry from state immediately
    setLedgerEntries(ledgerEntries.filter(entry => entry.id !== selectedEntry.id));
    setShowDeleteModal(false);
    setSelectedEntry(null);
    showToast('Ledger entry archived successfully', 'success');
    
    // Refetch to ensure deleted entry doesn't reappear
    fetchLedgerEntries();
    
  } catch (error) {
    console.error('Error deleting ledger entry:', error);
    showToast('Failed to archive ledger entry', 'error');
  }
};

// Update handleSubmitForApproval to use API
const handleSubmitForApproval = async (id) => {
  try {
    const response = await fetch(`/api/ledger-entries/${id}/submit`, {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      console.error('Submit for approval error:', errorData);
      throw new Error(errorData.message || 'Failed to submit for approval');
    }

    const updatedEntry = await response.json();

    const updatedEntries = ledgerEntries.map(entry =>
      entry.id === id ? { ...entry, status: 'Pending Adviser Approval' } : entry
    );
    setLedgerEntries(updatedEntries);
    showToast('Ledger entry submitted for approval', 'success');
    
  } catch (error) {
    console.error('Error submitting for approval:', error);
    showToast(error.message || 'Failed to submit for approval', 'error');
  }
};

// Update handleSaveUpload to use API
const handleSaveUpload = async () => {
  if (!selectedEntry) return;

  try {
    const formData = new FormData();
    
    // Only add file if one was selected
    if (selectedFile) {
      formData.append('ledger_proof', selectedFile);
    } else {
      // If no file selected, show error or just close
      showToast('Please select a file to upload', 'error');
      return;
    }

    const response = await fetch(`/api/ledger-entries/${selectedEntry.id}/upload`, {
      method: 'POST',
      headers: {
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: formData,
    });

    if (!response.ok) {
      throw new Error('Failed to upload document');
    }

    const updatedEntry = await response.json();

    await fetchLedgerEntries();
    setShowUploadModal(false);
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    showToast('Document uploaded successfully', 'success');
    
  } catch (error) {
    console.error('Error uploading document:', error);
    showToast('Failed to upload document', 'error');
  }
};

  const handleFileUpload = (e) => {
    const file = e.target.files && e.target.files[0];
    if (!file) return;
    
    if (file.size > 2 * 1024 * 1024) {
      showToast('File size must be less than 2MB due to the lack of storage space', 'error');
      return;
    }

    setSelectedFile(file);
    setFilePreview({
      name: file.name,
      size: (file.size / (1024 * 1024)).toFixed(2) + ' MB',
      type: file.type,
    });
  };

  const calculateGrandTotal = () => {
    return editBudgetItems.reduce((sum, item) => {
      const qty = parseFloat(item.qty) || 0;
      const unitPrice = parseFloat(item.unitPrice) || 0;
      return sum + (qty * unitPrice);
    }, 0);
  };

  const addItem = () => {
    const newId = editBudgetItems.length > 0 ? Math.max(...editBudgetItems.map((item) => item.id)) + 1 : 1;
    setEditBudgetItems((prev) => [...prev, { id: newId, item: '', qty: 1, unitPrice: '', amount: 0 }]);
  };

  const removeItem = (id) => {
    if (editBudgetItems.length > 1) {
      setEditBudgetItems((prev) => prev.filter((item) => item.id !== id));
    }
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
    case 'Canvas': return ' text-gray-700';
    case 'Transfer': return 'text-yellow-700';
    default: return 'text-gray-700';
  }
};

  const updateItem = (id, field, value) => {
    setEditBudgetItems((prev) =>
      prev.map((item) => {
        if (item.id !== id) return item;
        const updated = { ...item, [field]: value };
        const qty = parseFloat(updated.qty) || 0;
        const unitPrice = parseFloat(updated.unitPrice) || 0;
        updated.amount = qty * unitPrice;
        return updated;
      })
    );
  };

  const handleEditClose = () => {
    setShowEditModal(false);
    setSelectedEntry(null);
    setFilePreview(null);
    setSelectedFile(null);
    setIsUploading(false);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  const totalIncome = ledgerEntries
    .filter(e => e.type === 'Income' && e.status === 'Approved')
    .reduce((sum, e) => sum + e.amount, 0);

  const totalExpenses = ledgerEntries
    .filter(e => e.type === 'Expense' && e.status === 'Approved')
    .reduce((sum, e) => sum + e.amount, 0);

  const currentBalance = totalIncome - totalExpenses;

  // Budget items state for the ledger entry
  const [budgetItems, setBudgetItems] = useState([
    { id: 1, item: '', qty: 1, asset_category: 'Furniture', unitPrice: '', amount: 0 }
  ]);

  // Calculate item total
  const calculateItemTotal = (item) => {
    if (item.qty && item.unitPrice) {
      const qty = parseFloat(item.qty) || 0;
      const unitPrice = parseFloat(item.unitPrice) || 0;
      return qty * unitPrice;
    }
    return parseFloat(item.amount) || 0;
  };

  // Calculate total budget from all items
  const calculateTotalBudget = () => {
    return budgetItems.reduce((sum, item) => sum + calculateItemTotal(item), 0);
  };

  // Add budget item
  const addBudgetItem = () => {
    const newId = budgetItems.length > 0 
      ? Math.max(...budgetItems.map(item => item.id)) + 1 
      : 1;
    setBudgetItems([...budgetItems, { 
      id: newId, 
      item: '', 
      qty: 1, 
      asset_category: 'Furniture',
      unitPrice: '', 
      amount: 0 
    }]);
  };

  // Remove budget item
  const removeBudgetItem = (id) => {
    if (budgetItems.length > 1) {
      setBudgetItems(budgetItems.filter(item => item.id !== id));
    }
  };

  // Update budget item
  const updateBudgetItem = (id, field, value) => {
    setBudgetItems(budgetItems.map(item => {
      if (item.id === id) {
        const updatedItem = { ...item, [field]: value };
        
        if (field === 'qty' || field === 'unitPrice') {
          const qty = field === 'qty' ? parseFloat(value) || 0 : parseFloat(item.qty) || 0;
          const unitPrice = field === 'unitPrice' ? parseFloat(value) || 0 : parseFloat(item.unitPrice) || 0;
          updatedItem.amount = qty * unitPrice;
        }
        
        return updatedItem;
      }
      return item;
    }));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
         <div>
        <div className="flex items-center gap-2">
          <h1 className="text-2xl font-semibold text-blue-600">CSG Officer Ledger Management</h1>
         
    {hasSecurityAlert ? (
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

         
          <p className="text-gray-500">Track all financial transactions across projects</p>
        </div>
        
      
          <div className="flex flex-col md:flex-row gap-2">

          {canCreateLedgers && (
            <Button
            onClick={() => setShowAddModal(true)}
            className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            disabled={allProjects.length === 0}
            title={allProjects.length === 0 ? 'No projects available. Create a project first.' : undefined}
          >
            <Plus className="w-4 h-4 mr-2" />
            Add Ledger Entry
          </Button>
          )}
          {canCreateLedgers && (
            <Button
              onClick={() => setShowBulkModal(true)}
              variant="outline"
              className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={allProjects.length === 0}
              title={allProjects.length === 0 ? 'No projects available. Create a project first.' : 'Upload a CSV of line items — grouped automatically into one entry per type'}
            >
              <Upload className="w-4 h-4 mr-2" />
              Bulk Upload (CSV)
            </Button>
          )}
          {canCreateLedgers && (
            <Button
              onClick={() => {
                fetchAssetInventory();
                setShowAssetsModal(true);
              }}
              variant="outline"
              className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
              disabled={allProjects.length === 0}
              title={allProjects.length === 0 ? 'No projects available. Create a project first.' : 'View all recorded assets and their stock status'}
            >
              <Folder className="w-4 h-4 mr-2" />Assets List
            </Button>
          )}
          </div>
        {/* </div> */}
      </div>

      {hasSecurityAlert && (
    <div className="mt-3 p-3 bg-red-50 border border-red-200 rounded-lg">
      <div className="flex items-start gap-2">
        <AlertCircle className="w-4 h-4 text-red-600 mt-0.5 flex-shrink-0" />
        <div>
          <p className="text-sm font-medium text-red-800">
            {hasTamperedEntries ? 'Security Alert.' : 'Budget Alert.'}
            <span className="text-xs text-red-600 ml-2">
              {integrityAlertMessage}
            </span>
          </p>
        </div>
      </div>
    </div>
  )}

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Average Income</p>
              <p className="text-2xl text-green-600 mt-1">₱{formatLimitedNumber(averageIncome || 0)}</p>
                             <p className="text-xs text-gray-500 mt-1">Income earned per project</p>
            </div>
            <div className="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </Card>

        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Average Expenses</p>
              <p className="text-2xl text-red-600 mt-1">₱{formatLimitedNumber(averageExpense || 0)}</p>
               <p className="text-xs text-gray-500 mt-1">Cost spent per project</p>
            </div>
            <div className="w-12 h-12 bg-red-50 rounded-xl flex items-center justify-center">
              <TrendingDown className="w-6 h-6 text-red-600" />
            </div>
          </div>
        </Card>

          <Card className={`rounded-[20px] border-0 shadow-sm p-6 ${isBudgetTampered ? 'bg-red-50' : 'bg-white'}`}>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Remaining Budget</p>
              <p className={`text-2xl mt-1 ${isBudgetTampered ? 'text-red-700' : 'text-blue-600'}`}>
                ₱{formatLimitedNumber(totalBudget || 0)}
              </p>
              <p className="text-xs text-gray-500 mt-1">
<span style={{ color: isBudgetTampered ? 'red' : '#2563eb'}}>
  {isBudgetTampered ? 'Mismatch detected' : 'Sum of budgets for projects'}
</span>              </p>
            </div>
            <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
              <Wallet className={`w-6 h-6 ${isBudgetTampered ? 'text-red-600' : 'text-blue-600'}`} />
            </div>
          </div>
        </Card>

        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Project Shortfall</p>
              <p className={`text-2xl mt-1 text-red-600`}>
                ₱{formatLimitedNumber(totalShortfall  || 0)}
              </p>
               <p className="text-xs text-gray-500 mt-1">Expenses exceed funds</p>
            </div>
            <div className="w-12 h-12 bg-red-50 rounded-xl flex items-center justify-center">
              <Wallet className="w-6 h-6 text-red-600" />
            </div>
          </div>
        </Card>

      </div>

      {/* Filters */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Search */}
          <div className="lg:col-span-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <Input
              placeholder="Search by Project Title..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 rounded-xl border border-gray-200 bg-white focus:ring-2 focus:ring-blue-200 focus:border-blue-300"
            />
          </div>

          {/* Type Filter */}
          <Select value={filterType} onChange={(e) => setFilterType(e.target.value)}>
            <option value="all" disabled>Select Type</option>
             <option value="all">All</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Asset">Asset</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
            <option value="Initial">Initial</option>
            <option value="Initial Transfer">Initial Transfer</option>
             <option value="Transfer">Transfer</option>
          </Select>

          {/* Status Filter */}
          <Select value={filterStatus} onChange={(e) => setFilterStatus(e.target.value)}>
            <option value="all" disabled>Select Status</option>
             <option value="all">All</option>
            <option value="Draft">Draft</option>
            <option value="Pending Adviser Approval">Pending</option>
            <option value="Approved">Approved</option>
            <option value="Rejected">Rejected</option>
          </Select>

          {/* Project Filter */}
          <Select value={filterProject} onChange={(e) => setFilterProject(e.target.value)}>
            <option value="all" disabled>Select Projects</option>
            {projects.map((p) => (
              <option key={p.id} value={p.title || p.name || p.id}>
                {p.title || p.name || p.id}
              </option>
            ))}
          </Select>
        </div>
      </Card>

      {/* Entries Count */}
     <div>
        <p className="text-sm text-gray-500">
          Showing {indexOfFirstItem + 1} to {Math.min(indexOfLastItem, filteredEntries.length)} of {filteredEntries.length} entries
        </p>
      </div>

      {/* Ledger Cards Grid - Fixed Layout  */}
       <div className="space-y-3">
        {currentItems.map((entry) => {
          // const entryLocked = isProjectLocked(entry.project_id);
          const isInitialEntry = ['initial', 'initial transfer'].includes((entry.type || '').toLowerCase()) || (entry.type || '').toLowerCase() === 'transfer';
         const entryLocked = isProjectLocked(entry.project_id) && !isInitialEntry;
          return (
         <div key={entry.id} className="relative">
         <Card className={`rounded-xl border-0 shadow-sm transition-all duration-200 overflow-x-auto ${
           entry.verificationState?.tampered ? 'ring-2 ring-red-200 bg-red-50' : ''
         } ${entryLocked ? 'opacity-70 pointer-events-none' : 'hover:shadow-md'}`}>
             <div className="p-4 min-w-0">
              {/* Tamper Alert Banner for individual entry */}
              {/* {entryLocked && (
                <div className="mb-3 p-2 bg-red-100 border border-red-200 rounded-lg">
                  <p className="text-xs font-medium text-red-700">
                    Locked: this entry belongs to a project with tampered ledger data.
                  </p>
                </div>
              )} */}


              {/* Fixed grid layout with consistent column widths */}
              <div className="grid grid-cols-[180px_120px_200px_140px_120px_auto] gap-4 items-center">
                {/* ID and Type Section */}
                <div className="flex items-center gap-3 min-w-0">
                  {/* <span className="truncate text-[11px] font-mono text-gray-500 bg-gray-100 px-2 py-0.5 rounded whitespace-nowrap">
                    {entry.id}
                  </span> */}
                  {/* <Badge className={`text-[11px] px-2 py-0.5 rounded-md whitespace-nowrap shrink-0 ${getTypeColor(entry.type)}`}>
                    {entry.type}
                  </Badge> */}

                   {/* Category Section */}
                <div className="flex flex-col min-w-0">
                  <p className="text-[10px] text-gray-400 uppercase tracking-wide mb-0.5">Project Title</p>
                  <p className="text-xs text-gray-700 font-medium truncate">{entry.projectName || '—'}</p>
                </div>
                </div>

                {/* Amount Section */}
               <div>
  <p className={`text-xl font-sm text-gray-900 whitespace-nowrap ${getTypeAmountColor(entry.type)}`}>
    ₱{formatLimitedNumber(entry.amount || 0, { minFractionDigits: 2, maxFractionDigits: 2 })}
  </p>
</div>

                
                <div>
                  <Badge className={`text-[11px] px-2 py-0.5 rounded-md whitespace-nowrap shrink-0 ${getTypeColor(entry.type)}`}>
                    {entry.type}
                  </Badge>
                </div>

                {/* Date Section */}
                <div>
                  <p className="text-[10px] text-gray-400 uppercase tracking-wide mb-0.5">Created At</p>
                  <p className="text-xs text-gray-700 whitespace-nowrap">{entry.createdAt}</p>
                </div>

                {/* Status Section */}
                <div className="flex items-center gap-1 min-w-0">
                  {getStatusIcon(entry.status)}
                  <Badge className={`text-[11px] px-2 py-0.5 rounded-md shrink-0 ${getStatusColor(entry.status)}`}>
                    {entry.status}
                  </Badge>
                </div>

                {/* Action Buttons */}
                <div className="hidden sm:flex flex-wrap gap-1 justify-end">
                  {canViewLedgers && (
                 <Button
  variant="ghost"
  size="sm"
  onClick={() => {
    setSelectedEntry(entry);
    setShowDetailsModal(true);
  }}
  className="h-7 text-xs rounded-md hover:bg-gray-100 px-2"
  title="View Details"
>
  <Eye className="w-3.5 h-3.5" /> 
</Button>
                  )}
                  
                  {(entry.status === 'Draft' || entry.status === 'Rejected') && !isInitialEntry && (
                    <>
                    
                     {isEditable(entry) && canEditLedgers && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setSelectedEntry(entry);
                          setLedgerForm({
                            type: entry.type,
                            amount: entry.amount,
                            description: entry.description,
                            category: entry.category || '',
                            project_id: entry.project_id,
                            referenceNumber: entry.referenceNumber || '',
                            requiresProof: entry.requiresProof || false,
                            existingProof: entry.ledger_proof || entry.proofFiles?.[0]?.url || entry.proofFiles?.[0]?.path || '',
                          });
                          setEditBudgetItems(entry.budgetBreakdown || [{ id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }]);
                          setShowEditModal(true);
                        }}
                        className="h-7 text-xs rounded-md hover:bg-gray-100 px-2 disabled:opacity-50 disabled:cursor-not-allowed"
                        disabled={entryLocked}
                      >
                        <Edit className="w-3.5 h-3.5 mr-1" /> 
                      </Button>
                      )}
                      
                      {canDeleteLedgers && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => {
                          setSelectedEntry(entry);
                          setShowDeleteModal(true);
                        }}
                        className="h-7 text-xs rounded-md text-red-600 hover:bg-red-50 px-2 disabled:opacity-50 disabled:cursor-not-allowed"
                        disabled={entryLocked}
                      >
                        <Trash2 className="w-3.5 h-3.5 mr-1" /> 
                      </Button>
                      )}
                      
                      {canSubmitLedgers && (
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => handleSubmitForApproval(entry.id)}
                        className="h-7 text-xs rounded-md hover:bg-gray-100 px-2 disabled:opacity-50 disabled:cursor-not-allowed"
                        disabled={entryLocked}
                      >
                        <Send className="w-3.5 h-3.5 mr-1" /> 
                      </Button>
                      )}
                    </>
                  )}
                </div>

              </div>
            </div>
          </Card>
          <details className="absolute right-2 top-2 z-30 sm:hidden">
            <summary className="flex h-8 w-8 cursor-pointer list-none items-center justify-center rounded-md bg-white text-gray-600 shadow-sm ring-1 ring-gray-200 hover:bg-gray-100 [&::-webkit-details-marker]:hidden">
              <span className="sr-only">Open ledger actions</span>
              <MoreVertical className="h-4 w-4" />
            </summary>
            <div className="absolute right-0 top-9 min-w-40 rounded-lg border border-gray-200 bg-white p-1 shadow-lg">
              {canViewLedgers && (
                <button type="button" onClick={() => { setSelectedEntry(entry); setShowDetailsModal(true); }} className="flex w-full items-center rounded-md px-3 py-2 text-left text-sm text-gray-700 hover:bg-gray-100">
                  <Eye className="mr-2 h-4 w-4" /> View details
                </button>
              )}
              {(entry.status === 'Draft' || entry.status === 'Rejected') && !isInitialEntry && (
                <>
                  {isEditable(entry) && canEditLedgers && (
                    <button type="button" onClick={() => {
                      setSelectedEntry(entry);
                            setLedgerForm({ type: entry.type, amount: entry.amount, description: entry.description, category: entry.category || '', project_id: entry.project_id, referenceNumber: entry.referenceNumber || '', requiresProof: entry.requiresProof || false, existingProof: entry.ledger_proof || entry.proofFiles?.[0]?.url || entry.proofFiles?.[0]?.path || '' });
                      setEditBudgetItems(entry.budgetBreakdown || [{ id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }]);
                      setShowEditModal(true);
                    }} disabled={entryLocked} className="flex w-full items-center rounded-md px-3 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50">
                      <Edit className="mr-2 h-4 w-4" /> Edit
                    </button>
                  )}
                  {canDeleteLedgers && (
                    <button type="button" onClick={() => { setSelectedEntry(entry); setShowDeleteModal(true); }} disabled={entryLocked} className="flex w-full items-center rounded-md px-3 py-2 text-left text-sm text-red-600 hover:bg-red-50 disabled:cursor-not-allowed disabled:opacity-50">
                      <Trash2 className="mr-2 h-4 w-4" /> Delete
                    </button>
                  )}
                  {canSubmitLedgers && (
                    <button type="button" onClick={() => handleSubmitForApproval(entry.id)} disabled={entryLocked} className="flex w-full items-center rounded-md px-3 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50">
                      <Send className="mr-2 h-4 w-4" /> Submit
                    </button>
                  )}
                </>
              )}
            </div>
          </details>
          </div>
          );
        })}
      </div>

      {filteredEntries.length === 0 && (
        <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
          <div className="text-center">
            <Wallet className="w-12 h-12 text-gray-300 mx-auto mb-3" />
             <p className="text-sm text-gray-500">No ledger entries found</p>
             <p className="text-xs text-gray-400 mt-1 mb-4">
              {searchQuery || filterStatus !== 'all'
                ? 'Try adjusting your search or filter criteria'
                : 'Add your first transaction to get started'}
            </p>
             {!searchQuery && filterStatus === 'all' && (
                          <Button
                            onClick={() => setShowAddModal(true)}
                             className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            disabled={allProjects.length === 0}
            title={allProjects.length === 0 ? 'No projects available. Create a project first.' : undefined}
                          >
                            <Plus className="w-4 h-4 mr-2" />
                            Add Ledger Entry
                          </Button>
                        )}
          </div>
        </Card>
      )}


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

      {/* Add Ledger Entry Modal */}
      <Modal
        open={showAddModal}
        onClose={() => {
          setShowAddModal(false);
          setFilePreview(null);
          setSelectedFile(null);
          if (fileInputRef.current) fileInputRef.current.value = '';
        }}
        title="Add Ledger Entry"
        description="Create a new financial transaction"
      >
        <div className="space-y-4 pt-6">
          <div>
            <FieldLabel>Type *</FieldLabel>
            <Select
              className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200"
              value={ledgerForm.type}
              onChange={(e) => setLedgerForm({ ...ledgerForm, type: e.target.value })}
            >
              <option value="">Select Type</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Asset">Asset</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
            </Select>
          </div>

          {ledgerForm.type === 'Asset' && (
            <AssetActionFields mode={assetMode} onModeChange={setAssetMode} usages={assetUsages} onUsagesChange={setAssetUsages} />
          )}

          {/* Project Selection */}
          <div>
            <FieldLabel>Project *</FieldLabel>
            <Select
              value={ledgerForm.project_id}
              onChange={(e) => setLedgerForm({ ...ledgerForm, project_id: e.target.value })}
              className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200"
            >
              <option value="">Select Project</option>
              {projects.filter((project) => !isProjectLocked(project.id)).map((project) => (
                <option key={project.id} value={project.id}>{project.title}</option>
              ))}
            </Select>
          </div>

          {/* Description */}
          <div>
            <FieldLabel>Description *</FieldLabel>
            <Textarea 
              placeholder="Enter transaction description" 
              value={ledgerForm.description} 
              onChange={(e) => setLedgerForm({ ...ledgerForm, description: e.target.value })} 
              rows={3} 
              className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white" 
            />
          </div>

          {/* Budget Breakdown Section */}
         {!(ledgerForm.type === 'Asset' && assetMode === 'use') && (
         <div className="grid grid-cols-1 gap-4">
            <div>
              <FieldLabel>Budget Breakdown (₱)</FieldLabel>
              <div className="space-y-3">
                {budgetItems.map((item) => (
                  <div
                    key={item.id}
                    className="flex flex-col gap-2 rounded-xl border border-gray-200 bg-gray-50 p-3 sm:border-0 sm:bg-transparent sm:p-0"
                  >
                    <Input
                      placeholder="Item name"
                      value={item.item}
                      onChange={(e) => updateBudgetItem(item.id, 'item', e.target.value)}
                      className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                    />

                    {ledgerForm.type === 'Asset' && assetMode === 'purchase' && (
                      <Select
                        value={item.asset_category || 'Other'}
                        onChange={(e) => updateBudgetItem(item.id, 'asset_category', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                      >
                        {ASSET_CATEGORIES.map((category) => (
                          <option key={category} value={category}>{category}</option>
                        ))}
                      </Select>
                    )}

                    <div className="grid grid-cols-[minmax(0,1fr)_minmax(0,1fr)_minmax(0,1.3fr)_auto] gap-2 sm:items-start">
                      <Input
                        type="number"
                        placeholder="Qty"
                        min="1"
                        value={item.qty}
                        onChange={(e) => updateBudgetItem(item.id, 'qty', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                      />
                      <Input
                        type="number"
                        placeholder="Unit Price"
                        min="0"
                        step="0.01"
                        value={item.unitPrice}
                        onChange={(e) => updateBudgetItem(item.id, 'unitPrice', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                      />
                      <div className="h-10 flex items-center justify-end px-3 bg-gray-100 rounded-xl text-gray-700 font-medium whitespace-nowrap">
                        ₱{formatLimitedNumber(item.amount || 0)}
                       </div>
                      {budgetItems.length > 1 && (
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          onClick={() => removeBudgetItem(item.id)}
                          className="h-10 w-10 rounded-lg p-0 text-red-600 hover:bg-red-50 shrink-0 self-start"
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      )}
                    </div>
                  </div>
                ))}
                <Button
                  type="button"
                  onClick={addBudgetItem}
                  variant="outline"
                  size="sm"
                  className="w-full rounded-xl"
                >
                  <Plus className="w-4 h-4 mr-2" />
                  Add Budget Item
                </Button>
              </div>
            </div>
            
            <div>
              <FieldLabel>Total Amount (₱)</FieldLabel>
              <div className="bg-blue-50 rounded-xl p-4 mt-1">
                <p className="text-3xl font-semibold text-blue-900">
                  ₱{formatLimitedNumber(calculateTotalBudget())}
                </p>
                <p className="text-xs text-blue-700 mt-1">
                  Auto-calculated from breakdown items
                </p>
              </div>
            </div>
          </div>
          )}

          {/* File Upload */}
          <div>
            <FieldLabel>Attach Proof Document (Required)</FieldLabel>
            <div className="flex flex-col items-center gap-3">
              <button 
                type="button" 
                className="w-full border-2 border-dashed border-gray-300 rounded-xl p-8 flex flex-col items-center justify-center hover:bg-gray-50 transition" 
                onClick={() => fileInputRef.current?.click()}
              >
                <Upload className="w-6 h-6 text-gray-500" />
                <p className="text-sm text-gray-600 mt-2">Click to upload</p>
                <p className="text-xs text-gray-500 mt-1">PDF, Images up to 2MB</p>
              </button>
              <input 
                ref={fileInputRef} 
                type="file" 
                accept=".pdf,.jpg,.jpeg,.png" 
                onChange={handleFileUpload} 
                className="hidden" 
              />
              {filePreview && (
                <div className="w-full p-4 bg-gray-50 rounded-xl flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <FileText className="w-5 h-5 text-blue-600" />
                    <div>
                      <p className="text-sm font-medium text-gray-900">{filePreview.name}</p>
                      <p className="text-xs text-gray-500">{filePreview.size}</p>
                    </div>
                  </div>
                  <Button 
                    variant="ghost" 
                    size="sm" 
                    onClick={() => { 
                      setFilePreview(null); 
                      setSelectedFile(null);
                      if (fileInputRef.current) fileInputRef.current.value = ''; 
                    }}
                  >
                    ✕
                  </Button>
                </div>
              )}
            </div>
          </div>

          {/* Buttons */}
          <div className="flex gap-3 pt-4 border-t">
            <Button 
              variant="outline" 
              onClick={() => {
                setShowAddModal(false);
                setFilePreview(null);
                setSelectedFile(null);
                if (fileInputRef.current) fileInputRef.current.value = '';
              }} 
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button 
              onClick={handleAddEntry} 
              className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
              disabled={!ledgerForm.description || !ledgerForm.project_id || !ledgerForm.type || isLoading}
            >
              {isLoading ? 'Adding...' : 'Save Entry'}
            </Button>
          </div>
        </div>
      </Modal>

      <Modal
        open={showAssetsModal}
        onClose={() => setShowAssetsModal(false)}
        title="Recorded Assets"
        description="Current asset inventory and available stock status"
      >
        <div className="space-y-4 pt-6">
          {assetInventory.length === 0 ? (
            <div className="rounded-xl border border-dashed border-gray-200 bg-gray-50 p-8 text-center text-sm text-gray-500">
              No recorded assets yet.
            </div>
          ) : (
            <div className="overflow-hidden rounded-xl border border-gray-200">
              <div className="overflow-x-auto">
                <table className="min-w-full text-left text-sm">
                  <thead className="bg-gray-50 text-gray-600">
                    <tr>
                      <th className="px-4 py-3 font-medium">Asset Name</th>
                      <th className="px-4 py-3 font-medium">Category</th>
                      <th className="px-4 py-3 font-medium">Quantity Available</th>
                      <th className="px-4 py-3 font-medium">Status</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200 bg-white">
                    {assetInventory.map((asset) => {
                      const statusText = asset.status || (Number(asset.available_quantity || 0) > 0 ? 'Available' : 'Unavailable');
                      const isAvailable = statusText.toLowerCase() === 'available';

                      return (
                        <tr key={asset.id} className="align-middle">
                          <td className="px-4 py-3 font-medium text-gray-900">{asset.name}</td>
                          <td className="px-4 py-3 text-gray-700">{asset.asset_category || 'Other'}</td>
                          <td className="px-4 py-3 text-gray-700">{Number(asset.available_quantity || 0)}</td>
                          <td className="px-4 py-3">
                            <span className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${
                              isAvailable ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
                            }`}>
                              {statusText}
                            </span>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          <div className="flex justify-end pt-2">
            <Button variant="outline" onClick={() => setShowAssetsModal(false)} className="rounded-xl">
              Close
            </Button>
          </div>
        </div>
      </Modal>

      {/* Bulk Upload (CSV) Modal */}
      <Modal
        open={showBulkModal}
        onClose={handleCloseBulkModal}
        title="Bulk Upload Ledger Entries (CSV)"
        description="Upload a CSV of line items. Rows are grouped by their type column — all Income rows become one Income entry, all Expense rows become one Expense entry, and so on."
      >
        <div className="space-y-4">
          {/* Project Selection */}
          <div>
            <FieldLabel>Project *</FieldLabel>
            <Select
              value={bulkProjectId}
              onChange={(e) => { setBulkProjectId(e.target.value); setBulkPreview(null); }}
              className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200"
            >
              <option value="">Select Project</option>
              {projects.filter((project) => !isProjectLocked(project.id)).map((project) => (
                <option key={project.id} value={project.id}>{project.title}</option>
              ))}
            </Select>
          </div>

          {/* CSV format help + template download */}
          <div className="rounded-xl bg-gray-50 p-3 text-xs text-gray-600 space-y-1">
            <p>Required columns: <code>type</code>, <code>item</code>, <code>unit_price</code>. Optional: <code>qty</code> (defaults to 1), <code>description</code>.</p>
            <p><code>type</code> must be one of: Income, Expense, Donation, Sponsorship, Canvas.</p>
            <button
              type="button"
              onClick={downloadBulkCsvTemplate}
              className="text-blue-600 hover:underline font-medium"
            >
              
                <div className='flex'>
                  <Download className="w-4 h-4 mr-2" /> Download a sample CSV template
                </div>
            </button>
          </div>

          {/* CSV File */}
          <div>
            <FieldLabel>CSV File *</FieldLabel>
            <button
              type="button"
              className="w-full border-2 border-dashed border-gray-300 rounded-xl p-6 flex flex-col items-center justify-center hover:bg-gray-50 transition"
              onClick={() => bulkCsvInputRef.current?.click()}
            >
              <Upload className="w-6 h-6 text-gray-500" />
              <p className="text-sm text-gray-600 mt-2">{bulkCsvFile ? bulkCsvFile.name : 'Click to choose a .csv file'}</p>
            </button>
            <input
              ref={bulkCsvInputRef}
              type="file"
              accept=".csv,text/csv"
              onChange={handleBulkCsvSelect}
              className="hidden"
            />
          </div>

          {/* Preview button */}
          <Button
            type="button"
            variant="outline"
            className="w-full rounded-xl border-blue-200 text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed"
            onClick={handleBulkPreviewClick}
            disabled={!bulkProjectId || !bulkCsvFile || isBulkPreviewing}
          >
            {isBulkPreviewing ? 'Reading CSV...' : 'Preview Grouped Entries'}
          </Button>

          {/* Preview results */}
          {bulkPreview && (
            <div className="space-y-3">
              <div className="rounded-xl bg-blue-50 p-4">
                <p className="text-sm font-medium text-blue-900">
                  {bulkPreview.entries_to_create} ledger entry(ies) will be created from {bulkPreview.row_count} row(s)
                </p>
              </div>

              {bulkPreview.preview?.map((group) => (
                <div key={group.type} className="rounded-xl border border-gray-200 p-3">
                  <div className="flex items-center justify-between">
                    <Badge className={'bg-gray-100 text-gray-700 rounded-lg ' + getTypeColor(group.type)}>{group.type}</Badge>
                    <span className="text-sm font-semibold text-gray-900">
                      ₱{Number(group.amount || 0).toLocaleString()} · {group.item_count} item(s)
                    </span>
                  </div>
                  <ul className="mt-2 text-xs text-gray-600 space-y-0.5 max-h-24 overflow-y-auto">
                    {group.items.map((it) => (
                      <li key={it.id}>
                        {it.item} — {it.qty} × ₱{Number(it.unitPrice).toLocaleString()} = ₱{Number(it.amount).toLocaleString()}
                      </li>
                    ))}
                  </ul>
                </div>
              ))}

              {bulkPreview.errors?.length > 0 && (
                <div className="rounded-xl bg-amber-50 p-3">
                  <p className="text-xs font-medium text-amber-800 mb-1">
                    {bulkPreview.errors.length} row(s) were skipped:
                  </p>
                  <ul className="text-xs text-amber-700 space-y-0.5 max-h-20 overflow-y-auto">
                    {bulkPreview.errors.map((e, i) => (
                      <li key={i}>Row {e.row}: {e.reason}</li>
                    ))}
                  </ul>
                </div>
              )}

              {/* Optional shared proof */}
              <div>
                <FieldLabel>Attach Supporting Document (optional)</FieldLabel>
                <button
                  type="button"
                  className="w-full border-2 border-dashed border-gray-300 rounded-xl p-4 flex flex-col items-center justify-center hover:bg-gray-50 transition"
                  onClick={() => bulkProofInputRef.current?.click()}
                >
                  <FileText className="w-5 h-5 text-gray-500" />
                  <p className="text-xs text-gray-600 mt-1">{bulkProofFile ? bulkProofFile.name : 'One document attached to every entry created (e.g. a scanned receipt bundle)'}</p>
                </button>
                <input
                  ref={bulkProofInputRef}
                  type="file"
                  accept=".pdf,.jpg,.jpeg,.png"
                  onChange={handleBulkProofSelect}
                  className="hidden"
                />
              </div>
            </div>
          )}

          {/* Actions */}
          <div className="flex gap-3 pt-4 border-t">
            <Button variant="outline" onClick={handleCloseBulkModal} className="flex-1 rounded-xl" disabled={isBulkUploading}>
              Cancel
            </Button>
            <Button
              onClick={handleBulkSubmit}
              className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
              disabled={!bulkPreview || bulkPreview.entries_to_create === 0 || isBulkUploading}
            >
              {isBulkUploading ? 'Creating entries...' : `Create ${bulkPreview?.entries_to_create || ''} Entries`}
            </Button>
          </div>
        </div>
      </Modal>

      {/* Edit Modal */}
      <Modal open={showEditModal} onClose={handleEditClose} title="Edit Ledger Entry" description="Update transaction information">
        <div className="space-y-4">
          <div>
            <FieldLabel>Type</FieldLabel>
            <Select
              value={ledgerForm.type}
              onChange={(e) => setLedgerForm({ ...ledgerForm, type: e.target.value })}
            >
              <option value="">Select Type</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
            </Select>
          </div>

          <div>
            <FieldLabel>Project</FieldLabel>
            <Select
              value={ledgerForm.project_id || ''}
              onChange={(e) => setLedgerForm({ ...ledgerForm, project_id: e.target.value })}
            >
              <option value="">Select Project</option>
              {projects.filter((project) => !isProjectLocked(project.id)).map((project) => (
                <option key={project.id} value={project.id}>{project.title}</option>
              ))}
            </Select>
          </div>

          <div>
            <FieldLabel>Description</FieldLabel>
            <Textarea
              value={ledgerForm.description}
              onChange={(e) => setLedgerForm({ ...ledgerForm, description: e.target.value })}
              rows={3}
              className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>

                 <div className="space-y-4">
                          <FieldLabel>Budget Breakdown (₱)</FieldLabel>
                          <div className="space-y-4">
                            {editBudgetItems.map((item) => (
                              <div key={item.id} className="flex gap-2 items-start">
                                <Input
                                  placeholder="Item name"
                                  value={item.item}
                                  onChange={(e) => updateItem(item.id, 'item', e.target.value)}
                                  className="flex-1 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                                />
                                <Input
                                  type="number"
                                  placeholder="Qty"
                                  min="1"
                                  value={item.qty}
                                  onChange={(e) => updateItem(item.id, 'qty', e.target.value)}
                                  className="w-20 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                                />
                                <Input
                                  type="number"
                                  placeholder="Unit Price"
                                  min="0"
                                  step="0.01"
                                  value={item.unitPrice}
                                  onChange={(e) => updateItem(item.id, 'unitPrice', e.target.value)}
                                  className="w-28 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                                />
                                <div className="w-28 h-10 flex items-center justify-end px-3 bg-gray-100 rounded-xl text-gray-700 font-medium">
                                  ₱{formatLimitedNumber(item.amount || 0)}
                                </div>
                                {editBudgetItems.length > 1 && (
                                  <Button 
                                    type="button" 
                                    variant="ghost" 
                                    size="sm" 
                                    onClick={() => removeItem(item.id)} 
                                    className="rounded-lg text-red-600 hover:bg-red-50"
                                  >
                                    <Trash2 className="w-4 h-4" />
                                  </Button>
                                )}
                              </div>
                            ))}
                            
                            <Button 
                              type="button" 
                              onClick={addItem} 
                              variant="outline" 
                              size="sm" 
                              className="w-full rounded-xl"
                            >
                              <Plus className="w-4 h-4 mr-2" />
                              Add Budget Item
                            </Button>
                          </div>
                
                          <div>
                            <FieldLabel>Total Budget (₱)</FieldLabel>
                            <div className="bg-blue-50 rounded-xl p-4">
                              <p className="text-3xl font-semibold text-blue-900">
                                ₱{formatLimitedNumber(calculateGrandTotal())}
                              </p>
                              <p className="text-xs text-blue-700 mt-1">
                                Auto-calculated from (Quantity × Unit Price)
                              </p>
                            </div>
                          </div>
                
                          <div>
                            <FieldLabel>Ledger Proof Document (Required)</FieldLabel>
                            <div className="flex flex-col items-center gap-3">
                              <button
                                type="button"
                                className="w-full border-2 border-dashed border-gray-300 rounded-xl p-8 flex flex-col items-center justify-center hover:bg-gray-50 transition"
                                onClick={() => fileInputRef.current?.click()}
                              >
                                <Upload className="w-6 h-6 text-gray-500" />
                                <p className="text-sm text-gray-600 mt-2">Click to upload new file</p>
                                <p className="text-xs text-gray-500 mt-1">PDF, Images up to 2MB</p>
                              </button>
                              <input 
                                ref={fileInputRef} 
                                type="file" 
                                accept=".pdf,.jpg,.jpeg,.png" 
                                onChange={handleFileUpload} 
                                className="hidden" 
                              />
                              {filePreview && (
                                <div className="w-full p-4 bg-gray-50 rounded-xl flex items-center justify-between">
                                  <div className="flex items-center gap-3">
                                    <FileText className="w-5 h-5 text-blue-600" />
                                    <div>
                                      <p className="text-sm font-medium text-gray-900">{filePreview.name}</p>
                                      <p className="text-xs text-gray-500">{filePreview.size}</p>
                                    </div>
                                  </div>
                                  <Button 
                                    variant="ghost" 
                                    size="sm" 
                                    onClick={() => { 
                                      setFilePreview(null); 
                                      setSelectedFile(null);
                                      if (fileInputRef.current) fileInputRef.current.value = ''; 
                                    }}
                                  >
                                    <X className="w-4 h-4" />
                                  </Button>
                                </div>
                              )}
                              {ledgerForm.existingProof && !selectedFile && (
                                <div className="w-full rounded-xl border border-blue-200 bg-blue-50 p-3">
                                  {(() => {
                                    const { url, fileName, extension } = proofDetails(ledgerForm.existingProof);
                                    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];

                                    if (imageExtensions.includes(extension)) {
                                      return (
                                        <div>
                                          <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof: </p>
                                          <img src={url} alt="Current ledger proof" className="max-h-64 w-full rounded-lg object-contain" />
                                        </div>
                                      );
                                    }

                                    if (extension === 'pdf') {
                                      return (
                                        <div>
                                          <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof: </p>
                                          <iframe src={url} title="Current ledger proof" className="h-64 w-full rounded-lg border-0" />
                                        </div>
                                      );
                                    }

                                    return (
                                      <div className="flex items-center gap-3">
                                        <FileText className="h-5 w-5 flex-shrink-0 text-green-600" />
                                        <a href={url} target="_blank" rel="noreferrer" className="truncate text-sm text-blue-600 underline">
                                          
                                        </a>
                                      </div>
                                    );
                                  })()}
                                </div>
                              )}
                            </div>
                          </div>
                        </div>

                        <div className="flex gap-3 pt-4 border-t mt-4">
                          <Button variant="outline" onClick={handleEditClose} className="flex-1 rounded-xl" disabled={isUploading}>
                            Cancel
                          </Button>
                          <Button
                            onClick={handleEditEntry}
                            className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
                            disabled={isUploading}
                          >
                            {isUploading ? 'Saving...' : 'Save Changes'}
                          </Button>
                        </div>
        </div>
      </Modal>

{/* Details Modal */}
<Modal 
  open={showDetailsModal} 
  onClose={() => { 
    setShowDetailsModal(false); 
    setSelectedEntry(null); 
  }} 
  title="Ledger Entry Details"
>
  {selectedEntry && (
    <div className="space-y-4 pt-6">
      <div className="grid grid-cols-2 gap-4">
        <div>
          <p className="text-sm text-gray-500 mb-1">Project Title *</p>
          <p className="font-semibold text-sm text-blue-700 break-all">{selectedEntry.project}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Type *</p>
          <Badge className={`rounded-lg ${selectedEntry.type === 'Income' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
            {selectedEntry.type}
          </Badge>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Total Amount *</p>
          <p className="text-xl font-semibold text-blue-600">₱{formatLimitedNumber(selectedEntry?.amount || 0)}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Status *</p>
          <div className="flex items-center gap-1">
            {getStatusIcon(selectedEntry.status)}
            <Badge className={`rounded-lg ${getStatusColor(selectedEntry.status)}`}>
              {selectedEntry.status}
            </Badge>
          </div>
        </div>
        {/* <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Project Title *</p>
          <p className="text-gray-900">{selectedEntry.project}</p>
        </div> */}
        <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Description *</p>
          <p className="text-gray-900">{selectedEntry.description}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Created By *</p>
          <p className="text-sm text-gray-900">{selectedEntry.createdBy || 'N/A'}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Created At *</p>
          <p className="text-sm text-gray-900">{selectedEntry.createdAt}</p>
        </div>
        
      <div className="col-span-2">
  <p className="text-sm text-gray-500 mb-1">Budget Breakdown Details *</p>
  {selectedEntry.budgetBreakdown && selectedEntry.budgetBreakdown.length > 0 ? (
    <div className="bg-gray-50 rounded-lg p-3 mt-1">
      {/* Header */}
      <div className="flex justify-between items-center pb-2 mb-2 border-b border-gray-300">
        <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Item (Unit Price x Quantity)</span>
        <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Amount</span>
      </div>
      
      {/* Items */}
      <div className="space-y-1">
        {selectedEntry.budgetBreakdown.map((item, index) => (
          <div key={item.id || index} className="flex justify-between items-center py-1">
            <div className="flex-1">
              <span className="text-sm text-gray-900">{item.item || item.name || 'Unnamed Item'}</span>
              {(item.quantity || item.qty) && (
                <span className="text-xs text-gray-500 ml-2">
                  (₱{formatLimitedNumber(parseFloat(item.unitPrice) || 0)} x {item.quantity || item.qty})
                </span>
              )}
            </div>
            <span className="text-sm font-medium text-blue-600">
              ₱{formatLimitedNumber(parseFloat(item.amount) || 0)}
            </span>
          </div>
        ))}
      </div>
      
      {/* Total */}
      <div className="flex justify-between pt-2 mt-2 border-t border-gray-300 font-semibold">
        <span className="text-gray-700">Total</span>
        <span className="text-blue-600">
          ₱{formatLimitedNumber(selectedEntry.budgetBreakdown.reduce((sum, item) => sum + (parseFloat(item.amount) || 0), 0))}
        </span>
      </div>
    </div>
  ) : (
    <p className="text-gray-500 mt-1">No budget breakdown available for this transaction.</p>
  )}
</div>

        <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Proof *</p>
          {selectedEntry.ledger_proof ? (
            <div className="w-full rounded-xl border border-blue-200 bg-blue-50 p-3">
              {(() => {
                const { url, fileName, extension } = proofDetails(selectedEntry.ledger_proof);
                const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];

                if (imageExtensions.includes(extension)) {
                  return (
                    <div>
                      <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof:</p>
                      <img src={url} alt="Current ledger proof" className="max-h-64 w-full rounded-lg object-contain" />
                    </div>
                  );
                }

                if (extension === 'pdf') {
                  return (
                    <div>
                      <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof: </p>
                      <iframe src={url} title="Current ledger proof" className="h-64 w-full rounded-lg border-0" />
                    </div>
                  );
                }

                return (
                  <div className="flex items-center gap-3">
                    <FileText className="h-5 w-5 flex-shrink-0 text-green-600" />
                    <a href={url} target="_blank" rel="noreferrer" className="truncate text-sm text-blue-600 underline">
                      
                    </a>
                  </div>
                );
              })()}
            </div>
          ) : (
            <div className="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
              <FileText className="w-5 h-5 text-yellow-600 flex-shrink-0" />
              <p className="text-yellow-700 text-sm flex-1">No proof document provided</p>
            </div>
          )}
        </div>

      
      {/* notes */}
                <div className="col-span-2">
                  <p className="text-sm text-gray-500 mb-1">
                    {selectedEntry.approval_status === 'Rejected' ? 'Rejection Notes *' : 'Approver Notes *'}
                  </p>
                  <div className={`rounded-lg p-4 ${
                    selectedEntry.approval_status === 'Rejected' ? 'bg-red-50' : 'bg-blue-50'
                  }`}>
                    <p className={`text-sm ${
                      selectedEntry.approval_status === 'Rejected' ? 'text-red-900' : 'text-blue-900'
                    }`}>
                      {selectedEntry.note || (selectedEntry.approval_status === 'Rejected' 
                        ? 'No rejection reason provided.' 
                        : 'No notes available.')}
                    </p>
                    <p className={`text-xs mt-2 ${
                      selectedEntry.approval_status === 'Rejected' ? 'text-red-600' : 'text-blue-600'
                    }`}>
                      - {selectedEntry.approved_by || 'Not assigned'}
                    </p>
                    <p className={`text-xs mt-1 ${
                      selectedEntry.approval_status === 'Rejected' ? 'text-red-600' : 'text-blue-600'
                    }`}>
                      - {selectedEntry.approved_at ? `Approved on ${new Date(selectedEntry.approved_at).toLocaleDateString()}` : 'Not yet approved'}
                    </p>
                  </div>
                </div>
            


        {/* Chain Verification Status */}
        {/* <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Blockchain Verification *</p>
          <div className={`rounded-lg p-4 ${
            selectedEntry.verificationState?.tampered ? 'bg-red-50 border border-red-200' :
            selectedEntry.verificationState?.blockchainValid ? 'bg-green-50 border border-green-200' :
            'bg-yellow-50 border border-yellow-200'
          }`}>
            <div className="flex items-center gap-2 mb-2">
              {selectedEntry.verificationState?.tampered ? (
                <AlertCircle className="w-5 h-5 text-red-600" />
              ) : selectedEntry.verificationState?.blockchainValid && (selectedEntry.approval_status === 'Approved' || selectedEntry.status === 'Approved') ? (
                <Shield className="w-5 h-5 text-green-600" />
              ) : (
                <Clock className="w-5 h-5 text-yellow-600" />
              )}
              <span className={`text-sm font-medium ${
                selectedEntry.verificationState?.tampered ? 'text-red-800' :
                selectedEntry.verificationState?.blockchainValid && (selectedEntry.approval_status === 'Approved' || selectedEntry.status === 'Approved') ? 'text-green-800' :
                'text-yellow-800'
              }`}>
                {selectedEntry.verificationState?.tampered ? 'TAMPERED - Integrity Compromised' :
                 selectedEntry.verificationState?.blockchainValid && (selectedEntry.approval_status === 'Approved' || selectedEntry.status === 'Approved') ? 'Verified' :
                 'Unverified - Pending'}
              </span>
            </div>
            {selectedEntry.verificationState?.tampered && (
              <div className="text-sm text-red-700">
                 <p className="text-sm font-medium text-red-800">Security Alert. 
                  <span className="text-xs text-red-600 mt-2 ml-2">
                     A Ledger Entry has been Tampered. Please review the affected entries and contact system administrators immediately.
                  </span>
                </p>
              </div>
            )}
            <div className="text-xs text-gray-600 mt-2 space-y-1">
              <p><strong>Status:</strong> {selectedEntry.verificationState?.blockchainStatus || 'Unknown'}</p>
              <p><strong>Submitted:</strong> {selectedEntry.verificationState?.submitted || 'N/A'}</p>
              <p><strong>Reviewed:</strong> {selectedEntry.verificationState?.reviewed || 'N/A'}</p>
              {selectedEntry.verificationState?.corrected && (
                <p><strong>Corrected:</strong> {selectedEntry.verificationState.corrected}</p>
              )}
            </div>
          </div>
        </div> */}

        {/* Documents Section */}
        {selectedEntry.documents && selectedEntry.documents.length > 0 && (
          <div className="col-span-2">
            <p className="text-sm text-gray-500 mb-1">Attached Documents</p>
            <div className="space-y-2">
              {selectedEntry.documents.map((doc, index) => (
                <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center gap-3">
                    <FileText className="w-4 h-4 text-blue-600" />
                    <div>
                      <p className="text-sm text-gray-900">{doc.name}</p>
                      <p className="text-xs text-gray-500">{doc.size}</p>
                    </div>
                  </div>
                  <Button variant="ghost" size="sm" className="rounded-lg">
                    <Download className="w-4 h-4" />
                  </Button>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
      
      <Button onClick={() => setShowDetailsModal(false)} className="w-full rounded-xl" variant="outline">
        Close
      </Button>
    </div>
  )}
</Modal>

      {/* Delete Confirmation Modal */}
      <Modal
        open={showDeleteModal}
        onClose={() => {
          setShowDeleteModal(false);
          setSelectedEntry(null);
        }}
        title="Delete Ledger Entry"
        description="Are you sure you want to delete this transaction? This action cannot be undone."
      >
        <div className="pt-6">
          <p className="text-sm text-gray-600 mb-6">
            Transaction: <span className="font-medium">{selectedEntry?.id} - {selectedEntry?.description}</span>
          </p>
          <div className="flex gap-3">
            <Button
              variant="outline"
              onClick={() => setShowDeleteModal(false)}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleDeleteEntry}
              className="flex-1 rounded-xl bg-red-600 hover:bg-red-700 text-white"
            >
              Archive Entry
            </Button>
          </div>
        </div>
      </Modal>

       {/* Modal for Ledger Proof Document Viewer */}
            <Modal open={showLedgerProofViewer} onClose={() => { setShowLedgerProofViewer(false); }} title="Proof Document">
              {selectedEntry?.ledger_proof && (
                <div className="space-y-4 pt-6">
                  <div className="bg-gray-100 rounded-xl p-6 flex flex-col items-center justify-center min-h-96 max-h-96 overflow-auto">
                    {(() => {
                      const { url: proofUrl, extension: fileExtension } = proofDetails(selectedEntry.ledger_proof);
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
                              {proofDetails(selectedEntry.ledger_proof).fileName}
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
                        const { url: proofUrl } = proofDetails(selectedEntry.ledger_proof);
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

      {/* Upload Document Modal */}
      <Modal
        open={showUploadModal}
        onClose={() => {
          setShowUploadModal(false);
          setFilePreview(null);
          setSelectedFile(null);
          if (fileInputRef.current) fileInputRef.current.value = '';
        }}
        title="Upload Document"
        description="Upload proof of transaction"
      >
        <div className="space-y-4 pt-6">
          <div className="flex flex-col items-center gap-3">
            <button
              type="button"
              className="w-full border-2 border-dashed border-gray-300 rounded-xl p-10 flex flex-col items-center justify-center hover:bg-gray-50 transition"
              onClick={() => fileInputRef.current && fileInputRef.current.click()}
            >
              <Upload className="w-6 h-6 text-gray-500" />
              <p className="text-sm text-gray-600 mt-2">Click to upload</p>
              <p className="text-xs text-gray-500 mt-1">PDF, Images up to 2MB</p>
            </button>

            <input
              ref={fileInputRef}
              type="file"
              accept=".pdf,.jpg,.jpeg,.png"
              onChange={handleFileUpload}
              className="hidden"
            />

            {filePreview && (
              <div className="w-full p-4 bg-gray-50 rounded-xl">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <FileText className="w-5 h-5 text-blue-600" />
                    <div>
                      <p className="text-sm font-medium text-gray-900">{filePreview.name}</p>
                      <p className="text-xs text-gray-500">{filePreview.size}</p>
                    </div>
                  </div>
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={() => {
                      setFilePreview(null);
                      setSelectedFile(null);
                      if (fileInputRef.current) fileInputRef.current.value = '';
                    }}
                  >
                    ✕
                  </Button>
                </div>
              </div>
            )}
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => {
                setShowUploadModal(false);
                setFilePreview(null);
                setSelectedFile(null);
                if (fileInputRef.current) fileInputRef.current.value = '';
              }}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSaveUpload}
              disabled={!filePreview}
              className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
            >
              Upload Document
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default function LedgerPage() {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">CSG Ledger</h2>}>
      <Head title="CSG Ledger" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <LedgerPageInner />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}