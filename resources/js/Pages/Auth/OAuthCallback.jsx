import { useEffect, useRef, useState } from 'react';
import { router } from '@inertiajs/react';
import { useSupabase } from '../../context/SupabaseContext';

export default function OAuthCallback() {
  const { user, loading, signOut } = useSupabase();
  const [error, setError] = useState('');
  const [validating, setValidating] = useState(true);
  const hasHandledCallback = useRef(false);

  useEffect(() => {
    const handleCallback = async () => {
      try {
        setValidating(true);

        if (loading) return;
        if (hasHandledCallback.current) return;

        if (user && user.email) {
          hasHandledCallback.current = true;

          // Validate KLD email domain
          if (!user.email.endsWith('@kld.edu.ph')) {
            await signOut();
            setError('Email must be a valid KLD school email (@kld.edu.ph). Your account has been signed out.');
            setTimeout(() => {
              router.visit('/login');
            }, 3000);
            return;
          }

          // Sync Supabase user to Laravel step2 DB
          console.log('📝 Syncing Supabase user to Laravel step2 DB...');

          const response = await fetch('/api/oauth/google-login', {
            method: 'POST',
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
            },
            body: JSON.stringify({
              id: user.id,
              email: user.email,
              name: user.user_metadata?.full_name || user.email.split('@')[0],
              avatar_url: user.user_metadata?.avatar_url || null,
            }),
          });

          const contentType = response.headers.get('content-type') || '';
          const isJsonResponse = contentType.includes('application/json');

          if (!response.ok || !isJsonResponse) {
            if (isJsonResponse) {
              const errorData = await response.json();
              throw new Error(errorData.message || 'Failed to create user in database');
            }
            const errorText = await response.text();
            console.error('❌ Non-JSON response:', {
              status: response.status,
              redirected: response.redirected,
              url: response.url,
            });
            console.log('Error snippet:', errorText.substring(0, 200));
            throw new Error(
              `Expected JSON from /api/oauth/google-login but got ${contentType || 'unknown'} (status ${response.status}).`
            );
          }

          const data = await response.json();
          console.log('✅ User created/updated in step2 DB:', data.user);

          setOauthUser(data.user);

          // if (!data.user.profile_completed) {
          //   console.log('📋 Profile incomplete, fetching dropdown data...');

          //   try {
          //     // FETCH THE DATA FROM THE DATABASE HERE
          //     const academicRes = await fetch(`${API_BASE_URL}/api/onboarding/data`, {
          //       headers: { 'Accept': 'application/json' }
          //     });

          //     if (academicRes.ok) {
          //       const academicData = await academicRes.json();
          //       setCourseList(academicData.courses || []);
          //       setInstituteList(academicData.institutes || []);
          //       console.log('✅ Dropdown data loaded');
          //     }
          //   } catch (fetchErr) {
          //     console.error('❌ Failed to load dropdowns:', fetchErr);
          //   }

          //   setShowOnboarding(true);
          //   setValidating(false);
          // } else {
          //   router.visit('/user');
          // }

          if (!data.user.profile_completed) {
            // 1. Fetch the dropdown data here
            try {
              const [cRes, iRes] = await Promise.all([
                fetch('/api/onboarding/courses', { headers: { 'Accept': 'application/json' } }),
                fetch('/api/onboarding/institutes', { headers: { 'Accept': 'application/json' } })
              ]);

              const cType = cRes.headers.get('content-type') || '';
              const iType = iRes.headers.get('content-type') || '';
              const cData = cType.includes('application/json') ? await cRes.json() : { courses: [] };
              const iData = iType.includes('application/json') ? await iRes.json() : { institutes: [] };

              setCourseList(cData.courses || []);
              setInstituteList(iData.institutes || []);
            } catch (err) {
              console.error("Failed to preload dropdowns", err);
            }

            setShowOnboarding(true);
            setValidating(false);
          } else {
           // Existing user with completed profile: redirect based on role
console.log('✅ Profile already completed, checking role for redirect');
console.log('📧 Email:', data.user.email);
console.log('👤 Role:', data.user.role?.slug);

// Determine redirect path based on role slug
let redirectPath = '/user'; // Default redirect for student/teacher

if (data.user.role?.slug === 'superadmin') {
  redirectPath = '/sadmin'; // Super admin dashboard
} else if (data.user.role?.slug === 'admin') {
  redirectPath = '/adviser/dashboard'; // Adviser/Admin dashboard
} else if (data.user.role?.slug === 'csg') {
  redirectPath = '/csg/dashboard'; // CSG dashboard
} else if (data.user.role?.slug === 'student' || data.user.role?.slug === 'teacher') {
  redirectPath = '/user'; // User dashboard for students and teachers
} else {
  // Default fallback for any other roles
  redirectPath = '/user';
}

console.log(`🚀 Redirecting to ${redirectPath} based on role: ${data.user.role?.slug}`);
router.visit(redirectPath);
          }

          // Always redirect to /user
          router.visit('/user');

        } else {
          throw new Error('No user session found after Google sign-in');
        }
      } catch (err) {
        console.error('OAuth callback error:', err);
        setError(err.message || 'Authentication failed. Redirecting to login...');
        setTimeout(() => {
          router.visit('/login');
        }, 3000);
      } finally {
        setValidating(false);
      }
    };

    handleCallback();
  }, [loading, user, signOut]);

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-600 via-blue-500 to-blue-700 relative overflow-hidden">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: '1s' }}></div>
      </div>

      {/* Main content */}
      <div className="relative z-10 text-center px-4">
        {error ? (
          // Error State
          <div className="bg-white/10 backdrop-blur-xl rounded-2xl p-8 shadow-2xl border border-white/20 max-w-md">
            <div className="mb-6">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-red-500/20 mb-4">
                <svg className="w-8 h-8 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4v.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
            <h1 className="text-3xl font-bold text-white mb-4">Authentication Failed</h1>
            <p className="text-white/90 text-base mb-6 leading-relaxed">{error}</p>
            <p className="text-white/70 text-sm animate-bounce">Redirecting to login...</p>
          </div>
        ) : validating ? (
          // Loading State
          <div className="bg-white/10 backdrop-blur-xl rounded-2xl p-12 shadow-2xl border border-white/20 max-w-md">
            <div className="mb-8">
              <div className="relative inline-block">
                <div className="absolute inset-0 rounded-full border-4 border-transparent border-t-white border-r-white animate-spin"></div>
                <div className="relative w-24 h-24 flex items-center justify-center">
                  <img src="/images/Logo.png" alt="STEP Logo" className="w-20 h-20 object-contain drop-shadow-lg" />
                </div>
              </div>
            </div>
            <div className="flex justify-center gap-2 mb-6">
              <div className="w-2 h-2 rounded-full bg-white animate-bounce" style={{ animationDelay: '0s' }}></div>
              <div className="w-2 h-2 rounded-full bg-white animate-bounce" style={{ animationDelay: '0.2s' }}></div>
              <div className="w-2 h-2 rounded-full bg-white animate-bounce" style={{ animationDelay: '0.4s' }}></div>
            </div>
            <h1 className="text-2xl font-bold text-white mb-2">Verifying Credentials</h1>
            <p className="text-white/80 text-sm mb-6">Please wait while we validate your KLD email</p>
            <div className="w-full bg-white/20 rounded-full h-1 overflow-hidden">
              <div className="h-full bg-gradient-to-r from-white via-blue-200 to-white rounded-full animate-pulse" style={{ width: '60%' }}></div>
            </div>
          </div>
        ) : (
          // Success/Redirecting State
          <div className="bg-white/10 backdrop-blur-xl rounded-2xl p-12 shadow-2xl border border-white/20 max-w-md">
            <div className="mb-8">
              <div className="animate-pulse">
                <img src="/images/Logo.png" alt="STEP Logo" className="w-20 h-20 object-contain drop-shadow-lg mx-auto" />
              </div>
            </div>
            <h1 className="text-2xl font-bold text-white mb-2">Success!</h1>
            <p className="text-white/80 text-sm">Taking you to your dashboard</p>
            <div className="mt-6 flex justify-center">
              <svg className="w-12 h-12 text-green-400 animate-bounce" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}