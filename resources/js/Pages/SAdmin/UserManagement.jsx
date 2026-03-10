import React, { useMemo, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge, Modal, Select, SelectItem, showToast } from './components/ui';
import { Search, Plus, UserX, UserCheck, Key } from 'lucide-react';

const mockUsers = [
  { id: 1, name: 'Super Admin', email: 'superadmin@kld.edu.ph', role: 'Superadmin', status: 'Active', createdAt: '2024-01-15', lastLogin: '2024-11-20' },
  { id: 2, name: 'Admin User', email: 'admin@kld.edu.ph', role: 'Admin/Adviser', status: 'Active', createdAt: '2024-01-20', lastLogin: '2024-11-20' },
  { id: 3, name: 'Sarah Chen', email: 'sarah.chen@kld.edu.ph', role: 'CSG Officer', status: 'Active', createdAt: '2024-08-01', lastLogin: '2024-11-20' },
  { id: 4, name: 'Michael Torres', email: 'michael.torres@kld.edu.ph', role: 'CSG Officer', status: 'Active', createdAt: '2024-08-01', lastLogin: '2024-11-19' },
  { id: 5, name: 'Emma Johnson', email: 'emma.johnson@kld.edu.ph', role: 'Student', status: 'Active', createdAt: '2024-09-01', lastLogin: '2024-11-20' },
  { id: 6, name: 'John Suspended', email: 'john.suspended@kld.edu.ph', role: 'Student', status: 'Suspended', createdAt: '2024-09-15', lastLogin: '2024-11-10' },
];

