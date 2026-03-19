import { useState } from "react";
import { Link, router } from '@inertiajs/react';
import { User, Lock, Eye, EyeOff, Shield } from "lucide-react";

export default function SuperAdminLoginPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      const uname = username.trim();
      if (!uname) {
        throw new Error("Please enter your email");
      }

      if (!password) {
        throw new Error("Please enter your password");
      }

      const payload = {
        email: uname,
        password: password,
        isSuperAdmin: true,
      };
      
      console.log('Sending superadmin login request with payload:', payload);
      
      const response = await fetch('/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        },
        body: JSON.stringify(payload),
      });

      console.log('Response status:', response.status);
      
      const data = await response.json();
      
      console.log('Response data:', data);

      if (!response.ok) {
        // Check if it's a non-superadmin trying to login on secret portal
        if (response.status === 403 && data.message?.includes('does not have superadmin')) {
          // Redirect to regular login
          console.log('Non-superadmin detected, redirecting to regular login...');
          setError("Redirecting to regular login portal...");
          setTimeout(() => {
            router.visit(route('login'));
          }, 1500);
          return; // Exit without throwing error
        }
        throw new Error(data.message || "Login failed. Please check your credentials.");
      }

      // Verify user is superadmin
      if (data.user?.role !== 'superadmin') {
        // Redirect admin/adviser to regular login
        console.log('Non-superadmin account detected, redirecting to regular login...');
        setError("Redirecting to regular login portal...");
        setTimeout(() => {
          router.visit(route('login'));
        }, 1500);
        return; // Exit without throwing error
      }

      // Store remember me preference
      if (rememberMe) {
        localStorage.setItem('rememberMe', 'true');
        localStorage.setItem('rememberedEmail', uname);
      }

      // Store user info in localStorage for frontend use
      localStorage.setItem('user', JSON.stringify(data.user));

      // Redirect to superadmin dashboard
      window.location.href = data.redirect || "/sadmin";

    } catch (err) {
      setError(err.message || "Login failed. Please check your credentials.");
      console.error("Superadmin login error:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const goBackToLogin = () => {
    router.visit(route('login'));
  };

  return (
    <div className="min-h-screen flex">

      {/* LEFT PANEL */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">

        {/* Decorative Circles */}
        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <div className="flex items-center gap-3 mb-4">
            <Shield className="w-8 h-8" />
            <h1 className="text-3xl font-bold">STEP SuperAdmin</h1>
          </div>
          <p className="text-lg text-blue-100">Administrative Access Portal</p>

          <div className="relative z-10 mt-10 flex justify-center">
            <div className="mt-20 space-y-4 w-1/2">
              <h2 className="text-4xl font-semibold leading-tight">
                System.<br />
                Control.<br />
                Authority.
              </h2>
              <p className="text-white/80 max-w-md">
                Exclusive administrative interface for system superadministrators
                and platform management.
              </p>
            </div>

            <div className="gap-2 overflow-hidden">
              <img
                src="/images/login-bg.png" alt="Login Background"
                className="w-full object-cover"
              />
            </div>
          </div>
        </div>
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">

        <div className="w-full max-w-md bg-white rounded-2xl border-2 border-gray-200 shadow-lg p-10">

          {/* STEP Icon */}
          <div className="flex justify-center mb-2">
            <div className="w-20 overflow-hidden px-2">
              <img
                src="/images/Logo.png" alt="Step Logo"
                className="w-full object-cover"
              />
            </div>
          </div>

          {/* Secret Badge */}
          <div className="flex justify-center mb-4">
            <div className="bg-blue-100 text-blue-700 px-4 py-2 rounded-full text-sm font-semibold flex items-center gap-2">
              <Shield className="w-4 h-4" />
              SuperAdmin Access
            </div>
          </div>

          <h2 className="text-center text-2xl text-gray-800 mb-6">
            Administrative Login
          </h2>

          {/* Error */}
          {error && (
            <div className="mb-4 p-3 text-sm text-red-700 bg-red-50 rounded-lg border border-red-200">
              {error}
            </div>
          )}

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-5">

            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Email Address
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="admin@kld.edu.ph"
                  type="email"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Password
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Enter your password"
                  type={showPassword ? "text" : "password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full h-10 pl-9 pr-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                >
                  {showPassword ? (
                    <EyeOff className="w-4 h-4" />
                  ) : (
                    <Eye className="w-4 h-4" />
                  )}
                </button>
              </div>
            </div>

            {/* Remember Me */}
            <div className="flex items-center justify-between text-sm">
              <label className="flex items-center gap-2 text-gray-600">
                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="rounded border-gray-300"
                />
                Remember me
              </label>

              <Link href={route('password.request')} className="text-blue-600 hover:underline">
                Forgot password?
              </Link>
            </div>

            {/* Login Button */}
            <button
              type="submit"
              disabled={isLoading}
              aria-busy={isLoading}
              className={`w-full h-10 rounded-xl text-white font-medium transition ${isLoading ? 'opacity-60 cursor-not-allowed pointer-events-none' : ''}`}
              style={{ background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)" }}
            >
              {isLoading ? "Logging in..." : "Login as SuperAdmin"}
            </button>
          </form>

          {/* Back to Regular Login */}
          <p className="text-center text-sm text-gray-600 mt-6">
            <button onClick={goBackToLogin} className="text-blue-600 hover:underline">
              Back to Regular Login
            </button>
          </p>

          {/* Footer Note */}
          <div className="mt-8 p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-xs text-yellow-800">
            <p className="font-semibold mb-1">⚠️ Restricted Access</p>
            <p>This login portal is restricted to authorized system administrators only. Unauthorized access attempts will be logged.</p>
          </div>
        </div>
      </div>
    </div>
  );
}
