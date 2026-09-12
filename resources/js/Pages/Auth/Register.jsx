import { useState, useEffect } from "react";
import { User, Mail, Lock, Eye, EyeOff, Shield, ArrowLeftIcon } from "lucide-react";
import { useSupabase } from "../../context/SupabaseContext";
import VerifyOTPPage from "./VerifyOTP";
import { Link } from '@inertiajs/react';

const animationStyles = `
  html {
    scroll-behavior: smooth;
  }

  @keyframes fadeInSlideUp {
    from {
      opacity: 0;
      transform: translateY(20px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }

  .fade-in-container {
    animation: fadeInSlideUp 0.6s ease-out;
  }

  button, a {
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
  }

  input, select {
    transition: all 0.3s ease;
  }
`;

export default function RegisterPage({ onRegister, onNavigateToLogin }) {
  const { signUp, signInWithGoogle, validateGoogleEmailDomain, user } = useSupabase();

  const [showOTPPage, setShowOTPPage] = useState(false);
  const [pendingEmail, setPendingEmail] = useState("");

  const [roleOptions, setRoleOptions] = useState([]);

  const [form, setForm] = useState({
    firstName: "",
    lastName: "",
    email: "",
    password: "",
    confirmPassword: "",
    role: "",
    studentId: "",
    courseId: "",
    agree: false,
  });

  const [courseList, setCourseList] = useState([]);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  // Log available roles and fetch courses on component mount
  useEffect(() => {
    console.log("🎯 Register Component Loaded");
    console.log("📋 Available Roles:", roleOptions);
    
    // Fetch live role IDs and courses for registration.
    const fetchRegistrationData = async () => {
      try {
        const [rolesResponse, coursesResponse] = await Promise.all([
          fetch('/api/registration-roles', { headers: { 'Accept': 'application/json' } }),
          fetch('/api/onboarding/courses', { headers: { 'Accept': 'application/json' } }),
        ]);

        if (!rolesResponse.ok || !coursesResponse.ok) {
          throw new Error('Registration data could not be loaded. Please refresh the page.');
        }

        const rolesData = await rolesResponse.json();
        const coursesData = await coursesResponse.json();
        const roles = rolesData.roles || [];

        setRoleOptions(roles);
        setForm((currentForm) => ({
          ...currentForm,
          role: roles.find((role) => role.slug === 'student')?.id || '',
        }));
        setCourseList(coursesData.courses || []);
        console.log('✅ Registration data loaded');
      } catch (err) {
        console.error('❌ Failed to fetch registration data:', err);
        setError(err.message || 'Registration data could not be loaded. Please refresh the page.');
      }
    };
    
    fetchRegistrationData();
  }, []);

  const handleChange = (field, value) => {
    setForm({ ...form, [field]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      // Validation
      if (
        !form.firstName ||
        !form.lastName ||
        !form.email ||
        !form.password ||
        !form.confirmPassword ||
        !form.role
      ) {
        throw new Error("Please fill in all required fields.");
      }

      // For students, validate Student ID and Course
      const selectedRole = roleOptions.find(r => r.id === form.role);
      if (selectedRole?.slug === 'student') {
        if (!form.studentId) {
          throw new Error("Please enter your Student ID.");
        }
        if (!form.courseId) {
          throw new Error("Please select a course.");
        }
      }

       if (!form.email.endsWith("@kld.edu.ph")) {
        throw new Error("Email must be a valid KLD school email (@kld.edu.ph)");
      }

      if (form.password.length < 8) {
        throw new Error("Password must be at least 8 characters.");
      }

      if (form.password !== form.confirmPassword) {
        throw new Error("Passwords do not match.");
      }

      if (!form.agree) {
        throw new Error("You must agree to the terms and conditions.");
      }

      // Send OTP to email via Laravel backend
      // Supabase Auth user will be created after OTP verification (in backend)
      console.log("📧 Sending OTP to email:", form.email);

      // Debug: Log what we're sending
      const payload = {
        email: form.email,
        firstName: form.firstName,
        lastName: form.lastName,
        password: form.password,
        role_id: form.role,
      };

      // Add student details if registering as student
      if (selectedRole?.slug === 'student') {
        payload.student_id = form.studentId;
        payload.course_id = form.courseId;
      }

      console.log("📤 Request payload:", payload);

      // Get CSRF token from meta tag
      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content");
      if (!csrfToken) {
        throw new Error("CSRF token not found. Please refresh the page and try again.");
      }

      const response = await fetch("/api/send-otp", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-TOKEN": csrfToken,
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        // Try to parse as JSON, if it fails, return generic error
        let errorData = {};
        try {
          errorData = await response.json();
        } catch (e) {
          console.error("❌ Server error (non-JSON response):", response.status);
          throw new Error("Server error. Please try again later.");
        }

        console.error("❌ OTP Send Error Response:", errorData);

        // Show detailed validation errors if available
        if (errorData.errors) {
          const errorMessages = Object.values(errorData.errors)
            .flat()
            .join("\n");
          throw new Error(errorMessages || errorData.message || "Validation failed");
        }

        throw new Error(errorData.message || "Failed to send OTP. Please try again.");
      }

      const data = await response.json();
      console.log("✅ OTP sent successfully");

      // Store email and show OTP verification page
      setPendingEmail(form.email);
      setShowOTPPage(true);
    } catch (err) {
      setError(err.message || "Registration failed. Please try again.");
      console.error("Registration error:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleRegister = async () => {
    try {
      setError("");
      setIsLoading(true);

      // Initiate Google OAuth sign-up with Supabase
      const { error } = await signInWithGoogle();

      if (error) {
        throw error;
      }

    } catch (err) {
      setError(err.message || "Google sign-up failed. Please try again.");
      console.error("Google sign-up error:", err);
      setIsLoading(false);
    }
  };

  const goToLogin = () => {
    if (onNavigateToLogin) return onNavigateToLogin();
    window.location.href = '/login';
  };

  const handleOTPVerifySuccess = (data) => {
    console.log("✅ OTP verified, user registered successfully");
    // Redirect to dashboard after OTP verification (profile is completed)
    window.location.href = "/user";
  };

  const handleBackToRegister = () => {
    setShowOTPPage(false);
    setPendingEmail("");
    setError("");
  };

  // Show OTP verification page if email registration was submitted
  if (showOTPPage) {
    return (
      <VerifyOTPPage
        email={pendingEmail}
        onVerifySuccess={handleOTPVerifySuccess}
        onBackToRegister={handleBackToRegister}
      />
    );
  }

  return (
    <div className="">
      <style>{animationStyles}</style>

<div className="flex h-screen overflow-hidden mx-auto">
      {/* LEFT PANEL (Same as Login) */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] h-screen text-white p-12 flex-col justify-between relative overflow-hidden">

        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <h1 className="text-4xl font-bold">Welcome to STEP</h1>
          <p className="text-sm">Create your school account</p>

            <div className="relative z-10 mt-10 flex justify-center mb-10">
            <div className="mt-44 space-y-4 w-1/2">
              <h2 className="text-4xl font-semibold leading-tight">
                Transparent.<br />
                Accountable.<br />
                Trustworthy.
              </h2>
              {/* <p className="text-white/80 max-w-md">
                Empowering students and organizations with financial transparency
                and collaborative decision-making.
              </p> */}
            </div>

            <div className="mt-20 gap-2 overflow-hidden">
              <img src="/images/login-bg.png" alt="Login Background" className="w-full object-cover rounded-[24px] drop-shadow-lg" />
            </div>

          </div>
           <div>
              <p className="text-white/80 max-w-md">
                Empowering students and organizations with financial transparency
                and collaborative decision making. 
              </p> 
            </div>
        </div>
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 bg-[#F5F6F8] p-6 relative overflow-y-auto ">

 <div className="absolute top-6 left-6">
  <Link href="/" className="text-blue-600 hover:underline flex items-center gap-1">
    <ArrowLeftIcon className="w-4 h-4" />
    <span>Go back to Home</span>
  </Link>
</div>

        <div className="w-full max-w-lg mx-auto bg-white rounded-2xl border border-gray-200 shadow-sm p-10 mt-11 md:mt-11 fade-in-container">

          {/* Logo */}
          <div className="flex justify-center mb-2">
            <div className="w-20 overflow-hidden px-2">
              <img
                src="/images/Logo.svg"
                alt="Step Logo"
                className="w-full object-cover"
              />
            </div>
          </div>

          <h2 className="text-center text-2xl text-gray-800 mb-2">
            Sign Up
          </h2>

          <p className="text-center text-sm text-gray-500 mb-6">
            Create your account to get started
          </p>

          {/* Google Button */}
          <button
            onClick={handleGoogleRegister}
            disabled={isLoading}
            className="w-full h-10 border border-gray-300 rounded-xl flex items-center justify-center gap-2 bg-white hover:bg-gray-50 transition"
          >
            <svg viewBox="0 0 48 48" width="18" height="18">
              <path fill="#EA4335" d="M24 9.5c3.5 0 6.6 1.2 9 3.2l6.7-6.7C35.8 2.2 30.2 0 24 0 14.6 0 6.6 5.4 2.6 13.3l7.8 6C12.3 13 17.7 9.5 24 9.5z" />
              <path fill="#4285F4" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.6 3-2.4 5.6-5 7.3l7.8 6C44.2 37.7 46.5 31.6 46.5 24.5z" />
              <path fill="#FBBC05" d="M10.4 28.3c-1-3-.9-6.2 0-9.2l-7.8-6C-1.5 18.4-1.5 29.6 2.6 34.9l7.8-6.6z" />
              <path fill="#34A853" d="M24 48c6.2 0 11.8-2 15.7-5.5l-7.8-6c-2.2 1.5-5 2.3-7.9 2.3-6.3 0-11.7-3.5-13.6-8.8l-7.8 6C6.6 42.6 14.6 48 24 48z" />
            </svg>
            <span className="text-sm text-gray-700 font-medium">
              Continue with Google
            </span>
          </button>

          {/* Divider */}
          <div className="flex items-center my-6">
            <div className="flex-grow border-t border-gray-300"></div>
            <span className="mx-4 text-xs text-gray-500">OR</span>
            <div className="flex-grow border-t border-gray-300"></div>
          </div>

          {/* Error */}
          {error && (
            <div className="mb-4 p-3 text-sm text-red-700 bg-red-50 rounded-lg border border-red-200">
              {error}
            </div>
          )}

          {/* FORM */}
          <form onSubmit={handleSubmit} className="space-y-5">

            {/* First + Last */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm text-gray-600 mb-1">
                  First Name <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    placeholder="Juan"
                    value={form.firstName}
                    onChange={(e) => handleChange("firstName", e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm text-gray-600 mb-1">
                  Last Name <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    placeholder="Cruz"
                    value={form.lastName}
                    onChange={(e) => handleChange("lastName", e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                </div>
              </div>

            </div>

            {/* Email */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Email Address <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="email"
                  placeholder="your.name@kld.edu.ph"
                  value={form.email}
                  onChange={(e) => handleChange("email", e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
            </div>


            {/* Passwords */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm text-gray-600 mb-1">
                  Password <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type={showPassword ? "text" : "password"}
                    placeholder="Min. 8 characters"
                    value={form.password}
                    onChange={(e) => handleChange("password", e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                  >
                    {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                  </button>
                </div>
              </div>


              <div>
                <label className="block text-sm text-gray-600 mb-1">
                  Confirm Password <span className="text-red-500">*</span>
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <input
                    type={showConfirm ? "text" : "password"}
                    placeholder="Re-enter password"
                    value={form.confirmPassword}
                    onChange={(e) => handleChange("confirmPassword", e.target.value)}
                    className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  />
                  <button
                    type="button"
                    onClick={() => setShowConfirm(!showConfirm)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                  >
                    {showConfirm ? <EyeOff size={16} /> : <Eye size={16} />}
                  </button>
                </div>
              </div>

            </div>

            {/* Role Selection */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Role
              </label>
              <div className="relative">
                <Shield className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  value="Student"
                  disabled
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-100 text-gray-700 cursor-not-allowed"
                />
                <input type="hidden" name="role" value={form.role} />
              </div>
            </div>

            {/* Student ID */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Student ID <span className="text-red-500">*</span>
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="e.g., STU001"
                  value={form.studentId}
                  onChange={(e) => handleChange("studentId", e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
            </div>

            {/* Course Selection */}
            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Course <span className="text-red-500">*</span>
              </label>
              <select
                value={form.courseId}
                onChange={(e) => handleChange("courseId", e.target.value)}
                className="w-full h-10 pl-3 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition text-gray-700"
              >
                <option value="">-- Select a course --</option>
                {courseList.map((course) => (
                  <option key={course.id} value={course.id}>
                    {course.name || course.title || 'Unknown Course'}
                  </option>
                ))}
              </select>
            </div>

            {/* Terms */}
            <label className="flex items-center gap-2 text-sm text-gray-600">
              <input
                type="checkbox"
                checked={form.agree}
                onChange={(e) => handleChange("agree", e.target.checked)}
                className="rounded border-gray-300"
              />
              I agree to the Terms and Privacy Policy
            </label>

            {/* Button */}
            <button
              type="submit"
              disabled={isLoading}
              aria-busy={isLoading}
              className={`w-full h-10 rounded-xl text-white font-medium transition ${isLoading ? 'opacity-60 cursor-not-allowed pointer-events-none' : ''}`}
              style={{ background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)" }}
            >
              {isLoading ? "Creating account..." : "Create Account"}
            </button>
          </form>

          {/* Login */}
          <p className="text-center text-sm text-gray-600 mt-6">
            Already have an account?{" "}
            <button onClick={goToLogin} className="text-blue-600 hover:underline">
              Login
            </button>
          </p>
        </div>
      </div>
      </div>
    </div>
  );
}