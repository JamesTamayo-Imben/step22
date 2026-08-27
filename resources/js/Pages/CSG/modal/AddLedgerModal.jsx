import React, { useState, useRef, useEffect } from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Textarea } from '@/Components/ui/textarea';
import { toast } from 'react-hot-toast';
import {
  Edit,
  Trash2,
  Send,
  Plus,
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

// ─── Add Ledger Entry Modal ──────────────────────────────────────────────────

export function AddLedgerModal({ open, onClose, ledgerForm, setLedgerForm, onSave, projectId, projectBudgetBreakdown = [] }) {
  const fileInputRef = useRef(null);
  const [filePreview, setFilePreview] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [isUploading, setIsUploading] = useState(false);

  // Budget items state for the ledger entry
  const [budgetItems, setBudgetItems] = useState([
    { id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }
  ]);

  // Calculate item total
  const calculateItemTotal = (item) => {
    if (item.qty && item.unitPrice) {
      const qty = parseFloat(item.qty) || 0;
      const unitPrice = parseFloat(item.unitPrice) || 0;
      return qty * unitPrice;
    }
    return parseFloat(item.amount) || 0;
  };

  // Calculate total budget from all items
  const calculateTotalBudget = () => {
    return budgetItems.reduce((sum, item) => sum + calculateItemTotal(item), 0);
  };

  // Add budget item
  const addBudgetItem = () => {
    const newId = budgetItems.length > 0
      ? Math.max(...budgetItems.map(item => item.id)) + 1
      : 1;
    setBudgetItems([...budgetItems, {
      id: newId,
      item: '',
      quantity: 1,
      unitPrice: '',
      amount: 0
    }]);
  };

  // Remove budget item
  const removeBudgetItem = (id) => {
    if (budgetItems.length > 1) {
      setBudgetItems(budgetItems.filter(item => item.id !== id));
    }
  };

  // Update budget item
  const updateBudgetItem = (id, field, value) => {
    setBudgetItems(budgetItems.map(item => {
      if (item.id === id) {
        const updatedItem = { ...item, [field]: value };

        if (field === 'qty' || field === 'unitPrice') {
          const qty = field === 'qty' ? parseFloat(value) || 0 : parseFloat(item.qty) || 0;
          const unitPrice = field === 'unitPrice' ? parseFloat(value) || 0 : parseFloat(item.unitPrice) || 0;
          updatedItem.amount = qty * unitPrice;
        }
        return updatedItem;
      }
      return item;
    }));
  };

  // Handle file upload
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

  // Reset form
  const resetForm = () => {
    setBudgetItems([{ id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }]);
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    setLedgerForm({
      type: 'Expense',
      description: '',
      category: '',
      referenceNumber: ''
    });
  };

  const handleClose = () => {
    resetForm();
    onClose();
  };

  // Handle save
  const handleSave = async (e) => {
    if (e) e.preventDefault();

    if (!selectedFile) {
      showToast('Please attach proof for this ledger entry', 'error');
      return;
    }

    setIsUploading(true); // Start loading state

    try {
      const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

      // 1. Create FormData and append ALL necessary fields
      const formData = new FormData();
      formData.append('project_id', projectId);
      formData.append('type', ledgerForm.type);
      formData.append('description', ledgerForm.description);
      formData.append('amount', calculateTotalBudget().toString());
      formData.append('budget_breakdown', JSON.stringify(budgetItems));
      formData.append('project_budget_breakdown', JSON.stringify(projectBudgetBreakdown || []));
      formData.append('date', ledgerForm.date || new Date().toISOString().split('T')[0]);
      formData.append('approval_status', 'Draft');

      // 2. Attach the proof file using both supported field names so the Laravel
      // controller can persist it into the ledger entry's ledger_proof column.
      formData.append('proof_file', selectedFile);
      formData.append('ledger_proof', selectedFile);

      console.log('📤 Sending ledger entry to /api/ledger-entries...');

      // 3. Define 'res' (The Response)
      const res = await fetch('/api/ledger-entries', {
        method: 'POST',
        headers: {
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        body: formData,
      });

      console.log('📥 Response received - Status:', res.status, res.statusText);
      console.log('📥 Response headers:', {
        'Content-Type': res.headers.get('Content-Type'),
        'Content-Length': res.headers.get('Content-Length')
      });

      // 4. Handle the Response
      if (res.ok) {
        console.log('✅ Response is OK (2xx status), attempting to parse JSON...');
        let result = null;
        let parseErr = null;

        try {
          result = await res.json();
          console.log('✅ JSON parsed successfully:', result);
        } catch (e) {
          parseErr = e;
          console.warn('⚠️ Could not parse response as JSON, but status was OK');
          console.log('Parse error:', e.message);
        }

        // Whether we got JSON or not, if status is 201, assume success
        // (Server may crash after sending 201 header but before body)
        toast.success(result?.message || "Entry created successfully!");

        // Close the modal FIRST
        handleClose();

        // Then call onSave to trigger a fresh fetch from the database
        if (onSave) {
          onSave({
            success: true,
            id: result?.id,
            message: result?.message || 'Entry created successfully',
            refresh: true  // Signal to fetch fresh data
          });
        }
      } else if (res.status === 422 || res.status === 400) {
        // Validation error - try to parse error details
        console.log('❌ Validation error:', res.status);
        let errorMsg = 'Validation failed';
        try {
          const errData = await res.json();
          console.log('Server error response:', errData);
          errorMsg = errData.message || errorMsg;
          if (errData.errors) {
            const errorList = Object.entries(errData.errors)
              .map(([key, messages]) => `${key}: ${Array.isArray(messages) ? messages.join(', ') : messages}`)
              .join('\n');
            errorMsg += `\n\n${errorList}`;
          }
        } catch (parseError) {
          console.error('Could not parse error response:', parseError);
          errorMsg += ` (Status: ${res.status})`;
        }
        toast.error(errorMsg);
      } else {
        // Other server errors
        console.log('❌ Server error:', res.status);
        let errorMsg = `Server error (${res.status})`;
        try {
          const errData = await res.json();
          errorMsg = errData.message || errorMsg;
        } catch (parseError) {
          console.error('Could not parse error:', parseError);
        }
        toast.error(errorMsg);
      }
    } catch (err) {
      // Handle Network Errors (e.g., Server is offline)
      console.error("❌ Fetch Error:", err.message);
      console.error("Full error:", err);

      // Network error
      toast.error("Network error: " + (err.message || "Could not reach the server."));
    } finally {
      setIsUploading(false); // Stop loading state
    }
  };

  return (
    <Modal open={open} onClose={handleClose} title="Add Ledger Entry" description="Create a new ledger entry for this project">
      <div className="space-y-4">
        {/* Type Selection */}
        <div>
          <FieldLabel>Type *</FieldLabel>
          <Select
            className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200"
            value={ledgerForm.type}
            onChange={(e) => setLedgerForm({ ...ledgerForm, type: e.target.value })}
          >
            <option value="" disabled>Select Type</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
          </Select>
        </div>

        {/* Description */}
        <div>
          <FieldLabel>Description *</FieldLabel>
          <Textarea
            placeholder="Enter transaction description"
            value={ledgerForm.description}
            onChange={(e) => setLedgerForm({ ...ledgerForm, description: e.target.value })}
            rows={3}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        {/* Budget Breakdown Section */}
        <div className="grid grid-cols-1 gap-4">
          <div>
            <FieldLabel>Budget Breakdown (₱)</FieldLabel>
            <div className="space-y-3">
              {budgetItems.map((item) => (
                <div key={item.id} className="flex gap-2 items-start">
                  <Input
                    placeholder="Item name"
                    value={item.item}
                    onChange={(e) => updateBudgetItem(item.id, 'item', e.target.value)}
                    className="flex-1 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                  />
                  <Input
                    type="number"
                    placeholder="Qty"
                    min="1"
                    value={item.qty}
                    onChange={(e) => updateBudgetItem(item.id, 'qty', e.target.value)}
                    className="w-20 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                  />
                  <Input
                    type="number"
                    placeholder="Unit Price"
                    min="1"
                    // step="0.01"
                    value={item.unitPrice}
                    onChange={(e) => updateBudgetItem(item.id, 'unitPrice', e.target.value)}
                    className="w-28 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                  />
                  <div className="w-28 h-10 flex items-center justify-end px-3 bg-gray-100 rounded-xl text-gray-700 font-medium">
                    ₱{(item.amount || 0).toLocaleString()}
                  </div>
                  {budgetItems.length > 1 && (
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      onClick={() => removeBudgetItem(item.id)}
                      className="rounded-lg text-red-600 hover:bg-red-50"
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  )}
                </div>
              ))}
              <Button
                type="button"
                onClick={addBudgetItem}
                variant="outline"
                size="sm"
                className="w-full rounded-xl"
                 disabled={budgetItems.some(item => !item.item || !item.unitPrice || item.quantity <= 0)}
              >
                <Plus className="w-4 h-4 mr-2" />
                Add Budget Item
              </Button>
            </div>
          </div>

          <div>
            <FieldLabel>Total Amount (₱)</FieldLabel>
            <div className="bg-blue-50 rounded-xl p-4 mt-1">
              <p className="text-3xl font-semibold text-blue-900">
                ₱{calculateTotalBudget().toLocaleString()}
              </p>
              <p className="text-xs text-blue-700 mt-1">
                Auto-calculated from breakdown items
              </p>
            </div>
          </div>
        </div>

        {/* File Upload */}
        <div>
          <FieldLabel>Attach Proof Document (Required)</FieldLabel>
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
                  ✕
                </Button>
              </div>
            )}
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
            disabled={!ledgerForm.description || isUploading}
          >
            {isUploading ? 'Saving...' : 'Save Entry'}
          </Button>
        </div>
      </div>
    </Modal>
  );
}