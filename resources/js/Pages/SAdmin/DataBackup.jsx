import React, { useMemo, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge, Progress, Select, SelectItem, showToast } from './components/ui';
import {
  Database,
  Download,
  Upload,
  Calendar,
  HardDrive,
  FileArchive,
  CheckCircle,
  Clock,
  AlertCircle,
  RefreshCw,
} from 'lucide-react';

const mockBackups = [
  { id: 1, filename: 'step_backup_2024-11-20_full.sql.gz', date: '2024-11-20 03:00:00', size: '245 MB', status: 'Completed', type: 'Auto' },
  { id: 2, filename: 'step_backup_2024-11-19_full.sql.gz', date: '2024-11-19 03:00:00', size: '242 MB', status: 'Completed', type: 'Auto' },
  { id: 3, filename: 'step_backup_2024-11-18_manual.sql.gz', date: '2024-11-18 14:30:00', size: '240 MB', status: 'Completed', type: 'Manual' },
  { id: 4, filename: 'step_backup_2024-11-17_full.sql.gz', date: '2024-11-17 03:00:00', size: '238 MB', status: 'Completed', type: 'Auto' },
];

export default function DataBackupPage() {
  const [backups] = useState(mockBackups);
  const [backupSchedule, setBackupSchedule] = useState('daily');
  const [isBackingUp, setIsBackingUp] = useState(false);

  const storageData = useMemo(
    () => ({
      total: 1000,
      used: 325,
      proofUploads: 180,
      userData: 45,
      systemLogs: 80,
      backups: 20,
    }),
    []
  );

  const usagePercentage = (storageData.used / storageData.total) * 100;

  const handleCreateBackup = () => {
    setIsBackingUp(true);
    setTimeout(() => {
      setIsBackingUp(false);
      showToast('Backup created successfully', 'success');
    }, 1200);
  };

  const handleDownloadBackup = (backup) => showToast(`Downloading ${backup.filename}`, 'success');
  const handleRestoreBackup = (backup) => showToast(`Restoring from ${backup.filename}`, 'success');
  const handleExportData = (dataType) => showToast(`Exporting ${dataType} data...`, 'success');

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Completed':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'In Progress':
        return <Clock className="w-4 h-4 text-blue-600" />;
      case 'Failed':
        return <AlertCircle className="w-4 h-4 text-red-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Completed':
        return 'bg-green-100 text-green-700';
      case 'In Progress':
        return 'bg-blue-100 text-blue-700';
      case 'Failed':
        return 'bg-red-100 text-red-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Data & Backup</h2>}>
      <Head title="Data & Backup" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">Data & Backup Center</h1>
              <p className="text-gray-500">Manage backups, exports, and storage</p>
            </div>

            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex items-center justify-between mb-6 flex-col sm:flex-row gap-4">
                <div>
                  <h2 className="text-gray-900 font-semibold mb-1">Database Backup</h2>
                  <p className="text-sm text-gray-500">Create and schedule automatic backups</p>
                </div>
                <Button
                  onClick={handleCreateBackup}
                  disabled={isBackingUp}
                  className="text-white rounded-xl bg-blue-600 hover:bg-blue-700  lg:w-auto w-full"
                >
                  {isBackingUp ? (
                    <>
                      <RefreshCw className="w-4 h-4 mr-2 animate-spin" />
                      Creating...
                    </>
                  ) : (
                    <>
                      <Database className="w-4 h-4 mr-2" />
                      Create Backup Now
                    </>
                  )}
                </Button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                <Card className="rounded-xl p-4 bg-purple-50 border-0">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-purple-700">Total Backups</p>
                      <p className="text-2xl text-purple-900">{backups.length}</p>
                    </div>
                    <FileArchive className="w-8 h-8 text-purple-600" />
                  </div>
                </Card>

                <Card className="rounded-xl p-4 bg-green-50 border-0">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-green-700">Last Backup</p>
                      <p className="text-sm text-green-900">{backups[0]?.date.split(' ')[0] || 'N/A'}</p>
                    </div>
                    <CheckCircle className="w-8 h-8 text-green-600" />
                  </div>
                </Card>

                <Card className="rounded-xl p-4 bg-blue-50 border-0">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-blue-700">Next Scheduled</p>
                      <p className="text-sm text-blue-900">Tomorrow 3:00 AM</p>
                    </div>
                    <Calendar className="w-8 h-8 text-blue-600" />
                  </div>
                </Card>
              </div>

              <div className="flex items-center gap-4 p-4 bg-gray-50 rounded-xl flex-col sm:flex-row">
                <label className="text-sm text-gray-700 whitespace-nowrap">Backup Schedule:</label>
                <Select value={backupSchedule} onValueChange={setBackupSchedule} className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition">
                  <SelectItem value="hourly">Hourly</SelectItem>
                  <SelectItem value="daily">Daily (3:00 AM)</SelectItem>
                  <SelectItem value="weekly">Weekly (Sunday 3:00 AM)</SelectItem>
                  <SelectItem value="monthly">Monthly (1st of month)</SelectItem>
                </Select>
              </div>
            </Card>

            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-gray-900 font-semibold mb-6">Backup History</h2>
              <div className="space-y-3">
                {backups.map((backup) => (
                  <div
                    key={backup.id}
                    className="flex flex-col md:flex-row md:items-center justify-between gap-4 p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors"
                  >
                    <div className="flex items-start gap-4">
                      <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center flex-shrink-0">
                        {getStatusIcon(backup.status)}
                      </div>
                      <div>
                        <p className="text-sm text-gray-900 mb-1">{backup.filename}</p>
                        <div className="flex items-center gap-3 text-xs text-gray-500 flex-wrap">
                          <span>{backup.date}</span>
                          <span>•</span>
                          <span>{backup.size}</span>
                          <span>•</span>
                          <Badge className={backup.type === 'Auto' ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'}>
                            {backup.type}
                          </Badge>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 flex-wrap flex-col sm:flex-row sm:justify-end">
                      <Badge className={getStatusColor(backup.status)}>{backup.status}</Badge>
                      <Button size="sm" variant="outline" onClick={() => handleDownloadBackup(backup)} className="rounded-lg lg:w-auto w-full">
                        <Download className="w-4 h-4 mr-1" />
                        Download
                      </Button>
                      <Button size="sm" variant="outline" onClick={() => handleRestoreBackup(backup)} className="rounded-lg lg:w-auto w-full">
                        <Upload className="w-4 h-4 mr-1" />
                        Restore
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </Card>

            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-gray-900 font-semibold mb-6">Data Export</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {[
                  { key: 'users', title: 'User Data', desc: 'Export all user accounts and profiles', label: 'Export as CSV' },
                  { key: 'projects', title: 'Projects', desc: 'Export all project data and details', label: 'Export as CSV' },
                  { key: 'ledger', title: 'Ledger Entries', desc: 'Export financial transactions', label: 'Export as CSV' },
                  { key: 'proofs', title: 'Proof Documents', desc: 'Download all uploaded proofs', label: 'Export as ZIP' },
                ].map((x) => (
                  <div key={x.key} className="p-4 border border-gray-200 rounded-xl hover:border-purple-300 transition-colors">
                    <h3 className="text-gray-900 font-semibold mb-2">{x.title}</h3>
                    <p className="text-sm text-gray-600 mb-4">{x.desc}</p>
                    <Button variant="outline" onClick={() => handleExportData(x.key)} className="w-full rounded-xl">
                      <Download className="w-4 h-4 mr-2" />
                      {x.label}
                    </Button>
                  </div>
                ))}
              </div>
            </Card>

            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-gray-900 font-semibold mb-6">Storage Analysis</h2>
              <div className="space-y-6">
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                      <HardDrive className="w-5 h-5 text-blue-600" />
                      <span className="text-sm text-gray-700">Total Storage Usage</span>
                    </div>
                    <span className="text-sm text-gray-900">
                      {storageData.used}GB / {storageData.total}GB
                    </span>
                  </div>
                  <Progress value={usagePercentage} className="h-3 mb-2" />
                  <p className="text-xs text-gray-500">{usagePercentage.toFixed(1)}% used</p>
                </div>

                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  {[
                    { key: 'proofUploads', title: 'Proof Uploads', bg: 'bg-blue-50', t1: 'text-blue-700', t2: 'text-blue-900', t3: 'text-blue-600' },
                    { key: 'userData', title: 'User Data', bg: 'bg-green-50', t1: 'text-green-700', t2: 'text-green-900', t3: 'text-green-600' },
                    { key: 'systemLogs', title: 'System Logs', bg: 'bg-yellow-50', t1: 'text-yellow-700', t2: 'text-yellow-900', t3: 'text-yellow-600' },
                    { key: 'backups', title: 'Backups', bg: 'bg-purple-50', t1: 'text-purple-700', t2: 'text-purple-900', t3: 'text-purple-600' },
                  ].map((c) => {
                    const v = storageData[c.key];
                    return (
                      <div key={c.key} className={`p-4 ${c.bg} rounded-xl`}>
                        <p className={`text-xs ${c.t1} mb-1`}>{c.title}</p>
                        <p className={`text-xl ${c.t2}`}>{v}GB</p>
                        <p className={`text-xs ${c.t3} mt-1`}>{((v / storageData.used) * 100).toFixed(0)}% of total</p>
                      </div>
                    );
                  })}
                </div>
              </div>
            </Card>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

