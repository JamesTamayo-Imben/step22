import React, { useState, useRef, useEffect } from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Textarea } from '@/Components/ui/textarea';
import {
  Upload,
  X,
  FileText,
  Plus,
} from 'lucide-react';
import { computeBudgetFromEntries, projectBudgetMismatch } from '@/utils/projectBudget';

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

// ─── Create Project Modal ───────────────────────────────────────────────────

export function CreateProjectModal({
  open,
  onClose,
  newProject,
  setNewProject,
  onSave,
}) {
  const fileInputRef = useRef(null);
  const [filePreview, setFilePreview] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [completedProjects, setCompletedProjects] = useState([]);
  const [isLoadingProjects, setIsLoadingProjects] = useState(false);
  const [ledgerEntries, setLedgerEntries] = useState([]);

  useEffect(() => {
    if (!open) return;

    const loadCompletedProjects = async () => {
      try {
        setIsLoadingProjects(true);
        const [projectsResponse, ledgerResponse] = await Promise.all([
          fetch('/api/projects', {
            headers: {
              Accept: 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
          }),
          fetch('/api/ledger-entries', {
            headers: {
              Accept: 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
          }),
        ]);

        if (!projectsResponse.ok) throw new Error('Failed to load completed projects');
        if (!ledgerResponse.ok) throw new Error('Failed to load ledger entries');

        const projectsData = await projectsResponse.json();
        const ledgerData = await ledgerResponse.json();
        const normalizedProjects = Array.isArray(projectsData) ? projectsData : [];
        const normalizedLedgerEntries = Array.isArray(ledgerData) ? ledgerData : [];
        setLedgerEntries(normalizedLedgerEntries);

        const completed = normalizedProjects.filter((project) => {
          const status = String(project?.status || '').toLowerCase();
          const approvalStatus = String(project?.approval_status || '').toLowerCase();
          const endDate = project?.end_date || project?.endDate;
          const hasEnded = endDate ? new Date(endDate) < new Date() : false;

          return status === 'complete' || status === 'completed' || (approvalStatus === 'approved' && hasEnded);
        });

        const eligible = completed.filter((project) => {
          const projectId = String(project?.id || '');
          const projectLedgers = normalizedLedgerEntries.filter((entry) => {
            const entryProjectId = String(entry?.project_id || entry?.projectId || '');
            return entryProjectId === projectId && (entry?.approval_status || entry?.status) === 'Approved';
          });

          const displayBudget = Number(project?.budget || 0);
          const computedFromLedger = computeBudgetFromEntries(projectLedgers);
          const hasMismatch = displayBudget > 0 && projectLedgers.length > 0 && projectBudgetMismatch(displayBudget, computedFromLedger, projectLedgers.length > 0);
          const hasTampered = projectLedgers.some((entry) => entry?.verificationState?.tampered || entry?.tampered || entry?.verification_state?.tampered);
          const hasTamperedMetadata = Number(project?.tamperedAlerts || 0) > 0 || project?.isTampered === true;

          return Number(project?.budget || 0) > 0 && !hasMismatch && !hasTampered && !hasTamperedMetadata;
        });

        setCompletedProjects(eligible);
      } catch (error) {
        console.error('Failed to load completed projects:', error);
        setCompletedProjects([]);
        setLedgerEntries([]);
      } finally {
        setIsLoadingProjects(false);
      }
    };

    loadCompletedProjects();
  }, [open]);

  const handleFileUpload = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (file.size > 10 * 1024 * 1024) {
      showToast('File size must be less than 10MB', 'error');
      return;
    }

    setSelectedFile(file);
    setFilePreview({
      name: file.name,
      size: (file.size / (1024 * 1024)).toFixed(2) + ' MB'
    });
  };

  const handleCreateProject = async () => {
    if (!newProject.title || !newProject.category || !newProject.description ||
      !newProject.objective || !newProject.venue || !newProject.proposedBy) {
      showToast('Please fill in all required fields', 'error');
      return;
    }

    if (newProject.hasBudget && newProject.budgetSource === 'none' && (!newProject.budget || parseFloat(newProject.budget) <= 0)) {
      showToast('Please enter a valid budget amount for a newly created budget', 'error');
      return;
    }

    if (newProject.hasBudget && newProject.budgetSource === 'past_project') {
      if (!newProject.transferFromProjectId) {
        showToast('Please select a completed project to transfer budget from', 'error');
        return;
      }

      if (!newProject.transferAmount || parseFloat(newProject.transferAmount) <= 0) {
        showToast('Please enter a transfer amount greater than zero', 'error');
        return;
      }

      //also dont add the tamper check for transfer amount exceeding remaining balance
      const selectedProject = completedProjects.find((project) => String(project.id) === String(newProject.transferFromProjectId));
      const remainingBalance = Number(selectedProject?.budget || 0);
      const transferAmount = Number(newProject.transferAmount || 0);

      if (transferAmount > remainingBalance) {
        showToast(`Transfer amount cannot exceed the remaining balance of ₱${remainingBalance.toLocaleString('en-PH', { maximumFractionDigits: 2 })}`, 'error');
        return;
      }
    }

    setIsLoading(true);

    const formData = new FormData();
    formData.append('title', newProject.title);
    formData.append('description', newProject.description);
    formData.append('objective', newProject.objective);
    formData.append('venue', newProject.venue);
    formData.append('category', newProject.category);
    formData.append('budget', newProject.hasBudget ? (newProject.budget || '') : '');
    formData.append('has_budget', newProject.hasBudget ? '1' : '0');
    formData.append('is_active', '0');
    formData.append('budget_source', newProject.hasBudget ? (newProject.budgetSource || 'none') : 'none');
    formData.append('transfer_from_project_id', newProject.transferFromProjectId || '');
    formData.append('transfer_amount', newProject.transferAmount || '');
    formData.append('status', 'Draft');
    formData.append('proposed_by', newProject.proposedBy);
    formData.append('start_date', newProject.startDate);
    formData.append('end_date', newProject.endDate);
    formData.append('approval_status', 'Draft');
    formData.append('archive', '0');
    // Set is_initial to 1 if budget is provided, 0 otherwise
    formData.append('is_initial', newProject.hasBudget && newProject.budget && parseFloat(newProject.budget) > 0 ? '1' : '0');

    if (selectedFile) {
      formData.append('project_proof', selectedFile);
    }

    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

      const response = await fetch('/api/projects', {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData,
      });

      // Check if response is ok first
      if (!response.ok) {
        console.error('❌ Server error response:', response.status, response.statusText);
        const contentType = response.headers.get('content-type') || '';
        const isJsonResponse = contentType.includes('application/json');
        
        if (isJsonResponse) {
          const data = await response.json();
          throw new Error(data.message || `Server error: ${response.status}`);
        } else {
          const text = await response.text();
          console.error('Non-JSON response:', text.substring(0, 500));
          throw new Error(`Server error: ${response.status} - ${response.statusText}`);
        }
      }

      // Try to parse JSON response
      const contentType = response.headers.get('content-type') || '';
      const isJsonResponse = contentType.includes('application/json');
      
      if (!isJsonResponse) {
        throw new Error('Server did not return JSON response');
      }

      const data = await response.json();

      showToast('Project created successfully', 'success');
      handleClose();

      // Call onSave callback
      if (onSave) {
        onSave(data);
      }
    } catch (err) {
      console.error('❌ Project creation error:', err);
      showToast(err.message || 'Failed to create project', 'error');
    } finally {
      setIsLoading(false);
    }
  };

  const handleClose = () => {
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    onClose();
  };

  return (
    <Modal open={open} onClose={handleClose} title="Create New Project" description="Fill in the project details below">
      <div className="space-y-4">
        {/* Project Title */}
        <div>
          <FieldLabel>Project Title *</FieldLabel>
          <Input
            placeholder="Enter project title"
            value={newProject.title || ''}
            onChange={(e) => setNewProject({ ...newProject, title: e.target.value })}
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Category */}
        <div>
          <FieldLabel>Category *</FieldLabel>
          <Select
            value={newProject.category || ''}
            onValueChange={(value) => setNewProject({ ...newProject, category: value })}
          >
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
            value={newProject.objective || ''}
            onChange={(e) => setNewProject({ ...newProject, objective: e.target.value })}
            rows={3}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Description */}
        <div>
          <FieldLabel>Description *</FieldLabel>
          <Textarea
            placeholder="Describe the project objectives and goals"
            value={newProject.description || ''}
            onChange={(e) => setNewProject({ ...newProject, description: e.target.value })}
            rows={4}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Venue */}
        <div>
          <FieldLabel>Venue *</FieldLabel>
          <Input
            placeholder="Enter project venue/location"
            value={newProject.venue || ''}
            onChange={(e) => setNewProject({ ...newProject, venue: e.target.value })}
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
                name="has-budget"
                checked={newProject.hasBudget === true}
                onChange={() => setNewProject({ ...newProject, hasBudget: true, budget: newProject.budget || '' })}
              />
              Yes, this project has a budget
            </label>
            <label className="flex items-center gap-2 text-sm text-gray-700">
              <input
                type="radio"
                name="has-budget"
                checked={newProject.hasBudget === false}
                onChange={() => setNewProject({ ...newProject, hasBudget: false, budget: '', budgetSource: 'none', transferFromProjectId: '', transferAmount: '' })}
              />
              No budget yet
            </label>
          </div>

          {newProject.hasBudget && newProject.budgetSource === 'none' && (
            <div>
              <FieldLabel>Budget Amount *</FieldLabel>
              <Input
                type="number"
                placeholder="Enter project budget amount"
                value={newProject.budget || ''}
                onChange={(e) => setNewProject({ ...newProject, budget: e.target.value })}
                min="0"
                step="0.01"
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
              />
            </div>
          )}
        </div>

        {/* Budget Source */}
        {newProject.hasBudget && (
          <div className="rounded-xl border border-gray-200 p-4 space-y-3">
            <FieldLabel>Budget Source</FieldLabel>
            <div className="flex flex-wrap gap-4">
              <label className="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="radio"
                  name="budget-source"
                  checked={newProject.budgetSource === 'none'}
                  onChange={() => setNewProject({ ...newProject, budgetSource: 'none', transferFromProjectId: '', transferAmount: '' })}
                />
                Use a newly created budget
              </label>
              <label className="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="radio"
                  name="budget-source"
                  checked={newProject.budgetSource === 'past_project'}
                  onChange={() => setNewProject({ ...newProject, budgetSource: 'past_project', transferFromProjectId: '', transferAmount: '' })}
                />
                Use remaining budget from a completed project
              </label>
            </div>

            {newProject.budgetSource === 'none' && (
              <div className="rounded-lg border border-blue-100 bg-blue-50 p-3 text-sm text-blue-700">
                Enter the budget amount for this new project.
              </div>
            )}

            {newProject.budgetSource === 'past_project' && (
              <div className="space-y-3">
                {(() => {
                  const eligibleProjects = (completedProjects || []).filter((project) => {
                    const hasTamperedMetadata = Number(project?.tamperedAlerts || 0) > 0 || project?.isTampered === true;
                    const hasMismatchMetadata = project?.isBudgetMismatch === true || project?.budgetMismatch === true;
                    return Number(project?.budget || 0) > 0 && !hasTamperedMetadata && !hasMismatchMetadata;
                  });

                  if (eligibleProjects.length === 0) {
                    return (
                      <div className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700">
                        No completed projects with a remaining budget are available right now.
                      </div>
                    );
                  }

                  return (
                    <>
                      <div>
                        <FieldLabel>Completed Project *</FieldLabel>
                        <Select
                          value={newProject.transferFromProjectId || ''}
                          onValueChange={(value) => setNewProject({ ...newProject, transferFromProjectId: value })}
                        >
                          <option value="">Select a completed project</option>
                          {eligibleProjects.map((project) => {
                            const remainingBalance = Number(project?.budget || 0);
                            return (
                              <option key={project.id} value={project.id}>
                                {project.title} — Balance: ₱{remainingBalance.toLocaleString('en-PH', { maximumFractionDigits: 2 })}
                              </option>
                            );
                          })}
                        </Select>
                      </div>

                      <div>
                        <FieldLabel>Transfer Amount *</FieldLabel>
                        <Input
                          type="number"
                          placeholder="Enter amount to transfer"
                          value={newProject.transferAmount || ''}
                          onChange={(e) => setNewProject({ ...newProject, transferAmount: e.target.value })}
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
          <FieldLabel>Project Budget Proof (Optional)</FieldLabel>
          <div className="flex flex-col items-center gap-3">
            <button
              type="button"
              className="w-full border-2 border-dashed border-gray-300 rounded-xl p-8 flex flex-col items-center justify-center hover:bg-gray-50 transition"
              onClick={() => fileInputRef.current?.click()}
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
          </div>
        </div>

        {/* Proposed By */}
        <div>
          <FieldLabel>Proposed by *</FieldLabel>
          <Input
            placeholder="Enter name of proposer"
            value={newProject.proposedBy || ''}
            onChange={(e) => setNewProject({ ...newProject, proposedBy: e.target.value })}
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Dates */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <FieldLabel>Start Date</FieldLabel>
            <Input
              type="date"
              min={getMinimumStartDate()}
              value={newProject.startDate || ''}
              onChange={(e) => {
                const selectedDate = e.target.value;
                const minDate = getMinimumStartDate();
                
                if (selectedDate && selectedDate < minDate) {
                  showToast('Start date must be at least 1 month from today', 'error');
                  return;
                }
                
                setNewProject({ ...newProject, startDate: selectedDate });
              }}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>
          <div>
            <FieldLabel>End Date</FieldLabel>
            <Input
              type="date"
              min={getMinimumEndDate(newProject.startDate)}
              value={newProject.endDate || ''}
              onChange={(e) => {
                const selectedDate = e.target.value;
                const minDate = getMinimumEndDate(newProject.startDate);
                
                if (selectedDate && selectedDate < minDate) {
                  showToast('End date must be at least one day after the start date', 'error');
                  return;
                }
                
                setNewProject({ ...newProject, endDate: selectedDate });
              }}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>
        </div>

        {/* Buttons */}
        <div className="flex gap-3 pt-4">
          <Button
            variant="outline"
            onClick={handleClose}
            className="flex-1 rounded-xl"
            disabled={isLoading}
          >
            Cancel
          </Button>
          <Button
            onClick={handleCreateProject}
            disabled={
              !newProject.title ||
              !newProject.category ||
              !newProject.description ||
              !newProject.objective ||
              !newProject.venue ||
              !newProject.proposedBy ||
              isLoading
            }
            className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
          >
            {isLoading ? 'Creating...' : 'Create Project'}
          </Button>
        </div>
      </div>
    </Modal>
  );
}
