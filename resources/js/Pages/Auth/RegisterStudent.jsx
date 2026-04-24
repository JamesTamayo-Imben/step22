import { useState, useEffect } from "react";
import { Mail, Lock, User, Eye, EyeOff, AlertCircle, CheckCircle, BookOpen, Phone } from "lucide-react";

export default function RegisterStudentPage() {
  const [form, setForm] = useState({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    studentId: '',
    course: '',
    phone: '',
  });
  const [invitationToken, setInvitationToken] = useState('');

  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);
  const [courses, setCourses] = useState([]);
  const [phoneError, setPhoneError] = useState('');

  // Pre-fill form from URL query parameters and fetch courses
  useEffect(() => {
    const searchParams = new URLSearchParams(window.location.search);
    const email = searchParams.get('email') || '';
    const password = searchParams.get('password') || '';
    const name = searchParams.get('name') || '';
    const token = searchParams.get('invitation_token') || '';
    setInvitationToken(token);

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

    // Fetch courses
    fetch('/api/courses')
      .then(res => {
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res.json();
      })
      .then(data => {
        console.log('Courses data received:', data);
        if (data.courses && Array.isArray(data.courses)) {
          setCourses(data.courses);
          console.log('Courses set:', data.courses);
        } else {
          console.warn('Courses data not in expected format:', data);
        }
      })
      .catch(err => {
        console.error('Failed to fetch courses:', err);
        setError(`Failed to load courses: ${err.message}`);
      });
  }, []);

  const handleChange = (field, value) => {
    if (field === 'phone') {
      const cleaned = value.replace(/\D/g, '').slice(0, 11);
      setForm({ ...form, phone: cleaned });
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
      // Validation
      if (!form.firstName || !form.lastName) {
        throw new Error('Please provide your full name');
      }

      if (!form.studentId) {
        throw new Error('Please provide your student ID');
      }

      if (!form.email) {
        throw new Error('Email is required');
      }

      if (!form.password) {
        throw new Error('Password is required');
      }

      // Send registration request
      console.log('🚀 Sending registration request to /api/auth/register-student');
      console.log('📋 Form data:', {
        firstName: form.firstName,
        lastName: form.lastName,
        email: form.email,
        studentId: form.studentId,
        course: form.course || null,
        phone: form.phone || null,
        role: 'student',
      });

      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
      console.log('🔐 CSRF Token:', csrfToken ? '✅ Present' : '❌ Missing');

      // Validate and format phone before sending
      let phoneToSend = form.phone || null;
      if (phoneToSend) {
        if (phoneToSend.length < 10) throw new Error('Please enter a valid phone number (at least 10 digits)');
        if (phoneToSend.length > 11) throw new Error('Phone number cannot exceed 11 digits');
        if (phoneToSend.startsWith('9') && phoneToSend.length === 10) phoneToSend = '0' + phoneToSend;
      }

      const response = await fetch('/api/auth/register-student', {
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
          studentId: form.studentId,
          course: form.course || null,
          // course_id: null,
          phone: phoneToSend,
          role: 'student',
          invitation_token: invitationToken || null,
        }),
      });

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
        // Redirect to CSG dashboard after success
        setTimeout(() => {
          window.location.href = '/csg/dashboard';
        }, 2000);
      } else {
        throw new Error(data.message || 'Registration failed');
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
          <p className="text-lg">Student Registration</p>

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

          <h2 className="text-center text-2xl text-gray-800 mb-2">Student Registration</h2>
          <p className="text-center text-sm text-gray-500 mb-6">Complete your profile to get started</p>

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
{/* 
            {form.password && (
              <div className="p-3 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-xs text-gray-600 mb-1">Initial Password (Change after login)</p>
                <code className="text-sm font-mono text-gray-800">{form.password}</code>
              </div>
            )} */}

            {/* First + Last Name */}
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

            {/* Student ID */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">Student ID * <span className="text-xs text-gray-500">(Only KLD School ID Number)</span></label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="2024-1-2345"
                  value={form.studentId}
                  onChange={(e) => handleChange('studentId', e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
            </div>

            {/* Course (Optional) */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">Course</label>
              <div className="relative">
                <BookOpen className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <select
                  value={form.course}
                  onChange={(e) => handleChange('course', e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="">Select a course</option>
                  {courses.map((course) => (
                    <option key={course.id} value={course.id}>
                      {course.name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* password field is pre-filled but hidden, with a note to change it after login */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Password (Pre-filled, change after login)
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type={showPassword ? "text" : "password"}
                  value={form.password}
                  onChange={(e) => handleChange('password', e.target.value)}
                  className="w-full h-10 pl-9 pr-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
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
              {isLoading ? 'Completing Registration...' : 'Complete Registration'}
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
