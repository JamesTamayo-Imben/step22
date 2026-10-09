import React, { useEffect, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Check, Palette } from 'lucide-react';

const COLOR_THEMES = [
  {
    id: 'system',
    title: 'System colors',
    description: 'Use STEP’s standard blue color palette.',
    primary: '#2563EB',
    secondary: '#1D4ED8',
  },
  {
    id: 'kld',
    title: 'KLD colors',
    description: 'Use a KLD green color palette.',
    primary: '#166534',
    secondary: '#14532D',
  },
];

export default function SettingsPage() {
  const { globalColorTheme = 'system' } = usePage().props;
  const [theme, setTheme] = useState(globalColorTheme);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    setTheme(globalColorTheme);
    document.documentElement.dataset.sadminTheme = globalColorTheme;
  }, [globalColorTheme]);

  useEffect(() => {
    const handleThemeSync = (event) => setTheme(event.detail?.theme === 'kld' ? 'kld' : 'system');
    window.addEventListener('step:global-theme-change', handleThemeSync);
    return () => window.removeEventListener('step:global-theme-change', handleThemeSync);
  }, []);

  const selectTheme = (nextTheme) => {
    const previousTheme = theme;
    setTheme(nextTheme);
    document.documentElement.dataset.sadminTheme = nextTheme;
    setIsSaving(true);
    router.post(route('sadmin.preferences.theme.update'), { theme: nextTheme }, {
      preserveScroll: true,
      onError: () => {
        setTheme(previousTheme);
        document.documentElement.dataset.sadminTheme = previousTheme;
      },
      onFinish: () => setIsSaving(false),
    });
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Settings</h2>}>
      <Head title="Settings" />
      <div className="px-4 py-8 md:px-0 lg:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl font-semibold text-gray-900">Settings</h1>
              <p className="text-gray-500">Choose the color palette used across the entire system.</p>
            </div>

            <Card className="rounded-[20px] border-0 bg-white p-6 shadow-sm">
              <div className="mb-5 flex items-start gap-3">
                <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-blue-50 text-blue-600">
                  <Palette className="h-5 w-5" aria-hidden="true" />
                </span>
                <div>
                  <h2 className="font-semibold text-gray-900">System color</h2>
                  <p className="mt-1 text-sm text-gray-500">Choose the color palette used across all pages in the system.</p>
                </div>
              </div>

              <div className="grid gap-3 sm:grid-cols-2" role="radiogroup" aria-label="System color palette">
                {COLOR_THEMES.map((option) => {
                  const isSelected = theme === option.id;
                  return (
                    <button
                      key={option.id}
                      type="button"
                      role="radio"
                      aria-checked={isSelected}
                      onClick={() => selectTheme(option.id)}
                      className={`rounded-xl border p-4 text-left transition focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 ${
                        isSelected ? 'border-blue-600 bg-blue-50/50' : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                      }`}
                    >
                      <span className="flex items-center justify-between gap-3">
                        <span className="font-medium text-gray-900">{option.title}</span>
                        {isSelected && <Check className="h-5 w-5 text-blue-600" aria-label="Selected" />}
                      </span>
                      <span className="mt-1 block text-sm text-gray-500">{option.description}</span>
                      <span className="mt-4 flex items-center gap-2" aria-hidden="true">
                        <span className="h-7 w-7 rounded-full border border-black/5" style={{ backgroundColor: option.primary }} />
                        <span className="h-7 w-7 rounded-full border border-black/5" style={{ backgroundColor: option.secondary }} />
                        <span className="ml-1 text-xs text-gray-500">Palette preview</span>
                      </span>
                    </button>
                  );
                })}
              </div>
              <p className="mt-4 text-xs text-gray-500" role="status">
                {isSaving ? 'Saving system-wide preference…' : 'This preference is shared with all users and devices.'}
              </p>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
