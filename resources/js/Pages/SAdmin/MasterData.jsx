import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
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
  Tag,
  DollarSign,
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

const mockDepartments = [
  { id: 1, name: 'Computer Science', description: 'CS & IT programs' },
  { id: 2, name: 'Engineering', description: 'All engineering disciplines' },
  { id: 3, name: 'Business Administration', description: 'Business & Management' },
  { id: 4, name: 'Arts & Sciences', description: 'Liberal arts programs' },
];

const mockPositions = [
  { id: 1, name: 'President', description: 'Organization head' },
  { id: 2, name: 'Vice President', description: 'Second in command' },
  { id: 3, name: 'Secretary', description: 'Documentation officer' },
  { id: 4, name: 'Treasurer', description: 'Financial officer' },
  { id: 5, name: 'CSG Officer', description: 'General CSG officer' },
];

const mockOrgTypes = [
  { id: 1, name: 'Central Student Government', description: 'Main student body' },
  { id: 2, name: 'Academic Club', description: 'Subject-based organizations' },
  { id: 3, name: 'Sports Club', description: 'Athletic organizations' },
  { id: 4, name: 'Cultural Organization', description: 'Arts and culture groups' },
];

const mockProjectCategories = [
  { id: 1, name: 'Community Outreach', description: 'Community service projects' },
  { id: 2, name: 'Academic', description: 'Educational programs' },
  { id: 3, name: 'Sports & Recreation', description: 'Athletic events' },
  { id: 4, name: 'Wellness', description: 'Health and wellbeing' },
  { id: 5, name: 'Cultural', description: 'Arts and cultural activities' },
];

const mockLedgerCategories = [
  { id: 1, name: 'Transportation', description: 'Travel and logistics' },
  { id: 2, name: 'Materials & Supplies', description: 'Consumables and equipment' },
  { id: 3, name: 'Marketing', description: 'Promotional materials' },
  { id: 4, name: 'Venue Rental', description: 'Facility costs' },
  { id: 5, name: 'Food & Beverage', description: 'Catering expenses' },
  { id: 6, name: 'Honorarium', description: 'Speaker fees' },
];

