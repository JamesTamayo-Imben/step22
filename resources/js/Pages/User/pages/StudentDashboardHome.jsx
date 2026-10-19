import { usePage } from '@inertiajs/react';
import { useEffect, useRef, useState } from 'react';
import { TrendingUp, Award, Trophy, FolderKanban, Calendar, Star, Target, Zap, ChevronLeft, ChevronRight, Clock3, CircleDollarSign, FolderPlus, ArrowRightLeft, SlidersHorizontal, Search, ChevronDown, ZoomIn, ZoomOut, RotateCcw, Sparkles, ListTree } from 'lucide-react';
import { Chatbot } from '@/Components/ui/Chatbot';

export function StudentDashboardHome({
  onNavigate,
  onViewProject,
  stats = {},
  activeProjects = [],
  projectTimelines = [],
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
  const [selectedTimelineEvents, setSelectedTimelineEvents] = useState({});
  const [openTimelineGroups, setOpenTimelineGroups] = useState({});
  const [timelineZoom, setTimelineZoom] = useState(1);
  const [timelineViewMode, setTimelineViewMode] = useState('simple');
  const [timelinePan, setTimelinePan] = useState({ x: 0, y: 0 });
  const [isTimelineDragging, setIsTimelineDragging] = useState(false);
  const timelinePointersRef = useRef(new Map());
  const pinchStartRef = useRef(null);
  const timelinePanStartRef = useRef(null);
  const timelinePanRef = useRef({ x: 0, y: 0 });
  const timelineDraggedRef = useRef(false);
  const timelineViewportRef = useRef(null);
  const timelineStageRef = useRef(null);
  const [selectedTimelineProjectIds, setSelectedTimelineProjectIds] = useState(null);
  const [isTimelineFilterOpen, setIsTimelineFilterOpen] = useState(false);
  const [timelineProjectSearch, setTimelineProjectSearch] = useState('');
  const timelineFilterRef = useRef(null);
  const timelineFilterButtonRef = useRef(null);
  const visibleTimelineProjects = selectedTimelineProjectIds === null
    ? projectTimelines
    : projectTimelines.filter((project) => selectedTimelineProjectIds.includes(project.id));

  const toggleTimelineProject = (projectId) => {
    setSelectedTimelineProjectIds((current) => {
      if (current === null) {
        return projectTimelines.map((project) => project.id).filter((id) => id !== projectId);
      }
      if (current.includes(projectId)) return current.filter((id) => id !== projectId);
      const next = [...current, projectId];
      return next.length === projectTimelines.length ? null : next;
    });
  };

  const updateTimelineZoom = (nextZoom) => {
    setTimelineZoom(Math.min(2, Math.max(0.5, nextZoom)));
  };

  const getPointerDistance = (points) => {
    const [first, second] = points;
    return Math.hypot(first.x - second.x, first.y - second.y);
  };

  const clampTimelinePan = (x, y) => {
    const viewport = timelineViewportRef.current;
    const stage = timelineStageRef.current;
    if (!viewport || !stage) return { x: 0, y: 0 };

    const maxX = Math.max(0, stage.offsetWidth - viewport.clientWidth);
    const maxY = Math.max(0, stage.offsetHeight - viewport.clientHeight);
    return {
      x: Math.max(-maxX, Math.min(0, x)),
      y: Math.max(-maxY, Math.min(0, y)),
    };
  };

  const handleTimelinePointerDown = (event) => {
    timelinePointersRef.current.set(event.pointerId, { x: event.clientX, y: event.clientY });
    if (timelinePointersRef.current.size === 2) {
      timelinePanStartRef.current = null;
      setIsTimelineDragging(false);
      pinchStartRef.current = {
        distance: getPointerDistance([...timelinePointersRef.current.values()]),
        zoom: timelineZoom,
      };
      return;
    }

    if (timelinePointersRef.current.size === 1) {
      timelineDraggedRef.current = false;
      timelinePanStartRef.current = {
        pointerId: event.pointerId,
        x: event.clientX,
        y: event.clientY,
        panX: timelinePanRef.current.x,
        panY: timelinePanRef.current.y,
        element: event.currentTarget,
      };
    }
  };

  const handleTimelinePointerMove = (event) => {
    if (!timelinePointersRef.current.has(event.pointerId)) return;
    timelinePointersRef.current.set(event.pointerId, { x: event.clientX, y: event.clientY });
    if (timelinePointersRef.current.size >= 2 && pinchStartRef.current) {
      const distance = getPointerDistance([...timelinePointersRef.current.values()]);
      if (pinchStartRef.current.distance > 0) {
        updateTimelineZoom(pinchStartRef.current.zoom * (distance / pinchStartRef.current.distance));
      }
      return;
    }

    const panStart = timelinePanStartRef.current;
    if (panStart?.pointerId === event.pointerId) {
      const deltaX = event.clientX - panStart.x;
      const deltaY = event.clientY - panStart.y;
      if (!timelineDraggedRef.current && Math.hypot(deltaX, deltaY) > 4) {
        timelineDraggedRef.current = true;
        setIsTimelineDragging(true);
        try {
          panStart.element.setPointerCapture(event.pointerId);
        } catch {
          // Pointer capture may be unavailable if the input ended during the gesture.
        }
      }
      if (timelineDraggedRef.current) {
        const nextPan = clampTimelinePan(panStart.panX + deltaX, panStart.panY + deltaY);
        timelinePanRef.current = nextPan;
        setTimelinePan(nextPan);
      }
    }
  };

  const handleTimelinePointerEnd = (event) => {
    timelinePointersRef.current.delete(event.pointerId);
    pinchStartRef.current = null;
    if (timelinePanStartRef.current?.pointerId === event.pointerId) {
      timelinePanStartRef.current = null;
      setIsTimelineDragging(false);
    }
    if (timelinePointersRef.current.size === 1) {
      const [pointerId, point] = [...timelinePointersRef.current.entries()][0];
      timelinePanStartRef.current = {
        pointerId,
        x: point.x,
        y: point.y,
        panX: timelinePanRef.current.x,
        panY: timelinePanRef.current.y,
        element: timelineViewportRef.current,
      };
    }
  };

  const resetTimelineView = () => {
    updateTimelineZoom(1);
    const initialPan = clampTimelinePan(0, 0);
    timelinePanRef.current = initialPan;
    setTimelinePan(initialPan);
    setSelectedTimelineEvents({});
  };

  const preventTimelineClickAfterDrag = (event) => {
    if (!timelineDraggedRef.current) return;
    event.preventDefault();
    event.stopPropagation();
    timelineDraggedRef.current = false;
  };

  const handleTimelineWheel = (event) => {
    if (!event.ctrlKey && !event.metaKey) return;
    event.preventDefault();
    updateTimelineZoom(timelineZoom - event.deltaY * 0.002);
  };

  useEffect(() => {
    if (!isTimelineFilterOpen) return undefined;

    const closeOnOutsideClick = (event) => {
      if (!timelineFilterRef.current?.contains(event.target)) {
        setIsTimelineFilterOpen(false);
      }
    };
    const closeOnEscape = (event) => {
      if (event.key === 'Escape') {
        setIsTimelineFilterOpen(false);
        timelineFilterButtonRef.current?.focus();
      }
    };

    document.addEventListener('mousedown', closeOnOutsideClick);
    document.addEventListener('keydown', closeOnEscape);
    return () => {
      document.removeEventListener('mousedown', closeOnOutsideClick);
      document.removeEventListener('keydown', closeOnEscape);
    };
  }, [isTimelineFilterOpen]);

  useEffect(() => {
    const nextPan = clampTimelinePan(timelinePanRef.current.x, timelinePanRef.current.y);
    if (nextPan.x !== timelinePanRef.current.x || nextPan.y !== timelinePanRef.current.y) {
      timelinePanRef.current = nextPan;
      setTimelinePan(nextPan);
    }
  }, [timelineZoom, visibleTimelineProjects, selectedTimelineEvents]);

  const parseProjectDate = (value) => {
    if (!value || value === 'TBD') return null;
    const dateOnlyMatch = /^([0-9]{4})-([0-9]{2})-([0-9]{2})$/.exec(String(value));
    if (dateOnlyMatch) {
      const [, year, month, day] = dateOnlyMatch;
      return new Date(Number(year), Number(month) - 1, Number(day));
    }
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
        const startDate = parseProjectDate(project.startDateValue || project.startDate);
        return startDate && startDate.getFullYear() === year && startDate.getMonth() === month && startDate.getDate() === day;
      });
      const projectsEnding = (activeProjects || []).filter((project) => {
        const endDate = parseProjectDate(project.deadlineValue || project.deadline);
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

  const formatTimelineDate = (value) => {
    if (!value) return 'Date unavailable';
    const date = new Date(String(value).replace(' ', 'T'));
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: 'numeric',
      minute: '2-digit',
    });
  };

  const getTimelineScale = (value) => {
    if (!value) return { label: 'Time unavailable', opacity: 0.2, unit: 'minute' };
    const date = new Date(String(value).replace(' ', 'T'));
    if (Number.isNaN(date.getTime())) return { label: value, opacity: 0.2, unit: 'minute' };

    if (timelineZoom < 0.85) {
      return { label: date.toLocaleDateString('en-US', { year: 'numeric' }), opacity: 0.82, unit: 'year' };
    }
    if (timelineZoom < 1.05) {
      return { label: date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' }), opacity: 0.62, unit: 'month' };
    }
    if (timelineZoom < 1.3) {
      return { label: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }), opacity: 0.4, unit: 'day' };
    }
    if (timelineZoom < 1.42) {
      return { label: date.toLocaleString('en-US', { month: 'short', day: 'numeric', hour: 'numeric' }), opacity: 0.3, unit: 'hour' };
    }
    return { label: date.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' }), opacity: 0.22, unit: 'minute' };
  };

  const getTimelineTimestamp = (value) => {
    if (!value) return null;
    const timestamp = new Date(String(value).replace(' ', 'T')).getTime();
    return Number.isFinite(timestamp) ? timestamp : null;
  };

  const getTimelineTickConfig = (span) => {
    const unit = timelineZoom < 0.9
      ? 'year'
      : timelineZoom < 1.15
        ? 'month'
        : timelineZoom < 1.4
          ? 'day'
          : timelineZoom < 1.7 ? 'hour' : 'minute';
    const baseInterval = {
      year: 365.25 * 24 * 60 * 60 * 1000,
      month: 30.4375 * 24 * 60 * 60 * 1000,
      day: 24 * 60 * 60 * 1000,
      hour: 60 * 60 * 1000,
      minute: 60 * 1000,
    }[unit];
    const majorInterval = baseInterval * Math.max(1, Math.ceil(span / (baseInterval * 12)));
    const interval = Math.min(span / 6, Math.max(baseInterval / 6, span / (timelineZoom > 1.7 ? 72 : 36)));
    const effectiveUnit = interval >= 365 * 24 * 60 * 60 * 1000
      ? 'year'
      : interval >= 28 * 24 * 60 * 60 * 1000
        ? 'month'
        : interval >= 24 * 60 * 60 * 1000
          ? 'day'
          : interval >= 60 * 60 * 1000 ? 'hour' : 'minute';
    const formatter = new Intl.DateTimeFormat('en-US', effectiveUnit === 'year'
      ? { year: 'numeric' }
      : effectiveUnit === 'month'
        ? { month: 'short', year: 'numeric' }
        : effectiveUnit === 'day'
          ? { month: 'short', day: 'numeric' }
          : effectiveUnit === 'hour'
            ? { month: 'short', day: 'numeric', hour: 'numeric' }
            : { month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' });
    return { unit, interval, majorInterval, formatter };
  };

  const timelineStatusClass = (status) => {
    if (status === 'Approved' || status === 'Complete' || status === 'Current') {
      return 'bg-blue-100 text-blue-800';
    }
    if (status === 'Rejected') return 'bg-red-100 text-red-800';
    return 'bg-amber-100 text-amber-800';
  };

const getStatusColor = (status) => {
  switch (status) { 
    case 'Draft': return 'bg-gray-100 text-gray-700';
    case 'Upcoming': return 'bg-purple-100 text-purple-700';
    case 'Pending Adviser Approval': return 'bg-yellow-100 text-yellow-700';
    case 'Approved':
    case 'Ongoing': return 'bg-blue-100 text-blue-700';
    case 'Completed': return 'bg-blue-100 text-blue-700';
    case 'Rejected': return 'bg-red-100 text-red-700';
    default: return 'bg-gray-100 text-gray-700';
  }
};

  const allVisibleTimelineEvents = visibleTimelineProjects.flatMap((project) => project.events || []);
  const validTimelineTimestamps = allVisibleTimelineEvents
    .map((event) => getTimelineTimestamp(event.date))
    .filter((timestamp) => timestamp !== null);
  const sharedTimelineStart = validTimelineTimestamps.length ? Math.min(...validTimelineTimestamps) : 0;
  const sharedTimelineEnd = validTimelineTimestamps.length
    ? Math.max(...validTimelineTimestamps)
    : sharedTimelineStart + 60 * 60 * 1000;
  const sharedTimelineSpan = Math.max(60 * 1000, sharedTimelineEnd - sharedTimelineStart);
  const sharedTickConfig = getTimelineTickConfig(sharedTimelineSpan);
  const sharedTopPadding = 40;
  const sharedBottomPadding = 56;
  const sharedAxisHeight = Math.max(240, Math.ceil(sharedTimelineSpan / sharedTickConfig.interval) * 36);
  const sharedTimelineHeight = sharedTopPadding + sharedAxisHeight + sharedBottomPadding;
  const getSharedEventY = (timestamp) => timestamp === null
    ? sharedTopPadding + sharedAxisHeight * 0.5
    : sharedTopPadding + ((timestamp - sharedTimelineStart) / sharedTimelineSpan) * sharedAxisHeight;
  const sharedFirstTick = Math.ceil(sharedTimelineStart / sharedTickConfig.interval) * sharedTickConfig.interval;
  const sharedTimeTicks = [];
  for (let timestamp = sharedFirstTick; timestamp <= sharedTimelineEnd; timestamp += sharedTickConfig.interval) {
    sharedTimeTicks.push({
      timestamp,
      y: getSharedEventY(timestamp),
      label: sharedTickConfig.formatter.format(new Date(timestamp)),
      isMajor: sharedTimeTicks.length === 0 || Math.abs(timestamp % sharedTickConfig.majorInterval) < sharedTickConfig.interval,
    });
  }


  return ( 
    <div className="space-y-6 pb-6">
      {/* Welcome Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 rounded-[20px] p-8 text-white shadow-lg">
        <h1 className="text-white font-bold mb-2">Welcome, {stats.name || 'User'}!</h1>
        <p className="text-blue-100"><strong>STEP</strong> keeps your student council's finances and projects transparent for every student to see because good governance starts with transparency.</p>
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
      </div>

      {/* Active Projects */}
      {canViewProjects && (
        <div className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-gray-900">Active Projects</h2>
            <button onClick={() => onNavigate('projects')} className="text-sm text-blue-600 hover:underline">
              View All
            </button>
          </div>

       <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
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
        <div className="text-card-foreground flex flex-col gap-6 p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex flex-col gap-6 mb-2 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 className="text-gray-900 font-semibold">Project Calendar</h2>
              <p className="text-sm text-gray-500">Track project start and end dates.</p>
            </div>
            <div className="flex w-full items-center justify-between gap-1.5 sm:w-auto sm:justify-center">
              <button
                type="button"
                onClick={() => shiftCalendarMonth(-1)}
                className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
                aria-label="Previous month"
              >
               ← Prev
              </button>
              <div className="flex-1 rounded-md bg-slate-100 px-3 py-1 text-center text-sm font-medium text-slate-800 sm:flex-none">
                {calendarMonthLabel}
              </div>
              <button
                type="button"
                onClick={() => shiftCalendarMonth(1)}
                className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
                aria-label="Next month"
              >
                Next →
              </button>
            </div>
          </div>

          <div className="flex gap-3 text-xs text-gray-600 mb-4 w-full items-center justify-between sm:w-auto sm:justify-start">
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-blue-600" /> Project starts
            </span>
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-amber-500" /> Project ends
            </span>
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-slate-200 border border-slate-300" /> No activity
            </span>
          </div>

          <div className="grid grid-cols-7 gap-1 sm:gap-2 text-[11px] text-center text-gray-600">
            {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => <div key={day}>{day}</div>)}
          </div>

          <div className="grid grid-cols-7 gap-1 sm:gap-2 mt-2">
            {calendarDays.map((cell) => {
              if (!cell.day) return <div key={cell.key} className="h-20 rounded-xl bg-transparent" />;

              const hasStart = cell.projectsStarting.length > 0;
              const hasEnd = cell.projectsEnding.length > 0;
              const projectEvents = [
                ...cell.projectsStarting.map((project) => ({ project, label: 'Start' })),
                ...cell.projectsEnding.map((project) => ({ project, label: 'End' })),
              ];

              return (
                <div
                  key={cell.key}
                  className={`h-20 rounded-xl p-2 flex flex-col justify-between transition-all ${
                    hasStart && hasEnd
                      ? 'bg-gradient-to-br from-blue-50 to-amber-50 border border-blue-200'
                      : hasStart
                      ? 'bg-blue-50 border border-blue-200'
                      : hasEnd
                      ? 'bg-amber-50 border border-amber-200'
                      : 'bg-slate-200 text-slate-700 border border-slate-300 opacity-90'
                  }`}
                >
                  <span className="text-[11px] uppercase tracking-[0.08em] text-gray-700">{cell.day}</span>
                  {projectEvents.length > 0 ? (
                    <div className="flex h-full flex-col items-center justify-center gap-0.5">
                      {projectEvents.map(({ project, label }) => (
                        <button
                          key={`${label}-${project.id}`}
                          type="button"
                          onClick={() => onViewProject?.(project.id)}
                          className={`w-full min-w-0 rounded px-1 py-0.5 text-[10px] font-semibold leading-none transition-colors focus:outline-none focus:ring-2 focus:ring-blue-400 sm:text-xs ${
                            label === 'Start'
                              ? 'text-blue-700 hover:bg-blue-100'
                              : 'text-amber-700 hover:bg-amber-100'
                          }`}
                          aria-label={`${label} project ${project.title || 'project'}`}
                        >
                          <span className="hidden min-w-0 max-w-full truncate whitespace-nowrap sm:block" title={project.title || 'Project'}>
                            {project.title || 'Project'}
                          </span>
                          <span className="sm:hidden">
                            {(project.title || 'Project').slice(0, 2)}
                          </span>
                        </button>
                      ))}
                    </div>
                  ) : (
                    <span className="text-[10px] text-slate-500">—</span>
                  )}
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

      {canViewProjects && (
        <section className="text-card-foreground flex flex-col gap-6 rounded-[20px] border-0 bg-white p-6 shadow-sm" aria-labelledby="project-timelines-heading">
          <div className="flex flex-col gap-4 xl:flex-row xl:items-center xl:justify-between">
            <div>
              <h2 id="project-timelines-heading" className="font-semibold text-gray-900">Project Status &amp; Ledger Timeline</h2>
              <p className="text-sm text-gray-600">A complete activity history for every approved project.</p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <div className="inline-flex items-center rounded-lg border border-gray-200 bg-gray-50 p-1" role="group" aria-label="Timeline display mode">
                <button
                  type="button"
                  onClick={() => setTimelineViewMode('simple')}
                  aria-pressed={timelineViewMode === 'simple'}
                  className={`inline-flex min-h-9 items-center gap-1.5 rounded-md px-3 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 ${timelineViewMode === 'simple' ? 'bg-white text-blue-700 shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                >
                  <Sparkles className="h-4 w-4" aria-hidden="true" />
                  Simple
                </button>
                <button
                  type="button"
                  onClick={() => setTimelineViewMode('detailed')}
                  aria-pressed={timelineViewMode === 'detailed'}
                  className={`inline-flex min-h-9 items-center gap-1.5 rounded-md px-3 text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 ${timelineViewMode === 'detailed' ? 'bg-white text-blue-700 shadow-sm' : 'text-gray-600 hover:text-gray-900'}`}
                >
                  <ListTree className="h-4 w-4" aria-hidden="true" />
                  Detailed
                </button>
              </div>
              <div className="flex items-center gap-1 rounded-lg border border-gray-200 bg-white p-1 shadow-sm" aria-label="Timeline zoom controls">
                <button
                  type="button"
                  onClick={() => updateTimelineZoom(timelineZoom - 0.1)}
                  disabled={timelineZoom <= 0.5}
                  aria-label="Zoom timeline out"
                  className="inline-flex h-9 w-9 items-center justify-center rounded-md text-gray-600 transition-colors hover:bg-gray-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:cursor-not-allowed disabled:opacity-40"
                >
                  <ZoomOut className="h-4 w-4" aria-hidden="true" />
                </button>
                <label className="sr-only" htmlFor="project-timeline-zoom">Timeline zoom</label>
                <input
                  id="project-timeline-zoom"
                  type="range"
                  min="0.5"
                  max="2"
                  step="0.1"
                  value={timelineZoom}
                  onChange={(event) => updateTimelineZoom(Number(event.target.value))}
                  className="h-1.5 w-20 cursor-pointer accent-blue-600 sm:w-24"
                />
                <span className="w-12 text-center text-xs font-medium tabular-nums text-gray-600">{Math.round(timelineZoom * 100)}%</span>
                <button
                  type="button"
                  onClick={() => updateTimelineZoom(timelineZoom + 0.1)}
                  disabled={timelineZoom >= 2}
                  aria-label="Zoom timeline in"
                  className="inline-flex h-9 w-9 items-center justify-center rounded-md text-gray-600 transition-colors hover:bg-gray-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:cursor-not-allowed disabled:opacity-40"
                >
                  <ZoomIn className="h-4 w-4" aria-hidden="true" />
                </button>
                <button
                  type="button"
                  onClick={resetTimelineView}
                  aria-label="Reset timeline position and zoom"
                  title="Reset timeline position and zoom"
                  className="inline-flex h-9 items-center justify-center gap-2 rounded-md px-2 text-sm font-medium text-gray-600 transition-colors hover:bg-gray-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                >
                  <RotateCcw className="h-4 w-4" aria-hidden="true" />
                  <span className="hidden sm:inline">Reset view</span>
                </button>
              </div>
              {projectTimelines.length > 0 && (
              <div className="relative" ref={timelineFilterRef}>
                <button
                  ref={timelineFilterButtonRef}
                  type="button"
                  onClick={() => setIsTimelineFilterOpen((open) => !open)}
                  aria-expanded={isTimelineFilterOpen}
                  aria-haspopup="true"
                  className="inline-flex min-h-11 items-center gap-2 rounded-lg border border-gray-300 bg-white px-3.5 py-2 text-sm font-medium text-gray-700 shadow-sm transition-colors hover:bg-gray-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-offset-2"
                >
                  <SlidersHorizontal className="h-4 w-4 text-gray-500" aria-hidden="true" />
                  <span>Projects</span>
                  <span className="rounded-full bg-blue-100 px-2 py-0.5 text-xs font-semibold text-blue-800">
                    {selectedTimelineProjectIds === null ? 'All' : `${visibleTimelineProjects.length} selected`}
                  </span>
                  <ChevronDown className={`h-4 w-4 text-gray-500 transition-transform ${isTimelineFilterOpen ? 'rotate-180' : ''}`} aria-hidden="true" />
                </button>

                {isTimelineFilterOpen && (
                  <div className="absolute right-0 z-30 mt-2 w-[min(20rem,calc(100vw-2.5rem))] rounded-xl border border-gray-200 bg-white p-3 shadow-xl">
                    <div className="flex items-center justify-between gap-3 px-1 pb-2">
                      <p className="text-sm font-semibold text-gray-900">Filter projects</p>
                      <span className="text-xs text-gray-500">{visibleTimelineProjects.length} of {projectTimelines.length} shown</span>
                    </div>
                    <label className="relative block">
                      <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" aria-hidden="true" />
                      <span className="sr-only">Search projects</span>
                      <input
                        type="search"
                        value={timelineProjectSearch}
                        onChange={(event) => setTimelineProjectSearch(event.target.value)}
                        placeholder="Search projects"
                        className="min-h-10 w-full rounded-lg border border-gray-300 py-2 pl-9 pr-3 text-sm text-gray-900 placeholder:text-gray-500 focus:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-200"
                      />
                    </label>
                    <div className="flex items-center justify-between border-b border-gray-100 px-1 py-2">
                      <button
                        type="button"
                        onClick={() => setSelectedTimelineProjectIds(null)}
                        className="min-h-10 rounded px-2 text-sm font-medium text-blue-700 hover:bg-blue-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                      >
                        Select all
                      </button>
                      <button
                        type="button"
                        onClick={() => setSelectedTimelineProjectIds([])}
                        className="min-h-10 rounded px-2 text-sm font-medium text-gray-600 hover:bg-gray-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                      >
                        Clear
                      </button>
                    </div>
                    <div className="mt-1 max-h-60 space-y-1 overflow-y-auto" role="group" aria-label="Projects">
                      {projectTimelines
                        .filter((project) => (project.title || '').toLowerCase().includes(timelineProjectSearch.trim().toLowerCase()))
                        .map((project) => {
                          const isSelected = selectedTimelineProjectIds === null || selectedTimelineProjectIds.includes(project.id);
                          return (
                            <label key={`filter-${project.id}`} className="flex min-h-11 cursor-pointer items-center gap-3 rounded-lg px-2 hover:bg-gray-50">
                              <input
                                type="checkbox"
                                checked={isSelected}
                                onChange={() => toggleTimelineProject(project.id)}
                                className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                              />
                              <span className="truncate text-sm text-gray-700">{project.title || 'Untitled project'}</span>
                            </label>
                          );
                        })}
                      {projectTimelines.filter((project) => (project.title || '').toLowerCase().includes(timelineProjectSearch.trim().toLowerCase())).length === 0 && (
                        <p className="px-2 py-4 text-center text-sm text-gray-500">No matching projects.</p>
                      )}
                    </div>
                  </div>
                )}
              </div>
              )}
            </div>
          </div>

          {visibleTimelineProjects.length > 0 ? (
            <div
              ref={timelineViewportRef}
              className={`relative overflow-hidden rounded-2xl bg-white shadow-[inset_0_2px_10px_rgba(15,23,42,0.12)] touch-none select-none ${isTimelineDragging ? 'cursor-grabbing' : 'cursor-grab'}`}
              style={{ height: 'max(320px, calc(100dvh - 22rem))', touchAction: 'none' }}
              onPointerDown={handleTimelinePointerDown}
              onPointerMove={handleTimelinePointerMove}
              onPointerUp={handleTimelinePointerEnd}
              onPointerCancel={handleTimelinePointerEnd}
              onWheel={handleTimelineWheel}
              onClickCapture={preventTimelineClickAfterDrag}
              onKeyDown={(event) => {
                const panAmount = 48;
                const directions = {
                  ArrowLeft: { x: panAmount, y: 0 },
                  ArrowRight: { x: -panAmount, y: 0 },
                  ArrowUp: { x: 0, y: panAmount },
                  ArrowDown: { x: 0, y: -panAmount },
                };
                const direction = directions[event.key];
                if (!direction) return;
                event.preventDefault();
                const nextPan = clampTimelinePan(timelinePanRef.current.x + direction.x, timelinePanRef.current.y + direction.y);
                timelinePanRef.current = nextPan;
                setTimelinePan(nextPan);
              }}
              tabIndex={0}
              role="region"
              aria-label="Draggable project timelines. Drag to pan; use arrow keys when focused."
            >
              <div
                ref={timelineStageRef}
                className="grid min-h-full min-w-full grid-flow-col auto-cols-[minmax(280px,340px)] divide-x divide-gray-300 border-l border-gray-300"
                style={{ width: 'max-content', gridAutoColumns: 'minmax(280px, 340px)', transform: `translate3d(${timelinePan.x}px, ${timelinePan.y}px, 0)`, willChange: isTimelineDragging ? 'transform' : 'auto' }}
              >
              {visibleTimelineProjects.map((project) => {
                const events = project.events || [];
                const datedEvents = events.map((event) => ({ ...event, timestamp: getTimelineTimestamp(event.date) }));
                const positionedEvents = datedEvents
                  .map((event, index) => ({ ...event, originalIndex: index, y: getSharedEventY(event.timestamp) }))
                  .sort((left, right) => (left.timestamp ?? Infinity) - (right.timestamp ?? Infinity));
                const overlapDistance = 38 * timelineZoom + 6;
                const eventGroups = [];
                positionedEvents.forEach((event) => {
                  const currentGroup = eventGroups[eventGroups.length - 1];
                  if (currentGroup && Math.abs(event.y - currentGroup.y) < overlapDistance) {
                    currentGroup.events.push(event);
                    currentGroup.y = currentGroup.events.reduce((sum, item) => sum + item.y, 0) / currentGroup.events.length;
                  } else {
                    eventGroups.push({
                      id: `${project.id}-${event.id}`,
                      y: event.y,
                      events: [event],
                    });
                  }
                });
                const stonePath = eventGroups.map((group, index) => {
                  const x = index % 2 === 0 ? 29 : 71;
                  const y = group.y;
                  if (index === 0) return `M ${x} ${y}`;
                  const previousX = (index - 1) % 2 === 0 ? 29 : 71;
                  const previousY = eventGroups[index - 1].y;
                  const midpointY = (previousY + y) / 2;
                  return `C ${previousX} ${midpointY}, ${x} ${midpointY}, ${x} ${y}`;
                }).join(' ');

                return (
                  <article key={project.id} className="min-w-0 overflow-hidden border-r border-gray-300 bg-white">
                    <div className="flex flex-col gap-3 bg-gradient-to-r from-blue-50 to-white px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
                      <div className="flex min-w-0 items-center gap-3">
                        <span className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-blue-600 text-white shadow-sm">
                          <FolderKanban className="h-5 w-5" aria-hidden="true" />
                        </span>
                        <div className="min-w-0">
                          <h3 className="truncate font-semibold text-gray-900">{project.title || 'Untitled project'}</h3>
                          <p className="text-xs text-gray-600">{events.length} timeline {events.length === 1 ? 'event' : 'events'} · Tap an icon for details</p>
                        </div>
                      </div>
                      <span className={`inline-flex w-fit items-center rounded-full px-3 py-1 text-xs font-semibold ${getStatusColor(project.status)}`}>
                        {project.status || 'Draft'}
                      </span>
                    </div>

                    {events.length > 0 ? (
                      <>
                        {timelineViewMode === 'simple' && (() => {
                          const simpleEvents = [...events]
                            .map((event) => ({ ...event, timestamp: getTimelineTimestamp(event.date) }))
                            .sort((left, right) => (left.timestamp ?? Infinity) - (right.timestamp ?? Infinity));
                          const selectedEvent = simpleEvents.find((event) => event.id === selectedTimelineEvents[project.id]);
                          const selectedIndex = simpleEvents.findIndex((event) => event.id === selectedTimelineEvents[project.id]);
                          const step = 92 * timelineZoom;
                          const selectedExtra = 220 * timelineZoom;
                          const rowTop = (index) => 32 + index * step + (selectedIndex >= 0 && index > selectedIndex ? selectedExtra : 0);
                          const eventTop = (index) => rowTop(index) + (selectedIndex === index ? selectedExtra / 2 : 0);
                          const simpleHeight = 32 + simpleEvents.length * step + (selectedIndex >= 0 ? selectedExtra : 0) + 24;
                          const path = simpleEvents.map((event, index) => {
                            const x = index % 2 === 0 ? 29 : 71;
                            const y = eventTop(index);
                            if (index === 0) return `M ${x} ${y}`;
                            const priorX = (index - 1) % 2 === 0 ? 29 : 71;
                            const priorY = eventTop(index - 1);
                            const midY = (priorY + y) / 2;
                            return `C ${priorX} ${midY}, ${x} ${midY}, ${x} ${y}`;
                          }).join(' ');

                          return (
                            <ol
                              className="relative mx-auto my-5 w-full max-w-md"
                              style={{ height: `${simpleHeight}px` }}
                              aria-label={`${project.title || 'Project'} stepping-stone timeline`}
                            >
                              <svg className="pointer-events-none absolute inset-0 h-full w-full" viewBox={`0 0 100 ${simpleHeight}`} preserveAspectRatio="none" aria-hidden="true">
                                <path d={path} fill="none" stroke="#cbd5e1" strokeWidth="2" strokeDasharray="5 7" vectorEffect="non-scaling-stroke" />
                              </svg>
                              {simpleEvents.map((event, index) => {
                                const EventIcon = event.type === 'ledger'
                                  ? (event.label?.includes('Transfer') ? ArrowRightLeft : CircleDollarSign)
                                  : event.type === 'project-status' ? Clock3 : FolderPlus;
                                const isSelected = selectedTimelineEvents[project.id] === event.id;
                                const side = index % 2 === 0;
                                const stoneColor = event.type === 'project-status'
                                  ? 'bg-blue-600 hover:bg-blue-700'
                                  : event.type === 'ledger' && event.label?.includes('Transfer')
                                    ? 'bg-amber-500 hover:bg-amber-600'
                                    : event.type === 'ledger'
                                      ? 'bg-indigo-600 hover:bg-indigo-700'
                                      : 'bg-teal-600 hover:bg-teal-700';

                                return (
                                  <li key={event.id} className="absolute left-0 top-0 h-0 w-full" style={{ top: `${eventTop(index)}px` }}>
                                    <button
                                      type="button"
                                      onClick={() => setSelectedTimelineEvents((current) => ({
                                        ...current,
                                        [project.id]: isSelected ? null : event.id,
                                      }))}
                                      aria-label={`${isSelected ? 'Hide' : 'Show'} details for ${event.label} in ${project.title || 'project'}`}
                                      aria-expanded={isSelected}
                                      className={`absolute top-0 z-10 flex -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full text-white transition-transform hover:scale-105 focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-blue-300 focus-visible:ring-offset-2 ${isSelected ? 'scale-110' : ''}`}
                                      style={{ left: `${side ? 29 : 71}%`, width: `${36 * timelineZoom}px`, height: `${36 * timelineZoom}px` }}
                                    >
                                      <span
                                        className={`absolute inset-0 rounded-full ring-2 ring-white ${stoneColor} ${side ? '-rotate-6' : 'rotate-6'}`}
                                        style={{ transform: `perspective(100px) rotateX(16deg) rotateZ(${side ? -6 : 6}deg)`, boxShadow: '0 5px 0 rgba(30, 64, 175, 0.28)' }}
                                        aria-hidden="true"
                                      />
                                      <EventIcon className="relative z-10" style={{ width: `${17 * timelineZoom}px`, height: `${17 * timelineZoom}px` }} aria-hidden="true" />
                                    </button>
                                    {isSelected && (
                                      <div
                                        className={`absolute top-0 z-20 w-[64%] -translate-y-1/2 rounded-xl bg-blue-50 p-3 shadow-md sm:p-4 ${side ? 'left-[35%]' : 'left-[1%]'}`}
                                        aria-live="polite"
                                      >
                                        <div className="flex flex-wrap items-center gap-2">
                                          <h4 className="text-sm font-semibold leading-5 text-gray-900">{event.label}</h4>
                                          <span className={`rounded-full px-2 py-0.5 text-xs font-semibold ${timelineStatusClass(event.status)}`}>
                                            {event.status || 'Pending'}
                                          </span>
                                        </div>
                                        <p className="mt-1 break-words text-xs leading-5 text-gray-700 sm:text-sm">{event.description}</p>
                                        {(event.category || event.amount !== null && event.amount !== undefined) && (
                                          <dl className="mt-3 grid grid-cols-2 gap-2 border-t border-blue-100 pt-3 text-xs">
                                            {event.category && (
                                              <div>
                                                <dt className="text-gray-500">Category</dt>
                                                <dd className="mt-0.5 font-medium text-gray-800">{event.category}</dd>
                                              </div>
                                            )}
                                            {event.amount !== null && event.amount !== undefined && (
                                              <div>
                                                <dt className="text-gray-500">Amount</dt>
                                                <dd className="mt-0.5 font-semibold tabular-nums text-gray-900">₱{Number(event.amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</dd>
                                              </div>
                                            )}
                                          </dl>
                                        )}
                                        <time className="mt-1 block text-xs text-gray-600" dateTime={event.date?.replace(' ', 'T')}>
                                          {formatTimelineDate(event.date)}
                                        </time>
                                      </div>
                                    )}
                                  </li>
                                );
                              })}
                            </ol>
                          );
                        })()}

                        {timelineViewMode === 'detailed' && (
                        <ol
                          className="relative mx-auto my-5 w-full max-w-md"
                          style={{ height: `${sharedTimelineHeight}px` }}
                          aria-label={`${project.title || 'Project'} activity timeline`}
                        >
                          <svg
                            className="pointer-events-none absolute inset-0 h-full w-full"
                            viewBox={`0 0 100 ${sharedTimelineHeight}`}
                            preserveAspectRatio="none"
                            aria-hidden="true"
                          >
                            {timelineViewMode === 'detailed' && sharedTimeTicks.map((tick) => (
                              <g key={`time-tick-${tick.timestamp}`}>
                                <line
                                  x1="0"
                                  x2="100"
                                  y1={tick.y}
                                  y2={tick.y}
                                  stroke="#6b7280"
                                  strokeWidth={tick.isMajor ? 1.2 : 0.8}
                                  strokeOpacity={tick.isMajor
                                    ? (sharedTickConfig.unit === 'year' ? 0.58 : sharedTickConfig.unit === 'month' ? 0.42 : sharedTickConfig.unit === 'day' ? 0.3 : sharedTickConfig.unit === 'hour' ? 0.23 : 0.16)
                                    : 0.1}
                                  vectorEffect="non-scaling-stroke"
                                />
                              </g>
                            ))}
                            {timelineViewMode === 'detailed' && eventGroups.map((group) => (
                              <line
                                key={`time-guide-${group.id}`}
                                x1="0"
                                x2="100"
                                y1={group.y}
                                y2={group.y}
                                stroke="#6b7280"
                                strokeWidth="1"
                                strokeOpacity={sharedTickConfig.unit === 'year' ? 0.3 : sharedTickConfig.unit === 'month' ? 0.24 : sharedTickConfig.unit === 'day' ? 0.18 : 0.12}
                                vectorEffect="non-scaling-stroke"
                              />
                            ))}
                            {timelineViewMode === 'detailed' ? (
                              <path d={stonePath} fill="none" stroke="#9ca3af" strokeWidth="1.5" strokeDasharray="4 5" vectorEffect="non-scaling-stroke" />
                            ) : (
                              <path d={stonePath} fill="none" stroke="#cbd5e1" strokeWidth="2" strokeDasharray="5 7" vectorEffect="non-scaling-stroke" />
                            )}
                          </svg>
                          {sharedTimeTicks.filter((tick) => tick.isMajor).map((tick) => (
                            <span
                              key={`time-label-${tick.timestamp}`}
                              className={`pointer-events-none absolute left-1 top-0 z-0 -translate-y-1/2 rounded bg-white/80 px-1 text-[10px] font-medium leading-4 tabular-nums text-gray-600 ${timelineViewMode === 'detailed' ? '' : 'hidden'}`}
                              style={{ top: `${tick.y}px` }}
                            >
                              {tick.label}
                            </span>
                          ))}
                          {eventGroups.map((group, index) => {
                            const groupLead = group.events[0];
                            const EventIcon = groupLead.type === 'ledger'
                              ? (groupLead.label?.includes('Transfer') ? ArrowRightLeft : CircleDollarSign)
                              : groupLead.type === 'project-status' ? Clock3 : FolderPlus;
                            const selectedEvent = group.events.find((event) => event.id === selectedTimelineEvents[project.id]);
                            const isGroupOpen = openTimelineGroups[project.id] === group.id;
                            const isExpanded = Boolean(selectedEvent);
                            const isOverlap = group.events.length > 1;
                            const stoneColor = groupLead.type === 'project-status'
                              ? 'bg-blue-600 hover:bg-blue-700'
                              : groupLead.type === 'ledger' && groupLead.label?.includes('Transfer')
                                ? 'bg-amber-500 hover:bg-amber-600'
                                : groupLead.type === 'ledger'
                                  ? 'bg-indigo-600 hover:bg-indigo-700'
                                  : 'bg-teal-600 hover:bg-teal-700';
                            const side = index % 2 === 0;

                            return (
                              <li key={group.id} className="absolute left-0 top-0 h-0 w-full" style={{ top: `${group.y}px` }}>
                                <button
                                  type="button"
                                  onClick={() => {
                                    if (isOverlap) {
                                      setOpenTimelineGroups((current) => ({ ...current, [project.id]: isGroupOpen ? null : group.id }));
                                      setSelectedTimelineEvents((current) => ({ ...current, [project.id]: null }));
                                    } else {
                                      setOpenTimelineGroups((current) => ({ ...current, [project.id]: null }));
                                      setSelectedTimelineEvents((current) => ({
                                        ...current,
                                        [project.id]: isExpanded ? null : groupLead.id,
                                      }));
                                    }
                                  }}
                                  aria-label={isOverlap
                                    ? `${isGroupOpen ? 'Hide' : 'View'} ${group.events.length} overlapping events in ${project.title || 'project'}`
                                    : `${isExpanded ? 'Hide' : 'Show'} details for ${groupLead.label} in ${project.title || 'project'}`}
                                  aria-expanded={isOverlap ? isGroupOpen : isExpanded}
                                  className={`absolute top-0 z-10 flex -translate-x-1/2 -translate-y-1/2 items-center justify-center rounded-full text-white shadow-[0_4px_0_rgba(30,64,175,0.28)] ring-2 ring-white transition-transform hover:scale-105 focus-visible:outline-none focus-visible:ring-4 focus-visible:ring-blue-300 focus-visible:ring-offset-2 active:translate-y-[-40%] ${stoneColor} ${index % 2 === 0 ? '-rotate-6' : 'rotate-6'} ${isExpanded || isGroupOpen ? 'scale-110 ring-blue-200' : ''}`}
                                  style={{ left: `${side ? 29 : 71}%`, width: `${28 * timelineZoom}px`, height: `${28 * timelineZoom}px` }}
                                >
                                  <EventIcon className={`${index % 2 === 0 ? 'rotate-6' : '-rotate-6'}`} style={{ width: `${13 * timelineZoom}px`, height: `${13 * timelineZoom}px` }} aria-hidden="true" />
                                  {isOverlap && <span className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-gray-800 px-1 text-[9px] font-bold leading-none text-white">{group.events.length}</span>}
                                </button>

                                {isGroupOpen && (
                                  <div className={`absolute top-0 z-30 max-h-52 w-[68%] -translate-y-1/2 overflow-y-auto rounded-lg border border-gray-200 bg-white p-2 shadow-lg ${side ? 'left-[37%]' : 'left-[1%]'}`} role="group" aria-label="Overlapping timeline events">
                                    <p className="mb-1 px-2 text-[10px] font-semibold uppercase tracking-wide text-gray-500">{group.events.length} events at this time</p>
                                    {group.events.map((event) => (
                                      <button
                                        key={`overlap-${event.id}`}
                                        type="button"
                                        onClick={() => {
                                          setSelectedTimelineEvents((current) => ({ ...current, [project.id]: event.id }));
                                          setOpenTimelineGroups((current) => ({ ...current, [project.id]: null }));
                                        }}
                                        className="flex min-h-10 w-full flex-col items-start justify-center rounded-md px-2 py-1 text-left hover:bg-blue-50 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                                      >
                                        <span className="text-xs font-medium text-gray-900">{event.label}</span>
                                        <span className="text-[10px] text-gray-500">{formatTimelineDate(event.date)}</span>
                                      </button>
                                    ))}
                                  </div>
                                )}

                                {selectedEvent && (
                                  <div
                                    className={`absolute top-0 z-20 w-[68%] -translate-y-1/2 rounded-xl bg-blue-50 p-3 shadow-md sm:p-4 ${side ? 'left-[37%]' : 'left-[1%]'}`}
                                    aria-live="polite"
                                  >
                                    <div className="flex flex-wrap items-center gap-2">
                                      <h4 className="text-sm font-semibold leading-5 text-gray-900">{selectedEvent.label}</h4>
                                      <span className={`rounded-full px-2 py-0.5 text-xs font-semibold ${timelineStatusClass(selectedEvent.status)}`}>
                                        {selectedEvent.status || 'Pending'}
                                      </span>
                                    </div>
                                    <p className="mt-1 break-words text-xs leading-5 text-gray-700 sm:text-sm">{selectedEvent.description}</p>
                                    {(selectedEvent.category || selectedEvent.amount !== null && selectedEvent.amount !== undefined) && (
                                      <dl className="mt-3 grid grid-cols-2 gap-2 border-t border-blue-100 pt-3 text-xs">
                                        {selectedEvent.category && (
                                          <div>
                                            <dt className="text-gray-500">Category</dt>
                                            <dd className="mt-0.5 font-medium text-gray-800">{selectedEvent.category}</dd>
                                          </div>
                                        )}
                                        {selectedEvent.amount !== null && selectedEvent.amount !== undefined && (
                                          <div>
                                            <dt className="text-gray-500">Amount</dt>
                                            <dd className="mt-0.5 font-semibold tabular-nums text-gray-900">₱{Number(selectedEvent.amount).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</dd>
                                          </div>
                                        )}
                                      </dl>
                                    )}
                                    <time className="mt-1 block text-xs text-gray-600" dateTime={selectedEvent.date?.replace(' ', 'T')}>
                                      {formatTimelineDate(selectedEvent.date)}
                                    </time>
                                  </div>
                                )}
                              </li>
                            );
                          })}
                        </ol>
                        )}
                      </>
                    ) : (
                      <p className="px-5 py-8 text-center text-sm text-gray-600">No timeline events for this project yet.</p>
                    )}
                  </article>
                );
              })}
              </div>
            </div>
          ) : (
            <div className="rounded-2xl border border-dashed border-blue-200 bg-blue-50/50 px-5 py-10 text-center">
              <FolderKanban className="mx-auto mb-3 h-10 w-10 text-blue-400" aria-hidden="true" />
              <p className="font-medium text-gray-800">
                {projectTimelines.length > 0 ? 'No projects selected.' : 'No project activity to show yet.'}
              </p>
              <p className="mt-1 text-sm text-gray-600">
                {projectTimelines.length > 0 ? 'Choose one or more project filters above, or show all projects.' : 'Approved project timelines will appear here.'}
              </p>
            </div>
          )}
        </section>
      )}

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