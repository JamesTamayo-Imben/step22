<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>403 — Forbidden</title>
    <!-- load Tailwind build used by the app -->
    @if(app()->environment('local'))
      @vite(['resources/css/app.css'])
    @else
      @vite(['resources/css/app.css'])
    @endif
  </head>

  <body class="min-h-screen bg-gray-100 font-sans">
    <div class="min-h-screen flex">
      <!-- Left illustrative panel (visible on md+) -->
      <div class="hidden md:flex w-2/5 bg-gradient-to-br from-[#155DFC] to-[#193CB8] text-white p-12 flex-col justify-center relative overflow-hidden">
        <div class="absolute -top-40 -right-40 w-72 h-72 bg-white/10 rounded-full"></div>
        <div class="absolute -bottom-40 -left-40 w-80 h-80 bg-white/10 rounded-full"></div>

        <div class="relative z-10">
          <h1 class="text-4xl font-semibold mb-2">Access Denied</h1>
          <p class="text-lg">You don’t have permission to view this page.</p>

          <p class="mt-8 text-white/80 max-w-md">If you believe this is an error, contact your system administrator or request access from the appropriate office.</p>
        </div>
      </div>

      <!-- Main content -->
      <div class="flex-1 flex items-center justify-center p-6">
        <div class="w-full max-w-2xl bg-white rounded-2xl border border-gray-200 shadow-sm p-10 text-center">
          <div class="mx-auto w-36 h-36 rounded-full bg-red-50 flex items-center justify-center mb-6">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-16 h-16 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>

          <h2 class="text-2xl font-semibold text-gray-900">403 — Forbidden</h2>
          <p class="text-sm text-gray-500 mt-2">Sorry — you don’t have access to this resource.</p>

          <div class="mt-6 flex flex-col sm:flex-row items-center justify-center gap-3">
            <a href="{{ url('/') }}" class="inline-flex items-center justify-center px-5 py-2.5 rounded-lg bg-[#2563EB] text-white text-sm hover:bg-[#1e4fd6] transition">Go to Home</a>
            <a href="mailto:admin@example.com" class="inline-flex items-center justify-center px-5 py-2.5 rounded-lg border border-gray-200 text-sm text-gray-700 hover:bg-gray-50 transition">Contact Support</a>
          </div>

          <p class="text-xs text-gray-400 mt-6">If you believe you should have access, include the URL and the steps you took when you contact support.</p>
        </div>
      </div>
    </div>
  </body>
</html>
