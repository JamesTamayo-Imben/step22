import { StudentDashboardHome } from './pages/StudentDashboardHome';
import { StudentProjectsPage } from './pages/StudentProjectsPage';
import { StudentMeetingsPage } from './pages/StudentMeetingsPage';
import { StudentPointsPage } from './pages/StudentPointsPage';
import { StudentBadgesPage } from './pages/StudentBadgesPage';
import { StudentLeaderboardPage } from './pages/StudentLeaderboardPage';
import { StudentNotificationsPage } from './pages/StudentNotificationsPage';
import { StudentProfilePage } from './pages/StudentProfilePage';

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