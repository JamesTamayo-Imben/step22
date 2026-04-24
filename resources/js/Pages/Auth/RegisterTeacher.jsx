import { useState, useEffect } from "react";
import { Mail, Lock, User, Eye, EyeOff, AlertCircle, CheckCircle, Building, Phone } from "lucide-react";

export default function RegisterTeacherPage() {
  const [form, setForm] = useState({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    employeeId: '',
    institute: '',
    phone: '',
  });

  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [phoneError, setPhoneError] = useState('');
  const [institutes, setInstitutes] = useState([]);
  const [invitationToken, setInvitationToken] = useState(null);
  const [isInvitedRegistration, setIsInvitedRegistration] = useState(false);

  // Pre-fill form from URL query parameters and fetch institutes
  useEffect(() => {
    const searchParams = new URLSearchParams(window.location.search);
    const email = searchParams.get('email') || '';
    const password = searchParams.get('password') || '';
    const name = searchParams.get('name') || '';
    const token = searchParams.get('token') || '';

    // If token exists, this is an invited registration
    if (token) {
      setInvitationToken(token);
      setIsInvitedRegistration(true);
      console.log('🔗 Invitation token detected:', token.substring(0, 10) + '...');
      console.log('📧 Pre-filled email:', email);
      console.log('👤 Pre-filled name:', name);
    }

    setForm(prev => {
      const newForm = {
        ...prev,
        email: email,
        password: password,
      };

      if (name) {
        const parts = name.split(' ');
        newForm.firstName = parts[0] || '';
        newForm.lastName = parts.slice(1).join(' ') || '';
      }

      return newForm;
    });

    // Fetch institutes
    fetch('/api/institutes')
      .then(res => {
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res.json();
      })
      .then(data => {
        console.log('Institutes data received:', data);
        if (data.institutes && Array.isArray(data.institutes)) {
          setInstitutes(data.institutes);
          console.log('Institutes set:', data.institutes);
        } else {
          console.warn('Institutes data not in expected format:', data);
        }
      })
      .catch(err => {
        console.error('Failed to fetch institutes:', err);
        setError(`Failed to load institutes: ${err.message}`);
      });
  }, []);

  const handleChange = (field, value) => {
    if (field === 'phone') {
      // Remove non-digits and limit to 11 characters
      const cleaned = value.replace(/\D/g, '').slice(0, 11);
      setForm({ ...form, phone: cleaned });
      // Inline validation similar to StudentProfile
      // if (cleaned && cleaned.length > 0) {
      //   if (cleaned.length < 10) setPhoneError('Phone number must be at least 10 digits');
      //   else if (cleaned.length > 11) setPhoneError('Phone number cannot exceed 11 digits');
      //   else if (!cleaned.startsWith('09') && !cleaned.startsWith('9')) setPhoneError('Phone number should start with 09 or 9');
      //   else setPhoneError('');
      // } else {
      //   setPhoneError('');
      // }
      return;
    }

    setForm({ ...form, [field]: value });
  };


  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      // If this is an invited registration, only require password
      if (isInvitedRegistration) {
        if (!form.password) {
          throw new Error('Password is required');
        }
        
        if (form.password.length < 8) {
          throw new Error('Password must be at least 8 characters');
        }

        console.log('🔗 Completing invited teacher registration');
        console.log('📧 Email:', form.email);
        console.log('🔐 Token:', invitationToken.substring(0, 10) + '...');

        // Validate and format phone before sending
        let phoneToSend = form.phone || null;
        if (phoneToSend) {
          if (phoneToSend.length < 10) throw new Error('Please enter a valid phone number (at least 10 digits)');
          if (phoneToSend.length > 11) throw new Error('Phone number cannot exceed 11 digits');
          if (phoneToSend.startsWith('9') && phoneToSend.length === 10) phoneToSend = '0' + phoneToSend;
        }

        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

        const response = await fetch('/api/auth/register-teacher', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken || '',
            'Accept': 'application/json',
          },
          body: JSON.stringify({
            invitation_token: invitationToken,
            password: form.password,
            phone: phoneToSend,
          }),
        });

        console.log('📡 Response status:', response.status);

        const contentType = response.headers.get('content-type');
        let data;
        
        if (contentType && contentType.includes('application/json')) {
          data = await response.json();
          console.log('✅ Response data:', data);
        } else {
          const text = await response.text();
          console.error('❌ Response is HTML, not JSON');
          throw new Error('Server returned HTML instead of JSON.');
        }

        if (response.ok) {
          console.log('✅ Registration completed successfully!');
          setSuccess(true);
          // Redirect to login page after success so user can log in
          setTimeout(() => {
            window.location.href = '/login';
          }, 2000);
        } else {
          throw new Error(data.message || 'Registration failed');
        }
      } else {
        // Standard registration (no token)
        // Validation
        if (!form.firstName || !form.lastName) {
          throw new Error('Please provide your full name');
        }

        if (!form.employeeId) {
          throw new Error('Please provide your employee ID');
        }

        if (!form.email) {
          throw new Error('Email is required');
        }

        if (!form.password) {
          throw new Error('Password is required');
        }

        // Send registration request
        console.log('🚀 Sending registration request to /api/auth/register-teacher');
        console.log('📋 Form data:', {
          firstName: form.firstName,
          lastName: form.lastName,
          email: form.email,
          employeeId: form.employeeId,
          institute: form.institute || null,
          phone: form.phone || null,
          role: 'teacher',
        });

        // Validate and format phone before sending
        let phoneToSend = form.phone || null;
        if (phoneToSend) {
          if (phoneToSend.length < 10) throw new Error('Please enter a valid phone number (at least 10 digits)');
          if (phoneToSend.length > 11) throw new Error('Phone number cannot exceed 11 digits');
          if (phoneToSend.startsWith('9') && phoneToSend.length === 10) phoneToSend = '0' + phoneToSend;
        }

        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
        console.log('🔐 CSRF Token:', csrfToken ? '✅ Present' : '❌ Missing');

        // Problema ka

        // The email has already been taken.
        // This error can occur if the email provided is already registered in the system. The backend should ideally return a clear error message indicating that the email is already in use. Make sure to check the backend validation rules and error handling to ensure that it returns a proper JSON response with an appropriate status code (e.g., 422 Unprocessable Entity) when this happens.
        // how to fix
        // To fix the "email has already been taken" error, you should ensure that your backend API endpoint for registering a teacher checks if the email already exists in the database before attempting to create a new user. If the email is already registered, the backend should return a JSON response with an appropriate error message and status code (like 422 Unprocessable Entity). On the frontend, you can then display this error message to the user. Additionally, you can implement client-side validation to check if the email is already in use before submitting the form, although this should not replace server-side validation. Make sure to handle this error gracefully in your UI, informing the user that they need to use a different email address or log in if they already have an account.

        // provide code and what it is
        // what i want is update the one that sadmin create not add it to the table

        const response = await fetch('/api/auth/register-teacher', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': csrfToken || '',
            'Accept': 'application/json',
          },
          body: JSON.stringify({
            firstName: form.firstName,
            lastName: form.lastName,
            email: form.email,
            password: form.password,
            employeeId: form.employeeId,
            institute: form.institute || null,
            phone: phoneToSend,
            role: 'teacher',
          }),
        });
        
        // const response = await fetch('/api/auth/register-teacher', {
        //   method: 'POST',
        //   headers: {
        //     'Content-Type': 'application/json',
        //     'X-CSRF-TOKEN': csrfToken || '',
        //     'Accept': 'application/json',
        //   },
        //   body: JSON.stringify({
        //     firstName: form.firstName,
        //     lastName: form.lastName,
        //     email: form.email,
        //     password: form.password,
        //     employeeId: form.employeeId,
        //     institute: form.institute || null,
        //     phone: form.phone || null,
        //     role: 'teacher',
        //   }),
        // });

        console.log('📡 Response status:', response.status);
        console.log('📡 Response headers:', {
          contentType: response.headers.get('content-type'),
        });

        // First check if response is JSON
        const contentType = response.headers.get('content-type');
        let data;
        
        if (contentType && contentType.includes('application/json')) {
          data = await response.json();
          
          console.log('✅ Response data:', data);
        } else {
          // Response is HTML (error page), not JSON
          const text = await response.text();
          console.error('❌ Response is HTML, not JSON');
          console.error('📝 First 200 chars:', text.substring(0, 200));
          throw new Error('Server returned HTML instead of JSON. The API endpoint may not exist or there\'s a server error.');
        }

        if (response.ok) {
          setSuccess(true);
          // Redirect to login page after success so user can log in
          setTimeout(() => {
            window.location.href = '/login';
          }, 2000);
        } else {
          throw new Error(data.message || 'Registration failed');
        }
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setIsLoading(false);
    }
  };

  if (success) {
    return (
      <div className="min-h-screen flex">
        <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
          <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

          <div className="relative z-10">
            <h1 className="text-3xl font-medium mb-1">Welcome to STEP</h1>
            <p className="text-lg">Your account is ready</p>

            <div className="relative z-10 mt-10 flex justify-center">
              <div className="mt-20 space-y-4 w-1/2">
                <h2 className="text-4xl font-semibold leading-tight">
                  Transparent.<br />
                  Accountable.<br />
                  Trustworthy.
                </h2>
                <p className="text-white/80 max-w-md">
                  Empowering students and organizations with financial transparency
                  and collaborative decision-making.
                </p>
              </div>

              <div className="gap-2 overflow-hidden">
                <img
                  src="/images/login-bg.png"
                  alt="Register Background"
                  className="w-full object-cover"
                />
              </div>
            </div>
          </div>
        </div>

        <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">
          <div className="w-full max-w-lg bg-white rounded-2xl border border-gray-200 shadow-sm p-10 text-center">
            <CheckCircle className="w-16 h-16 text-green-500 mx-auto mb-4" />
            <h2 className="text-2xl font-bold text-gray-800 mb-2">Registration Successful!</h2>
            <p className="text-gray-600 mb-4">Your account has been created. Redirecting to login...</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex">
      {/* LEFT PANEL */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <h1 className="text-3xl font-medium mb-1">Welcome to STEP</h1>
          <p className="text-lg">Teacher Registration</p>

          <div className="relative z-10 mt-10 flex justify-center">
            <div className="mt-20 space-y-4 w-1/2">
              <h2 className="text-4xl font-semibold leading-tight">
                Transparent.<br />
                Accountable.<br />
                Trustworthy.
              </h2>
              <p className="text-white/80 max-w-md">
                Empowering students and organizations with financial transparency
                and collaborative decision-making.
              </p>
            </div>

            <div className="gap-2 overflow-hidden">
              <img
                src="/images/login-bg.png"
                alt="Register Background"
                className="w-full object-cover"
              />
            </div>
          </div>
        </div>
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">
        <div className="w-full max-w-lg bg-white rounded-2xl border border-gray-200 shadow-sm p-10">
          {/* Logo */}
          <div className="flex justify-center mb-2">
            <div className="w-20 overflow-hidden px-2">
              <img
                src="/images/Logo.png"
                alt="Step Logo"
                className="w-full object-cover"
              />
            </div>
          </div>

          <h2 className="text-center text-2xl text-gray-800 mb-2">
            {isInvitedRegistration ? 'Complete Your Registration' : 'Teacher Registration'}
          </h2>
          <p className="text-center text-sm text-gray-500 mb-6">
            {isInvitedRegistration ? 'Set your password to activate your account' : 'Complete your profile to get started'}
          </p>

          {/* Error */}
          {error && (
            <div className="mb-4 p-3 text-sm text-red-700 bg-red-50 rounded-lg border border-red-200">
              {error}
            </div>
          )}

          {/* FORM */}
          <form onSubmit={handleSubmit} className="space-y-5">
            {/* Pre-filled Email and Password Display */}
            {form.email && (
              <div className="p-3 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-xs text-gray-600 mb-1">Email (Pre-filled)</p>
                <p className="text-sm font-semibold text-gray-800">{form.email}</p>
              </div>
            )}

            {isInvitedRegistration && form.firstName && (
              <div className="p-3 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-xs text-gray-600 mb-1">Name (Pre-filled)</p>
                <p className="text-sm font-semibold text-gray-800">{form.firstName} {form.lastName}</p>
              </div>
            )}

            {/* Show full name fields only for standard registration */}
            {!isInvitedRegistration && (
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-gray-600 mb-1">First Name *</label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input
                      placeholder="Juan"
                      value={form.firstName}
                      onChange={(e) => handleChange('firstName', e.target.value)}
                      className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-sm text-gray-600 mb-1">Last Name *</label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input
                      placeholder="Dela Cruz"
                      value={form.lastName}
                      onChange={(e) => handleChange('lastName', e.target.value)}
                      className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    />
                  </div>
                </div>
              </div>
            )}

            {/* Email field only for standard registration */}
            {!isInvitedRegistration && !form.email && (
              <div>
                <label className="block text-sm text-gray-600 mb-1">Email *</label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type="email"
                    placeholder="your.email@kld.edu.ph"
                    value={form.email}
                    onChange={(e) => handleChange('email', e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                </div>
              </div>
            )}

            {/* Employee ID - only for standard registration */}
            {!isInvitedRegistration && (
              <div>
                <label className="block text-sm text-gray-600 mb-1">Employee ID *</label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type="text"
                    placeholder="T-12345"
                    value={form.employeeId}
                    onChange={(e) => handleChange('employeeId', e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                </div>
              </div>
            )}

            {/* Institute (Optional) - only for standard registration */}
            {!isInvitedRegistration && (
              <div>
                <label className="block text-sm text-gray-600 mb-1">Institute</label>
                <div className="relative">
                  <Building className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <select
                    value={form.institute}
                    onChange={(e) => handleChange('institute', e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  >
                    <option value="">Select an institute</option>
                    {institutes.map((institute) => (
                      <option key={institute.id} value={institute.id}>
                        {institute.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            )}

            {/* Password - required for both */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                {isInvitedRegistration ? 'Set Your Password *' : 'Password *'}
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="••••••••"
                  value={form.password}
                  onChange={(e) => handleChange('password', e.target.value)}
                  className="w-full h-10 pl-9 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {isInvitedRegistration && (
                <p className="text-xs text-gray-500 mt-1">Minimum 8 characters required</p>
              )}
            </div>

            {/* Phone (Optional) */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">Phone Number</label>
              <div className="relative">
                <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="tel"
                  placeholder="09991234567"
                  value={form.phone}
                  onChange={(e) => handleChange('phone', e.target.value)}
                  onKeyPress={(e) => { if (!/[0-9]/.test(e.key)) e.preventDefault(); }}
                  onPaste={(e) => {
                    e.preventDefault();
                    const pasted = e.clipboardData.getData('text') || '';
                    const digits = pasted.replace(/\D/g, '').slice(0, 11);
                    handleChange('phone', digits);
                  }}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  inputMode="numeric"
                  pattern="[0-9]*"
                />  
                {phoneError && <p className="text-red-600 text-sm mt-1">{phoneError}</p>}
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isLoading}
              aria-busy={isLoading}
              className={`w-full h-10 rounded-xl text-white font-medium transition ${isLoading ? 'opacity-60 cursor-not-allowed pointer-events-none' : ''}`}
              style={{ background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)" }}
            >
              {isLoading ? (isInvitedRegistration ? 'Completing Registration...' : 'Registering...') : (isInvitedRegistration ? 'Complete Registration' : 'Register')}
            </button>
          </form>

          <p className="text-center text-sm text-gray-600 mt-6">
            Already have an account?{" "}
            <a href="/login" className="text-blue-600 hover:underline">
              Login
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}
