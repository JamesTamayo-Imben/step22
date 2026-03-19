import React, { useState, useEffect, useRef } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge, Modal, Select, SelectItem, showToast } from './components/ui';
import { Search, Plus, UserX, UserCheck, Key, Trash2, ChevronLeft, ChevronRight, AlertCircle, CheckCircle, XCircle, Eye, EyeOff } from 'lucide-react';

export default function UserManagementPage({ users: initialUsers, roles: initialRoles, statuses: initialStatuses, pagination: initialPagination, filters: initialFilters }) {
  const [users, setUsers] = useState(initialUsers || []);
  const [roles, setRoles] = useState(initialRoles || []);
  const [statuses, setStatuses] = useState(initialStatuses || []);
  const [pagination, setPagination] = useState(initialPagination || { current_page: 1, per_page: 5, total: 0, last_page: 1 });
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

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
  
  // Debounce timer for search
  const searchTimeoutRef = useRef(null);

  // Create form state with dynamic fields
  const [createForm, setCreateForm] = useState({
    name: '',
    email: '',
    role_id: '',
    password: '',
    password_confirmation: '',
    phone: '',
    // Student fields
    student_id: '',
    // Teacher/Adviser fields
    employee_id: '',
    specialization: '',
    office_location: '',
  });

  const [formFields, setFormFields] = useState({
    baseFields: {},
    roleSpecificFields: {},
  });

  const [formErrors, setFormErrors] = useState({});

  // Password visibility state
  const [showPassword, setShowPassword] = useState(false);
  const [showPasswordConfirmation, setShowPasswordConfirmation] = useState(false);

  // Cleanup timeout on component unmount
  useEffect(() => {
    return () => {
      if (searchTimeoutRef.current) {
        clearTimeout(searchTimeoutRef.current);
      }
    };
  }, []);

  // Fetch form fields when role changes
  const fetchFormFields = async (roleId) => {
    if (!roleId) {
      setFormFields({ baseFields: {}, roleSpecificFields: {} });
      return;
    }

    try {
      const response = await fetch(`/sadmin/users/form-fields/${roleId}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });
      const data = await response.json();
      setFormFields({
        baseFields: data.baseFields || {},
        roleSpecificFields: data.roleSpecificFields || {},
      });
    } catch (error) {
      console.error('Error fetching form fields:', error);
      showToast('Error loading form fields', 'error');
    }
  };

  // Handle role change and fetch dynamic fields (for create form)
  const handleRoleChangeForCreateForm = (roleId) => {
    setCreateForm({ ...createForm, role_id: roleId });
    fetchFormFields(roleId);
  };

  const roleBadge = (role) => {
    // Handle both object and string
    const roleName = typeof role === 'object' ? role?.name : role;
    const map = {
      'Superadmin': 'bg-purple-100 text-purple-700',
      'Super Admin': 'bg-purple-100 text-purple-700',
      'Admin': 'bg-blue-100 text-blue-700',
      'Admin/Adviser': 'bg-blue-100 text-blue-700',
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

  // AJAX call to fetch filtered users without page refresh
  const fetchFilteredUsers = async (search = searchQuery, role = filterRole, status = filterStatus, page = 1) => {
    setIsLoading(true);
    try {
      const params = new URLSearchParams();
      params.append('page', page);
      if (search) params.append('search', search);
      if (role !== 'all') params.append('role', role);
      if (status !== 'all') params.append('status', status);
      
      const response = await fetch(`/sadmin/users/search?${params.toString()}`, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });
      
      if (!response.ok) throw new Error('Failed to fetch users');
      
      const data = await response.json();
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
    setSearchQuery(value); // Update UI immediately
    
    // Clear existing timeout
    if (searchTimeoutRef.current) {
      clearTimeout(searchTimeoutRef.current);
    }
    
    // Set new timeout to trigger AJAX search after 500ms of no typing
    searchTimeoutRef.current = setTimeout(() => {
      fetchFilteredUsers(value, filterRole, filterStatus, 1);
    }, 500);
  };

  // Handle role filter change - AJAX version (no page refresh)
  const handleRoleChange = (role) => {
    setFilterRole(role);
    fetchFilteredUsers(searchQuery, role, filterStatus, 1);
  };

  // Handle status filter change - AJAX version (no page refresh)
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

  // Execute reset password via AJAX
  const executeResetPassword = async (id) => {
    setIsLoading(true);
    try {
      const response = await fetch(`/sadmin/users/${id}/reset-password`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || ''
        }
      });

      if (!response.ok) throw new Error('Failed to reset password');
      
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

  // Execute toggle status via AJAX
  const executeToggleStatus = async (id) => {
    setIsLoading(true);
    try {
      const response = await fetch(`/sadmin/users/${id}/toggle-status`, {
        method: 'PATCH',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || ''
        }
      });

      if (!response.ok) throw new Error('Failed to toggle status');
      
      const data = await response.json();
      
      // Update user status in state
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

  // Execute archive user via AJAX
  const executeArchiveUser = async (id) => {
    setIsLoading(true);
    try {
      const response = await fetch(`/sadmin/users/${id}`, {
        method: 'DELETE',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || ''
        }
      });

      if (!response.ok) throw new Error('Failed to archive user');
      
      // Update user status to archived instead of removing from list
      setUsers((prev) =>
        prev.map((u) => {
          if (u.id === id) {
            return { ...u, status: 'archived' };
          }
          return u;
        })
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

  // Execute restore user via AJAX
  const executeRestoreUser = async (id) => {
    setIsLoading(true);
    try {
      const response = await fetch(`/sadmin/users/${id}/restore`, {
        method: 'PATCH',
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || ''
        }
      });

      if (!response.ok) throw new Error('Failed to restore user');
      
      // Update user status to active
      setUsers((prev) =>
        prev.map((u) => {
          if (u.id === id) {
            return { ...u, status: 'active' };
          }
          return u;
        })
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

  // const handleCreate = async () => {
  //   // Clear previous errors
  //   setFormErrors({});

  //   // Client-side validation
  //   if (!createForm.name || !createForm.email) {
  //     showToast('Name and email are required', 'error');
  //     return;
  //   }
  //   if (!createForm.role_id) {
  //     showToast('Please select a role', 'error');
  //     return;
  //   }
  //   if (!createForm.password || createForm.password.length < 6) {
  //     showToast('Password must be at least 6 characters', 'error');
  //     return;
  //   }
  //   if (createForm.password !== createForm.password_confirmation) {
  //     showToast('Passwords do not match', 'error');
  //     return;
  //   }

  //   // Validate required fields based on role
  //   // Student role UUID: 359f4170-235d-11f1-9647-10683825ce81
  //   // Ordinary Teacher UUID: 459f4213-235d-11f1-9647-10683825ce81
  //   // Admin/Adviser UUID: 159ef712-235d-11f1-9647-10683825ce81
  //   const studentRoleId = '359f4170-235d-11f1-9647-10683825ce81';
  //   const teacherRoleIds = ['459f4213-235d-11f1-9647-10683825ce81', '159ef712-235d-11f1-9647-10683825ce81'];

  //   if (createForm.role_id === studentRoleId) {
  //     if (!createForm.student_id) {
  //       showToast('Please fill in the student ID', 'error');
  //       return;
  //     }
  //   } else if (teacherRoleIds.includes(createForm.role_id)) {
  //     if (!createForm.employee_id || !createForm.department) {
  //       showToast('Please fill in all required teacher fields', 'error');
  //       return;
  //     }
  //   }

  //   setIsLoading(true);
  //   try {
  //     const response = await fetch('/sadmin/users', {
  //       method: 'POST',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'X-Requested-With': 'XMLHttpRequest',
  //         'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
  //       },
  //       body: JSON.stringify(createForm),
  //     });

  //     const data = await response.json();

  //     if (response.ok) {
  //       // Reset form and close modal
  //       setCreateForm({
  //         name: '',
  //         email: '',
  //         role_id: '',
  //         password: '',
  //         password_confirmation: '',
  //         phone: '',
  //         institute_id: '',
  //         student_id: '',
  //         employee_id: '',
  //         department: '',
  //         specialization: '',
  //         office_location: '',
  //         office_phone: '',
  //         assigned_since: '',
  //       });
  //       setFormFields({ baseFields: {}, roleSpecificFields: {} });
  //       setFormErrors({});
  //       setShowPassword(false);
  //       setShowPasswordConfirmation(false);
  //       setShowCreateModal(false);
  //       showToast('User created successfully', 'success');

  //       // Refresh the user list
  //       fetchFilteredUsers(searchQuery, filterRole, filterStatus, 1);
  //     } else {
  //       // Handle validation errors from backend
  //       if (data.errors) {
  //         setFormErrors(data.errors);
  //         const errorMessages = Object.values(data.errors).flat().join(', ');
  //         showToast('Validation errors: ' + errorMessages, 'error');
  //       } else {
  //         showToast(data.message || 'Failed to create user', 'error');
  //       }
  //     }
  //   } catch (error) {
  //     console.error('Error creating user:', error);
  //     showToast('Error creating user: ' + error.message, 'error');
  //   } finally {
  //     setIsLoading(false);
  //   }
  // };


  const handleCreate = async () => {
    // Clear previous errors
    setFormErrors({});

    // Client-side validation
    if (!createForm.name || !createForm.email) {
      showToast('Name and email are required', 'error');
      return;
    }
    if (!createForm.role_id) {
      showToast('Please select a role', 'error');
      return;
    }
    if (!createForm.password || createForm.password.length < 6) {
      showToast('Password must be at least 6 characters', 'error');
      return;
    }
    if (createForm.password !== createForm.password_confirmation) {
      showToast('Passwords do not match', 'error');
      return;
    }

    setIsLoading(true);
    try {
      const response = await fetch('/sadmin/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        body: JSON.stringify(createForm),
      });

      const data = await response.json();

      if (response.ok) {
        // Reset form and close modal
        setCreateForm({
          name: '',
          email: '',
          role_id: '',
          password: '',
          password_confirmation: '',
          phone: '',
          student_id: '',
          employee_id: '',
          specialization: '',
          office_location: '',
        });
        setFormFields({ baseFields: {}, roleSpecificFields: {} });
        setFormErrors({});
        setShowPassword(false);
        setShowPasswordConfirmation(false);
        setShowCreateModal(false);
        showToast('User created successfully', 'success');

        // Refresh the user list
        fetchFilteredUsers(searchQuery, filterRole, filterStatus, 1);
      } else {
        // Handle validation errors from backend
        if (data.errors) {
          setFormErrors(data.errors);
          const errorMessages = Object.values(data.errors).flat().join(', ');
          showToast('Validation errors: ' + errorMessages, 'error');
        } else {
          showToast(data.message || 'Failed to create user', 'error');
        }
      }
    } catch (error) {
      console.error('Error creating user:', error);
      showToast('Error creating user: ' + error.message, 'error');
    } finally {
      setIsLoading(false);
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
                <h1 className="text-gray-900 text-2xl font-semibold">User Management</h1>
                <p className="text-gray-500">Add, suspend, and manage platform users</p>
              </div>
              <Button onClick={() => setShowCreateModal(true)} className="text-white rounded-xl bg-blue-600 hover:bg-blue-700 lg:w-auto w-full" disabled={isLoading}>
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
                    {users.map((u) => (
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
                        <td className="py-4 pr-4 text-gray-600">{u.createdAt}</td>
                        <td className="py-4 pr-4 text-gray-600">{u.lastLogin || '—'}</td>
                        <td className="py-4">
                          <div className="flex items-center gap-2 flex-wrap">
                            {/* Show all buttons for active and suspended users */}
                            {u.status?.toLowerCase() !== 'archived' && (
                              <>
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="rounded-lg"
                                  onClick={() => openResetPasswordConfirm(u.id)}
                                  disabled={isLoading || confirmModal.open}
                                >
                                  <Key className="w-4 h-4 mr-1" />
                                  Reset
                                </Button>
                                <Button
                                  size="sm"
                                  variant="outline"
                                  className="rounded-lg"
                                  onClick={() => openToggleStatusConfirm(u.id)}
                                  disabled={isLoading || confirmModal.open}
                                >
                                  {u.status?.toLowerCase() === 'active' ? (
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
                            
                            {/* Show only Restore button for archived users */}
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
                    {!users.length ? (
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

      <Modal
        open={showCreateModal}
        onClose={() => {
          setShowPassword(false);
          setShowPasswordConfirmation(false);
          setShowCreateModal(false);
        }}
        title="Create User"
        description="Create a new platform user"
        maxWidthClass="max-w-2xl"
      >
        <div className="space-y-4 pt-6 max-h-96 overflow-y-auto">
          {/* Base Fields - Always Shown */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm text-gray-700 mb-1">Name *</label>
              <Input placeholder="Juan Dela Cruz" value={createForm.name} onChange={(e) => setCreateForm({ ...createForm, name: e.target.value })} className={`flex-1 w-full rounded-xl border ${formErrors.name ? 'border-red-500' : 'border-gray-300'} bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10`} />
              {formErrors.name && <p className="text-red-500 text-xs mt-1">{formErrors.name[0]}</p>}
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Role *</label>
              <Select
                className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10"
                value={createForm.role_id} onValueChange={handleRoleChangeForCreateForm}>
                <SelectItem value="">Select a role</SelectItem>
                {roles.map((role) => (
                  <SelectItem key={role.id} value={role.id.toString()}>
                    {role.name}
                  </SelectItem>
                ))}
              </Select>
              {formErrors.role_id && <p className="text-red-500 text-xs mt-1">{formErrors.role_id[0]}</p>}
            </div>
            <div className="md:col-span-2">
              <label className="block text-sm text-gray-700 mb-1">Email *</label>
              <Input placeholder="juan.delacruz@example.com" type="email" value={createForm.email} onChange={(e) => setCreateForm({ ...createForm, email: e.target.value })} className={`flex-1 w-full rounded-xl border ${formErrors.email ? 'border-red-500' : 'border-gray-300'} bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10`} />
              {formErrors.email && <p className="text-red-500 text-xs mt-1">{formErrors.email[0]}</p>}
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Password *</label>
              <div className="relative">
                <Input 
                  placeholder="••••••••" 
                  type={showPassword ? 'text' : 'password'} 
                  value={createForm.password} 
                  onChange={(e) => setCreateForm({ ...createForm, password: e.target.value })} 
                  className={`flex-1 w-full rounded-xl border ${formErrors.password ? 'border-red-500' : 'border-gray-300'} bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10 pr-10`} 
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {formErrors.password && <p className="text-red-500 text-xs mt-1">{formErrors.password[0]}</p>}
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Confirm Password *</label>
              <div className="relative">
                <Input 
                  placeholder="••••••••" 
                  type={showPasswordConfirmation ? 'text' : 'password'} 
                  value={createForm.password_confirmation} 
                  onChange={(e) => setCreateForm({ ...createForm, password_confirmation: e.target.value })} 
                  className={`flex-1 w-full rounded-xl border ${formErrors.password_confirmation ? 'border-red-500' : 'border-gray-300'} bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10 pr-10`} 
                />
                <button
                  type="button"
                  onClick={() => setShowPasswordConfirmation(!showPasswordConfirmation)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPasswordConfirmation ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              {formErrors.password_confirmation && <p className="text-red-500 text-xs mt-1">{formErrors.password_confirmation[0]}</p>}
            </div>
            <div>
              <label className="block text-sm text-gray-700 mb-1">Phone</label>
              <Input placeholder="09991234567" value={createForm.phone} onChange={(e) => setCreateForm({ ...createForm, phone: e.target.value })} className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10" />
            </div>
          </div>

          {/* Role-Specific Fields */}
          {createForm.role_id && Object.keys(formFields.roleSpecificFields).length > 0 && (
            <div className="border-t pt-4 mt-4">
              <h3 className="text-sm font-semibold text-gray-700 mb-4">
                {createForm.role_id === '359f4170-235d-11f1-9647-10683825ce81' ? 'Student Information' : createForm.role_id === '159ef712-235d-11f1-9647-10683825ce81' ? 'Adviser Information' : 'Teacher Information'}
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {Object.entries(formFields.roleSpecificFields).map(([fieldName, fieldConfig]) => (
                  <div key={fieldName} className={fieldConfig.type === 'select' ? (fieldName === 'adviser_id' ? 'md:col-span-2' : '') : ''}>
                    <label className="block text-sm text-gray-700 mb-1">
                      {fieldConfig.label}
                      {fieldConfig.required && ' *'}
                    </label>
                    {fieldConfig.type === 'text' || fieldConfig.type === 'email' || fieldConfig.type === 'tel' || fieldConfig.type === 'date' ? (
                      <Input
                        type={fieldConfig.type}
                        placeholder={fieldConfig.label}
                        value={createForm[fieldName] || ''}
                        onChange={(e) => setCreateForm({ ...createForm, [fieldName]: e.target.value })}
                        className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10"
                      />
                    ) : fieldConfig.type === 'select' ? (
                      <Select
                        value={createForm[fieldName] || ''}
                        onValueChange={(v) => setCreateForm({ ...createForm, [fieldName]: v })}
                        className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition h-10"
                      >
                        <SelectItem value="">Select {fieldConfig.label}</SelectItem>
                        {fieldConfig.options && Array.isArray(fieldConfig.options) ? (
                          // Array of strings (year levels, etc.)
                          fieldConfig.options.map((opt) => (
                            <SelectItem key={opt} value={opt}>
                              {opt}
                            </SelectItem>
                          ))
                        ) : fieldConfig.options && typeof fieldConfig.options === 'object' ? (
                          // Object with id:name pairs (advisers)
                          Object.entries(fieldConfig.options).map(([id, name]) => (
                            <SelectItem key={id} value={id.toString()}>
                              {name}
                            </SelectItem>
                          ))
                        ) : null}
                      </Select>
                    ) : null}
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        <div className="flex gap-3 pt-4 border-t mt-4">
          <Button variant="outline" onClick={() => {
            setShowPassword(false);
            setShowPasswordConfirmation(false);
            setShowCreateModal(false);
          }} className="flex-1 rounded-xl" disabled={isLoading}>
            Cancel
          </Button>
          <Button onClick={handleCreate} className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700" disabled={isLoading}>
            {isLoading ? 'Creating...' : 'Create'}
          </Button>
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

