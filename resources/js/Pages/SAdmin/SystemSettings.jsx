import React, { useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
import {
  Save,
  Settings,
  Shield,
  Lock,
  Upload,
  Bell,
  Download,
  Scan,
  Smartphone,
  AlertCircle,
  CheckCircle,
} from 'lucide-react';

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

function ToggleSwitch({ checked, onChange, disabled = false }) {
  return (
    <button
      onClick={() => !disabled && onChange(!checked)}
      disabled={disabled}
      className={`relative inline-flex h-7 w-12 items-center rounded-full transition-colors ${
        checked ? 'bg-blue-600' : 'bg-gray-300'
      } ${disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
    >
      <span
        className={`inline-block h-5 w-5 transform rounded-full bg-white transition-transform ${
          checked ? 'translate-x-6' : 'translate-x-1'
        }`}
      />
    </button>
  );
}

function Textarea({ value, onChange, placeholder, rows = 4, className = '' }) {
  return (
    <textarea
      value={value}
      onChange={onChange}
      placeholder={placeholder}
      rows={rows}
      className={`w-full px-3 py-2 border border-gray-300 rounded-xl bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300 ${className}`}
    />
  );
}

export default function SystemSettingsPage() {
  const [activeTab, setActiveTab] = useState('general');
  const [settings, setSettings] = useState({
    // General
    systemName: 'STEP - School Transparency & Engagement Portal',
    primaryColor: '#2563EB',
    logoUrl: '',

    // Authentication
    allowedEmailDomains: '@kld.edu.ph',
    enableRegistration: true,
    requireEmailVerification: true,
    sessionTimeout: '30',

    // Ledger Rules
    immutableMode: true,
    allowLedgerCorrections: false,
    requiredApprovals: '1',

    // Upload Settings
    maxFileSize: '10',
    allowedFileTypes: 'PDF, JPG, PNG, DOCX',
    proofRetentionDays: '365',

    // Notifications
    enablePushNotifications: true,
    enableEmailNotifications: true,
    notificationRetentionDays: '90',
    emailTemplate: '',

    // PWA Settings
    enablePWA: true,
    enableOfflineMode: false,
    cacheStrategy: 'network-first',
  });

  const tabs = [
    { id: 'general', label: 'General', icon: Settings },
    { id: 'auth', label: 'Authentication', icon: Shield },
    { id: 'ledger', label: 'Ledger Rules', icon: Lock },
    { id: 'upload', label: 'Upload', icon: Upload },
    { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'pwa', label: 'PWA', icon: Smartphone },
  ];

  const handleSave = () => {
    showToast('Settings saved successfully', 'success');
  };

  const handleChange = (key, value) => {
    setSettings({ ...settings, [key]: value });
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">System Settings</h2>}>
      <Head title="System Settings" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">System Blockchain</h1>
                <p className="text-gray-500">Project Chain Monitoring</p>
              </div>
             <div className='flex gap-2'>
               <Button className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white w-full sm:w-auto">
                <Scan className="w-4 h-4 mr-2" />
                Scan The Chain
              </Button>
               <Button className="rounded-xl bg-white text-blue-600 border border-blue-200 rounded-xl hover:bg-blue-50 sm:w-auto">
                <Download className="w-4 h-4 mr-2" />
                Download Report 
              </Button>
             </div>
            </div>

            {/* Tabs */}
            <Card className="rounded-[20px] border-0 shadow-sm">

              <div className="p-6">
                HELLOOOOOOO WALA LANG PANG PA ASTIG LANG ULI
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

