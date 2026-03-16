import { useState } from "react";
import { Link } from '@inertiajs/react';
import { User, Lock, Eye, EyeOff } from "lucide-react";
// ============================================================================
// SUPABASE AUTH - TEMPORARILY COMMENTED OUT
// Description: This import and useSupabase hook are disabled for database auth
// To re-enable Supabase authentication:
//   1. Uncomment the import line below
//   2. Uncomment the useSupabase hook initialization
//   3. Uncomment the Google login handler inside handleGoogleLogin()
//   4. Uncomment the signIn() call in handleSubmit()
// Currently using Laravel/step2 database for authentication instead
// ============================================================================
// import { useSupabase } from "../../context/SupabaseContext";

export default function LoginPage({ onLogin, onNavigateToRegister }) {
    // ========== SUPABASE HOOK - UNCOMMENT TO RE-ENABLE SUPABASE AUTH ==========
    // const { signIn, signInWithGoogle, validateGoogleEmailDomain, user } = useSupabase();
    
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

      // Validate email domain
      // if (!uname.endsWith("@kld.edu.ph")) {
      //   throw new Error("Email must be a valid KLD school email (@kld.edu.ph)");
      // }

      if (!password) {
        throw new Error("Please enter your password");
      }

      // ======= STEP2 DATABASE AUTH (CURRENT) =======
      // Using Laravel backend to authenticate against step2 database
      const payload = {
        email: uname,
        password: password,
      };
      
      console.log('Sending login request with payload:', payload);
      
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
        throw new Error(data.message || "Login failed. Please check your credentials.");
      }

      // Store remember me preference
      if (rememberMe) {
        localStorage.setItem('rememberMe', 'true');
        localStorage.setItem('rememberedEmail', uname);
      }

      // Store user info in localStorage for frontend use
      localStorage.setItem('user', JSON.stringify(data.user));

      // Redirect to appropriate dashboard based on role
      window.location.href = data.redirect || "/dashboard";

      /* ======= SUPABASE AUTH (COMMENTED OUT - UNCOMMENT TO RE-ENABLE) =======
      // Sign in with Supabase (using email as username)
      const result = await signIn(uname, password);

      // Store remember me preference
      if (rememberMe) {
        localStorage.setItem('rememberMe', 'true');
        localStorage.setItem('rememberedEmail', uname);
      }

      // Call onLogin callback if provided
      if (onLogin) {
        // Determine role from metadata or default to 'user'
        const role = result.user?.user_metadata?.role || 'user';
        onLogin(role, uname);
      } else {
        // Fallback: navigate to dashboard
        window.location.href = "/user";
      }
      ======= END SUPABASE AUTH ======= */
    } catch (err) {
      setError(err.message || "Login failed. Please check your credentials.");
      console.error("Login error:", err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    // ======= GOOGLE OAUTH (SUPABASE) - COMMENTED OUT =======
    // This feature requires Supabase to be enabled
    // To re-enable Google login with Supabase:
    //   1. Uncomment the code below
    //   2. Make sure useSupabase hook is imported and initialized
    //   3. This will redirect to Google login via Supabase
    // For now, only email/password login via step2 database is available
    // ========================================================
    
    /* SUPABASE GOOGLE LOGIN - UNCOMMENT TO RE-ENABLE
    try {
      setError("");
      setIsLoading(true);
      
      // Initiate Google OAuth sign-in with Supabase
      // This will redirect to Google login page
      const { error } = await signInWithGoogle();
      
      if (error) {
        throw error;
      }
      
      // Note: Execution stops here and redirects to Google
      // User will be redirected back to /auth/callback after Google login
      // Do NOT add code after signInWithGoogle() - it won't execute!
    } catch (err) {
      setError(err.message || "Google login failed. Please try again.");
      console.error("Google login error:", err);
      setIsLoading(false);
    }
    */
    
    // For now, show a message that Google login is disabled
    setError("Google login is currently disabled. Please use email/password login.");
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