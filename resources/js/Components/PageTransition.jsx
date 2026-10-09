import React, { useEffect, useState } from 'react';
import { usePage } from '@inertiajs/react';

export default function PageTransition({ children }) {
  const { url } = usePage();
  const pagePath = url.split(/[?#]/, 1)[0];
  const [visible, setVisible] = useState(false);

  // Query-only visits, such as changing a heatmap month, should not transition the whole page.
  useEffect(() => {
    setVisible(false);
    const t = setTimeout(() => setVisible(true), 15);
    return () => clearTimeout(t);
  }, [pagePath]);

  return (
    <div key={pagePath} className={`transition-all duration-300 ease-in-out ${visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-2'}`}>
      {children}
    </div>
  );
}
