import React, { useState, useMemo } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { useEffect } from 'react';
import ReactDOM from 'react-dom';
import { Clock, FolderKanban, DollarSign, FileText, Calendar, Eye, CheckCircle, XCircle, Hash, Shield, Search } from 'lucide-react';

// Simple lightweight toast (avoid introducing new deps)
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
  // Lock body scroll when modal opens
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

  // Portal to body to avoid ancestor transform issues
  return ReactDOM.createPortal(
    // Backdrop overlay with click handler
    <div 
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
    >
      {/* Modal content: stop propagation so clicks inside don't close */}
      <div 
        className="relative w-full max-w-3xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Fixed header */}
        <div className="flex items-center justify-between p-6 border-b">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700">✕</button>
        </div>
        {/* Scrollable content area */}
        <div className="overflow-y-auto p-6 pt-0">
          {children}
        </div>
      </div>
    </div>,
    document.body
  );
}

export default function AdviserApprovalsPage() {
  // mock data (kept small)
  const [pendingProjects, setPendingProjects] = useState([
    { id: 'PROJ-024', title: 'Mental Health Awareness Week', submittedBy: 'Sarah Chen', submittedDate: '2024-11-20', status: 'Pending Approval', category: 'Wellness', amount: 45000, type: 'project' },
    { id: 'PROJ-023', title: 'Alumni Networking Event', submittedBy: 'Michael Torres', submittedDate: '2024-11-18', status: 'Pending Approval', category: 'Networking', amount: 35000, type: 'project' },
  ]);
  const [pendingLedger, setPendingLedger] = useState([
    { id: 'TXN-2024-003', title: 'Transportation and Logistics', submittedBy: 'Sarah Chen', submittedDate: '2024-11-10', status: 'Pending Approval', amount: 8500, project: 'Annual Sports Fest', hash: 'c9f0a1b2e3d4c5b6a7f8e9d0c1b2a3f4', type: 'ledger' },
    { id: 'TXN-2024-006', title: 'Marketing Materials', submittedBy: 'Michael Torres', submittedDate: '2024-11-15', status: 'Pending Approval', amount: 12000, project: 'Mental Health Awareness', hash: 'd1c2a3b4f5e6d7c8b9a0f1e2d3c4b5a6', type: 'ledger' },
  ]);
  const [pendingProofs, setPendingProofs] = useState([
    { id: 'PROOF-002', title: 'Transport_Invoice.jpg', submittedBy: 'Sarah Chen', submittedDate: '2024-11-10', status: 'Pending Approval', project: 'Annual Sports Fest', hash: 'sha256:c9f0a1b2e3d4c5b6a7f8e9d0c1b2a3f4', type: 'proof' },
  ]);
  const [pendingMeetings, setPendingMeetings] = useState([
    { id: 'MEET-008', title: 'Budget Planning Session - Minutes', submittedBy: 'Sarah Chen', submittedDate: '2024-11-18', status: 'Pending Approval', type: 'meeting' },
  ]);
  const [rejectedItems, setRejectedItems] = useState([
    { id: 'PROJ-021', title: 'Gaming Tournament', submittedBy: 'Michael Torres', submittedDate: '2024-11-05', status: 'Rejected', category: 'Events', amount: 25000, type: 'project' },
  ]);

  const [tab, setTab] = useState('projects');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedItem, setSelectedItem] = useState(null);
  const [showReview, setShowReview] = useState(false);
  const [showReject, setShowReject] = useState(false);
  const [rejectReason, setRejectReason] = useState('');

  const totalPending = pendingProjects.length + pendingLedger.length + pendingProofs.length + pendingMeetings.length;

  const counts = {
    projects: pendingProjects.length,
    ledger: pendingLedger.length,
    proofs: pendingProofs.length,
    meetings: pendingMeetings.length,
    rejected: rejectedItems.length,
  };

  const getTypeIcon = (type) => {
    switch (type) {
      case 'project': return <FolderKanban className="w-5 h-5 text-blue-600" />;
      case 'ledger': return <DollarSign className="w-5 h-5 text-green-600" />;
      case 'proof': return <FileText className="w-5 h-5 text-purple-600" />;
      case 'meeting': return <Calendar className="w-5 h-5 text-orange-600" />;
      default: return <FileText className="w-5 h-5 text-gray-600" />;
    }
  };

  const handleApprove = (item) => {
    if (!item) return;
    // remove from source arrays
    if (item.type === 'project') setPendingProjects(p => p.filter(x => x.id !== item.id));
    if (item.type === 'ledger') setPendingLedger(p => p.filter(x => x.id !== item.id));
    if (item.type === 'proof') setPendingProofs(p => p.filter(x => x.id !== item.id));
    if (item.type === 'meeting') setPendingMeetings(p => p.filter(x => x.id !== item.id));
    setShowReview(false);
    setSelectedItem(null);
    showToast('Approved');
  };

  const handleReject = () => {
    if (!selectedItem) return showToast('No item selected', 'error');
    if (!rejectReason.trim()) return showToast('Provide a reason', 'error');
    const rejected = { ...selectedItem, status: 'Rejected' };
    if (selectedItem.type === 'project') setPendingProjects(p => p.filter(x => x.id !== selectedItem.id));
    if (selectedItem.type === 'ledger') setPendingLedger(p => p.filter(x => x.id !== selectedItem.id));
    if (selectedItem.type === 'proof') setPendingProofs(p => p.filter(x => x.id !== selectedItem.id));
    if (selectedItem.type === 'meeting') setPendingMeetings(p => p.filter(x => x.id !== selectedItem.id));
    setRejectedItems(r => [rejected, ...r]);
    setShowReject(false);
    setShowReview(false);
    setSelectedItem(null);
    setRejectReason('');
    showToast('Rejected');
  };

  const itemsForTab = useMemo(() => {
    switch (tab) {
      case 'projects': return pendingProjects;
      case 'ledger': return pendingLedger;
      case 'proofs': return pendingProofs;
      case 'meetings': return pendingMeetings;
      case 'rejected': return rejectedItems;
      default: return [];
    }
  }, [tab, pendingProjects, pendingLedger, pendingProofs, pendingMeetings, rejectedItems]);

  const filtered = itemsForTab.filter(i => {
    if (!searchQuery) return true;
    return (i.title || '').toLowerCase().includes(searchQuery.toLowerCase()) || (i.id || '').toLowerCase().includes(searchQuery.toLowerCase());
  });

  const renderItem = (item) => (
    <Card key={item.id} className="rounded-[20px] border-0 shadow-sm p-4 hover:shadow-md transition-all">
      <div className="flex items-start gap-4">
        <div className="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center flex-shrink-0">{getTypeIcon(item.type)}</div>
        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between gap-2 mb-2">
            <div>
              <h3 className="text-gray-900 mb-1">{item.title}</h3>
              <p className="text-xs text-gray-500">ID: {item.id}</p>
            </div>
            <div className="text-xs px-3 py-1 rounded-full bg-gray-100 text-gray-700">{item.status}</div>
          </div>

          <div className="space-y-1 mb-3">
            <p className="text-sm text-gray-600">Submitted by: {item.submittedBy}</p>
            <p className="text-sm text-gray-600">Date: {item.submittedDate}</p>
            {item.project && <p className="text-sm text-gray-600">Project: {item.project}</p>}
            {item.amount && <p className="text-sm text-gray-900">Amount: ₱{item.amount.toLocaleString()}</p>}
            {item.hash && <div className="flex items-center gap-2 mt-2"><Hash className="w-3 h-3 text-purple-600" /><span className="text-xs font-mono text-gray-500 truncate">{item.hash}</span></div>}
          </div>

          {item.status === 'Pending Approval' && (
            <div className="flex gap-2">
              <Button variant="outline" size="sm" className="flex-1 rounded-xl" onClick={() => { setSelectedItem(item); setShowReview(true); }}>
                <Eye className="w-4 h-4 mr-1" /> Review
              </Button>
              <Button size="sm" className="text-white rounded-xl bg-green-600 hover:bg-green-700" onClick={() => handleApprove(item)}>
                <CheckCircle className="w-4 h-4 mr-1" /> Approve
              </Button>
              <Button size="sm" variant="outline" className="rounded-xl text-red-600 hover:bg-red-50" onClick={() => { setSelectedItem(item); setShowReject(true); }}>
                <XCircle className="w-4 h-4" />
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

      <div className="py-12">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">Approval Center</h1>
              <p className="text-gray-500">Review and approve pending submissions</p>
            </div>

            <div className="flex items-center gap-3">
              <button type="button" className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-full shadow">
                <Clock className="w-4 h-4" />
                <span className="text-sm font-medium">{totalPending} Pending</span>
              </button>
            </div>
          </div>

          {/* Summary cards */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-blue-50">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-blue-700">Projects</p>
                  <p className="text-2xl text-blue-900">{pendingProjects.length}</p>
                </div>
                <FolderKanban className="w-8 h-8 text-blue-600" />
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-green-50">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-green-700">Ledger</p>
                  <p className="text-2xl text-green-900">{pendingLedger.length}</p>
                </div>
                <DollarSign className="w-8 h-8 text-green-600" />
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-purple-50">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-purple-700">Proofs</p>
                  <p className="text-2xl text-purple-900">{pendingProofs.length}</p>
                </div>
                <FileText className="w-8 h-8 text-purple-600" />
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-orange-50">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-orange-700">Meetings</p>
                  <p className="text-2xl text-orange-900">{pendingMeetings.length}</p>
                </div>
                <Calendar className="w-8 h-8 text-orange-600" />
              </div>
            </Card>
          </div>

          {/* Filters */}
          <Card className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="relative md:col-span-2">
                 
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                 
                  <input placeholder="Search submissions..." value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)} className="w-full pl-9 pr-3 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-gray-200" />
                </div>
              <div>
                <select className="w-full px-3 py-2 border border-gray-200 rounded-xl focus:outline-none focus:ring-1 focus:ring-gray-200" onChange={(e) => { /* placeholder */ }}>
                  <option>Newest First</option>
                  <option>Oldest First</option>
                </select>
              </div>
            </div>
          </Card>

          {/* Tabs */}
          <div className="space-y-6">
            <div className="bg-white rounded-xl p-2 shadow-sm flex flex-wrap gap-2">
              {['projects','ledger','proofs','meetings','rejected'].map(t => (
                <button
                  key={t}
                  onClick={() => setTab(t)}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${tab===t ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`}>
                  <span className="capitalize">{t}</span>
                  <span className={`text-xs px-2 py-0.5 rounded-full ${tab===t ? 'bg-white/20 text-white' : 'bg-gray-100 text-gray-700'}`}>{counts[t]}</span>
                </button>
              ))}
            </div>

            <div className="space-y-4">
              {filtered.length === 0 ? (
                <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
                  <div className="flex items-center justify-center mb-4">
                    <Shield className="w-8 h-8 text-gray-400" />
                  </div>
                  <p className="text-gray-900">Nothing to review right now</p>
                  <p className="text-sm text-gray-500">You're all caught up — no pending items in this tab.</p>
                </Card>
              ) : (
                filtered.map(item => renderItem(item))
              )}
            </div>
          </div>
        </div>
      </div>

      <Modal open={showReview} onClose={() => setShowReview(false)} title={selectedItem ? `Review ${selectedItem.type}` : 'Review'}>
        {selectedItem && (
          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-600 mb-1">ID</p>
                <p className="font-mono text-gray-900">{selectedItem.id}</p>
              </div>
              <div>
                <p className="text-sm text-gray-600 mb-1">Type</p>
                <div className="text-sm text-gray-700">{selectedItem.type}</div>
              </div>
              <div className="col-span-2">
                <p className="text-sm text-gray-600 mb-1">Title</p>
                <p className="text-gray-900">{selectedItem.title}</p>
              </div>
            </div>

            <div className="flex gap-3 pt-4">
              <Button variant="outline" className="flex-1 rounded-xl" onClick={() => setShowReview(false)}>Cancel</Button>
              <Button variant="outline" className="flex-1 rounded-xl text-red-600" onClick={() => { setShowReview(false); setShowReject(true); }}>Reject</Button>
              <Button className="text-white flex-1 rounded-xl bg-green-600 hover:bg-green-700" onClick={() => handleApprove(selectedItem)}>Approve</Button>
            </div>
          </div>
        )}
      </Modal>

      <Modal open={showReject} onClose={() => setShowReject(false)} title="Reject Submission">
        <div className="space-y-4">
          <p className="text-sm text-gray-600">Please provide a reason for rejecting this submission.</p>
          <textarea value={rejectReason} onChange={(e) => setRejectReason(e.target.value)} rows={4} className="w-full rounded-xl border px-3 py-2" />
          <div className="flex gap-3">
            <Button variant="outline" className="flex-1 rounded-xl" onClick={() => { setShowReject(false); setRejectReason(''); }}>Cancel</Button>
            <Button className="flex-1 rounded-xl bg-red-600 hover:bg-red-700" onClick={handleReject}>Confirm Rejection</Button>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}
