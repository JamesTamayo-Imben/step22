import React, { useState, useRef, useEffect } from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Textarea } from '@/Components/ui/textarea';
import {
  Edit,
  Send,
  FileText,
  Upload,
  X,
} from 'lucide-react';

// ─── Helpers ────────────────────────────────────────────────────────────────

export function showToast(message, type = 'success') {
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

export function Modal({ open, onClose, title, description, children }) {
  React.useEffect(() => {
    if (!open) return undefined;
    const originalStyle = window.getComputedStyle(document.body).overflow;
    document.body.style.overflow = 'hidden';
    return () => { document.body.style.overflow = originalStyle; };
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
            {description && <p className="text-sm text-gray-500 mt-1">{description}</p>}
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">✕</button>
        </div>
        <div className="overflow-y-auto p-6">{children}</div>
      </div>
    </div>,
    document.body
  );
}

function FieldLabel({ children }) {
  return <label className="block text-sm text-gray-700 mb-1">{children}</label>;
}

function Select({ className = '', children, value, onValueChange, ...props }) {
  return (
    <select
      className={[
        'w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      value={value}
      onChange={(e) => onValueChange?.(e.target.value)}
      {...props}
    >
      {children}
    </select>
  );
}

// ─── Helper Functions ───────────────────────────────────────────────────────

function getMinimumStartDate() {
  const today = new Date();
  const nextMonth = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
  return nextMonth.toISOString().split('T')[0];
}

function getMinimumEndDate(startDate) {
  if (!startDate) return null;
  const start = new Date(startDate);
  const minEndDate = new Date(start.getFullYear(), start.getMonth(), start.getDate() + 1);
  return minEndDate.toISOString().split('T')[0];
}

function getProofDetails(value) {
  const url = new URL(value, window.location.origin);
  const fileName = decodeURIComponent(url.pathname.split('/').pop() || 'Current proof document');
  const extension = fileName.includes('.') ? fileName.split('.').pop().toLowerCase() : '';
  return { url: url.toString(), fileName, extension };
}

function getDefaultBudgetSourceOptions() {
  return {
    sponsorship: [],
    donation: [],
  };
}

function getBudgetSourceEntries(sourceOptions, type) {
  return Array.isArray(sourceOptions?.[type]) ? sourceOptions[type] : [];
}

function getBudgetSourceTotal(sourceOptions) {
  return Object.entries(sourceOptions || getDefaultBudgetSourceOptions()).reduce((sum, [, entries]) => {
    if (!Array.isArray(entries)) return sum;
    return sum + entries.reduce((groupSum, entry) => groupSum + (Number(entry?.amount) || 0), 0);
  }, 0);
}

function addBudgetSourceEntry(sourceOptions, type) {
  const template = { id: `${type}-${Date.now()}-${Math.random().toString(16).slice(2)}`, name: '', amount: '' };
  return {
    ...sourceOptions,
    [type]: [...getBudgetSourceEntries(sourceOptions, type), template],
  };
}

function normalizeBudgetSourceOptions(rawValue) {
  const sourceOptions = getDefaultBudgetSourceOptions();
  if (!rawValue) return sourceOptions;

  const pushEntry = (entry, fallbackKey = 'sponsorship') => {
    const sourceLabel = String(entry?.source || entry?.type || entry?.key || entry?.category || '').toLowerCase();
    const key = sourceLabel.includes('donation') ? 'donation' : sourceLabel.includes('sponsorship') ? 'sponsorship' : fallbackKey;
    const name = String(entry?.name || entry?.sponsor || entry?.source_name || '').trim();
    const amount = Number(entry?.amount ?? entry?.value ?? 0);

    if (!name && amount <= 0) return;

    sourceOptions[key].push({
      id: entry?.id || `${key}-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      name,
      amount,
    });
  };

  if (Array.isArray(rawValue)) {
    rawValue.forEach((entry) => pushEntry(entry));
    return sourceOptions;
  }

  let parsedValue = rawValue;
  if (typeof parsedValue === 'string') {
    try {
      parsedValue = JSON.parse(parsedValue);
    } catch {
      parsedValue = null;
    }
  }

  if (!parsedValue || typeof parsedValue !== 'object') {
    return sourceOptions;
  }

  if (Array.isArray(parsedValue.sponsorship)) {
    parsedValue.sponsorship.forEach((entry) => pushEntry(entry, 'sponsorship'));
  }

  if (Array.isArray(parsedValue.donation)) {
    parsedValue.donation.forEach((entry) => pushEntry(entry, 'donation'));
  }

  if (!Array.isArray(parsedValue.sponsorship) && !Array.isArray(parsedValue.donation)) {
    Object.entries(parsedValue).forEach(([key, entries]) => {
      if (!Array.isArray(entries)) return;
      entries.forEach((entry) => pushEntry(entry, key === 'donation' ? 'donation' : 'sponsorship'));
    });
  }

  return sourceOptions;
}

// ─── Edit Project Modal ──────────────────────────────────────────────────────

export function EditProjectModal({
  open,
  onClose,
  editForm,
  setEditForm,
  onSave,
  projectId,
}) {
  const fileInputRef = useRef(null);
  const [filePreview, setFilePreview] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [isUploading, setIsUploading] = useState(false);
  const [completedProjects, setCompletedProjects] = useState([]);
  const [isLoadingProjects, setIsLoadingProjects] = useState(false);

  useEffect(() => {
    if (!open || !editForm) return;

    if (editForm.budgetSource === 'past_project') {
      return;
    }

    if (editForm.budgetSourceOptions) {
      return;
    }

    const hydratedSources = normalizeBudgetSourceOptions(
      editForm.budgetBreakdown ??
      editForm.budget_breakdown ??
      editForm.budgetSourceDetails ??
      editForm.budget_source_details ??
      []
    );

    const hasHydratedData = Object.values(hydratedSources).some((entries) => Array.isArray(entries) && entries.length > 0);
    const currentSources = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();

    if (hasHydratedData && JSON.stringify(currentSources) !== JSON.stringify(hydratedSources)) {
      setEditForm((current) => ({
        ...current,
        budgetSourceOptions: hydratedSources,
        hasBudget: current.hasBudget ?? Number(current.budget || 0) > 0,
        budgetSource: current.budgetSource || 'none',
      }));
    }
  }, [open, editForm?.budgetSourceOptions, editForm?.budgetBreakdown, editForm?.budget_breakdown, editForm?.budgetSourceDetails, editForm?.budget_source_details]);

  useEffect(() => {
    if (!open) return;

    const loadCompletedProjects = async () => {
      try {
        setIsLoadingProjects(true);
        const response = await fetch('/api/projects', {
          headers: {
            Accept: 'application/json',
            'X-Requested-With': 'XMLHttpRequest',
          },
        });

        if (!response.ok) throw new Error('Failed to load completed projects');

        const data = await response.json();
        const normalized = Array.isArray(data) ? data : [];
        const completed = normalized.filter((p) => {
          if (String(p?.id) === String(projectId)) return false;

          const status = String(p?.status || '').toLowerCase();
          const approvalStatus = String(p?.approval_status || '').toLowerCase();
          const endDate = p?.end_date || p?.endDate;
          const hasEnded = endDate ? new Date(endDate) < new Date() : false;

          return status === 'complete' || status === 'completed' || (approvalStatus === 'approved' && hasEnded);
        });

        setCompletedProjects(completed);
      } catch (error) {
        console.error('Failed to load completed projects:', error);
        setCompletedProjects([]);
      } finally {
        setIsLoadingProjects(false);
      }
    };

    loadCompletedProjects();
  }, [open, projectId]);

  const handleFileUpload = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      showToast('File size must be less than 2MB due to the lack of storage space', 'error');
      return;
    }
    setSelectedFile(file);
    setFilePreview({
      name: file.name,
      size: (file.size / (1024 * 1024)).toFixed(2) + ' MB'
    });
  };

  const handleSave = async () => {
  if (!editForm.title || !editForm.category || !editForm.description || !editForm.proposedBy) {
    showToast('Please fill in all required fields', 'error');
    return;
  }

  if (editForm.hasBudget && editForm.budgetSource === 'none') {
    const sourceOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
    const selectedSources = Object.entries(sourceOptions)
      .flatMap(([key, entries]) => (Array.isArray(entries) ? entries.map((entry) => ({ ...entry, key })) : []))
      .filter((entry) => String(entry?.name || '').trim() || Number(entry?.amount || 0) > 0);

    if (selectedSources.length === 0) {
      showToast('Please select at least one budget source', 'error');
      return;
    }

    const invalidSource = Object.entries(sourceOptions)
      .flatMap(([key, entries]) => (Array.isArray(entries) ? entries.map((entry) => ({ ...entry, key })) : []))
      .some((entry) => {
        const hasValue = String(entry?.name || '').trim() || Number(entry?.amount || 0) > 0;
        if (!hasValue) return false;
        return !String(entry?.name || '').trim() || Number(entry?.amount || 0) <= 0;
      });

    if (invalidSource) {
      showToast('Please provide each selected source name and amount', 'error');
      return;
    }

    const autoBudgetTotal = getBudgetSourceTotal(sourceOptions);
    if (!autoBudgetTotal || autoBudgetTotal <= 0) {
      showToast('Budget total must be greater than zero', 'error');
      return;
    }

    setEditForm({ ...editForm, budget: String(autoBudgetTotal) });
  }

  if (editForm.hasBudget && editForm.budgetSource === 'past_project') {
    if (!editForm.transferAmount || parseFloat(editForm.transferAmount) <= 0) {
      showToast('Please enter a transfer amount greater than zero', 'error');
      return;
    }

    const eligibleProjects = (completedProjects || []).filter((p) => Number(p?.budget || 0) > 0);
    const availableRemainingBudget = eligibleProjects.reduce(
      (total, project) => total + Math.max(0, Number(project?.budget || 0)),
      0,
    );
    const transferAmount = Number(editForm.transferAmount || 0);

    if (transferAmount > availableRemainingBudget) {
      showToast(`Transfer amount cannot exceed the overall remaining balance of ₱${availableRemainingBudget.toLocaleString('en-PH', { maximumFractionDigits: 2 })}`, 'error');
      return;
    }
  }

    const hasPositiveBudget = editForm.hasBudget && (
      (editForm.budgetSource === 'past_project' && parseFloat(editForm.transferAmount) > 0) ||
      (editForm.budgetSource !== 'past_project' && parseFloat(editForm.budget) > 0)
    );
    const hasExistingProof = Boolean(editForm.projectProof || editForm.project_proof);

    if (hasPositiveBudget && !selectedFile && !hasExistingProof) {
      showToast('Please attach proof of the project budget', 'error');
      return;
    }

  setIsUploading(true);

  try {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    // Create FormData for file upload
    const sourceOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
    const selectedBudgetSources = Object.entries(sourceOptions)
      .flatMap(([key, entries]) => (Array.isArray(entries) ? entries.map((entry) => ({
        key,
        id: entry?.id || `${key}-${Math.random()}`,
        name: String(entry?.name || '').trim(),
        amount: Number(entry?.amount || 0),
      })) : []))
      .filter((entry) => String(entry?.name || '').trim() || Number(entry?.amount || 0) > 0);
    const autoBudgetTotal = getBudgetSourceTotal(sourceOptions);
    const submittedBudget = editForm.hasBudget
      ? (editForm.budgetSource === 'past_project'
          ? String(Number(editForm.transferAmount || editForm.budget || 0))
          : (editForm.budgetSource === 'none' ? String(autoBudgetTotal) : (editForm.budget || '')))
      : '';

    const formData = new FormData();
    formData.append('_method', 'PUT'); // Laravel method spoofing

    // Include ALL fields, preserving existing data
    formData.append('title', editForm.title);
    formData.append('description', editForm.description);
    formData.append('objective', editForm.objective || '');
    formData.append('venue', editForm.venue || '');
    formData.append('category', editForm.category);
    formData.append('budget', submittedBudget);
    formData.append('has_budget', editForm.hasBudget ? '1' : '0');
    formData.append('budget_source', editForm.hasBudget ? (editForm.budgetSource || 'none') : 'none');
    formData.append('budget_source_type', editForm.hasBudget && editForm.budgetSource === 'none' ? selectedBudgetSources.map((entry) => entry.key).join(',') : '');
    formData.append('budget_source_details', editForm.hasBudget && editForm.budgetSource === 'none' ? JSON.stringify({
      sponsorship: (editForm.budgetSourceOptions?.sponsorship || []).map((entry) => ({ name: String(entry?.name || '').trim(), amount: Number(entry?.amount || 0) })),
      donation: (editForm.budgetSourceOptions?.donation || []).map((entry) => ({ name: String(entry?.name || '').trim(), amount: Number(entry?.amount || 0) })),
    }) : '');
    formData.append('transfer_from_project_id', editForm.transferFromProjectId || '');
    formData.append('transfer_amount', editForm.transferAmount || '');
    formData.append('proposed_by', editForm.proposedBy);
    formData.append('start_date', editForm.startDate);
    formData.append('end_date', editForm.endDate);

    // CRITICAL: Preserve existing fields
    formData.append('status', editForm.status || 'Draft');
    formData.append('approval_status', editForm.approvalStatus || 'Draft');
    formData.append('archive', editForm.archive !== undefined ? editForm.archive : 0);
    formData.append('note', editForm.note || '');
    formData.append('approve_by', editForm.approveBy || '');

    // Append file if selected
    if (selectedFile) {
      formData.append('project_proof', selectedFile);
    }

    const res = await fetch(`/api/projects/${projectId}`, {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'X-CSRF-TOKEN': token,
        'Accept': 'application/json',
      },
      body: formData,
    });

    if (!res.ok) {
      let msg = 'Failed to update project';
      try {
        const errData = await res.json();
        if (errData && errData.message) msg = errData.message;
      } catch {}
      throw new Error(msg);
    }

    const updatedProject = await res.json();

    showToast('Project updated successfully', 'success');
    onSave(updatedProject);
    handleClose();
    
    // Reload page to show all updated data
    setTimeout(() => window.location.reload(), 500);
  } catch (err) {
    showToast(err.message, 'error');
  } finally {
    setIsUploading(false);
  }
};

  const handleClose = () => {
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    onClose();
  };

  return (
    <Modal open={open} onClose={handleClose} title="Edit Project" description="Update project information">
      <div className="space-y-4">
        {/* Project Title */}
        <div>
          <FieldLabel>Project Title *</FieldLabel>
          <Input
            value={editForm.title || ''}
            onChange={(e) => setEditForm({ ...editForm, title: e.target.value })}
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Category */}
        <div>
          <FieldLabel>Category *</FieldLabel>
          <Select value={editForm.category || ''} onValueChange={(value) => setEditForm({ ...editForm, category: value })}>
            <option value="">Select category</option>
            <option value="Social">Social</option>
            <option value="Sports">Sports</option>
            <option value="Environmental">Environmental</option>
            <option value="Technology">Technology</option>
            <option value="Cultural">Cultural</option>
            <option value="Education">Education</option>
            <option value="Health">Health</option>
          </Select>
        </div>

        {/* Objective */}
        <div>
          <FieldLabel>Objective *</FieldLabel>
          <Textarea
            placeholder="Describe the main objective of the project"
            value={editForm.objective || ''}
            onChange={(e) => setEditForm({ ...editForm, objective: e.target.value })}
            rows={3}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Description */}
        <div>
          <FieldLabel>Description *</FieldLabel>
          <Textarea
            placeholder="Describe the project details and goals"
            value={editForm.description || ''}
            onChange={(e) => setEditForm({ ...editForm, description: e.target.value })}
            rows={4}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Venue */}
        <div>
          <FieldLabel>Venue *</FieldLabel>
          <Input
            placeholder="Enter project venue/location"
            value={editForm.venue || ''}
            onChange={(e) => setEditForm({ ...editForm, venue: e.target.value })}
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Budget */}
        <div className="rounded-xl border border-gray-200 p-4 space-y-3">
          <FieldLabel>Project Budget</FieldLabel>
          <div className="flex flex-wrap gap-4">
            <label className="flex items-center gap-2 text-sm text-gray-700">
              <input
                type="radio"
                name="edit-has-budget"
                checked={editForm.hasBudget === true}
                onChange={() => setEditForm({ ...editForm, hasBudget: true, budget: editForm.budget || '', budgetSource: editForm.budgetSource || 'none' })}
              />
              Yes, this project has a budget
            </label>
            <label className="flex items-center gap-2 text-sm text-gray-700">
              <input
                type="radio"
                name="edit-has-budget"
                checked={editForm.hasBudget === false}
                onChange={() => setEditForm({ ...editForm, hasBudget: false, budget: '', budgetSource: 'none', transferFromProjectId: '', transferAmount: '' })}
              />
              No budget yet
            </label>
          </div>

          {editForm.hasBudget && editForm.budgetSource === 'none' && (
            <div className="hidden">
              <FieldLabel>Budget Amount</FieldLabel>
              <Input
                type="number"
                placeholder="Auto-calculated from selected sources"
                value={String(getBudgetSourceTotal(editForm.budgetSourceOptions || getDefaultBudgetSourceOptions()))}
                min="0"
                step="0.01"
                readOnly
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 text-gray-600 cursor-not-allowed"
              />
            </div>
          )}
        </div>

        {/* Budget Source */}
        {editForm.hasBudget && (
          <div className="rounded-xl border border-gray-200 p-4 space-y-3">
            <FieldLabel>Budget Source</FieldLabel>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="radio"
                  name="edit-budget-source"
                  checked={editForm.budgetSource === 'none'}
                  onChange={() => setEditForm({ ...editForm, budgetSource: 'none', transferFromProjectId: '', transferAmount: '', budget: editForm.budget || '' })}
                />
                Use a newly created budget
              </label>
              <label className="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="radio"
                  name="edit-budget-source"
                  checked={editForm.budgetSource === 'past_project'}
                  onChange={() => setEditForm({ ...editForm, budgetSource: 'past_project', budget: editForm.transferAmount || editForm.budget || '' })}
                />
                Use remaining budget from a completed project
              </label>
            </div>

            {editForm.budgetSource === 'none' && (
              <div className="space-y-3">
                <div className="rounded-lg border border-blue-100 bg-blue-50 p-3 text-sm text-blue-700">
                  Enter the budget amount for this project.
                </div>

                <div>
                  <FieldLabel>Where did this budget come from? *</FieldLabel>
                  <div className="space-y-3">
                    {[
                      { value: 'sponsorship', label: 'Sponsorship' },
                      { value: 'donation', label: 'Donation' },
                    ].map((option) => {
                      const entries = getBudgetSourceEntries(editForm.budgetSourceOptions, option.value);
                      const selected = entries.length > 0;
                      return (
                        <div key={option.value} className="rounded-xl border border-gray-200 p-3">
                          <div className="flex items-center justify-between gap-3">
                            <label className="flex items-center gap-2 text-sm text-gray-700 font-medium">
                              <input
                                type="checkbox"
                                checked={selected}
                                onChange={(e) => {
                                  const currentOptions = normalizeBudgetSourceOptions(editForm.budgetSourceOptions);
                                  const updatedOptions = {
                                    ...currentOptions,
                                    [option.value]: e.target.checked ? [{ id: `${option.value}-1`, name: '', amount: '' }] : [],
                                  };
                                  setEditForm({
                                    ...editForm,
                                    budget: String(getBudgetSourceTotal(updatedOptions)),
                                    budgetSourceOptions: updatedOptions,
                                  });
                                }}
                              />
                              {option.label}
                            </label>
                            {selected && (
                              <button
                                type="button"
                                onClick={() => {
                                  const currentOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
                                  const updatedOptions = addBudgetSourceEntry(currentOptions, option.value);
                                  setEditForm({
                                    ...editForm,
                                    budget: String(getBudgetSourceTotal(updatedOptions)),
                                    budgetSourceOptions: updatedOptions,
                                  });
                                }}
                                className="text-xs font-medium text-blue-600 hover:text-blue-700"
                              >
                                + Add {option.label}
                              </button>
                            )}
                          </div>

                          {selected && (
                            <div className="mt-3 space-y-3">
                              {entries.map((entry, index) => (
                                <div key={entry.id || `${option.value}-${index}`} className="grid grid-cols-1 md:grid-cols-[1.2fr_1fr_auto] gap-3">
                                  <div>
                                    <FieldLabel>{option.label} Name *</FieldLabel>
                                    <Input
                                      placeholder={option.value === 'sponsorship' ? 'e.g. ABC Corporation' : 'e.g. Alumni Donors'}
                                      value={entry.name || ''}
                                      onChange={(e) => {
                                        const currentOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
                                        const nextEntries = [...getBudgetSourceEntries(currentOptions, option.value)];
                                        nextEntries[index] = { ...entry, name: e.target.value };
                                        setEditForm({
                                          ...editForm,
                                          budget: String(getBudgetSourceTotal({ ...currentOptions, [option.value]: nextEntries })),
                                          budgetSourceOptions: { ...currentOptions, [option.value]: nextEntries },
                                        });
                                      }}
                                      className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                                    />
                                  </div>
                                  <div>
                                    <FieldLabel>{option.label} Amount *</FieldLabel>
                                    <Input
                                      type="number"
                                      min="0"
                                      step="0.01"
                                      placeholder="0.00"
                                      value={entry.amount || ''}
                                      onChange={(e) => {
                                        const currentOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
                                        const nextEntries = [...getBudgetSourceEntries(currentOptions, option.value)];
                                        nextEntries[index] = { ...entry, amount: e.target.value };
                                        setEditForm({
                                          ...editForm,
                                          budget: String(getBudgetSourceTotal({ ...currentOptions, [option.value]: nextEntries })),
                                          budgetSourceOptions: { ...currentOptions, [option.value]: nextEntries },
                                        });
                                      }}
                                      className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                                    />
                                  </div>
                                  <div className="flex items-end">
                                    <button
                                      type="button"
                                      onClick={() => {
                                        const currentOptions = editForm.budgetSourceOptions || getDefaultBudgetSourceOptions();
                                        const nextEntries = getBudgetSourceEntries(currentOptions, option.value).filter((_, itemIndex) => itemIndex !== index);
                                        const updatedOptions = { ...currentOptions, [option.value]: nextEntries };
                                        setEditForm({
                                          ...editForm,
                                          budget: String(getBudgetSourceTotal(updatedOptions)),
                                          budgetSourceOptions: updatedOptions,
                                        });
                                      }}
                                      className="h-10 px-3 rounded-xl border border-red-200 bg-red-50 text-red-600 text-sm"
                                    >
                                      Remove
                                    </button>
                                  </div>
                                </div>
                              ))}
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>

                <div className="rounded-lg border border-slate-200 bg-slate-50 p-3">
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-slate-600">Auto-calculated total</span>
                    <strong className="text-slate-900">
                      ₱{getBudgetSourceTotal(editForm.budgetSourceOptions || getDefaultBudgetSourceOptions()).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                    </strong>
                  </div>
                </div>
              </div>
            )}

            {editForm.budgetSource === 'past_project' && (
              <div className="space-y-3">
                {(() => {
                  const eligibleProjects = (completedProjects || []).filter((p) => Number(p?.budget || 0) > 0);
                  const availableRemainingBudget = eligibleProjects.reduce(
                    (total, project) => total + Math.max(0, Number(project?.budget || 0)),
                    0,
                  );

                  if (eligibleProjects.length === 0) {
                    return (
                      <div className="rounded-lg border border-amber-200 bg-amber-50 p-3 text-sm text-amber-700">
                        No completed projects with a remaining budget are available right now.
                      </div>
                    );
                  }

                  return (
                    <>
                      <div className="rounded-lg border border-green-200 bg-green-50 p-3 text-sm text-green-800">
                        Overall available remaining budget: <strong>₱{availableRemainingBudget.toLocaleString('en-PH', { maximumFractionDigits: 2 })}</strong>
                        <p className="mt-1 text-xs text-green-700">Funds will be combined automatically from completed projects when needed.</p>
                      </div>

                      <div>
                        <FieldLabel>Transfer Amount *</FieldLabel>
                        <Input
                          type="number"
                          placeholder="Enter amount to transfer"
                          value={editForm.transferAmount || ''}
                          onChange={(e) => {
                            const nextAmount = e.target.value;
                            setEditForm({
                              ...editForm,
                              transferAmount: nextAmount,
                              budget: nextAmount,
                            });
                          }}
                          min="0"
                          step="0.01"
                          className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                        />
                      </div>
                    </>
                  );
                })()}
                {isLoadingProjects && <p className="mt-1 text-xs text-gray-500">Loading completed projects...</p>}
              </div>
            )}
          </div>
        )}

        {/* File Upload */}
        <div>
          <FieldLabel>Project Budget Proof {editForm.hasBudget ? '(Required)' : '(Optional)'}</FieldLabel>
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
            {editForm.projectProof && !selectedFile && (
              <div className="w-full rounded-xl border border-green-200 bg-green-50 p-3">
                {(() => {
                  const { url, fileName, extension } = getProofDetails(editForm.projectProof);
                  const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];

                  if (imageExtensions.includes(extension)) {
                    return (
                      <div>
                        {/* <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof: {fileName}</p> */}
                        <img src={url} alt="Current project proof" className="max-h-64 w-full rounded-lg object-contain" />
                      </div>
                    );
                  }

                  if (extension === 'pdf') {
                    return (
                      <div>
                        {/* <p className="mb-2 text-sm font-medium text-gray-900">Current uploaded proof: {fileName}</p> */}
                        <iframe src={url} title="Current project proof" className="h-64 w-full rounded-lg border-0" />
                      </div>
                    );
                  }

                  return (
                    <div className="flex items-center gap-3">
                      <FileText className="h-5 w-5 flex-shrink-0 text-green-600" />
                      <a href={url} target="_blank" rel="noreferrer" className="truncate text-sm text-blue-600 underline">
                        {fileName}
                      </a>
                    </div>
                  );
                })()}
              </div>
            )}
          </div>
        </div>

        {/* Proposed By */}
        <div>
          <FieldLabel>Proposed by *</FieldLabel>
          <Input
            placeholder="Enter name of proposer"
            value={editForm.proposedBy || ''}
            onChange={(e) => setEditForm({ ...editForm, proposedBy: e.target.value })}
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Dates */}
        <div className="grid grid-cols-2 gap-4">
          <div>
            <FieldLabel>Start Date</FieldLabel>
            <Input
              type="date"
              min={getMinimumStartDate()}
              value={editForm.startDate || ''}
              onChange={(e) => {
                const selectedDate = e.target.value;
                const minDate = getMinimumStartDate();
                
                if (selectedDate && selectedDate < minDate) {
                  showToast('Start date must be at least 1 month from today', 'error');
                  return;
                }
                
                setEditForm({ ...editForm, startDate: selectedDate });
              }}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>
          <div>
            <FieldLabel>End Date</FieldLabel>
            <Input
              type="date"
              min={getMinimumEndDate(editForm.startDate)}
              value={editForm.endDate || ''}
              onChange={(e) => setEditForm({ ...editForm, endDate: e.target.value })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>
        </div>

        {/* Buttons */}
        <div className="flex gap-3 pt-4 bottom-0 bg-white py-4 border-t">
          <Button variant="outline" onClick={handleClose} className="flex-1 rounded-xl" disabled={isUploading}>
            Cancel
          </Button>
          <Button
            onClick={handleSave}
            className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
            disabled={!editForm.title || !editForm.category || !editForm.description || !editForm.proposedBy || isUploading}
          >
            {isUploading ? 'Saving...' : 'Save Changes'}
          </Button>
        </div>
      </div>
    </Modal>
  );
}