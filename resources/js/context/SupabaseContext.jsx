import { createContext, useContext, useEffect, useState } from 'react';
import { supabase } from '../config/supabase';

const SupabaseContext = createContext(null);

export const SupabaseProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [session, setSession] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Initialize auth session on mount
  useEffect(() => {
    const initializeAuth = async () => {
      try {
        setLoading(true);
        
        // Get current session
        const { data: { session }, error: sessionError } = await supabase.auth.getSession();
        
        if (sessionError) throw sessionError;
        
        setSession(session);
        setUser(session?.user ?? null);
      } catch (err) {
        console.error('Auth initialization error:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    initializeAuth();

    // Listen for auth changes
    const subscription = supabase.auth.onAuthStateChange((event, session) => {
      setSession(session);
      setUser(session?.user ?? null);
    });

    return () => {
      if (subscription && typeof subscription.unsubscribe === 'function') {
        subscription.unsubscribe();
      } else if (subscription && Array.isArray(subscription)) {
        subscription[1]?.();
      }
    };
  }, []);

  // Sign up function
  const signUp = async (email, password, userData = {}) => {
    try {
      setError(null);
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: userData,
        },
      });

      if (error) throw error;
      return data;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  // Sign in function
  const signIn = async (email, password) => {
    try {
      setError(null);
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;
      return data;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  // Sign out function
  const signOut = async () => {
    try {
      setError(null);
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  // Update user profile
  const updateProfile = async (updates) => {
    try {
      setError(null);
      const { data, error } = await supabase.auth.updateUser(updates);
      if (error) throw error;
      setUser(data.user);
      return data;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  // Google Sign In/Sign Up with email domain validation
  const signInWithGoogle = async () => {
    try {
      setError(null);
      
      // Determine the correct redirect URL based on current location
      // This helps avoid redirect_uri_mismatch errors
      let redirectUrl = `${window.location.origin}/callback`;
      
      // If running on localhost, explicitly use the right format
      if (window.location.hostname === 'localhost') {
        redirectUrl = `http://localhost:8000/callback`;
      } else if (window.location.hostname === '127.0.0.1') {
        redirectUrl = `http://127.0.0.1:8000/callback`;
      }
      
      const { data, error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: redirectUrl,
          skipBrowserRedirect: false,
        },
      });

      if (error) throw error;
      return data;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  // Validate if user's email is @kld.edu.ph after OAuth login
  const validateGoogleEmailDomain = async () => {
    try {
      if (!user) {
        throw new Error('No user session found');
      }

      const userEmail = user.email || '';
      if (!userEmail.endsWith('@kld.edu.ph')) {
        // Sign out if email is not from valid domain
        await signOut();
        throw new Error('Email must be a valid KLD school email (@kld.edu.ph)');
      }

      return true;
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  const value = {
    user,
    session,
    loading,
    error,
    signUp,
    signIn,
    signOut,
    updateProfile,
    signInWithGoogle,
    validateGoogleEmailDomain,
    isAuthenticated: !!session,
  };

  return (
    <SupabaseContext.Provider value={value}>
      {children}
    </SupabaseContext.Provider>
  );
};

// Hook to use Supabase context
export const useSupabase = () => {
  const context = useContext(SupabaseContext);
  if (!context) {
    throw new Error('useSupabase must be used within a SupabaseProvider');
  }
  return context;
};
