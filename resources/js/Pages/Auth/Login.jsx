import { useState } from "react";
import { Link } from '@inertiajs/react';
import { User, Lock, Eye, EyeOff } from "lucide-react";

export default function LoginPage({ onLogin, onNavigateToRegister }) {
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

    await new Promise((resolve) => setTimeout(resolve, 1000));

    const uname = username.trim();
    if (!uname) {
      setError("Please enter a username");
      setIsLoading(false);
      return;
    }

    // Accept any password but only specific usernames map to roles
    const key = uname.toLowerCase();
    const allowed = {
      sadmin: "SAdmin",
      adviser: "Adviser",
      csg: "CSG",
      user: "user",
    };

    if (!Object.keys(allowed).includes(key)) {
      setError("Invalid username. Use SAdmin, Adviser, CSG, or user.");
      setIsLoading(false);
      return;
    }

    const role = allowed[key];

    // If parent provided a handler, call it with (role, username)
    if (onLogin) {
      onLogin(role, username);
      return;
    }

    // Otherwise navigate to role-specific path
    // paths: /sadmin, /adviser, /csg, /user
    window.location.href = `/${key}`;
  };

  const handleGoogleLogin = () => {
    setIsLoading(true);
    setTimeout(() => {
      // treat Google login as a regular user in this demo
      if (onLogin) {
        onLogin("user", "google");
        return;
      }
      window.location.href = "/user";
    }, 1200);
  };

  const goToRegister = () => {
    if (onNavigateToRegister) return onNavigateToRegister();
    window.location.href = '/register';
  };

  return (
    <div className="min-h-screen flex">

      {/* LEFT PANEL */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">

        {/* Decorative Circles */}
        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <h1 className="text-3xl font-medium mb-1">Welcome to STEP</h1>
          <p className="text-lg">Sign in with your school email</p>

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
              src="/images/login-bg.png" alt="Login Background"
              className="w-full object-cover"/>
            </div>
          </div>
        </div>

        {/* Image Preview (like Figma stacked cards look) */}
        {/* <div className="relative z-10 mt-10 flex justify-center">
          <div className="w-64 rounded-2xl overflow-hidden shadow-2xl">
            <img
              src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400"
              alt="Preview"
              className="w-full h-80 object-cover"
            />
          </div>
        </div> */}
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">

        <div className="w-full max-w-md bg-white rounded-2xl border border-gray-200 shadow-sm p-10">

          {/* STEP Icon */}
          <div className="flex justify-center mb-2">
            {/* <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-blue-700 rounded-lg flex items-center justify-center">
              <span className="text-white font-semibold">S</span>
            </div> */}
            <div className="w-20 overflow-hidden px-2">
              <img
              src="/images/Logo.png" alt="Step Logo"
              className="w-full object-cover"/>
            </div>
          </div>

          <h2 className="text-center text-2xl text-gray-800 mb-6">
            Login
          </h2>

          {/* Google Button */}
          <button
            onClick={handleGoogleLogin}
            disabled={isLoading}
            className="w-full h-10 border border-gray-300 rounded-xl flex items-center justify-center gap-2 bg-white hover:bg-gray-50 transition"
          >
            <svg viewBox="0 0 48 48" width="18" height="18">
              <path fill="#EA4335" d="M24 9.5c3.5 0 6.6 1.2 9 3.2l6.7-6.7C35.8 2.2 30.2 0 24 0 14.6 0 6.6 5.4 2.6 13.3l7.8 6C12.3 13 17.7 9.5 24 9.5z"/>
              <path fill="#4285F4" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.6 3-2.4 5.6-5 7.3l7.8 6C44.2 37.7 46.5 31.6 46.5 24.5z"/>
              <path fill="#FBBC05" d="M10.4 28.3c-1-3-.9-6.2 0-9.2l-7.8-6C-1.5 18.4-1.5 29.6 2.6 34.9l7.8-6.6z"/>
              <path fill="#34A853" d="M24 48c6.2 0 11.8-2 15.7-5.5l-7.8-6c-2.2 1.5-5 2.3-7.9 2.3-6.3 0-11.7-3.5-13.6-8.8l-7.8 6C6.6 42.6 14.6 48 24 48z"/>
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
            <div className="mb-4 text-sm text-red-600">
              {error}
            </div>
          )}

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-5">

            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Username
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Enter your username"
                  type="text"
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

            {/* Remember + Forgot */}
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
              {isLoading ? "Logging in..." : "Login"}
            </button>
          </form>

          {/* Register */}
          <p className="text-center text-sm text-gray-600 mt-6">
            Don't have an account?{" "}
            <button onClick={goToRegister} className="text-blue-600 hover:underline">
              Sign up
            </button>
          </p>
        </div>
      </div>
    </div>
  );
}