import { useState } from 'react';
import { Mail, Eye, EyeOff } from 'lucide-react';
import InputError from '@/Components/InputError';
import PrimaryButton from '@/Components/PrimaryButton';
import TextInput from '@/Components/TextInput';
import GuestLayout from '@/Layouts/GuestLayout';
import { Head, useForm, Link } from '@inertiajs/react';

export default function ForgotPassword({ status }) {
    const { data, setData, post, processing, errors } = useForm({
        email: '',
    });

    const [submitted, setSubmitted] = useState(false);

    const submit = (e) => {
        e.preventDefault();
        post(route('password.email'), {
            onSuccess: () => setSubmitted(true),
        });
    };

    return (
        <div className="min-h-screen flex">
            {/* LEFT PANEL */}
            <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
                <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
                <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

                <div className="relative z-10">
                    <h1 className="text-3xl font-medium mb-1">Forgot Password</h1>
                    <p className="text-lg">Reset your account password</p>

                    <div className="relative z-10 mt-10">
                        <h2 className="text-4xl font-semibold leading-tight">
                            Secure.<br />
                            Fast.<br />
                            Simple.
                        </h2>
                        <p className="text-white/80 max-w-md mt-4">
                            Enter your email and we'll send a secure link to reset your password.
                        </p>
                    </div>
                </div>
            </div>

            {/* RIGHT PANEL */}
            <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">
                <div className="w-full max-w-md bg-white rounded-2xl border border-gray-200 shadow-sm p-10">
                    <Head title="Forgot Password" />

                    <div className="flex justify-center mb-4">
                        <div className="w-20 overflow-hidden px-2">
                            <img src="/images/Logo.png" alt="Step Logo" className="w-full object-cover" />
                        </div>
                    </div>

                    <h2 className="text-center text-2xl text-gray-800 mb-6">Forgot your password?</h2>
                    <p className="text-center text-base text-gray-600 mb-6">Enter the email associated with your account and we'll send a password reset link.</p>

                    {status && (
                        <div className="mb-4 text-sm font-medium text-green-600 text-center">{status}</div>
                    )}

                    {submitted && !status && (
                        <div className="mb-4 text-sm font-medium text-green-600 text-center">If the email exists, a reset link has been sent.</div>
                    )}

                    <form onSubmit={submit} className="space-y-5">
                        <div>
                            <label className="block text-sm text-gray-600 mb-1">Email Address</label>
                            <div className="relative">
                                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                                <TextInput
                                    id="email"
                                    type="email"
                                    name="email"
                                    placeholder="name@kld.edu.ph"
                                    value={data.email}
                                    className="w-full h-10 pl-12 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:ring-2 focus:ring-gray-200 outline-none text-sm font-medium"
                                    onChange={(e) => setData('email', e.target.value)}
                                />
                            </div>
                            <InputError message={errors.email} className="mt-2" />
                        </div>

                        <div className="flex items-center justify-between">
                            <Link href={route('login')} className="text-sm text-blue-600 hover:underline">Back to login</Link>


                            <button
                                type="submit"
                                disabled={processing}
                                aria-busy={processing}
                                className={`w-full h-10 rounded-xl text-white font-medium transition ${processing ? 'opacity-60 cursor-not-allowed pointer-events-none' : ''}`}
                                style={{ background: 'linear-gradient(90deg, #2563EA 0%, #1E3A8A 100%)' }}
                            >
                                {processing ? 'Sending...' : 'Send Reset Link'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
}
