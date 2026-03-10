import React from 'react';
import { Card } from '@/Components/ui/card';
import { StudentDashboardHome } from './pages/StudentDashboardHome';

function Placeholder({ title }) {
  return <Card className="p-8 rounded-[20px] border-0 shadow-sm bg-white">{title} (placeholder)</Card>;
}

function StudentProjectsPage() { return <Placeholder title="Projects" />; }
function StudentMeetingsPage() { return <Placeholder title="Meetings" />; }
function StudentPointsPage() { return <Placeholder title="Points" />; }
function StudentBadgesPage() { return <Placeholder title="Badges" />; }
function StudentLeaderboardPage() { return <Placeholder title="Leaderboard" />; }
function StudentNotificationsPage() { return <Placeholder title="Notifications" />; }
function StudentProfilePage() { return <Placeholder title="Profile" />; }

export function StudentDashboard({ currentView, onNavigate }) {
  switch (currentView) {
    case 'dashboard':
      return <StudentDashboardHome onNavigate={onNavigate} />;
    case 'projects':
      return <StudentProjectsPage onNavigate={onNavigate} />;
    case 'meetings':
      return <StudentMeetingsPage onNavigate={onNavigate} />;
    case 'points':
      return <StudentPointsPage onNavigate={onNavigate} />;
    case 'badges':
      return <StudentBadgesPage onNavigate={onNavigate} />;
    case 'leaderboard':
      return <StudentLeaderboardPage onNavigate={onNavigate} />;
    case 'notifications':
      return <StudentNotificationsPage onNavigate={onNavigate} />;
    case 'profile':
      return <StudentProfilePage onNavigate={onNavigate} />;
    default:
      return <StudentDashboardHome onNavigate={onNavigate} />;
  }
}