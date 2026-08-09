import React, { useState, useMemo } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { CalendarDays, DollarSign, FolderKanban, Search, Star } from 'lucide-react';

const STATUS_OPTIONS = ['Draft', 'Upcoming', 'Ongoing', 'Completed'];
const APPROVAL_OPTIONS = ['Draft', 'Pending Adviser Approval', 'Approved', 'Rejected'];
const CATEGORY_OPTIONS = ['Social', 'Sports', 'Environmental', 'Technology', 'Cultural', 'Education', 'Health'];

const statusBadgeClass = (status) => {
  switch (status) {
    case 'Ongoing':
      return 'bg-yellow-100 text-yellow-700';
    case 'Completed':
      return 'bg-green-100 text-green-700';
    case 'Upcoming':
      return 'bg-blue-100 text-blue-700';
    default:
      return 'bg-gray-100 text-gray-700';
  }
};

const approvalBadgeClass = (status) => {
  switch (status) {
    case 'Approved':
      return 'bg-green-100 text-green-700';
    case 'Pending Adviser Approval':
      return 'bg-yellow-100 text-yellow-700';
    case 'Rejected':
      return 'bg-red-100 text-red-700';
    default:
      return 'bg-gray-100 text-gray-700';
  }
};

const formatCurrency = (value) => {
  const amount = Number(value ?? 0);
  return new Intl.NumberFormat('en-PH', {
    style: 'currency',
    currency: 'PHP',
    maximumFractionDigits: 0,
  }).format(amount);
};

const formatTimeline = (project) => {
  if (!project.start_date && !project.end_date) {
    return 'Timeline not set';
  }

  const start = project.start_date
    ? new Date(project.start_date).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })
    : null;
  const end = project.end_date
    ? new Date(project.end_date).toLocaleDateString('en-PH', { month: 'short', day: 'numeric', year: 'numeric' })
    : null;

  if (start && end) return `${start} - ${end}`;
  if (start) return `Starts ${start}`;
  if (end) return `Ends ${end}`;
  return 'Timeline not set';
};

const getCalculatedStatus = (project) => {
  const approvalStatus = project.approval_status || project.approvalStatus || 'Draft';

  if (approvalStatus !== 'Approved') {
    return 'Draft';
  }

  if (!project.start_date && !project.end_date && !project.startDate && !project.endDate) {
    return 'Draft';
  }

  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const startDate = new Date(project.start_date || project.startDate);
    const endDate = new Date(project.end_date || project.endDate);
    startDate.setHours(0, 0, 0, 0);
    endDate.setHours(0, 0, 0, 0);

    if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
      return 'Draft';
    }

    if (today < startDate) {
      return 'Upcoming';
    }

    if (today > endDate) {
      return 'Completed';
    }

    if (today >= startDate && today <= endDate) {
      return 'Ongoing';
    }

    return 'Draft';
  } catch (error) {
    return 'Draft';
  }
};

const getAverageRating = (project) => {
  const ratings = Array.isArray(project.ratings) ? project.ratings : [];
  if (!ratings.length) {
    return null;
  }

  const average = ratings.reduce((sum, rating) => {
    const ratingScore = rating?.rating_score != null
      ? Number(rating.rating_score)
      : ((Number(rating?.satisfaction_rating ?? rating?.satisfactionRating ?? 0) +
          Number(rating?.engagement_rating ?? rating?.engagementRating ?? 0) +
          Number(rating?.completeness_rating ?? rating?.completenessRating ?? 0)) / 3);

    return sum + ratingScore;
  }, 0) / ratings.length;

  return { average: average.toFixed(1), count: ratings.length };
};

export default function AdviserProjectsPage() {
  const { projects = [] } = usePage().props;

  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [approvalFilter, setApprovalFilter] = useState('all');
  const [categoryFilter, setCategoryFilter] = useState('all');

  const stats = useMemo(() => {
    const computedProjects = projects.map((project) => ({
      ...project,
      computedStatus: getCalculatedStatus(project),
    }));

    return {
      total: computedProjects.length,
      ongoing: computedProjects.filter((project) => project.computedStatus === 'Ongoing').length,
      completed: computedProjects.filter((project) => project.computedStatus === 'Completed').length,
      rejected: computedProjects.filter((project) => project.approval_status === 'Rejected').length,
    };
  }, [projects]);

  const filteredProjects = useMemo(() => {
    return projects.filter((p) => {
      const computedStatus = getCalculatedStatus(p);
      const matchesSearch = p.title?.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = statusFilter === 'all' || computedStatus === statusFilter;
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

          {/* <p>weyt lang - nakalimutan ko ano gagawen dto</p> */}

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
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-6">
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
              filteredProjects.map((project) => {
                const averageRating = getAverageRating(project);
                const computedStatus = getCalculatedStatus(project);

                return (
                  <Card key={project.id} className="rounded-[20px] border-0 shadow-sm p-6 hover:shadow-md transition-all flex flex-col gap-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <h3 className="font-semibold text-gray-900 line-clamp-2">{project.title || 'Untitled Project'}</h3>
                      </div>
                      <Badge className={`rounded-full ${statusBadgeClass(computedStatus)}`}>
                        {computedStatus}
                      </Badge>
                    </div>

                    <div className="flex flex-wrap gap-2">
                      <Badge className="bg-gray-100 text-gray-700 rounded-lg">{project.category || 'Uncategorized'}</Badge>
                      <Badge className={`rounded-lg ${approvalBadgeClass(project.approval_status)}`}>
                        {project.approval_status || 'Draft'}
                      </Badge>
                    </div>

                    <p
                      className="text-sm text-gray-600"
                      style={{ display: '-webkit-box', WebkitLineClamp: 3, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}
                      title={project.description}
                    >
                      {project.description || 'No description provided for this project yet.'}
                    </p>

                    <div className="grid grid-cols-2 gap-3 text-sm">
                      <div className="rounded-xl bg-gray-50 p-3">
                        <div className="flex items-center gap-2 text-gray-500 text-xs uppercase tracking-wide">
                          <CalendarDays className="w-3.5 h-3.5" />
                          Timeline
                        </div>
                        <p className="mt-1 font-medium text-gray-900">{formatTimeline(project)}</p>
                      </div>
                      <div className="rounded-xl bg-gray-50 p-3">
                        <div className="flex items-center gap-2 text-gray-500 text-xs uppercase tracking-wide">
                          <DollarSign className="w-3.5 h-3.5" />
                          Budget
                        </div>
                        <p className="mt-1 font-medium text-gray-900">{formatCurrency(project.budget)}</p>
                      </div>
                    </div>

                    <div className="rounded-xl border border-gray-100 p-3 flex items-center justify-between">
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <Star className="w-4 h-4 text-amber-500 fill-current" />
                        <span>
                          {averageRating ? `${averageRating.average}/5` : 'No ratings yet'}
                        </span>
                      </div>
                      <span className="text-xs text-gray-500">
                        {averageRating ? `${averageRating.count} review${averageRating.count > 1 ? 's' : ''}` : 'Be the first to rate'}
                      </span>
                    </div>
                  </Card>
                );
              })
            )}
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}