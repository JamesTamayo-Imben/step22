import React, { useState, useEffect, useRef } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge, Modal, Select, SelectItem, showToast } from './components/ui';
import { Search, Plus, UserX, UserCheck, Key, Trash2, ChevronLeft, ChevronRight, AlertCircle, CheckCircle, XCircle, Eye, EyeOff } from 'lucide-react';
import axios from 'axios';

export default function UserManagementPage({ users: initialUsers, roles: initialRoles, statuses: initialStatuses, pagination: initialPagination, filters: initialFilters }) {
  const [users, setUsers] = useState(initialUsers || []);
  const [roles, setRoles] = useState(initialRoles || []);
  const [statuses, setStatuses] = useState(initialStatuses || []);
  const [pagination, setPagination] = useState(initialPagination || { current_page: 1, per_page: 20, total: 0, last_page: 1 });
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // Bulk registration modal state - Step 1: Select role type
  const [bulkRegModal, setBulkRegModal] = useState({
    open: false,
    step: 1, // 1: select role, 2: input emails/names
    selectedRole: null,
    registrationType: null, // 'single' or 'multiple'
    emails: '', // text area for multiple emails
    singleName: '',
    singleEmail: '',
    result: null, // 'success', 'error', null
    successMessage: '',
  });

  // Confirmation modal state
  const [confirmModal, setConfirmModal] = useState({
    open: false,
    type: null, // 'reset', 'toggle', 'archive'
    userId: null,
    message: '',
    result: null, // 'success', 'error', null
  });

  const [searchQuery, setSearchQuery] = useState(initialFilters?.search || '');
  const [filterRole, setFilterRole] = useState(initialFilters?.role || 'all');
  const [filterStatus, setFilterStatus] = useState(initialFilters?.status || 'all');

  // Filter out superadmin users from being displayed
  const visibleUsers = users.filter(u => {
    const roleName = (typeof u.role === 'object' ? u.role?.name : u.role)?.toLowerCase();
    return !['superadmin', 'super admin'].includes(roleName);
  });

  // Debounce timer for search
  const searchTimeoutRef = useRef(null);

  // Cleanup timeout on component unmount
  useEffect(() => {
    return () => {
      if (searchTimeoutRef.current) {
        clearTimeout(searchTimeoutRef.current);
      }
    };
  }, []);

  // Generate password from email: lpcalibuso@kld.edu.ph -> lpcalibusoKLD2026
  const generatePasswordFromEmail = (email) => {
    const username = email.split('@')[0];
    const year = new Date().getFullYear();
    return `${username}KLD${year}`;
  };

  // Validate email: check format, domain, and if exists
  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return { valid: false, error: `Invalid email format: ${email}` };
    }

    const domain = email.split('@')[1]?.toLowerCase();
    const validDomains = ['kld.edu.ph', 'kld.com.ph', 'step.edu.ph'];

    if (!domain || !validDomains.some(d => domain.endsWith(d))) {
      return { valid: false, error: `Email must use institutional domain (kld.edu.ph, etc.): ${email}` };
    }

    return { valid: true };
  };

  // Open bulk registration modal - Step 1
  const openBulkRegModal = () => {
    setBulkRegModal({
      open: true,
      step: 1,
      selectedRole: null,
      registrationType: null,
      emails: '',
      singleName: '',
      singleEmail: '',
      result: null,
      successMessage: '',
    });
  };

  // Handle role selection in Step 1
  const handleRoleSelect = (roleId, registrationType) => {
    setBulkRegModal(prev => ({
      ...prev,
      selectedRole: roleId,
      registrationType: registrationType,
      step: 2,
    }));
  };

  // Handle bulk registration submission
  const handleBulkRegSubmit = async () => {
    setIsLoading(true);
    try {
      let emailsToRegister = [];

      if (bulkRegModal.registrationType === 'single') {
        if (!bulkRegModal.singleName || !bulkRegModal.singleEmail) {
          showToast('Please fill in name and email', 'error');
          setIsLoading(false);
          return;
        }

        const emailValidation = validateEmail(bulkRegModal.singleEmail);
        if (!emailValidation.valid) {
          showToast(emailValidation.error, 'error');
          setIsLoading(false);
          return;
        }

        emailsToRegister = [{
          email: bulkRegModal.singleEmail,
          name: bulkRegModal.singleName,
        }];
      } else {
        const emailLines = bulkRegModal.emails
          .split('\n')
          .map(line => line.trim())
          .filter(line => line);

        if (emailLines.length === 0) {
          showToast('Please enter at least one email', 'error');
          setIsLoading(false);
          return;
        }

        if (emailLines.length > 10) {
          showToast('Maximum 10 emails allowed', 'error');
          setIsLoading(false);
          return;
        }

        let validEmails = [];
        let invalidEmails = [];

        emailLines.forEach((line) => {
          let email = '';
          let name = '';

          const emailMatch = line.match(/[\w\.-]+@[\w\.-]+\.\w+/);
          if (emailMatch) {
            email = emailMatch[0];
            const beforeEmail = line.substring(0, line.indexOf(email)).trim();
            name = beforeEmail || email.split('@')[0];
          } else {
            email = line;
            name = email.split('@')[0];
          }

          const emailValidation = validateEmail(email);
          if (emailValidation.valid) {
            validEmails.push({ email, name });
          } else {
            invalidEmails.push({ email, reason: emailValidation.error });
          }
        });

        if (validEmails.length === 0) {
          showToast('No valid emails found. ' + invalidEmails.map(e => `${e.email}: ${e.reason}`).join('; '), 'error');
          setIsLoading(false);
          return;
        }

        if (invalidEmails.length > 0) {
          const warnings = invalidEmails.map(e => `${e.email}: ${e.reason}`).join('\n');
          showToast(`Skipping invalid emails:\n${warnings}\nProceeding with ${validEmails.length} valid email(s)`, 'warning');
        }

        emailsToRegister = validEmails;
      }

      // Use axios — handles CSRF automatically via XSRF-TOKEN cookie
      const response = await axios.post('/sadmin/users/bulk-create', {
        role_id: bulkRegModal.selectedRole,
        users: emailsToRegister,
      });

      const data = response.data;

      setBulkRegModal(prev => ({
        ...prev,
        result: 'success',
        successMessage: data.message || 'Users created successfully. Invitation emails sent.',
      }));

      setTimeout(() => {
        setBulkRegModal(prev => ({ ...prev, open: false }));
        setIsLoading(false);
        showToast('Users created and emails sent!', 'success');
        fetchFilteredUsers(searchQuery, filterRole, filterStatus, 1);
      }, 3000);

    } catch (error) {
      console.error('Error creating users:', error);
      setBulkRegModal(prev => ({ ...prev, result: 'error' }));
      const message = error.response?.data?.message || error.message || 'Failed to create users';
      showToast('Error: ' + message, 'error');
      setTimeout(() => {
        setBulkRegModal(prev => ({ ...prev, result: null }));
        setIsLoading(false);
      }, 2000);
    }
  };

  const roleBadge = (role) => {
    const roleName = typeof role === 'object' ? role?.name : role;
    const map = {
      'Superadmin': 'bg-purple-100 text-purple-700',
      'Super Admin': 'bg-purple-100 text-purple-700',
      'Admin': 'bg-blue-100 text-blue-700',
      'Admin/Adviser': 'bg-blue-100 text-blue-700',
      'Admin/SADU': 'bg-blue-100 text-blue-700',
      'Adviser': 'bg-blue-100 text-blue-700',
      'CSG Officer': 'bg-green-100 text-green-700',
      'CSG': 'bg-green-100 text-green-700',
      'Student': 'bg-gray-100 text-gray-700',
      'Teacher': 'bg-orange-100 text-orange-700',
    };
    return map[roleName] || 'bg-gray-100 text-gray-700';
  };

  const statusBadge = (status) => {
    const normalizedStatus = status?.toLowerCase();
    if (normalizedStatus === 'active') return 'bg-green-100 text-green-700';
    if (normalizedStatus === 'suspended') return 'bg-yellow-100 text-yellow-700';
    if (normalizedStatus === 'archived') return 'bg-red-100 text-red-700';
    return 'bg-gray-100 text-gray-700';
  };

  // Apply filters and search - navigate with query params
  const applyFilters = (search = searchQuery, role = filterRole, status = filterStatus) => {
    const params = new URLSearchParams();
    if (search) params.append('search', search);
    if (role !== 'all') params.append('role', role);
    if (status !== 'all') params.append('status', status);

    router.visit(`/sadmin/users?page=1&${params.toString()}`);
  };

  // Axios call to fetch filtered users without page refresh
  const fetchFilteredUsers = async (search = searchQuery, role = filterRole, status = filterStatus, page = 1) => {
    setIsLoading(true);
    try {
      const params = new URLSearchParams();
      params.append('page', page);
      if (search) params.append('search', search);
      if (role !== 'all') params.append('role', role);
      if (status !== 'all') params.append('status', status);

      // axios automatically sends XSRF-TOKEN cookie, no manual header needed
      const response = await axios.get(`/sadmin/users/search?${params.toString()}`);

      const data = response.data;
      setUsers(data.users || []);
      setPagination(data.pagination || {});
    } catch (error) {
      console.error('Search error:', error);
      showToast('Failed to load users', 'error');
    } finally {
      setIsLoading(false);
    }
  };

  // Handle search input change with debounce - AJAX version (no page refresh)
  const handleSearchChange = (e) => {
    const value = e.target.value;
    setSearchQuery(value);

    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }

    searchTimeoutRef.current = setTimeout(() => {
      fetchFilteredUsers(value, filterRole, filterStatus, 1);
    }, 500);
  };

  // Handle role filter change
  const handleRoleChange = (role) => {
    setFilterRole(role);
    fetchFilteredUsers(searchQuery, role, filterStatus, 1);
  };

  // Handle status filter change
  const handleStatusChange = (status) => {
    setFilterStatus(status);
    fetchFilteredUsers(searchQuery, filterRole, status, 1);
  };

  // Show confirmation for reset password
  const openResetPasswordConfirm = (id) => {
    const user = users.find(u => u.id === id);
    setConfirmModal({
      open: true,
      type: 'reset',
      userId: id,
      message: `Are you sure you want to reset the password for ${user?.name}? A reset link will be sent to ${user?.email}.`,
      result: null,
    });
  };

  // Execute reset password via axios
  const executeResetPassword = async (id) => {
    setIsLoading(true);
    try {
      await axios.post(`/sadmin/users/${id}/reset-password`);

      setConfirmModal(prev => ({ ...prev, result: 'success' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
        showToast('Password reset email sent', 'success');
      }, 2000);
    } catch (error) {
      console.error('Reset password error:', error);
      setConfirmModal(prev => ({ ...prev, result: 'error' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
      }, 2000);
    }
  };

  // Show confirmation for toggle status
  const openToggleStatusConfirm = (id) => {
    const user = users.find(u => u.id === id);
    const newStatus = user?.status?.toLowerCase() === 'active' ? 'suspended' : 'active';
    setConfirmModal({
      open: true,
      type: 'toggle',
      userId: id,
      message: `Are you sure you want to ${newStatus === 'suspended' ? 'suspend' : 'activate'} ${user?.name}?`,
      result: null,
    });
  };

  // Execute toggle status via axios
  const executeToggleStatus = async (id) => {
    setIsLoading(true);
    try {
      const response = await axios.patch(`/sadmin/users/${id}/toggle-status`);
      const data = response.data;

      setUsers((prev) =>
        prev.map((u) => {
          if (u.id === id) {
            const newStatus = u.status?.toLowerCase() === 'active' ? 'suspended' : 'active';
            return { ...u, status: newStatus };
          }
          return u;
        })
      );

      setConfirmModal(prev => ({ ...prev, result: 'success' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
        const action = data.status === 'Suspended' ? 'suspended' : 'activated';
        showToast(`User ${action} successfully`, 'success');
      }, 2000);
    } catch (error) {
      console.error('Toggle status error:', error);
      setConfirmModal(prev => ({ ...prev, result: 'error' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
      }, 2000);
    }
  };

  // Show confirmation for archive
  const openArchiveConfirm = (id) => {
    const user = users.find(u => u.id === id);
    setConfirmModal({
      open: true,
      type: 'archive',
      userId: id,
      message: `Are you sure you want to archive ${user?.name}? This will change their status to archived.`,
      result: null,
    });
  };

  // Show confirmation for restore
  const openRestoreConfirm = (id) => {
    const user = users.find(u => u.id === id);
    setConfirmModal({
      open: true,
      type: 'restore',
      userId: id,
      message: `Are you sure you want to restore ${user?.name}? They will be activated and can log in again.`,
      result: null,
    });
  };

  // Execute archive user via axios
  const executeArchiveUser = async (id) => {
    setIsLoading(true);
    try {
      await axios.delete(`/sadmin/users/${id}`);

      setUsers((prev) =>
        prev.map((u) => u.id === id ? { ...u, status: 'archived' } : u)
      );

      setConfirmModal(prev => ({ ...prev, result: 'success' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
        showToast('User archived successfully', 'success');
      }, 2000);
    } catch (error) {
      console.error('Archive error:', error);
      setConfirmModal(prev => ({ ...prev, result: 'error' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
      }, 2000);
    }
  };

  // Execute restore user via axios
  const executeRestoreUser = async (id) => {
    setIsLoading(true);
    try {
      await axios.patch(`/sadmin/users/${id}/restore`);

      setUsers((prev) =>
        prev.map((u) => u.id === id ? { ...u, status: 'active' } : u)
      );

      setConfirmModal(prev => ({ ...prev, result: 'success' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
        showToast('User restored successfully', 'success');
      }, 2000);
    } catch (error) {
      console.error('Restore error:', error);
      setConfirmModal(prev => ({ ...prev, result: 'error' }));
      setTimeout(() => {
        setConfirmModal({ open: false, type: null, userId: null, message: '', result: null });
        setIsLoading(false);
      }, 2000);
    }
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">User Management</h2>}>
      <Head title="User Management" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-blue-600 text-2xl font-semibold">User Management</h1>
                <p className="text-gray-500">Add, suspend, and manage platform users</p>
              </div>
              <Button onClick={() => openBulkRegModal()} className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 lg:w-auto w-full" disabled={isLoading}>
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
                      onChange={handleSearchChange}
                      placeholder="Search name/email..."
                      className="pl-9 flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    />
                  </div>
                </div>
                <div>
                  <Select
                    className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    value={filterRole} onValueChange={handleRoleChange}>
                    <SelectItem value="all">All roles</SelectItem>
                    {roles.map((role) => (
                      <SelectItem key={role.id} value={role.name}>
                        {role.name}
                      </SelectItem>
                    ))}
                  </Select>
                </div>
                <div>
                  <Select
                    className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                    value={filterStatus} onValueChange={handleStatusChange}>
                    <SelectItem value="all">All statuses</SelectItem>
                    {statuses.map((status) => (
                      <SelectItem key={status.value} value={status.value}>
                        {status.label}
                      </SelectItem>
                    ))}
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
                    {visibleUsers.map((u) => (
                      <tr key={u.id} className="border-b last:border-0">
                        <td className="py-4 pr-4">
                          <div className="text-gray-900">{u.name}</div>
                          <div className="text-xs text-gray-500">{u.email}</div>
                        </td>
                        <td className="py-4 pr-4">
                          <Badge className={roleBadge(u.role)}>{u.role?.name}</Badge>
                        </td>
                        <td className="py-4 pr-4">
                          <Badge className={statusBadge(u.status)}>{u.status}</Badge>
                        </td>
                        <td className="py-4 pr-4 text-gray-600">
                          <div className="max-w-[300px] truncate">
   {u.createdAt}
  </div></td>
<td className="py-4 pr-4 text-gray-600">
  <div className="max-w-[300px] truncate">
    {u.lastLogin || '—'}
  </div>
</td>                        <td className="py-4">
                          <div className="flex items-center gap-2 flex-wrap">
                            {u.status?.toLowerCase() !== 'archived' && (
                              <>
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="rounded-lg text-red-600 hover:text-red-700 hover:bg-red-50"
                                  onClick={() => openArchiveConfirm(u.id)}
                                  disabled={isLoading || confirmModal.open}
                                >
                                  <Trash2 className="w-4 h-4 mr-1" />
                                  Archive
                                </Button>
                              </>
                            )}

                            {u.status?.toLowerCase() === 'archived' && (
                              <Button
                                size="sm"
                                variant="outline"
                                className="rounded-lg text-green-600 hover:text-green-700 hover:bg-green-50"
                                onClick={() => openRestoreConfirm(u.id)}
                                disabled={isLoading || confirmModal.open}
                              >
                                <UserCheck className="w-4 h-4 mr-1" />
                                Restore
                              </Button>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))}
                    {!visibleUsers.length ? (
                      <tr>
                        <td colSpan={6} className="py-10 text-center text-gray-500">
                          No users found.
                        </td>
                      </tr>
                    ) : null}
                  </tbody>
                </table>
              </div>

              {/* Pagination Controls */}
              {pagination.last_page > 1 && (
                <div className="mt-6 flex items-center justify-between">
                  <div className="text-sm text-gray-600">
                    Showing {(pagination.current_page - 1) * pagination.per_page + 1} to {Math.min(pagination.current_page * pagination.per_page, pagination.total)} of {pagination.total} users
                  </div>
                  <div className="flex gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      className="rounded-lg"
                      disabled={pagination.current_page === 1 || isLoading}
                      onClick={() => fetchFilteredUsers(searchQuery, filterRole, filterStatus, pagination.current_page - 1)}
                    >
                      <ChevronLeft className="w-4 h-4 mr-1" />
                      Previous
                    </Button>

                    <div className="flex items-center gap-2">
                      {Array.from({ length: pagination.last_page }, (_, i) => i + 1).map((page) => (
                        <Button
                          key={page}
                          variant={pagination.current_page === page ? 'default' : 'outline'}
                          size="sm"
                          className={`rounded-lg w-10 h-10 p-0 ${pagination.current_page === page ? 'bg-blue-600 text-white' : ''}`}
                          onClick={() => fetchFilteredUsers(searchQuery, filterRole, filterStatus, page)}
                          disabled={isLoading}
                        >
                          {page}
                        </Button>
                      ))}
                    </div>

                    <Button
                      variant="outline"
                      size="sm"
                      className="rounded-lg"
                      disabled={pagination.current_page === pagination.last_page || isLoading}
                      onClick={() => fetchFilteredUsers(searchQuery, filterRole, filterStatus, pagination.current_page + 1)}
                    >
                      Next
                      <ChevronRight className="w-4 h-4 ml-1" />
                    </Button>
                  </div>
                </div>
              )}
            </Card>
          </div>
        </div>
      </div>

      {/* STEP 1: Select Role Type Modal */}
      <Modal
        open={bulkRegModal.open && bulkRegModal.step === 1}
        onClose={() => setBulkRegModal(prev => ({ ...prev, open: false }))}
        title="Register New Users"
        description="Choose how you want to register users"
        maxWidthClass="max-w-md"
      >
        <div className="py-6 space-y-4">
          <div>
            <h3 className="text-sm font-semibold text-gray-800 mb-4">Select Role:</h3>
            <div className="grid grid-cols-1 gap-3 mb-6">
              {roles
                .filter(role => {
                  const allowedRoles = ['Student', 'Teacher', 'Ordinary Teacher'];
                  const isAdminRole = role.name === 'Superadmin' || role.name === 'Super Admin' ||
                    role.name === 'Admin' || role.name === 'Admin/Adviser' ||
                    role.name === 'CSG Officer' || role.name === 'CSG';

                  return allowedRoles.includes(role.name) && !isAdminRole;
                })
                .map((role) => (
                  <div key={role.id}>
                    <h4 className="text-sm font-medium text-gray-700 mb-2">{role.name}</h4>
                    <div className="flex gap-2">
                      <Button
                        onClick={() => handleRoleSelect(role.id, 'single')}
                        className="flex-1 text-white rounded-lg bg-blue-600 hover:bg-blue-700 text-sm"
                        disabled={isLoading}
                      >
                        Single
                      </Button>

                      {(role.name === 'Student' || role.name === 'Teacher' || role.name === 'Ordinary Teacher') && (
                        <Button
                          onClick={() => handleRoleSelect(role.id, 'multiple')}
                          className="flex-1 text-white rounded-lg bg-green-600 hover:bg-green-700 text-sm"
                          disabled={isLoading}
                        >
                          Multiple (Max 10)
                        </Button>
                      )}
                    </div>
                  </div>
                ))}
            </div>
          </div>
          <Button
            variant="outline"
            onClick={() => setBulkRegModal(prev => ({ ...prev, open: false }))}
            className="w-full rounded-lg"
          >
            Cancel
          </Button>
        </div>
      </Modal>

      {/* STEP 2: Input Emails Modal */}
      <Modal
        open={bulkRegModal.open && bulkRegModal.step === 2}
        onClose={() => {
          setBulkRegModal(prev => ({ ...prev, step: 1, registrationType: null }));
        }}
        title={bulkRegModal.registrationType === 'single' ? 'Register Single User' : 'Register Multiple Users'}
        description=""
        maxWidthClass="max-w-lg"
      >
        <div className="py-6 space-y-4">
          {bulkRegModal.result === null && (
            <>
              <div>
                <label className="block text-sm text-gray-700 mb-2">
                  {bulkRegModal.registrationType === 'single' ? 'Full Name *' : 'Email(s) - One per line (Max 10)'}
                </label>
                {bulkRegModal.registrationType === 'single' ? (
                  <>
                    <Input
                      placeholder="Juan Dela Cruz"
                      value={bulkRegModal.singleName}
                      onChange={(e) => setBulkRegModal(prev => ({ ...prev, singleName: e.target.value }))}
                      className="w-full rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10 mb-3"
                    />
                    <Input
                      placeholder="juan.delacruz@kld.edu.ph"
                      type="email"
                      value={bulkRegModal.singleEmail}
                      onChange={(e) => setBulkRegModal(prev => ({ ...prev, singleEmail: e.target.value }))}
                      className="w-full rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10"
                    />
                  </>
                ) : (
                  <textarea
                    placeholder={`student1@kld.edu.ph\nstudent2@kld.edu.ph\nstudent3@kld.edu.ph\n\nOr with names:\nJuan Dela Cruz juan@kld.edu.ph\nMaria Santos maria@kld.edu.ph`}
                    value={bulkRegModal.emails}
                    onChange={(e) => setBulkRegModal(prev => ({ ...prev, emails: e.target.value }))}
                    className="w-full rounded-lg border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition p-3"
                    rows="8"
                  />
                )}
                <p className="text-xs text-gray-500 mt-2">
                  System will auto-generate passwords and send invitation emails with role-specific signup links.
                </p>
              </div>
            </>
          )}

          {bulkRegModal.result === 'success' && (
            <div className="text-center py-4">
              <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <p className="text-gray-700 font-semibold mb-2">Success!</p>
              <p className="text-sm text-gray-600">{bulkRegModal.successMessage}</p>
              <p className="text-xs text-gray-500 mt-3">Closing in a moment...</p>
            </div>
          )}

          {bulkRegModal.result === 'error' && (
            <div className="text-center py-4">
              <XCircle className="w-12 h-12 text-red-500 mx-auto mb-4" />
              <p className="text-gray-700 font-semibold">Error</p>
              <p className="text-sm text-gray-600">Failed to create users. Please try again.</p>
            </div>
          )}

          <div className="flex gap-3">
            {bulkRegModal.result === null && (
              <>
                <Button
                  variant="outline"
                  onClick={() => setBulkRegModal(prev => ({ ...prev, step: 1, registrationType: null }))}
                  className="flex-1 rounded-lg"
                  disabled={isLoading}
                >
                  Back
                </Button>
                <Button
                  onClick={() => handleBulkRegSubmit()}
                  className="flex-1 text-white rounded-lg bg-blue-600 hover:bg-blue-700"
                  disabled={isLoading}
                >
                  {isLoading ? 'Creating...' : 'Create & Send Invitations'}
                </Button>
              </>
            )}
          </div>
        </div>
      </Modal>

      {/* Confirmation Modal */}
      <Modal
        open={confirmModal.open}
        onClose={() => !confirmModal.result && setConfirmModal({ open: false, type: null, userId: null, message: '', result: null })}
        title={confirmModal.result ? (confirmModal.result === 'success' ? 'Success' : 'Error') : 'Confirm Action'}
        description=""
        maxWidthClass="max-w-md"
      >
        <div className="py-6 text-center">
          {confirmModal.result === null && (
            <>
              <AlertCircle className="w-12 h-12 text-yellow-500 mx-auto mb-4" />
              <p className="text-gray-700 mb-6">{confirmModal.message}</p>
              <div className="flex gap-3 justify-center">
                <Button
                  variant="outline"
                  onClick={() => setConfirmModal({ open: false, type: null, userId: null, message: '', result: null })}
                  className="rounded-lg"
                  disabled={isLoading}
                >
                  Cancel
                </Button>
                <Button
                  onClick={() => {
                    if (confirmModal.type === 'reset') executeResetPassword(confirmModal.userId);
                    else if (confirmModal.type === 'toggle') executeToggleStatus(confirmModal.userId);
                    else if (confirmModal.type === 'archive') executeArchiveUser(confirmModal.userId);
                    else if (confirmModal.type === 'restore') executeRestoreUser(confirmModal.userId);
                  }}
                  className="text-white rounded-lg bg-red-600 hover:bg-red-700"
                  disabled={isLoading}
                >
                  {isLoading ? 'Processing...' : 'Confirm'}
                </Button>
              </div>
            </>
          )}

          {confirmModal.result === 'success' && (
            <>
              <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <p className="text-gray-700">Action completed successfully!</p>
            </>
          )}

          {confirmModal.result === 'error' && (
            <>
              <XCircle className="w-12 h-12 text-red-500 mx-auto mb-4" />
              <p className="text-gray-700">An error occurred. Please try again.</p>
            </>
          )}
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}