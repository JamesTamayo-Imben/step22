import React, { useState, useMemo } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import ReactDOM from 'react-dom';
import { CalendarDays, DollarSign, FolderKanban, Search, Star, X } from 'lucide-react';

const SORT_OPTIONS = [
  { value: 'all', label: 'Default Sorting' },
  { value: 'highest_rating', label: 'Highest Rated' },
  { value: 'highest_income', label: 'Highest Income' },
  { value: 'by_month', label: 'Projects by Month' },
];

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

const isApprovedProject = (project) => (
  (project.approval_status || project.approvalStatus) === 'Approved'
);

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

const getAverageRatingValue = (project) => {
  const rating = getAverageRating(project);
  return rating ? Number(rating.average) : 0;
};

const getProjectStartTimestamp = (project) => {
  const dateValue = project.start_date || project.startDate;
  const date = dateValue ? new Date(dateValue) : null;
  return date && !isNaN(date.getTime()) ? date.getTime() : 0;
};

const getProjectIncome = (project) => {
  const ledgerEntries = project.ledgerEntries || project.ledger_entries || [];
  if (!Array.isArray(ledgerEntries)) {
    return 0;
  }

  return ledgerEntries
    .filter((entry) => (entry.type === 'Income' || entry.transactionType === 'Income') && (entry.approval_status === 'Approved' || entry.status === 'Approved'))
    .reduce((sum, entry) => sum + (Number(entry.amount) || 0), 0);
};

const getProjectMonthDistance = (project, referenceDate = new Date()) => {
  const dateValue = project.start_date || project.startDate || project.end_date || project.endDate;
  const projectDate = dateValue ? new Date(dateValue) : null;
  if (!projectDate || isNaN(projectDate.getTime())) {
    return Number.MAX_SAFE_INTEGER;
  }

  const projectMonth = projectDate.getMonth();
  const referenceMonth = referenceDate.getMonth();
  const diff = Math.abs(projectMonth - referenceMonth);
  return Math.min(diff, 12 - diff);
};

