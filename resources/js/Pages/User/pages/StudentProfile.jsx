import { useState, useRef, useEffect } from 'react';
import { Inertia } from '@inertiajs/inertia';
import { usePage, useForm } from '@inertiajs/react';
import { useSupabase } from '@/context/SupabaseContext';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { Button } from '@/Components/ui/button';
import { 
  User, 
  Mail, 
  School, 
  Calendar, 
  Award, 
  Star, 
  Trophy, 
  TrendingUp, 
  Camera,
  Lock,
  Key,
  LogOut,
  X,
} from 'lucide-react';

const profileStats = [
  { label: 'Total Points', value: 500, icon: Star, color: 'text-yellow-600', bgColor: 'bg-yellow-100' },
  { label: 'Badges Earned', value: 12, icon: Award, color: 'text-purple-600', bgColor: 'bg-purple-100' },
  { label: 'Rank', value: '#24', icon: Trophy, color: 'text-blue-600', bgColor: 'bg-blue-100' },
  { label: 'Level', value: 5, icon: TrendingUp, color: 'text-green-600', bgColor: 'bg-green-100' },
];

const recentBadges = [
  { name: 'Active Participant', icon: '🌟', tier: 'Bronze', date: '2024-11-05' },
  { name: 'Project Supporter', icon: '🎯', tier: 'Silver', date: '2024-11-15' },
  { name: 'Meeting Regular', icon: '📅', tier: 'Bronze', date: '2024-11-10' },
  { name: 'Top Contributor', icon: '🏆', tier: 'Gold', date: '2024-11-24' },
  { name: 'Rising Star', icon: '⭐', tier: 'Silver', date: '2024-11-22' },
  { name: 'Team Player', icon: '🤝', tier: 'Bronze', date: '2024-11-12' },
];

const recentActivity = [
  { type: 'rating', description: 'Rated "Community Outreach Program"', date: '2024-11-24', points: 10 },
  { type: 'meeting', description: 'Attended "General Assembly"', date: '2024-11-22', points: 20 },
  { type: 'comment', description: 'Commented on "Sports Fest"', date: '2024-11-20', points: 5 },
  { type: 'badge', description: 'Earned "Top Contributor" Badge', date: '2024-11-24', points: 100 },
];

