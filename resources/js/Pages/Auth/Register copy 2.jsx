import { useState } from "react";
import { User, Mail, Lock, Eye, EyeOff } from "lucide-react";

export default function RegisterPage({ onNavigateToLogin }) {
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);

  return (
    <div className="min-h-screen flex">

      {/* LEFT PANEL (Same as Login) */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">

        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <h1 className="text-3xl font-medium mb-1">Welcome to STEP</h1>
          <p className="text-lg">Sign in with your school email</p>

          {/* <div className="mt-20 flex items-center gap-6">
            <div className="space-y-4 w-1/2">
              <h2 className="text-4xl font-semibold leading-tight">
                Transparent.<br />
                Accountable.<br />
                Trustworthy.
              </h2>
              <p className="text-white/80">
                Empowering students and organizations with financial transparency
                and collaborative decision-making.
              </p>
            </div>

            <div className="w-40">
              <img
                src="/images/login-bg.png"
                alt="Preview"
                className="rounded-xl shadow-xl"
              />
            </div>
          </div> */}
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
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">

        <div className="w-full max-w-lg bg-white rounded-2xl border border-gray-200 shadow-sm p-10">

          {/* Logo */}
          <div className="flex justify-center mb-3">
            <img src="/images/Logo.png" alt="Logo" className="w-14" />
          </div>

          <h2 className="text-center text-2xl text-gray-800 font-semibold">
            Sign Up
          </h2>
          <p className="text-center text-sm text-gray-500 mb-6">
            Create your account to get started
          </p>

          {/* Google */}
          <button className="w-full h-10 border border-gray-300 rounded-lg flex items-center justify-center gap-2 bg-white hover:bg-gray-50 transition">
            <svg viewBox="0 0 48 48" width="18" height="18">
              <path fill="#EA4335" d="M24 9.5c3.5 0 6.6 1.2 9 3.2l6.7-6.7C35.8 2.2 30.2 0 24 0 14.6 0 6.6 5.4 2.6 13.3l7.8 6C12.3 13 17.7 9.5 24 9.5z"/>
              <path fill="#4285F4" d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.6 3-2.4 5.6-5 7.3l7.8 6C44.2 37.7 46.5 31.6 46.5 24.5z"/>
              <path fill="#FBBC05" d="M10.4 28.3c-1-3-.9-6.2 0-9.2l-7.8-6C-1.5 18.4-1.5 29.6 2.6 34.9l7.8-6.6z"/>
              <path fill="#34A853" d="M24 48c6.2 0 11.8-2 15.7-5.5l-7.8-6c-2.2 1.5-5 2.3-7.9 2.3-6.3 0-11.7-3.5-13.6-8.8l-7.8 6C6.6 42.6 14.6 48 24 48z"/>
            </svg>
            <span className="text-sm font-medium text-gray-700">
              Continue with Google
            </span>
          </button>

          {/* Divider */}
          <div className="flex items-center my-6">
            <div className="flex-grow border-t border-gray-300"></div>
            <span className="mx-4 text-xs text-gray-500">OR</span>
            <div className="flex-grow border-t border-gray-300"></div>
          </div>

          <form className="space-y-5">

            {/* First + Last Name */}
            <div className="grid grid-cols-2 gap-4">
              <label className="block text-sm text-gray-600 mb-1">
                First
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="First Name"
                  className="w-full h-10 pl-9 rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none"
                />
              </div>

              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Last Name"
                  className="w-full h-10 pl-9 rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none"
                />
              </div>
            </div>

            {/* Email */}
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                placeholder="your.name@kid.edu.ph"
                className="w-full h-10 pl-9 rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none"
              />
            </div>
            <p className="text-xs text-gray-500 -mt-3">
              Use your school email (kid.edu.ph)
            </p>

            {/* Passwords */}
            <div className="grid grid-cols-2 gap-4">
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Min. 8 characters"
                  className="w-full h-10 pl-9 pr-9 rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                >
                  {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
                </button>
              </div>

              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type={showConfirm ? "text" : "password"}
                  placeholder="Re-enter password"
                  className="w-full h-10 pl-9 pr-9 rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none"
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

            {/* Institute */}
            <select className="w-full h-10 rounded-lg border border-gray-300 bg-gray-50 px-4 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none">
              <option>Choose your institute</option>
            </select>

            {/* Terms */}
            <div className="flex items-start gap-2 text-sm text-gray-600">
              <input type="checkbox" className="mt-1" />
              <p>
                I agree to the{" "}
                <span className="text-blue-600 hover:underline cursor-pointer">
                  Terms and Conditions
                </span>{" "}
                and{" "}
                <span className="text-blue-600 hover:underline cursor-pointer">
                  Privacy Policy
                </span>
              </p>
            </div>

            {/* Button */}
            <button className="w-full h-11 rounded-lg bg-gradient-to-r from-blue-500 to-blue-700 text-white font-medium hover:opacity-90 transition">
              Create Account
            </button>

          </form>

          {/* Login */}
          <p className="text-center text-sm text-gray-600 mt-6">
            Already have an account?{" "}
            <button
              onClick={onNavigateToLogin}
              className="text-blue-600 hover:underline"
            >
              Login
            </button>
          </p>

        </div>
      </div>
    </div>
  );
}