export default function AdviserProjectsPage() {
  const { projects = [] } = usePage().props;

  const [searchQuery, setSearchQuery] = useState('');
  const [sortOption, setSortOption] = useState('all');
  const [selectedProject, setSelectedProject] = useState(null);

  const handleProjectClick = (project) => {
    if (project.approval_status === 'Approved') {
      setSelectedProject(project);
      return;
    }

    router.visit(`/adviser/approvals?project=${encodeURIComponent(project.id)}`);
  };

  const stats = useMemo(() => {
    const computedProjects = projects.filter(isApprovedProject).map((project) => ({
      ...project,
      computedStatus: getCalculatedStatus(project),
    }));

    return {
      total: computedProjects.length,
      ongoing: computedProjects.filter((project) => project.computedStatus === 'Ongoing').length,
      completed: computedProjects.filter((project) => project.computedStatus === 'Completed').length,
    };
  }, [projects]);

  const recommendedProjects = useMemo(() => {
    const now = new Date();
    const candidates = projects
      .filter(isApprovedProject)
      .filter((project) => getCalculatedStatus(project) === 'Completed')
      .filter((project) => getAverageRatingValue(project) > 0)
      .filter((project) => getProjectMonthDistance(project, now) <= 1)
      .map((project) => ({
        ...project,
        averageRating: getAverageRatingValue(project),
        income: getProjectIncome(project),
        startTimestamp: getProjectStartTimestamp(project),
      }))
      .sort((a, b) => {
        if (b.averageRating !== a.averageRating) {
          return b.averageRating - a.averageRating;
        }
        return getProjectIncome(b) - getProjectIncome(a);
      })
      .slice(0, 3);

    const highestRating = Math.max(...candidates.map((project) => project.averageRating), 0);
    const highestIncome = Math.max(...candidates.map((project) => project.income), 0);

    return candidates.map((project) => ({
      ...project,
      recommendationReason: project.averageRating === highestRating
        ? 'Recommended because this project has the highest rating.'
        : project.income === highestIncome
          ? 'Recommended because this project has the highest income.'
          : 'Recommended based on strong recent performance.',
    }));
  }, [projects]);

  const filteredProjects = useMemo(() => {
    const filtered = projects.filter((p) => {
      if (!isApprovedProject(p)) return false;
      const matchesSearch = p.title?.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesSearch;
    });

    const sorted = [...filtered];

    if (sortOption === 'highest_rating') {
      sorted.sort((a, b) => getAverageRatingValue(b) - getAverageRatingValue(a));
    } else if (sortOption === 'highest_income') {
      sorted.sort((a, b) => getProjectIncome(b) - getProjectIncome(a));
    } else if (sortOption === 'by_month') {
      sorted.sort((a, b) => getProjectStartTimestamp(b) - getProjectStartTimestamp(a));
    }

    return sorted;
  }, [projects, searchQuery, sortOption]);

  return (
    <AuthenticatedLayout>
      <Head title="Projects" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-blue-600 text-2xl font-semibold">Admin Project Oversight</h1>
              <p className="text-gray-500">View and Monitor Council Projects.</p>
            </div>
          </div>

          {/* <p>weyt lang - nakalimutan ko ano gagawen dto</p> */}

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
          </div>

          <Card className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
              <div className="relative md:col-span-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Search submissions..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
              <div className="">
                <select
                  value={sortOption}
                  onChange={(e) => setSortOption(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  {SORT_OPTIONS.map((option) => (
                    <option key={option.value} value={option.value}>{option.label}</option>
                  ))}
                </select>
              </div>
            </div>
          </Card>
        </div>

        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6 mt-6">
          <div className="bg-white border p-4 rounded-xl">
            <h1 className="text-blue-700">Project Recommendations</h1>
            {recommendedProjects.length === 0 ? (
              <p className="text-base text-gray-700">There are no recommended projects as of now because the cycle has not begun yet.</p>
            ) : (
              <div className="space-y-4">
                <p className="text-base text-gray-700">Recommended from best-performing past projects near the current month.</p>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
                  {recommendedProjects.map((project) => (
                    <Card
                      key={project.id}
                      role="button"
                      tabIndex={0}
                      onKeyDown={(event) => {
                        if (event.key === 'Enter' || event.key === ' ') handleProjectClick(project);
                      }}
                      className="h-full rounded-[20px] border border-blue-500 bg-white p-4 shadow-sm cursor-pointer hover:shadow-md transition-shadow flex flex-col"
                    >
                      <div className="mb-3">
                        <h2 className="text-sm font-semibold text-gray-900 line-clamp-2">{project.title || 'Untitled Project'}</h2>
                        <p className="text-xs text-gray-500">{project.category || 'Uncategorized'}</p>
                      </div>
                      <div className="flex-1 text-sm text-gray-600 space-y-2">
                        <div className="flex items-center justify-between gap-2">
                          <span>Average Rating</span>
                          <span className="font-semibold text-blue-700">{project.averageRating.toFixed(1)}/5</span>
                        </div>
                        <div className="flex items-center justify-between gap-2">
                          <span>Income</span>
                          <span className="font-semibold text-blue-700">{formatCurrency(project.income ?? getProjectIncome(project))}</span>
                        </div>
                        <div className="flex items-center justify-between gap-2">
                          <span>Timeline</span>
                          <span className="font-semibold text-blue-700">{formatTimeline(project)}</span>
                        </div>
                        <p className="text-xs text-blue-500">Note: {project.recommendationReason}</p>
                      </div>

                      <button
                        type="button"
                        onClick={() => handleProjectClick(project)}
                        className="w-full rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-blue-700 transition-colors duration-200 shadow-sm hover:shadow-md focus:outline-none focus:ring-2 focus:ring-blue-200"
                      >
                        View Details
                      </button>
                    </Card>
                  ))}
                </div>
              </div>
            )}
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
                  <Card
                    key={project.id}
                    role="button"
                    tabIndex={0}
                    onClick={() => handleProjectClick(project)}
                    onKeyDown={(event) => {
                      if (event.key === 'Enter' || event.key === ' ') handleProjectClick(project);
                    }}
                    className="h-full rounded-[20px] border-0 shadow-sm p-6 hover:shadow-md transition-all flex flex-col gap-4 cursor-pointer"
                  >
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
                      className="text-sm text-gray-600 flex-1"
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
                    <button
                      type="button"
                      onClick={() => handleProjectClick(project)}
                      className="mt-auto w-full rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-blue-700 transition-colors duration-200 shadow-sm hover:shadow-md focus:outline-none focus:ring-2 focus:ring-blue-200"
                    >
                      View Details
                    </button>
                  </Card>
                );
              })
            )}
          </div>
        </div>
      </div>

      {selectedProject && ReactDOM.createPortal(
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4" onClick={() => setSelectedProject(null)}>
          <div className="relative w-full max-w-3xl max-h-[90vh] overflow-y-auto rounded-2xl bg-white p-6 shadow-lg" onClick={(event) => event.stopPropagation()}>
            <div className="mb-6 flex items-start justify-between gap-4 border-b pb-4">
              <div>
                <h2 className="text-xl font-semibold text-gray-900">{selectedProject.title || 'Untitled Project'}</h2>
                <p className="mt-1 text-sm text-gray-500">Approved project details</p>
              </div>
              <button type="button" onClick={() => setSelectedProject(null)} className="text-gray-500 hover:text-gray-700" aria-label="Close project details">
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <div><p className="text-xs text-gray-500">Status</p><Badge className="mt-1 rounded-lg bg-green-100 text-green-700">{selectedProject.approval_status || 'Approved'}</Badge></div>
              <div><p className="text-xs text-gray-500">Category</p><p className="mt-1 text-sm text-gray-900">{selectedProject.category || 'Not specified'}</p></div>
              <div><p className="text-xs text-gray-500">Budget</p><p className="mt-1 text-sm text-gray-900">{formatCurrency(selectedProject.budget)}</p></div>
              <div><p className="text-xs text-gray-500">Timeline</p><p className="mt-1 text-sm text-gray-900">{formatTimeline(selectedProject)}</p></div>
              <div><p className="text-xs text-gray-500">Venue</p><p className="mt-1 text-sm text-gray-900">{selectedProject.venue || 'Not specified'}</p></div>
              <div><p className="text-xs text-gray-500">Created By</p><p className="mt-1 text-sm text-gray-900">{selectedProject.created_by || selectedProject.proposed_by || 'Unknown'}</p></div>
              <div className="sm:col-span-2"><p className="text-xs text-gray-500">Objective</p><p className="mt-1 whitespace-pre-wrap text-sm text-gray-900">{selectedProject.objective || 'No objective provided'}</p></div>
              <div className="sm:col-span-2"><p className="text-xs text-gray-500">Description</p><p className="mt-1 whitespace-pre-wrap text-sm text-gray-900">{selectedProject.description || 'No description provided'}</p></div>
            </div>

            <div className="mt-6 flex justify-end border-t pt-4">
              <button type="button" onClick={() => setSelectedProject(null)} className="rounded-xl border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">Close</button>
            </div>
          </div>
        </div>,
        document.body
      )}
    </AuthenticatedLayout>
  );
}