import React, { useState, useEffect, useMemo } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import { Avatar, AvatarFallback } from '@/Components/ui/avatar';
// import { Button } from '@/Components/ui/button';
import {
  Star,
  TrendingUp,
  ThumbsUp,
  MessageSquare,
  Filter,
  CheckCircle,
  Clock,
  Search,
  Download,
  StarHalf,
  ChevronLeft,
  ChevronRight,
} from 'lucide-react';

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

// Mask user name for privacy: "John Doe" becomes "J******* D*******"
function maskUserName(fullName) {
  if (!fullName) return '******* *******';
  const names = fullName.trim().split(/\s+/).filter(Boolean);
  if (names.length === 0) return '******* *******';
  
  return names
    .map((name) => {
      if (name.length <= 1) return name;
      return name[0] + '*'.repeat(name.length - 1);
    })
    .join(' ');
}

function Select({ className = '', children, value, onValueChange, ...props }) {
  return (
    <select
      className={[
        'w-full h-10 px-3 border border-gray-200 rounded-xl bg-white outline-none focus:ring-2 focus:ring-blue-200 focus:border-blue-300',
        className,
      ].join(' ')}
      value={value}
      onChange={(e) => onValueChange?.(e.target.value)}
      {...props}
    >
      {children}
    </select>
  );
}

