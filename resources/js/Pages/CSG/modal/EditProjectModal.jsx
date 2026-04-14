import React, { useState, useRef } from 'react';
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

  const handleSave = async () => {
  if (!editForm.title || !editForm.category || !editForm.description || !editForm.proposedBy) {
    showToast('Please fill in all required fields', 'error');
    return;
  }

  setIsUploading(true);

  try {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    // Create FormData for file upload
    const formData = new FormData();
    formData.append('_method', 'PUT'); // Laravel method spoofing

    // Include ALL fields, preserving existing data
    formData.append('title', editForm.title);
    formData.append('description', editForm.description);
    formData.append('objective', editForm.objective || '');
    formData.append('venue', editForm.venue || '');
    formData.append('category', editForm.category);
    formData.append('budget', editForm.budget || 0);
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
        <div>
          <FieldLabel>Project Budget (₱)</FieldLabel>
          <Input
            type="number"
            placeholder="Enter project budget amount"
            value={editForm.budget || ''}
            onChange={(e) => setEditForm({ ...editForm, budget: e.target.value })}
            min="0"
            step="0.01"
            className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

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
              <p className="text-sm text-gray-600 mt-2">Click to upload new file</p>
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
              value={editForm.startDate || ''}
              onChange={(e) => setEditForm({ ...editForm, startDate: e.target.value })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
            />
          </div>
          <div>
            <FieldLabel>End Date</FieldLabel>
            <Input
              type="date"
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