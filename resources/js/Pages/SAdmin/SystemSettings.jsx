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
                <h1 className="text-2xl font-semibold text-gray-900">System Settings</h1>
                <p className="text-gray-500">Configure platform-wide settings</p>
              </div>
              <Button onClick={handleSave} className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white w-full sm:w-auto">
                <Save className="w-4 h-4 mr-2" />
                Save All Changes
              </Button>
            </div>

            {/* Tabs */}
            <Card className="rounded-[20px] border-0 shadow-sm">
              <div className="flex overflow-x-auto border-b border-gray-200">
                {tabs.map((tab) => {
                  const Icon = tab.icon;
                  const isActive = activeTab === tab.id;
                  return (
                    <button
                      key={tab.id}
                      onClick={() => setActiveTab(tab.id)}
                      className={`flex items-center gap-2 px-4 py-4 border-b-2 transition-all whitespace-nowrap ${
                        isActive
                          ? 'border-blue-600 text-blue-600'
                          : 'border-transparent text-gray-600 hover:text-gray-900'
                      }`}
                    >
                      <Icon className="w-4 h-4" />
                      <span className="text-sm font-medium">{tab.label}</span>
                    </button>
                  );
                })}
              </div>

              <div className="p-6">
                {/* General Settings */}
                {activeTab === 'general' && (
                  <div className="space-y-6">
                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">System Name</label>
                      <Input
                        value={settings.systemName}
                        onChange={(e) => handleChange('systemName', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Displayed in navigation and page titles</p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Primary Brand Color</label>
                      <div className="flex items-center gap-4">
                        <Input
                          type="color"
                          value={settings.primaryColor}
                          onChange={(e) => handleChange('primaryColor', e.target.value)}
                          className="w-16 h-10 rounded-xl cursor-pointer border border-gray-300"
                        />
                        <Input
                          value={settings.primaryColor}
                          onChange={(e) => handleChange('primaryColor', e.target.value)}
                          className="flex-1 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                        />
                      </div>
                      <p className="text-xs text-gray-500 mt-1">Used for buttons, links, and accents</p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Logo URL</label>
                      <Input
                        placeholder="https://example.com/logo.png"
                        value={settings.logoUrl}
                        onChange={(e) => handleChange('logoUrl', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">URL to your organization logo</p>
                    </div>
                  </div>
                )}

                {/* Authentication Settings */}
                {activeTab === 'auth' && (
                  <div className="space-y-6">
                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Allowed Email Domains</label>
                      <Input
                        placeholder="@university.edu, @students.edu"
                        value={settings.allowedEmailDomains}
                        onChange={(e) => handleChange('allowedEmailDomains', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Comma-separated list of allowed email domains</p>
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Enable User Registration</p>
                        <p className="text-xs text-gray-500 mt-1">Allow new users to create accounts</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.enableRegistration}
                        onChange={(checked) => handleChange('enableRegistration', checked)}
                      />
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Require Email Verification</p>
                        <p className="text-xs text-gray-500 mt-1">Users must verify email before accessing system</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.requireEmailVerification}
                        onChange={(checked) => handleChange('requireEmailVerification', checked)}
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Session Timeout (minutes)</label>
                      <Input
                        type="number"
                        value={settings.sessionTimeout}
                        onChange={(e) => handleChange('sessionTimeout', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Auto-logout after inactivity period</p>
                    </div>
                  </div>
                )}

                {/* Ledger Rules */}
                {activeTab === 'ledger' && (
                  <div className="space-y-6">
                    <div className="p-4 bg-blue-50 rounded-xl border-2 border-blue-200">
                      <div className="flex items-start gap-3">
                        <Lock className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                        <div>
                          <p className="text-sm font-semibold text-blue-900">Immutable Ledger Mode: ENABLED</p>
                          <p className="text-xs text-blue-700 mt-1">
                            This setting is permanently enabled to ensure financial transparency and accountability. Once a ledger entry is approved, it cannot be modified or deleted.
                          </p>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-100 rounded-xl opacity-50">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Immutable Mode</p>
                        <p className="text-xs text-gray-500 mt-1">Cannot be disabled for CSG compliance</p>
                      </div>
                      <ToggleSwitch checked={settings.immutableMode} onChange={() => {}} disabled={true} />
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Allow Correction Entries</p>
                        <p className="text-xs text-gray-500 mt-1">Permit reversing entries for approved transactions</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.allowLedgerCorrections}
                        onChange={(checked) => handleChange('allowLedgerCorrections', checked)}
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Required Approvals per Entry</label>
                      <Input
                        type="number"
                        min="1"
                        max="3"
                        value={settings.requiredApprovals}
                        onChange={(e) => handleChange('requiredApprovals', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Number of adviser approvals required</p>
                    </div>
                  </div>
                )}

                {/* Upload Settings */}
                {activeTab === 'upload' && (
                  <div className="space-y-6">
                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Maximum File Size (MB)</label>
                      <Input
                        type="number"
                        value={settings.maxFileSize}
                        onChange={(e) => handleChange('maxFileSize', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Maximum allowed file size for uploads</p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Allowed File Types</label>
                      <Input
                        placeholder="PDF, JPG, PNG, DOCX"
                        value={settings.allowedFileTypes}
                        onChange={(e) => handleChange('allowedFileTypes', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Comma-separated list of allowed file extensions</p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Proof Document Retention (days)</label>
                      <Input
                        type="number"
                        value={settings.proofRetentionDays}
                        onChange={(e) => handleChange('proofRetentionDays', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">How long to keep archived proof documents</p>
                    </div>

                    <div className="p-4 bg-blue-50 rounded-xl border border-blue-200">
                      <div className="flex items-start gap-3">
                        <AlertCircle className="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" />
                        <div>
                          <p className="text-sm text-blue-900">
                            All uploaded files are hashed using SHA-256 for verification and integrity checking.
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* Notification Settings */}
                {activeTab === 'notifications' && (
                  <div className="space-y-6">
                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Enable Push Notifications</p>
                        <p className="text-xs text-gray-500 mt-1">Real-time browser notifications</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.enablePushNotifications}
                        onChange={(checked) => handleChange('enablePushNotifications', checked)}
                      />
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Enable Email Notifications</p>
                        <p className="text-xs text-gray-500 mt-1">Send notifications via email</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.enableEmailNotifications}
                        onChange={(checked) => handleChange('enableEmailNotifications', checked)}
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Notification Retention (days)</label>
                      <Input
                        type="number"
                        value={settings.notificationRetentionDays}
                        onChange={(e) => handleChange('notificationRetentionDays', e.target.value)}
                        className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      />
                      <p className="text-xs text-gray-500 mt-1">Auto-delete old notifications after this period</p>
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Email Template Customization</label>
                      <Textarea
                        value={settings.emailTemplate}
                        onChange={(e) => handleChange('emailTemplate', e.target.value)}
                        placeholder="Customize email notification templates..."
                        rows={4}
                      />
                      <p className="text-xs text-gray-500 mt-1">HTML template for email notifications</p>
                    </div>
                  </div>
                )}

                {/* PWA Settings */}
                {activeTab === 'pwa' && (
                  <div className="space-y-6">
                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Enable PWA Features</p>
                        <p className="text-xs text-gray-500 mt-1">Allow installation as mobile app</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.enablePWA}
                        onChange={(checked) => handleChange('enablePWA', checked)}
                      />
                    </div>

                    <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                      <div>
                        <p className="text-sm font-medium text-gray-900">Enable Offline Mode</p>
                        <p className="text-xs text-gray-500 mt-1">Cache data for offline access</p>
                      </div>
                      <ToggleSwitch
                        checked={settings.enableOfflineMode}
                        onChange={(checked) => handleChange('enableOfflineMode', checked)}
                      />
                    </div>

                    <div>
                      <label className="block text-sm font-medium text-gray-900 mb-2">Cache Strategy</label>
                      <select
                        value={settings.cacheStrategy}
                        onChange={(e) => handleChange('cacheStrategy', e.target.value)}
                        className="w-full px-3 py-2 h-10 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                      >
                        <option value="network-first">Network First</option>
                        <option value="cache-first">Cache First</option>
                        <option value="network-only">Network Only</option>
                        <option value="cache-only">Cache Only</option>
                      </select>
                      <p className="text-xs text-gray-500 mt-1">How the service worker handles requests</p>
                    </div>
                  </div>
                )}
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

