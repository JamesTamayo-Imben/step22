import { FolderKanban, Calendar, DollarSign, Star, Users, Plus } from 'lucide-react';
import { Badge } from '@/Components/ui/badge';
import { Card } from '@/Components/ui/card';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { CSGOfficerSidebar } from '@/Components/CSGOfficerSidebar';
import { Head } from '@inertiajs/react';
import React from 'react';
import ProjectsPage from './Projects';

export function Button({ children, className = "", variant = "default", ...props }) {
  const baseStyles = "inline-flex items-center justify-center px-4 py-2 font-medium rounded-lg transition-colors";
  const variants = {
    default: "bg-gray-900 text-white hover:bg-gray-800",
    outline: "border border-gray-300 text-gray-900 hover:bg-gray-50",
  };
  return (
    <button className={`${baseStyles} ${variants[variant]} ${className}`} {...props}>
      {children}
    </button>
  );
}

// Placeholder sub-pages (project can replace with full implementations)
function LedgerPage() { return <Card className="p-8">Ledger (placeholder)</Card>; }
function ProofPage() { return <Card className="p-8">Proof Documents (placeholder)</Card>; }
function MeetingsPage() { return <Card className="p-8">Meetings (placeholder)</Card>; }
function RatingsPage() { return <Card className="p-8">Ratings (placeholder)</Card>; }
function PerformancePage() { return <Card className="p-8">Performance Panel (placeholder)</Card>; }
function ProfilePage() { return <Card className="p-8">Profile (placeholder)</Card>; }

