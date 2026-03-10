import React, { useMemo, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge, Switch, showToast } from './components/ui';
import { RotateCcw, Save, Shield } from 'lucide-react';

const permissionModules = [
  { id: 'projects', module: 'Projects', actions: ['view', 'create', 'edit', 'delete', 'approve', 'rate'] },
  { id: 'ledger', module: 'Ledger', actions: ['view', 'create', 'edit', 'delete', 'approve', 'submit'] },
  { id: 'proof', module: 'Proof Documents', actions: ['view', 'upload', 'delete', 'approve', 'validate'] },
  { id: 'meetings', module: 'Meetings', actions: ['view', 'create', 'edit', 'delete', 'upload_minutes', 'approve_minutes'] },
  { id: 'ratings', module: 'Ratings', actions: ['view', 'submit', 'moderate', 'analytics'] },
  { id: 'notifications', module: 'Notifications', actions: ['view', 'send', 'manage'] },
  { id: 'users', module: 'User Management', actions: ['view', 'create', 'edit', 'suspend', 'delete'] },
  { id: 'organizations', module: 'Organizations', actions: ['view', 'create', 'edit', 'archive'] },
  { id: 'system', module: 'System Settings', actions: ['view', 'configure', 'backup', 'logs'] },
];

const defaultRoles = [
  { id: 'superadmin', name: 'Superadmin', description: 'Full system access with all permissions', color: 'bg-purple-100 text-purple-700' },
  { id: 'admin', name: 'Admin/Adviser', description: 'Oversight and approvals', color: 'bg-blue-100 text-blue-700' },
  { id: 'csg', name: 'CSG Officer', description: 'Organization operations and submissions', color: 'bg-green-100 text-green-700' },
  { id: 'student', name: 'Student', description: 'View, rate, and engage', color: 'bg-gray-100 text-gray-700' },
];

function makeDefaultPermissions() {
  const perms = {};
  for (const m of permissionModules) for (const a of m.actions) perms[`${m.id}.${a}`] = false;
  // reasonable defaults
  for (const k of Object.keys(perms)) {
    if (k.startsWith('projects.view') || k.startsWith('ratings.view') || k.startsWith('notifications.view')) perms[k] = true;
  }
  return perms;
}

export default function RolesPermissionsPage() {
  const [selectedRoleId, setSelectedRoleId] = useState('superadmin');
  const [rolePermissions, setRolePermissions] = useState(() => {
    const base = makeDefaultPermissions();
    return {
      superadmin: Object.fromEntries(Object.keys(base).map((k) => [k, true])),
      admin: { ...base, 'projects.view': true, 'projects.approve': true, 'ledger.view': true, 'ledger.approve': true, 'users.view': true },
      csg: { ...base, 'projects.view': true, 'projects.create': true, 'ledger.view': true, 'ledger.create': true, 'proof.upload': true },
      student: { ...base, 'projects.view': true, 'ratings.view': true, 'ratings.submit': true },
    };
  });

  const selectedRole = useMemo(() => defaultRoles.find((r) => r.id === selectedRoleId) || defaultRoles[0], [selectedRoleId]);
  const selectedPerms = rolePermissions[selectedRoleId] || {};

  const setPerm = (permKey, value) => {
    setRolePermissions((prev) => ({
      ...prev,
      [selectedRoleId]: { ...(prev[selectedRoleId] || {}), [permKey]: value },
    }));
  };

  const resetRole = () => {
    setRolePermissions((prev) => ({ ...prev, [selectedRoleId]: makeDefaultPermissions() }));
    showToast('Role permissions reset', 'success');
  };

  const saveRole = () => showToast('Permissions saved successfully', 'success');

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Roles & Permissions</h2>}>
      <Head title="Roles & Permissions" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-gray-900 text-2xl font-semibold">Roles & Permissions</h1>
                <p className="text-gray-500">Configure access control across the platform</p>
              </div>
              <div className="flex flex-col sm:flex-row gap-3 lg:w-auto w-full">
                <Button variant="outline" onClick={resetRole} className="rounded-xl">
                  <RotateCcw className="w-auto h-4 mr-2" />
                  Reset
                </Button>
                <Button onClick={saveRole} className="text-white rounded-xl bg-blue-600 hover:bg-blue-700">
                  <Save className="w-auto h-4 mr-2" />
                  Save
                </Button>
              </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
                <h2 className="text-gray-900 font-semibold mb-4">Roles</h2>
                <div className="space-y-2">
                  {defaultRoles.map((r) => (
                    <button
                      key={r.id}
                      onClick={() => setSelectedRoleId(r.id)}
                      className={`w-full text-left p-4 rounded-xl border transition ${
                        r.id === selectedRoleId ? 'border-blue-300 bg-blue-50' : 'border-gray-100 hover:border-blue-200'
                      }`}
                    >
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-gray-900 font-medium">{r.name}</p>
                          <p className="text-xs text-gray-500 mt-1">{r.description}</p>
                        </div>
                        <Badge className={r.color}>Role</Badge>
                      </div>
                    </button>
                  ))}
                </div>
              </Card>

              <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white lg:col-span-2">
                <div className="flex items-center gap-2 mb-2">
                  <Shield className="w-5 h-5 text-blue-600" />
                  <h2 className="text-gray-900 font-semibold">{selectedRole.name} Permissions</h2>
                </div>
                <p className="text-sm text-gray-500 mb-6">Toggle what this role can do in each module.</p>

                <div className="space-y-6">
                  {permissionModules.map((m) => (
                    <div key={m.id} className="border border-gray-100 rounded-2xl p-4">
                      <div className="flex items-center justify-between">
                        <div>
                          <p className="text-gray-900 font-medium">{m.module}</p>
                          <p className="text-xs text-gray-500">{m.actions.length} actions</p>
                        </div>
                        <Button
                          size="sm"
                          variant="outline"
                          className="rounded-lg"
                          onClick={() => {
                            const allOn = m.actions.every((a) => !!selectedPerms[`${m.id}.${a}`]);
                            m.actions.forEach((a) => setPerm(`${m.id}.${a}`, !allOn));
                          }}
                        >
                          Toggle all
                        </Button>
                      </div>

                      <div className="mt-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                        {m.actions.map((a) => {
                          const key = `${m.id}.${a}`;
                          return (
                            <div key={key} className="flex items-center justify-between p-3 bg-gray-50 rounded-xl">
                              <div>
                                <p className="text-sm text-gray-900">{a.replace(/_/g, ' ')}</p>
                                <p className="text-xs text-gray-500">{key}</p>
                              </div>
                              <Switch checked={!!selectedPerms[key]} onCheckedChange={(v) => setPerm(key, v)} />
                            </div>
                          );
                        })}
                      </div>
                    </div>
                  ))}
                </div>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