export default function StudentProfilePage({ onNavigate }) {
  const { props } = usePage();
  const [profileData, setProfileData] = useState(null);
  const [showEditPhoneModal, setShowEditPhoneModal] = useState(false);
  const [showChangePasswordModal, setShowChangePasswordModal] = useState(false);
  const accountInfoRef = useRef(null);

  // Initialize profile data from Laravel user (step2 database)
  // Use temporary/fallback data if no user is logged in (for development/testing)
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
    });
  }, [props.auth?.user]);

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

  // Edit Phone Modal Component
  const EditPhoneModal = () => {
    const [phoneInput, setPhoneInput] = useState(profileData?.phone || '');
    const [isSaving, setIsSaving] = useState(false);
    const { patch } = useForm({ phone: phoneInput });

    const handleSavePhone = (e) => {
      e.preventDefault();
      setIsSaving(true);
      patch(route('profile.update'), {
        onSuccess: () => {
          setProfileData(prev => ({ ...prev, phone: phoneInput }));
          setShowEditPhoneModal(false);
          setIsSaving(false);
        },
        onError: () => {
          setIsSaving(false);
        },
      });
    };

    return (
      <>
        {showEditPhoneModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
            <Card className="w-full max-w-sm p-6 rounded-[20px] border-0 shadow-lg">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-semibold text-gray-900">Edit Phone Number</h3>
                <button
                  onClick={() => setShowEditPhoneModal(false)}
                  className="p-1 hover:bg-gray-100 rounded-lg transition-colors"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
              <form onSubmit={handleSavePhone} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Phone Number
                  </label>
                  <input
                    type="text"
                    value={phoneInput}
                    onChange={(e) => setPhoneInput(e.target.value)}
                    placeholder="09xxxxxxxxx"
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
                  />
                </div>
                <div className="flex gap-2 pt-4">
                  <button
                    type="button"
                    onClick={() => setShowEditPhoneModal(false)}
                    className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={isSaving}
                    className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
                  >
                    {isSaving ? 'Saving...' : 'Save'}
                  </button>
                </div>
              </form>
            </Card>
          </div>
        )}
      </>
    );
  };

  // Change Password Modal Component
  const ChangePasswordModal = () => {
    const [passwordData, setPasswordData] = useState({
      current_password: '',
      password: '',
      password_confirmation: '',
    });
    const [errors, setErrors] = useState({});
    const [isSaving, setIsSaving] = useState(false);
    const { put } = useForm(passwordData);

    const handleChangePassword = (e) => {
      e.preventDefault();
      setErrors({});
      setIsSaving(true);
      
      put(route('password.update'), {
        preserveScroll: true,
        onSuccess: () => {
          setPasswordData({
            current_password: '',
            password: '',
            password_confirmation: '',
          });
          setShowChangePasswordModal(false);
          setIsSaving(false);
        },
        onError: (err) => {
          setErrors(err);
          setIsSaving(false);
        },
      });
    };

    return (
      <>
        {showChangePasswordModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
            <Card className="w-full max-w-sm p-6 rounded-[20px] border-0 shadow-lg">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-semibold text-gray-900">Change Password</h3>
                <button
                  onClick={() => setShowChangePasswordModal(false)}
                  className="p-1 hover:bg-gray-100 rounded-lg transition-colors"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
              <form onSubmit={handleChangePassword} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Current Password
                  </label>
                  <input
                    type="password"
                    value={passwordData.current_password}
                    onChange={(e) => setPasswordData({ ...passwordData, current_password: e.target.value })}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-colors"
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
                    onClick={() => setShowChangePasswordModal(false)}
                    className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    disabled={isSaving}
                    className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
                  >
                    {isSaving ? 'Saving...' : 'Change'}
                  </button>
                </div>
              </form>
            </Card>
          </div>
        )}
      </>
    );
  };

  return (
    <div className="space-y-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="text-gray-900 text-2xl font-semibold mb-2">Profile</h1>
        <p className="text-gray-500">Manage your account and view your progress</p>
      </div>

      {/* Profile Header Card */}
      <Card className="p-8 rounded-[20px] border-0 shadow-sm bg-gradient-to-br from-blue-600 to-purple-600 text-white">
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

      {/* Stats Grid */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {profileStats.map((stat) => {
          const Icon = stat.icon;
          return (
            <Card key={stat.label} className="p-6 rounded-[20px] border-0 shadow-sm text-center">
              <div className={`w-12 h-12 ${stat.bgColor} rounded-xl flex items-center justify-center mx-auto mb-3`}>
                <Icon className={`w-6 h-6 ${stat.color}`} />
              </div>
              <p className="text-2xl text-gray-900 font-semibold mb-1">{stat.value}</p>
              <p className="text-xs text-gray-600">{stat.label}</p>
            </Card>
          );
        })}
      </div>

      {/* Profile Information Card */}
      <div ref={accountInfoRef}>
        <Card className="p-6 rounded-[20px] border-0 shadow-sm">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-gray-900 text-xl font-semibold">Account Information</h2>
          </div>

          <div className="space-y-6">
            {/* Profile picture / upload removed as per requested UI simplification */}

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
                    <p className="text-gray-900 font-medium">{new Date(profileData.createdAt).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })}</p>
                    <p className="text-xs text-gray-500">{new Date(profileData.createdAt).toLocaleTimeString()}</p>
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
              {/* Two-factor authentication removed from this view per request */}
            </div>
          </div>
        </Card>
      </div>

      {/* Recent Badges */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-gray-900 text-xl font-semibold">Recent Badges</h2>
          <button
            onClick={() => onNavigate('badges')}
            className="text-sm text-blue-600 hover:text-blue-700 font-medium transition-colors"
          >
            View All
          </button>
        </div>
        <div className="grid grid-cols-3 md:grid-cols-6 gap-3">
          {recentBadges.map((badge, index) => (
            <div key={index} className="text-center">
              <div className="w-16 h-16 mx-auto mb-2 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-2xl shadow-md">
                {badge.icon}
              </div>
              <p className="text-xs text-gray-900 mb-1 line-clamp-1 font-medium">{badge.name}</p>
              <Badge variant="secondary" className="text-xs">
                {badge.tier}
              </Badge>
            </div>
          ))}
        </div>
      </Card>

      {/* Recent Activity */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-gray-900 text-xl font-semibold">Recent Activity</h2>
          <button
            onClick={() => onNavigate('points')}
            className="text-sm text-blue-600 hover:text-blue-700 font-medium transition-colors"
          >
            View All
          </button>
        </div>
        <div className="space-y-3">
          {recentActivity.map((activity, index) => (
            <div key={index} className="flex items-center gap-4 p-3 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
              <div className={`w-10 h-10 ${getActivityBgColor(activity.type)} rounded-lg flex items-center justify-center flex-shrink-0`}>
                {getActivityIcon(activity.type)}
              </div>
              <div className="flex-1">
                <p className="text-sm text-gray-900 font-medium">{activity.description}</p>
                <p className="text-xs text-gray-500">
                  {new Date(activity.date).toLocaleDateString('en-US', { 
                    month: 'short', 
                    day: 'numeric', 
                    year: 'numeric' 
                  })}
                </p>
              </div>
              <Badge className="bg-blue-600 hover:bg-blue-600 text-white">
                +{activity.points} pts
              </Badge>
            </div>
          ))}
        </div>
      </Card>

      {/* Quick Links */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <button
          onClick={() => onNavigate('points')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-blue-300 hover:shadow-md transition-all text-left"
        >
          <TrendingUp className="w-8 h-8 text-blue-600 mb-3" />
          <h3 className="text-gray-900 font-semibold mb-1">Points History</h3>
          <p className="text-sm text-gray-600">View your earning history</p>
        </button>

        <button
          onClick={() => onNavigate('badges')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-purple-300 hover:shadow-md transition-all text-left"
        >
          <Award className="w-8 h-8 text-purple-600 mb-3" />
          <h3 className="text-gray-900 font-semibold mb-1">Badge Collection</h3>
          <p className="text-sm text-gray-600">See all your achievements</p>
        </button>

        <button
          onClick={() => onNavigate('leaderboard')}
          className="p-6 bg-white rounded-[20px] border border-gray-200 hover:border-yellow-300 hover:shadow-md transition-all text-left"
        >
          <Trophy className="w-8 h-8 text-yellow-600 mb-3" />
          <h3 className="text-gray-900 font-semibold mb-1">Leaderboard</h3>
          <p className="text-sm text-gray-600">Check your ranking</p>
        </button>
      </div>

      {/* Logout Button */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm border border-red-200">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-gray-900 font-semibold mb-1">Sign Out</h3>
            <p className="text-sm text-gray-600">Sign out of your STEP account</p>
          </div>
          <button 
            onClick={() => Inertia.post(route('logout'))}
            className="px-4 py-2 border border-red-300 text-red-600 hover:bg-red-50 rounded-xl font-medium flex items-center gap-2 transition-colors"
          >
            <LogOut className="w-4 h-4" />
            Logout
          </button>
        </div>
      </Card>

      {/* Modals */}
      <EditPhoneModal />
      <ChangePasswordModal />
    </div>
  );
}