export function CSGOfficerDashboard({ currentView, onNavigate }) {

  // Route to sub-pages
  if (currentView === 'projects') return <ProjectsPage />;
  if (currentView === 'ledger') return <LedgerPage />;
  if (currentView === 'proof') return <ProofPage />;
  if (currentView === 'meetings') return <MeetingsPage />;
  if (currentView === 'ratings') return <RatingsPage />;
  if (currentView === 'performance-panel') return <PerformancePage />;
  if (currentView === 'profile') return <ProfilePage />;

  // Default dashboard view
  return (
    <div className="space-y-6 max-w-7xl mx-auto px-4">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-gray-900 text-2xl font-semibold">CSG Officer Dashboard</h1>
          <p className="text-gray-500">Manage projects, ledger, and student engagement</p>
        </div>
        <div className="hidden md:flex gap-3">
          <Button className="bg-green-600 hover:bg-green-700 rounded-xl">
            <Plus className="w-4 h-4 mr-2" />
            New Project
          </Button>
          <Button variant="outline" className="rounded-xl">
            <DollarSign className="w-4 h-4 mr-2" />
            Add Entry
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Active Projects</p>
              <p className="text-2xl text-gray-900 mt-1">12</p>
              <p className="text-xs text-green-600 mt-1">3 pending approval</p>
            </div>
            <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
              <FolderKanban className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </Card>

        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Budget Balance</p>
              <p className="text-2xl text-gray-900 mt-1">₱45.2K</p>
              <p className="text-xs text-gray-500 mt-1">72% of total budget</p>
            </div>
            <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
              <DollarSign className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </Card>

        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Avg. Rating</p>
              <p className="text-2xl text-gray-900 mt-1">4.5</p>
              <p className="text-xs text-yellow-600 mt-1">★★★★☆ (245 ratings)</p>
            </div>
            <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
              <Star className="w-6 h-6 text-yellow-600" />
            </div>
          </div>
        </Card>

        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Student Engagement</p>
              <p className="text-2xl text-gray-900 mt-1">87%</p>
              <p className="text-xs text-green-600 mt-1">↑ 8% from last month</p>
            </div>
            <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
              <Users className="w-6 h-6 text-purple-600" />
            </div>
          </div>
        </Card>
      </div>

      <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-gray-900">Active Projects</h2>
          <button onClick={() => onNavigate && onNavigate('projects')} className="text-sm text-green-600 hover:underline">
            View All
          </button>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {[
            { title: 'Community Outreach Program', status: 'In Progress', budget: '₱25,000', spent: '₱18,500', progress: 74, deadline: 'Dec 15, 2024' },
            { title: 'Annual Sports Fest', status: 'Planning', budget: '₱35,000', spent: '₱5,200', progress: 15, deadline: 'Jan 20, 2025' },
          ].map((project, index) => (
            <div key={index} className="p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors">
              <div className="flex items-start justify-between mb-3">
                <div>
                  <p className="text-sm text-gray-900">{project.title}</p>
                  <p className="text-xs text-gray-500 mt-1">Due: {project.deadline}</p>
                </div>
                <Badge variant="secondary" className="text-xs">{project.status}</Badge>
              </div>
              <div className="space-y-2">
                <div className="flex items-center justify-between text-xs">
                  <span className="text-gray-500">Progress</span>
                  <span className="text-gray-900">{project.progress}%</span>
                </div>
                <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div className="h-full bg-green-600 rounded-full transition-all" style={{ width: `${project.progress}%` }}></div>
                </div>
                <div className="flex items-center justify-between text-xs">
                  <span className="text-gray-500">Budget: {project.spent} / {project.budget}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <h2 className="text-gray-900 mb-4">Recent Ledger Entries</h2>
          <div className="space-y-3">
            {[
              { desc: 'Sports Equipment Purchase', amount: '-₱15,450', status: 'Pending', type: 'expense' },
              { desc: 'Student Council Fund', amount: '+₱50,000', status: 'Verified', type: 'income' },
              { desc: 'Event Supplies', amount: '-₱8,250', status: 'Verified', type: 'expense' },
            ].map((entry, index) => (
              <div key={index} className="flex items-center justify-between py-3 border-b border-gray-100 last:border-0">
                <div className="flex items-center gap-3">
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${entry.type === 'income' ? 'bg-green-100' : 'bg-red-100'}`}>
                    <DollarSign className={`w-4 h-4 ${entry.type === 'income' ? 'text-green-600' : 'text-red-600'}`} />
                  </div>
                  <div>
                    <p className="text-sm text-gray-900">{entry.desc}</p>
                    <p className="text-xs text-gray-500">{entry.status}</p>
                  </div>
                </div>
                <p className={`text-sm ${entry.type === 'income' ? 'text-green-600' : 'text-red-600'}`}>{entry.amount}</p>
              </div>
            ))}
          </div>
        </Card>

        <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
          <h2 className="text-gray-900 mb-4">Upcoming Meetings</h2>
          <div className="space-y-3">
            {[
              { title: 'General Assembly', date: 'Nov 28, 2024', time: '2:00 PM', attendees: 250 },
              { title: 'Budget Planning Session', date: 'Dec 2, 2024', time: '10:00 AM', attendees: 15 },
              { title: 'Project Review Meeting', date: 'Dec 5, 2024', time: '3:00 PM', attendees: 30 },
            ].map((meeting, index) => (
              <div key={index} className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Calendar className="w-5 h-5 text-green-600" />
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-900">{meeting.title}</p>
                  <p className="text-xs text-gray-500">{meeting.date} • {meeting.time}</p>
                  <p className="text-xs text-gray-400 mt-1">{meeting.attendees} expected attendees</p>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </div>
    </div>
  );
}

// Default export — page wrapper with AuthenticatedLayout + sidebar
export default function CSGDashboardPage(props) {
  const [currentView, setCurrentView] = React.useState('dashboard');
  const onNavigate = (view) => setCurrentView(view);
  const handleLogout = () => { window.location.href = '/logout'; };

  return (
    <div className="flex min-h-screen bg-gray-50">
      <CSGOfficerSidebar
        currentView={currentView}
        onNavigate={onNavigate}
        onLogout={handleLogout}
        userData={{ canSwitch: true }}
      />
      <div className="flex-1 min-w-0">
        <AuthenticatedLayout header="Dashboard">
          <Head title="CSG Dashboard" />
          <div className="py-6  pl-64">
            <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
              <CSGOfficerDashboard currentView={currentView} onNavigate={onNavigate} />
            </div>
          </div>
        </AuthenticatedLayout>
      </div>
    </div>
  );
}