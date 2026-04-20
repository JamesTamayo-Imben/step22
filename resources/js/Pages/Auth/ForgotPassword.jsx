import { useState } from 'react';
import { Mail, Lock, Eye, EyeOff, ArrowLeft } from 'lucide-react';
import InputError from '@/Components/InputError';
import TextInput from '@/Components/TextInput';
import { Head, Link } from '@inertiajs/react';

export default function ForgotPassword({ status }) {
    // Step 1: Email submission
    const [step, setStep] = useState(1);
    const [email, setEmail] = useState('');
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    // Step 2: OTP verification
    const [otp, setOtp] = useState('');
    const [otpError, setOtpError] = useState('');
    const [resendCooldown, setResendCooldown] = useState(0);

    // Step 3: New password
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [showPassword, setShowPassword] = useState(false);
    const [passwordError, setPasswordError] = useState('');

    // Handle Step 1: Send OTP to email
    const handleSendOTP = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');
        setLoading(true);

        if (!email) {
            setError('Please enter your email address');
            setLoading(false);
            return;
        }

        try {
            const response = await fetch('/api/password-reset/send-otp', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
                },
                body: JSON.stringify({ email }),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Failed to send OTP');
            }

            setSuccess('OTP code sent to your email!');
            setStep(2);
            setOtp('');
        } catch (err) {
            setError(err.message || 'An error occurred');
        } finally {
            setLoading(false);
        }
    };

    // Handle Step 2: Verify OTP
    const handleVerifyOTP = async (e) => {
        e.preventDefault();
        setOtpError('');
        setLoading(true);

        if (!otp || otp.length < 6) {
            setOtpError('Please enter a valid 6-digit code');
            setLoading(false);
            return;
        }

        try {
            const response = await fetch('/api/password-reset/verify-otp', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
                },
                body: JSON.stringify({ email, otp }),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Invalid OTP code');
            }

            setSuccess('OTP verified! Now set your new password');
            setStep(3);
        } catch (err) {
            setOtpError(err.message || 'Failed to verify OTP');
        } finally {
            setLoading(false);
        }
    };

    // Handle Step 3: Set new password
    const handleResetPassword = async (e) => {
        e.preventDefault();
        setPasswordError('');
        setLoading(true);

        if (!newPassword || !confirmPassword) {
            setPasswordError('Please fill in all password fields');
            setLoading(false);
            return;
        }

        if (newPassword.length < 8) {
            setPasswordError('Password must be at least 8 characters');
            setLoading(false);
            return;
        }

        if (newPassword !== confirmPassword) {
            setPasswordError('Passwords do not match');
            setLoading(false);
            return;
        }

        try {
            const response = await fetch('/api/password-reset/reset', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
                },
                body: JSON.stringify({ email, otp, password: newPassword }),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Failed to reset password');
            }

            setSuccess('Password reset successfully! Redirecting to login...');
            setTimeout(() => {
                window.location.href = route('login');
            }, 2000);
        } catch (err) {
            setPasswordError(err.message || 'An error occurred');
        } finally {
            setLoading(false);
        }
    };

    // Resend OTP
    const handleResendOTP = async () => {
        if (resendCooldown > 0) return;
        
        setOtpError('');
        setLoading(true);

        try {
            const response = await fetch('/api/password-reset/send-otp', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content,
                },
                body: JSON.stringify({ email }),
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.message || 'Failed to resend OTP');
            }

            setSuccess('New OTP sent to your email!');
            setResendCooldown(60);
            setOtp('');

            // Countdown timer
            const timer = setInterval(() => {
                setResendCooldown(prev => {
                    if (prev <= 1) {
                        clearInterval(timer);
                        return 0;
                    }
                    return prev - 1;
                });
            }, 1000);
        } catch (err) {
            setOtpError(err.message || 'Failed to resend OTP');
        } finally {
            setLoading(false);
        }
    };

    // Go back to previous step
    const handleBack = () => {
        if (step > 1) {
            setError('');
            setSuccess('');
            setOtpError('');
            setPasswordError('');
            setStep(step - 1);
        }
    };

    return (
        <div className="min-h-screen flex">
            <Head title="Reset Password" />

            {/* LEFT PANEL */}
            <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
                <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
                <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

                <div className="relative z-10">
                    <h1 className="text-3xl font-medium mb-1">
                        {step === 1 ? 'Forgot Password' : step === 2 ? 'Verify Email' : 'New Password'}
                    </h1>
                    <p className="text-lg">Reset your account password securely</p>

                    <div className="relative z-10 mt-10">
                        <h2 className="text-4xl font-semibold leading-tight">
                            Secure.<br />
                            Fast.<br />
                            Simple.
                        </h2>
                        <p className="text-white/80 max-w-md mt-4">
                            {step === 1 && 'Enter your email and we\'ll send a verification code to your inbox.'}
                            {step === 2 && 'Enter the code sent to your email to verify your identity.'}
                            {step === 3 && 'Set a strong new password for your account.'}
                        </p>
                    </div>

                    {/* Progress Indicator */}
                    <div className="mt-12 flex gap-2">
                        {[1, 2, 3].map((s) => (
                            <div
                                key={s}
                                className={`h-1 flex-1 rounded-full transition ${
                                    s <= step ? 'bg-white' : 'bg-white/30'
                                }`}
                            ></div>
                        ))}
                    </div>
                </div>
            </div>

            {/* RIGHT PANEL */}
            <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">
                <div className="w-full max-w-md bg-white rounded-2xl border border-gray-200 shadow-sm p-10">
                    <div className="flex justify-center mb-6">
                        <div className="w-20 overflow-hidden px-2">
                            <img src="/images/Logo.png" alt="Step Logo" className="w-full object-cover" />
                        </div>
                    </div>

                    {/* STEP 1: Enter Email */}
                    {step === 1 && (
                        <>
                            <h2 className="text-center text-2xl text-gray-800 mb-2">Reset Password</h2>
                            <p className="text-center text-sm text-gray-600 mb-6">
                                Enter your email address and we'll send you a verification code
                            </p>

                            {error && (
                                <div className="mb-4 p-3 bg-red-50 border border-red-200 text-sm text-red-600 rounded-lg">
                                    {error}
                                </div>
                            )}

                            <form onSubmit={handleSendOTP} className="space-y-5">
                                <div>
                                    <label className="block text-sm text-gray-600 mb-1">Email Address</label>
                                    <div className="relative">
                                        <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                                        <input
                                            type="email"
                                            placeholder="name@kld.edu.ph"
                                            value={email}
                                            onChange={(e) => setEmail(e.target.value)}
                                            className="w-full h-10 pl-12 pr-4 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-blue-200 outline-none text-sm font-medium"
                                        />
                                    </div>
                                </div>

                                <button
                                    type="submit"
                                    disabled={loading}
                                    className={`w-full h-10 rounded-xl text-white font-medium transition ${loading ? 'opacity-60 cursor-not-allowed' : ''}`}
                                    style={{ background: 'linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)' }}
                                >
                                    {loading ? 'Sending...' : 'Send Verification Code'}
                                </button>
                            </form>

                            <div className="mt-6 text-center">
                                <Link href={route('login')} className="text-sm text-blue-600 hover:underline">
                                    Back to login
                                </Link>
                            </div>
                        </>
                    )}

                    {/* STEP 2: Verify OTP */}
                    {step === 2 && (
                        <>
                            <h2 className="text-center text-2xl text-gray-800 mb-2">Verify Your Email</h2>
                            <p className="text-center text-sm text-gray-600 mb-6">
                                We've sent a 6-digit code to <strong>{email}</strong>
                            </p>

                            {otpError && (
                                <div className="mb-4 p-3 bg-red-50 border border-red-200 text-sm text-red-600 rounded-lg">
                                    {otpError}
                                </div>
                            )}

                            {success && (
                                <div className="mb-4 p-3 bg-green-50 border border-green-200 text-sm text-green-600 rounded-lg">
                                    {success}
                                </div>
                            )}

                            <form onSubmit={handleVerifyOTP} className="space-y-5">
                                <div>
                                    <label className="block text-sm text-gray-600 mb-2">Verification Code</label>
                                    <div className="flex gap-2 justify-center">
                                        {[...Array(6)].map((_, i) => (
                                            <input
                                                key={i}
                                                type="text"
                                                maxLength="1"
                                                value={otp[i] || ''}
                                                onChange={(e) => {
                                                    const value = e.target.value;
                                                    if (/^[0-9]?$/.test(value)) {
                                                        const newOtp = otp.split('');
                                                        newOtp[i] = value;
                                                        setOtp(newOtp.join(''));
                                                        
                                                        // Auto focus next input
                                                        if (value && i < 5) {
                                                            e.target.nextSibling?.focus?.();
                                                        }
                                                    }
                                                }}
                                                className="w-12 h-12 text-center text-lg font-bold border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none"
                                            />
                                        ))}
                                    </div>
                                </div>

                                <button
                                    type="submit"
                                    disabled={loading || otp.length < 6}
                                    className={`w-full h-10 rounded-xl text-white font-medium transition ${
                                        loading || otp.length < 6 ? 'opacity-60 cursor-not-allowed' : ''
                                    }`}
                                    style={{ background: 'linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)' }}
                                >
                                    {loading ? 'Verifying...' : 'Verify Code'}
                                </button>
                            </form>

                            <div className="mt-6 space-y-3 text-center">
                                <p className="text-sm text-gray-600">
                                    Didn't receive the code?{' '}
                                    <button
                                        type="button"
                                        onClick={handleResendOTP}
                                        disabled={resendCooldown > 0}
                                        className={`text-blue-600 hover:text-blue-700 font-medium ${
                                            resendCooldown > 0 ? 'opacity-50 cursor-not-allowed' : ''
                                        }`}
                                    >
                                        {resendCooldown > 0 ? `Resend in ${resendCooldown}s` : 'Resend Code'}
                                    </button>
                                </p>

                                <button
                                    type="button"
                                    onClick={handleBack}
                                    className="text-sm text-gray-600 hover:text-gray-800 flex items-center justify-center gap-1 w-full"
                                >
                                    <ArrowLeft size={16} /> Back to email
                                </button>
                            </div>
                        </>
                    )}

                    {/* STEP 3: Set New Password */}
                    {step === 3 && (
                        <>
                            <h2 className="text-center text-2xl text-gray-800 mb-2">Create New Password</h2>
                            <p className="text-center text-sm text-gray-600 mb-6">
                                Enter a strong password for your account
                            </p>

                            {passwordError && (
                                <div className="mb-4 p-3 bg-red-50 border border-red-200 text-sm text-red-600 rounded-lg">
                                    {passwordError}
                                </div>
                            )}

                            <form onSubmit={handleResetPassword} className="space-y-4">
                                <div>
                                    <label className="block text-sm text-gray-600 mb-1">New Password</label>
                                    <div className="relative">
                                        <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                                        <input
                                            type={showPassword ? 'text' : 'password'}
                                            placeholder="Enter new password"
                                            value={newPassword}
                                            onChange={(e) => setNewPassword(e.target.value)}
                                            className="w-full h-10 pl-12 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-blue-200 outline-none text-sm font-medium"
                                        />
                                        <button
                                            type="button"
                                            onClick={() => setShowPassword(!showPassword)}
                                            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400"
                                        >
                                            {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                                        </button>
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-sm text-gray-600 mb-1">Confirm Password</label>
                                    <div className="relative">
                                        <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                                        <input
                                            type={showPassword ? 'text' : 'password'}
                                            placeholder="Confirm new password"
                                            value={confirmPassword}
                                            onChange={(e) => setConfirmPassword(e.target.value)}
                                            className="w-full h-10 pl-12 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-blue-200 outline-none text-sm font-medium"
                                        />
                                    </div>
                                </div>

                                <div className="bg-blue-50 border border-blue-200 rounded-lg p-3 text-xs text-blue-700">
                                    ✓ Password must be at least 8 characters long
                                </div>

                                <button
                                    type="submit"
                                    disabled={loading}
                                    className={`w-full h-10 rounded-xl text-white font-medium transition ${loading ? 'opacity-60 cursor-not-allowed' : ''}`}
                                    style={{ background: 'linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)' }}
                                >
                                    {loading ? 'Resetting...' : 'Reset Password'}
                                </button>
                            </form>

                            <button
                                type="button"
                                onClick={handleBack}
                                className="mt-6 text-sm text-gray-600 hover:text-gray-800 flex items-center justify-center gap-1 w-full"
                            >
                                <ArrowLeft size={16} /> Back to verification
                            </button>
                        </>
                    )}
                </div>
            </div>
        </div>
    );
}
