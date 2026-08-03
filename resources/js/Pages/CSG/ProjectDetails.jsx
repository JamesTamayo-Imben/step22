import React, { useState, useEffect } from 'react';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
import {
  ArrowLeft,
  Wallet,
  FileText,
  CheckCircle,
  Download,
  Eye,
  Hash,
  Shield,
  Star,
  Calendar,
  Clock,
  Edit,
  Trash2,
  Send,
  AlertCircle,
  Plus,
  Upload,
  FolderKanban,
  ChevronLeft,
  ChevronRight,
  ExternalLink,
} from 'lucide-react';

import {
  showToast,
  Modal,
  SubmitConfirmModal,
  SubmitLedgerConfirmModal,
  DeleteConfirmModal,
  UploadProofModal,
  EditActionButtons,
} from './ProjectEdit';

function formatLimitedNumber(value, opts = {}) {
  const { minFractionDigits = 0, maxFractionDigits = 2 } = opts;
  const n = Number(value) || 0;
  const abs = Math.abs(n);
  if (abs >= 1000000) {
    return (n / 1000000).toLocaleString('en-US', { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits }) + 'M';
  }
  return n.toLocaleString('en-US', { minimumFractionDigits: minFractionDigits, maximumFractionDigits: maxFractionDigits });
}

