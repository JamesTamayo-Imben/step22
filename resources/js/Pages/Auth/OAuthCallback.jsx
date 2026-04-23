import { useEffect, useRef, useState } from 'react';
import { router } from '@inertiajs/react';
import { useSupabase } from '../../context/SupabaseContext';

export default function OAuthCallback() {
  const { user, loading, signOut } = useSupabase();
  const [error, setError] = useState('');
  const [validating, setValidating] = useState(true);
  const [showOnboarding, setShowOnboarding] = useState(false);
  const [oauthUser, setOauthUser] = useState(null);
  const [courseList, setCourseList] = useState([]);
  const [submitting, setSubmitting] = useState(false);
  const [formData, setFormData] = useState({
    course_id: '',
    student_id: '',
  });
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

          if (!data.user.profile_completed) {
            console.log('📋 Profile incomplete, fetching dropdown data...');

            try {
              const cRes = await fetch('/api/onboarding/courses', { headers: { 'Accept': 'application/json' } });
              const cType = cRes.headers.get('content-type') || '';
              const cData = cType.includes('application/json') ? await cRes.json() : { courses: [] };
              setCourseList(cData.courses || []);
              console.log('✅ Dropdown data loaded');
            } catch (fetchErr) {
              console.error('❌ Failed to load dropdowns:', fetchErr);
            }

            setShowOnboarding(true);
            setValidating(false);
          } else {
            // Existing user with completed profile: redirect to dashboard immediately
            console.log('✅ Profile already completed, redirecting to dashboard');
            console.log('📧 Email:', data.user.email);
            console.log('👤 Role:', data.user.role?.slug);

            let redirectPath = '/user';

            if (data.user.role?.slug === 'superadmin') {
              redirectPath = '/sadmin';
            } else if (data.user.role?.slug === 'admin') {
              redirectPath = '/adviser/dashboard';
            } else if (data.user.role?.slug === 'csg') {
              redirectPath = '/csg/dashboard';
            } else if (data.user.role?.slug === 'student' || data.user.role?.slug === 'teacher') {
              redirectPath = '/user';
            } else {
              redirectPath = '/user';
            }

            console.log(`🚀 Redirecting to ${redirectPath} based on role: ${data.user.role?.slug}`);
            // Redirect immediately without showing onboarding form
            router.visit(redirectPath);
            return; // Exit early to prevent showing onboarding page
          }

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

  const handleOnboardingSubmit = async (e) => {
    e.preventDefault();
    try {
      setSubmitting(true);

      // Validate that course_id and student_id are provided (they're required for role='student')
      if (!formData.course_id) {
        throw new Error('Please select a course to proceed.');
      }
      if (!formData.student_id) {
        throw new Error('Please enter your student ID to proceed.');
      }

      console.log('📤 Submitting onboarding data:', {
        user_id: oauthUser?.id,
        email: oauthUser?.email,
        role: 'student',
        student_id: formData.student_id,
        course_id: formData.course_id,
      });

      const response = await fetch('/api/onboarding/complete', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        },
        body: JSON.stringify({
          user_id: oauthUser?.id,
          email: oauthUser?.email,
          role: 'student',
          student_id: formData.student_id,
          course_id: formData.course_id,
        }),
      });

      const contentType = response.headers.get('content-type') || '';
      const isJsonResponse = contentType.includes('application/json');
      
      if (!isJsonResponse) {
        const text = await response.text();
        console.error('❌ Non-JSON response:', response.status, text.substring(0, 200));
        throw new Error('Server returned an unexpected response. Please try again.');
      }

      const data = await response.json();

      if (!response.ok) {
        // Handle validation errors from backend
        const errorMessage = data.errors 
          ? Object.values(data.errors).flat().join(', ')
          : data.message || 'Failed to complete profile setup.';
        console.error('❌ Backend validation error:', errorMessage);
        throw new Error(errorMessage);
      }

      console.log('✅ Onboarding complete:', data);
      showSuccessMessage('Profile setup complete! Welcome email with temporary password has been sent to your inbox.');
      
      setTimeout(() => {
        router.visit('/user');
      }, 2000);
    } catch (err) {
      console.error('❌ Onboarding submit error:', err);
      alert(err.message || 'Something went wrong. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const handleSkipOnboarding = async () => {
    try {
      setSubmitting(true);

      console.log('⏭️ Skipping onboarding, sending welcome email...');

      // Call API endpoint to send welcome email and skip onboarding
      const response = await fetch('/api/onboarding/skip', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        },
        body: JSON.stringify({
          user_id: oauthUser?.id,
          email: oauthUser?.email,
        }),
      });

      const contentType = response.headers.get('content-type') || '';
      const isJsonResponse = contentType.includes('application/json');
      
      if (!isJsonResponse) {
        const text = await response.text();
        console.error('❌ Non-JSON response:', response.status, text.substring(0, 200));
        throw new Error('Server returned an unexpected response. Please try again.');
      }

      const data = await response.json();

      if (!response.ok) {
        const errorMessage = data.message || 'Failed to skip onboarding.';
        console.error('❌ Skip onboarding error:', errorMessage);
        throw new Error(errorMessage);
      }

      console.log('✅ Onboarding skipped:', data);
      showSuccessMessage('You can complete your profile later! Welcome email with temporary password has been sent to your inbox.');
      
      setTimeout(() => {
        router.visit('/user');
      }, 2000);
    } catch (err) {
      console.error('❌ Skip onboarding error:', err);
      alert(err.message || 'Something went wrong. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const showSuccessMessage = (message) => {
    // Use showToast if available, otherwise fallback to console
    if (typeof showToast === 'function') {
      showToast(message, 'success');
    } else {
      console.log('✅ ' + message);
    }
  };

  // ─── Onboarding Modal ───────────────────────────────────────────────────────
  if (showOnboarding) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-600 via-blue-500 to-blue-700 relative overflow-hidden px-4">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: '1s' }}></div>
        </div>

        <div className="relative z-10 w-full max-w-md">
          <div className="bg-white rounded-2xl shadow-2xl p-8">
            {/* Header */}
            <div className="text-center mb-6">
              <img src="/images/Logo.png" alt="STEP Logo" className="w-14 h-14 object-contain mx-auto mb-3" />
              <h1 className="text-2xl font-bold text-gray-900">Complete Your Profile</h1>
              <p className="text-sm text-gray-500 mt-1">We just need a few more details to get you started.</p>
            </div>

            {/* Welcome message */}
            {oauthUser && (
              <div className="flex items-center gap-3 bg-blue-50 rounded-xl px-4 py-3 mb-6">
                {oauthUser.avatar_url ? (
                  <img src={oauthUser.avatar_url} alt={oauthUser.name} className="w-10 h-10 rounded-full object-cover border border-blue-200" />
                ) : (
                  <div className="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white text-sm font-medium">
                    {oauthUser.name?.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)}
                  </div>
                )}
                <div>
                  <p className="text-sm font-medium text-gray-900">{oauthUser.name}</p>
                  <p className="text-xs text-gray-500">{oauthUser.email}</p>
                </div>
              </div>
            )}

            {/* Form */}
            <form onSubmit={handleOnboardingSubmit} className="space-y-4">
              {/* Student ID */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Student ID <span className="text-red-500 font-normal">*</span>
                </label>
                <input
                  type="text"
                  placeholder="e.g. 2021-00123"
                  required
                  value={formData.student_id}
                  onChange={(e) => setFormData(prev => ({ ...prev, student_id: e.target.value }))}
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              {/* Course */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Course <span className="text-red-500 font-normal">*</span>
                </label>
                <select
                  value={formData.course_id}
                  onChange={(e) => setFormData(prev => ({ ...prev, course_id: e.target.value }))}
                  required
                  className="w-full px-4 py-2.5 border border-gray-300 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white"
                >
                  <option value="">Select your course</option>
                  {courseList.map((course) => (
                    <option key={course.id} value={course.id}>
                      {course.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Submit */}
              <button
                type="submit"
                disabled={submitting}
                className="w-full py-3 bg-gradient-to-r from-blue-600 to-blue-800 text-white font-medium rounded-xl hover:from-blue-700 hover:to-blue-900 transition-all shadow-md disabled:opacity-60 disabled:cursor-not-allowed mt-2"
              >
                {submitting ? (
                  <span className="flex items-center justify-center gap-2">
                    <svg className="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
                    </svg>
                    Saving...
                  </span>
                ) : 'Complete Setup'}
              </button>

              {/* Skip */}
              <button
                type="button"
                onClick={handleSkipOnboarding}
                disabled={submitting}
                className="w-full py-2.5 text-sm text-gray-500 hover:text-gray-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {submitting ? 'Processing...' : 'Skip for now'}
              </button>
            </form>
          </div>
        </div>
      </div>
    );
  }

  // ─── Loading / Error / Success States ──────────────────────────────────────
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-600 via-blue-500 to-blue-700 relative overflow-hidden">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: '1s' }}></div>
      </div>

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