import React, { useEffect, useRef, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
import {
  Mail,
  Phone,
  MapPin,
  Calendar,
  Edit,
  Key,
  CheckCircle,
  Clock,
  XCircle,
  Upload,
  Lock,
  Users,
  Shield,
  Database,
  Activity,
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

function Modal({ open, onClose, title, description, children }) {
  useEffect(() => {
    if (!open) return undefined;
    const originalStyle = window.getComputedStyle(document.body).overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = originalStyle;
    };
  }, [open]);

  if (!open) return null;

  return ReactDOM.createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
      role="dialog"
      aria-modal="true"
    >
      <div
        className="relative w-full max-w-2xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between p-6 border-b">
          <div>
            <h3 className="text-lg font-semibold">{title}</h3>
            {description ? <p className="text-sm text-gray-500 mt-1">{description}</p> : null}
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            ✕
          </button>
        </div>
        <div className="overflow-y-auto p-6 pt-0">{children}</div>
      </div>
    </div>,
    document.body
  );
}

function FieldLabel({ children }) {
  return <label className="block text-sm text-gray-700 mb-1">{children}</label>;
}

function Textarea({ className = '', rows = 4, ...props }) {
  return (
    <textarea
      rows={rows}
      className={[
        'w-full px-3 py-2 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300',
        className,
      ].join(' ')}
      {...props}
    />
  );
}

