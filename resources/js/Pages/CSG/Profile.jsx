import React, { useEffect, useRef, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
import {
  User,
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
  Camera,
  Eye,
  Repeat,
  EyeOff,
  Save,
  ChevronLeft,
  ChevronRight,
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

function CSGProfilePageInner({ user }) {
  const [showEditModal, setShowEditModal] = useState(false);
  const [showChangePasswordModal, setShowChangePasswordModal] = useState(false);
  const [showChangePhotoModal, setShowChangePhotoModal] = useState(false);
  const [photoPreview, setPhotoPreview] = useState(null);
  const fileInputRef = useRef(null);

  const [profile, setProfile] = useState({
    firstName: user?.name?.split(' ')[0] || 'John',
    lastName: user?.name?.split(' ')[1] || 'Reyes',
    name: user?.name || 'John Reyes',
    email: user?.email || 'john.reyes@kld.edu.ph',
    phone: user?.phone || '+63 9123456789',
    //get the position 
    position: `CSG ${user?.student?.csg_position || 'President'}`,
    department: user?.student?.department || 'College of Engineering',
    joinDate: user?.created_at ? new Date(user.created_at).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }) : '2023-08-15',
    bio: user?.student?.bio || 'Passionate about student engagement and organizational excellence.',
    address: user?.student?.address || '123 Main Street, City, Province',
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
  const [recentActivity, setRecentActivity] = useState([]);
  const [activityLoading, setActivityLoading] = useState(true);
  const [activityPage, setActivityPage] = useState(1);
  const [activityTotalPages, setActivityTotalPages] = useState(1);

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
        const response = await fetch(`/csg/recent-activity?page=${activityPage}`, {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content'),
          },
        });

        if (response.ok) {
          const data = await response.json();
          setRecentActivity(data.activities || []);
          setActivityTotalPages(data.pagination?.last_page ?? 1);
        } else {
          console.error('Failed to fetch recent activity');
          setRecentActivity([]);
          setActivityTotalPages(1);
        }
      } catch (error) {
        console.error('Error fetching recent activity:', error);
        setRecentActivity([]);
        setActivityTotalPages(1);
      } finally {
        setActivityLoading(false);
      }
    };

    fetchRecentActivity();
  }, [activityPage]);

  const activityStats = {
    projectsCreated: 12,
    meetingsAttended: 24,
    proofsSubmitted: 36,
    ledgerEntries: 18,
  };

  const handleEditProfile = () => {
    setProfile({ 
      ...editForm,
      name: `${editForm.firstName} ${editForm.lastName}`,
    });
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
      const response = await fetch('/csg/change-password', {
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
    switch (status?.toLowerCase()) {
      case 'success':
      case 'approved':
      case 'completed':
        return <CheckCircle className="w-4 h-4 text-green-600" />;
      case 'failed':
      case 'rejected':
        return <XCircle className="w-4 h-4 text-red-600" />;
      case 'pending':
      case 'scheduled':
      case 'draft':
      case 'ongoing':
      case 'warning':
        return <Clock className="w-4 h-4 text-yellow-600" />;
      default:
        return null;
    }
  };

  const getStatusColor = (status) => {
    switch (status?.toLowerCase()) {
      case 'success':
      case 'approved':
      case 'completed':
        return 'bg-green-100 text-green-700';
      case 'failed':
      case 'rejected':
        return 'bg-red-100 text-red-700';
      case 'pending':
      case 'scheduled':
      case 'draft':
      case 'ongoing':
      case 'warning':
        return 'bg-yellow-100 text-yellow-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const formatTime = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);
    
    if (diffInSeconds < 60) return 'Just now';
    if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}m ago`;
    if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}h ago`;
    if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)}d ago`;
    
    return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
  };

  const initials = `${profile.firstName[0]}${profile.lastName[0]}`.toUpperCase();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-semibold text-blue-600">My Profile</h1>
        <p className="text-gray-500">Manage your personal information and account settings</p>
      </div>

      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col md:flex-row gap-6">
          <div className="flex flex-col items-center gap-4">
            <Avatar className="w-32 h-32">
              {profile.photo ? (
                <img src={profile.photo} alt="Profile" className="w-full h-full object-cover" />
              ) : (
                <AvatarFallback className="bg-gradient-to-br from-blue-400 to-blue-600 text-white text-3xl">
                  {initials}
                </AvatarFallback>
              )}
            </Avatar>
             <p className="text-blue-600">{profile.position}</p>
            {/* <Button onClick={() => setShowChangePhotoModal(true)} variant="outline" className="rounded-xl">
              <Camera className="w-4 h-4 mr-2" />
              Change Photo
            </Button> */}
          </div>

          <div className="flex-1 space-y-4">
            <div className="gap-2 text-center md:text-left">
              <h2 className="text-gray-900 text-xl font-semibold">
                {profile.firstName} {profile.lastName}
              </h2>
               <p className="text-sm text-gray-500">{profile.email}</p>
              {/* <p className="text-blue-600">{profile.position}</p> */}
              <p className="text-sm text-gray-500 mt-1">Member since {profile.joinDate}</p>
                <p className="text-gray-600 italic mt-2">"{profile.bio}"</p>
            </div>

          

          
            <div className="flex gap-3 justify-center md:justify-start">
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
              <Button onClick={() => setShowChangePasswordModal(true)} variant="outline" 
              className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white">
                <Key className="w-4 h-4 mr-2" />
                Change Password
              </Button>
               {/* <Button onClick={() => setShowChangePasswordModal(true)} variant="outline" className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white">
                 <Repeat className="w-5 h-5" />
                Switch Role
              </Button> */}
            </div>
          </div>
        </div>
      </Card>

     <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <h2 className="text-gray-900 text-lg font-semibold mb-6">Recent Activity</h2>

        {activityLoading ? (
          <div className="text-center py-8">
            <Clock className="w-10 h-10 text-gray-300 mx-auto mb-3 animate-pulse" />
            <p className="text-sm text-gray-500">Loading recent activity...</p>
          </div>
        ) : recentActivity.length > 0 ? (
          <>
            <div className="space-y-3">
              {recentActivity.map((activity) => (
                <div
                  key={activity.id}
                  className="p-4 bg-gray-50 rounded-xl flex items-center justify-between hover:bg-gray-100 transition-all"
                >
                  <div className="flex items-center gap-3 flex-1">
                    {getStatusIcon(activity.status)}
                    <div className="flex-1">
                      <p className="text-sm text-gray-900 font-medium">{activity.title}</p>
                      <p className="text-xs text-gray-500 mt-1">
                        {activity.type} • {formatTime(activity.date)}
                      </p>
                    </div>
                  </div>
                  <div className={`px-3 py-1 rounded-lg text-xs font-medium ${getStatusColor(activity.status)}`}>
                    {activity.status}
                  </div>
                </div>
              ))}
            </div>

            {activityTotalPages > 1 && (
              <div className="flex items-center justify-between border-t border-gray-200 mt-4 pt-4">
                <div className="flex flex-1 justify-between sm:hidden">
                  <Button
                    onClick={() => setActivityPage((prev) => Math.max(prev - 1, 1))}
                    disabled={activityPage === 1}
                    variant="outline"
                    className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Previous
                  </Button>
                  <Button
                    onClick={() => setActivityPage((prev) => Math.min(prev + 1, activityTotalPages))}
                    disabled={activityPage === activityTotalPages}
                    variant="outline"
                    className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Next
                  </Button>
                </div>
                <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                  <p className="text-sm text-gray-700">
                    Page <span className="font-medium">{activityPage}</span> of{' '}
                    <span className="font-medium">{activityTotalPages}</span>
                  </p>
                  <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Activity pagination">
                    <Button
                      onClick={() => setActivityPage((prev) => Math.max(prev - 1, 1))}
                      disabled={activityPage === 1}
                      variant="outline"
                      className="relative inline-flex items-center rounded-l-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Previous</span>
                      <ChevronLeft className="h-5 w-5" />
                    </Button>
                    {[...Array(activityTotalPages)].map((_, i) => {
                      const page = i + 1;
                      const isCurrentPage = page === activityPage;

                      if (
                        page === 1 ||
                        page === activityTotalPages ||
                        (page >= activityPage - 1 && page <= activityPage + 1)
                      ) {
                        return (
                          <Button
                            key={page}
                            onClick={() => setActivityPage(page)}
                            variant="outline"
                            className={`relative inline-flex items-center px-4 py-2 text-sm font-medium ${
                              isCurrentPage
                                ? 'z-10 bg-blue-600 text-white border-blue-600 hover:bg-blue-700'
                                : 'bg-white text-gray-700 hover:bg-gray-50'
                            }`}
                          >
                            {page}
                          </Button>
                        );
                      }

                      if (page === activityPage - 2 || page === activityPage + 2) {
                        return (
                          <span
                            key={page}
                            className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700"
                          >
                            ...
                          </span>
                        );
                      }

                      return null;
                    })}
                    <Button
                      onClick={() => setActivityPage((prev) => Math.min(prev + 1, activityTotalPages))}
                      disabled={activityPage === activityTotalPages}
                      variant="outline"
                      className="relative inline-flex items-center rounded-r-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Next</span>
                      <ChevronRight className="h-5 w-5" />
                    </Button>
                  </nav>
                </div>
              </div>
            )}
          </>
        ) : (
          <div className="text-center">
            <Calendar className="w-12 h-12 text-gray-300 mx-auto mb-3" />
            <p className="text-sm text-gray-500">No recent activity found</p>
            <p className="text-xs text-gray-400 mt-1 mb-4">
              Your recent actions and updates will appear here for quick reference.
            </p>
          </div>
        )}
      </Card>

      <Modal open={showEditModal} onClose={() => setShowEditModal(false)} title="Edit Profile">
        <div className="space-y-4 pt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <FieldLabel>First Name</FieldLabel>
              <Input
                value={editForm.firstName}
                onChange={(e) => setEditForm({ ...editForm, firstName: e.target.value })}
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
              />
            </div>

            <div>
              <FieldLabel>Last Name</FieldLabel>
              <Input
                value={editForm.lastName}
                onChange={(e) => setEditForm({ ...editForm, lastName: e.target.value })}
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
              <FieldLabel>Position</FieldLabel>
              <Input
                value={editForm.position}
                onChange={(e) => setEditForm({ ...editForm, position: e.target.value })}
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

            <div className="md:col-span-2">
              <FieldLabel>Address</FieldLabel>
              <Input
                value={editForm.address}
                onChange={(e) => setEditForm({ ...editForm, address: e.target.value })}
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
          </div>

          <div>
            <FieldLabel>New Password</FieldLabel>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
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
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
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
                <AvatarFallback className="bg-gradient-to-br from-blue-400 to-blue-600 text-white text-3xl">
                  {initials}
                </AvatarFallback>
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

export default function CSGProfilePage({ user }) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">My Profile</h2>}>
      <Head title="My Profile" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <CSGProfilePageInner user={user} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}