function csvEscape(val) {
  const s = String(val ?? '');
  if (/[",\n\r]/.test(s)) return `"${s.replace(/"/g, '""')}"`;
  return s;
}

function inDateRange(isoOrDate, dateRange) {
  if (dateRange === 'all') return true;
  if (!isoOrDate) return true;
  const d = new Date(isoOrDate);
  if (Number.isNaN(d.getTime())) return true;
  const now = new Date();
  const days = dateRange === 'week' ? 7 : dateRange === 'month' ? 30 : 90;
  const start = new Date(now);
  start.setDate(start.getDate() - days);
  return d >= start;
}

const ITEMS_PER_PAGE = 5;

function CSGRatingsPageInner({ projectSummaries: initialProjects, recentComments: initialComments, kpi: initialKpi }) {
  const [selectedProject, setSelectedProject] = useState('all');
  const [selectedRating, setSelectedRating] = useState('all');
  const [dateRange, setDateRange] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [sortBy, setSortBy] = useState('highest');
  const [projectSummaries, setProjectSummaries] = useState(initialProjects || []);
  const [recentComments, setRecentComments] = useState(initialComments || []);
  const [kpi, setKpi] = useState(initialKpi || {});
  const [loading, setLoading] = useState(false);

 const [currentPage, setCurrentPage] = useState(1);

  // Fetch data if not provided via Inertia props
  useEffect(() => {
    if (!initialProjects || initialProjects.length === 0) {
      setLoading(true);
      fetch('/api/csg/ratings')
        .then(res => res.json())
        .then(data => {
          setProjectSummaries(data.projectSummaries || []);
          setRecentComments(data.recentComments || []);
          setKpi(data.kpi || {});
        })
        .catch(err => {
          console.error('Failed to fetch ratings:', err);
          showToast('Failed to load ratings data', 'error');
        })
        .finally(() => setLoading(false));
    }
  }, [initialProjects]);

  // Filter comments based on all filters
  const filteredComments = useMemo(() => {
    const q = searchQuery.toLowerCase();
    return recentComments.filter((comment) => {
      const matchesProject = selectedProject === 'all' || comment.projectId === selectedProject;
      const matchesRating = selectedRating === 'all' || String(comment.rating) === selectedRating;
      const matchesSearch = 
        (comment.studentName || '').toLowerCase().includes(q) ||
        (comment.comment || '').toLowerCase().includes(q) ||
        (comment.projectName || '').toLowerCase().includes(q);
      const matchesDate = inDateRange(comment.createdAt || comment.date, dateRange);
      return matchesProject && matchesRating && matchesSearch && matchesDate;
    });
  }, [dateRange, searchQuery, selectedProject, selectedRating, recentComments]);

  // Filter and sort projects
  const filteredProjects = useMemo(() => {
    let projects = selectedProject === 'all'
      ? projectSummaries
      : projectSummaries.filter((p) => p.id === selectedProject);

    // Apply rating filter to projects based on their average rating
    if (selectedRating !== 'all') {
      const ratingNum = parseInt(selectedRating);
      projects = projects.filter(p => Math.floor(p.averageRating) === ratingNum);
    }

    // Apply sorting
    return [...projects].sort((a, b) => {
      if (sortBy === 'highest') return b.averageRating - a.averageRating;
      if (sortBy === 'lowest') return a.averageRating - b.averageRating;
      if (sortBy === 'most-rated') return b.totalRatings - a.totalRatings;
      return 0;
    });
  }, [projectSummaries, selectedProject, selectedRating, sortBy]);

  // Pagination operates on the rendered project cards, not the raw rating rows
    const totalPages = Math.max(1, Math.ceil(filteredProjects.length / ITEMS_PER_PAGE));
  
    useEffect(() => {
      if (currentPage > totalPages) setCurrentPage(totalPages);
    }, [totalPages]);
  
    const paginatedProjects = filteredProjects.slice(
      (currentPage - 1) * ITEMS_PER_PAGE,
      currentPage * ITEMS_PER_PAGE
    );

  // Get comments for each project (filtered)
  const getProjectComments = (projectId) => {
    return filteredComments.filter(c => c.projectId === projectId).slice(0, 3);
  };

  const handleExport = () => {
    const headers = ['Student', 'Project', 'Rating', 'Comment', 'Date'];
    const rows = filteredComments.map((c) => [
      csvEscape(c.studentName),
      csvEscape(c.projectName),
      csvEscape(c.rating),
      csvEscape(c.comment),
      csvEscape(c.date),
    ]);
    const csv = [headers.join(','), ...rows.map((row) => row.join(','))].join('\n');
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = `csg_ratings_export_${new Date().toISOString().slice(0, 10)}.csv`;
    link.click();
    URL.revokeObjectURL(link.href);
    showToast('Export completed successfully');
  };

  const renderStars = (rating) => {
    return [...Array(5)].map((_, i) => (
      <Star
        key={i}
        className={`w-5 h-5 ${
          i < Math.floor(rating)
            ? 'fill-yellow-400 text-yellow-400'
            : i < rating
            ? 'fill-yellow-200 text-yellow-400'
            : 'text-gray-300'
        }`}
      />
    ));
  };

  const renderSmallStars = (rating) => {
    return [...Array(5)].map((_, i) => (
      <Star
        key={i}
        className={`w-4 h-4 ${
          i < rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'
        }`}
      />
    ));
  };

  const totalRatings = kpi.totalRatings ?? recentComments.length;
  const overallAverage = totalRatings ? (kpi.overallAverage ?? 0) : 0;
  const satisfactionRate = kpi.satisfactionRate ?? 0;
  const projectCount = kpi.projectCountWithRatings ?? projectSummaries.filter((p) => p.totalRatings > 0).length;

  if (loading) {
    return (
      <div className="flex justify-center items-center py-12">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header with Export Button */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="text-2xl font-semibold text-blue-600">CSG Officers Project Ratings</h1>
          <p className="text-gray-500">Student feedback and satisfaction ratings for CSG projects</p>
        </div>
        {/* <Button type="button" variant="outline" className="rounded-xl" onClick={handleExport}>
          <Download className="w-4 h-4 mr-2" />
          Export Report
        </Button> */}
      </div>


      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">
                Overall Average Rating
              </p>
              <div className="flex items-center gap-3 mt-2">
                <p className="text-3xl font-semibold text-gray-900">
                  {(kpi.overallAverage || 0).toFixed(1)}
                </p>
                <div className="flex">{renderStars(kpi.overallAverage || 0)}</div>
              </div>
              <p className="text-xs text-gray-400 mt-1">Across all projects</p>
            </div>
            <div className="w-12 h-12 bg-yellow-50 rounded-xl flex items-center justify-center">
              <Star className="w-6 h-6 text-yellow-600" />
            </div>
          </div>
        </Card>

        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Total Ratings</p>
              <p className="text-3xl font-semibold text-gray-900 mt-2">{kpi.totalRatings || 0}</p>
              <p className="text-xs text-gray-400 mt-1">Across all projects</p>
            </div>
            <div className="w-12 h-12 bg-blue-50 rounded-xl flex items-center justify-center">
              <MessageSquare className="w-6 h-6 text-blue-600" />
            </div>
          </div>
        </Card>

        <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500">Users Satisfaction Rate</p>
              <p className="text-3xl font-semibold text-gray-900 mt-2">{kpi.csatRate || 0}%</p>
              <p className="text-xs text-green-600 mt-1">Satisfied (3-5 stars)</p>
            </div>
            <div className="w-12 h-12 bg-green-50 rounded-xl flex items-center justify-center">
              <ThumbsUp className="w-6 h-6 text-green-600" />
            </div>
          </div>
        </Card>
      </div>

      {/* Enhanced Filters */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          {/* Search Input */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              placeholder="Search..."
                value={searchQuery}
              onChange={(e) => {
                setSearchQuery(e.target.value);
                setCurrentPage(1);
              }}
              className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
            />
          </div>

          {/* Project Filter */}
          <Select
            value={selectedProject}
            onValueChange={(v) => {
              setSelectedProject(v);
              setCurrentPage(1);
            }}
          >
            <option value="all">All Projects</option>
            {projectSummaries.map((project) => (
              <option key={project.id} value={project.id}>
                {project.projectName}
              </option>
            ))}
          </Select>

          {/* Rating Filter */}
          <Select
            value={selectedRating}
            onValueChange={(v) => {
              setSelectedRating(v);
              setCurrentPage(1);
            }}
          >
            <option value="all">All Ratings</option>
            <option value="5">5 Stars</option>
            <option value="4">4 Stars</option>
            <option value="3">3 Stars</option>
            <option value="2">2 Stars</option>
            <option value="1">1 Star</option>
          </Select>

          {/* Date Range Filter */}
           <Select
            value={dateRange}
            onValueChange={(v) => {
              setDateRange(v);
              setCurrentPage(1);
            }}
          >
            <option value="all">All Time</option>
            <option value="week">Last Week</option>
            <option value="month">Last Month</option>
            <option value="quarter">Last Quarter (90d)</option>
          </Select>

          {/* Sort By Filter */}
          <Select value={sortBy} onValueChange={setSortBy}>
            <option value="highest">Highest Rated</option>
            <option value="lowest">Lowest Rated</option>
            <option value="most-rated">Most Rated</option>
          </Select>
        </div>
      </Card>

       {/* Project Ratings */}
      <div className="space-y-6">
         {paginatedProjects.map((project) => {
          const projectComments = getProjectComments(project.id);
          return (
            <Card key={project.id} className="rounded-[20px] border-0 shadow-sm p-6 bg-white">
                          {/* Project Header */}
                          <div className="flex flex-col md:flex-row md:items-start justify-between gap-4">
                            <div>
                              <h2 className="text-xl font-semibold text-gray-900 mb-2">
                                {project.projectName}
                              </h2>
                              <div className="flex items-center gap-4">
                                <div className="flex items-center gap-2">
                                  <span className="text-3xl font-semibold text-gray-900">
                                    {project.totalRatings ? project.averageRating.toFixed(2) : ''}
                                  </span>
                                  {project.totalRatings > 0 && <div className="flex">{renderStars(project.averageRating)}</div>}
                                </div>
                                <span className="text-sm text-gray-500">({project.totalRatings} ratings)</span>
                              </div>
                            </div>
            
                            {project.totalRatings > 0 && (
                              <Badge className="bg-blue-100 text-blue-700 rounded-lg px-3 py-1">
                                <TrendingUp className="w-3 h-3 mr-1" />
                                {Math.round((project.totalRatings / (kpi.totalRatings || 1)) * 100)}% of feedback
                              </Badge>
                            )}
                          </div>
            
                          {/* Rating Breakdown by Category */}
                          {project.totalRatings > 0 && (
                            <div className="grid grid-cols-3 gap-3 mb-2">
                              <div className="p-3 bg-blue-50 rounded-lg border border-blue-200">
                                <p className="text-xs text-blue-600 font-medium mb-1">Satisfaction</p>
                                <div className="flex items-center gap-2">
                                  <span className="text-lg font-semibold text-blue-900">{project.satisfactionRating.toFixed(1)}</span>
                                  <div className="flex gap-0.5">{renderSmallStars(project.satisfactionRating)}</div>
                                </div>
                              </div>
                              <div className="p-3 bg-blue-50 rounded-lg border border-blue-200">
                                <p className="text-xs text-blue-600 font-medium mb-1">Completeness</p>
                                <div className="flex items-center gap-2">
                                  <span className="text-lg font-semibold text-blue-900">{project.completenessRating.toFixed(1)}</span>
                                  <div className="flex gap-0.5">{renderSmallStars(project.completenessRating)}</div>
                                </div>
                              </div>
                              <div className="p-3 bg-blue-50 rounded-lg border border-blue-200">
                                <p className="text-xs text-blue-600 font-medium mb-1">Engagement</p>
                                <div className="flex items-center gap-2">
                                  <span className="text-lg font-semibold text-blue-900">{project.engagementRating.toFixed(1)}</span>
                                  <div className="flex gap-0.5">{renderSmallStars(project.engagementRating)}</div>
                                </div>
                              </div>
                            </div>
                          )}
            
                          {/* Rating Distribution */}
                          {project.totalRatings > 0 && (
                            <div className="mb-6">
                              <h3 className="text-sm font-medium text-gray-700 mb-3">Rating Distribution</h3>
                              <div className="space-y-2">
                                {[5, 4, 3, 2, 1].map((stars) => {
                                  const count = project.ratingDistribution?.[stars] ?? 0;
                                  const percentage = project.totalRatings > 0 ? (count / project.totalRatings) * 100 : 0;
                                  return (
                                    <div key={stars} className="flex items-center gap-3">
                                      <span className="text-sm text-gray-600 w-6">{stars}</span>
                                      <Star className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                                      <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                                        <div
                                          className="h-full rounded-full transition-all bg-yellow-400"
                                          style={{ width: `${percentage}%` }}
                                        />
                                      </div>
                                      <span className="text-sm text-gray-600 w-12 text-right">{count}</span>
                                    </div>
                                  );
                                })}
                              </div>
                            </div>
                          )}
            
                          {/* Recent Comments for this Project (Filtered) */}
                          {projectComments.length > 0 && (
                            <div>
                              <h3 className="text-sm font-medium text-gray-700 mb-4">Recent Feedback</h3>
                              <div className="space-y-4">
                                {projectComments.map((comment) => (
                                  <div
                                    key={comment.id}
                                    className="flex gap-4 pb-4 border-b border-gray-100 last:border-0 last:pb-0"
                                  >
                                    <Avatar className="bg-blue-100 text-blue-800 text-sm w-10 h-10 flex-shrink-0">
                                      <AvatarFallback>
                                        {comment.studentName
                                          .split(' ')
                                          .filter(Boolean)
                                          .map((n) => n[0])
                                          .join('')
                                          .slice(0, 2)
                                          .toUpperCase()}
                                      </AvatarFallback>
                                    </Avatar>
            
                                    <div className="flex-1">
                                      <div className="flex items-start justify-between gap-2 mb-1">
                                        <div>
                                          <p className="text-sm font-medium text-gray-900">
                                            {maskUserName(comment.studentName)}
                                          </p>
                                          <div className="flex items-center gap-2 mt-1">
                                            <div className="flex">{renderSmallStars(comment.rating)}</div>
                                            <span className="text-xs text-gray-400">{comment.date}</span>
                                          </div>
                                        </div>
                                      </div>
                                      {comment.comment && (
                                        <p className="text-sm text-gray-600 mt-2">{comment.comment}</p>
                                      )}
                                    </div>
                                  </div>
                                ))}
                              </div>
                            </div>
                          )}
            
                          {projectComments.length === 0 && project.totalRatings > 0 && (
                            <div className="text-center py-6">
                              <MessageSquare className="w-8 h-8 text-gray-300 mx-auto mb-2" />
                              <p className="text-sm text-gray-500">No comments in filters, but project has ratings</p>
                            </div>
                          )}
                        </Card>
          );
        })}

        {paginatedProjects.length === 0 && (
          <Card className="rounded-[20px] border-0 shadow-sm p-12 bg-white text-center">
            <div className="text-center">
              <Star className="w-12 h-12 text-gray-300 mx-auto mb-3" />
              <p className="text-sm text-gray-500">No projects found</p>
              <p className="text-xs text-gray-400 mt-1">No projects match your filters</p>
            </div>
          </Card>
        )}
      </div>
        {totalPages > 1 && (
              <div className="flex items-center justify-between border-t border-gray-200 mt-4 pt-4">
                <div className="flex flex-1 justify-between sm:hidden">
                  <Button
                    onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
                    disabled={currentPage === 1}
                    variant="outline"
                    className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Previous
                  </Button>
                  <Button
                    onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
                    disabled={currentPage === totalPages}
                    variant="outline"
                    className="rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Next
                  </Button>
                </div>
                <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                  <p className="text-sm text-gray-700">
                    Page <span className="font-medium">{currentPage}</span> of{' '}
                    <span className="font-medium">{totalPages}</span>
                  </p>
                  <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Ratings pagination">
                    <Button
                      onClick={() => setCurrentPage((p) => Math.max(p - 1, 1))}
                      disabled={currentPage === 1}
                      variant="outline"
                      className="relative inline-flex items-center rounded-l-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Previous</span>
                      <ChevronLeft className="h-5 w-5" />
                    </Button>
                    {[...Array(totalPages)].map((_, i) => {
                      const page = i + 1;
                      const isCurrentPage = page === currentPage;
                      if (page === 1 || page === totalPages || (page >= currentPage - 1 && page <= currentPage + 1)) {
                        return (
                          <Button
                            key={page}
                            onClick={() => setCurrentPage(page)}
                            variant="outline"
                            className={`relative inline-flex items-center px-4 py-2 text-sm font-medium ${
                              isCurrentPage
                                ? 'z-10 bg-blue-600 text-white border-blue-600 hover:bg-blue-700'
                                : 'bg-white text-gray-700 hover:bg-gray-50'
                            }`}
                          >
                            {page}
                          </Button>
                        );
                      }
                      if (page === currentPage - 2 || page === currentPage + 2) {
                        return (
                          <span key={page} className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700">
                            ...
                          </span>
                        );
                      }
                      return null;
                    })}
                    <Button
                      onClick={() => setCurrentPage((p) => Math.min(p + 1, totalPages))}
                      disabled={currentPage === totalPages}
                      variant="outline"
                      className="relative inline-flex items-center rounded-r-xl px-2 py-2 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Next</span>
                      <ChevronRight className="h-5 w-5" />
                    </Button>
                  </nav>
                </div>
              </div>
            )}
          </div> 
  );
}

export default function CSGRatingsPage(props) {
  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Project Ratings & Student Satisfaction</h2>}>
      <Head title="Project Ratings" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <CSGRatingsPageInner 
            projectSummaries={props.projectSummaries}
            recentComments={props.recentComments}
            kpi={props.kpi}
          />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}