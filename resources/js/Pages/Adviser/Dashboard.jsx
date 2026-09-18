import React from 'react';
import { router } from '@inertiajs/react';  
import { Card } from '../../Components/ui/card';
import { CheckSquare, Clock, AlertCircle, TrendingUp, FileText, CheckCircle2, FolderKanban, DollarSign, Star } from 'lucide-react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';

// Small inline Badge component (keeps this file self-contained)
function Badge({ children, className = '' }) {
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-700 ${className}`}>
      {children}
    </span>
  );
}

// Placeholder sub-pages (project can replace with full implementations)
function ApprovalCenterPage() { return <Card className="p-8">Approval Center (placeholder)</Card>; }
function RatingsAnalyticsPage() { return <Card className="p-8"> Analytics (placeholder)</Card>; }
function OrganizationsPage() { return <Card className="p-8">Organizations / CSG Overview (placeholder)</Card>; }
function SystemLogsPage() { return <Card className="p-8">System Logs (placeholder)</Card>; }
function AdminProfilePage() { return <Card className="p-8">Profile (placeholder)</Card>; }
function LedgerOversightPage() { return <Card className="p-8">Ledger Oversight (placeholder)</Card>; }
function RolePermissionsPage() { return <Card className="p-8">Role & Permissions (placeholder)</Card>; }

export function AdminAdviserDashboard({
  currentView,
  onNavigate,
  stats = {},
  approvalQueue = [],
  recentActivity = [],
  heatmapDays = [],
  heatmapMonth,
  heatmapLabel,
  prevHeatmapMonth,
  nextHeatmapMonth,
  canNavigateNext,
}) {
  const s = {
    pendingApprovals: stats.pendingApprovals ?? 0,
    pendingProjects: stats.pendingProjects ?? 0,
    pendingMeetings: stats.pendingMeetings ?? 0,
    avgRating: typeof stats.avgRating === 'number' ? stats.avgRating : 0,
    tamperedAlerts: stats.tamperedAlerts ?? 0,
    activeCsgCount: stats.activeCsgCount ?? 0,
    isBudgetTampered: stats.isBudgetTampered ?? false,
    budgetMismatchCount: stats.budgetMismatchCount ?? 0,
  };
  
  // Simple subcomponents to mirror the STEP AdminAdviser layout
  function StatsCard({ title, value, hint, icon, iconBg = 'bg-gray-100', iconColor = 'text-gray-700' }) {
    return (
      <Card className="p-4 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-gray-500">{title}</p>
            <p className="text-2xl text-gray-900 mt-1">{value}</p>
            {hint && <p className="text-xs text-gray-500 mt-1">{hint}</p>}
          </div>
          <div className={`w-12 h-12 ${iconBg} rounded-xl flex items-center justify-center`}>
            {icon && React.cloneElement(icon, { className: `w-6 h-6 ${iconColor}` })}
          </div>
        </div>
      </Card>
    );
  }

  const getTypeIcon = (approvalType) => {
      switch (approvalType) {
        case 'project': return <FolderKanban className="w-5 h-5 text-blue-600" />;
        case 'ledger': return <DollarSign className="w-5 h-5 text-green-600" />;
        default: return <FileText className="w-5 h-5 text-gray-600" />;
      }
    };

  const heatmapDaysData = heatmapDays || [];

  const getHeatmapCellStyles = (item) => {
    const tampering = Number(item.tamperingCount) || 0;
    const activity = Number(item.activityCount) || 0;
    const total = tampering + activity;

    if (!total) {
      return { className: 'bg-slate-200 text-slate-700 border border-slate-300' };
    }
    if (!tampering) {
      return { className: 'bg-emerald-500 text-white' };
    }
    if (!activity) {
      return { className: 'bg-red-600 text-white' };
    }

    const tamperingPercent = Math.round((tampering / total) * 100);
    return {
      className: 'text-white',
      style: {
        background: `linear-gradient(90deg, #dc2626 ${tamperingPercent}%, #10b981 ${tamperingPercent}%)`,
      },
    };
  };

  const formatHeatmapTooltip = (item) => {
    return `${item.tamperingCount} tampering event${item.tamperingCount !== 1 ? 's' : ''}, ${item.activityCount} CSG activit${item.activityCount !== 1 ? 'ies' : 'y'} event${item.activityCount !== 1 ? 's' : ''}`;
  };

  function ApprovalItem({ item }) {
    const isLedgerOrProject = item.type === 'Ledger Entry' || item.type === 'Project';
    const bgClass = isLedgerOrProject ? 'bg-blue-50' : 'bg-gray-50';
    const icon = getTypeIcon(item.type.toLowerCase().includes('ledger') ? 'ledger' : item.type.toLowerCase().includes('project') ? 'project' : 'default');

    return (
      <div className={`flex items-center justify-between p-4 ${bgClass} rounded-xl hover:bg-gray-100 transition-colors cursor-pointer`}>
        <div className="flex items-center gap-4">
          <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center border border-gray-200">
            {icon}
          </div>
          <div>
            <div className="flex items-center gap-2 mb-1">
              <p className="text-sm text-gray-900">{item.title}</p>
              <Badge variant={item.priority === 'high' ? 'destructive' : 'secondary'} className="text-xs">
                {item.type}
              </Badge>
            </div>
            <p className="text-xs text-gray-500">Submitted by {item.submittedBy} • {item.time}</p>
          </div>
        </div>
        {item.amount && <p className="text-sm text-gray-900">{item.amount}</p>}
      </div>
    );
  }

  // Filter approval queue to show ONLY pending approval items (remove variants)
  const pendingApprovalItems = approvalQueue.filter(item => 
    item.type === 'Project' || item.type === 'Ledger Entry'
  );

  // Route other subpages to their components if requested
  if (['approvals', 'ledger-verification', 'project-verification', 'meeting-minutes'].includes(currentView)) {
    return <ApprovalCenterPage />;
  }

  if (currentView === 'ledger-view') return <LedgerOversightPage />;
  if (currentView === 'feedback-review') return <RolePermissionsPage />;
  if (currentView === 'ratings-analytics') return <RatingsAnalyticsPage />;
  if (currentView === 'organizations') return <OrganizationsPage />;
  if (currentView === 'system-logs') return <SystemLogsPage />;
  if (currentView === 'profile') return <AdminProfilePage />;

  // Default dashboard view
  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      <div>
        <h1 className="text-blue-600 text-2xl font-semibold">Admin Dashboard</h1>
        <p className="text-gray-500">Approvals, verification, and oversight</p>
      </div>

      {(s.tamperedAlerts > 0 || s.isBudgetTampered) && (
        <div className="p-4 rounded-lg bg-red-50 border border-red-200 text-red-800">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-semibold">ALERT: Ledger tampering or budget mismatch detected</p>
              <p className="text-sm">
                {s.tamperedAlerts > 0 && s.isBudgetTampered
                  ? 'One or more ledger entries or project budgets appear inconsistent. Immediate review required.'
                  : s.tamperedAlerts > 0
                  ? 'One or more ledger entries appear to be tampered. Immediate review required.'
                  : 'One or more projects have a budget mismatch. Immediate review required.'}
              </p>
            </div>
            <div>
              <a href="/adviser/ledger" className="text-sm underline">View Ledger</a>
            </div>
          </div>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
        <StatsCard 
          title="Total Pending" 
          value={String(s.pendingApprovals)} 
          hint="Pending Approval" 
          icon={<Clock />} 
          iconBg="bg-orange-50" 
          iconColor="text-orange-600" 
        />
        <StatsCard 
          title="CSG Members" 
          value={String(s.activeCsgCount)} 
          hint="Active officers" 
          icon={<CheckCircle2 />} 
          iconBg="bg-green-50" 
          iconColor="text-green-600" 
        />
        <StatsCard 
          title="Avg. Rating" 
          value={s.avgRating.toFixed(1)} 
          hint="All student ratings" 
          icon={<Star />} 
          iconBg="bg-yellow-50" 
          iconColor="text-yellow-600" 
        />
        <StatsCard 
          title="Budget Mismatch" 
          value={String(s.budgetMismatchCount)} 
          hint="Budget issues" 
          icon={<DollarSign />} 
          iconBg="bg-red-50" 
          iconColor="text-red-600" 
        />
        <StatsCard 
          title="Tampered Alerts" 
          value={String(s.tamperedAlerts)} 
          hint="Blockchain issues" 
          icon={<AlertCircle />} 
          iconBg="bg-red-50" 
          iconColor="text-red-600" 
        />
      </div>

      <Card className="p-6 rounded-2xl border-0 shadow-sm bg-white">
        <div className="flex flex-col gap-4">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            <div>
              <h2 className="text-gray-900">Integrity Heatmap</h2>
              <p className="text-sm text-gray-500">View tampering and CSG activity by month.</p>
            </div>
            <div className="flex items-center gap-2 justify-between">
              <button
                type="button"
                onClick={() => router.get('/adviser', { heatmap_month: prevHeatmapMonth }, {
                  preserveScroll: true,
                  preserveState: true,
                  only: ['charts'],
                })}
                className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
              >
                ← Prev
              </button>
              <div className="rounded-md bg-slate-100 px-3 py-1 text-sm font-medium text-slate-800">
                {heatmapLabel || heatmapMonth || 'This month'}
              </div>
              {canNavigateNext ? (
                <button
                  type="button"
                  onClick={() => router.get('/adviser', { heatmap_month: nextHeatmapMonth }, {
                    preserveScroll: true,
                    preserveState: true,
                    only: ['charts'],
                  })}
                  className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
                >
                  Next →
                </button>
              ) : (
                <span className="rounded-md bg-slate-100 px-3 py-1 text-sm text-slate-400 cursor-not-allowed">
                  Next →
                </span>
              )}
            </div>
          </div>

          <div className="flex flex-wrap gap-3 text-xs text-gray-600">
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-red-600" /> Tampering
            </span>
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-emerald-500" /> CSG Activity
            </span>
            <span className="inline-flex items-center gap-2">
              <span className="h-3 w-3 rounded-sm bg-slate-200 border border-slate-300" /> No activity
            </span>
          </div>

          <div className="grid grid-cols-7 gap-2 text-[11px] text-center text-gray-600">
            <div>Sun</div>
            <div>Mon</div>
            <div>Tue</div>
            <div>Wed</div>
            <div>Thu</div>
            <div>Fri</div>
            <div>Sat</div>
          </div>

          <div className="grid grid-cols-7 gap-2">
            {(() => {
              const firstWeekday = heatmapDaysData.length ? heatmapDaysData[0].weekday : 0;
              return Array.from({ length: firstWeekday }, (_, index) => (
                <div key={`blank-${index}`} className="h-20 rounded-xl bg-transparent" />
              ));
            })()}

            {heatmapDaysData.map((item) => {
              const styles = getHeatmapCellStyles(item);
              return (
                <div
                  key={item.date}
                  className={`${styles.className} rounded-xl p-2 h-20 flex flex-col justify-between transition-all`}
                  style={styles.style}
                  title={`${item.label} ${item.date}: ${formatHeatmapTooltip(item)}`}
                >
                  <span className="text-[11px] uppercase tracking-[0.08em]">{item.day}</span>
                  <span className="text-lg font-semibold">{item.tamperingCount + item.activityCount} <span className="hidden md:flex text-xs font-normal">events</span></span>
                </div>
              );
            })}
          </div>
        </div>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="p-6 rounded-2xl border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-gray-900">Pending Approvals</h2>
          </div>

          <div className="space-y-3">
            {pendingApprovalItems.length === 0 && (
              <div className="text-center py-4">
                <Clock className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                <p className="text-sm text-gray-500">No pending approvals found</p>
                <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
              </div>
            )}
            {pendingApprovalItems.map((item) => (
              <div key={`${item.type}-${item.title}`} className="flex items-center justify-between p-4 bg-white rounded-xl border border-gray-100 hover:shadow-sm transition-all">
                <div className="flex items-center gap-4">
                  <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center border border-gray-200 shadow-sm">
                    {item.type === 'Project' ? <FolderKanban className="w-5 h-5 text-blue-600" /> : <DollarSign className="w-5 h-5 text-green-600" />}
                  </div>
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <p className="text-sm text-gray-900">{item.title}</p>
                      <Badge className="text-xs">
                        {item.type}
                      </Badge>
                    </div>
                    <p className="text-xs text-gray-500">Submitted by {item.submittedBy} • {item.time}</p>
                  </div>
                </div>
                {item.amount && <p className="text-sm text-gray-900">{item.amount}</p>}
              </div>
            ))}
          </div>
        </Card>
       
        <Card className="p-6 rounded-2xl border-0 shadow-sm bg-white">
          <h2 className="text-gray-900 mb-4">Recent Activity</h2>
          <div className="space-y-3">
            {recentActivity.length === 0 && (
              <div className="text-center py-4">
                <Clock className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                <p className="text-sm text-gray-500">No recent activity found</p>
                <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
              </div>
            )}
            {recentActivity.map((activity, index) => (
              <div key={index} className="flex items-center gap-3">
                <div className={`w-2 h-2 rounded-full ${activity.status === 'approved' ? 'bg-green-500' : 'bg-red-500'}`} />
                <div className="flex-1"><p className="text-sm text-gray-900">{activity.action}</p><p className="text-xs text-gray-500">{activity.time}</p></div>
              </div>
            ))}
          </div>
        </Card>
      </div>

    </div>

    
  );
}

// Provide a default export so Inertia's page resolver receives a component (not a module object)
// Page wrapper that provides the authenticated layout (sidebar + header)
export default function AdviserDashboardPage(props) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Admin/Adviser Dashboard</h2>}>
      <Head title="Adviser" />

      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <AdminAdviserDashboard {...props} />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}