export default function UserManagementPage() {
  const [users, setUsers] = useState(mockUsers);
  const [showCreateModal, setShowCreateModal] = useState(false);

  const [searchQuery, setSearchQuery] = useState('');
  const [filterRole, setFilterRole] = useState('all');
  const [filterStatus, setFilterStatus] = useState('all');

  const [createForm, setCreateForm] = useState({
    name: '',
    email: '',
    role: 'Student',
    password: '',
    confirmPassword: '',
  });

  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const s = searchQuery.trim().toLowerCase();
      const matchesSearch = !s || u.name.toLowerCase().includes(s) || u.email.toLowerCase().includes(s);
      const matchesRole = filterRole === 'all' || u.role === filterRole;
      const matchesStatus = filterStatus === 'all' || u.status === filterStatus;
      return matchesSearch && matchesRole && matchesStatus;
    });
  }, [users, searchQuery, filterRole, filterStatus]);

  const roleBadge = (role) => {
    const map = {
      Superadmin: 'bg-purple-100 text-purple-700',
      'Admin/Adviser': 'bg-blue-100 text-blue-700',
      'CSG Officer': 'bg-green-100 text-green-700',
      Student: 'bg-gray-100 text-gray-700',
    };
    return map[role] || 'bg-gray-100 text-gray-700';
  };

  const statusBadge = (status) => (status === 'Active' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700');

  const handleToggleStatus = (id) => {
    setUsers((prev) =>
      prev.map((u) => (u.id === id ? { ...u, status: u.status === 'Active' ? 'Suspended' : 'Active' } : u))
    );
    const u = users.find((x) => x.id === id);
    showToast(`${u?.name || 'User'} status updated`, 'success');
  };

  const handleResetPassword = (id) => {
    const u = users.find((x) => x.id === id);
    showToast(`Password reset link sent to ${u?.email || 'user'}`, 'success');
  };

  const handleCreate = () => {
    if (!createForm.name || !createForm.email) {
      showToast('Name and email are required', 'error');
      return;
    }
    if (createForm.password.length < 8) {
      showToast('Password must be at least 8 characters', 'error');
      return;
    }
    if (createForm.password !== createForm.confirmPassword) {
      showToast('Passwords do not match', 'error');
      return;
    }

    const next = {
      id: Math.max(...users.map((u) => u.id)) + 1,
      name: createForm.name,
      email: createForm.email,
      role: createForm.role,
      status: 'Active',
      createdAt: new Date().toISOString().slice(0, 10),
      lastLogin: '—',
    };
    setUsers((prev) => [next, ...prev]);
    setShowCreateModal(false);
    setCreateForm({ name: '', email: '', role: 'Student', password: '', confirmPassword: '' });
    showToast('User created successfully', 'success');
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">User Management</h2>}>
      <Head title="User Management" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-gray-900 text-2xl font-semibold">User Management</h1>
                <p className="text-gray-500">Add, suspend, and manage platform users</p>
              </div>
              <Button onClick={() => setShowCreateModal(true)} className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 lg:w-auto w-full">
                <Plus className="w-4 h-4 mr-2" />
                Create User
              </Button>
            </div>

            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="md:col-span-1">
                  <div className="relative">
                    <Search className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
                    <input
                      value={searchQuery}
                      onChange={(e) => setSearchQuery(e.target.value)}
                      placeholder="Search name/email..."
                      className="pl-9 flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    />
                  </div>
                </div>
                <div>
                  <Select
                  className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                  value={filterRole} onValueChange={setFilterRole}>
                    <SelectItem value="all">All roles</SelectItem>
                    <SelectItem value="Superadmin">Superadmin</SelectItem>
                    <SelectItem value="Admin/Adviser">Admin/Adviser</SelectItem>
                    <SelectItem value="CSG Officer">CSG Officer</SelectItem>
                    <SelectItem value="Student">Student</SelectItem>
                  </Select>
                </div>
                <div>
                  <Select
                  className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                   value={filterStatus} onValueChange={setFilterStatus}>
                    <SelectItem value="all">All statuses</SelectItem>
                    <SelectItem value="Active">Active</SelectItem>
                    <SelectItem value="Suspended">Suspended</SelectItem>
                  </Select>
                </div>
              </div>

              <div className="mt-6 overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-left text-gray-500 border-b">
                      <th className="py-3 pr-4">User</th>
                      <th className="py-3 pr-4">Role</th>
                      <th className="py-3 pr-4">Status</th>
                      <th className="py-3 pr-4">Created</th>
                      <th className="py-3 pr-4">Last Login</th>
                      <th className="py-3">Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    {filteredUsers.map((u) => (
                      <tr key={u.id} className="border-b last:border-0">
                        <td className="py-4 pr-4">
                          <div className="text-gray-900">{u.name}</div>
                          <div className="text-xs text-gray-500">{u.email}</div>
                        </td>
                        <td className="py-4 pr-4">
                          <Badge className={roleBadge(u.role)}>{u.role}</Badge>
                        </td>
                        <td className="py-4 pr-4">
                          <Badge className={statusBadge(u.status)}>{u.status}</Badge>
                        </td>
                        <td className="py-4 pr-4 text-gray-600">{u.createdAt}</td>
                        <td className="py-4 pr-4 text-gray-600">{u.lastLogin || '—'}</td>
                        <td className="py-4">
                          <div className="flex items-center gap-2 flex-wrap">
                            <Button
                              size="sm"
                              variant="outline"
                              className="rounded-lg"
                              onClick={() => handleResetPassword(u.id)}
                            >
                              <Key className="w-4 h-4 mr-1" />
                              Reset
                            </Button>
                            <Button
                              size="sm"
                              variant="outline"
                              className="rounded-lg"
                              onClick={() => handleToggleStatus(u.id)}
                            >
                              {u.status === 'Active' ? (
                                <>
                                  <UserX className="w-4 h-4 mr-1" />
                                  Suspend
                                </>
                              ) : (
                                <>
                                  <UserCheck className="w-4 h-4 mr-1" />
                                  Activate
                                </>
                              )}
                            </Button>
                          </div>
                        </td>
                      </tr>
                    ))}
                    {!filteredUsers.length ? (
                      <tr>
                        <td colSpan={6} className="py-10 text-center text-gray-500">
                          No users match your filters.
                        </td>
                      </tr>
                    ) : null}
                  </tbody>
                </table>
              </div>
            </Card>
          </div>
        </div>
      </div>

      <Modal
        open={showCreateModal}
        onClose={() => setShowCreateModal(false)}
        title="Create User"
        description="Create a new platform user"
        maxWidthClass="max-w-xl"
      >
        <div className="space-y-4 pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm text-gray-700 mb-1">Name</label>
              <Input placeholder="Juan Dela Cruz" value={createForm.name} onChange={(e) => setCreateForm({ ...createForm, name: e.target.value })} className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10" />
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Role</label>
              <Select
              className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10"
              value={createForm.role} onValueChange={(v) => setCreateForm({ ...createForm, role: v })}>
                <SelectItem value="Student">Student</SelectItem>
                <SelectItem value="CSG Officer">CSG Officer</SelectItem>
                <SelectItem value="Admin/Adviser">Admin/Adviser</SelectItem>
                <SelectItem value="Superadmin">Superadmin</SelectItem>
              </Select>
            </div>
            <div className="md:col-span-2">
              <label className="block text-sm text-gray-700 mb-1">Email</label>
              <Input placeholder="juan.delacruz@example.com" type="email" value={createForm.email} onChange={(e) => setCreateForm({ ...createForm, email: e.target.value })} className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10" />
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Password</label>
              <Input placeholder="••••••••" type="password" value={createForm.password} onChange={(e) => setCreateForm({ ...createForm, password: e.target.value })} className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10" />
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Confirm</label>
              <Input placeholder="••••••••" type="password" value={createForm.confirmPassword} onChange={(e) => setCreateForm({ ...createForm, confirmPassword: e.target.value })} className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10" />
            </div>
          </div>

          <div className="flex gap-3 pt-4">
            <Button variant="outline" onClick={() => setShowCreateModal(false)} className="flex-1 rounded-xl">
              Cancel
            </Button>
            <Button onClick={handleCreate} className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700">
              Create
            </Button>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}

