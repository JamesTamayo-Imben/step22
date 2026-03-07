import { useState } from "react";
import { Card } from '../../Components/ui/card';
import { Input } from '../../Components/ui/input';
import { Button } from '../../Components/ui/button';
import { Checkbox } from '../../Components/ui/checkbox';
import {
  User,
  Lock,
  Eye,
  EyeOff,
  Loader2,
  AlertCircle,
} from "lucide-react";
// import { ImageWithFallback } from "../figma/ImageWithFallback";

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

    if (!username.trim() || !password.trim()) {
      setError("Please enter both username and password");
      setIsLoading(false);
      return;
    }

    const normalizedUsername = username.toLowerCase().trim();
    let role = "student";

    if (normalizedUsername.includes("superadmin")) {
      role = "superadmin";
    } else if (
      normalizedUsername.includes("admin") ||
      normalizedUsername.includes("adviser")
    ) {
      role = "admin";
    } else if (
      normalizedUsername.includes("csg") ||
      normalizedUsername.includes("officer")
    ) {
      role = "csg-officer";
    }

    await new Promise((resolve) => setTimeout(resolve, 1000));

    if (onLogin) onLogin(role, username);
  };

  const handleGoogleLogin = () => {
    setError("");
    setIsLoading(true);

    setTimeout(() => {
      if (onLogin) onLogin("student");
    }, 1500);
  };

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      
      {/* LEFT SIDE */}
      <div className="hidden md:flex md:w-1/2 lg:w-2/5 bg-gradient-to-br from-[#5B21B6] via-[#6D28D9] to-[#7C3AED] p-12 flex-col justify-between relative overflow-hidden">
        <div className="absolute top-0 right-0 w-64 h-64 bg-white opacity-5 rounded-full -mr-32 -mt-32"></div>
        <div className="absolute bottom-0 left-0 w-96 h-96 bg-white opacity-5 rounded-full -ml-48 -mb-48"></div>

        <div className="relative z-10">
          <div className="mb-12">
            <h1 className="text-white text-3xl mb-2">Welcome to STEP</h1>
            <p className="text-purple-200 text-lg">
              Sign in with your school email
            </p>
          </div>

          <div className="space-y-6 mt-16">
            <h2 className="text-white text-4xl lg:text-5xl leading-tight">
              Transparent.<br />
              Accountable.<br />
              Trustworthy.
            </h2>
            <p className="text-purple-100 text-lg leading-relaxed max-w-md">
              Empowering students and organizations with financial transparency
              and collaborative decision-making.
            </p>
          </div>
        </div>

        {/* <div className="relative z-10 mt-8">
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 aspect-square">
              <ImageWithFallback
                src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=400&fit=crop"
                alt="Dashboard"
                className="w-full h-full object-cover rounded-xl"
              />
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 aspect-square">
              <ImageWithFallback
                src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=400&fit=crop"
                alt="Analytics"
                className="w-full h-full object-cover rounded-xl"
              />
            </div>
          </div>
        </div> */}
      </div>

      {/* RIGHT SIDE */}
      <div className="flex-1 flex items-center justify-center p-6 md:p-12 bg-gray-50">
        <Card className="w-full max-w-md p-8 md:p-10 rounded-[24px] shadow-sm border-0 bg-white">
          <div className="space-y-6">

            {/* Logo */}
            <div className="flex justify-center mb-6">
              <div className="relative">
                <div className="w-16 h-16 bg-gradient-to-br from-[#2563EB] to-[#3B82F6] rounded-2xl flex items-center justify-center rotate-12">
                  <span className="text-white text-2xl -rotate-12">S</span>
                </div>
                <div className="absolute -top-1 -right-1 w-6 h-6 bg-[#2563EB] rounded-lg"></div>
              </div>
            </div>

            <div className="text-center">
              <h2 className="text-gray-900 text-2xl mb-2">Login</h2>
            </div>

            {/* Google Button */}
            {/* <Button
              type="button"
              onClick={handleGoogleLogin}
              variant="outline"
              disabled={isLoading}
              className="w-full h-12 rounded-xl flex items-center justify-center gap-3"
            >
              Continue with Google
            </Button> */}
            <Button
  type="button"
  onClick={handleGoogleLogin}
  variant="outline"
  disabled={isLoading}
  className="w-full h-12 rounded-xl border-gray-300 hover:bg-gray-50 flex items-center justify-center gap-3"
