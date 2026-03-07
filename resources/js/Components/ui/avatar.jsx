import React from 'react';

export function Avatar({ children, className = '', ...props }) {
  return (
    <div className={`inline-flex items-center justify-center rounded-full overflow-hidden ${className}`} {...props}>
      {children}
    </div>
  );
}

export function AvatarFallback({ children, className = '', ...props }) {
  return (
    <div className={`w-full h-full flex items-center justify-center ${className}`} {...props}>
      {children}
    </div>
  );
}
