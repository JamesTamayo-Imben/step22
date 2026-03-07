import { Head, Link, useForm } from "@inertiajs/react";
import { CheckCircle, Mail } from "lucide-react";
import PrimaryButton from '@/Components/PrimaryButton';

export default function VerifyEmail({ status }) {
  const { post, processing } = useForm({});

  const submit = (e) => {
    e.preventDefault();
    post(route("verification.send"));
  };

  return (
    <div className="min-h-screen flex">

      {/* LEFT PANEL */}
      <div className="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-between relative overflow-hidden">
        <div className="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div className="relative z-10">
          <h1 className="text-3xl font-medium mb-1">Email Verification</h1>
          <p className="text-lg">Please verify your account</p>

          <div className="relative z-10 mt-10">
            <h2 className="text-4xl font-semibold leading-tight">
              Secure.<br />
              Verified.<br />
              Trusted.
            </h2>
            <p className="text-white/80 max-w-md mt-4">
              Check your inbox for the verification link. If you didn't receive it, you can request another one below.
            </p>
          </div>
        </div>
      </div>

      {/* RIGHT PANEL */}
      <div className="flex-1 flex items-center justify-center bg-[#F5F6F8] p-6">
        <div className="w-full max-w-md bg-white rounded-2xl border border-gray-200 shadow-sm p-8 md:p-10 text-center">

          <Head title="Email Verification" />

          <div className="space-y-6">

            {/* Icon */}
            <div className="flex justify-center">
              <div className="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center">
                <Mail className="w-10 h-10 text-blue-600" />
              </div>
            </div>

            {/* Title */}
            <div className="space-y-2">
              <h2 className="text-2xl font-semibold text-gray-900">Verify Your Email</h2>
              <p className="text-sm text-gray-500">Thanks for signing up! Please check your inbox and click the verification link to activate your account.</p>
            </div>

            {/* Success Message */}
            {status === "verification-link-sent" && (
              <div className="flex items-center gap-2 justify-center bg-green-50 text-green-600 text-sm p-3 rounded-lg">
                <CheckCircle className="w-4 h-4" />
                A new verification link has been sent.
              </div>
            )}

            {/* Actions */}
            <form onSubmit={submit} className="space-y-4">

              <PrimaryButton type="submit" disabled={processing} className="w-full h-11">
                {processing ? "Sending..." : "Resend Verification Email"}
              </PrimaryButton>

              <Link
                href={route("logout")}
                method="post"
                as="button"
                className="w-full text-sm text-gray-600 hover:underline"
              >
                Log Out
              </Link>

            </form>

          </div>
        </div>
      </div>
    </div>
  );
}