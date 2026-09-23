import React from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import {
  Users,
  Shield,
  Activity,
  Database,
  TrendingUp,
  AlertCircle,
  BarChart3,
  PieChart as PieChartIcon,
} from 'lucide-react';

const PieChart = ({ data, colors }) => {
  // Validate data
  if (!data || data.length === 0) {
    return <div className="text-gray-500 text-sm">No data available</div>;
  }

  const total = data.reduce((sum, item) => sum + (item.value || 0), 0);
  
  if (total === 0) {
    return <div className="text-gray-500 text-sm">All values are zero</div>;
  }

  let offset = 0;
  const slices = data.map((item, idx) => {
    const percentage = ((item.value || 0) / total) * 100;
    const startAngle = (offset / 100) * 360;
    const endAngle = ((offset + percentage) / 100) * 360;
    const startRad = (startAngle * Math.PI) / 180;
    const endRad = (endAngle * Math.PI) / 180;

    const x1 = parseFloat((50 + 45 * Math.cos(startRad)).toFixed(2));
    const y1 = parseFloat((50 + 45 * Math.sin(startRad)).toFixed(2));
    const x2 = parseFloat((50 + 45 * Math.cos(endRad)).toFixed(2));
    const y2 = parseFloat((50 + 45 * Math.sin(endRad)).toFixed(2));

    const largeArc = percentage > 50 ? 1 : 0;

    const pathData = [
      `M 50 50`,
      `L ${x1} ${y1}`,
      `A 45 45 0 ${largeArc} 1 ${x2} ${y2}`,
      'Z',
    ].join(' ');

    offset += percentage;
    return { 
      pathData, 
      color: colors[idx] || '#6b7280', 
      label: item.name, 
      value: item.value || 0 
    };
  });

  const fullCircle = slices.length === 1 || slices.some((slice) => slice.value === total);

  return (
    <div className="flex items-center gap-4">
      <svg width="120" height="120" viewBox="0 0 100 100">
        {fullCircle
          ? <circle cx="50" cy="50" r="45" fill={slices.find((slice) => slice.value === total)?.color || '#6b7280'} stroke="white" strokeWidth="1" />
          : slices.map((slice, idx) => (
            <path key={idx} d={slice.pathData} fill={slice.color} stroke="white" strokeWidth="1" />
          ))}
      </svg>
      <div className="space-y-2 text-sm">
        {slices.map((slice, idx) => (
          <div key={idx} className="flex items-center gap-2">
            <div className="w-3 h-3 rounded-full" style={{ backgroundColor: slice.color }}></div>
            <span className="text-gray-600">{slice.label}: {slice.value}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

const LineChart = ({ data }) => {
  const maxValue = Math.max(...data.map(d => d.count), 1);
  return (
    <div className="flex items-end gap-2 h-32">
      {data.map((item, idx) => (
        <div key={idx} className="flex-1 flex flex-col items-center gap-2">
          <div
            className="w-full bg-blue-500 rounded-t transition-all"
            style={{
              height: `${(item.count / maxValue) * 100}%`,
              minHeight: item.count > 0 ? '4px' : '2px',
            }}
          ></div>
          <span className="text-xs text-gray-500 text-center">{item.date}</span>
        </div>
      ))}
    </div>
  );
};

const BarChart = ({ data }) => {
  const maxValue = Math.max(...data.map(d => d.value), 1);
  return (
    <div className="space-y-3">
      {data.slice(0, 5).map((item, idx) => (
        <div key={idx}>
          <div className="flex items-center justify-between mb-1">
            <span className="text-sm text-gray-700">{item.name}</span>
            <span className="text-sm font-semibold text-gray-900">{item.value}</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className="bg-blue-500 h-2 rounded-full transition-all"
              style={{ width: `${(item.value / maxValue) * 100}%` }}
            ></div>
          </div>
        </div>
      ))}
    </div>
  );
};

const AuditHeatmap = ({ data, heatmapLabel, prevHeatmapMonth, nextHeatmapMonth, canNavigateNext }) => {
  const getCellStyles = (item) => {
    const tampering = Number(item.tamperingCount) || 0;
    const activity = Number(item.activityCount) || 0;
    const total = tampering + activity;

    if (!total) return { className: 'bg-slate-200 text-slate-700 border border-slate-300' };
    if (!tampering) return { className: 'bg-emerald-500 text-white' };
    if (!activity) return { className: 'bg-red-600 text-white' };

    const tamperingPercent = Math.round((tampering / total) * 100);
    return {
      className: 'text-white',
      style: {
        background: `linear-gradient(90deg, #dc2626 ${tamperingPercent}%, #10b981 ${tamperingPercent}%)`,
      },
    };
  };

  const handleMonthChange = (month) => {
    if (!month) return;

    router.get('/sadmin', { heatmap_month: month }, {
      preserveScroll: true,
      preserveState: true,
      only: ['charts'],
    });
  };

  return (
    <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
      <div className="flex flex-col gap-6 mb-2 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-gray-900 font-semibold">Audit Activity</h2>
          <p className="text-sm text-gray-500">System activity and tampering events by month.</p>
        </div>
        <div className="flex w-full items-center justify-between gap-1.5 sm:w-auto sm:justify-center">
          <button
            type="button"
            onClick={() => handleMonthChange(prevHeatmapMonth)}
            className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
          >
            ← Prev
          </button>
          <div className="flex-1 rounded-md bg-slate-100 px-3 py-1 text-center text-sm font-medium text-slate-800 sm:flex-none">{heatmapLabel || 'This month'}</div>
          {canNavigateNext ? (
            <button
              type="button"
              onClick={() => handleMonthChange(nextHeatmapMonth)}
              className="rounded-md border border-slate-200 bg-white px-3 py-1 text-sm text-slate-700 hover:bg-slate-50"
            >
              Next →
            </button>
          ) : (
            <span className="rounded-md bg-slate-100 px-3 py-1 text-sm text-slate-400 cursor-not-allowed">Next →</span>
          )}
        </div>
      </div>
      <div className="flex gap-3 text-xs text-gray-600 mb-4 w-full items-center justify-between sm:w-auto sm:justify-start">
        <span className="inline-flex items-center gap-2"><span className="h-3 w-3 rounded-sm bg-red-600" /> Tampering</span>
        <span className="inline-flex items-center gap-2"><span className="h-3 w-3 rounded-sm bg-emerald-500" /> System activity</span>
        <span className="inline-flex items-center gap-2"><span className="h-3 w-3 rounded-sm bg-slate-200 border border-slate-300" /> No activity</span>
      </div>

      <div className="grid grid-cols-7 gap-1 sm:gap-2 text-[11px] text-center text-gray-600">
        {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => <div key={day}>{day}</div>)}
      </div>
      <div className="grid grid-cols-7 gap-1 sm:gap-2 mt-2">
        {Array.from({ length: data[0]?.weekday || 0 }, (_, index) => <div key={`blank-${index}`} className="h-20" />)}
        {data.map((item) => {
          const total = Number(item.tamperingCount || 0) + Number(item.activityCount || 0);
          const hasActivity = total > 0;

          return (
            <div
              key={item.date}
              className={`${getCellStyles(item).className} rounded-xl p-2 h-20 flex flex-col justify-between transition-all ${!hasActivity ? 'opacity-90' : ''}`}
              style={getCellStyles(item).style}
              title={`${item.label} ${item.date}: ${item.tamperingCount} tampering event${item.tamperingCount !== 1 ? 's' : ''}, ${item.activityCount} system activit${item.activityCount !== 1 ? 'ies' : 'y'}`}
            >
              <span className="text-[11px] uppercase tracking-[0.08em]">{item.day}</span>
              {hasActivity ? (
                <div className="flex h-full items-center justify-center">
                  <div className="flex flex-col items-center justify-center text-center gap-0.5 sm:gap-1">
                    <span className="flex items-center justify-center gap-1 text-lg font-semibold leading-none">
                      {item.tamperingCount > 0 && item.activityCount > 0 ? (
                        <span className="inline-flex items-center gap-1">
                          <span className="text-base">⚠</span>
                          <span className="text-sm">{total}</span>
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1">
                          <span className="text-base">{item.tamperingCount > 0 ? '⚠' : '✓'}</span>
                          <span className="text-sm">{total}</span>
                        </span>
                      )}
                    </span>

                    <span className="hidden text-[10px] font-medium leading-none text-white/90 sm:block">
                      {item.tamperingCount > 0 && item.activityCount > 0
                        ? `${item.activityCount} act / ${item.tamperingCount} tam`
                        : item.tamperingCount > 0
                          ? `${item.tamperingCount} tam`
                          : `${item.activityCount} act`}
                    </span>
                  </div>
                </div>
              ) : (
                <span className="text-[10px] text-slate-500">—</span>
              )}
            </div>
          );
        })}
      </div>
    </Card>
  );
};

export default function SAdminDashboard({ stats = {}, charts = {} }) {
  const s = {
    totalUsers: stats.totalUsers ?? 0,
    activeRoles: stats.activeRoles ?? 0,
    approvedProjects: stats.approvedProjects ?? 0,
    pendingApprovals: stats.pendingApprovals ?? 0,
    auditEventsWeek: stats.auditEventsWeek ?? 0,
    totalCsgOfficers: stats.totalCsgOfficers ?? 0,
    totalAdvisers: stats.totalAdvisers ?? 0,
  };

  // Combine teacher and student into member role
  const processedUsersByRole = (charts.usersByRole ?? []).reduce((acc, item) => {
    const lowerName = item.name.toLowerCase().trim();
    if (lowerName.includes('teacher') || lowerName.includes('student')) {
      const existingMember = acc.find(r => r.name === 'Member (Teacher & Student)');
      if (existingMember) {
        existingMember.value += item.value;
      } else {
        acc.push({ name: 'Member (Teacher & Student)', value: item.value });
      }
    } else {
      acc.push(item);
    }
    return acc;
  }, []);

  const chartData = {
    projectStatus: charts.projectStatus ?? [],
    auditByDay: charts.auditByDay ?? [],
    auditHeatmap: charts.auditHeatmap ?? [],
    usersByRole: processedUsersByRole,
    ledgerStatus: charts.ledgerStatus ?? [],
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Super Admin</h2>}>
      <Head title="Super Admin" />


      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            <div>
              <h1 className="text-blue-600 text-2xl font-semibold">Superadmin Dashboard</h1>
              <p className="text-gray-500">Complete system oversight and management</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Total Users</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.totalUsers.toLocaleString()}</p>
                    <p className="text-xs text-gray-500 mt-1">Active users (not archived)</p>
                  </div>
                  <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                    <Users className="w-6 h-6 text-purple-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Active Roles</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.activeRoles}</p>
                    <p className="text-xs text-gray-500 mt-1">Configured</p>
                  </div>
                  <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                    <Shield className="w-6 h-6 text-blue-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">CSG Officers</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.totalCsgOfficers}</p>
                    <p className="text-xs text-gray-500 mt-1">Active positions</p>
                  </div>
                  <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                    <Activity className="w-6 h-6 text-green-600" />
                  </div>
                </div>
              </Card>

              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Admins</p>
                    <p className="text-2xl text-gray-900 mt-1">{s.totalAdvisers}</p>
                    <p className="text-xs text-gray-500 mt-1">Assigned advisers</p>
                  </div>
                  <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                    <Database className="w-6 h-6 text-orange-600" />
                  </div>
                </div>
              </Card>
            </div>

            {/* //here */}
              {/* Analytics Charts */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Project Status Chart */}
              <Card className="p-6 items-center rounded-[20px] border-0 shadow-sm bg-white">
                  <div className="flex items-center gap-2 mb-4">
                    <PieChartIcon className="w-5 h-5 text-blue-600" />
                    <h2 className="text-gray-900 font-semibold">Project Status Distribution</h2>
                  </div>
                  <PieChart
                    data={chartData.projectStatus}
                    colors={['#10b981', '#f97316', '#ef4444', '#6b7280']}
                  />
              </Card>

              {/* Ledger Status Chart */}
              {chartData.ledgerStatus.length > 0 && (
                <Card className="items-center p-6 rounded-[20px] border-0 shadow-sm bg-white">
                  <div className="flex items-center gap-2 mb-4">
                    <PieChartIcon className="w-5 h-5 text-green-600" />
                    <h2 className="text-gray-900 font-semibold">Ledger Entry Status</h2>
                  </div>
                  <PieChart
                    data={chartData.ledgerStatus}
                    colors={['#10b981', '#f97316', '#ef4444']}
                  />
                </Card>
              )}
            </div>

            <AuditHeatmap
              data={chartData.auditHeatmap}
              heatmapLabel={charts.heatmapLabel}
              prevHeatmapMonth={charts.prevHeatmapMonth}
              nextHeatmapMonth={charts.nextHeatmapMonth}
              canNavigateNext={charts.canNavigateNext}
            />

          

            {/* Audit Activity Chart */}
           

            {/* Users by Role Chart */}
            {/* {chartData.usersByRole.length > 0 && (
              <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
                <div className="flex items-center gap-2 mb-6">
                  <BarChart3 className="w-5 h-5 text-purple-600" />
                  <h2 className="text-gray-900 font-semibold">Users by Role</h2>
                </div>
                <BarChart data={chartData.usersByRole} />
              </Card>
            )} */}
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
