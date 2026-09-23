import React, { useMemo, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import {
  Plus,
  Edit,
  Trash2,
  Building,
  Users,
  FolderKanban,
  X,
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

function Modal({ open, onClose, title, children }) {
  React.useEffect(() => {
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
        className="relative w-full max-w-2xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between p-6 border-b">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            <X className="w-6 h-6" />
          </button>
        </div>
        <div className="overflow-y-auto p-6">{children}</div>
      </div>
    </div>,
    document.body
  );
}

export default function MasterDataPage() {
  const { institutes = [], courses = [], positions = [] } = usePage().props;

  const [showModal, setShowModal] = useState(false);
  const [currentCategory, setCurrentCategory] = useState('institutes');
  const [editingItem, setEditingItem] = useState(null);
  const [formData, setFormData] = useState({ name: '', description: '', institute_id: '' });
  const [searchQuery, setSearchQuery] = useState({ institutes: '', courses: '', positions: '' });
  const [confirmModal, setConfirmModal] = useState({
    open: false,
    type: null,
    category: null,
    itemId: null,
    itemName: '',
    result: null,
  });

  const dataByCategory = useMemo(
    () => ({
      institutes: institutes,
      courses: courses,
      positions: positions,
    }),
    [institutes, courses, positions]
  );

  const getDataByCategory = (category) => dataByCategory[category] || [];

  const handleOpenModal = (category, item) => {
    setCurrentCategory(category);
    if (item) {
      setEditingItem(item);
      setFormData({
        name: item.name,
        description: item.description || '',
        institute_id: item.institute_id || '',
      });
    } else {
      setEditingItem(null);
      setFormData({ name: '', description: '', institute_id: '' });
    }
    setShowModal(true);
  };

  const handleSave = () => {
    if (!formData.name.trim()) {
      showToast('Name is required', 'error');
      return;
    }

    const payload = {
      name: formData.name.trim(),
      description: formData.description.trim(),
    };

    if (currentCategory === 'courses') {
      payload.institute_id = formData.institute_id || null;
    }

    const routeName = {
      institutes: editingItem ? route('sadmin.master-data.institutes.update', editingItem.id) : route('sadmin.master-data.institutes.store'),
      courses: editingItem ? route('sadmin.master-data.courses.update', editingItem.id) : route('sadmin.master-data.courses.store'),
      positions: editingItem ? route('sadmin.master-data.positions.update', editingItem.id) : route('sadmin.master-data.positions.store'),
    }[currentCategory];

    const method = editingItem ? 'put' : 'post';

    router[method](routeName, payload, {
      onSuccess: () => showToast(editingItem ? 'Item updated successfully' : 'Item created successfully', 'success'),
      onError: (errors) => {
        const firstError = Object.values(errors || {})[0];
        showToast(Array.isArray(firstError) ? firstError[0] : (firstError || 'Unable to save item'), 'error');
      },
    });

    setShowModal(false);
    setEditingItem(null);
    setFormData({ name: '', description: '', institute_id: '' });
  };

  const openArchiveConfirm = (category, item) => {
    setConfirmModal({
      open: true,
      type: 'archive',
      category,
      itemId: item.id,
      itemName: item.name,
      result: null,
    });
  };

  const openRestoreConfirm = (category, item) => {
    setConfirmModal({
      open: true,
      type: 'restore',
      category,
      itemId: item.id,
      itemName: item.name,
      result: null,
    });
  };

  const executeArchiveRestore = (category, id) => {
    const routeName = {
      institutes: route('sadmin.master-data.institutes.destroy', id),
      courses: route('sadmin.master-data.courses.destroy', id),
      positions: route('sadmin.master-data.positions.destroy', id),
    }[category];

    if (!routeName) return;

    const isRestoring = confirmModal.type === 'restore';

    router.delete(routeName, {
      onSuccess: () => {
        setConfirmModal((prev) => ({ ...prev, result: 'success' }));
        setTimeout(() => {
          setConfirmModal({ open: false, type: null, category: null, itemId: null, itemName: '', result: null });
          showToast(isRestoring ? 'Item restored successfully' : 'Item archived successfully', 'success');
        }, 1200);
      },
      onError: () => {
        setConfirmModal((prev) => ({ ...prev, result: 'error' }));
        setTimeout(() => {
          setConfirmModal({ open: false, type: null, category: null, itemId: null, itemName: '', result: null });
          showToast('Unable to update item', 'error');
        }, 1200);
      },
    });
  };

  const getCategoryLabel = (category) => {
    switch (category) {
      case 'institutes':
        return 'Institutes';
      case 'positions':
        return 'Positions';
      case 'courses':
        return 'Courses';
      default:
        return '';
    }
  };

  const getFilteredData = (category) => {
    const data = getDataByCategory(category);
    const query = (searchQuery[category] || '').trim().toLowerCase();

    if (!query) return data;

    return data.filter((item) => {
      const haystack = [
        item.name,
        item.description,
        category === 'courses' ? item.institute_name : '',
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase();

      return haystack.includes(query);
    });
  };

  const renderDataTable = (category) => {
    const data = getFilteredData(category);

    return (
      <div className="space-y-4">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="relative flex-1">
            <Input
              type="search"
              value={searchQuery[category] || ''}
              onChange={(e) =>
                setSearchQuery((prev) => ({
                  ...prev,
                  [category]: e.target.value,
                }))
              }
              placeholder={`Search ${getCategoryLabel(category).toLowerCase()}...`}
              className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition disabled:opacity-50"
            />

            <div className="pointer-events-none absolute inset-y-0 left-3 flex items-center text-gray-400">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-4 w-4">
                <circle cx="11" cy="11" r="6" />
                <path d="M16 16L21 21" strokeLinecap="round" />
              </svg>
            </div>
          </div>

          <Button
            onClick={() => handleOpenModal(activeTab, null)}
            className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white whitespace-nowrap w-auto px-3"
          >
            <Plus className="w-4 h-4 mr-2" />
            Add {getCategoryLabel(activeTab).slice(0, -1)}
          </Button>
        </div>


        {data.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500">No items found</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
            {data.map((item) => (
              <div
                key={item.id}
                className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors border border-gray-200"
              >
                <div className="min-w-0 pr-3">
                  <div className="flex items-center gap-2">
                    <p className="text-sm font-medium text-gray-900 break-words">{item.name}</p>
                    {item.archive && (
                      <span className="inline-flex items-center rounded-full bg-amber-100 px-2 py-0.5 text-[10px] font-medium text-amber-800">
                        Archived
                      </span>
                    )}
                  </div>
                  {item.description && <p className="text-xs text-gray-500 mt-1 break-words">{item.description}</p>}
                  {category === 'courses' && item.institute_name && (
                    <p className="text-[11px] text-gray-500 mt-1">Institute: {item.institute_name}</p>
                  )}
                </div>
                <div className="flex gap-2 shrink-0">
                  <button
                    onClick={() => handleOpenModal(category, item)}
                    className="p-2 text-gray-600 hover:bg-white rounded-lg transition-colors"
                    title="Edit"
                  >
                    <Edit className="w-4 h-4" />
                  </button>
                  <button
                    onClick={() => (item.archive ? openRestoreConfirm(category, item) : openArchiveConfirm(category, item))}
                    className={`p-2 rounded-lg transition-colors ${item.archive ? 'text-emerald-600 hover:bg-emerald-50' : 'text-red-600 hover:bg-red-50'}`}
                    title={item.archive ? 'Restore' : 'Archive'}
                  >
                    {item.archive ? (
                      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-4 w-4">
                        <path d="M4 12c0-4.418 3.582-8 8-8s8 3.582 8 8-3.582 8-8 8-8-3.582-8-8Z" />
                        <path d="M9 12l2 2 4-4" strokeLinecap="round" strokeLinejoin="round" />
                      </svg>
                    ) : (
                      <Trash2 className="w-4 h-4" />
                    )}
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    );
  };

  const tabs = [
    { id: 'institutes', label: 'Institutes', icon: Building },
    { id: 'courses', label: 'Courses', icon: FolderKanban },
    { id: 'positions', label: 'Positions', icon: Users },
  ];

  const [activeTab, setActiveTab] = useState('institutes');

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Master Data</h2>}>
      <Head title="Master Data Management" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl font-semibold text-gray-900">Master Data Management</h1>
              <p className="text-gray-500">Manage the live institute, course, and position reference data used by the system.</p>
            </div>

            {/* Tabs */}
            <Card className="rounded-[20px] border-0 shadow-sm gap-2">
              <div className="flex overflow-x-auto border-b border-gray-200">
                {tabs.map((tab) => {
                  const TabIcon = tab.icon;
                  const isActive = activeTab === tab.id;
                  return (
                    <button
                      key={tab.id}
                      onClick={() => setActiveTab(tab.id)}
                      className={`flex items-center gap-2 px-4 py-4 border-b-2 transition-all whitespace-nowrap ${
                        isActive
                          ? 'border-blue-600 text-blue-600'
                          : 'border-transparent text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      <TabIcon className="w-4 h-4" />
                      <span className="text-sm font-medium">{tab.label}</span>
                    </button>
                  );
                })}
              </div>

              <div className="p-6">
                  <div className="flex-1">
                    {renderDataTable(activeTab)}
                  </div>
              </div>
            </Card>
          </div>
        </div>
      </div>

      <Modal
        open={confirmModal.open}
        onClose={() => !confirmModal.result && setConfirmModal({ open: false, type: null, category: null, itemId: null, itemName: '', result: null })}
        title={confirmModal.result ? (confirmModal.result === 'success' ? 'Success' : 'Error') : 'Confirm Action'}
      >
        <div className="py-6 text-center">
          {confirmModal.result === null && (
            <>
              <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-yellow-100 text-yellow-600">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-6 w-6">
                  <path d="M12 9v4" strokeLinecap="round" />
                  <path d="M12 17h.01" strokeLinecap="round" />
                  <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z" />
                </svg>
              </div>
              <p className="mt-4 text-gray-700">
                {confirmModal.type === 'restore'
                  ? `Are you sure you want to restore ${confirmModal.itemName}? It will be activated and shown again in active use.`
                  : `Are you sure you want to archive ${confirmModal.itemName}? This will change its status to archived.`}
              </p>
              <div className="mt-6 flex justify-center gap-3">
                <Button
                  variant="outline"
                  onClick={() => setConfirmModal({ open: false, type: null, category: null, itemId: null, itemName: '', result: null })}
                  className="rounded-lg"
                >
                  Cancel
                </Button>
                <Button
                  onClick={() => executeArchiveRestore(confirmModal.category, confirmModal.itemId)}
                  className={`rounded-lg text-white ${confirmModal.type === 'restore' ? 'bg-emerald-600 hover:bg-emerald-700' : 'bg-red-600 hover:bg-red-700'}`}
                >
                  Confirm
                </Button>
              </div>
            </>
          )}

          {confirmModal.result === 'success' && (
            <div className="text-center">
              <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100 text-green-600">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-6 w-6">
                  <path d="m5 12 5 5L20 2" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
              </div>
              <p className="mt-4 text-gray-700">
                {confirmModal.type === 'restore' ? 'Item restored successfully.' : 'Item archived successfully.'}
              </p>
            </div>
          )}

          {confirmModal.result === 'error' && (
            <div className="text-center">
              <div className="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-red-100 text-red-600">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="h-6 w-6">
                  <path d="M12 8v4" strokeLinecap="round" />
                  <path d="M12 16h.01" strokeLinecap="round" />
                  <path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z" />
                </svg>
              </div>
              <p className="mt-4 text-gray-700">Unable to update item. Please try again.</p>
            </div>
          )}
        </div>
      </Modal>

      {/* Add/Edit Modal */}
      <Modal
        open={showModal}
        onClose={() => setShowModal(false)}
        title={`${editingItem ? 'Edit' : 'Add'} ${getCategoryLabel(currentCategory)}`}
      >
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Name *</label>
            <Input
              placeholder="Enter name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          {currentCategory === 'courses' && (
            <div>
              <label className="block text-sm font-medium text-gray-900 mb-2">Institute</label>
              <select
                value={formData.institute_id}
                onChange={(e) => setFormData({ ...formData, institute_id: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 px-3 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
              >
                <option value="">Select an institute</option>
                {institutes.map((institute) => (
                  <option key={institute.id} value={institute.id}>{institute.name}</option>
                ))}
              </select>
            </div>
          )}

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Description</label>
            <textarea
              placeholder="Optional description"
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={3}
              className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => setShowModal(false)}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSave}
              className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
            >
              {editingItem ? 'Save Changes' : 'Create'}
            </Button>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}

