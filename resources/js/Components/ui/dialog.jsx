import React from 'react';

export function Dialog({ open, onOpenChange, children }) {
  if (!open) return null;
  
  return (
    <>
      <div 
        className="fixed inset-0 bg-black/50 z-50" 
        onClick={() => onOpenChange(false)}
      />
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div 
          className="bg-white rounded-lg shadow-lg max-w-md w-full"
          onClick={(e) => e.stopPropagation()}
        >
          {children}
        </div>
      </div>
    </>
  );
}

export function DialogContent({ children, className = '' }) {
  return (
    <div className={`p-6 ${className}`}>
      {children}
    </div>
  );
}

export function DialogHeader({ children }) {
  return (
    <div className="pb-4 border-b border-gray-200">
      {children}
    </div>
  );
}

export function DialogTitle({ children, className = '' }) {
  return (
    <h2 className={`text-lg font-semibold text-gray-900 ${className}`}>
      {children}
    </h2>
  );
}