function SAdminProfilePageInner() {
  const [showEditModal, setShowEditModal] = useState(false);
  const [showChangePasswordModal, setShowChangePasswordModal] = useState(false);
  const [showChangePhotoModal, setShowChangePhotoModal] = useState(false);
  const [photoPreview, setPhotoPreview] = useState(null);
  const fileInputRef = useRef(null);

  const [profile, setProfile] = useState({
    name: 'Super Admin',
    position: 'Super Administrator',
    email: 'superadmin@kld.edu.ph',
    phone: '+63 912 345 6789',
    bio: 'System administrator overseeing the entire STEP platform. Responsible for user management, system configuration, and ensuring optimal platform performance and security.',
    joinedDate: 'January 2026',
    department: 'System Administration',
    location: 'Kolehiyo ng Lungsod ng Dasmariñas',
    photo: null,
  });

  const [editForm, setEditForm] = useState({ ...profile });
  const [passwordForm, setPasswordForm] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });

  const activityStats = {
    usersManaged: 156,
    rolesCreated: 24,
    systemLogs: 1250,
    auditTrails: 892,
  };

  const recentActivities = [
    { id: 1, type: 'User', action: 'Created new user account', target: 'adviser@kld.edu.ph', date: '2024-11-20', status: 'Success' },
    { id: 2, type: 'Role', action: 'Updated user permissions', target: 'Adviser Role', date: '2024-11-20', status: 'Success' },
    { id: 3, type: 'System', action: 'System backup completed', target: 'Full Database Backup', date: '2024-11-20', status: 'Success' },
    { id: 4, type: 'Security', action: 'Password policy updated', target: 'System Settings', date: '2024-11-18', status: 'Success' },
  ];

  const handleEditProfile = () => {
    setProfile(editForm);
    setShowEditModal(false);
    showToast('Profile updated successfully', 'success');
  };

  const handleChangePassword = () => {
    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      showToast('Passwords do not match', 'error');
      return;
    }
    if (passwordForm.newPassword.length < 8) {
      showToast('Password must be at least 8 characters', 'error');
      return;
    }
    setShowChangePasswordModal(false);
    setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' });
    showToast('Password changed successfully', 'success');
  };

  const setPreviewFromFile = (file) => {
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      showToast('Please upload an image file (JPG or PNG)', 'error');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      showToast('Image size must be less than 5MB', 'error');
      return;
    }
    const reader = new FileReader();
    reader.onloadend = () => setPhotoPreview(reader.result);
    reader.readAsDataURL(file);
  };

  const handlePhotoChange = (e) => {
    const file = e.target.files && e.target.files[0];
    setPreviewFromFile(file);
  };

  const handleSavePhoto = () => {
    if (!photoPreview) return;
    setProfile((p) => ({ ...p, photo: photoPreview }));
    showToast('Profile photo updated successfully', 'success');
    setShowChangePhotoModal(false);
    setPhotoPreview(null);
    if (fileInputRef.current) fileInputRef.current.value = '';
  };

  const handleDragOver = (e) => e.preventDefault();
  const handleDrop = (e) => {
    e.preventDefault();
    const file = e.dataTransfer.files && e.dataTransfer.files[0];
    if (!file) return;
    setPreviewFromFile(file);
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'Success':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'Failed':
        return <XCircle className="w-4 h-4 text-red-600" />;
      case 'Pending':
        return <Clock className="w-4 h-4 text-yellow-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Success':
        return 'bg-green-100 text-green-700';
      case 'Failed':
        return 'bg-red-100 text-red-700';
      case 'Pending':
        return 'bg-yellow-100 text-yellow-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const initials = profile.name
    .split(' ')
    .filter(Boolean)
    .map((n) => n[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-gray-900">Profile</h1>
        <p className="text-gray-500">Manage your account information and settings</p>
      </div>

      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col md:flex-row gap-6">
          <div className="flex flex-col items-center gap-4">
            <Avatar className="w-32 h-32">
              {profile.photo ? (
                <img src={profile.photo} alt="Profile" className="w-full h-full object-cover" />
              ) : (
                <AvatarFallback className="bg-blue-600 text-white text-3xl">{initials}</AvatarFallback>
              )}
            </Avatar>
            <Button onClick={() => setShowChangePhotoModal(true)} variant="outline" className="rounded-xl">
              <Upload className="w-4 h-4 mr-2" />
              Change Photo
            </Button>
          </div>

          <div className="flex-1 space-y-4">
            <div>
              <h2 className="text-gray-900 text-xl font-semibold mb-1">{profile.name}</h2>
              <p className="text-blue-600">{profile.position}</p>
              <p className="text-sm text-gray-500 mt-1">Member since {profile.joinedDate}</p>
            </div>

            <p className="text-gray-600">{profile.bio}</p>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="flex items-center gap-3 text-sm text-gray-600">
                <Mail className="w-4 h-4" />
                <span>{profile.email}</span>
              </div>
              <div className="flex items-center gap-3 text-sm text-gray-600">
                <Phone className="w-4 h-4" />
                <span>{profile.phone}</span>
              </div>
              <div className="flex items-center gap-3 text-sm text-gray-600">
                <MapPin className="w-4 h-4" />
                <span>{profile.location}</span>
              </div>
              <div className="flex items-center gap-3 text-sm text-gray-600">
                <Calendar className="w-4 h-4" />
                <span>{profile.department}</span>
              </div>
            </div>

            <div className="flex gap-3">
              <Button
                onClick={() => {
                  setEditForm({ ...profile });
                  setShowEditModal(true);
                }}
                className="text-white rounded-xl bg-blue-600 hover:bg-blue-700"
              >
                <Edit className="w-4 h-4 mr-2" />
                Edit Profile
              </Button>
              <Button onClick={() => setShowChangePasswordModal(true)} variant="outline" className="rounded-xl">
                <Key className="w-4 h-4 mr-2" />
                Change Password
              </Button>
            </div>
          </div>
        </div>
      </Card>

      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <h2 className="text-gray-900 text-lg font-semibold mb-6">System Activity</h2>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-purple-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center mb-3">
              <Users className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.usersManaged}</p>
            <p className="text-sm text-gray-600">Users Managed</p>
          </div>

          <div className="bg-blue-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center mb-3">
              <Shield className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.rolesCreated}</p>
            <p className="text-sm text-gray-600">Roles Created</p>
          </div>

          <div className="bg-indigo-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-indigo-600 rounded-lg flex items-center justify-center mb-3">
              <Activity className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.systemLogs}</p>
            <p className="text-sm text-gray-600">System Logs</p>
          </div>

          <div className="bg-cyan-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-cyan-600 rounded-lg flex items-center justify-center mb-3">
              <Database className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.auditTrails}</p>
            <p className="text-sm text-gray-600">Audit Trails</p>
          </div>
        </div>
      </Card>

      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <h2 className="text-gray-900 text-lg font-semibold mb-6">Recent Activities</h2>

        <div className="space-y-3">
          {recentActivities.map((activity) => (
            <div
              key={activity.id}
              className="p-4 bg-gray-50 rounded-xl flex items-center justify-between hover:bg-gray-100 transition-all"
            >
              <div className="flex items-center gap-3 flex-1">
                {getStatusIcon(activity.status)}
                <div className="flex-1">
                  <p className="text-sm text-gray-900">{activity.action}</p>
                  <p className="text-xs text-gray-500">
                    {activity.type} • {activity.target} • {activity.date}
                  </p>
                </div>
              </div>
              <div className={`px-3 py-1 rounded-lg text-xs ${getStatusColor(activity.status)}`}>
                {activity.status}
              </div>
            </div>
          ))}
        </div>
      </Card>

      <Modal open={showEditModal} onClose={() => setShowEditModal(false)} title="Edit Profile">
        <div className="space-y-4 pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <FieldLabel>Full Name</FieldLabel>
              <Input
                value={editForm.name}
                onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Position</FieldLabel>
              <Input
                value={editForm.position}
                onChange={(e) => setEditForm({ ...editForm, position: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Email</FieldLabel>
              <Input
                type="email"
                value={editForm.email}
                onChange={(e) => setEditForm({ ...editForm, email: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Phone Number</FieldLabel>
              <Input
                value={editForm.phone}
                onChange={(e) => setEditForm({ ...editForm, phone: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Department</FieldLabel>
              <Input
                value={editForm.department}
                onChange={(e) => setEditForm({ ...editForm, department: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Location</FieldLabel>
              <Input
                value={editForm.location}
                onChange={(e) => setEditForm({ ...editForm, location: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>
          </div>

          <div>
            <FieldLabel>Bio</FieldLabel>
            <Textarea
              className="flex-1 w-full rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              value={editForm.bio}
              onChange={(e) => setEditForm({ ...editForm, bio: e.target.value })}
              rows={4}
            />
          </div>

          <div className="flex gap-3 pt-4">
            <Button variant="outline" onClick={() => setShowEditModal(false)} className="flex-1 rounded-xl">
              Cancel
            </Button>
            <Button onClick={handleEditProfile} className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700">
              Save Changes
            </Button>
          </div>
        </div>
      </Modal>

      <Modal open={showChangePasswordModal} onClose={() => setShowChangePasswordModal(false)} title="Change Password">
        <div className="space-y-4 pt-6">
          <div>
            <FieldLabel>Current Password</FieldLabel>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="password"
                placeholder="Minimum 8 characters"
                value={passwordForm.currentPassword}
                onChange={(e) => setPasswordForm({ ...passwordForm, currentPassword: e.target.value })}
                className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>
          </div>

          <div>
            <FieldLabel>New Password</FieldLabel>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="password"
                placeholder="••••••••"
                value={passwordForm.newPassword}
                onChange={(e) => setPasswordForm({ ...passwordForm, newPassword: e.target.value })}
                className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>
            <p className="text-xs text-gray-500 mt-1">Must be at least 8 characters</p>
          </div>

          <div>
            <FieldLabel>Confirm New Password</FieldLabel>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="password"
                placeholder="••••••••"
                value={passwordForm.confirmPassword}
                onChange={(e) => setPasswordForm({ ...passwordForm, confirmPassword: e.target.value })}
                className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>
          </div>

          <div className="flex gap-3 pt-4">
            <Button variant="outline" onClick={() => setShowChangePasswordModal(false)} className="flex-1 rounded-xl">
              Cancel
            </Button>
            <Button onClick={handleChangePassword} className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700">
              Change Password
            </Button>
          </div>
        </div>
      </Modal>

      <Modal
        open={showChangePhotoModal}
        onClose={() => {
          setShowChangePhotoModal(false);
          setPhotoPreview(null);
          if (fileInputRef.current) fileInputRef.current.value = '';
        }}
        title="Change Photo"
        description="Drag and drop or click to upload a new photo"
      >
        <div className="space-y-4 pt-6">
          <div className="flex flex-col items-center">
            <Avatar className="w-32 h-32">
              {photoPreview ? (
                <img src={photoPreview} alt="Profile" className="w-full h-full object-cover" />
              ) : (
                <AvatarFallback className="bg-blue-600 text-white text-3xl">{initials}</AvatarFallback>
              )}
            </Avatar>
          </div>

          <div className="flex flex-col items-center gap-3">
            <button
              type="button"
              className="w-full max-w-md border-2 border-dashed border-gray-300 rounded-xl p-10 flex flex-col items-center justify-center hover:bg-gray-50 transition"
              onClick={() => fileInputRef.current && fileInputRef.current.click()}
              onDragOver={handleDragOver}
              onDrop={handleDrop}
            >
              <Upload className="w-6 h-6 text-gray-500" />
              <p className="text-sm text-gray-600 mt-2">Click to upload</p>
              <p className="text-xs text-gray-500 mt-1">PNG/JPG up to 5MB</p>
            </button>

            <input
              ref={fileInputRef}
              type="file"
              accept="image/*"
              onChange={handlePhotoChange}
              className="hidden"
            />
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => {
                setShowChangePhotoModal(false);
                setPhotoPreview(null);
                if (fileInputRef.current) fileInputRef.current.value = '';
              }}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSavePhoto}
              disabled={!photoPreview}
              className="text-white flex-1 rounded-xl bg-blue-600 hover:bg-blue-700"
            >
              Save Changes
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  );
}

export default function SAdminProfilePage(props) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Profile</h2>}>
      <Head title="Super Admin Profile" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <SAdminProfilePageInner {...props} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

