import { useCallback } from 'react';
import { useSupabase } from '../context/SupabaseContext';
import { Inertia } from '@inertiajs/inertia';
import { usePage } from '@inertiajs/react';

/**
 * useLogout - Handle logout with both Supabase and Laravel
 * Provides a logout function that handles both authentication systems
 */
export const useLogout = () => {
  const { signOut } = useSupabase();
  const { props } = usePage();

  const logout = useCallback(async () => {
    try {
      // Sign out from Supabase
      await signOut();
    } catch (error) {
      console.error('Supabase logout error:', error);
      // Continue to Laravel logout even if Supabase fails
    }

    // Also logout from Laravel
    try {
      if (typeof props.route === 'function') {
        Inertia.post(props.route('logout'));
      } else if (window.route) {
        Inertia.post(window.route('logout'));
      } else {
        // Fallback: Direct post request
        await fetch('/logout', {
          method: 'POST',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
          },
        });
        window.location.href = '/login';
      }
    } catch (error) {
      console.error('Laravel logout error:', error);
      // Fallback: Direct navigation
      window.location.href = '/login';
    }
  }, [signOut, props]);

  return { logout };
};
