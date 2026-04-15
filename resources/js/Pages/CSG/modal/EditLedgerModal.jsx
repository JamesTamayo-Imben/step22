import React, { useState, useRef, useEffect } from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Textarea } from '@/Components/ui/textarea';
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

// ─── Edit Ledger Entry Modal ─────────────────────────────────────────────────

export function EditLedgerModal({ open, onClose, ledgerForm, setLedgerForm, onSave }) {
  console.log('🎯 EditLedgerModal rendered with props:', { open, ledgerForm, onSave: !!onSave });

  // State for budget items in edit mode
  const [editBudgetItems, setEditBudgetItems] = useState([]);

  // File upload states
  const fileInputRef = useRef(null);
  const [filePreview, setFilePreview] = useState(null);
  const [selectedFile, setSelectedFile] = useState(null);
  const [isUploading, setIsUploading] = useState(false);

  // Initialize budget items when ledgerForm changes (for editing)
  useEffect(() => {
    console.log('🔄 EditLedgerModal useEffect triggered, ledgerForm:', ledgerForm);
    if (ledgerForm.budgetBreakdown && ledgerForm.budgetBreakdown.length > 0) {
      // Convert existing budget breakdown to the format needed for editing
      const formattedItems = ledgerForm.budgetBreakdown.map((item, index) => ({
        id: item.id || index + 1,
        item: item.item || '',
        qty: item.quantity || item.qty || 1,
        unitPrice: item.unitPrice || 0,
        amount: item.amount || 0
      }));
      console.log('📋 Formatted budget items:', formattedItems);
      setEditBudgetItems(formattedItems);
    } else {
      // Default empty item if no budget breakdown exists
      console.log('📋 No budget breakdown, using default');
      setEditBudgetItems([{ id: 1, item: '', qty: 1, unitPrice: '', amount: 0 }]);
    }
  }, [ledgerForm.budgetBreakdown]);

  const calculateItemTotal = (item) => {
    if (item.qty && item.unitPrice) {
      const quantity = parseFloat(item.qty) || 0;
      const unitPrice = parseFloat(item.unitPrice) || 0;
      return quantity * unitPrice;
    }
    return parseFloat(item.amount) || 0;
  };

  const calculateGrandTotal = (items = editBudgetItems) =>
    items.reduce((sum, item) => sum + calculateItemTotal(item), 0);

  const updateItem = (id, field, value) => {
    setEditBudgetItems((prev) => {
      const updatedItems = prev.map((item) => {
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
      });
      return updatedItems;
    });
  };

  const addItem = () => {
    const newId = editBudgetItems.length > 0
      ? Math.max(...editBudgetItems.map(item => item.id)) + 1
      : 1;
    setEditBudgetItems((prev) => [...prev, {
      id: newId,
      item: '',
      qty: 1,
      unitPrice: '',
      amount: 0
    }]);
  };

  const removeItem = (id) => {
    if (editBudgetItems.length > 1) {
      setEditBudgetItems((prev) => prev.filter((i) => i.id !== id));
    }
  };

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
  console.log('💾 EditLedgerModal handleSave called');
  console.log('📋 Current ledgerForm:', ledgerForm);
  console.log('📋 Current editBudgetItems:', editBudgetItems);

  // Validate required fields
  if (!ledgerForm.description) {
    console.log('❌ Validation failed: missing description');
    showToast('Please enter a description', 'error');
    return;
  }

  // Validate budget items
  const hasEmptyItems = editBudgetItems.some(item => !item.item || !item.unitPrice || item.qty <= 0);
  if (hasEmptyItems) {
    console.log('❌ Validation failed: empty budget items');
    showToast('Please fill in all budget item details', 'error');
    return;
  }

  setIsUploading(true);
  console.log('🔄 Starting upload process...');

  try {
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    console.log('🔑 CSRF token:', token ? 'present' : 'missing');

    // Create FormData for file upload
    const formData = new FormData();
    formData.append('type', ledgerForm.type || 'Expense');
    formData.append('description', ledgerForm.description);
    formData.append('category', ledgerForm.category || '');
    formData.append('reference_number', ledgerForm.referenceNumber || '');
    formData.append('budget_breakdown', JSON.stringify(editBudgetItems));
    formData.append('amount', calculateGrandTotal().toString());

    console.log('📦 FormData contents:', {
      type: ledgerForm.type,
      description: ledgerForm.description,
      category: ledgerForm.category,
      reference_number: ledgerForm.referenceNumber,
      budget_breakdown: JSON.stringify(editBudgetItems),
      amount: calculateGrandTotal().toString(),
      hasFile: !!selectedFile,
    });

    // Append file if selected
    if (selectedFile) {
      formData.append('ledger_proof', selectedFile);
      console.log('📎 File attached:', selectedFile.name);
    } else {
      console.log('📎 No new file selected');
    }

    const ledgerId = ledgerForm.id;
    console.log('🎯 Making PUT request to:', `/api/ledger-entries/${ledgerId}`);

    const res = await fetch(`/api/ledger-entries/${ledgerId}`, {
      method: 'PUT',
      headers: {
        'X-CSRF-TOKEN': token,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
      body: formData,
    });

    console.log('📡 Response status:', res.status);

    if (!res.ok) {
      let msg = 'Failed to update ledger entry';
      try {
        const errData = await res.json();
        console.log('❌ Error response:', errData);
        if (errData && errData.message) msg = errData.message;
      } catch (parseErr) {
        console.log('❌ Could not parse error response:', parseErr);
      }
      throw new Error(msg);
    }

    const responseData = await res.json();
    console.log('✅ Success response:', responseData);

    // Call onSave with the updated entry
    onSave(responseData);
    handleClose();
    // showToast('Ledger successfully edited', 'success');
    // console.log('✅ Ledger entry updated successfully');
  } catch (err) {
    console.log('💥 Error in handleSave:', err);
    showToast(err.message, 'error');
  } finally {
    setIsUploading(false);
    // console.log('🔄 Upload process finished');
  }
};

  const handleClose = () => {
    setFilePreview(null);
    setSelectedFile(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
    onClose();
  };

  return (
    <Modal open={open} onClose={handleClose} title="Edit Ledger Entry" description="Update ledger entry information">
      <div className="space-y-4">
        <div>
          <FieldLabel>Type</FieldLabel>
          <select
            className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200"
            value={ledgerForm.type}
            onChange={(e) => setLedgerForm({ ...ledgerForm, type: e.target.value })}
          >
            <option value="">Select Type</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
            <option value="Donation">Donation</option>
            <option value="Sponsorship">Sponsorship</option>
            <option value="Canvas">Canvas</option>
          </select>
        </div>

        <div>
          <FieldLabel>Description</FieldLabel>
          <Textarea
            value={ledgerForm.description}
            onChange={(e) => setLedgerForm({ ...ledgerForm, description: e.target.value })}
            rows={3}
            className="w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
          />
        </div>

        <div className="space-y-4">
          <FieldLabel>Budget Breakdown (₱)</FieldLabel>
          <div className="space-y-4">
            {editBudgetItems.map((item) => (
              <div key={item.id} className="flex gap-2 items-start">
                <Input
                  placeholder="Item name"
                  value={item.item}
                  onChange={(e) => updateItem(item.id, 'item', e.target.value)}
                  className="flex-1 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                />
                <Input
                  type="number"
                  placeholder="Qty"
                  min="1"
                  value={item.qty}
                  onChange={(e) => updateItem(item.id, 'qty', e.target.value)}
                  className="w-20 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                />
                <Input
                  type="number"
                  placeholder="Unit Price"
                  min="0"
                  step="0.01"
                  value={item.unitPrice}
                  onChange={(e) => updateItem(item.id, 'unitPrice', e.target.value)}
                  className="w-28 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white"
                />
                <div className="w-28 h-10 flex items-center justify-end px-3 bg-gray-100 rounded-xl text-gray-700 font-medium">
                  ₱{(item.amount || 0).toLocaleString()}
                </div>
                {editBudgetItems.length > 1 && (
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    onClick={() => removeItem(item.id)}
                    className="rounded-lg text-red-600 hover:bg-red-50"
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                )}
              </div>
            ))}

            <Button
              type="button"
              onClick={addItem}
              variant="outline"
              size="sm"
              className="w-full rounded-xl"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Budget Item
            </Button>
          </div>

          <div>
            <FieldLabel>Total Budget (₱)</FieldLabel>
            <div className="bg-blue-50 rounded-xl p-4">
              <p className="text-3xl font-semibold text-blue-900">
                ₱{calculateGrandTotal().toLocaleString()}
              </p>
              <p className="text-xs text-blue-700 mt-1">
                Auto-calculated from (Quantity × Unit Price)
              </p>
            </div>
          </div>

          <div>
            <FieldLabel>Ledger Proof Document (Optional)</FieldLabel>
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
              {ledgerForm.existingProof && !selectedFile && (
                <div className="w-full p-4 bg-gray-50 rounded-xl flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <FileText className="w-5 h-5 text-green-600" />
                    <div>
                      <p className="text-sm font-medium text-gray-900">Existing Proof Document</p>
                      <p className="text-xs text-gray-500">Current file will be kept unless replaced</p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>

        <div className="flex gap-3 pt-4 border-t mt-4">
          <Button variant="outline" onClick={handleClose} className="flex-1 rounded-xl" disabled={isUploading}>
            Cancel
          </Button>
          <Button
            onClick={handleSave}
            className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
            disabled={isUploading}
          >
            {isUploading ? 'Saving...' : 'Save Changes'}
          </Button>
        </div>
      </div>
    </Modal>
  );
}