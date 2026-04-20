import { useState, useRef, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { usePage, useForm, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { 
  User, 
  Mail, 
  School, 
  Calendar, 
  Award, 
  Star, 
  Trophy, 
  TrendingUp, 
  Key,
  LogOut,
  X,
} from 'lucide-react';
import { showToast } from '@/Pages/CSG/ProjectEdit';

// Edit Phone Modal Component - With Number Only Input
const EditPhoneModal = ({ isOpen, onClose, initialPhone, onSave, isSaving }) => {
  const [phoneInput, setPhoneInput] = useState(initialPhone);
  const [error, setError] = useState('');

  // Reset when modal opens or initialPhone changes
  useEffect(() => {
    if (isOpen) {
      setPhoneInput(initialPhone);
      setError('');
    }
  }, [isOpen, initialPhone]);

  // Function to validate and format phone number
  const handlePhoneChange = (e) => {
    let value = e.target.value;
    
    // Remove any non-digit characters
    const cleaned = value.replace(/\D/g, '');
    
    // Limit to 11 digits (Philippine mobile number format)
    const limited = cleaned.slice(0, 11);
    
    setPhoneInput(limited);
    
    // Validate phone number
    if (limited && limited.length > 0) {
      if (limited.length < 10) {
        setError('Phone number must be at least 10 digits');
      } else if (limited.length > 11) {
        setError('Phone number cannot exceed 11 digits');
      } else if (!limited.startsWith('09') && !limited.startsWith('9')) {
        setError('Phone number should start with 09 or 9');
      } else {
        setError('');
      }
    } else {
      setError('');
    }
  };

  const handleSave = (e) => {
    e.preventDefault();
    
    // Final validation before saving
    if (!phoneInput || phoneInput.length < 10) {
      setError('Please enter a valid phone number (at least 10 digits)');
      return;
    }
    
    if (phoneInput.length > 11) {
      setError('Phone number cannot exceed 11 digits');
      return;
    }
    
    // Format the phone number to start with 09 if it starts with 9
    let formattedPhone = phoneInput;
    if (formattedPhone.startsWith('9') && formattedPhone.length === 10) {
      formattedPhone = '0' + formattedPhone;
    }
    
    onSave(formattedPhone);
  };

  if (!isOpen) return null;

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50" onClick={onClose}>
      <Card className="w-full max-w-sm p-6 rounded-[20px] border-0 shadow-lg" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Edit Phone Number</h3>
          <button
            onClick={onClose}
            className="p-1 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-500" />
          </button>
        </div>
        <form onSubmit={handleSave} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Phone Number
            </label>
            <input
              type="tel"
              value={phoneInput}
              onChange={handlePhoneChange}
              onKeyPress={(e) => {
                // Allow only numbers
                if (!/[0-9]/.test(e.key)) {
                  e.preventDefault();
                }
              }}
              onPaste={(e) => {
                // Handle paste event to remove non-numbers
                e.preventDefault();
                const pastedText = e.clipboardData.getData('text');
                const numbersOnly = pastedText.replace(/\D/g, '');
                const limited = numbersOnly.slice(0, 11);
                setPhoneInput(limited);
              }}
              placeholder="09123456789"
              className={`w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors ${
                error ? 'border-red-500' : 'border-gray-300'
              }`}
              autoFocus
              inputMode="numeric"
              pattern="[0-9]*"
            />
            {error && (
              <p className="text-red-600 text-sm mt-1">{error}</p>
            )}
            <p className="text-gray-500 text-xs mt-1">
              Enter 10-11 digit mobile number (e.g., 09123456789)
            </p>
          </div>
          <div className="flex gap-2 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSaving || !!error || !phoneInput}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isSaving ? 'Saving...' : 'Save'}
            </button>
          </div>
        </form>
      </Card>
    </div>,
    document.body
  );
};

// Change Password Modal Component
const ChangePasswordModal = ({ isOpen, onClose, onSave, errors, isSaving }) => {
  const [passwordData, setPasswordData] = useState({
    current_password: '',
    password: '',
    password_confirmation: '',
  });

  // Reset when modal opens
  useEffect(() => {
    if (isOpen) {
      setPasswordData({
        current_password: '',
        password: '',
        password_confirmation: '',
      });
    }
  }, [isOpen]);

  const handleSubmit = (e) => {
    e.preventDefault();
    onSave(passwordData);
  };

  if (!isOpen) return null;

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/50" onClick={onClose}>
      <Card className="w-full max-w-sm p-6 rounded-[20px] border-0 shadow-lg" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Change Password</h3>
          <button
            onClick={onClose}
            className="p-1 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-gray-500" />
          </button>
        </div>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Current Password
            </label>
            <input
              type="password"
              value={passwordData.current_password}
              onChange={(e) => setPasswordData({ ...passwordData, current_password: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
              autoFocus
            />
            {errors.current_password && (
              <p className="text-red-600 text-sm mt-1">{errors.current_password}</p>
            )}
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              New Password
            </label>
            <input
              type="password"
              value={passwordData.password}
              onChange={(e) => setPasswordData({ ...passwordData, password: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
            />
            {errors.password && (
              <p className="text-red-600 text-sm mt-1">{errors.password}</p>
            )}
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Confirm Password
            </label>
            <input
              type="password"
              value={passwordData.password_confirmation}
              onChange={(e) => setPasswordData({ ...passwordData, password_confirmation: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
            />
            {errors.password_confirmation && (
              <p className="text-red-600 text-sm mt-1">{errors.password_confirmation}</p>
            )}
          </div>
          <div className="flex gap-2 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSaving}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
            >
              {isSaving ? 'Changing...' : 'Change Password'}
            </button>
          </div>
        </form>
      </Card>
    </div>,
    document.body
  );
};

// Main Profile Component
export default function StudentProfilePage({ onNavigate }) {
  const { props } = usePage();
  const [profileData, setProfileData] = useState(null);
  const [showEditPhoneModal, setShowEditPhoneModal] = useState(false);
  const [showChangePasswordModal, setShowChangePasswordModal] = useState(false);
  const accountInfoRef = useRef(null);
  
  // Form hooks for submission
  const phoneForm = useForm({ phone: '' });
  const passwordForm = useForm({
    current_password: '',
    password: '',
    password_confirmation: '',
  });

  // Initialize profile data from Laravel user
  useEffect(() => {
    const fallbackUser = {
      id: null,
      name: 'Guest User',
      email: 'guest@example.com',
      phone: 'Not provided',
      avatar_url: null,
      status: 'active',
      role: { name: 'Student', slug: 'student' },
      created_at: new Date().toISOString(),
      email_verified_at: null,
      profile_completed: false,
    };
    
    const laravelUser = props.auth?.user || fallbackUser;
    const roleData = laravelUser?.role;
    
    setProfileData({
      fullName: laravelUser?.name || 'Student',
      email: laravelUser?.email || '',
      picture: laravelUser?.avatar_url || null,
      phone: laravelUser?.phone || 'Not provided',
      role: roleData?.name || 'Student',
      roleSlug: roleData?.slug || '',
      status: laravelUser?.status || 'active',
      createdAt: laravelUser?.created_at,
      emailVerified: laravelUser?.email_verified_at,
      profileCompleted: laravelUser?.profile_completed,
      userId: laravelUser?.id,
      studentId: laravelUser?.student?.id || null,
      employeeId: laravelUser?.teacher?.id || null,
    });
  }, [props.auth?.user]);

  // Get activity icon based on type
  const getActivityIcon = (type) => {
    switch (type) {
      case 'rating': 
        return <Star className="w-5 h-5 text-yellow-600" />;
      case 'meeting': 
        return <Calendar className="w-5 h-5 text-blue-600" />;
      case 'comment': 
        return <Mail className="w-5 h-5 text-green-600" />;
      case 'badge': 
        return <Award className="w-5 h-5 text-purple-600" />;
      default: 
        return null;
    }
  };

  // Get activity background color based on type
  const getActivityBgColor = (type) => {
    switch (type) {
      case 'rating': 
        return 'bg-yellow-100';
      case 'meeting': 
        return 'bg-blue-100';
      case 'comment': 
        return 'bg-green-100';
      case 'badge': 
        return 'bg-purple-100';
      default: 
        return 'bg-gray-100';
    }
  };

  // Phone save handler
const handleSavePhone = (phoneNumber) => {
    router.patch(route('profile.phone.update'), { phone: phoneNumber }, {
        preserveScroll: true,
        onSuccess: () => {
            setProfileData(prev => ({ ...prev, phone: phoneNumber }));
            setShowEditPhoneModal(false);
            showToast('Phone number updated successfully!', 'success');
        },
        onError: (errors) => {
            const errorMessage = errors?.phone || 'Failed to update phone number.';
            showToast(errorMessage, 'error');
        },
    });
};

  // Password save handler
  const handleSavePassword = (passwordData) => {
    router.put(route('password.update'), passwordData, {
        preserveScroll: true,
        onSuccess: () => {
            setShowChangePasswordModal(false);
            showToast('Password changed successfully!', 'success');
        },
        onError: (errors) => {
            if (errors.current_password) {
                showToast('Current password is incorrect.', 'error');
            } else if (errors.password) {
                showToast(errors.password, 'error');
            } else {
                showToast('Failed to change password.', 'error');
            }
        },
    });
};

  return (
    <div className="space-y-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="text-gray-900 text-2xl font-semibold mb-2">Profile</h1>
        <p className="text-gray-500">Manage your account and view your progress</p>
      </div>

      {/* Profile Header Card */}
      <Card className="p-8 rounded-[20px] border-0 shadow-sm bg-gradient-to-br from-blue-900 to-blue-500 text-white">
        <div className="flex flex-col md:flex-row items-center gap-6">
          {/* Avatar */}
          {profileData?.picture ? (
            <img 
              src={profileData.picture} 
              alt={profileData.fullName}
              className="w-32 h-32 rounded-full border-4 border-white/30 shadow-xl flex-shrink-0 object-cover"
            />
          ) : (
            <div className="w-32 h-32 rounded-full bg-white/20 border-4 border-white/30 shadow-xl flex items-center justify-center text-4xl font-semibold flex-shrink-0">
              {profileData?.fullName?.split(' ').map(n => n[0]).join('').slice(0, 2)}
            </div>
          )}

          {/* User Info */}
          <div className="flex-1 text-center md:text-left">
            <h2 className="text-white font-semibold mb-2">{profileData?.fullName}</h2>
            <p className="text-blue-100 mb-4 flex items-center gap-2 justify-center md:justify-start">
              <Mail className="w-4 h-4" />
              {profileData?.email}
            </p>
            <div className="flex flex-wrap gap-2 justify-center md:justify-start">
              <Badge className="bg-blue-100 hover:bg-blue-100 text-blue-700 font-medium">
                {profileData?.role || 'Student'}
              </Badge>
              {profileData?.emailVerified && (
                <Badge className="bg-green-100 hover:bg-green-100 text-green-700">
                  ✓ Email Verified
                </Badge>
              )}
              {profileData?.profileCompleted && (
                <Badge className="bg-purple-100 hover:bg-purple-100 text-purple-700">
                  ✓ Profile Complete
                </Badge>
              )}
            </div>
          </div>
        </div>
      </Card>

      {/* Profile Information Card */}
      <div ref={accountInfoRef}>
        <Card className="p-6 rounded-[20px] border-0 shadow-sm">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-gray-900 text-xl font-semibold">Account Information</h2>
          </div>

          <div className="space-y-6">
            {/* Account Information Grid - Read Only */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <User className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Full Name</p>
                  <p className="text-gray-900 font-medium">{profileData?.fullName}</p>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Mail className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Email</p>
                  <p className="text-gray-900 font-medium">{profileData?.email}</p>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <School className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Role</p>
                  <p className="text-gray-900 font-medium capitalize">{profileData?.role || 'Student'}</p>
                </div>
              </div>

              {/* Student ID - Show if user is a student */}
              {profileData?.roleSlug === 'student' && (
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <User className="w-5 h-5 text-emerald-600" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Student ID</p>
                    <p className="text-gray-900 font-medium">{profileData?.studentId || 'Not set'}</p>
                  </div>
                </div>
              )}

              {/* Employee ID - Show if user is a teacher */}
              {profileData?.roleSlug === 'teacher' && (
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <User className="w-5 h-5 text-purple-600" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Employee ID</p>
                    <p className="text-gray-900 font-medium">{profileData?.employeeId || 'Not set'}</p>
                  </div>
                </div>
              )}

              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Calendar className="w-5 h-5 text-blue-600" />
                </div>
                <div className="flex-1 flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">Phone</p>
                    <p className="text-gray-900 font-medium">{profileData?.phone || 'Not provided'}</p>
                  </div>
                  <div>
                    <button
                      onClick={() => setShowEditPhoneModal(true)}
                      className="px-3 py-1 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-md text-sm font-medium transition-colors"
                    >
                      Edit Phone
                    </button>
                  </div>
                </div>
              </div>

              {/* Account Created Date */}
              {profileData?.createdAt && (
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0">
                    <Calendar className="w-5 h-5 text-green-600" />
                  </div>
                  <div>
                    <p className="text-sm text-gray-600">Account Created</p>
                    <p className="text-gray-900 font-medium">
                      {new Date(profileData.createdAt).toLocaleDateString('en-US', { 
                        year: 'numeric', 
                        month: 'long', 
                        day: 'numeric' 
                      })}
                    </p>
                    <p className="text-xs text-gray-500">
                      {new Date(profileData.createdAt).toLocaleTimeString()}
                    </p>
                  </div>
                </div>
              )}

              {/* Account Status */}
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <User className="w-5 h-5 text-purple-600" />
                </div>
                <div>
                  <p className="text-sm text-gray-600">Status</p>
                  <p className="text-gray-900 font-medium capitalize">{profileData?.status || 'active'}</p>
                </div>
              </div>
            </div>

            {/* Action Buttons */}
            <div className="pt-6 border-t flex flex-col sm:flex-row gap-3">
              <button
                onClick={() => setShowChangePasswordModal(true)}
                className="flex-1 px-4 py-3 bg-blue-50 hover:bg-blue-100 text-blue-600 rounded-xl font-medium transition-colors flex items-center justify-center gap-2"
              >
                <Key className="w-5 h-5" />
                Change Password
              </button>
            </div>
          </div>
        </Card>
      </div>

      {/* Quick Links */}
      {/* <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <button
          onClick={() => onNavigate('points')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-blue-300 hover:shadow-md transition-all text-left group"
        >
          <TrendingUp className="w-8 h-8 text-blue-600 mb-3 group-hover:scale-110 transition-transform" />
          <h3 className="text-gray-900 font-semibold mb-1">Points History</h3>
          <p className="text-sm text-gray-600">View your earning history</p>
        </button>

        <button
          onClick={() => onNavigate('badges')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-purple-300 hover:shadow-md transition-all text-left group"
        >
          <Award className="w-8 h-8 text-purple-600 mb-3 group-hover:scale-110 transition-transform" />
          <h3 className="text-gray-900 font-semibold mb-1">Badge Collection</h3>
          <p className="text-sm text-gray-600">See all your achievements</p>
        </button>

        <button
          onClick={() => onNavigate('leaderboard')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-yellow-300 hover:shadow-md transition-all text-left group"
        >
          <Trophy className="w-8 h-8 text-yellow-600 mb-3 group-hover:scale-110 transition-transform" />
          <h3 className="text-gray-900 font-semibold mb-1">Leaderboard</h3>
          <p className="text-sm text-gray-600">Check your ranking</p>
        </button>
      </div> */}

      {/* Logout Button */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm border border-red-200">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-gray-900 font-semibold mb-1">Sign Out</h3>
            <p className="text-sm text-gray-600">Sign out of your STEP account</p>
          </div>
          <button 
            onClick={() => router.post('/logout')}
            className="px-4 py-2 border border-red-300 text-red-600 hover:bg-red-50 rounded-xl font-medium flex items-center gap-2 transition-colors"
          >
            <LogOut className="w-4 h-4" />
            Logout
          </button>
        </div>
      </Card>

      {/* Modals */}
      <EditPhoneModal 
        isOpen={showEditPhoneModal}
        onClose={() => setShowEditPhoneModal(false)}
        initialPhone={profileData?.phone === 'Not provided' ? '' : profileData?.phone || ''}
        onSave={handleSavePhone}
        isSaving={phoneForm.processing}
      />
      
      <ChangePasswordModal 
        isOpen={showChangePasswordModal}
        onClose={() => setShowChangePasswordModal(false)}
        onSave={handleSavePassword}
        errors={passwordForm.errors}
        isSaving={passwordForm.processing}
      />
    </div>
  );
}