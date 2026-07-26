import React, { useState, useMemo } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { FolderKanban, Search } from 'lucide-react';

const STATUS_OPTIONS = ['Draft', 'Upcoming', 'Ongoing', 'Completed'];
const APPROVAL_OPTIONS = ['Draft', 'Pending Adviser Approval', 'Approved'];
const CATEGORY_OPTIONS = ['Social', 'Sports', 'Environmental', 'Technology', 'Cultural', 'Education', 'Health'];

const approvalBadgeClass = (status) => {
  switch (status) {
    case 'Approved':
      return 'bg-green-100 text-green-700';
    case 'Pending Adviser Approval':
      return 'bg-yellow-100 text-yellow-700';
    default:
      return 'bg-gray-100 text-gray-700';
  }
};

export default function AdviserProjectsPage() {
  const { projects = [] } = usePage().props;

  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [approvalFilter, setApprovalFilter] = useState('all');
  const [categoryFilter, setCategoryFilter] = useState('all');

  const stats = useMemo(() => ({
    total: projects.length,
    ongoing: projects.filter(p => p.status === 'Ongoing').length,
    completed: projects.filter(p => p.status === 'Completed').length,
    rejected: projects.filter(p => p.approval_status === 'Rejected').length,
  }), [projects]);

  const filteredProjects = useMemo(() => {
    return projects.filter((p) => {
      const matchesSearch = p.title?.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = statusFilter === 'all' || p.status === statusFilter;
      const matchesApproval = approvalFilter === 'all' || p.approval_status === approvalFilter;
      const matchesCategory = categoryFilter === 'all' || p.category === categoryFilter;
      return matchesSearch && matchesStatus && matchesApproval && matchesCategory;
    });
  }, [projects, searchQuery, statusFilter, approvalFilter, categoryFilter]);

  return (
    <AuthenticatedLayout>
      <Head title="Projects" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-gray-900 text-2xl font-semibold">Projects</h1>
              <p className="text-gray-500">View and Monitor Council Projects.</p>
            </div>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Total Projects</p>
                  <p className="text-2xl text-gray-900">{stats.total}</p>
                </div>
                <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
                  <FolderKanban className="w-8 h-8 text-blue-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Ongoing Projects</p>
                  <p className="text-2xl text-gray-900">{stats.ongoing}</p>
                </div>
                <div className="w-12 h-12 bg-yellow-50 rounded-xl flex items-center justify-center">
                  <FolderKanban className="w-8 h-8 text-yellow-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Completed Projects</p>
                  <p className="text-2xl text-gray-900">{stats.completed}</p>
                </div>
                <div className="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
                  <FolderKanban className="w-8 h-8 text-green-600" />
                </div>
              </div>
            </Card>
            <Card className="rounded-[20px] p-4 border-0 shadow-sm">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-700">Rejected Projects</p>
                  <p className="text-2xl text-gray-900">{stats.rejected}</p>
                </div>
                <div className="w-12 h-12 bg-red-50 rounded-xl flex items-center justify-center">
                  <FolderKanban className="w-8 h-8 text-red-600" />
                </div>
              </div>
            </Card>
          </div>

          <Card className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div className="relative md:col-span-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Search submissions..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
              <div>
                <select
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all">All Project Status</option>
                  {STATUS_OPTIONS.map((s) => (
                    <option key={s} value={s}>{s}</option>
                  ))}
                </select>
              </div>
              <div>
                <select
                  value={approvalFilter}
                  onChange={(e) => setApprovalFilter(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all">All Approval Status</option>
                  {APPROVAL_OPTIONS.map((s) => (
                    <option key={s} value={s}>{s}</option>
                  ))}
                </select>
              </div>
              <div>
                <select
                  value={categoryFilter}
                  onChange={(e) => setCategoryFilter(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all">All Categories</option>
                  {CATEGORY_OPTIONS.map((c) => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>
            </div>
          </Card>
        </div>

        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6 mt-6">
          <div className="bg-blue-50 border border-blue-500 p-4 rounded-xl">
            <h1 className="text-blue-700">Project Recommendations</h1>
            <p className="text-base text-gray-700">There are no recommended projects as of now because the cycle has not begun yet.</p>
          </div>
        </div>

        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 mt-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredProjects.length === 0 ? (
             <Card className="col-span-full rounded-[20px] border-0 shadow-sm p-12">
          <div className="text-center">
            <FolderKanban className="w-12 h-12 text-gray-300 mx-auto mb-3" />
          <p className="text-sm text-gray-500">No active projects found</p>
            <p className="text-xs text-gray-400 mt-1 mb-4">Create project first
            </p>
          </div>
        </Card>
            ) : (
              filteredProjects.map((project) => (
                <Card key={project.id} className="rounded-[20px] border-0 shadow-sm p-6 hover:shadow-md transition-all">
                  <div className="mb-4">
                    <div className="flex items-start justify-between mb-2">
                      <h3 className="font-semibold text-gray-900 flex-1 truncate">{project.title}</h3>
                    </div>
                    <div className="flex flex-wrap gap-2">
                      <Badge className="bg-gray-100 text-gray-700 rounded-lg">{project.category}</Badge>
                      <Badge className={`rounded-lg ${approvalBadgeClass(project.approval_status)}`}>
                        {project.approval_status}
                      </Badge>
                    </div>
                  </div>

                  <p className="text-sm text-gray-600 mb-4 line-clamp-2">{project.description}</p>

                  <div className="mb-4">
                    <div className="flex items-center justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-gray-500">Progress</span>
                        <Badge className="rounded-lg bg-gray-100 text-gray-700">{project.status}</Badge>
                      </div>
                      <span className="text-xs font-medium text-gray-900">{project.progress ?? 0}%</span>
                    </div>
                    <div className="w-full h-2 bg-gray-100 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-blue-600 rounded-full transition-all"
                        style={{ width: `${project.progress ?? 0}%` }}
                      />
                    </div>
                  </div>
                </Card>
              ))
            )}
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}