export default function MasterDataPage() {
  const [departments, setDepartments] = useState(mockDepartments);
  const [positions, setPositions] = useState(mockPositions);
  const [orgTypes, setOrgTypes] = useState(mockOrgTypes);
  const [projectCategories, setProjectCategories] = useState(mockProjectCategories);
  const [ledgerCategories, setLedgerCategories] = useState(mockLedgerCategories);

  const [showModal, setShowModal] = useState(false);
  const [currentCategory, setCurrentCategory] = useState('departments');
  const [editingItem, setEditingItem] = useState(null);
  const [formData, setFormData] = useState({ name: '', description: '' });

  const getDataByCategory = (category) => {
    switch (category) {
      case 'departments':
        return departments;
      case 'positions':
        return positions;
      case 'org-types':
        return orgTypes;
      case 'project-categories':
        return projectCategories;
      case 'ledger-categories':
        return ledgerCategories;
      default:
        return [];
    }
  };

  const setDataByCategory = (category, data) => {
    switch (category) {
      case 'departments':
        setDepartments(data);
        break;
      case 'positions':
        setPositions(data);
        break;
      case 'org-types':
        setOrgTypes(data);
        break;
      case 'project-categories':
        setProjectCategories(data);
        break;
      case 'ledger-categories':
        setLedgerCategories(data);
        break;
    }
  };

  const handleOpenModal = (category, item) => {
    setCurrentCategory(category);
    if (item) {
      setEditingItem(item);
      setFormData({ name: item.name, description: item.description || '' });
    } else {
      setEditingItem(null);
      setFormData({ name: '', description: '' });
    }
    setShowModal(true);
  };

  const handleSave = () => {
    if (!formData.name.trim()) {
      showToast('Name is required', 'error');
      return;
    }

    const currentData = getDataByCategory(currentCategory);

    if (editingItem) {
      const updatedData = currentData.map((item) =>
        item.id === editingItem.id ? { ...item, ...formData } : item
      );
      setDataByCategory(currentCategory, updatedData);
      showToast('Item updated successfully', 'success');
    } else {
      const newItem = {
        id: currentData.length + 1,
        ...formData,
      };
      setDataByCategory(currentCategory, [...currentData, newItem]);
      showToast('Item created successfully', 'success');
    }

    setShowModal(false);
    setEditingItem(null);
    setFormData({ name: '', description: '' });
  };

  const handleDelete = (category, id) => {
    const currentData = getDataByCategory(category);
    setDataByCategory(category, currentData.filter((item) => item.id !== id));
    showToast('Item deleted', 'success');
  };

  const getCategoryIcon = (category) => {
    switch (category) {
      case 'departments':
        return <Building className="w-5 h-5" />;
      case 'positions':
        return <Users className="w-5 h-5" />;
      case 'org-types':
        return <FolderKanban className="w-5 h-5" />;
      case 'project-categories':
        return <Tag className="w-5 h-5" />;
      case 'ledger-categories':
        return <DollarSign className="w-5 h-5" />;
      default:
        return null;
    }
  };

  const getCategoryLabel = (category) => {
    switch (category) {
      case 'departments':
        return 'Departments';
      case 'positions':
        return 'Positions';
      case 'org-types':
        return 'Organization Types';
      case 'project-categories':
        return 'Project Categories';
      case 'ledger-categories':
        return 'Ledger Categories';
      default:
        return '';
    }
  };

  const renderDataTable = (category) => {
    const data = getDataByCategory(category);

    return (
      <div className="space-y-3">
        {data.map((item) => (
          <div
            key={item.id}
            className="flex items-center justify-between p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors"
          >
            <div>
              <p className="text-sm font-medium text-gray-900">{item.name}</p>
              {item.description && <p className="text-xs text-gray-500 mt-1">{item.description}</p>}
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => handleOpenModal(category, item)}
                className="p-2 text-gray-600 hover:bg-white rounded-lg transition-colors"
                title="Edit"
              >
                <Edit className="w-4 h-4" />
              </button>
              <button
                onClick={() => handleDelete(category, item.id)}
                className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                title="Delete"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
          </div>
        ))}

        {data.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">No items yet</p>
          </div>
        )}
      </div>
    );
  };

  const tabs = [
    { id: 'departments', label: 'Departments', icon: Building },
    { id: 'positions', label: 'Positions', icon: Users },
    { id: 'org-types', label: 'Org Types', icon: FolderKanban },
    { id: 'project-categories', label: 'Projects', icon: Tag },
    { id: 'ledger-categories', label: 'Ledger', icon: DollarSign },
  ];

  const [activeTab, setActiveTab] = useState('departments');

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Master Data</h2>}>
      <Head title="Master Data Management" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div>
              <h1 className="text-2xl font-semibold text-gray-900">Master Data Management</h1>
              <p className="text-gray-500">Manage system-wide reference data</p>
            </div>

            {/* Summary Cards */}
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-blue-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-blue-700">Departments</p>
                    <p className="text-2xl text-blue-900 font-bold">{departments.length}</p>
                  </div>
                  <Building className="w-8 h-8 text-blue-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-green-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-green-700">Positions</p>
                    <p className="text-2xl text-green-900 font-bold">{positions.length}</p>
                  </div>
                  <Users className="w-8 h-8 text-green-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-purple-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-purple-700">Org Types</p>
                    <p className="text-2xl text-purple-900 font-bold">{orgTypes.length}</p>
                  </div>
                  <FolderKanban className="w-8 h-8 text-purple-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-orange-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-orange-700">Projects</p>
                    <p className="text-2xl text-orange-900 font-bold">{projectCategories.length}</p>
                  </div>
                  <Tag className="w-8 h-8 text-orange-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-yellow-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-yellow-700">Ledger</p>
                    <p className="text-2xl text-yellow-900 font-bold">{ledgerCategories.length}</p>
                  </div>
                  <DollarSign className="w-8 h-8 text-yellow-600" />
                </div>
              </Card>
            </div>

            {/* Tabs */}
            <Card className="rounded-[20px] border-0 shadow-sm">
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
                <div className="flex items-center justify-between mb-6">
                  <h2 className="text-lg font-semibold text-gray-900">{getCategoryLabel(activeTab)}</h2>
                  <Button
                    onClick={() => handleOpenModal(activeTab, null)}
                    className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                  >
                    <Plus className="w-4 h-4 mr-2" />
                    Add {getCategoryLabel(activeTab).slice(0, -1)}
                  </Button>
                </div>
                {renderDataTable(activeTab)}
              </div>
            </Card>
          </div>
        </div>
      </div>

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

