import React, { useEffect, useState } from 'react';
import { usePage } from '@inertiajs/react';

export default function PageTransition({ children }) {
  const { url } = usePage();
  const [visible, setVisible] = useState(false);

  // Trigger a small mount animation whenever the page URL changes.
  useEffect(() => {
    setVisible(false);
    const t = setTimeout(() => setVisible(true), 15);
    return () => clearTimeout(t);
  }, [url]);

  return (
    <div key={url} className={`transition-all duration-300 ease-in-out ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-2'}`}>
      {children}
    </div>
  );
}
