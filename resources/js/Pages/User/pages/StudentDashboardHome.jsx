import { usePage } from '@inertiajs/react';
import { useState } from 'react';
import { TrendingUp, Award, Trophy, FolderKanban, Calendar, Star, Target, Zap, ChevronLeft, ChevronRight } from 'lucide-react';
import { Chatbot } from '@/Components/ui/Chatbot';

export function StudentDashboardHome({
  onNavigate,
  onViewProject,
  stats = {},
  activeProjects = [],
  recentBadges = [],
  upcomingMeetings = [],
  leaderboardSummary = null,
}) {
  const { props } = usePage();
  const userPermissions = Array.isArray(props?.userPermissions)
    ? props.userPermissions
    : Array.isArray(props?.auth?.permissions)
      ? props.auth.permissions
      : [];
  const canViewProjects = userPermissions.includes('projects.view');
  const canViewMeetings = userPermissions.includes('meetings.view');
  const canViewRatings = userPermissions.includes('ratings.view');
  // const canViewNotifications = userPermissions.includes('notifications.view');

  const [calendarMonth, setCalendarMonth] = useState(() => {
    const today = new Date();
    return new Date(today.getFullYear(), today.getMonth(), 1);
  });

  const parseProjectDate = (value) => {
    if (!value || value === 'TBD') return null;
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
  };

  const calendarDays = (() => {
    const year = calendarMonth.getFullYear();
    const month = calendarMonth.getMonth();
    const firstWeekday = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const cells = Array.from({ length: firstWeekday }, (_, index) => ({ key: `blank-${index}` }));

    for (let day = 1; day <= daysInMonth; day += 1) {
      const date = new Date(year, month, day);
      const projectsStarting = (activeProjects || []).filter((project) => {
        const startDate = parseProjectDate(project.startDate);
        return startDate && startDate.getFullYear() === year && startDate.getMonth() === month && startDate.getDate() === day;
      });
      const projectsEnding = (activeProjects || []).filter((project) => {
        const endDate = parseProjectDate(project.deadline);
        return endDate && endDate.getFullYear() === year && endDate.getMonth() === month && endDate.getDate() === day;
      });

      cells.push({ key: date.toISOString(), day, projectsStarting, projectsEnding });
    }

    return cells;
  })();

  const calendarMonthLabel = calendarMonth.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
  const shiftCalendarMonth = (amount) => {
    setCalendarMonth((currentMonth) => new Date(currentMonth.getFullYear(), currentMonth.getMonth() + amount, 1));
  };

const getStatusColor = (status) => {
  switch (status) { 
    case 'Draft': return 'bg-gray-100 text-gray-700';
    case 'Upcoming': return 'bg-purple-100 text-purple-700';
    case 'Pending Adviser Approval': return 'bg-yellow-100 text-yellow-700';
    case 'Approved':
    case 'Ongoing': return 'bg-blue-100 text-blue-700';
    case 'Completed': return 'bg-green-100 text-green-700';
    case 'Rejected': return 'bg-red-100 text-red-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};


  return ( 
    <div className="space-y-6 pb-6">
      {/* Welcome Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 rounded-[20px] p-8 text-white shadow-lg">
        <h1 className="text-white mb-2">Welcome back, {stats.name || 'User'}!</h1>
        <p className="text-blue-100">Track your progress and stay updated</p>

        {/* <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4">
            <TrendingUp className="w-6 h-6 mb-2" />
            <p className="text-2xl mb-1">500</p>
            <p className="text-xs text-blue-100">Total Points</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4">
            <Award className="w-6 h-6 mb-2" />
            <p className="text-2xl mb-1">{stats.badgesEarned ?? 0}</p>
            <p className="text-xs text-blue-100">Badges Earned</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4">
            <Trophy className="w-6 h-6 mb-2" />
            <p className="text-2xl mb-1">{stats.leaderboardRank ? `#${stats.leaderboardRank}` : '-'}</p>
            <p className="text-xs text-blue-100">Leaderboard Rank</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-4">
            <Star className="w-6 h-6 mb-2" />
            <p className="text-2xl mb-1">Level {stats.engagementLevel ?? (leaderboardSummary?.level || 1)}</p>
            <p className="text-xs text-blue-100">Engagement Level</p>
          </div>
        </div> */}
      </div>

      {/* Quick Actions */}
      <div className={`grid grid-cols-1 gap-4 ${canViewProjects && canViewMeetings ? 'md:grid-cols-2' : ''}`}>
        {canViewProjects && (
          <button
            onClick={() => onNavigate('projects')}
            className="p-4 bg-white rounded-[20px] border border-gray-200 hover:border-blue-300 hover:shadow-md transition-all text-left"
          >
            <FolderKanban className="w-8 h-8 text-blue-600 mb-2" />
            <p className="text-sm text-gray-900">View Projects</p>
            <p className="text-xs text-gray-500 mt-1">{stats.activeProjectsCount ?? activeProjects.length} active</p>
          </button>
        )}

        {canViewMeetings && (
          <button
            onClick={() => onNavigate('meetings')}
            className="p-4 bg-white rounded-[20px] border border-gray-200 hover:border-blue-300 hover:shadow-md transition-all text-left"
          >
            <Calendar className="w-8 h-8 text-blue-600 mb-2" />
            <p className="text-sm text-gray-900">Meetings</p>
            <p className="text-xs text-gray-500 mt-1">{stats.upcomingMeetingsCount ?? upcomingMeetings.length} upcoming</p>
          </button>
        )}

        {/* <button
          onClick={() => onNavigate('points')}
          className="p-4 bg-white rounded-[20px] border border-gray-200 hover:border-purple-300 hover:shadow-md transition-all text-left"
        >
          <Zap className="w-8 h-8 text-purple-600 mb-2" />
          <p className="text-sm text-gray-900">My Points</p>
          <p className="text-xs text-gray-500 mt-1">View history</p>
        </button> */}
      </div>

      {/* Active Projects */}
      {canViewProjects && (
      <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-gray-900">Active Projects</h2>
          <button
            onClick={() => onNavigate('projects')}
            className="text-sm text-blue-600 hover:underline"
          >
            View All
          </button>
        </div>

       <div className="grid grid-cols-2 gap-3">
         {/* <div className="space-y-3"> */}
          {(activeProjects || []).map((project, index) => {
            const isLocked = !!project?.isTampered || !!project?.isBudgetMismatch;
            const lockTitle = project?.isTampered
              ? 'This project is locked due to tampered ledger records.'
              : project?.isBudgetMismatch
              ? 'This project is locked due to a budget mismatch.'
              : undefined;
            const lockMessage = project?.isTampered
              ? 'Locked: Project ledger tampering detected.'
              : project?.isBudgetMismatch
              ? 'Locked: Budget mismatch detected.'
              : null;

            return (
              <button
                key={index}
                onClick={() => {
                  if (isLocked) return;
                  onViewProject?.(project.id);
                }}
                disabled={isLocked}
                title={lockTitle}
                className={`w-full text-left p-4 rounded-xl transition-colors ${
                  isLocked
                    ? 'bg-red-50 cursor-not-allowed opacity-70'
                    : 'bg-gray-50 hover:bg-gray-100 cursor-pointer'
                }`}
              >
                <div className="flex items-start justify-between mb-2">
                  <div className="flex-1">
                    <p className="text-sm text-gray-900 mb-1">{project.title}</p>
                    <div className="flex items-center gap-3 text-xs text-gray-500">
                      <span>Timeline: {project.startDate} - {project.deadline}</span>
                    </div>
                    {lockMessage && (
                      <p className="text-xs text-red-600 mt-1">{lockMessage}</p>
                    )}
                  </div>
                  {/* Badge replacement */}
                 <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${getStatusColor(project.status)}`}>
  {project.status}
</span>
                </div>

                 {canViewRatings ? (
              <div className="flex items-center gap-2 mb-2">
                <div className="flex items-center gap-1">
                  {[...Array(5)].map((_, i) => (
                    <Star
                      key={i}
                      className={`w-3 h-3 ${
                        i < Math.floor(project.rating) ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'
                      }`}
                    />
                  ))}
                </div>
                <span className="text-xs text-gray-600">{project.rating}</span>
              </div>
                 ) : null}
              <div className="flex items-center gap-2">
                <div className="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-blue-600 rounded-full transition-all"
                    style={{ width: `${project.progress}%` }}
                  ></div>
                </div>
                <span className="text-xs text-gray-600">{project.progress}%</span>
              </div>
             </button>
          )})}
          {!activeProjects?.length && 
          <div className="text-center py-4">
                                 <FolderKanban className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                                 <p className="text-sm text-gray-500">No active projects yet.</p>
                                 <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
                               </div>
          }
        {/* </div> */}
       </div>
      </div>
      )}

      {canViewProjects && (
        <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between mb-4">
            <div>
              <h2 className="text-gray-900">Project Calendar</h2>
              <p className="text-sm text-gray-500">Track project start and end dates.</p>
            </div>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => shiftCalendarMonth(-1)}
                className="p-2 rounded-md border border-gray-200 text-gray-600 hover:bg-gray-50"
                aria-label="Previous month"
              >
                <ChevronLeft className="w-4 h-4" />
              </button>
              <span className="min-w-32 text-center text-sm font-medium text-gray-800">{calendarMonthLabel}</span>
              <button
                type="button"
                onClick={() => shiftCalendarMonth(1)}
                className="p-2 rounded-md border border-gray-200 text-gray-600 hover:bg-gray-50"
                aria-label="Next month"
              >
                <ChevronRight className="w-4 h-4" />
              </button>
            </div>
          </div>

          <div className="flex flex-wrap gap-3 mb-4 text-xs text-gray-600">
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-blue-600" /> Project starts
            </span>
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-amber-500" /> Project ends
            </span>
          </div>

          <div className="grid grid-cols-7 gap-2 text-[11px] text-center text-gray-500 mb-2">
            {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => <div key={day}>{day}</div>)}
          </div>

          <div className="grid grid-cols-7 gap-2">
            {calendarDays.map((cell) => {
              if (!cell.day) return <div key={cell.key} className="min-h-20 rounded-xl bg-transparent" />;

              const hasStart = cell.projectsStarting.length > 0;
              const hasEnd = cell.projectsEnding.length > 0;
              const projectNames = [
                ...cell.projectsStarting.map((project) => `Starts: ${project.title}`),
                ...cell.projectsEnding.map((project) => `Ends: ${project.title}`),
              ];

              return (
                <div
                  key={cell.key}
                  className={`min-h-20 rounded-xl p-2 border flex flex-col gap-1 ${
                    hasStart && hasEnd
                      ? 'bg-gradient-to-br from-blue-50 to-amber-50 border-blue-200'
                      : hasStart
                      ? 'bg-blue-50 border-blue-200'
                      : hasEnd
                      ? 'bg-amber-50 border-amber-200'
                      : 'bg-gray-50 border-gray-100'
                  }`}
                  title={projectNames.join(' | ') || undefined}
                >
                  <span className="text-xs font-semibold text-gray-700">{cell.day}</span>
                  {hasStart && <span className="truncate rounded bg-blue-600 px-1 py-0.5 text-[10px] text-white">Start</span>}
                  {hasEnd && <span className="truncate rounded bg-amber-500 px-1 py-0.5 text-[10px] text-white">End</span>}
                  {projectNames.length > 0 && <span className={`${hasStart ? 'bg-blue-600' : 'bg-amber-500'} text-white px-1 py-0.5 text-[10px] rounded`}>{projectNames[0].replace(/^(Starts|Ends): /, '')}</span>}
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Recent Badges & Upcoming Events */}
      <div className="grid grid-cols-1 gap-6">
        {/* <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-gray-900">Recent Badges</h2>
            <button
              onClick={() => onNavigate('badges')}
              className="text-sm text-blue-600 hover:underline"
            >
              View All
            </button>
          </div>

          <div className="grid grid-cols-3 gap-3">
            {(recentBadges || []).map((badge, index) => (
              <div key={index} className={`${badge.color} rounded-xl p-3 text-center`}>
                <p className="text-2xl mb-1">{badge.icon}</p>
                <p className="text-xs text-gray-700">{badge.name}</p>
              </div>
            ))}
            {!recentBadges?.length && <p className="text-sm text-gray-500 col-span-3">No recent badges.</p>}
          </div>
        </div> */}

        {canViewMeetings && (
          <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-gray-900">Upcoming Meetings</h2>
              <button
                onClick={() => onNavigate('meetings')}
                className="text-sm text-blue-600 hover:underline"
              >
                View All
              </button>
            </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            {/* <div className="space-y-3"> */}
            {(upcomingMeetings || []).map((meeting, index) => (
              <div key={index} className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                <div className="w-10 h-10 bg-blue-100 rounded-lg flex flex-col items-center justify-center flex-shrink-0">
                  <p className="text-xs text-blue-600">{meeting.date.split(' ')[0]}</p>
                  <p className="text-xs text-blue-900">{meeting.date.split(' ')[1]}</p>
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-900">{meeting.title}</p>
                  <p className="text-xs text-gray-500">{meeting.time} • {meeting.location}</p>
                </div>
              </div>
            ))}
            {!upcomingMeetings?.length && 
             <div className="col-span-2 text-center py-4">
                                 <Calendar className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                                 <p className="text-sm text-gray-500">No upcoming meetings found</p>
                                 <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
                               </div>
            }
          {/* </div> */}
        </div>
        </div>
        )}
      </div>

      {/* Progress to Next Level */}
      {/* <div className="p-6 rounded-[20px] border-0 shadow-sm bg-gradient-to-r from-blue-50 to-purple-50">
        <div className="flex items-center justify-between mb-3">
          <div>
            <p className="text-sm text-gray-600">Progress to Level 6</p>
            <p className="text-xs text-gray-500">You need 100 more points</p>
          </div>
          <div className="flex items-center gap-2">
            <Target className="w-5 h-5 text-blue-600" />
            <span className="text-sm text-blue-600">83%</span>
          </div>
        </div>
        <div className="w-full h-3 bg-gray-200 rounded-full overflow-hidden">
          <div className="h-full bg-gradient-to-r from-blue-600 to-purple-600 rounded-full" style={{ width: '83%' }}></div>
        </div>
      </div> */}

      {/* <Chatbot title="Project Assistant" /> */}
    </div>

    
  );
}