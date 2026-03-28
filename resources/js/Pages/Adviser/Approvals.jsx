import React, { useState, useMemo, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import ReactDOM from 'react-dom';
import { Clock, FolderKanban, DollarSign, FileText, Calendar, Eye, CheckCircle, XCircle, Hash, Shield, Search, ChevronLeft, ChevronRight } from 'lucide-react';

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

const LIST_PAGE_SIZE = 3;

export default function AdviserApprovalsPage() {
  const {
    pendingProjects = [],
    pendingLedger = [],
    pendingProofs = [],
    pendingMeetings = [],
    rejectedItems = [],
  } = usePage().props;

  const [tab, setTab] = useState('projects');
  const [searchQuery, setSearchQuery] = useState('');
  const [sortOrder, setSortOrder] = useState('newest');
  const [listPage, setListPage] = useState(1);
  const [selectedItem, setSelectedItem] = useState(null);
  const [showReview, setShowReview] = useState(false);
  const [showReject, setShowReject] = useState(false);
  const [rejectReason, setRejectReason] = useState('');

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const tabParam = params.get('tab');
    if (tabParam === 'meetings') {
      setTab('meetings');
    }
  }, []);

  useEffect(() => {
    setListPage(1);
  }, [tab, searchQuery, sortOrder]);

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

  const runApprove = (item) => {
    if (!item) return;
    const message = `Approve this ${item.type === 'project' ? 'project' : item.type === 'meeting' ? 'meeting minutes' : item.type === 'proof' ? 'proof document' : 'ledger entry'}?`;
    if (!window.confirm(message)) return;

    router.post(route('adviser.approvals.approve'), {
      type: item.type === 'proof' ? 'proof' : item.type,
      id: item.id,
    }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Approved');
        setShowReview(false);
        setSelectedItem(null);
      },
      onError: () => showToast('Could not approve', 'error'),
    });
  };

  const runReject = () => {
    if (!selectedItem) return showToast('No item selected', 'error');
    if (!rejectReason.trim()) return showToast('Provide a reason', 'error');
    if (!window.confirm('Reject this submission? This cannot be undone from this screen.')) return;

    router.post(route('adviser.approvals.reject'), {
      type: selectedItem.type === 'proof' ? 'proof' : selectedItem.type,
      id: selectedItem.id,
      reason: rejectReason.trim(),
    }, {
      preserveScroll: true,
      onSuccess: () => {
        showToast('Rejected');
        setShowReject(false);
        setShowReview(false);
        setSelectedItem(null);
        setRejectReason('');
      },
      onError: () => showToast('Could not reject', 'error'),
    });
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

  const filtered = itemsForTab.filter((i) => {
    if (!searchQuery) return true;
    const q = searchQuery.toLowerCase();
    return (
      (i.title || '').toLowerCase().includes(q)
      || (i.id || '').toLowerCase().includes(q)
      || (i.submittedBy || '').toLowerCase().includes(q)
      || (i.project || '').toLowerCase().includes(q)
      || (i.category || '').toLowerCase().includes(q)
    );
  });

  const sorted = useMemo(() => {
    const arr = [...filtered];
    arr.sort((a, b) => {
      const da = new Date(a.submittedDate || 0).getTime();
      const db = new Date(b.submittedDate || 0).getTime();
      return sortOrder === 'newest' ? db - da : da - db;
    });
    return arr;
  }, [filtered, sortOrder]);

  const totalPages = Math.max(1, Math.ceil(sorted.length / LIST_PAGE_SIZE));
  const displayItems = sorted.slice((listPage - 1) * LIST_PAGE_SIZE, listPage * LIST_PAGE_SIZE);

  const renderItem = (item) => (
    <Card key={`${item.type}-${item.id}`} className="rounded-[20px] border-0 shadow-sm p-4 hover:shadow-md transition-all">
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
            {item.amount != null && <p className="text-sm text-gray-900">Amount: ₱{Number(item.amount).toLocaleString()}</p>}
            {item.hash && (
              <div className="flex items-center gap-2 mt-2">
                <Hash className="w-3 h-3 text-purple-600" />
                <span className="text-xs font-mono text-gray-500 truncate">{item.hash}</span>
              </div>
            )}
          </div>

          {item.status === 'Pending Approval' && (
            <div className="flex gap-2">
              <Button variant="outline" size="sm" className="flex-1 rounded-xl" onClick={() => { setSelectedItem(item); setShowReview(true); }}>
                <Eye className="w-4 h-4 mr-1" /> Review
              </Button>
              <Button size="sm" className="text-white rounded-xl bg-green-600 hover:bg-green-700" onClick={() => runApprove(item)}>
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

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">Approval Center</h1>
              <p className="text-gray-500">Review and approve pending submissions</p>
            </div>

            <div className="flex items-center gap-3">
              <div className="inline-flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-full shadow">
                <Clock className="w-4 h-4" />
                <span className="text-sm font-medium">{totalPending} Pending</span>
              </div>
            </div>
          </div>

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
            <div className="bg-white rounded-xl p-2 shadow-sm flex flex-wrap gap-2">
              {['projects', 'ledger', 'proofs', 'meetings', 'rejected'].map((t) => (
                <button
                  key={t}
                  type="button"
                  onClick={() => setTab(t)}
                  className={`flex items-center gap-2 px-3 py-2 rounded-lg transition-colors ${tab === t ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`}
                >
                  <span className="capitalize">{t}</span>
                  <span className={`text-xs px-2 py-0.5 rounded-full ${tab === t ? 'bg-white/20 text-white' : 'bg-gray-100 text-gray-700'}`}>{counts[t]}</span>
                </button>
              ))}
            </div>

            <div className="space-y-4">
              {displayItems.length === 0 ? (
                <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
                  <div className="flex items-center justify-center mb-4">
                    <Shield className="w-8 h-8 text-gray-400" />
                  </div>
                  <p className="text-gray-900">Nothing to review right now</p>
                  <p className="text-sm text-gray-500">You&apos;re all caught up — no pending items in this tab.</p>
                </Card>
              ) : (
                displayItems.map((item) => renderItem(item))
              )}
            </div>

            {sorted.length > LIST_PAGE_SIZE && (
              <div className="flex items-center justify-center gap-4 pt-2">
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="rounded-xl"
                  disabled={listPage <= 1}
                  onClick={() => setListPage((p) => Math.max(1, p - 1))}
                >
                  <ChevronLeft className="w-4 h-4" />
                </Button>
                <span className="text-sm text-gray-600">
                  Page {listPage} of {totalPages} ({sorted.length} items)
                </span>
                <Button
                  type="button"
                  variant="outline"
                  size="sm"
                  className="rounded-xl"
                  disabled={listPage >= totalPages}
                  onClick={() => setListPage((p) => Math.min(totalPages, p + 1))}
                >
                  <ChevronRight className="w-4 h-4" />
                </Button>
              </div>
            )}
          </div>
        </div>
      </div>

      <Modal open={showReview} onClose={() => setShowReview(false)} title={selectedItem ? `Review ${selectedItem.type === 'project' ? 'Project' : selectedItem.type === 'ledger' ? 'Ledger Entry' : selectedItem.type === 'proof' ? 'Proof' : 'Meeting'}` : 'Review'}>
        {selectedItem && (
          <div className="space-y-6 pt-4">
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-3 flex gap-3">
              <div className="flex-shrink-0">
                <svg className="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
                </svg>
              </div>
              <p className="text-sm text-blue-800">This action will update records in the system</p>
            </div>

            <div className="space-y-4 pt-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <span className="text-xs text-gray-600 block mb-1">ID</span>
                  <p className="text-sm font-semibold text-gray-900">{selectedItem.id}</p>
                </div>
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Type</span>
                  <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-200 text-gray-800">
                    {selectedItem.type === 'project' ? 'Project' : selectedItem.type === 'ledger' ? 'Ledger' : selectedItem.type === 'proof' ? 'Proof' : 'Meeting'}
                  </span>
                </div>
              </div>

              <div>
                <span className="text-xs text-gray-600 block mb-1">Title</span>
                <p className="text-sm text-gray-900">{selectedItem.title}</p>
              </div>

              {selectedItem.submittedBy && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Submitted By</span>
                  <p className="text-sm text-gray-900">{selectedItem.submittedBy}</p>
                </div>
              )}

              {selectedItem.submittedDate && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Date</span>
                  <p className="text-sm text-gray-900">{selectedItem.submittedDate}</p>
                </div>
              )}

              {selectedItem.amount != null && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Amount</span>
                  <p className="text-sm font-semibold text-gray-900">₱{Number(selectedItem.amount).toLocaleString()}</p>
                </div>
              )}

              {selectedItem.category && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Category</span>
                  <p className="text-sm text-gray-900">{selectedItem.category}</p>
                </div>
              )}

              {selectedItem.project && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Project</span>
                  <p className="text-sm text-gray-900">{selectedItem.project}</p>
                </div>
              )}

              {selectedItem.hash && (
                <div>
                  <span className="text-xs text-gray-600 block mb-1">Hash</span>
                  <p className="text-xs font-mono text-gray-600 truncate">{selectedItem.hash}</p>
                </div>
              )}
            </div>

            {selectedItem.status === 'Pending Approval' && (
              <div className="flex gap-3 pt-2 border-t">
                <Button variant="outline" className="flex-1 rounded-xl" onClick={() => setShowReview(false)}>
                  Cancel
                </Button>
                <Button variant="outline" className="flex-1 rounded-xl text-red-600 hover:bg-red-50" onClick={() => { setShowReview(false); setShowReject(true); }}>
                  Reject
                </Button>
                <Button className="text-white flex-1 rounded-xl bg-green-600 hover:bg-green-700" onClick={() => runApprove(selectedItem)}>
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
          <textarea value={rejectReason} onChange={(e) => setRejectReason(e.target.value)} rows={4} className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition" />
          <div className="flex gap-3">
            <Button variant="outline" className="flex-1 rounded-xl" onClick={() => { setShowReject(false); setRejectReason(''); }}>Cancel</Button>
            <Button className="text-white flex-1 rounded-xl bg-red-600 hover:bg-red-700" onClick={runReject}>Confirm Rejection</Button>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}
