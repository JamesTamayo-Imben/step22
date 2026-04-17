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
  const [institutes, setInstitutes] = useState([]);

  // Pre-fill form from URL query parameters and fetch institutes
  useEffect(() => {
    const searchParams = new URLSearchParams(window.location.search);
    const email = searchParams.get('email') || '';
    const password = searchParams.get('password') || '';
    const name = searchParams.get('name') || '';

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
      .then(res => res.json())
      .then(data => {
        if (data.institutes) {
          setInstitutes(data.institutes);
        }
      })
      .catch(err => console.error('Failed to fetch institutes:', err));
  }, []);

  const handleChange = (field, value) => {
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
      const response = await fetch('/api/auth/register-teacher', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'),
        },
        body: JSON.stringify({
          firstName: form.firstName,
          lastName: form.lastName,
          email: form.email,
          password: form.password,
          employeeId: form.employeeId,
          institute: form.institute || null,
          phone: form.phone || null,
          role: 'teacher',
        }),
      });

      const data = await response.json();

      if (response.ok) {
        setSuccess(true);
        // Redirect to login after success
        setTimeout(() => {
          window.location.href = '/login';
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

          <h2 className="text-center text-2xl text-gray-800 mb-2">Teacher Registration</h2>
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

            {form.password && (
              <div className="p-3 bg-blue-50 border border-blue-200 rounded-xl">
                <p className="text-xs text-gray-600 mb-1">Initial Password (Change after login)</p>
                <code className="text-sm font-mono text-gray-800">{form.password}</code>
              </div>
            )}

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

            {/* Employee ID */}
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

            {/* Institute (Optional) */}
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
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
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
