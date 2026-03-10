import React, { useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge } from '@/Components/ui/badge';
import {
  Save,
  TrendingUp,
  Award,
  Plus,
  Edit,
  Trash2,
  Star,
  MessageSquare,
  Eye,
  Calendar,
  Trophy,
  X,
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

function Modal({ open, onClose, title, children }) {
  React.useEffect(() => {
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
        className="relative w-full max-w-md bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between p-6 border-b">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            <X className="w-6 h-6" />
          </button>
        </div>
        <div className="overflow-y-auto p-6">{children}</div>
      </div>
    </div>,
    document.body
  );
}

const defaultPointRules = [
  { id: 'rate_project', action: 'Rating a project', points: 10, icon: Star, color: 'text-yellow-600' },
  { id: 'comment', action: 'Commenting on a project', points: 5, icon: MessageSquare, color: 'text-blue-600' },
  { id: 'view_proof', action: 'Viewing proof documents', points: 2, icon: Eye, color: 'text-purple-600' },
  { id: 'attend_meeting', action: 'Participating in meetings', points: 15, icon: Calendar, color: 'text-green-600' },
  { id: 'badge_unlock', action: 'Unlocking a badge', points: 50, icon: Award, color: 'text-orange-600' },
];

const mockBadges = [
  {
    id: 1,
    name: 'First Steps',
    tier: 'Bronze',
    icon: '🎯',
    requirementType: 'ratings',
    requirementValue: 1,
    xpReward: 10,
  },
  {
    id: 2,
    name: 'Active Reviewer',
    tier: 'Silver',
    icon: '⭐',
    requirementType: 'ratings',
    requirementValue: 10,
    xpReward: 50,
  },
  {
    id: 3,
    name: 'Community Champion',
    tier: 'Gold',
    icon: '🏆',
    requirementType: 'ratings',
    requirementValue: 50,
    xpReward: 200,
  },
  {
    id: 4,
    name: 'Engagement Master',
    tier: 'Platinum',
    icon: '💎',
    requirementType: 'xp',
    requirementValue: 1000,
    xpReward: 500,
  },
];

export default function EngagementRulesPage() {
  const [pointRules, setPointRules] = useState(defaultPointRules);
  const [badges, setBadges] = useState(mockBadges);
  const [showBadgeModal, setShowBadgeModal] = useState(false);
  const [editingBadge, setEditingBadge] = useState(null);
  const [leaderboardVisible, setLeaderboardVisible] = useState(true);
  const [rankingAlgorithm, setRankingAlgorithm] = useState('xp');
  const [leaderboardTop, setLeaderboardTop] = useState('100');

  const [badgeForm, setBadgeForm] = useState({
    name: '',
    tier: 'Bronze',
    icon: '🎖️',
    requirementType: 'ratings',
    requirementValue: 0,
    xpReward: 0,
  });

  const handlePointChange = (id, value) => {
    setPointRules(
      pointRules.map((rule) =>
        rule.id === id ? { ...rule, points: value } : rule
      )
    );
  };

  const handleSavePoints = () => {
    showToast('Point rules saved successfully', 'success');
  };

  const handleSaveBadge = () => {
    if (!badgeForm.name || badgeForm.requirementValue === 0 || badgeForm.xpReward === 0) {
      showToast('Please fill in all required fields', 'error');
      return;
    }

    if (editingBadge) {
      setBadges(
        badges.map((b) =>
          b.id === editingBadge.id ? { ...editingBadge, ...badgeForm } : b
        )
      );
      showToast('Badge updated successfully', 'success');
    } else {
      const newBadge = {
        id: badges.length + 1,
        ...badgeForm,
      };
      setBadges([...badges, newBadge]);
      showToast('Badge created successfully', 'success');
    }

    setShowBadgeModal(false);
    setEditingBadge(null);
    setBadgeForm({
      name: '',
      tier: 'Bronze',
      icon: '🎖️',
      requirementType: 'ratings',
      requirementValue: 0,
      xpReward: 0,
    });
  };

  const handleDeleteBadge = (id) => {
    setBadges(badges.filter((b) => b.id !== id));
    showToast('Badge deleted', 'success');
  };

  const getTierColor = (tier) => {
    switch (tier) {
      case 'Bronze':
        return 'bg-orange-100 text-orange-700';
      case 'Silver':
        return 'bg-gray-100 text-gray-700';
      case 'Gold':
        return 'bg-yellow-100 text-yellow-700';
      case 'Platinum':
        return 'bg-purple-100 text-purple-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getRequirementLabel = (type) => {
    switch (type) {
      case 'ratings':
        return 'Ratings';
      case 'interactions':
        return 'Interactions';
      case 'xp':
        return 'XP Points';
      case 'projects':
        return 'Projects Viewed';
      default:
        return type;
    }
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Engagement Rules</h2>}>
      <Head title="Engagement Rules" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div>
              <h1 className="text-2xl font-semibold text-gray-900">Engagement Rules</h1>
              <p className="text-gray-500">Configure gamification and student engagement system</p>
            </div>

            {/* Points Rules Section */}
            <Card className="rounded-[20px] border-0 shadow-sm">
              <div className="p-6">
                <div className="flex flex-col sm:flex-row gap-4 items-center justify-between mb-6">
                  <div>
                    <h2 className="text-lg font-semibold text-gray-900 mb-1">Point Rules</h2>
                    <p className="text-sm text-gray-500">Define how students earn engagement points</p>
                  </div>
                  <Button
                    onClick={handleSavePoints}
                    className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white  lg:w-auto w-full"
                  >
                    <Save className="w-4 h-4 mr-2" />
                    Save Changes
                  </Button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {pointRules.map((rule) => {
                    const IconComponent = rule.icon;
                    return (
                      <div
                        key={rule.id}
                        className="p-4 border border-gray-200 rounded-xl hover:border-blue-300 transition-colors"
                      >
                        <div className="flex items-start gap-3">
                          <div className="w-10 h-10 bg-blue-50 rounded-lg flex items-center justify-center flex-shrink-0">
                            <IconComponent className={`w-5 h-5 ${rule.color}`} />
                          </div>
                          <div className="flex-1">
                            <p className="text-sm text-gray-900 mb-3">{rule.action}</p>
                            <div className="flex items-center gap-3">
                              <Input
                                type="number"
                                value={rule.points}
                                onChange={(e) => handlePointChange(rule.id, parseInt(e.target.value) || 0)}
                                className="w-24 h-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                                min="0"
                              />
                              <span className="text-sm text-gray-600">points</span>
                            </div>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </Card>

            {/* Badge Rules Section */}
            <Card className="rounded-[20px] border-0 shadow-sm">
              <div className="p-6">
                <div className="flex items-center justify-between mb-6 flex-col sm:flex-row gap-4">
                  <div>
                    <h2 className="text-lg font-semibold text-gray-900 mb-1">Badge System</h2>
                    <p className="text-sm text-gray-500">Manage achievement badges and requirements</p>
                  </div>
                  <Button
                    onClick={() => {
                      setEditingBadge(null);
                      setBadgeForm({
                        name: '',
                        tier: 'Bronze',
                        icon: '🎖️',
                        requirementType: 'ratings',
                        requirementValue: 0,
                        xpReward: 0,
                      });
                      setShowBadgeModal(true);
                    }}
                    className="rounded-xl bg-blue-600 hover:bg-blue-700 text-white lg:w-auto w-full"
                  >
                    <Plus className="w-4 h-4 mr-2" />
                    Create Badge
                  </Button>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                  {badges.map((badge) => (
                    <Card key={badge.id} className="rounded-xl p-4 border shadow-sm hover:shadow-md transition-all">
                      <div className="flex items-start justify-between mb-3">
                        <div className="flex items-center gap-3">
                          <span className="text-3xl">{badge.icon}</span>
                          <div>
                            <p className="text-sm font-medium text-gray-900">{badge.name}</p>
                            <Badge className={getTierColor(badge.tier)}>
                              {badge.tier}
                            </Badge>
                          </div>
                        </div>
                      </div>

                      <div className="space-y-2 mb-4">
                        <div className="flex items-center justify-between text-sm">
                          <span className="text-gray-600">Requirement:</span>
                          <span className="text-gray-900">
                            {badge.requirementValue} {getRequirementLabel(badge.requirementType)}
                          </span>
                        </div>
                        <div className="flex items-center justify-between text-sm">
                          <span className="text-gray-600">XP Reward:</span>
                          <span className="text-gray-900">{badge.xpReward} XP</span>
                        </div>
                      </div>

                      <div className="flex gap-2">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => {
                            setEditingBadge(badge);
                            setBadgeForm(badge);
                            setShowBadgeModal(true);
                          }}
                          className="flex-1 rounded-lg"
                        >
                          <Edit className="w-3 h-3 mr-1" />
                          Edit
                        </Button>
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => handleDeleteBadge(badge.id)}
                          className="rounded-lg text-red-600 hover:bg-red-50"
                        >
                          <Trash2 className="w-3 h-3" />
                        </Button>
                      </div>
                    </Card>
                  ))}
                </div>
              </div>
            </Card>

            {/* Leaderboard Settings */}
            <Card className="rounded-[20px] border-0 shadow-sm">
              <div className="p-6">
                <h2 className="text-lg font-semibold text-gray-900 mb-6">Leaderboard Settings</h2>

                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
                    <div>
                      <p className="text-sm font-medium text-gray-900">Enable Leaderboard</p>
                      <p className="text-xs text-gray-500">Show student rankings publicly</p>
                    </div>
                    <button
                      onClick={() => setLeaderboardVisible(!leaderboardVisible)}
                      className={`relative inline-flex h-8 w-14 items-center rounded-full transition-colors ${
                        leaderboardVisible ? 'bg-blue-600' : 'bg-gray-300'
                      }`}
                    >
                      <span
                        className={`inline-block h-6 w-6 transform rounded-full bg-white transition-transform ${
                          leaderboardVisible ? 'translate-x-7' : 'translate-x-1'
                        }`}
                      />
                    </button>
                  </div>

                  <div className="p-4 border border-gray-200 rounded-xl">
                    <label className="block text-sm font-medium text-gray-900 mb-2">Ranking Algorithm</label>
                    <select
                      value={rankingAlgorithm}
                      onChange={(e) => setRankingAlgorithm(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                    >
                      <option value="xp">Total XP Points</option>
                      <option value="badges">Badge Count</option>
                      <option value="combined">Combined Score</option>
                    </select>
                    <p className="text-xs text-gray-500 mt-2">How students are ranked on the leaderboard</p>
                  </div>

                  <div className="p-4 border border-gray-200 rounded-xl">
                    <label className="block text-sm font-medium text-gray-900 mb-2">Display Top</label>
                    <select
                      value={leaderboardTop}
                      onChange={(e) => setLeaderboardTop(e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
                    >
                      <option value="10">Top 10</option>
                      <option value="50">Top 50</option>
                      <option value="100">Top 100</option>
                      <option value="all">All Students</option>
                    </select>
                    <p className="text-xs text-gray-500 mt-2">Number of students shown on leaderboard</p>
                  </div>
                </div>
              </div>
            </Card>

            {/* Summary Stats */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-purple-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-purple-700">Total Badges</p>
                    <p className="text-2xl font-bold text-purple-900">{badges.length}</p>
                  </div>
                  <Award className="w-8 h-8 text-purple-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-blue-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-blue-700">Point Actions</p>
                    <p className="text-2xl font-bold text-blue-900">{pointRules.length}</p>
                  </div>
                  <TrendingUp className="w-8 h-8 text-blue-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-green-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-green-700">Avg Points/Action</p>
                    <p className="text-2xl font-bold text-green-900">
                      {Math.round(
                        pointRules.reduce((sum, r) => sum + r.points, 0) / pointRules.length
                      )}
                    </p>
                  </div>
                  <Star className="w-8 h-8 text-green-600" />
                </div>
              </Card>

              <Card className="rounded-[20px] p-4 border-0 shadow-sm bg-yellow-50">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-yellow-700">Leaderboard</p>
                    <p className="text-sm font-medium text-yellow-900">
                      {leaderboardVisible ? 'Enabled' : 'Disabled'}
                    </p>
                  </div>
                  <Trophy className="w-8 h-8 text-yellow-600" />
                </div>
              </Card>
            </div>
          </div>
        </div>
      </div>

      {/* Badge Modal */}
      <Modal
        open={showBadgeModal}
        onClose={() => setShowBadgeModal(false)}
        title={editingBadge ? 'Edit Badge' : 'Create New Badge'}
      >
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Badge Name *</label>
            <Input
              placeholder="e.g., Active Reviewer"
              value={badgeForm.name}
              onChange={(e) => setBadgeForm({ ...badgeForm, name: e.target.value })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Tier *</label>
            <select
              value={badgeForm.tier}
              onChange={(e) => setBadgeForm({ ...badgeForm, tier: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            >
              <option value="Bronze">Bronze</option>
              <option value="Silver">Silver</option>
              <option value="Gold">Gold</option>
              <option value="Platinum">Platinum</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Icon (Emoji) *</label>
            <Input
              placeholder="🏆"
              value={badgeForm.icon}
              onChange={(e) => setBadgeForm({ ...badgeForm, icon: e.target.value })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Requirement Type *</label>
            <select
              value={badgeForm.requirementType}
              onChange={(e) => setBadgeForm({ ...badgeForm, requirementType: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            >
              <option value="ratings">Number of Ratings</option>
              <option value="interactions">Total Interactions</option>
              <option value="xp">XP Points</option>
              <option value="projects">Projects Viewed</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">Requirement Value *</label>
            <Input
              type="number"
              placeholder="e.g., 10"
              value={badgeForm.requirementValue}
              onChange={(e) => setBadgeForm({ ...badgeForm, requirementValue: parseInt(e.target.value) || 0 })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-900 mb-2">XP Reward *</label>
            <Input
              type="number"
              placeholder="e.g., 50"
              value={badgeForm.xpReward}
              onChange={(e) => setBadgeForm({ ...badgeForm, xpReward: parseInt(e.target.value) || 0 })}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-gray-200 focus:border-gray-300"
            />
          </div>

          <div className="flex gap-3 pt-4">
            <Button
              variant="outline"
              onClick={() => setShowBadgeModal(false)}
              className="flex-1 rounded-xl"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSaveBadge}
              className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
            >
              {editingBadge ? 'Save Changes' : 'Create Badge'}
            </Button>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}

