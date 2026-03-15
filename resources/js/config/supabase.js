import { createClient } from '@supabase/supabase-js';

// Get your project URL and anon key from https://app.supabase.com
const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL || '';
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
  console.warn('Supabase environment variables not configured');
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