>
  {/* Google Icon EA4335 4285F4 34A853*/}
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 48 48"
    width="20"
    height="20"
  >
    <path
      fill="#EA4335"
      d="M24 9.5c3.5 0 6.6 1.2 9 3.2l6.7-6.7C35.8 2.2 30.2 0 24 0 14.6 0 6.6 5.4 2.6 13.3l7.8 6C12.3 13 17.7 9.5 24 9.5z"
    />
    <path
      fill="#4285F4"
      d="M46.5 24.5c0-1.6-.1-3.1-.4-4.5H24v9h12.7c-.6 3-2.4 5.6-5 7.3l7.8 6C44.2 37.7 46.5 31.6 46.5 24.5z"
    />
    <path
      fill="#FBBC05"
      d="M10.4 28.3c-1-3-.9-6.2 0-9.2l-7.8-6C-1.5 18.4-1.5 29.6 2.6 34.9l7.8-6.6z"
    />
    <path
      fill="#34A853"
      d="M24 48c6.2 0 11.8-2 15.7-5.5l-7.8-6c-2.2 1.5-5 2.3-7.9 2.3-6.3 0-11.7-3.5-13.6-8.8l-7.8 6C6.6 42.6 14.6 48 24 48z"
    />
  </svg>

  <span className="text-gray-700 font-medium">
    Continue with Google
  </span>
</Button>

            {/* Divider */}
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300"></div>
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-4 bg-white text-gray-500">OR</span>
              </div>
            </div>

            {/* Error */}
            {error && (
              <div className="p-4 bg-red-50 border border-red-200 rounded-xl flex gap-3">
                <AlertCircle className="w-5 h-5 text-red-600 mt-0.5" />
                <p className="text-sm text-red-800">{error}</p>
              </div>
            )}

            {/* Form */}
            <form onSubmit={handleSubmit} className="space-y-4">

              <div className="space-y-2">
                <label className="text-sm text-gray-700">Username</label>
                <div className="relative">
                  <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <Input
                    type="text"
                    value={username}
                    onChange={(e) => {
                      setUsername(e.target.value);
                      setError("");
                    }}
                    className="pl-12 h-12 rounded-xl bg-gray-50"
                    disabled={isLoading}
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-sm text-gray-700">Password</label>
                <div className="relative">
                  <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                  <Input
                    type={showPassword ? "text" : "password"}
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value);
                      setError("");
                    }}
                    className="pl-12 pr-12 h-12 rounded-xl bg-gray-50"
                    disabled={isLoading}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400"
                  >
                    {showPassword ? (
                      <EyeOff className="w-5 h-5" />
                    ) : (
                      <Eye className="w-5 h-5" />
                    )}
                  </button>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <Checkbox
                  checked={rememberMe}
                  onCheckedChange={(checked) => setRememberMe(!!checked)}
                />
                <label className="text-sm text-gray-600">
                  Remember me
                </label>
              </div>

              <Button
                type="submit"
                disabled={isLoading}
                className="w-full h-12 bg-[#2563EB] hover:bg-[#1d4ed8] text-white rounded-xl"
              >
                {isLoading ? (
                  <>
                    <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                    Logging in...
                  </>
                ) : (
                  "Login"
                )}
              </Button>
            </form>

            <div className="text-center pt-2">
              <p className="text-sm text-gray-600">
                Don't have an account?{" "}
                <button
                  onClick={onNavigateToRegister}
                  className="text-[#2563EB] hover:underline"
                >
                  Sign up
                </button>
              </p>
            </div>

          </div>
        </Card>
      </div>
    </div>
  );
}