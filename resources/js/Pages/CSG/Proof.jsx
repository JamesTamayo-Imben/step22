import React, { useEffect, useRef, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
import {
  Upload,
  Search,
  Filter,
  Eye,
  Download,
  Trash2,
  FileText,
  Image,
  File,
  Hash,
  Shield,
  CheckCircle,
  Clock,
  XCircle,
  ChevronLeft,
  ChevronRight,
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

function CSGProofPageInner() {
  const { proofDocuments: initialProofDocuments = [], projects: initialProjects = [], transactions: initialTransactions = [] } = usePage().props;
  const [selectedProof, setSelectedProof] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all');
  const [filterProject, setFilterProject] = useState('all');
  const [filterType, setFilterType] = useState('all');
  const [filePreview, setFilePreview] = useState(null);
  const fileInputRef = useRef(null);

  const [proofDocuments, setProofDocuments] = useState(initialProofDocuments);

  const [uploadForm, setUploadForm] = useState({
    linkedTransaction: '',
    linkedProject: '',
    fileName: '',
  });

  // Modal state variables
  const [showUploadModal, setShowUploadModal] = useState(false);
  const [showViewModal, setShowViewModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  // Pagination state
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;

  const projects = initialProjects;
  
  const transactions = initialTransactions;

  const filteredDocuments = proofDocuments.filter((doc) => {
    const matchesSearch =
      doc.fileName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      doc.id.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus = filterStatus === 'all' || doc.status === filterStatus;
    const matchesProject = filterProject === 'all' || doc.linkedProject === filterProject;
    const matchesType = filterType === 'all' || doc.fileType === filterType;
    return matchesSearch && matchesStatus && matchesProject && matchesType;
  });

  // Pagination logic
  const totalPages = Math.ceil(filteredDocuments.length / itemsPerPage);
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredDocuments.slice(indexOfFirstItem, indexOfLastItem);

  // Reset to page 1 when filters change
  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, filterStatus, filterProject, filterType]);

  const stats = {
    totalDocuments: proofDocuments.length,
    approvedDocuments: proofDocuments.filter(d => d.status === 'Approved').length,
    pendingDocuments: proofDocuments.filter(d => d.status === 'Pending Adviser Approval').length,
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Approved':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'Pending Adviser Approval':
        return <Clock className="w-4 h-4 text-yellow-600" />;
      case 'Rejected':
        return <XCircle className="w-4 h-4 text-red-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Approved':
        return 'bg-green-100 text-green-700';
      case 'Pending Adviser Approval':
        return 'bg-yellow-100 text-yellow-700';
      case 'Rejected':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getFileIcon = (type) => {
    switch (type) {
      case 'PDF':
        return <FileText className="w-8 h-8 text-red-600" />;
      case 'Image':
        return <Image className="w-8 h-8 text-blue-600" />;
      default:
        return <File className="w-8 h-8 text-gray-600" />;
    }
  };

  const handleUpload = () => {
    if (!uploadForm.linkedTransaction || !uploadForm.linkedProject || !filePreview) {
      showToast('Please fill in all required fields and select a file', 'error');
      return;
    }

    const formData = new FormData();
    formData.append('proof_file', filePreview.file);

    router.post(`/csg/ledger-entries/${uploadForm.linkedTransaction}/proof`, formData, {
      onSuccess: () => {
        showToast('Proof document uploaded successfully', 'success');
        setShowUploadModal(false);
        setFilePreview(null);
        setUploadForm({ linkedTransaction: '', linkedProject: '', fileName: '' });
        if (fileInputRef.current) fileInputRef.current.value = '';
        // Refresh the page to get updated data
        window.location.reload();
      },
      onError: (errors) => {
        showToast('Failed to upload proof document', 'error');
        console.error('Upload errors:', errors);
      }
    });
  };

  const handleDelete = () => {
    if (!selectedProof) return;
    setProofDocuments(proofDocuments.filter((doc) => doc.id !== selectedProof.id));
    setShowDeleteModal(false);
    setSelectedProof(null);
    showToast('Proof document deleted', 'success');
  };

  const handleFileUpload = (e) => {
    const file = e.target.files && e.target.files[0];
    if (!file) return;
    
    if (file.size > 10 * 1024 * 1024) {
      showToast('File size must be less than 10MB', 'error');
      return;
    }

    setFilePreview({
      name: file.name,
      size: (file.size / (1024 * 1024)).toFixed(2) + ' MB',
      type: file.type,
      file: file, // Store the actual file object
    });
    setUploadForm({ ...uploadForm, fileName: file.name });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">Proof of Transactions</h1>
          <p className="text-gray-500">Manage all supporting documents and receipts</p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">

        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm text-gray-500">Total Documents</p>
        <div className="flex items-center gap-3 mt-2">
          <p className="text-3xl text-blue-600">{stats.totalDocuments}</p>
        </div>
      </div>
      <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
        <FileText className="w-6 h-6 text-blue-600" />
      </div>
    </div>
  </Card>

         <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm text-gray-500">Approved</p>
        <div className="flex items-center gap-3 mt-2">
          <p className="text-3xl text-green-600">{stats.approvedDocuments}</p>
        </div>
      </div>
      <div className="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
        <CheckCircle className="w-6 h-6 text-green-600" />
      </div>
    </div>
  </Card>

 <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm text-gray-500">Pending Review</p>
        <div className="flex items-center gap-3 mt-2">
          <p className="text-3xl text-yellow-600">{stats.pendingDocuments}</p>
        </div>
      </div>
      <div className="w-12 h-12 bg-yellow-50 rounded-xl flex items-center justify-center">
        <CheckCircle className="w-6 h-6 text-yellow-600" />
      </div>
    </div>
  </Card>



      </div>

      {/* Search and Filters */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <Input
              placeholder="Search documents..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 rounded-xl border border-gray-200 bg-white focus:ring-2 focus:ring-blue-200 focus:border-blue-300"
            />
          </div>
          <div className="w-full md:w-48">
            <Select
              value={filterStatus}
              onChange={(e) => setFilterStatus(e.target.value)}
            >
              <option value="all">All Status</option>
              <option value="Approved">Approved</option>
              <option value="Pending Adviser Approval">Pending</option>
              <option value="Rejected">Rejected</option>
            </Select>
          </div>
          <div className="w-full md:w-48">
            <Select
              value={filterProject}
              onChange={(e) => setFilterProject(e.target.value)}
            >
              <option value="all">All Projects</option>
              {projects.map((project) => (
                <option key={project} value={project}>{project}</option>
              ))}
            </Select>
          </div>
          <div className="w-full md:w-48">
            <Select
              value={filterType}
              onChange={(e) => setFilterType(e.target.value)}
            >
              <option value="all">All Types</option>
              <option value="PDF">PDF</option>
              <option value="Image">Image</option>
            </Select>
          </div>
        </div>
      </Card>

      {/* Proof Documents Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        {currentItems.map((proof) => (
          <Card key={proof.id} className="rounded-[20px] border-0 shadow-sm p-4 hover:shadow-md transition-all">
            {/* File Preview */}
            <div className="h-32 bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl flex items-center justify-center mb-4">
              {getFileIcon(proof.fileType)}
            </div>

            {/* File Info */}
            <div className="space-y-3">
              <div>
                <h3 className="font-semibold text-gray-900 truncate">{proof.fileName}</h3>
                <p className="text-xs text-gray-500 mt-1">
                  {proof.fileType} • {proof.fileSize}
                </p>
              </div>

              <div className="space-y-1">
                <div className="flex items-center gap-2 text-xs text-gray-600">
                  <Hash className="w-3 h-3 text-blue-600 flex-shrink-0" />
                  <span className="font-mono truncate">{proof.linkedTransaction}</span>
                </div>
                <p className="text-xs text-gray-500 truncate">{proof.linkedProject}</p>
                <p className="text-xs text-gray-400">Uploaded by {proof.uploadedBy}</p>
              </div>

              <div className="">
                <div className="flex items-center gap-1">
                  {getStatusIcon(proof.status)}
                  <span className={`text-xs font-medium px-2 py-1 rounded-lg ${getStatusColor(proof.status)}`}>
                    {proof.status}
                  </span>
                </div>
                <div>
                   <span className="text-xs text-gray-400">{proof.uploadDate}</span>
                </div>
                {/* <span className="text-xs text-gray-400">{proof.uploadDate}</span> */}
              </div>

              {/* Action Buttons */}
              <div className="flex gap-2 pt-2 border-t">
                <Button
                  variant="outline"
                  size="sm"
                  className="flex-1 rounded-lg"
                  onClick={() => {
                    setSelectedProof(proof);
                    setShowViewModal(true);
                  }}
                >
                  <Eye className="w-4 h-4 mr-1" />
                  View
                </Button>
                {/* {proof.status === 'Pending Adviser Approval' && (
                  <Button
                    variant="outline"
                    size="sm"
                    className="rounded-lg text-red-600 hover:bg-red-50"
                    onClick={() => {
                      setSelectedProof(proof);
                      setShowDeleteModal(true);
                    }}
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                )} */}
              </div>
            </div>
          </Card>
        ))}

        {currentItems.length === 0 && filteredDocuments.length > 0 && (
          <Card className="col-span-full rounded-[20px] border-0 shadow-sm p-12">
            <div className="text-center">
              <FileText className="w-12 h-12 text-gray-300 mx-auto mb-4" />
              <h3 className="text-lg font-medium text-gray-900 mb-2">No proof documents found</h3>
              <p className="text-gray-500 mb-6">
                Try adjusting your filters or pagination
              </p>
            </div>
          </Card>
        )}

        {filteredDocuments.length === 0 && (
          <Card className="col-span-full rounded-[20px] border-0 shadow-sm p-12">
            <div className="text-center">
              <FileText className="w-12 h-12 text-gray-300 mx-auto mb-4" />
              <h3 className="text-lg font-medium text-gray-900 mb-2">No proof documents found</h3>
              <p className="text-gray-500 mb-6">
                {searchQuery || filterStatus !== 'all' || filterProject !== 'all'
                  ? 'Try adjusting your filters'
                  : 'Upload your first proof document'}
              </p>
              {/* {!searchQuery && filterStatus === 'all' && filterProject === 'all' && (
                <Button
                  onClick={() => setShowUploadModal(true)}
                  className="text-white rounded-xl bg-blue-600 hover:bg-blue-700"
                >
                  <Upload className="w-4 h-4 mr-2" />
                  Upload Proof
                </Button>
              )} */}
            </div>
          </Card>
        )}
      </div>

      {/* Pagination */}
      {filteredDocuments.length > 0 && totalPages > 1 && (
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
                Showing {indexOfFirstItem + 1} to {Math.min(indexOfLastItem, filteredDocuments.length)} of {filteredDocuments.length} documents
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

      {/* Upload Modal */}
      <Modal
        open={showUploadModal}
        onClose={() => {
          setShowUploadModal(false);
          setFilePreview(null);
          setUploadForm({ linkedTransaction: '', linkedProject: '', fileName: '' });
          if (fileInputRef.current) fileInputRef.current.value = '';
        }}
        title="Upload Proof of Transaction"
        description="Upload supporting documents for ledger entries"
      >
        <div className="space-y-4 pt-6">
          <div>
            <FieldLabel>Project</FieldLabel>
            <Select
              value={uploadForm.linkedProject}
              onChange={(e) => setUploadForm({ ...uploadForm, linkedProject: e.target.value })}
            >
              <option value="">Select project</option>
              {projects.map((project) => (
                <option key={project} value={project}>{project}</option>
              ))}
            </Select>
          </div>

          <div>
            <FieldLabel>Linked Transaction</FieldLabel>
            <Select
              value={uploadForm.linkedTransaction}
              onChange={(e) => setUploadForm({ ...uploadForm, linkedTransaction: e.target.value })}
            >
              <option value="">Select transaction</option>
              {transactions.map((txn) => (
                <option key={txn} value={txn}>{txn}</option>
              ))}
            </Select>
          </div>

          <div>
            <FieldLabel>Upload File</FieldLabel>
            <div className="flex flex-col items-center gap-3">
              <button
                type="button"
                className="w-full border-2 border-dashed border-gray-300 rounded-xl p-8 flex flex-col items-center justify-center hover:bg-gray-50 transition"
                onClick={() => fileInputRef.current && fileInputRef.current.click()}
              >
                <Upload className="w-6 h-6 text-gray-500" />
                <p className="text-sm text-gray-600 mt-2">Click to upload</p>
                <p className="text-xs text-gray-500 mt-1">PDF, Images up to 10MB</p>
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
                        setUploadForm({ ...uploadForm, fileName: '' });
                        if (fileInputRef.current) fileInputRef.current.value = '';
                      }}
                    >
                      ✕
                    </Button>
                  </div>
                </div>
              )}
            </div>
          </div>

          <div className="bg-blue-50 rounded-xl p-4">
            <div className="flex items-start gap-2">
              <Shield className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
              <p className="text-sm text-blue-900">
                Your file will be hashed using SHA-256 for verification and immutability.
              </p>
            </div>
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => setShowUploadModal(false)}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleUpload}
              disabled={!uploadForm.linkedTransaction || !uploadForm.linkedProject || !uploadForm.fileName}
              className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
            >
              Upload
            </Button>
          </div>
        </div>
      </Modal>

      {/* View Modal */}
      <Modal
        open={showViewModal}
        onClose={() => {
          setShowViewModal(false);
          setSelectedProof(null);
        }}
        title="Proof Document Details"
        description={`Document ID: ${selectedProof?.id}`}
      >
        {selectedProof && (
          <div className="space-y-6 pt-6">
            {/* File Preview */}
            <div className="h-48 bg-gray-100 rounded-xl flex items-center justify-center">
              <div className="text-center">
                {getFileIcon(selectedProof.fileType)}
                <p className="text-gray-600 mt-2 font-medium">{selectedProof.fileName}</p>
                <p className="text-xs text-gray-500 mt-1">
                  {selectedProof.fileType} • {selectedProof.fileSize}
                </p>
              </div>
            </div>

            {/* Document Info */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <h4 className="text-sm font-medium text-gray-700 mb-1">Status</h4>
                <div className="flex items-center gap-1">
                  {getStatusIcon(selectedProof.status)}
                  <span className={`text-xs font-medium px-2 py-1 rounded-lg ${getStatusColor(selectedProof.status)}`}>
                    {selectedProof.status}
                  </span>
                </div>
              </div>
              <div>
                <h4 className="text-sm font-medium text-gray-700 mb-1">Upload Date</h4>
                <p className="text-sm text-gray-600">{selectedProof.uploadDate}</p>
              </div>
              <div>
                <h4 className="text-sm font-medium text-gray-700 mb-1">Uploaded By</h4>
                <p className="text-sm text-gray-600">{selectedProof.uploadedBy}</p>
              </div>
              <div>
                <h4 className="text-sm font-medium text-gray-700 mb-1">Linked Transaction</h4>
                <p className="text-sm font-mono text-gray-600">{selectedProof.linkedTransaction}</p>
              </div>
              <div className="col-span-2">
                <h4 className="text-sm font-medium text-gray-700 mb-1">Project</h4>
                <p className="text-sm text-gray-600">{selectedProof.linkedProject}</p>
              </div>
               <div className="col-span-2">
                <h4 className="text-sm font-medium text-gray-700 mb-1">Description</h4>
                <p className="text-sm text-gray-600">{selectedProof.description}</p>
              </div>
              <div className="col-span-2">
                <h4 className="text-sm font-medium text-gray-700 mb-2">File Hash (SHA-256)</h4>
                <div className="bg-gray-50 rounded-lg p-3 font-mono text-xs text-gray-700 break-all">
                  {selectedProof.hash}
                </div>
              </div>
            </div>

            <div className="flex gap-3 pt-4">
              <a
                href={`/${selectedProof.filePath}`}
                target="_blank"
                rel="noopener noreferrer"
                className="flex-1"
              >
                <Button className="w-full rounded-xl bg-blue-600 hover:bg-blue-700">
                  <Download className="w-4 h-4 mr-2" />
                  Download
                </Button>
              </a>
              <Button
                onClick={() => setShowViewModal(false)}
                variant="outline"
                className="flex-1 rounded-xl"
              >
                Close
              </Button>
            </div>
          </div>
        )}
      </Modal>

      {/* Delete Confirmation Modal */}
      <Modal
        open={showDeleteModal}
        onClose={() => {
          setShowDeleteModal(false);
          setSelectedProof(null);
        }}
        title="Delete Proof Document"
        description="Are you sure you want to delete this document? This action cannot be undone."
      >
        <div className="pt-6">
          <p className="text-sm text-gray-600 mb-6">
            Document: <span className="font-medium">{selectedProof?.fileName}</span>
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
              onClick={handleDelete}
              className="flex-1 rounded-xl bg-red-600 hover:bg-red-700 text-white"
            >
              Delete Document
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default function CSGProofPage() {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Proof of Transactions</h2>}>
      <Head title="Proof of Transactions" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <CSGProofPageInner />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}