function renderStars(value) {
  const stars = Math.max(0, Math.min(5, Math.round(Number(value) || 0)));
  return [...Array(5)].map((_, i) => (
    <Star key={i} className={`w-3 h-3 ${i < stars ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
  ));
}

function getMinimumStartDate() {
  const today = new Date();
  const nextMonth = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 21);
  return nextMonth.toISOString().split('T')[0];
}

function getMinimumEndDate(startDate) {
  if (!startDate) return null;
  const start = new Date(startDate);
  const minEndDate = new Date(start.getFullYear(), start.getMonth(), start.getDate() + 1);
  return minEndDate.toISOString().split('T')[0];
}

import {
  EditProjectModal,
  AddLedgerModal,
  EditLedgerModal,
} from './modal';

// ─── Default project structure ────────────────────────────────────────────────────
const defaultProject = {
  id: null,
  title: 'Loading...',
  category: '',
  description: '',
  objective: '',
  venue: '',
  status: 'Draft',
  approvalStatus: 'Draft',
  progress: 0,
  budget: 0,
  budgetBreakdown: [],
  startDate: '',
  endDate: '',
  createdAt: '',
  proposedBy: '',
  note: '',
  approveBy: '',
  createdBy: '',
  archive: 0,
  approvedAt: null,
  is_initial: 0,
};

// ─── Mock Data for Status Timeline and Ratings ────────────────────────────────────
const mockStatusHistory = [
  { 
    id: 1, 
    label: 'Draft Created', 
    date: '2024-10-25', 
    description: 'Project draft created and initial details added.', 
    isDone: true,
    isCurrent: false
  },
  { 
    id: 2, 
    label: 'Submitted for Approval', 
    date: '2024-10-28', 
    description: 'Project submitted to adviser for review and approval.', 
    isDone: true,
    isCurrent: false
  },
  { 
    id: 3, 
    label: 'Approved', 
    date: '2024-10-30', 
    description: 'Project approved. Ready for execution.', 
    isDone: true,
    isCurrent: false
  },
  { 
    id: 4, 
    label: 'Execution Started', 
    date: '2024-11-01', 
    description: 'Project execution phase started. Budget allocated.', 
    isDone: true,
    isCurrent: true
  },
];

// const mockRatings = [
//   { 
//     id: 1, 
//     user_name: 'Emma Johnson', 
//     rating: 5, 
//     comment: 'Amazing initiative! The workshops were very helpful.', 
//     created_at: '2024-11-20' 
//   },
//   { 
//     id: 2, 
//     user_name: 'James Smith', 
//     rating: 5, 
//     comment: 'This project has made a real impact in our community.', 
//     created_at: '2024-11-19' 
//   },
//   { 
//     id: 3, 
//     user_name: 'Sofia Martinez', 
//     rating: 4, 
//     comment: 'Very good project with clear objectives. Would love to see more events like this.', 
//     created_at: '2024-11-18' 
//   },
//   { 
//     id: 4, 
//     user_name: 'Michael Chen', 
//     rating: 5, 
//     comment: 'Well organized and executed. Great job to the team!', 
//     created_at: '2024-11-17' 
//   },
//   { 
//     id: 5, 
//     user_name: 'Lisa Rodriguez', 
//     rating: 4, 
//     comment: 'Good project overall. The materials provided were very useful.', 
//     created_at: '2024-11-16' 
//   },
// ];

// ─── Status / color helpers ──────────────────────────────────────────────────

// Calculate project status based on approval status and dates
const getCalculatedStatus = (project) => {
  // If not approved yet, show as Draft
  if (project.approvalStatus !== 'Approved' && project.approvalStatus !== 'Approved') {
    return 'Draft';
  }
  
  // If approved, calculate status based on dates
  if (!project.startDate && !project.endDate) {
    return 'Draft';
  }
  
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const startDate = new Date(project.startDate);
    const endDate = new Date(project.endDate);
    startDate.setHours(0, 0, 0, 0);
    endDate.setHours(0, 0, 0, 0);
    
    // Check if dates are valid
    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      return 'Draft';
    }
    
    if (today < startDate) {
      return 'Upcoming';
    } else if (today > endDate) {
      return 'Completed';
    } else if (today >= startDate && today <= endDate) {
      return 'Ongoing';
    }
    
    return 'Draft';
  } catch (error) {
    console.error('Error calculating status:', error);
    return 'Draft';
  }
};

const getStatusColor = (status) => {
  switch (status) {
    case 'Draft': return 'bg-gray-100 text-gray-700';
    case 'Upcoming': return 'bg-purple-100 text-purple-700';
    case 'Pending Adviser Approval': return 'bg-yellow-100 text-yellow-700';
    case 'Approved':
    case 'Ongoing': return 'bg-blue-100 text-blue-700';
    case 'Completed': return 'bg-green-100 text-green-700';
    case 'Rejected': return 'bg-red-100 text-red-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getLedgerStatusColor = (status) => {
  switch (status) {
    case 'Draft': return 'bg-gray-100 text-gray-700';
    case 'Pending Adviser Approval': return 'bg-yellow-100 text-yellow-700';
    case 'Approved': return 'bg-green-100 text-green-700';
    case 'Rejected': return 'bg-red-100 text-red-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getTypeColor = (type) => {
  switch (type) {
    case 'Expense': return 'bg-red-100 text-red-700';
    case 'Income': return 'bg-green-100 text-green-700';
    case 'Initial': return 'bg-indigo-100 text-indigo-700';
     case 'Initial Transfer': return 'bg-indigo-100 text-indigo-700';
      case 'Transfer': return 'bg-yellow-100 text-yellow-700';
    case 'Donation': return 'bg-blue-100 text-blue-700';
    case 'Sponsorship': return 'bg-purple-100 text-purple-700';
    case 'Canvas': return 'bg-gray-100 text-gray-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getTypeAmountColor = (type) => {
  switch (type) {
    case 'Expense': return 'text-red-700';
    case 'Income': return 'text-green-700';
    case 'Initial': return 'text-indigo-700';
    case 'Initial Transfer': return 'text-indigo-700';
      case 'Transfer': return 'text-yellow-700';
    case 'Donation': return 'text-green-700';
    case 'Sponsorship': return 'text-green-700';
    case 'Canvas': return ' text-gray-700';
    default: return 'text-gray-700';
  }
};

//show change date button when the date is start date is not yet reached when the status of change date is pending make it disabled
//make it so if there is a pending date change request the button is disabled and shows the proposed date change in the project details section with the status of the request
const canChangeDatesRequest = (project) => {
  if (!project.startDate) return false;
  const now = new Date();
  const startDate = new Date(project.startDate);
  return now < startDate;
};

//dont show the change date button if the project is completed or ongoing also if it is not approved or pending adviser approval
const shouldShowChangeDateButton = (project) => {
  const status = getCalculatedStatus(project);
  const isApprovedOrPending = ['Approved'].includes(project.approvalStatus);
  const now = new Date();
  const startDate = new Date(project.startDate);

  return now < startDate && isApprovedOrPending && (status === 'Upcoming' || status === 'Draft');
};

// Helper function outside component
const formatDateRange = (startDate, endDate) => {
  const formatOptions = { month: 'short', day: 'numeric', year: 'numeric' };
  // Or use date-fns:
  // return `${format(new Date(startDate), 'MMM d, yyyy')} to ${format(new Date(endDate), 'MMM d, yyyy')}`;
  
  return new Date(startDate).toLocaleDateString('en-US', formatOptions) + 
         ' to ' + 
         new Date(endDate).toLocaleDateString('en-US', formatOptions);
};

// Check if the change date button should be disabled
const isChangeDateButtonDisabled = (project, dateChangeRequests) => {
  if (!project?.startDate) return true;

  // Disable if there's a pending date change request
  if (Array.isArray(dateChangeRequests) && dateChangeRequests.length > 0) {
    const latestRequest = dateChangeRequests[0];
    if (latestRequest?.status === 'pending') {
      return true;
    }
  }

  // Disable if start date has already passed
  const now = new Date();
  const startDate = new Date(project.startDate);
  return now >= startDate;
};

const getStatusIcon = (status) => {
  switch (status) {
    case 'Approved': return <CheckCircle className="w-4 h-4 text-green-600" />;
    case 'Pending Adviser Approval': return <Clock className="w-4 h-4 text-yellow-600" />;
    case 'Rejected': return <AlertCircle className="w-4 h-4 text-red-600" />;
    case 'Draft': return <Clock className="w-4 h-4 text-gray-600" />;
    default: return null;
  }
};

const calculateProgressFromDays = (startDate, endDate) => {
  if (!startDate || !endDate) return 0;
  
  const start = new Date(startDate);
  const end = new Date(endDate);
  const now = new Date();
  
  // If project hasn't started yet
  if (now < start) return 0;
  
  // If project is completed
  if (now > end) return 100;
  
  // Calculate total days in project
  const totalDays = Math.ceil((end - start) / (1000 * 60 * 60 * 24));
  
  // Calculate elapsed days
  const elapsedDays = Math.ceil((now - start) / (1000 * 60 * 60 * 24));
  
  // Calculate percentage
  const percentage = Math.min(Math.round((elapsedDays / totalDays) * 100), 100);
  return Math.max(percentage, 0);
};

function Progress({ value, className = '' }) {
  return (
    <div className={`w-full h-2 bg-gray-100 rounded-full overflow-hidden ${className}`}>
      <div className="h-full bg-blue-600 rounded-full transition-all" style={{ width: `${value}%` }} />
    </div>
  );
}

// ─── Main Component ──────────────────────────────────────────────────────────
export function CSGProjectDetailsPage({
  projectId,
  initialProject,
  onBack,
  onUpdate,
  onDelete,
}) {
  const [activeTab, setActiveTab] = useState('overview');
  const [loading, setLoading] = useState(false);
  
  const [project, setProject] = useState(() => {
    if (initialProject) {
      return {
        ...defaultProject,
        ...initialProject,
        budgetBreakdown: initialProject.budgetBreakdown || [],
        objective: initialProject.objective || '',
        venue: initialProject.venue || '',
      };
    }
    return defaultProject;
  });
  
  const [ledgerEntries, setLedgerEntries] = useState([]);
  const [proofDocuments, setProofDocuments] = useState([]);
  const [verificationStatus, setVerificationStatus] = useState({ isValid: true, status: 'valid', message: 'Blockchain is valid', tamperedBlocks: [] });
  
  // Status timeline - changed from static to mutable state
  const [statusHistory, setStatusHistory] = useState(mockStatusHistory);
  const [ratings, setRatings] = useState([]);
  const [ratingsStats, setRatingsStats] = useState({
    averageRating: 0,
    totalRatings: 0,
    csatRate: 0,
    satisfied: 0,
    notSatisfied: 0,
    satisfactionAverage: 0,
    completenessAverage: 0,
    engagementAverage: 0,
  });
  
  const [budgetItems, setBudgetItems] = useState(() => {
    if (project.budgetBreakdown && project.budgetBreakdown.length > 0) {
      return project.budgetBreakdown;
    }
    return [];
  });
  
  
  // Edit project state
  const [editBudgetItems, setEditBudgetItems] = useState([]);
  const [editForm, setEditForm] = useState(() => ({ ...project }));
  
  // Ledger form state
  const [ledgerForm, setLedgerForm] = useState({ 
    type: 'Expense', 
    amount: '', 
    description: '', 
    category: '', 
    referenceNumber: '', 
    requiresProof: true 
  });
  
  const resetLedgerForm = () => setLedgerForm({ 
    type: 'Expense', 
    amount: '', 
    description: '', 
    category: '', 
    referenceNumber: '', 
    requiresProof: true 
  });
  
  // Proof form state
  const [proofForm, setProofForm] = useState({ linkedTransaction: '', fileName: '', file: null });
  
  // Modal open states
  const [showEditModal, setShowEditModal] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [showSubmitConfirm, setShowSubmitConfirm] = useState(false);
  const [showSubmitLedgerModal, setShowSubmitLedgerModal] = useState(false);
  const [ledgerToSubmit, setLedgerToSubmit] = useState(null);
  const [showAddLedgerModal, setShowAddLedgerModal] = useState(false);
  const [showEditLedgerModal, setShowEditLedgerModal] = useState(false);
  const [showUploadProofModal, setShowUploadProofModal] = useState(false);
  const [showChangeDatesModal, setShowChangeDatesModal] = useState(false);
  const [proposedStartDate, setProposedStartDate] = useState('');
  const [proposedEndDate, setProposedEndDate] = useState('');
  const [dateChangeReason, setDateChangeReason] = useState('');
  const [isSubmittingDateChange, setIsSubmittingDateChange] = useState(false);
  const [dateChangeRequests, setDateChangeRequests] = useState([]);
  const [showProofViewer, setShowProofViewer] = useState(false);
  const [showLedgerProofViewer, setShowLedgerProofViewer] = useState(false);
  const [showLedgerDetails, setShowLedgerDetails] = useState(false);
  
  // Pagination state for ledger
  const [currentLedgerPage, setCurrentLedgerPage] = useState(1);
  const ledgerItemsPerPage = 5;
  
  // Reset ledger page when ledger entries change
  useEffect(() => {
    setCurrentLedgerPage(1);
  }, [ledgerEntries]);
  
  // Selected items
  const [selectedLedger, setSelectedLedger] = useState(null);
  const [selectedProof, setSelectedProof] = useState(null);
  
  // Delete ledger modal states
  const [deleteLedgerModalOpen, setDeleteLedgerModalOpen] = useState(false);
  const [entryToDelete, setEntryToDelete] = useState(null);
  const [isDeleting, setIsDeleting] = useState(false);
  
  // Toast state
  const [toast, setToast] = useState({ show: false, message: '', type: '' });
  
  // Toast helper function
  const showToastMessage = (message, type = 'success') => {
    setToast({ show: true, message, type });
    setTimeout(() => setToast({ show: false, message: '', type: '' }), 3000);
  };
  
  // Derived flags
  const isEditable = (project.approvalStatus === 'Draft' || project.approvalStatus === 'Rejected') && !project.archive;
  const isApprovedOrPending = ['Approved', 'Pending Adviser Approval', 'Ongoing'].includes(project.approvalStatus);
  const isApproved = project.approvalStatus === 'Approved';
  const shouldShowNotes = isApprovedOrPending || project.approvalStatus === 'Rejected';

  const latestDateChangeRequest = Array.isArray(dateChangeRequests) && dateChangeRequests.length > 0 ? dateChangeRequests[0] : null;
  const isDateChangePending = latestDateChangeRequest?.status === 'pending';
  const dateChangeButtonDisabled = isChangeDateButtonDisabled(project, dateChangeRequests);

//when the use request for change date shows the proposed date change if the request is pending or approved
const getDateChangeBadgeClass = (status) => {
  switch (status) {
    case 'Draft': return 'bg-gray-100 text-gray-700';
    case 'Upcoming': return 'bg-purple-100 text-purple-700';
    case 'Pending Adviser Approval': return 'bg-yellow-100 text-yellow-700';
    case 'Approved':
    case 'Ongoing': return 'bg-blue-100 text-blue-700';
    case 'Completed': return 'bg-green-100 text-green-700';
    case 'Rejected': return 'bg-red-100 text-red-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

// Get the status badge for date change requests
const getDateChangeStatusBadge = () => {
  if (dateChangeRequests.length === 0) return null;
  
  // Get the most recent request
  const latestRequest = dateChangeRequests[0];
  
  let badgeClass = '';
  let label = '';
  
  switch (latestRequest.status) {
    case 'pending':
      badgeClass = 'bg-yellow-100 text-yellow-700';
      label = 'Date Change Pending';
      break;
    case 'approved':
      badgeClass = 'bg-blue-100 text-blue-700';
      label = 'Date Change Approved';
      break;
    case 'rejected':
      badgeClass = 'bg-red-100 text-red-700';
      label = 'Date Change Rejected';
      break;
    default:
      return null;
  }
  
  return { badgeClass, label, request: latestRequest };
};


//change teh color of the date text based on the date change request status
const getDateTextClass = () => {
  const dateChangeBadge = getDateChangeStatusBadge();
  if (!dateChangeBadge) return '';

  switch (dateChangeBadge.request.status) {
    case 'pending':
      return 'text-yellow-600';
    case 'approved':
      return 'text-blue-600';
    case 'rejected':
      return 'text-red-600';
    default:
      return '';
  }
};

// tampering disable
const isTampered = verificationStatus.status === 'tampering_detected' || verificationStatus.status === 'Tampered';
const tamperedLedgerIds = new Set(
  (verificationStatus.tamperedBlocks || [])
    .map((block) => block.ledgerId)
    .filter(Boolean)
);

  // Debug: Log when status changes to help troubleshoot button visibility
  React.useEffect(() => {
    console.log('📊 ProjectDetails render check:', {
      approvalStatus: project.approvalStatus,
      archive: project.archive,
      archiveType: typeof project.archive,
      archiveValue: JSON.stringify(project.archive),
      isEditable,
      wouldBeEditable: (project.approvalStatus === 'Draft' || project.approvalStatus === 'Rejected') && !project.archive,
    });
    
    if (!project.approvalStatus) {
      console.warn('Project approvalStatus is missing! This will hide edit buttons.', { project });
    }
    if (!isEditable && (project.approvalStatus === 'Draft' || project.approvalStatus === 'Rejected')) {
      console.warn('⚠️  isEditable is false but status is Draft/Rejected!', {
        approvalStatus: project.approvalStatus,
        archive: project.archive,
        archiveType: typeof project.archive,
        shouldBeEditable: (project.approvalStatus === 'Draft' || project.approvalStatus === 'Rejected') && !project.archive,
        notArchived: !project.archive,
        statusMatches: project.approvalStatus === 'Draft' || project.approvalStatus === 'Rejected',
      });
    }
  }, [project.approvalStatus, project.id, project.archive, isEditable]);

// Date formatting helper
const formatDate = (dateString) => {
  if (!dateString) return 'Not specified';
  try {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  } catch (error) {
    return dateString;
  }
};

  // Fetch date change requests for this project
  const fetchDateChangeRequests = async () => {
    if (!projectId) return;
    
    try {
      const response = await fetch(`/api/projects/${projectId}/date-change-requests`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (response.ok) {
        const data = await response.json();
        setDateChangeRequests(Array.isArray(data) ? data : []);
      }
    } catch (error) {
      console.error('Error fetching date change requests:', error);
    }
  };

  // Fetch project from API if we have a projectId but no initial data (deep link refresh)
  useEffect(() => {
    const fetchProjectById = async () => {
      if (!projectId || initialProject) return;
      setLoading(true);
      try {
        const response = await fetch(`/api/projects/${projectId}`, {
          headers: {
            Accept: 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        });

        if (!response.ok) {
          throw new Error('Failed to load project details');
        }

        const data = await response.json();
        if (data) {
          let budgetBreakdown = [];

          if (Array.isArray(data.budget_breakdown)) {
            budgetBreakdown = data.budget_breakdown;
          } else if (typeof data.budget_breakdown === 'string' && data.budget_breakdown.trim()) {
            try {
              const parsed = JSON.parse(data.budget_breakdown);
              budgetBreakdown = Array.isArray(parsed) ? parsed : [];
            } catch (error) {
              console.warn('Unable to parse budget_breakdown JSON', error);
            }
          } else if (Array.isArray(data.budgetBreakdown)) {
            budgetBreakdown = data.budgetBreakdown;
          } else if (typeof data.budgetBreakdown === 'string' && data.budgetBreakdown.trim()) {
            try {
              const parsed = JSON.parse(data.budgetBreakdown);
              budgetBreakdown = Array.isArray(parsed) ? parsed : [];
            } catch (error) {
              console.warn('Unable to parse budgetBreakdown JSON', error);
            }
          }

          // Normalize API response to use camelCase field names consistently
          const normalized = {
            ...defaultProject,
            id: data.id || null,
            title: data.title || '',
            category: data.category || '',
            description: data.description || '',
            objective: data.objective || '',
            venue: data.venue || '',
            status: data.status || 'Draft',
            approvalStatus: data.approval_status || data.approvalStatus || 'Draft',
            progress: data.progress || 0,
            budget: data.budget || 0,
            budgetBreakdown,
            budgetSource: data.budgetSource || 'none',
            transferFromProjectId: data.transferFromProjectId || '',
            transferAmount: data.transferAmount || '',
            startDate: data.start_date || data.startDate || '',
            endDate: data.end_date || data.endDate || '',
            createdAt: data.created_at || data.createdAt || '',
            proposedBy: data.proposed_by || data.proposedBy || '',
            note: data.note || '',
            approveBy: data.approveBy || data.approve_by || '',
            projectProof: data.project_proof || data.projectProof || null,
            createdBy: data.createdBy || data.created_by || null,
            updatedBy: data.updated_by || data.updatedBy || null,
            archive: data.archive || 0,
            approvedAt: data.approved_at || data.approvedAt || null,
            is_initial: data.is_initial || 0,
          };
          setProject(normalized);
        }
      } catch (error) {
        console.error('Error fetching project for detail page:', error);
        showToast('Unable to load project details', 'error');
      } finally {
        setLoading(false);
      }
    };

    fetchProjectById();
  }, [projectId, initialProject]);

  // SAFETY VALVE: Auto-correct if approvalStatus is missing or invalid
  // This is a last-resort fix if the API response didn't include status fields
  React.useEffect(() => {
    if (project.id && !project.approvalStatus) {
      console.error('🚨 SAFETY VALVE: Project has no approvalStatus! Auto-correcting to Draft.', { project });
      setProject(prev => ({
        ...prev,
        approvalStatus: prev.approvalStatus || 'Draft',
        approval_status: prev.approval_status || 'Draft',
        status: prev.status || 'Draft',
        archive: prev.archive !== undefined ? prev.archive : 0
      }));
    }
  }, [project.id, project.approvalStatus]);
 
  // Ledger totals (only approved entries)
  const totalIncome = ledgerEntries
    .filter((e) => e.type === 'Income' && e.approval_status === 'Approved')
    .reduce((s, e) => s + (parseFloat(e.amount) || 0), 0);
    
  const totalExpenses = ledgerEntries
    .filter((e) => e.type === 'Expense' && e.approval_status === 'Approved')
    .reduce((s, e) => s + (parseFloat(e.amount) || 0), 0);

  // Calculate effective budget based on approved ledger entries
const displayBudget = parseFloat(project.budget) || 0;
const computedBudgetFromLedger = ledgerEntries
.filter((entry) => entry.approval_status === 'Approved' || ['Initial', 'Initial Transfer'].includes(entry.type))
  .reduce((sum, entry) => {
    const amount = parseFloat(entry.amount) || 0;
    const type = (entry.type || '').toLowerCase();
    
    if (type === 'expense' || type === 'transfer') {
      // If amount is negative, it effectively adds to budget
      // If amount is positive, it subtracts from budget
      return sum - amount;
    }
    if (type === 'canvas') {
      return sum;
    }
    return sum + amount;
  }, 0);
  const budgetDifference = displayBudget - computedBudgetFromLedger;
  // Only show mismatch after ledger data is loaded (not during initial load)
  const isBudgetTampered = !loading && ledgerEntries.length > 0 && displayBudget > 0 && Math.abs(budgetDifference) > 0.01;
  const isLedgerDisabled = isTampered || isBudgetTampered;

  const normalizeLedgerEntry = (item) => {
    const breakdownRaw = item.budgetBreakdown || item.budget_breakdown;
    const budgetBreakdown = breakdownRaw
      ? (Array.isArray(breakdownRaw)
          ? breakdownRaw
          : (typeof breakdownRaw === 'string' ? JSON.parse(breakdownRaw) : breakdownRaw))
      : [];

    return {
      ...item,
      requiresProof: !!item.ledger_proof,
      referenceNumber: item.reference_number || item.referenceNumber || '',
      budgetBreakdown,
    };
  };

  const ifBudgetNegative = project.budget < 0;

  // Function to build status timeline from ledger entries
  const buildStatusTimeline = (ledgerEntries) => {
    // Start with base status events
    const baseEvents = [
      {
        id: 'project-created',
        label: 'Project Created',
        description: 'Project created by CSG.',
        date: project.createdAt ? project.createdAt.split('T')[0] : new Date().toISOString().split('T')[0],
        isDone: true,
        isCurrent: false,
      },
      {
        id: 'project-status',
        label: 'Project Status Updated',
        description: `Current status: ${project.status || 'Draft'} / Approval: ${project.approvalStatus || 'Pending'}`,
        date: project.updatedAt ? project.updatedAt.split('T')[0] : new Date().toISOString().split('T')[0],
        isDone: true,
        isCurrent: false,
      },
    ];

    // Convert ledger entries to timeline events
    const ledgerEvents = (ledgerEntries || []).map((entry) => ({
      id: `ledger-${entry.id}`,
      label: `Ledger Entry ${entry.type || 'Entry'}`,
      description: `${entry.description || 'No description'} - ${entry.approval_status || 'Draft'}`,
      date: entry.created_at ? entry.created_at.split('T')[0] : entry.createdAt ? entry.createdAt.split('T')[0] : new Date().toISOString().split('T')[0],
      isDone: entry.approval_status === 'Approved',
      isCurrent: false,
    }));

    // Combine and sort by date
    const allEvents = [...baseEvents, ...ledgerEvents];
    allEvents.sort((a, b) => new Date(a.date) - new Date(b.date));

    // Mark the last event as current
    if (allEvents.length > 0) {
      allEvents[allEvents.length - 1].isCurrent = true;
    }

    // Mark all completed before the last as isDone
    allEvents.forEach((item, index) => {
      if (index < allEvents.length - 1) {
        item.isDone = true;
      }
    });

    console.log('Built timeline with', allEvents.length, 'events:', allEvents);
    return allEvents;
  };

  // Fetch ledger entries from database
  const fetchLedgerEntries = async () => {
    if (!projectId) return;
    
    setLoading(true);
    try {
      const response = await fetch(`/api/ledger-entries/project/${projectId}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to load ledger entries');
      }
      
      const data = await response.json();
      
      const mappedEntries = Array.isArray(data) ? data.map((item) => normalizeLedgerEntry(item)) : [];
      
      setLedgerEntries(mappedEntries);
      
      const proofs = mappedEntries
        .filter(entry => entry.ledger_proof)
        .map(entry => ({
          id: entry.id,
          fileName: entry.ledger_proof.split('/').pop(),
          linkedTransaction: entry.id,
          uploadDate: entry.created_at ? entry.created_at.split('T')[0] : new Date().toISOString().split('T')[0],
          fileType: entry.ledger_proof.split('.').pop().toUpperCase(),
          fileSize: 'Unknown',
          status: entry.approval_status,
          hash: entry.id,
          filePath: entry.ledger_proof,
          budgetBreakdown: entry.budgetBreakdown,
        }));
      
      setProofDocuments(proofs);
    } catch (error) {
      console.error('Ledger fetch error:', error);
      showToastMessage('Unable to load ledger entries', 'error');
    } finally {
      setLoading(false);
    }
  };

  // Fetch ratings from database
  const fetchProjectRatings = async () => {
    if (!projectId) return;
    
    try {
      const response = await fetch(`/api/projects/${projectId}/ratings`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to load ratings');
      }
      
      const data = await response.json();
      setRatings(data.ratings || []);
      setRatingsStats(data.statistics || {});
    } catch (error) {
      console.error('Ratings fetch error:', error);
      showToastMessage('Unable to load ratings', 'error');
    }
  };

  // Fetch blockchain verification status
  const fetchVerificationStatus = async () => {
    if (!projectId) return;
    
    try {
      const response = await fetch(`/api/projects/${projectId}/verify-chain`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to verify blockchain');
      }
      
      const data = await response.json();
      setVerificationStatus(data);
    } catch (error) {
      console.error('Verification fetch error:', error);
      setVerificationStatus({ isValid: false, status: 'error', message: 'Unable to verify blockchain' });
    }
  };

  // Mask user name for privacy: "John Doe" becomes "J******* D*******"
function maskUserName(fullName) {
  if (!fullName) return '******* *******';
  const names = fullName.trim().split(/\s+/).filter(Boolean);
  if (names.length === 0) return '******* *******';
  
  return names
    .map((name) => {
      if (name.length <= 1) return name;
      return name[0] + '*'.repeat(name.length - 1);
    })
    .join(' ');
}
  
  // Fetch data when component mounts or project changes
  useEffect(() => {
    if (project.id) {
      fetchLedgerEntries();
      fetchVerificationStatus();
      fetchDateChangeRequests();
    }
  }, [project.id]);

  useEffect(() => {
    if (project.id && isApproved) {
      fetchProjectRatings();
    }
  }, [project.id, isApproved]);

  // Rebuild status timeline whenever ledger entries change
  useEffect(() => {
    if (ledgerEntries.length > 0 || project.id) {
      const updatedTimeline = buildStatusTimeline(ledgerEntries);
      setStatusHistory(updatedTimeline);
    }
  }, [ledgerEntries, project.id, project.status, project.approvalStatus]);
  
  // ── Handlers ────────────────────────────────────────────────────────────────
  const normalizeProject = (raw) => ({
    id: raw.id,
    title: raw.title,
    description: raw.description,
    objective: raw.objective,
    venue: raw.venue,
    category: raw.category,
    budget: raw.budget,
    budgetBreakdown: raw.budget_breakdown
      ? (typeof raw.budget_breakdown === 'string' ? JSON.parse(raw.budget_breakdown) : raw.budget_breakdown)
      : [],
    status: raw.status || 'Draft',
    approvalStatus: raw.approval_status || raw.approvalStatus || 'Draft',
    startDate: raw.start_date || raw.startDate,
    endDate: raw.end_date || raw.endDate,
    proposedBy: raw.proposed_by || raw.proposedBy,
    note: raw.note,
    approveBy: raw.approveBy || raw.approve_by,
    projectProof: raw.project_proof || raw.projectProof,
    createdAt: raw.created_at || raw.createdAt,
    archive: raw.archive || 0,
    createdBy: raw.createdBy || raw.created_by,
    updatedBy: raw.updated_by || raw.updatedBy,
    approvedAt: raw.approved_at || raw.approvedAt,
  });
  
  const handleEditProject = (updatedProject) => {
  console.log('🔄 handleEditProject called with response:', updatedProject);
  
  // Log response structure for debugging
  console.log('🔍 Response structure:', {
    hasData: !!updatedProject?.data,
    hasProject: !!updatedProject?.project,
    topLevelKeys: Object.keys(updatedProject || {}).slice(0, 10),
    dataKeys: updatedProject?.data ? Object.keys(updatedProject.data).slice(0, 10) : 'N/A'
  });
  
  // Handle various possible API response structures
  let responseData = {};
  if (updatedProject?.data?.project) {
    // Case: {data: {project: {...}}}
    responseData = updatedProject.data.project;
  } else if (updatedProject?.data && typeof updatedProject.data === 'object' && updatedProject.data.id) {
    // Case: {data: {...full project...}}
    responseData = updatedProject.data;
  } else if (updatedProject?.project && typeof updatedProject.project === 'object') {
    // Case: {project: {...}}
    responseData = updatedProject.project;
  } else if (updatedProject && typeof updatedProject === 'object' && updatedProject.id) {
    // Case: {...full project...} (direct response)
    responseData = updatedProject;
  }
  
  console.log('📦 Current project baseline:', {
    id: project.id,
    title: project.title,
    approvalStatus: project.approvalStatus,
    status: project.status,
    archive: project.archive,
  });
  console.log('📦 API response data extracted:', {
    keys: Object.keys(responseData).slice(0, 15),
    approvalStatus: responseData.approval_status || responseData.approvalStatus,
    archive: responseData.archive,
  });
  
  // CRITICAL: Build a new project object that DEFINITELY preserves status fields
  const finalProject = {
    // Start with full current project to have all fields
    ...project,
    
    // Then merge in all non-null response fields
    ...(responseData || {}),
    
    // THEN explicitly and aggressively preserve critical status fields
    // These determine button visibility, so they MUST be correct
    id: responseData?.id || project.id,
    title: responseData?.title || project.title,
    approvalStatus: responseData?.approval_status || responseData?.approvalStatus || project.approvalStatus || 'Draft',
    approval_status: responseData?.approval_status || responseData?.approvalStatus || project.approval_status || 'Draft',
    status: responseData?.status || project.status || 'Draft',
    // NEVER let archive undefined - a null archive means not archived (0)
    archive: (responseData?.archive !== undefined && responseData?.archive !== null) 
      ? responseData.archive 
      : (project.archive !== undefined ? project.archive : 0),
    // Preserve is_initial field for budget mismatch check
    is_initial: responseData?.is_initial !== undefined ? responseData.is_initial : (project.is_initial || 0),
    // CRITICAL FIX: Ensure budget breakdown is properly synced
    budgetBreakdown: responseData?.budget_breakdown 
      ? (typeof responseData.budget_breakdown === 'string' ? JSON.parse(responseData.budget_breakdown) : responseData.budget_breakdown)
      : (responseData?.budgetBreakdown || project.budgetBreakdown || []),
  };
  
  // SAFETY: If this is Draft or Rejected, ensure archive is 0
  // These statuses require archive=0 to show edit buttons
  if ((finalProject.approvalStatus === 'Draft' || finalProject.approvalStatus === 'Rejected') && finalProject.archive !== 0) {
    console.warn('🔧 CORRECTING archive: Draft/Rejected projects should not be archived!', {
      before: finalProject.archive,
      after: 0,
      approvalStatus: finalProject.approvalStatus
    });
    finalProject.archive = 0;
  }
  
  console.log('📋 Final project object before normalization:', {
    id: finalProject.id,
    title: finalProject.title,
    approvalStatus: finalProject.approvalStatus,
    status: finalProject.status,
    archive: finalProject.archive,
    budgetBreakdownCount: finalProject.budgetBreakdown?.length || 0,
  });
  
  // Normalize for consistent shape
  const normalized = {
    ...finalProject,
    approvalStatus: finalProject.approvalStatus,
    status: finalProject.status,
    archive: finalProject.archive,
    is_initial: finalProject.is_initial,
    budgetBreakdown: finalProject.budgetBreakdown,
  };
  
  // Final sanity check - if buttons would be hidden, log a warning
  const wouldBeEditable = (normalized.approvalStatus === 'Draft' || normalized.approvalStatus === 'Rejected') && !normalized.archive;
  console.log('✅ Pre-state-update check:', {
    approvalStatus: normalized.approvalStatus,
    status: normalized.status, 
    archive: normalized.archive,
    archiveType: typeof normalized.archive,
    wouldBeEditable,
    budgetBreakdownCount: normalized.budgetBreakdown?.length,
    statusCheck: normalized.approvalStatus === 'Draft' || normalized.approvalStatus === 'Rejected',
    archiveCheck: !normalized.archive,
  });
  
  if (!wouldBeEditable && normalized.approvalStatus !== 'Pending Adviser Approval') {
    console.warn('⚠️  WARNING: Buttons may be hidden after this update!', { 
      normalized,
      breakdown: {
        approvalStatus: normalized.approvalStatus,
        archive: normalized.archive,
        reason: `approvalStatus="${normalized.approvalStatus}" (expected Draft/Rejected), archive=${normalized.archive} (expected 0)`
      }
    });
  }
  
  // IMMEDIATE UPDATE: Update both project and budget items simultaneously
  setProject(normalized);
  setBudgetItems(normalized.budgetBreakdown || []);
  setEditBudgetItems(normalized.budgetBreakdown || []);
  onUpdate?.(normalized);
};
  
  const handleDeleteProject = async () => {
    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const res = await fetch(`/api/projects/${project.id}/archive`, {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (!res.ok) {
        const errData = await res.json().catch(() => null);
        throw new Error(errData?.message || 'Failed to archive project');
      }
      
      setProject({ ...project, archive: 1 });
      showToastMessage('Project archived successfully', 'success');
      setShowDeleteConfirm(false);
      onDelete?.(project.id);
      onBack?.();
    } catch (error) {
      showToastMessage(error.message || 'Failed to archive project', 'error');
    }
  };
  
  const handleSubmitForApproval = async () => {
    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const response = await fetch(`/api/projects/${project.id}/submit`, {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to submit project');
      }
      
      const responseData = await response.json();
      
      // Extract the updated project data
      let updatedProject = {};
      if (responseData?.data?.id) {
        // Case: {data: {project: {...}}}
        updatedProject = responseData.data;
      } else if (responseData?.data && typeof responseData.data === 'object') {
        // Case: {data: {...full project...}}
        updatedProject = responseData.data;
      } else if (responseData && typeof responseData === 'object' && responseData.id) {
        // Case: {...full project...} (direct response)
        updatedProject = responseData;
      } else {
        // Fallback: create updated project with pending status
        updatedProject = {
          ...project,
          status: 'Pending Adviser Approval',
          approvalStatus: 'Pending Adviser Approval',
          approval_status: 'Pending Adviser Approval',
          updated_at: new Date().toISOString(),
        };
      }
      
      // CRITICAL: Ensure approval status is set to Pending Adviser Approval
      // Keep the project status unchanged (it represents lifecycle: Draft/Ongoing/Complete)
      const finalProject = {
        ...project,
        ...updatedProject,
        approvalStatus: 'Pending Adviser Approval',
        approval_status: 'Pending Adviser Approval',
        // Preserve the existing project status (Draft/Ongoing/Complete based on dates)
        status: updatedProject.status || project.status,
        // Preserve archive status
        archive: updatedProject.archive !== undefined ? updatedProject.archive : project.archive,
      };
      
      console.log('✅ Project submitted for approval:', {
        oldStatus: project.approvalStatus,
        newStatus: finalProject.approvalStatus,
        isEditable: (finalProject.approvalStatus === 'Draft' || finalProject.approvalStatus === 'Rejected') && !finalProject.archive,
      });
      
      setProject(finalProject);
      onUpdate?.(finalProject);
      setShowSubmitConfirm(false);
      showToastMessage('Project submitted for adviser approval', 'success');
    } catch (error) {
      showToastMessage(error.message || 'Failed to submit project', 'error');
    }
  };

  const handleSubmitDateChangeRequest = async () => {
    try {
      if (!proposedStartDate || !proposedEndDate || !dateChangeReason.trim()) {
        showToastMessage('Please fill in all fields', 'error');
        return;
      }

      if (new Date(proposedEndDate) < new Date(proposedStartDate)) {
        showToastMessage('End date must be after start date', 'error');
        return;
      }

      setIsSubmittingDateChange(true);

      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const response = await fetch(`/api/projects/${project.id}/request-date-change`, {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          proposed_start_date: proposedStartDate,
          proposed_end_date: proposedEndDate,
          reason: dateChangeReason.trim(),
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Failed to submit date change request');
      }

      const responseData = await response.json();
      setDateChangeRequests((prev) => [responseData.data, ...(Array.isArray(prev) ? prev : [])]);
      showToastMessage('Date change request submitted successfully. It will appear in the Adviser\'s approval center.', 'success');
      setShowChangeDatesModal(false);
      setProposedStartDate('');
      setProposedEndDate('');
      setDateChangeReason('');
    } catch (error) {
      showToastMessage(error.message || 'Failed to submit date change request', 'error');
    } finally {
      setIsSubmittingDateChange(false);
    }
  };
  
  const handleAddLedgerEntry = async (ledgerData) => {
    console.log('📝 handleAddLedgerEntry called with ledgerData:', ledgerData);
    
    // If refresh flag is set, fetch fresh data from database instead of adding locally
    if (ledgerData?.refresh) {
      console.log('🔄 Refresh flag detected - fetching fresh data from database...');
      
      // Show success toast immediately
      showToast(ledgerData.message || 'Ledger entry created successfully!', 'success');
      
      setShowAddLedgerModal(false);
      resetLedgerForm();
      
      // Wait a moment for the database to be ready, then fetch fresh data
      setTimeout(() => {
        fetchLedgerEntries();
        fetchVerificationStatus();
      }, 500);
      return;
    }
    
    // Fallback: Add entry locally if no refresh flag
    const mappedEntry = normalizeLedgerEntry({ ...ledgerData, approval_status: ledgerData.approval_status || 'Draft' });
    console.log('✅ Mapped entry:', mappedEntry);
    
    // Update ledger entries - this will trigger the useEffect to rebuild timeline
    setLedgerEntries((prevEntries) => [mappedEntry, ...prevEntries]);
    
    setShowAddLedgerModal(false);
    resetLedgerForm();
    showToast('Ledger added successfully', 'success');
  };
  
  // Open modal for ledger deletion
  const handleDeleteClick = (id) => {
    setEntryToDelete(id);
    setDeleteLedgerModalOpen(true);
  };
  
  // Handle the actual ledger deletion
  const handleDeleteLedgerEntry = async () => {
    if (!entryToDelete) return;
    
    setIsDeleting(true);
    
    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const response = await fetch(`/api/ledger-entries/${entryToDelete}`, {
        method: 'DELETE',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': token,
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to delete ledger entry');
      }
      
      // Update ledger entries - useEffect will rebuild timeline
      setLedgerEntries(ledgerEntries.filter(e => e.id !== entryToDelete));
      fetchVerificationStatus();
      
      showToastMessage('Ledger entry deleted successfully', 'success');
      setDeleteLedgerModalOpen(false);
      setEntryToDelete(null);
    } catch (error) {
      showToastMessage(error.message || 'Failed to delete ledger entry', 'error');
    } finally {
      setIsDeleting(false);
    }
  };
  
  const openEditLedgerModal = (entry) => {
    console.log('🔄 openEditLedgerModal called with entry:', entry);

    const breakdown = entry.budgetBreakdown ||
      (entry.budget_breakdown
        ? (typeof entry.budget_breakdown === 'string'
            ? JSON.parse(entry.budget_breakdown)
            : entry.budget_breakdown)
        : []);

    console.log('📋 Parsed budget breakdown:', breakdown);

    const formData = {
      id: entry.id,
      type: entry.type || 'Expense',
      amount: entry.amount != null ? entry.amount.toString() : '',
      description: entry.description || '',
      category: entry.category || '',
      referenceNumber: entry.referenceNumber || entry.reference_number || '',
      requiresProof: !!entry.ledger_proof,
      existingProof: !!entry.ledger_proof,
      budgetBreakdown: breakdown,
      approval_status: entry.approval_status || 'Draft',
    };

    console.log('📝 Setting ledger form data:', formData);

    setSelectedLedger(entry);
    setLedgerForm(formData);
    setShowEditLedgerModal(true);

    console.log('✅ Edit ledger modal should now be open');
  };

  const handleLedgerEntryUpdate = (updatedEntry) => {
    const mappedEntry = normalizeLedgerEntry(updatedEntry);
    setLedgerEntries((prevEntries) => prevEntries.map(e => e.id === mappedEntry.id ? mappedEntry : e));
    fetchVerificationStatus();
    
    setShowEditLedgerModal(false);
    setSelectedLedger(null);
    showToastMessage('Ledger entry updated successfully', 'success');
  };  
  const handleSubmitLedgerForApproval = async (id) => {
    if (!id) {
      showToastMessage('No ledger entry selected', 'error');
      return;
    }

    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const response = await fetch(`/api/ledger-entries/${id}/submit`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': token,
        },
      });
      
      if (!response.ok) {
        throw new Error('Failed to submit ledger entry');
      }
      
      const updatedEntry = await response.json();
      // Update ledger entries - useEffect will rebuild timeline
      setLedgerEntries(ledgerEntries.map(e => e.id === id ? updatedEntry : e));
      fetchVerificationStatus();
      
      showToastMessage('Ledger entry submitted for approval', 'success');
    } catch (error) {
      showToastMessage(error.message || 'Failed to submit ledger entry', 'error');
    } finally {
      setLedgerToSubmit(null);
      setShowSubmitLedgerModal(false);
    }
  };
  
  const handleUploadProof = async () => {
    if (!proofForm.linkedTransaction || !proofForm.file) {
      showToastMessage('Please select a transaction and file', 'error');
      return;
    }
    
    const formData = new FormData();
    formData.append('proof_file', proofForm.file);
    formData.append('linked_transaction', proofForm.linkedTransaction);
    
    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      const response = await fetch(`/api/ledger-entries/${proofForm.linkedTransaction}/proof`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': token,
        },
        body: formData,
      });
      
      if (!response.ok) {
        throw new Error('Failed to upload proof');
      }
      
      const updatedEntry = await response.json();
      setLedgerEntries(ledgerEntries.map(e => e.id === proofForm.linkedTransaction ? updatedEntry : e));
      
      const newProof = {
        id: updatedEntry.id,
        fileName: proofForm.file.name,
        linkedTransaction: proofForm.linkedTransaction,
        uploadDate: new Date().toISOString().split('T')[0],
        fileType: proofForm.file.name.split('.').pop().toUpperCase(),
        fileSize: `${(proofForm.file.size / (1024 * 1024)).toFixed(2)} MB`,
        status: updatedEntry.approval_status,
        hash: updatedEntry.id,
        filePath: updatedEntry.ledger_proof,
      };
      setProofDocuments([...proofDocuments, newProof]);
      
      setShowUploadProofModal(false);
      setProofForm({ linkedTransaction: '', fileName: '', file: null });
      showToastMessage('Proof document uploaded successfully', 'success');
    } catch (error) {
      showToastMessage(error.message || 'Failed to upload proof', 'error');
    }
  };
  
  // If project is still loading or has no ID, show loading state
  if (!project.id && project.title === 'Loading...') {
    return (
      <div className="space-y-6">
        <Button variant="ghost" onClick={onBack} className="rounded-xl">
          <ArrowLeft className="w-4 h-4 mr-2" />Back to Projects
        </Button>
        <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
          <div className="flex flex-col items-center justify-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mb-4"></div>
            <p className="text-gray-600">Loading project details...</p>
          </div>
        </Card>
      </div>
    );
  }
  
  // ── Render ───────────────────────────────────────────────────────────────────
  return (
    <div className="space-y-6">
      {/* Back Button */}
      <Button variant="ghost" onClick={onBack} className="rounded-xl hover:text-blue-600 hover:underline">
        <ArrowLeft className="w-4 h-4 mr-2" />Back to Projects
      </Button>
      
      {/* Project Header */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col lg:flex-row gap-6">
          <div className="flex-1 space-y-4">
            <div>
              <div className="flex flex-wrap items-center gap-3 mb-3">
                <h1 className="text-2xl font-semibold text-gray-900">{project.title}</h1>
                <Badge className={`rounded-lg ${getStatusColor(project.approvalStatus)}`}>{project.approvalStatus}</Badge>
                <Badge className={`rounded-lg ${getStatusColor(getCalculatedStatus(project))}`}>{getCalculatedStatus(project)}</Badge>
                {isEditable && <Badge className="rounded-lg bg-purple-100 text-purple-700">Edit Mode</Badge>}
                {getDateChangeStatusBadge() && (
                  <Badge className={`rounded-lg ${getDateChangeStatusBadge().badgeClass}`}>
                    {getDateChangeStatusBadge().label}
                  </Badge>
                )}
              </div>
              <p className="text-gray-600">{project.description}</p>
            </div>
            {isApprovedOrPending && (
              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm text-gray-500">Project Progress</span>
                  <span className="text-sm font-medium text-gray-900">{calculateProgressFromDays(project.startDate, project.endDate)}%</span>
                </div>
                <Progress value={calculateProgressFromDays(project.startDate, project.endDate)} className="h-3" />
              </div>
            )}
            
            {isEditable && (
              <EditActionButtons
                onSubmit={() => setShowSubmitConfirm(true)}
                onEdit={() => {
                  setEditForm({ 
                    ...project,
                    startDate: project.startDate,
                    endDate: project.endDate,
                    budgetBreakdown: project.budgetBreakdown,
                    status: project.status,
                    approvalStatus: project.approvalStatus,
                    archive: project.archive,
                    note: project.note,
                    approveBy: project.approveBy,
                    hasBudget: Number(project.budget || 0) > 0,
                    budgetSource: project.budgetSource || 'none',
                    transferFromProjectId: project.transferFromProjectId || '',
                    transferAmount: project.transferAmount || '',
                  });
                  setEditBudgetItems(project.budgetBreakdown?.map((i) => ({ ...i })) || []);
                  setShowEditModal(true);
                }}
                onDelete={() => setShowDeleteConfirm(true)}
              />
            )}
          </div>
          <div className="grid grid-cols-2 lg:grid-cols-1 gap-4 lg:w-64">
            <div className={`${isBudgetTampered ? 'bg-red-50 border border-red-200' : 'bg-blue-50'} rounded-xl p-4`}>
              <Wallet className={`w-5 h-5 mb-2 ${isBudgetTampered ? 'text-red-600' : 'text-blue-600'}`} />
             <p className="text-sm text-gray-500">Current Budget</p>
<p className={`text-xl font-semibold ${
  isBudgetTampered 
    ? 'text-red-700' 
    : Number(project.budget || 0) < 0 
      ? 'text-red-600' 
      : 'text-gray-900'
}`}>
  ₱{formatLimitedNumber(Number(project.budget || 0), { minFractionDigits: 2, maxFractionDigits: 2 })}
</p>
{Number(project.budget || 0) < 0 && !isBudgetTampered && (
  <p className="text-xs text-red-500 mt-1">
     Dont panic. The expenses only have exceed the budget.
  </p>
)}
              {isBudgetTampered && (
                <div className="mt-2">
                  <p className="text-xs font-semibold text-red-700">Alert: Budget mismatch detected</p>
                  <p className="text-xs text-red-600">
                    Ledger-computed: ₱{formatLimitedNumber(computedBudgetFromLedger, { minFractionDigits: 2, maxFractionDigits: 2 })}
                  </p>
                  <p className="text-xs text-red-600">
                    Difference: ₱{formatLimitedNumber(Math.abs(budgetDifference), { minFractionDigits: 2, maxFractionDigits: 2 })}
                  </p>
                </div>
              )}
              {/* {project.budget > 0 && (
                <p className="text-xs text-gray-500 mt-1">
                  Base: ₱{Number(project.budget).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </p>
              )} */}
            </div>
            <div className="bg-blue-50 rounded-xl p-4">
           
             <div className="flex items-center mb-2">
                <Calendar className="w-5 h-5 text-blue-600 mr-2" />
                {/* disable the button when there is already a pending date change request */}
                 {shouldShowChangeDateButton(project) && (
                <Button 
  onClick={() => setShowChangeDatesModal(true)} 
  variant="outline" 
  size="sm" 
  className={`${
    dateChangeButtonDisabled 
      ? 'bg-gray-400' 
      : 'bg-blue-600 hover:bg-blue-700'
  } text-white`}
  disabled={dateChangeButtonDisabled}
>
  {isDateChangePending ? 'Date Change Pending' : 'Change Date'}
</Button>
                 )}
             </div> 
           
              <p className="text-sm text-gray-500">Timeline 
                
              </p>
             {getDateTextClass(getCalculatedStatus(project)) ? (
  <p className={`text-sm font-semibold ${getDateTextClass(getCalculatedStatus(project))}`}>
    {formatDateRange(project.startDate, project.endDate)}
  </p>
) : (
  <p className="text-sm font-semibold text-blue-700">
    {formatDateRange(project.startDate, project.endDate)}
  </p>
)}
            </div>
          </div>
        </div>
      </Card>
      
      {/* Tab Navigation */}
      <div className="flex flex-wrap gap-2 bg-white rounded-xl p-1 shadow-sm">
        <button
          onClick={() => setActiveTab('overview')}
          className={`px-4 py-2 text-sm font-medium rounded-lg transition-all ${
            activeTab === 'overview' 
              ? 'bg-blue-600 text-white' 
              : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
          }`}
        >
          Overview
        </button>
      
        
        {isApproved && (
          <>
            <button
              onClick={() => setActiveTab('ledger')}
              className={`px-4 py-2 text-sm font-medium rounded-lg transition-all ${
                activeTab === 'ledger' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              Ledger
            </button>
            
            <button
              onClick={() => setActiveTab('proof')}
              className={`px-4 py-2 text-sm font-medium rounded-lg transition-all ${
                activeTab === 'proof' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              Proof
            </button>
            
            <button
              onClick={() => setActiveTab('status')}
              className={`px-4 py-2 text-sm font-medium rounded-lg transition-all ${
                activeTab === 'status' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              Status Timeline
            </button>
            
            <button
              onClick={() => setActiveTab('ratings')}
              className={`px-4 py-2 text-sm font-medium rounded-lg transition-all ${
                activeTab === 'ratings' 
                  ? 'bg-blue-600 text-white' 
                  : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
              }`}
            >
              Ratings
            </button>
          </>
        )}
      </div>
      
      {/* Tab Content - Overview */}
      {activeTab === 'overview' && (
       <div className="space-y-6">
  <Card className="rounded-[20px] border-0 shadow-sm p-6">
    <h2 className="text-lg font-semibold text-gray-900 mb-4">Project Details</h2>
    
    {/* {project.objective && (
      <div className="mb-6">
        <p className="text-sm text-gray-500 mb-1">Project Objective</p>
        <p className="text-gray-900">{project.objective}</p>
      </div>
    )} */}

    <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">

      {project.objective && (
      <div className="col-span-2">
        <p className="text-sm text-gray-500 mb-1">Project Objective</p>
        <p className="text-gray-900">{project.objective}</p>
      </div>
    )}


      {project.venue && (
        <div>
          <p className="text-sm text-gray-500 mb-1">Venue</p>
          <p className="text-gray-900">{project.venue}</p>
        </div>
      )}
      <div>
        <p className="text-sm text-gray-500 mb-1">Category</p>
        <p className="text-gray-900">{project.category || 'Not specified'}</p>
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Created On</p>
        <p className="text-gray-900">{formatDate(project.createdAt)}</p>
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Start Date</p>
        <p className="text-gray-900">{formatDate(project.startDate)}</p>
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">End Date</p>
        <p className="text-gray-900">{formatDate(project.endDate)}</p>
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Created by:</p>
        <p className="text-gray-900">{project.createdBy || 'Not specified'}</p>
      </div>
      <div>
        <p className="text-sm text-gray-500 mb-1">Proposed by:</p>
        <p className="text-gray-900">{project.proposedBy || 'Not specified'}</p>
      </div>
    </div>

    {getDateChangeStatusBadge() && (
      <div className="border-t pt-4 mb-6">
        <div className="mb-3">
          <p className="text-sm font-medium text-gray-900 flex items-center gap-2">
            {/* <Calendar className="w-4 h-4 text-purple-600" /> */}
            Pending Date Change
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 rounded-lg">
          <div>
            <p className="text-xs text-gray-600 mb-1">Current Dates</p>
            <p className="text-sm text-gray-900">{formatDate(getDateChangeStatusBadge().request.current_start_date)} to {formatDate(getDateChangeStatusBadge().request.current_end_date)}</p>
          </div>
          <div>
            <p className="text-xs text-gray-600 mb-1">Proposed Dates</p>
            <p className="text-sm text-gray-900">{formatDate(getDateChangeStatusBadge().request.proposed_start_date)} to {formatDate(getDateChangeStatusBadge().request.proposed_end_date)}</p>
          </div>
        </div>
        {getDateChangeStatusBadge().request.reason && (
          <div className="mt-3">
            <p className="text-xs text-gray-600 ">Reason</p>
            <p className="text-sm text-gray-700">{getDateChangeStatusBadge().request.reason}</p>
          </div>
        )}
       
      </div>
    )}

    <div className="border-t pt-4">
      <p className="text-lg font-semibold text-gray-900 mb-3">Project Approval Copy</p>
      <div>
        {project.projectProof ? (
          <div className="rounded-xl border border-gray-200 bg-gray-50 p-4">
            {(() => {
              const proofPath = project.projectProof;
              const proofUrl = proofPath.startsWith('/') ? proofPath : `/${proofPath}`;
              const fileExtension = (proofPath.split('.').pop() || '').toLowerCase();
              const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];

              if (imageExtensions.includes(fileExtension)) {
                return <img src={proofUrl} alt="Project Approval Copy" className="w-full h-auto rounded-lg" />;
              }

              if (fileExtension === 'pdf') {
                return (
                  <div className="space-y-3">
                    <iframe src={proofUrl} className="w-full h-96 rounded-lg border-0" title="Project Approval Copy" />
                    <Button onClick={() => window.open(proofUrl, '_blank')} className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white">
                      Open PDF in New Tab
                    </Button>
                  </div>
                );
              }

              return (
                <div className="text-center py-6">
                  <FileText className="w-12 h-12 text-blue-500 mx-auto mb-3" />
                  <p className="text-sm text-gray-700 font-medium">Approval copy available</p>
                  <p className="text-xs text-gray-500 mt-1">Open the file from the project proof path</p>
                </div>
              );
            })()}
          </div>
        ) : (
          <div className="text-center py-6">
            <FolderKanban className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-sm text-gray-500">No approval copy available</p>
            <p className="text-xs text-gray-400 mt-1">
              The approved proposal copy has not been uploaded yet.
            </p>
          </div>
        )}
      </div>
    </div>
  </Card>
  
  {shouldShowNotes && (
    <Card className="rounded-[20px] border-0 shadow-sm p-6">
      <h2 className="text-lg font-semibold text-gray-900">
        {project.approvalStatus === 'Rejected' ? 'Rejection Notes' : 'Adviser Notes'}
      </h2>
      <div className={`rounded-xl p-4 ${
        project.approvalStatus === 'Rejected' ? 'bg-red-50' : 'bg-blue-50'
      }`}>
        <p className={`text-sm ${
          project.approvalStatus === 'Rejected' ? 'text-red-900' : 'text-blue-900'
        }`}>
          {project.note || (project.approvalStatus === 'Rejected' 
            ? 'No rejection reason provided.' 
            : 'No notes available.')}
        </p>
        <div className="mt-2 space-y-1">
          <p className={`text-xs ${
            project.approvalStatus === 'Rejected' ? 'text-red-600' : 'text-blue-600'
          }`}>
            - {project.approveBy || 'Not assigned'}
          </p>
          <p className={`text-xs ${
            project.approvalStatus === 'Rejected' ? 'text-red-600' : 'text-blue-600'
          }`}>
            - {project.approvedAt ? `Approved on ${new Date(project.approvedAt).toLocaleDateString()}` : 'Not yet approved'}
          </p>
        </div>
      </div>
    </Card>
  )}
</div>
      )}
      
      {/* Tab Content - Ledger */}
      {activeTab === 'ledger' && isApproved && (
        <div className="space-y-6">
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div className="flex items-center gap-2">
                <h2 className="text-lg font-semibold text-gray-900">Ledger Entries</h2>
                <Badge className={`rounded-lg ${
                  verificationStatus.status === 'tampering_detected' 
                    ? 'bg-red-100 text-red-700' 
                    : verificationStatus.status === 'error'
                    ? 'bg-yellow-100 text-yellow-700'
                    : 'bg-green-100 text-green-700'
                }`}>
                  <Shield className={`w-3 h-3 mr-1 ${
                    verificationStatus.status === 'tampering_detected' ? 'text-red-500' : 'text-green-500'
                  }`} />
                  {verificationStatus.status === 'tampering_detected' ? 'Tampered Alert' : 'Verified'}
                </Badge>
              </div>
             <Button 
  onClick={() => setShowAddLedgerModal(true)} 
  className={`rounded-xl transition-all ${
    isLedgerDisabled 
      ? 'bg-gray-400 cursor-not-allowed opacity-50' 
      : 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm hover:shadow-md'
  }`}
  disabled={isLedgerDisabled}
>
  <Plus className="w-4 h-4 mr-2" />
  Add Ledger Entry
</Button>
            </div>
            
            {loading ? (
              <div className="text-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
                <p className="text-gray-500 mt-2">Loading ledger entries...</p>
              </div>
            ) : ledgerEntries.length === 0 ? (
              <div className="text-center">
                <Wallet className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                            <p className="text-sm text-gray-500">No ledger entries found</p>
                            <p className="text-xs text-gray-400 mt-1 mb-4">Add your first transaction to get started</p>
              </div>
            ) : (
              <>
                {/* Pagination logic */}
                {(() => {
                  const totalLedgerPages = Math.ceil(ledgerEntries.length / ledgerItemsPerPage);
                  const indexOfLastLedgerItem = currentLedgerPage * ledgerItemsPerPage;
                  const indexOfFirstLedgerItem = indexOfLastLedgerItem - ledgerItemsPerPage;
                  const currentLedgerItems = ledgerEntries.slice(indexOfFirstLedgerItem, indexOfLastLedgerItem);
                  
                  return (
                    <>
                      {/* Desktop Table */}
                     {/* Desktop Table */}
<div className="hidden md:block overflow-x-auto">
  {/* Tampering Warning - Moved OUTSIDE the table */}
  {(isTampered || isBudgetTampered) && (
    <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
       <div className="flex items-start gap-2">
              <AlertCircle className="w-4 h-4 text-red-600 mt-0.5 flex-shrink-0" />
              <div>
                <p className="text-sm font-medium text-red-800">
                  {isTampered ? 'Security Alert.' : 'Budget Mismatch Alert.'}
                  <span className="text-xs text-red-600 ml-2">
                    {isTampered
                      ? ' A Ledger Entry has been Tampered. Please review the affected entries and contact system administrators immediately.'
                      : ' Ledger totals do not match the project budget. Ledger operations are disabled until the budget is reconciled.'
                    }
                  </span>
                </p>
        
  
              </div>
            </div>
    </div>
  )}
  
  <table className={`w-full ${isLedgerDisabled ? 'opacity-60 pointer-events-none' : ''}`}>
    <thead>
      <tr className="border-b border-gray-200 bg-blue-50">
        {['ID', 'Type', 'Amount', 'Description', 'Status', 'Actions'].map((h) => (
          <th key={h} className="text-left py-3 px-4 text-sm font-semibold text-gray-600">{h}</th>
        ))}
      </tr>
    </thead>
    <tbody>
      {currentLedgerItems.map((entry) => {
        const entryIsTampered = tamperedLedgerIds.has(entry.id);
        const isInitialEntry = (entry.type || '').toLowerCase() === 'initial';
        const isTransferEntry = (entry.category || '').toLowerCase() === 'transfer';
        const canManageEntry = (entry.approval_status === 'Draft' || entry.approval_status === 'Rejected') && !isLedgerDisabled && !isInitialEntry && !isTransferEntry;
        return (
          <tr
            key={entry.id}
            className={`${entryIsTampered ? 'border-b border-red-200 bg-red-50' : 'border-b border-gray-100 hover:bg-gray-50'}`}
          >
            <td className="py-3 px-4 font-mono text-sm text-gray-600">{entry.id.substring(0, 8)}...</td>
            <td className="py-3 px-4">
              <Badge className={getTypeColor(entry.type)}>
                {entry.type}
              </Badge>
            </td>
            <td className={`py-3 px-4 font-semibold text-gray-900 ${getTypeAmountColor(entry.type)}`}>
              ₱{formatLimitedNumber(parseFloat(entry.amount) || 0)}
            </td>
            <td className="py-3 px-4 max-w-[200px] truncate text-gray-700">
              {entry.description}
              {entryIsTampered && (
                <div className="mt-2 inline-flex items-center rounded-full bg-red-100 px-2 py-1 text-xs font-semibold text-red-700">
                  Tampered
                </div>
              )}
            </td>
            <td className="py-3 px-4">
              <div className="flex items-center gap-1">
                {getStatusIcon(entry.approval_status)}
                <Badge className={`rounded-lg ${getLedgerStatusColor(entry.approval_status)}`}>
                  {entry.approval_status}
                </Badge>
              </div>
            </td>
            <td className="py-3 px-4">
              <div className="flex gap-2">
                <Button variant="ghost" size="sm" onClick={() => { setSelectedLedger(entry); setShowLedgerDetails(true); }} className="rounded-lg">
                  <Eye className="w-4 h-4" />
                </Button>
                {canManageEntry && (
                  <>
                    <Button variant="ghost" size="sm" onClick={() => { console.log(' Desktop edit button clicked for entry:', entry.id); openEditLedgerModal(entry); }} className="rounded-lg">
                      <Edit className="w-4 h-4" />
                    </Button>
                    <Button variant="ghost" size="sm" onClick={() => { setLedgerToSubmit(entry); setShowSubmitLedgerModal(true); }} className="rounded-lg">
                      <Send className="w-4 h-4" />
                    </Button>
                    <Button variant="ghost" size="sm" onClick={() => handleDeleteClick(entry.id)} className="rounded-lg text-red-600 hover:text-red-700">
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </>
                )}
              </div>
            </td>
          </tr>
        );
      })}
    </tbody>
  </table>
</div>
                      
                      {/* Mobile Cards */}
                      <div className="md:hidden space-y-4">
  {/* Add tampering warning for mobile */}
  {(isTampered || isBudgetTampered) && (
    <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
      <p className="text-red-600 text-sm">
        {isTampered
          ? 'This Project Ledger has been Tampered. All transactions will be stopped.'
          : 'Budget mismatch detected. Ledger operations are disabled until the budget is corrected.'
        }
      </p>
    </div>
  )}
  
  {currentLedgerItems.map((entry) => {
    const entryIsTampered = tamperedLedgerIds.has(entry.id);
    const isInitialEntry = (entry.type || '').toLowerCase() === 'initial';
    const isTransferEntry = (entry.category || '').toLowerCase() === 'transfer';
    const canManageEntry = (entry.approval_status === 'Draft' || entry.approval_status === 'Rejected') && !isLedgerDisabled && !isInitialEntry && !isTransferEntry;
    return (
      <Card
        key={entry.id}
        className={`rounded-xl p-4 border shadow-sm ${entryIsTampered ? 'border-red-200 bg-red-50' : ''}`}
      >
        <div className="space-y-3">
          <div className="flex items-start justify-between gap-2">
            <span className="font-mono text-sm text-gray-600">{entry.id.substring(0, 8)}...</span>
            <div className="flex items-center gap-2">
              {entryIsTampered && (
                <Badge className="rounded-lg bg-red-100 text-red-700">
                  Tampered
                </Badge>
              )}
              <Badge className={`rounded-lg ${getLedgerStatusColor(entry.approval_status)}`}>
                {entry.approval_status}
              </Badge>
            </div>
          </div>
          <div className="flex items-center justify-between">
            <Badge className={`rounded-lg ${entry.type === 'Income' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
              {entry.type}
            </Badge>
            <span className="text-xl font-semibold text-gray-900">₱{formatLimitedNumber(parseFloat(entry.amount) || 0)}</span>
          </div>
          <div>
            <p className="text-sm text-gray-700">{entry.description}</p>
          </div>
          <div className="flex flex-wrap gap-2">
            <Button variant="outline" size="sm" onClick={() => { setSelectedLedger(entry); setShowLedgerDetails(true); }} className="rounded-lg flex-1">
              <Eye className="w-4 h-4 mr-1" />View
            </Button>
            {/* Only show action buttons if entry is Draft AND NOT disabled */}
            {canManageEntry && (
              <>
                <Button variant="outline" size="sm" onClick={() => { console.log('🖱️ Mobile edit button clicked for entry:', entry.id); openEditLedgerModal(entry); }} className="rounded-lg">
                  <Edit className="w-4 h-4" />
                </Button>
                <Button variant="outline" size="sm" onClick={() => { setLedgerToSubmit(entry); setShowSubmitLedgerModal(true); }} className="rounded-lg">
                  <Send className="w-4 h-4" />
                </Button>
                <Button variant="outline" size="sm" onClick={() => handleDeleteClick(entry.id)} className="rounded-lg text-red-600 hover:text-red-700">
                  <Trash2 className="w-4 h-4" />
                </Button>
              </>
            )}
          </div>
        </div>
      </Card>
    );
  })}
</div>
                      
                      {/* Pagination */}
                      {totalLedgerPages > 1 && (
                        <div className="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 rounded-lg mt-6">
                          <div className="flex flex-1 justify-between sm:hidden">
                            <Button
                              onClick={() => setCurrentLedgerPage(prev => Math.max(prev - 1, 1))}
                              disabled={currentLedgerPage === 1}
                              className="relative inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                              Previous
                            </Button>
                            <Button
                              onClick={() => setCurrentLedgerPage(prev => Math.min(prev + 1, totalLedgerPages))}
                              disabled={currentLedgerPage === totalLedgerPages}
                              className="relative ml-3 inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                              Next
                            </Button>
                          </div>
                          <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                            <div>
                              <p className="text-sm text-gray-700">
                                Showing {indexOfFirstLedgerItem + 1} to {Math.min(indexOfLastLedgerItem, ledgerEntries.length)} of {ledgerEntries.length} entries
                              </p>
                            </div>
                            <div>
                              <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                                <Button
                                  onClick={() => setCurrentLedgerPage(prev => Math.max(prev - 1, 1))}
                                  disabled={currentLedgerPage === 1}
                                  className="relative inline-flex items-center rounded-l-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                                >
                                  <span className="sr-only">Previous</span>
                                  <ChevronLeft className="h-5 w-5" />
                                </Button>
                                
                                {[...Array(totalLedgerPages)].map((_, i) => {
                                  const page = i + 1;
                                  const isCurrentPage = page === currentLedgerPage;
                                  
                                  if (
                                    page === 1 ||
                                    page === totalLedgerPages ||
                                    (page >= currentLedgerPage - 1 && page <= currentLedgerPage + 1)
                                  ) {
                                    return (
                                      <Button
                                        key={page}
                                        onClick={() => setCurrentLedgerPage(page)}
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
                                  
                                  if (page === currentLedgerPage - 2 || page === currentLedgerPage + 2) {
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
                                  onClick={() => setCurrentLedgerPage(prev => Math.min(prev + 1, totalLedgerPages))}
                                  disabled={currentLedgerPage === totalLedgerPages}
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
                    </>
                  );
                })()}
              </>
            )}
            
            {/* Summary Cards */}
            <div className="mt-6 grid grid-cols-1 md:grid-cols-2 gap-4">
              <Card className="rounded-xl p-4 bg-green-50 border-green-200">
                <p className="text-sm text-green-700 mb-1">Total Income</p>
                <p className="text-2xl font-semibold text-green-900">₱{formatLimitedNumber(totalIncome)}</p>
                <p className="text-xs text-green-600 mt-1">From approved transactions only</p>
              </Card>
              <Card className="rounded-xl p-4 bg-red-50 border-red-200">
                <p className="text-sm text-red-700 mb-1">Total Expenses</p>
                <p className="text-2xl font-semibold text-red-900">₱{formatLimitedNumber(totalExpenses)}</p>
                <p className="text-xs text-red-600 mt-1">From approved transactions only</p>
              </Card>
            </div>
          </Card>
        </div>
      )}
      
      {/* Tab Content - Proof */}
      {activeTab === 'proof' && isApproved && (
        <div className="space-y-6">
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
              <h2 className="text-lg font-semibold text-gray-900">Proof of Transactions</h2>
              {isEditable && (
                <Button onClick={() => setShowUploadProofModal(true)} className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white">
                  <Upload className="w-4 h-4 mr-2" />Upload Proof
                </Button>
              )}
            </div>
            
            {proofDocuments.length === 0 ? (
              <div className="text-center">
               <FileText className="w-12 h-12 text-gray-300 mx-auto mb-3"/>
               <p className="text-sm text-gray-500">No proof documents found</p>
             <p className="text-xs text-gray-400 mt-1 mb-4">Add your first proof document to get started</p>
              </div>
            ) : (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {proofDocuments.map((proof) => (
                  <Card key={proof.id} className="rounded-xl p-4 border shadow-sm hover:shadow-md transition-all">
                    <div className="space-y-3">
                      <div className="h-32 bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg flex items-center justify-center">
                        <FileText className="w-12 h-12 text-blue-600" />
                      </div>
                      <div>
                        <h3 className="font-medium text-gray-900 truncate mb-1">{proof.fileName}</h3>
                        <p className="text-xs text-gray-500">{proof.fileType} • {proof.fileSize}</p>
                      </div>
                      <div className="flex items-center gap-2">
                        <FileText className="w-4 h-4 text-blue-600 flex-shrink-0" />
                        <span className="text-xs text-gray-600 font-mono truncate">{proof.linkedTransaction.substring(0, 8)}...</span>
                      </div>
                      <Badge className={`rounded-lg ${proof.status === 'Approved' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'}`}>
                        {proof.status}
                      </Badge>
                      <p className="text-xs text-gray-400">Uploaded: {proof.uploadDate}</p>
                      <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={() => { setSelectedProof(proof); setShowProofViewer(true); }} className="flex-1 rounded-lg bg-blue-500 text-white hover:bg-blue-600">
                          <Eye className="w-4 h-4 mr-1" />View
                        </Button>
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            )}
          </Card>
        </div>
      )}
      
      {/* Tab Content - Status Timeline */}
      {activeTab === 'status' && (
        <div className="space-y-6">
  <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-br from-white to-purple-50">
    <h2 className="text-lg font-semibold text-gray-900 mb-6">Project Status Timeline</h2>
    
    {/* Scrollable container */}
    <div className="space-y-0 max-h-[500px] overflow-y-auto pr-2">
      {(statusHistory || []).map((item, index, arr) => (
        <div key={item.id} className="flex gap-4 items-start relative">
          <div className="flex flex-col items-center">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
              item.isCurrent ? 'bg-emerald-500 text-white' : item.isDone ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-600'
            }`}>
              {item.isDone || item.isCurrent ? <CheckCircle className="w-4 h-4" /> : <Clock className="w-4 h-4" />}
            </div>
            {index < arr.length - 1 && (
              <div className={`w-0.5 h-16 ${item.isDone ? 'bg-blue-400' : 'bg-gray-200'}`} />
            )}
          </div>
          <div className={`pb-6 flex-1 ${index !== arr.length - 1 ? 'border-b border-purple-100' : ''}`}>
            <div className="flex items-center justify-between gap-2">
              <p className="font-semibold text-gray-900">{item.label}</p>
              {item.isCurrent && <Badge className="bg-emerald-100 text-emerald-700">Current</Badge>}
            </div>
            <p className="text-sm text-gray-700">{item.description}</p>
            <p className="text-xs text-gray-500 mt-1">{item.date || '-'}</p>
          </div>
        </div>
      ))}
      {!statusHistory?.length && <p className="text-gray-500">No status history yet.</p>}
    </div>
  </Card>
</div>
      )}
      
      {/* Tab Content - Ratings */}
      {activeTab === 'ratings' && isApproved && (
        <div className="space-y-6">
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <h2 className="text-lg font-semibold text-gray-900">Student Ratings & Satisfaction</h2>
        
            
            {/* Average Rating Display */}
             <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-2">
              <div className="bg-blue-50 rounded-xl border border-blue-200 p-4 text-center">
                      <p className="text-xs text-blue-900 mb-1">Average</p>
                      <p className="text-2xl font-bold text-blue-500">{ratingsStats.totalRatings ? ratingsStats.averageRating.toFixed(1) : '0.0'}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {renderStars(ratingsStats.averageRating)}
                      </div>
                    </div>

             <div className="bg-blue-50 rounded-xl border border-blue-200 p-4 text-center">
                      <p className="text-xs text-blue-900 mb-1">Satisfaction</p>
                      <p className="text-2xl font-bold text-blue-500">{ratingsStats.totalRatings ? ratingsStats.satisfactionAverage.toFixed(1) : '0.0'}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {renderStars(ratingsStats.satisfactionAverage)}
                      </div>
                    </div>

             <div className="bg-blue-50 rounded-xl border border-blue-200 p-4 text-center">
                      <p className="text-xs text-blue-900 mb-1">Completeness</p>
                      <p className="text-2xl font-bold text-blue-500">{ratingsStats.totalRatings ? ratingsStats.completenessAverage.toFixed(1) : '0.0'}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {renderStars(ratingsStats.completenessAverage)}
                      </div>
                    </div>

             <div className="bg-blue-50 rounded-xl border border-blue-200 p-4 text-center">
                      <p className="text-xs text-blue-900 mb-1">Engagement</p>
                      <p className="text-2xl font-bold text-blue-500">{ratingsStats.totalRatings ? ratingsStats.engagementAverage.toFixed(1) : '0.0'}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {renderStars(ratingsStats.engagementAverage)}
                      </div>
                    </div>
                    
             </div>

            
            
            {/* Ratings List */}
            {ratings.length > 0 ? (
              <div className="space-y-6">
                {ratings.map((review) => (
                  <div key={review.id} className="flex gap-4 pb-6 border-b last:border-0">
                    <Avatar className="w-12 h-12 flex-shrink-0">
                      <AvatarFallback className="bg-blue-100 text-blue-700 text-sm">
                        {maskUserName(review.user_name)?.split(' ').map((n) => n[0]).join('') || 'U'}
                      </AvatarFallback>
                    </Avatar> 
                    <div className="flex-1">
                     
                         <h3 className="font-semibold text-gray-900">{maskUserName(review.user_name)}</h3>
                        <div className="flex flex-wrap items-center justify-between gap-2 mb-2">
                         
                          
                         <div className="flex flex-wrap items-center gap-1 md:gap-2">

                         <span className="text-xs text-gray-500 font-semibold">Satisfaction:</span>
                          <div className="flex">
                               {[...Array(5)].map((_, i) => (
                                 <Star key={i} className={`w-3 h-3 ${i < (review.satisfaction_rating || 0) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
                               ))}
                             </div>

                         <div className="flex-1 min-w-[100px] md:flex-none flex items-center gap-2">
                             <span className="text-xs text-gray-500 font-semibold">Completeness:</span>
                             <div className="flex">
                               {[...Array(5)].map((_, i) => (
                                 <Star key={i} className={`w-3 h-3 ${i < (review.completeness_rating || 0) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
                               ))}
                             </div>
                           </div>

                         <div className="flex-1 min-w-[100px] md:flex-none flex items-center gap-2">
                             <span className="text-xs text-gray-500 font-semibold">Engagement:</span>
                             <div className="flex">
                               {[...Array(5)].map((_, i) => (
                                 <Star key={i} className={`w-3 h-3 ${i < (review.engagement_rating || 0) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}`} />
                               ))}
                             </div>
                           </div>

                         </div>

                        </div>
                      
                      {/* date */}
                      <p className="text-xs text-gray-400 mb-2">{review.date || review.created_at}</p>
                      {review.comment && (
                        <p className="text-gray-700">{review.comment}</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            ) : (
             <div className="text-center">
               <Star className="w-12 h-12 text-gray-300 mx-auto mb-3"/>
               <p className="text-sm text-gray-500">No ratings yet</p>
             <p className="text-xs text-gray-400 mt-1 mb-4">Ratings will appear here once students rate this project</p>
              </div>
            )}
          </Card>
        </div>
      )}
      
      {/* ── Modals ── */}
      <Modal open={showLedgerDetails} onClose={() => { setShowLedgerDetails(false); setSelectedLedger(null); }} title="Ledger Entry Details">
  {selectedLedger && (
    <div className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div>
          <p className="text-sm text-gray-500 mb-1">Transaction ID *</p>
          <p className="font-mono text-sm text-gray-900 break-all">{selectedLedger.id}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Type *</p>
          <Badge className={`rounded-lg ${selectedLedger.type === 'Income' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
            {selectedLedger.type}
          </Badge>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Total Amount *</p>
          <p className="text-xl font-semibold text-blue-600">₱{formatLimitedNumber(parseFloat(selectedLedger.amount) || 0)}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Status * </p>
          <div className="flex items-center gap-1">
            {getStatusIcon(selectedLedger.approval_status)}
            <Badge className={`rounded-lg ${getLedgerStatusColor(selectedLedger.approval_status)}`}>
              {selectedLedger.approval_status}
            </Badge>
          </div>
        </div>
        
        <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Description *</p>
          <p className="text-gray-900">{selectedLedger.description}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Created By *</p>
          <p className="text-sm text-gray-900">{selectedLedger.created_by || 'N/A'}</p>
        </div>
        <div>
          <p className="text-sm text-gray-500 mb-1">Created At *</p>
          <p className="text-sm text-gray-900">{selectedLedger.created_at ? new Date(selectedLedger.created_at).toLocaleDateString() : 'N/A'}</p>
        </div>

        <div className="col-span-2">
          <p className="text-sm text-gray-500 mb-1">Transaction Budget Breakdown *</p>
          {selectedLedger.budgetBreakdown && selectedLedger.budgetBreakdown.length > 0 ? (
            <div className="bg-gray-50 rounded-lg p-3 mt-1">
              {/* Header */}
              <div className="flex justify-between items-center pb-2 mb-2 border-b border-gray-300">
                <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Item (Unit Price x Quantity)</span>
                <span className="text-xs font-semibold text-gray-600 uppercase tracking-wider">Amount</span>
              </div>
              
              {/* Items */}
              <div className="space-y-1">
                {selectedLedger.budgetBreakdown.map((item, index) => (
                  <div key={item.id || index} className="flex justify-between items-center py-1">
                    <div className="flex-1">
                      <span className="text-sm text-gray-900">{item.item}</span>
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
                  ₱{formatLimitedNumber(selectedLedger.budgetBreakdown.reduce((sum, item) => sum + (parseFloat(item.amount) || 0), 0))}
                </span>
              </div>
            </div>
          ) : (
            <p className="text-gray-500 mt-1">No budget breakdown for this transaction</p>
          )}
        </div>

        {/* ADD PROOF SECTION HERE */}
        <div className="col-span-2">
  <p className="text-sm text-gray-500 mb-1">Proof Document *</p>
  {selectedLedger.ledger_proof ? (
    <div className="bg-gray-50 rounded-lg p-3 mt-1">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3">
          <FileText className="w-8 h-8 text-blue-600" />
          <div>
            <p className="text-sm font-medium text-gray-900 truncate max-w-[200px] md:max-w-[400px]">
              {selectedLedger.ledger_proof.split('/').pop()}
            </p>
            <p className="text-xs text-gray-500">
              {selectedLedger.ledger_proof.split('.').pop().toUpperCase()} file
            </p>
          </div>
        </div>
        <Button 
          variant="outline" 
          size="sm" 
          onClick={() => setShowLedgerProofViewer(true)}
          className="rounded-lg bg-blue-600 hover:bg-blue-700 text-white"
        >
          <Eye className="w-4 h-4 mr-1" /> View
        </Button>
      </div>
    </div>
  ) : (
    <div className="flex items-center gap-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
                       <FileText className="w-5 h-5 text-yellow-600 flex-shrink-0" />
                       <p className="text-yellow-700 text-sm flex-1">No proof document provided</p>
                     </div>
  )}
</div>

        {/* note here */}
        {shouldShowNotes && (
          <div className="col-span-2">
            <p className="text-sm text-gray-500 mb-1">
              {selectedLedger.approval_status === 'Rejected' ? 'Rejection Notes *' : 'Approver Notes *'}
            </p>
            <div className={`rounded-lg p-4 ${
              selectedLedger.approval_status === 'Rejected' ? 'bg-red-50' : 'bg-blue-50'
            }`}>
              <p className={`text-sm ${
                selectedLedger.approval_status === 'Rejected' ? 'text-red-900' : 'text-blue-900'
              }`}>
                {selectedLedger.note || (selectedLedger.approval_status === 'Rejected' 
                  ? 'No rejection reason provided.' 
                  : 'No notes available.')}
              </p>
              <p className={`text-xs mt-2 ${
                selectedLedger.approval_status === 'Rejected' ? 'text-red-600' : 'text-blue-600'
              }`}>
                - {selectedLedger.approved_by || 'Not assigned'}
              </p>
              <p className={`text-xs mt-1 ${
                selectedLedger.approval_status === 'Rejected' ? 'text-red-600' : 'text-blue-600'
              }`}>
                - {selectedLedger.approved_at ? `Approved on ${new Date(selectedLedger.approved_at).toLocaleDateString()}` : 'Not yet approved'}
              </p>
            </div>
          </div>
        )}
      </div>
      <Button onClick={() => setShowLedgerDetails(false)} className="w-full rounded-xl" variant="outline">
        Close
      </Button>
    </div>
  )}
</Modal>

      <Modal open={showProofViewer} onClose={() => { setShowProofViewer(false); setSelectedProof(null); }} title="Proof Document">
        {selectedProof && (
          <div className="space-y-4 pt-6">
            <div className="bg-gray-100 rounded-xl p-6 flex flex-col items-center justify-center min-h-96 max-h-96 overflow-auto">
              {(() => {
                const filePath = selectedProof.filePath || selectedProof.file_path || selectedProof.path;
                
                // If no file path, show placeholder
                if (!filePath) {
                  return (
                    <div className="text-center">
                      <FileText className="w-16 h-16 text-gray-400 mb-4 mx-auto" />
                      <p className="text-gray-600 mb-2 font-medium">{selectedProof.fileName}</p>
                      <p className="text-sm text-gray-500">{selectedProof.fileType} • {selectedProof.fileSize}</p>
                      <p className="text-xs text-gray-400 mt-4">No preview available</p>
                    </div>
                  );
                }

                const proofUrl = filePath.startsWith('/') ? filePath : `/${filePath}`;
                const fileExtension = selectedProof.fileName.split('.').pop().toLowerCase();
                const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
                
                if (imageExtensions.includes(fileExtension)) {
                  return (
                    <img 
                      src={proofUrl} 
                      alt="Proof Document" 
                      className="max-w-full max-h-96 object-contain rounded-lg"
                      onError={(e) => {
                        console.error('Failed to load image:', proofUrl);
                        e.target.style.display = 'none';
                      }}
                    />
                  );
                } else if (fileExtension === 'pdf') {
                  return (
                    <iframe 
                      src={proofUrl} 
                      className="w-full h-96 rounded-lg border-0"
                      title="PDF Preview"
                      onError={() => {
                        console.error('Failed to load PDF:', proofUrl);
                      }}
                    />
                  );
                } else {
                  return (
                    <div className="text-center">
                      <FileText className="w-16 h-16 text-gray-400 mb-4 mx-auto" />
                      <p className="text-gray-600 mb-2 font-medium">{selectedProof.fileName}</p>
                      <p className="text-sm text-gray-500">{selectedProof.fileType} • {selectedProof.fileSize}</p>
                    </div>
                  );
                }
              })()}
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div><p className="text-sm text-gray-500 mb-1">Linked Transaction</p><p className="font-mono text-sm text-gray-900 break-all">{selectedProof.linkedTransaction}</p></div>
              <div><p className="text-sm text-gray-500 mb-1">Upload Date</p><p className="text-gray-900">{selectedProof.uploadDate}</p></div>
            </div>
            <div className="flex gap-3 pt-4">
              <Button 
                onClick={() => {
                  const filePath = selectedProof.filePath || selectedProof.file_path || selectedProof.path;
                  if (filePath) {
                    const proofUrl = filePath.startsWith('/') ? filePath : `/${filePath}`;
                    window.open(proofUrl, '_blank');
                  } else {
                    showToastMessage('No file available for download', 'error');
                  }
                }}
                className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
              >
                <Download className="w-4 h-4 mr-2" />Download
              </Button>
              <Button onClick={() => setShowProofViewer(false)} variant="outline" className="flex-1 rounded-xl">Close</Button>
            </div>
          </div>
        )}
      </Modal>

      {/* Modal for Ledger Proof Document Viewer */}
      <Modal open={showLedgerProofViewer} onClose={() => { setShowLedgerProofViewer(false); }} title="Proof Document">
        {selectedLedger?.ledger_proof && (
          <div className="space-y-4 pt-6">
            <div className="bg-gray-100 rounded-xl p-6 flex flex-col items-center justify-center min-h-96 max-h-96 overflow-auto">
              {(() => {
                const proofUrl = selectedLedger.ledger_proof.startsWith('/') 
                  ? selectedLedger.ledger_proof 
                  : `/${selectedLedger.ledger_proof}`;
                const fileExtension = selectedLedger.ledger_proof.split('.').pop().toLowerCase();
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
                        {selectedLedger.ledger_proof.split('/').pop()}
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
                <p className="font-mono text-sm text-gray-900 break-all">{selectedLedger.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Amount</p>
                <p className="text-gray-900">₱{formatLimitedNumber(parseFloat(selectedLedger.amount) || 0)}</p>
              </div>
            </div>
            <div className="flex gap-3 pt-4">
              <Button 
                className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                onClick={() => {
                  const proofUrl = selectedLedger.ledger_proof.startsWith('/') 
                    ? selectedLedger.ledger_proof 
                    : `/${selectedLedger.ledger_proof}`;
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

      {/* Modal for change date request */}
      <Modal open={showChangeDatesModal} onClose={() => setShowChangeDatesModal(false)} title="Request Change of Project Dates">
        <div className="space-y-4">
          <p className="text-sm text-gray-500">Select new proposed start and end dates for the project:</p>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Proposed Start Date</label>
              <input 
                type="date"
                value={proposedStartDate}
                min={getMinimumStartDate()}
                onChange={(e) => setProposedStartDate(e.target.value
                  
                )}
                className="w-full px-3 py-2 rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 border"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Proposed End Date</label>
              <input 
                type="date"
                min={getMinimumEndDate(proposedStartDate)}
                value={proposedEndDate}
                onChange={(e) => setProposedEndDate(e.target.value)}
                className="w-full px-3 py-2 rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 border"
              />
            </div>
          </div>
          {/* note why change the date of the project  */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Reason for Date Change</label>
            <textarea
              value={dateChangeReason}
              onChange={(e) => setDateChangeReason(e.target.value)}
              rows={4}
              className="w-full px-3 py-2 rounded-lg border-gray-300 shadow-sm focus:ring-blue-500 focus:border-blue-500 border"
              placeholder="Provide a reason for the date change request"
            />
          </div>

          <div className="flex gap-3 pt-4">
                        <Button onClick={() => setShowChangeDatesModal(false)} variant="outline" className="flex-1 rounded-xl">Cancel</Button>

            <Button onClick={handleSubmitDateChangeRequest} disabled={isSubmittingDateChange} className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white">
              {isSubmittingDateChange ? 'Submitting...' : 'Submit Request'}
            </Button>
          </div>
        </div>
      </Modal>

      {/* Edit Modals */}
      <EditProjectModal
        open={showEditModal}
        onClose={() => setShowEditModal(false)}
        editForm={editForm}
        setEditForm={setEditForm}
        editBudgetItems={editBudgetItems}
        setEditBudgetItems={setEditBudgetItems}
        onSave={handleEditProject}
        projectId={project.id}
      />
      
      <SubmitConfirmModal
        open={showSubmitConfirm}
        onClose={() => setShowSubmitConfirm(false)}
        onConfirm={handleSubmitForApproval}
      />
      
      <DeleteConfirmModal
        open={showDeleteConfirm}
        onClose={() => setShowDeleteConfirm(false)}
        onConfirm={handleDeleteProject}
        title="Delete Project"
        description="Are you sure you want to delete this project? This action cannot be undone."
      />
      
      {/* Ledger Delete Confirmation Modal */}
      <DeleteConfirmModal
        open={deleteLedgerModalOpen}
        onClose={() => {
          setDeleteLedgerModalOpen(false);
          setEntryToDelete(null);
        }}
        onConfirm={handleDeleteLedgerEntry}
        isDeleting={isDeleting}
        title="Delete Ledger Entry"
        description="Are you sure you want to delete this ledger entry? This action cannot be undone."
      />

      <SubmitLedgerConfirmModal
        open={showSubmitLedgerModal}
        onClose={() => { setShowSubmitLedgerModal(false); setLedgerToSubmit(null); }}
        onConfirm={() => handleSubmitLedgerForApproval(ledgerToSubmit?.id)}
        ledger={ledgerToSubmit}
      />
      
      <AddLedgerModal
        open={showAddLedgerModal}
        onClose={() => { setShowAddLedgerModal(false); resetLedgerForm(); }}
        ledgerForm={ledgerForm}
        setLedgerForm={setLedgerForm}
        onSave={handleAddLedgerEntry}
        projectId={project.id} 
      />
      
      <EditLedgerModal
        open={showEditLedgerModal}
        onClose={() => { console.log('❌ EditLedgerModal closed'); setShowEditLedgerModal(false); setSelectedLedger(null); }}
        ledgerForm={ledgerForm}
        setLedgerForm={setLedgerForm}
        onSave={handleLedgerEntryUpdate}
      />
      
      <UploadProofModal
        open={showUploadProofModal}
        onClose={() => { setShowUploadProofModal(false); setProofForm({ linkedTransaction: '', fileName: '', file: null }); }}
        proofForm={proofForm}
        setProofForm={setProofForm}
        ledgerEntries={ledgerEntries}
        onSave={handleUploadProof}
      />

      {/* Toast Notification */}
      {toast.show && (
        <div className={`fixed bottom-4 right-4 z-50 animate-slide-in ${
          toast.type === 'success' ? 'bg-blue-500' : 'bg-red-500'
        } text-white px-6 py-3 rounded-lg shadow-lg`}>
          {toast.message}
        </div>
      )}
    </div>
  );
}