import { useState } from "react";
import { Link } from '@inertiajs/react';
import { User, Lock, Eye, EyeOff } from "lucide-react";
import { useSupabase } from "../../context/SupabaseContext";
import {
ArrowLeftIcon,
} from 'lucide-react';

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

  input {
    transition: all 0.3s ease;
  }
`;

export default function LoginPage({ onLogin, onNavigateToRegister, archivedMessage }) {
  const { signIn, signInWithGoogle } = useSupabase(); // ✅ re-enabled

  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(archivedMessage || "");
  const [showArchivedModal, setShowArchivedModal] = useState(Boolean(archivedMessage));

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    
    //click remember me, then click login, it will show error message "Login failed. Please check your credentials." even if the credentials are correct. This is because the rememberMe state is not being updated correctly before the login request is made. To fix this, we can update the handleSubmit function to ensure that the rememberMe state is properly set before making the login request.
    if (!rememberMe) {
      setError("You must check 'Remember me' to continue.");
    return;
    }

    setIsLoading(true);

    try {
      const uname = username.trim();
      if (!uname) throw new Error("Please enter your email");

      if (!uname.endsWith("@kld.edu.ph")) {
        throw new Error("Email must be a valid KLD school email (@kld.edu.ph)");
      }

      if (!password) throw new Error("Please enter your password");

      const payload = { email: uname, password };

      const response = await fetch('/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
        },
        body: JSON.stringify(payload),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Login failed. Please check your credentials.");
      }

      if (rememberMe) {
        localStorage.setItem('rememberMe', 'true');
        localStorage.setItem('rememberedEmail', uname);
      }

      localStorage.setItem('user', JSON.stringify(data.user));
      window.location.href = data.redirect || "/dashboard";

    } catch (err) {
      setError(err.message || "Login failed. Please check your credentials.");
      console.error("Login error:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    try {
      setError("");
      setIsLoading(true);

      const { error } = await signInWithGoogle(); // ✅ now works

      if (error) throw error;

      // Supabase will redirect automatically after Google OAuth
    } catch (err) {
      setError(err.message || "Google login failed. Please try again.");
      console.error("Google login error:", err);
      setIsLoading(false);
    }
  };

  const goToRegister = () => {
    if (onNavigateToRegister) return onNavigateToRegister();
    window.location.href = '/register';
  };

  return (
    <div className="min-h-screen flex">
      <style>{animationStyles}</style>

      {showArchivedModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4" role="dialog" aria-modal="true" aria-labelledby="archived-account-title">
          <div className="w-full max-w-md rounded-2xl bg-white p-6 shadow-2xl">
            <div className="mb-4 flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-red-100 text-red-600">
                !
              </div>
              <h2 id="archived-account-title" className="text-lg font-semibold text-gray-900">
                Account Archived
              </h2>
            </div>
            <p className="text-sm leading-6 text-gray-600">
              Your account has been archived from the system. Please contact the authorities.
            </p>
            <button
              type="button"
              onClick={() => setShowArchivedModal(false)}
              className="mt-6 w-full rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-medium text-white hover:bg-blue-700"
            >
              Close
            </button>
          </div>
        </div>
      )}

      {/* LEFT PANEL */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          {/* <div className="flex items-center gap-4 mb-10">
  <img 
    src="/images/kldlogo.png" 
    alt="Step Logo" 
    className="w-16 h-16 object-cover border-2 border-white rounded-full bg-white flex-shrink-0" 
  />
  <div>
    <h1 className="text-lg font-medium">Kolehiyo ng Lungsod ng Dasmarinas</h1>
    <p className="text-sm">In Partial Fulfilment of the Requirements for the Degree 
Bachelor of Science in Information Systems</p>
  </div>
</div> */}

          <h1 className="text-4xl font-bold">Welcome to STEP</h1>
          <p className="text-sm">Sign in with your school email</p>

          <div className="relative flex justify-center mb-10 mt-20">
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

            <div className="mt-20 gap-4 overflow-hidden">
              <img src="/images/login-bg.png" alt="Login Background" className="rounded-[24px] drop-shadow-lg w-full object-cover" />
            </div>

          </div>
           <div>
              <p className="text-white max-w">
                Empowering students and organizations with financial transparency
                and collaborative decision making. 
              </p> 
            </div>
        </div>
         {/* <div>
              <p className="text-white/80 max-w-md">
                Between dought and trust a bridge we design, 
                One STEP at a time.
              </p> 
            </div> */}
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6 relative">
    <div className="absolute top-6 left-6">
      <Link href="/" className="text-blue-600 hover:underline flex items-center gap-1">
        <ArrowLeftIcon className="w-4 h-4" />
        <span>Go back to Home</span>
      </Link>
    </div>

        <div className="w-full max-w-md bg-white rounded-2xl border border-gray-200 shadow-sm p-10 fade-in-container mt-11 md:mt-11">


          <div className="flex justify-center mb-2">
            <div className="w-20 overflow-hidden px-2">
              <img src="/images/Logo.svg" alt="Step Logo" className="w-full object-cover" />
            </div>
          </div>

          <h2 className="text-center text-2xl text-gray-800 mb-6">Login</h2>

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
            <span className="text-sm text-gray-700 font-medium">Continue with Google</span>
          </button>

          {/* Divider */}
          <div className="flex items-center my-6">
            <div className="flex-grow border-t border-gray-300"></div>
            <span className="mx-4 text-xs text-gray-500">OR</span>
            <div className="flex-grow border-t border-gray-300"></div>
          </div>

          {error && (
            <div className="mb-4 p-3 text-sm text-red-700 bg-red-50 rounded-lg border border-red-200">
              {error}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-5">

            <div>
              <label className="block text-sm text-gray-600 mb-1">
                Email Address
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="your.name@kld.edu.ph"
                  type="email"
                  value={username}
                  onChange={(e) => setUsername(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm text-gray-600 mb-1">Password</label>
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
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

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

            <button
              type="submit"
              disabled={isLoading}
              className={`w-full h-10 rounded-xl text-white font-medium transition ${isLoading ? 'opacity-60 cursor-not-allowed pointer-events-none' : ''}`}
              style={{ background: "linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)" }}
            >
              {isLoading ? "Logging in..." : "Login"}
            </button>
          </form>

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