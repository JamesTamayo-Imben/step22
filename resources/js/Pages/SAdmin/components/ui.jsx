import React, { useEffect } from 'react';
import ReactDOM from 'react-dom';

export function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#2563EB' : '#ef4444'; 
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

export function Modal({ open, onClose, title, description, children, maxWidthClass = 'max-w-2xl' }) {
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
        className={`relative w-full ${maxWidthClass} bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]`}
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

export function FieldLabel({ children }) {
  return <label className="block text-sm text-gray-700 mb-1">{children}</label>;
}

export function Textarea({ className = '', rows = 4, ...props }) {
  return (
    <textarea
      rows={rows}
      className={[
        'w-full px-3 py-2 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      {...props}
    />
  );
}

export function Badge({ children, className = '' }) {
  return (
    <span className={['inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium', className].join(' ')}>
      {children}
    </span>
  );
}

export function Progress({ value = 0, className = '' }) {
  const v = Math.max(0, Math.min(100, Number.isFinite(value) ? value : 0));
  return (
    <div className={['w-full bg-gray-100 rounded-full overflow-hidden', className].join(' ')}>
      <div className="h-full bg-blue-600 rounded-full" style={{ width: `${v}%`, height: '100%' }} />
    </div>
  );
}

export function Select({ value, onValueChange, children, className = '' }) {
  return (
    <select
      value={value}
      onChange={(e) => onValueChange && onValueChange(e.target.value)}
      className={['w-full px-3 py-2 border border-gray-200 rounded-xl bg-white', className].join(' ')}
    >
      {children}
    </select>
  );
}

export function SelectItem({ value, children }) {
  return <option value={value}>{children}</option>;
}

export function Switch({ checked, onCheckedChange, disabled, className = '' }) {
  return (
    <button
      type="button"
      onClick={() => !disabled && onCheckedChange && onCheckedChange(!checked)}
      className={[
        'relative inline-flex h-6 w-11 items-center rounded-full transition-colors',
        checked ? 'bg-blue-600' : 'bg-gray-200',
        disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer',
        className,
      ].join(' ')}
      aria-pressed={checked}
      aria-disabled={disabled}
    >
      <span
        className={[
          'inline-block h-5 w-5 transform rounded-full bg-white transition-transform',
          checked ? 'translate-x-5' : 'translate-x-1',
        ].join(' ')}
      />
    </button>
  );
}

