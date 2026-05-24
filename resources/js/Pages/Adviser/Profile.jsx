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
  Eye,
  EyeOff,
  Lock,
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
        'w-full px-3 py-2 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      {...props}
    />
  );
}

function AdviserProfilePageInner({ user }) {
  const [showEditModal, setShowEditModal] = useState(false);
  const [showChangePasswordModal, setShowChangePasswordModal] = useState(false);
  const [showChangePhotoModal, setShowChangePhotoModal] = useState(false);
  const [photoPreview, setPhotoPreview] = useState(null);
  const fileInputRef = useRef(null);
  const [recentActivity, setRecentActivity] = useState([]);
  const [activityLoading, setActivityLoading] = useState(true);

  const [profile, setProfile] = useState({
    name: user?.name || 'Admin User',
    position: user?.role?.name === 'admin' ? 'Admin & Adviser' : 'Adviser',
    email: user?.email || 'admin@kld.edu.ph',
    phone: user?.phone || '+63 912 345 6789',
    bio: user?.teacher?.bio || 'Dedicated adviser committed to transparency and excellence in student governance. Overseeing approval processes and ensuring compliance with university policies.',
    joinedDate: user?.created_at ? new Date(user.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long' }) : 'January 2026',
    department: user?.teacher?.department || 'Student Affairs Office',
    location: user?.teacher?.location || 'Kolehiyo ng Lungsod ng Dasmariñas',
    photo: user?.avatar_url || null,
  });

  const [editForm, setEditForm] = useState({ ...profile });
  const [passwordForm, setPasswordForm] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });
  const [showPasswords, setShowPasswords] = useState({
      currentPassword: false,
      newPassword: false,
      confirmPassword: false,
    });
  
    useEffect(() => {
    if (!showChangePasswordModal) {
      setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' });
      setShowPasswords({ currentPassword: false, newPassword: false, confirmPassword: false });
    }
  }, [showChangePasswordModal]);

  useEffect(() => {
    const fetchRecentActivity = async () => {
      try {
        setActivityLoading(true);
        const response = await fetch('/adviser/recent-activity', {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'),
          },
        });

        if (response.ok) {
          const data = await response.json();
          setRecentActivity(data.activities || []);
        } else {
          console.error('Failed to fetch recent activity');
          setRecentActivity([]);
        }
      } catch (error) {
        console.error('Error fetching recent activity:', error);
        setRecentActivity([]);
      } finally {
        setActivityLoading(false);
      }
    };

    fetchRecentActivity();
  }, []);

  const activityStats = {
    projectsApproved: 24,
    ledgerApproved: 58,
    proofsValidated: 42,
    meetingsReviewed: 15,
  };

  const handleEditProfile = () => {
    setProfile(editForm);
    setShowEditModal(false);
    showToast('Profile updated successfully', 'success');
  };

  const handleChangePassword = async () => {
    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      showToast('Passwords do not match', 'error');
      return;
    }
    if (passwordForm.newPassword.length < 8) {
      showToast('Password must be at least 8 characters', 'error');
      return;
    }

    try {
      const response = await fetch('/adviser/change-password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'),
        },
        body: JSON.stringify({
          current_password: passwordForm.currentPassword,
          new_password: passwordForm.newPassword,
          new_password_confirmation: passwordForm.confirmPassword,
        }),
      });

      if (!response.ok) {
        const error = await response.json();
        showToast(error.message || 'Failed to change password', 'error');
        return;
      }

      setShowChangePasswordModal(false);
      setPasswordForm({ currentPassword: '', newPassword: '', confirmPassword: '' });
      showToast('Password changed successfully', 'success');
    } catch (error) {
      showToast('An error occurred while changing password', 'error');
    }
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
      case 'Approved':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'Rejected':
        return <XCircle className="w-4 h-4 text-red-600" />;
      case 'Pending':
      case 'Ongoing':
        return <Clock className="w-4 h-4 text-yellow-600" />;
      case 'Completed':
        return <CheckCircle className="w-4 h-4 text-blue-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'Approved':
      case 'Completed':
        return 'bg-green-100 text-green-700';
      case 'Rejected':
        return 'bg-red-100 text-red-700';
      case 'Pending':
      case 'Ongoing':
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
            {/* <Button onClick={() => setShowChangePhotoModal(true)} variant="outline" className="rounded-xl">
              <Upload className="w-4 h-4 mr-2" />
              Change Photo
            </Button> */}
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
              {/* <div className="flex items-center gap-3 text-sm text-gray-600">
                <Phone className="w-4 h-4" />
                <span>{profile.phone}</span>
              </div> */}
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
              {/* <Button
                onClick={() => {
                  setEditForm({ ...profile });
                  setShowEditModal(true);
                }}
                className="text-white rounded-xl bg-blue-600 hover:bg-blue-700"
              >
                <Edit className="w-4 h-4 mr-2" />
                Edit Profile
              </Button> */}
              <Button onClick={() => setShowChangePasswordModal(true)} variant="outline" className="rounded-xl">
                <Key className="w-4 h-4 mr-2" />
                Change Password
              </Button>
            </div>
          </div>
        </div>
      </Card>

      {/* <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <h2 className="text-gray-900 text-lg font-semibold mb-6">Approval Activity</h2>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div className="bg-blue-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center mb-3">
              <CheckCircle className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.projectsApproved}</p>
            <p className="text-sm text-gray-600">Projects Approved</p>
          </div>

          <div className="bg-green-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-green-600 rounded-lg flex items-center justify-center mb-3">
              <CheckCircle className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.ledgerApproved}</p>
            <p className="text-sm text-gray-600">Ledger Approved</p>
          </div>

          <div className="bg-purple-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center mb-3">
              <CheckCircle className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.proofsValidated}</p>
            <p className="text-sm text-gray-600">Proofs Validated</p>
          </div>

          <div className="bg-orange-50 rounded-xl p-4">
            <div className="w-10 h-10 bg-orange-600 rounded-lg flex items-center justify-center mb-3">
              <CheckCircle className="w-5 h-5 text-white" />
            </div>
            <p className="text-2xl text-gray-900 mb-1">{activityStats.meetingsReviewed}</p>
            <p className="text-sm text-gray-600">Meetings Reviewed</p>
          </div>
        </div>
      </Card> */}

      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <h2 className="text-gray-900 text-lg font-semibold mb-6">Recent Activity</h2>

        {recentActivity.length > 0 ? (
          <div className="space-y-3">
            {recentActivity.map((activity) => (
              <div
                key={activity.id}
                className="p-4 bg-gray-50 rounded-xl flex items-center justify-between hover:bg-gray-100 transition-all"
              >
                <div className="flex items-center gap-3 flex-1">
                  {getStatusIcon(activity.status)}
                  <div>
                    <p className="text-sm text-gray-900">{activity.title}</p>
                    <p className="text-xs text-gray-500">
                      {activity.type} • {new Date(activity.date).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}
                    </p>
                  </div>
                </div>
                <div className={`px-3 py-1 rounded-lg text-xs ${getStatusColor(activity.status)}`}>
                  {activity.status}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="text-center">
            <Calendar className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-sm text-gray-500">No recent activity found</p>
            <p className="text-xs text-gray-400 mt-1 mb-4">
              Your approvals and actions will appear here for quick reference.
            </p>
          </div>
        )}
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
  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 z-10" />
  <input
    type={showPasswords.currentPassword ? "text" : "password"}
    placeholder="••••••••"
    value={passwordForm.currentPassword}
    onChange={(e) => setPasswordForm({ ...passwordForm, currentPassword: e.target.value })}
    className="w-full h-10 pl-9 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
    autoFocus
  />
  <button
    type="button"
    onClick={() => setShowPasswords({ ...showPasswords, currentPassword: !showPasswords.currentPassword })}
    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
  >
    {showPasswords.currentPassword ? <EyeOff size={18} /> : <Eye size={18} />}
  </button>
</div>
            
          </div>

          <div>
            <FieldLabel>New Password</FieldLabel>
           <div className="relative">
  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 z-10" />
  <input
    type={showPasswords.newPassword ? "text" : "password"}
    placeholder="••••••••"
    value={passwordForm.newPassword}
    onChange={(e) => setPasswordForm({ ...passwordForm, newPassword: e.target.value })}
    className="w-full h-10 pl-9 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
  />
  <button
    type="button"
    onClick={() => setShowPasswords({ ...showPasswords, newPassword: !showPasswords.newPassword })}
    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
  >
    {showPasswords.newPassword ? <EyeOff size={18} /> : <Eye size={18} />}
  </button>
</div>
            
            <p className="text-xs text-gray-500 mt-1">Must be at least 8 characters</p>
          </div>

          <div>
            <FieldLabel>Confirm New Password</FieldLabel>
            <div className="relative">
  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 z-10" />
  <input
    type={showPasswords.confirmPassword ? "text" : "password"}
    placeholder="••••••••"
    value={passwordForm.confirmPassword}
    onChange={(e) => setPasswordForm({ ...passwordForm, confirmPassword: e.target.value })}
    className="w-full h-10 pl-9 pr-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
  />
  <button
    type="button"
    onClick={() => setShowPasswords({ ...showPasswords, confirmPassword: !showPasswords.confirmPassword })}
    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-700"
  >
    {showPasswords.confirmPassword ? <EyeOff size={18} /> : <Eye size={18} />}
  </button>
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

export default function AdviserProfilePage({ user }) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Profile</h2>}>
      <Head title="Adviser Profile" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <AdviserProfilePageInner user={user} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

