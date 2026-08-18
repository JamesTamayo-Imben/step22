import { useState, useEffect } from 'react';
import { usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { StudentModal } from '@/Components/ui/StudentModal';
import { Chatbot } from '@/Components/ui/Chatbot';
import { ArrowLeft, FolderKanban, Star, Calendar, Wallet, FileText, CheckCircle, Clock3, Shield, XCircle } from 'lucide-react';

export default function StudentProjectDetails({ projectId, onBack, project }) {
  const { props } = usePage();
  const userPermissions = Array.isArray(props?.userPermissions)
    ? props.userPermissions
    : Array.isArray(props?.auth?.permissions)
      ? props.auth.permissions
      : [];

  const [currentProject, setCurrentProject] = useState(project);
  const [showRatingModal, setShowRatingModal] = useState(false);
  const [satisfactionRating, setSatisfactionRating] = useState(project?.currentUserRating?.satisfaction_rating || 0);
  const [completenessRating, setCompletenessRating] = useState(project?.currentUserRating?.completeness_rating || 0);
  const [engagementRating, setEngagementRating] = useState(project?.currentUserRating?.engagement_rating || 0);
  const [comment, setComment] = useState(project?.currentUserRating?.comment || '');
  const [hoveredSatisfactionRating, setHoveredSatisfactionRating] = useState(0);
  const [hoveredCompletenessRating, setHoveredCompletenessRating] = useState(0);
  const [hoveredEngagementRating, setHoveredEngagementRating] = useState(0);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [activeTab, setActiveTab] = useState('overview');
  const [activeRatingTab, setActiveRatingTab] = useState('satisfaction');
  const [selectedLedgerEntry, setSelectedLedgerEntry] = useState(null);
  const [selectedProofDocument, setSelectedProofDocument] = useState(null);
  const [selectedApprovalCopy, setSelectedApprovalCopy] = useState(null);
  const [showAllComments, setShowAllComments] = useState(false);

  const currentRoleName = props?.auth?.user?.role?.name || props?.auth?.user?.role_name || props?.role?.name || '';
  const isSuperAdmin = ['Super Admin', 'superadmin', 'Superadmin'].includes(currentRoleName);

  // Check permissions
  const canViewRatings = userPermissions.includes('ratings.view');
  const canSubmitRatings = userPermissions.includes('ratings.submit') && !isSuperAdmin;

  useEffect(() => {
    if (!canViewRatings && activeTab === 'ratings') {
      setActiveTab('overview');
    }
  }, [canViewRatings, activeTab]);

  // Check if user has already rated this project
  const hasUserRated = currentProject?.currentUserRating !== null && currentProject?.currentUserRating !== undefined;
  
  // Disable rating button if user has already rated
  const isRatingDisabled = hasUserRated;

  // Sync state with project prop whenever it changes
  useEffect(() => {
    setCurrentProject(project);
    // Update rating state if project has existing rating
    if (project?.currentUserRating) {
      setSatisfactionRating(project.currentUserRating.satisfaction_rating || 0);
      setCompletenessRating(project.currentUserRating.completeness_rating || 0);
      setEngagementRating(project.currentUserRating.engagement_rating || 0);
      setComment(project.currentUserRating.comment || '');
    }  }, [project]);

  const getProofUrl = (path) => {
    if (!path) return '#';
    if (path.startsWith('http://') || path.startsWith('https://') || path.startsWith('/')) return path;
    return `/${path}`;
  };

  const renderProofPreview = (proofPath, altText = 'Proof Document') => {
    if (!proofPath) return null;

    const proofUrl = getProofUrl(proofPath);
    const fileExtension = (proofPath.split('.').pop() || '').toLowerCase();
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];

    if (imageExtensions.includes(fileExtension)) {
      return <img src={proofUrl} alt={altText} className="w-full h-auto max-h-[420px] object-contain rounded-lg" />;
    }

    if (fileExtension === 'pdf') {
      return (
        <div className="space-y-3">
          <iframe src={proofUrl} className="w-full h-[420px] rounded-lg border-0" title={altText} />
          <a href={proofUrl} target="_blank" rel="noreferrer" className="inline-flex items-center bg-blue-600 text-white rounded-lg border border-blue-300 px-3 py-2 text-sm font-medium hover:bg-blue-700">
            Open PDF in new tab
          </a>
        </div>
      );
    }

    return (
      <div className="rounded-xl border border-gray-200 bg-gray-50 p-6 text-center">
        <FileText className="w-12 h-12 text-gray-400 mx-auto mb-3" />
        <p className="text-sm font-medium text-gray-700">Preview unavailable</p>
        <p className="text-xs text-gray-500 mt-1">This file type cannot be previewed inline.</p>
      </div>
    );
  };

  const getProjectApprovalProof = () => {
    const candidate = currentProject?.project_proof || currentProject?.projectProof || currentProject?.approval_copy || currentProject?.approvalCopy || null;
    if (!candidate) return null;
    return typeof candidate === 'string' ? candidate : null;
  };

  // Calculate project status based on approval status and dates
  const getCalculatedStatus = () => {
    // If not approved yet, show as Draft
    if (currentProject.approvalStatus !== 'Approved' && currentProject.approval_status !== 'Approved') {
      return 'Draft';
    }
    
    // If approved, calculate status based on dates
    const startDate = currentProject.startDate || currentProject.start_date;
    const endDate = currentProject.endDate || currentProject.end_date;

    //if the bidget becomes negative note
    const ifBudgetNegative = currentProject.budget < 0;
    
    if (!startDate || !endDate) {
      return 'Draft';
    }
    
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const start = new Date(startDate);
      const end = new Date(endDate);
      start.setHours(0, 0, 0, 0);
      end.setHours(0, 0, 0, 0);
      
      // Check if dates are valid
      if (isNaN(start.getTime()) || isNaN(end.getTime())) {
        return 'Draft';
      }
       
      if (today < start) {
        return 'Upcoming';
      } else if (today > end) {
        return 'Completed';
      } else if (today >= start && today <= end) {
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
      case 'Draft':
        return 'bg-gray-100 text-gray-700';
      case 'Upcoming':
        return 'bg-purple-100 text-purple-700';
      case 'Ongoing':
        return 'bg-blue-100 text-blue-700';
      case 'Completed':
        return 'bg-green-100 text-green-700';
      case 'Pending Adviser Approval':
        return 'bg-yellow-100 text-yellow-700';
      case 'Approved':
        return 'bg-blue-100 text-blue-700';
      case 'Rejected':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getStatusBadgeColor = (type) => {
    switch (type) {
      case 'Draft':
        return 'bg-gray-200 text-gray-700';
      case 'Upcoming':
        return 'bg-purple-200 text-purple-700';
      case 'Ongoing':
        return 'bg-blue-200 text-blue-700';
      case 'Completed':
        return 'bg-green-200 text-green-700';
      case 'Pending Adviser Approval':
        return 'bg-yellow-200 text-yellow-700';
      case 'Approved':
        return 'bg-blue-200 text-blue-700';
      case 'Rejected':
        return 'bg-red-200 text-red-700';
      default:
        return 'bg-gray-200 text-gray-700';
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

    const getTypeColor = (type) => {
  switch (type) {
    case 'Expense': return 'bg-red-100 text-red-700';
    case 'Income': return 'bg-green-100 text-green-700';
    case 'Donation': return 'bg-blue-100 text-blue-700';
    case 'Sponsorship': return 'bg-purple-100 text-purple-700';
    case 'Canvas': return 'bg-gray-100 text-gray-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

  const handleSubmitRating = async () => {
    if (!canSubmitRatings) return;
    if (!satisfactionRating) return;

    setIsSubmitting(true);
    try {
      const response = await fetch(`/user/projects/${projectId}/ratings`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        body: JSON.stringify({ 
          satisfaction_rating: satisfactionRating, 
          completeness_rating: completenessRating,
          engagement_rating: engagementRating,
          comment 
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to submit rating');
      }

      window.location.reload();
    } catch (error) {
      console.error(error);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!project) {
    return (
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <p className="text-gray-600">Project not found.</p>
      </Card>
    );
  }

  return (
    <div className="space-y-6">
      {/* Back Button */}
      <button
        onClick={onBack}
        className="flex items-center gap-2 px-4 py-2 text-gray-700 hover:text-blue-600 rounded-xl transition-colors"
      >
        <ArrowLeft className="w-4 h-4" />
        Back to Projects
      </button>

      {/* Project Header */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col lg:flex-row gap-6">
          <div className="flex-1 space-y-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 mb-2">{currentProject.title}</h1>
              <div className="flex flex-wrap gap-2 mb-3">
                <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">
                  {currentProject.category || 'General'}
                </Badge>
                {currentProject.tamperedAlerts > 0 ? (
                  <Badge className="bg-red-100 text-red-700 rounded-lg">
                    <XCircle className="w-3 h-3 mr-1" />{currentProject.tamperedAlerts} Tampered
                  </Badge>
                ) : (
                  <Badge className="bg-green-100 text-green-700 rounded-lg">
                    <Shield className="w-3 h-3 mr-1" />Verified
                  </Badge>
                )}
                <Badge className={getStatusColor(getCalculatedStatus())}>
                  {getCalculatedStatus()}
                </Badge>
              </div>
              <p className="text-gray-600 leading-relaxed">{currentProject.description || 'No details available.'}</p>
            </div>

      

            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-2">
              {canViewRatings ? (
                <div className="flex items-center gap-3">
                  {(() => {
                    const ratings = currentProject.ratings || [];
                    const satisfactionAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.satisfaction_rating || 0), 0) / ratings.length) : 0;
                    const completenessAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.completeness_rating || 0), 0) / ratings.length) : 0;
                    const engagementAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.engagement_rating || 0), 0) / ratings.length) : 0;
                    const overallAvg = ratings.length ? (satisfactionAvg + completenessAvg + engagementAvg) / 3 : 0;
                    
                    return (
                      <>
                        <div className="flex items-center gap-1">
                          {[...Array(5)].map((_, i) => (
                            <Star
                              key={i}
                              className={`w-5 h-5 ${
                                i < Math.floor(overallAvg)
                                  ? 'fill-yellow-400 text-yellow-400' 
                                  : 'text-gray-300'
                              }`}
                            />
                          ))}
                        </div>
                        <span className="font-semibold text-gray-900">{overallAvg.toFixed(2)}</span>
                        <span className="text-sm text-gray-500">({ratings.length} ratings)</span>
                      </>
                    );
                  })()}
                </div>
              ) : null}

              {/* Rating Button*/}
                {canSubmitRatings ? (
                  <div className="flex flex-col items-end gap-2">
                    <button
                      onClick={() => setShowRatingModal(true)}
                      disabled={isRatingDisabled}
                      className={`flex items-center gap-2 px-4 py-2 
                         disabled:bg-gray-400 disabled:hover:bg-gray-400 
       disabled:text-gray-200
                        rounded-xl transition-colors bg-blue-600 hover:bg-blue-700 text-white`}
                    >
                      <Star className="w-4 h-4" />
                      {isRatingDisabled ? 'Already Rated' : 'Rate this Project'}
                    </button>
                    {isRatingDisabled && (
                      <p className="text-xs text-yellow-600">
                        You have already rated this project. Thank you!
                      </p>
                    )}
                  </div>
                ) : null}
            
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">
          <div className="bg-blue-50 rounded-xl p-4">
            <Calendar className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Start Date</p>
            <p className="text-lg font-semibold text-gray-900">{currentProject.startDate || 'N/A'}</p>
          </div>
          <div className="bg-blue-50 rounded-xl p-4">
            <Calendar className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">End Date</p>
            <p className="text-lg font-semibold text-gray-900">{currentProject.endDate || 'N/A'}</p>
          </div>
         <div className="bg-blue-50 rounded-xl p-4">
  <Wallet className="w-5 h-5 text-blue-600 mb-2" />
  <p className="text-sm text-gray-600">Budget</p>
  <p className={`text-2xl font-bold ${Number(currentProject.budget || 0) < 0 ? 'text-red-600' : 'text-gray-900'}`}>
    ₱{Number(currentProject.budget || 0).toLocaleString()}
  </p>
  {Number(currentProject.budget || 0) < 0 && (
    <p className="text-xs text-red-600 mt-1">
      Don't worry, the Budget is Negative because of the expenses. No need to panic!
    </p>
  )}
</div>
          <div className="bg-blue-50 rounded-xl p-4">
            <Star className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Approval</p>
            <p className="text-lg font-semibold text-gray-900">{currentProject.approvalStatus || 'Pending'}</p>
          </div>
        </div>
      </Card>

      <div className="flex flex-wrap gap-2 bg-white rounded-xl p-2 shadow-sm border border-gray-100">
        {['overview', 'ledger', 'proof', 'status timeline', canViewRatings && 'ratings'].filter(Boolean).map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 rounded-lg font-medium transition-all capitalize ${
              activeTab === tab ? 'bg-blue-600 text-white' : 'text-gray-600 hover:bg-gray-100'
            }`}
          >
            {tab}
          </button>
        ))}
      </div>

      {activeTab === 'overview' && (
        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-br from-white to-blue-50">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Overview</h2>

          <div className="grid grid-cols-1 md:grid-cols-1 gap-6">
          <div className="rounded-2xl border border-blue-100 bg-white p-4 md:p-5">
            <div className="mt-4 grid grid-cols-1 md:grid-cols-2 gap-3">
              <div className='col-span-2 mb-4'>
              <p className='text-sm text-gray-500 mb-1'>Project Objective *</p>
            <p className="text-gray-900">{currentProject.objective || 'No objective available.'}</p>
            </div>
             <div className='mb-4'>
              <p className='text-sm text-gray-500 mb-1'>Project Proposer *</p>
              <p className="text-gray-900">{currentProject.proposeBy || 'N/A'}</p>
            </div>
             <div className='mb-4'>
              <p className='text-sm text-gray-500 mb-1'>Approved By</p>
              <p className="text-gray-900">{currentProject.approvedBy || 'CSG Adviser'}</p>
            </div>
              <div className="mb-4">
                <p className="text-xs text-gray-500">Category</p>
                <p className="text-sm font-semibold text-gray-900 mt-1">{currentProject.category || 'General'}</p>
              </div>
              <div className="mb-4">
                <p className="text-xs text-gray-500">Venue</p>
                <p className="text-sm font-semibold text-gray-900 mt-1">{currentProject.venue || 'Not specified'}</p>
              </div>
            </div>
          </div>

           <div className="col-span-full">
                        <div className="flex items-center justify-between gap-3">
                          <p className="text-lg font-semibold text-gray-900">Project Approval Copy</p>
                          {/* {getProjectApprovalProof() && (
                            <button
                              type="button"
                              onClick={() => setSelectedApprovalCopy({
                                path: getProjectApprovalProof(),
                                fileName: 'Project Approval Copy',
                                description: 'Approved proposal copy uploaded by the adviser.'
                              })}
                              className="text-sm font-medium text-blue-700 hover:text-blue-800"
                            >
                              View in modal
                            </button>
                          )} */}
                        </div>
                        <div className="mt-3">
                          {getProjectApprovalProof() ? (
                            <div className="rounded-xl border border-blue-100 bg-white p-4">
                              {(() => {
                                const proofPath = getProjectApprovalProof();
                                return renderProofPreview(proofPath, 'Project Approval Copy');
                              })()}
                            </div>
                          ) : (
                            <div className="text-center mt-6">
                      <FolderKanban className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                    <p className="text-sm text-gray-500">No approval copy available</p>
                      <p className="text-xs text-gray-400 mt-1 mb-4">
                        The approved proposal copy has not been uploaded yet.
                      </p>
                    </div>
                          )}
                        </div>
                      </div>
          </div>

        </Card>
      )}

      {activeTab === 'ledger' && (
        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          
          <h2 className="text-xl font-bold text-gray-900 mb-4">Ledger Entries Record</h2>

          {/* Tamper Alert */}
      {currentProject.tamperedAlerts > 0 && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <XCircle className="w-5 h-5 text-red-600 mt-0.5" />
            <div className="flex-1">
              <h4 className="text-sm font-medium text-red-800">Data Tampering Detected</h4>
              <p className="text-sm text-red-700 mt-1">
                {currentProject.tamperedAlerts} ledger entr{currentProject.tamperedAlerts === 1 ? 'y' : 'ies'} in this project {currentProject.tamperedAlerts === 1 ? 'has' : 'have'} been modified after approval. Contact your adviser for assistance.
              </p>
            </div>
          </div>
        </div>
      )}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {(currentProject.ledgerEntries || []).map((entry) => (
              <button
                key={entry.id}
                onClick={() => setSelectedLedgerEntry(entry)}
                className={`rounded-xl border p-4 ${
                  getTypeColor(entry.type)
                } text-left hover:shadow-md transition-shadow`}
              >
                <div className="flex items-start justify-between gap-3 mb-3">
                  <div>
                    <p className="text-xs text-gray-500">Transaction ID</p>
                    <p className="font-mono text-xs text-gray-700">{entry.id}</p>
                  </div>
                  <Badge className={getTypeColor(entry.type)}>
                    {entry.type}
                  </Badge>
                </div>
                <div className="flex items-center gap-2 mb-2">
                  <Wallet className="w-4 h-4 text-gray-700" />
                  <p className="text-lg font-bold text-gray-900">₱{Number(entry.amount || 0).toLocaleString()}</p>
                </div>
                <p className="text-sm text-gray-700 mb-3 truncate">{entry.description || '-'}</p>
                <div className="flex items-center justify-between text-xs">
                  <span className="px-2 py-1 rounded-md bg-white text-gray-700 border">{entry.approvalStatus}</span>
                  <span className="text-gray-600">{entry.createdAt || '-'}</span>
                </div>
              </button>
            ))}
          </div>
          {!currentProject.ledgerEntries?.length && 
          <div className="text-center">
                         <Wallet className="w-12 h-12 text-gray-300 mx-auto mb-3"/>
                         <p className="text-sm text-gray-500">No ledger entries yet</p>
                       <p className="text-xs text-gray-400 mt-1 mb-4">Add your first ledger entry to get started</p>
                        </div>
          }
        </Card>
      )}

      {activeTab === 'proof' && (
        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-br from-white to-blue-50">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Project Transaction Proof</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {(currentProject.proofDocuments || []).map((proof) => (
              <button
                key={proof.id}
                onClick={() => setSelectedProofDocument(proof)}
                className="border border-blue-100 bg-white rounded-xl p-4 text-left hover:shadow-md transition-shadow"
              >
               <div className="flex items-center gap-2 mb-3">
  <FileText className="w-4 h-4 text-blue-600 flex-shrink-0" />
  <div className="min-w-0 flex-1">
    <p className="font-medium text-gray-900 truncate">{proof.fileName}</p>
    <p className="text-xs text-gray-500 truncate">Linked: {proof.linkedTransaction}</p>
  </div>
</div>
                <div className="flex items-center justify-between">
                  <p className="text-xs text-gray-500">{proof.uploadDate}</p>
                  <div className="flex items-center gap-2">
                    <button
                      type="button"
                      className="text-xs px-2 py-1 rounded-md border border-blue-300 text-white bg-blue-600 hover:bg-blue-700"
                      onClick={(e) => {
                        e.stopPropagation();
                        setSelectedProofDocument(proof);
                      }}
                    >
                      View Proof
                    </button>
                    <Badge className="bg-green-100 text-green-700">{proof.status}</Badge>
                  </div>
                </div>
              </button>
            ))}
            {!currentProject.proofDocuments?.length && 
            <div className="text-center md:col-span-2">
                           <FileText className="w-12 h-12 text-gray-300 mx-auto mb-3"/>
                           <p className="text-sm text-gray-500">No proof documents found</p>
                         <p className="text-xs text-gray-400 mt-1 mb-4">Add your first proof document to get started</p>
                          </div>
            }
          </div>
        </Card>
      )}

      {activeTab === 'status timeline' && (
        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-br from-white to-purple-50">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Status Timeline</h2>
          <div className="space-y-0">
            {(currentProject.statusTimeline || []).map((item, index, arr) => (
              <div key={item.id} className="flex gap-4 items-start relative">
                <div className="flex flex-col items-center">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                    item.isCurrent ? 'bg-emerald-500 text-white' : item.isDone ? 'bg-blue-500 text-white' : 'bg-gray-200 text-gray-600'
                  }`}>
                    {item.isDone || item.isCurrent ? <CheckCircle className="w-4 h-4" /> : <Clock3 className="w-4 h-4" />}
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
            {!currentProject.statusTimeline?.length && <p className="text-gray-500">No status history yet.</p>}
          </div>
        </Card>
      )}

      {activeTab === 'ratings' && (
        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-gradient-to-br from-white to-yellow-50">
          <div className="space-y-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">Project Ratings</h2>
              
              {/* Calculate averages */}
              {(() => {
                const ratings = currentProject.ratings || [];
                const satisfactionAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.satisfaction_rating || 0), 0) / ratings.length).toFixed(2) : '0';
                const completenessAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.completeness_rating || 0), 0) / ratings.length).toFixed(2) : '0';
                const engagementAvg = ratings.length ? (ratings.reduce((sum, r) => sum + (r.engagement_rating || 0), 0) / ratings.length).toFixed(2) : '0';
                const overallAvg = ratings.length ? ((parseFloat(satisfactionAvg) + parseFloat(completenessAvg) + parseFloat(engagementAvg)) / 3).toFixed(2) : '0';
                const filledStars = Math.floor(parseFloat(overallAvg));

                return (
                  <div className="grid grid-cols-3 gap-3 mb-6">
                    <div className="bg-white rounded-xl border border-blue-100 p-4 text-center">
                      <p className="text-xs text-gray-500 mb-1">Satisfaction</p>
                      <p className="text-2xl font-bold text-gray-900">{satisfactionAvg}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {[...Array(5)].map((_, i) => (
                          <Star key={i} className={`w-3 h-3 ${i < Math.floor(parseFloat(satisfactionAvg)) ? 'fill-blue-400 text-blue-400' : 'text-gray-300'}`} />
                        ))}
                      </div>
                    </div>
                    <div className="bg-white rounded-xl border border-green-100 p-4 text-center">
                      <p className="text-xs text-gray-500 mb-1">Completeness</p>
                      <p className="text-2xl font-bold text-gray-900">{completenessAvg}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {[...Array(5)].map((_, i) => (
                          <Star key={i} className={`w-3 h-3 ${i < Math.floor(parseFloat(completenessAvg)) ? 'fill-green-400 text-green-400' : 'text-gray-300'}`} />
                        ))}
                      </div>
                    </div>
                    <div className="bg-white rounded-xl border border-red-100 p-4 text-center">
                      <p className="text-xs text-gray-500 mb-1">Engagement</p>
                      <p className="text-2xl font-bold text-gray-900">{engagementAvg}</p>
                      <div className="flex justify-center gap-1 mt-2">
                        {[...Array(5)].map((_, i) => (
                          <Star key={i} className={`w-3 h-3 ${i < Math.floor(parseFloat(engagementAvg)) ? 'fill-red-400 text-red-400' : 'text-gray-300'}`} />
                        ))}
                      </div>
                    </div>
                  </div>
                );
              })()}
            </div>

            {/* Rating Type Tabs - REMOVED */}
            {/* Now showing all ratings at once */}
          </div>
          
          <div className="space-y-6">
            {(showAllComments ? (currentProject.ratings || []) : (currentProject.ratings || []).slice(0, 5)).map((review) => {
              return (
                <div key={review.id} className="flex gap-4 pb-6 border-b  last:border-0">
                  <div className="w-12 h-12 rounded-full bg-blue-600 flex items-center justify-center flex-shrink-0">
                    <span className="text-sm font-bold text-white">
                      {(review.user?.name || 'U')
                        .split(' ')
                        .map((n) => n[0])
                        .join('')}
                    </span>
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900">{maskUserName(review.user?.name) || 'Unknown User'}</h3>
                    
                    {/* Display all three ratings */}
                    <div className="flex flex-wrap items-center gap-1 md:gap-2">
  <div className="flex-1 min-w-[100px] md:flex-none flex items-center gap-2">
    <span className="text-xs text-gray-500 font-semibold">Satisfaction:</span>
    <div className="flex">
      {[...Array(5)].map((_, i) => (
        <Star key={i} className={`w-3 h-3 ${i < (review.satisfaction_rating || 0) ? 'fill-blue-400 text-blue-400' : 'text-gray-300'}`} />
      ))}
    </div>
    {/* <span className="text-xs text-gray-600">{review.satisfaction_rating || 0}/5</span> */}
  </div>
  
  <div className="flex-1 min-w-[100px] md:flex-none flex items-center gap-2">
    <span className="text-xs text-gray-500 font-semibold">Completeness:</span>
    <div className="flex">
      {[...Array(5)].map((_, i) => (
        <Star key={i} className={`w-3 h-3 ${i < (review.completeness_rating || 0) ? 'fill-green-400 text-green-400' : 'text-gray-300'}`} />
      ))}
    </div>
    {/* <span className="text-xs text-gray-600">{review.completeness_rating || 0}/5</span> */}
  </div>
  
  <div className="flex-1 min-w-[100px] md:flex-none flex items-center gap-2">
    <span className="text-xs text-gray-500 font-semibold">Engagement:</span>
    <div className="flex">
      {[...Array(5)].map((_, i) => (
        <Star key={i} className={`w-3 h-3 ${i < (review.engagement_rating || 0) ? 'fill-red-400 text-red-400' : 'text-gray-300'}`} />
      ))}
    </div>
    {/* <span className="text-xs text-gray-600">{review.engagement_rating || 0}/5</span> */}
  </div>
                    </div>
                    
                    <p className="text-xs text-gray-500 mt-2">{review.date || ''}</p>
                    <p className="text-gray-700 mt-2">{review.comment || 'No comment provided.'}</p>
                    <div className="mt-2">
                      {/* <span className="inline-flex items-center text-xs px-2 py-1 rounded-md bg-white border border-yellow-200 text-yellow-700">
                        Helpful {review.helpful_count || 0}
                      </span> */}
                    </div>
                  </div>
                </div>
              );
            })}
            {(currentProject.ratings || []).length > 5 && (
              <button
                onClick={() => setShowAllComments((prev) => !prev)}
                className="px-4 py-2 text-sm font-medium rounded-lg border border-yellow-300 bg-white hover:bg-yellow-50 text-yellow-700"
              >
                {showAllComments ? 'Show less comments' : `More comments (${(currentProject.ratings || []).length - 5})`}
              </button>
            )}
            {!currentProject.ratings?.length && 
           <div className="text-center">
                          <Star className="w-12 h-12 text-gray-300 mx-auto mb-3"/>
                          <p className="text-sm text-gray-500">No ratings yet</p>
                        <p className="text-xs text-gray-400 mt-1 mb-4">Ratings will appear here once students rate this project</p>
                         </div>
            }
          </div>
        </Card>
      )}

      <StudentModal
        isOpen={!!selectedLedgerEntry}
        onClose={() => setSelectedLedgerEntry(null)}
        title="Ledger Entry Details"
      >
        {selectedLedgerEntry && (
          <div className="space-y-4 pt-2">
            <div className={`rounded-2xl p-4 border ${selectedLedgerEntry.type === 'Income' ? 'bg-green-50 border-green-200' : 'bg-red-50 border-red-200'}`}>
              <div className="flex items-center justify-between">
                <p className="font-semibold text-gray-900">{selectedLedgerEntry.type} Entry</p>
                <Badge className="bg-white text-gray-700 border">{selectedLedgerEntry.approvalStatus || '-'}</Badge>
              </div>
              <p className="text-2xl font-bold text-gray-900 mt-2">₱{Number(selectedLedgerEntry.amount || 0).toLocaleString()}</p>
              <p className="text-xs text-gray-600 mt-1">Transaction ID: {selectedLedgerEntry.id}</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
              <div className="rounded-xl border bg-gray-50 p-3"><p className="text-xs text-gray-500">Created</p><p className="font-medium text-gray-900">{selectedLedgerEntry.createdAt || '-'}</p></div>
              <div className="rounded-xl border bg-gray-50 p-3"><p className="text-xs text-gray-500">Approved</p><p className="font-medium text-gray-900">{selectedLedgerEntry.approvedAt || '-'}</p></div>
              <div className="rounded-xl border bg-gray-50 p-3"><p className="text-xs text-gray-500">Approved By</p><p className="font-medium text-gray-900">{selectedLedgerEntry.approvedBy || '-'}</p></div>
            </div>

            <div className="rounded-xl border bg-white p-4">
              <p className="text-xs text-gray-500 mb-1">Description</p>
              <p className="text-sm text-gray-800">{selectedLedgerEntry.description || '-'}</p>
            </div>

            <div className="rounded-xl border bg-white p-4">
              <p className="text-xs text-gray-500 mb-1">Remarks</p>
              <p className="text-sm text-gray-800">{selectedLedgerEntry.note || '-'}</p>
            </div>

            <div className="flex items-center justify-between rounded-xl bg-blue-50 border border-blue-100 p-3">
              <p className="text-sm text-blue-800">Supporting proof file</p>
              <a
                href={getProofUrl(selectedLedgerEntry.ledgerProof)}
                target="_blank"
                rel="noreferrer"
                className="text-xs px-3 py-1.5 rounded-md border border-blue-300 text-blue-700 hover:bg-blue-100"
              >
                Open Proof
              </a>
            </div>
          </div>
        )}
      </StudentModal>

      <StudentModal
        isOpen={!!selectedApprovalCopy}
        onClose={() => setSelectedApprovalCopy(null)}
        title="Project Approval Copy"
      >
        {selectedApprovalCopy && (
          <div className="space-y-4 pt-2">
            <div className="rounded-2xl bg-blue-50 border border-blue-200 p-4">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="font-semibold text-gray-900">{selectedApprovalCopy.fileName || 'Project Approval Copy'}</p>
                  <p className="text-xs text-gray-600 mt-1">Approved proposal copy uploaded by the adviser.</p>
                </div>
              </div>
            </div>

            <div className="rounded-xl border border-blue-100 bg-white p-3">
              {renderProofPreview(selectedApprovalCopy.path, 'Project Approval Copy')}
            </div>

            <div className="flex items-center justify-between rounded-xl bg-blue-50 border border-blue-100 p-3">
              <p className="text-sm text-blue-800">Open uploaded approval copy</p>
              <a
                href={getProofUrl(selectedApprovalCopy.path)}
                target="_blank"
                rel="noreferrer"
                className="text-xs px-3 py-1.5 rounded-md border border-blue-300 text-blue-700 hover:bg-blue-100"
              >
                View File
              </a>
            </div>
          </div>
        )}
      </StudentModal>

      <StudentModal
        isOpen={!!selectedProofDocument}
        onClose={() => setSelectedProofDocument(null)}
        title="Proof Document Details"
      >
        {selectedProofDocument && (
          <div className="space-y-4 pt-2">
            <div className="rounded-2xl bg-blue-50 border border-blue-200 p-4">
              <div className="flex items-start justify-between gap-3">
                <div className="">
                  <div className="flex flex-col max-w-48">
                    <p className="font-semibold text-gray-900 truncate">{selectedProofDocument.fileName || 'Proof Document'}</p>
                  </div>
                  <div>
                    <p className="text-xs text-gray-600 mt-1">Document ID: {selectedProofDocument.id}</p>
                  </div>
                </div>
                <Badge className="bg-blue-100 text-blue-700">{selectedProofDocument.status || '-'}</Badge>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 text-sm">
              <div className="rounded-xl border bg-gray-50 p-3"><p className="text-xs text-gray-500">Linked Transaction</p><p className="font-medium text-gray-900">{selectedProofDocument.linkedTransaction || '-'}</p></div>
              <div className="rounded-xl border bg-gray-50 p-3"><p className="text-xs text-gray-500">Uploaded</p><p className="font-medium text-gray-900">{selectedProofDocument.uploadDate || '-'}</p></div>
            </div>

            <div className="rounded-xl border bg-white p-4">
              <p className="text-xs text-gray-500 mb-1">Description</p>
              <p className="text-sm text-gray-800">{selectedProofDocument.description || 'Supporting document attached to this transaction.'}</p>
            </div>

            <div className="rounded-xl border border-indigo-100 bg-white p-3">
              {renderProofPreview(selectedProofDocument.ledgerProof || selectedProofDocument.filePath || selectedProofDocument.ledgerProof, 'Proof Document')}
            </div>

            {/* <div className="flex items-center justify-between rounded-xl bg-indigo-50 border border-indigo-100 p-3">
              <p className="text-sm text-indigo-800">Open uploaded proof</p>
              <a
                href={getProofUrl(selectedProofDocument.ledgerProof || selectedProofDocument.filePath)}
                target="_blank"
                rel="noreferrer"
                className="text-xs px-3 py-1.5 rounded-md border border-indigo-300 text-indigo-700 hover:bg-indigo-100"
              >
                View File
              </a>
            </div> */}
          </div>
        )}
      </StudentModal>

      {/* Rating Modal */}
      <StudentModal
        isOpen={canSubmitRatings && showRatingModal}
        onClose={() => {
          setShowRatingModal(false);
          setSatisfactionRating(0);
          setCompletenessRating(0);
          setEngagementRating(0);
          setComment('');
        }}
        title="Rate this Project"
      >
        <div className="space-y-6 pt-4">
          {/* Star Rating */}
          <div className="text-center">
            <p className="text-sm text-gray-600 mb-4">How would you rate this project?</p>
            <div className="grid grid-cols-3 gap-2 mb-2">

              {/* Satisfaction Rating */}
              <div className="items-center justify-center">
                <p className="text-sm text-gray-600">Satisfaction Rating</p>
                <p className="text-xs text-gray-500 mb-1">Are you satisfied with this project?</p>
                 {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  onClick={() => setSatisfactionRating(star)}
                  onMouseEnter={() => setHoveredSatisfactionRating(star)}
                  onMouseLeave={() => setHoveredSatisfactionRating(0)}
                  className="transition-transform hover:scale-110"
                >
                  <Star
                    className={`w-10 h-10 ${
                      star <= (hoveredSatisfactionRating || satisfactionRating)
                        ? 'fill-blue-400 text-blue-400'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
              </div>

              {/* Completeness Rating */}
               <div className="items-center justify-center">
                <p className="text-sm text-gray-600">Completeness Rating</p>
                <p className="text-xs text-gray-500 mb-1">Rate how complete this project is.</p>
                 {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  onClick={() => setCompletenessRating(star)}
                  onMouseEnter={() => setHoveredCompletenessRating(star)}
                  onMouseLeave={() => setHoveredCompletenessRating(0)}
                  className="transition-transform hover:scale-110"
                >
                  <Star
                    className={`w-10 h-10 ${
                      star <= (hoveredCompletenessRating || completenessRating)
                        ? 'fill-green-400 text-green-400'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
              </div>

              {/* Engagement Rating */}
               <div className="items-center justify-center">
                <p className="text-sm text-gray-600">Engagement Rating</p>
                <p className="text-xs text-gray-500 mb-1">How engaged were you with this project?</p>
                 {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  onClick={() => setEngagementRating(star)}
                  onMouseEnter={() => setHoveredEngagementRating(star)}
                  onMouseLeave={() => setHoveredEngagementRating(0)}
                  className="transition-transform hover:scale-110"
                >
                  <Star
                    className={`w-10 h-10 ${
                      star <= (hoveredEngagementRating || engagementRating)
                        ? 'fill-red-400 text-red-400'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
              </div>

            </div>
            {/* {satisfactionRating > 0 && (
              <p className="text-sm text-gray-600">
                {satisfactionRating === 1 && 'Poor'}
                {satisfactionRating === 2 && 'Fair'}
                {satisfactionRating === 3 && 'Good'}
                {satisfactionRating === 4 && 'Very Good'}
                {satisfactionRating === 5 && 'Excellent'}
              </p>
            )} */}
          </div>

          {/* Comment */}
          <div>
            <label className="text-sm text-gray-600 mb-2 block">
              Comment (Optional)
            </label>
            <textarea
              placeholder="Share your thoughts about this project..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              rows="4"
              className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-3">
            <button
              onClick={handleSubmitRating}
              disabled={!canSubmitRatings || satisfactionRating === 0 || isSubmitting}
              className="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 text-white rounded-xl transition-colors font-medium"
            >
              {isSubmitting ? 'Submitting...' : 'Submit Rating'}
            </button>
            <button
              onClick={() => {
                setShowRatingModal(false);
                setSatisfactionRating(0);
                setCompletenessRating(0);
                setEngagementRating(0);
                setComment('');
              }}
              className="px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors"
            >
              Cancel
            </button>
          </div>

          

        </div>
      </StudentModal>
    </div>

    
  );
}