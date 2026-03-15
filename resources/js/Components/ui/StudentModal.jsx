import React, { useEffect } from 'react';
import ReactDOM from 'react-dom';

export function StudentModal({ isOpen, onClose, title, children }) {
  // Lock body scroll when modal opens
  useEffect(() => {
    if (isOpen) {
      const originalStyle = window.getComputedStyle(document.body).overflow;
      document.body.style.overflow = 'hidden';
      return () => {
        document.body.style.overflow = originalStyle;
      };
    }
  }, [isOpen]);

  if (!isOpen) return null;

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
