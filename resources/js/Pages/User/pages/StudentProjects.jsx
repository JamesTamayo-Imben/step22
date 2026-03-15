import React, { useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import { Badge } from '@/Components/ui/badge';
import { StudentModal } from '@/Components/ui/StudentModal';
import { Search, Star, Users, Calendar } from 'lucide-react';

const projects = [
  {
    id: 1,
    title: 'Community Outreach Program',
    category: 'Social',
    status: 'In Progress',
    description: 'A comprehensive program to reach out to local communities and provide educational support.',
    rating: 4.8,
    ratingsCount: 45,
    progress: 75,
    participants: 150,
    deadline: 'Dec 15, 2024',
    budget: 50000,
    image: '🤝',
  },
  {
    id: 2,
    title: 'Annual Sports Fest',
    category: 'Sports',
    status: 'Planning',
    description: 'Annual inter-department sports competition with multiple events and activities.',
    rating: 4.5,
    ratingsCount: 32,
    progress: 45,
    participants: 320,
    deadline: 'Jan 20, 2025',
    budget: 75000,
    image: '⚽',
  },
  {
    id: 3,
    title: 'Campus Sustainability Initiative',
    category: 'Environmental',
    status: 'In Progress',
    description: 'Green campus initiative focusing on waste reduction and renewable energy.',
    rating: 4.9,
    ratingsCount: 67,
    progress: 90,
    participants: 200,
    deadline: 'Nov 30, 2024',
    budget: 40000,
    image: '🌱',
  },
  {
    id: 4,
    title: 'Tech Innovation Summit',
    category: 'Technology',
    status: 'Completed',
    description: 'A summit bringing together tech enthusiasts and industry leaders.',
    rating: 4.7,
    ratingsCount: 89,
    progress: 100,
    participants: 450,
    deadline: 'Nov 10, 2024',
    budget: 100000,
    image: '💻',
  },
  {
    id: 5,
    title: 'Cultural Festival 2024',
    category: 'Cultural',
    status: 'In Progress',
    description: 'Annual cultural celebration showcasing diverse traditions and performances.',
    rating: 4.6,
    ratingsCount: 54,
    progress: 60,
    participants: 280,
    deadline: 'Dec 20, 2024',
    budget: 60000,
    image: '🎭',
  },
  {
    id: 6,
    title: 'Student Leadership Program',
    category: 'Education',
    status: 'Planning',
    description: 'Leadership development program for aspiring student leaders.',
    rating: 4.4,
    ratingsCount: 28,
    progress: 30,
    participants: 80,
    deadline: 'Feb 1, 2025',
    budget: 30000,
    image: '📚',
  },
];

export default function StudentProjectsPage({ onNavigate, onViewDetails }) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selectedStatus, setSelectedStatus] = useState('all');
  const [showRatingModal, setShowRatingModal] = useState(false);
  const [selectedProjectId, setSelectedProjectId] = useState(null);
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [hoveredRating, setHoveredRating] = useState(0);

  const filteredProjects = projects.filter((project) => {
    const matchesSearch =
      project.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      project.description.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || project.category === selectedCategory;
    const matchesStatus = selectedStatus === 'all' || project.status === selectedStatus;
    return matchesSearch && matchesCategory && matchesStatus;
  });

  const handleRateProject = () => {
    setShowRatingModal(false);
    setRating(0);
    setComment('');
    setSelectedProjectId(null);
  };

  const handleOpenRatingModal = (projectId) => {
    setSelectedProjectId(projectId);
    setShowRatingModal(true);
  };

  const selectedProject = projects.find((p) => p.id === selectedProjectId);

  return (
    <div className="space-y-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="text-gray-900 text-2xl font-semibold mb-2">Projects</h1>
        <p className="text-gray-500">Explore and rate CSG projects</p>
      </div>

      {/* Search and Filters */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="md:col-span-2 relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
          <Input
            placeholder="Search projects..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-10 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-blue-200"
          />
        </div>

        <select
          value={selectedCategory}
          onChange={(e) => setSelectedCategory(e.target.value)}
          className="h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-blue-200 px-3"
        >
          <option value="all">All Categories</option>
          <option value="Social">Social</option>
          <option value="Sports">Sports</option>
          <option value="Environmental">Environmental</option>
          <option value="Technology">Technology</option>
          <option value="Cultural">Cultural</option>
          <option value="Education">Education</option>
        </select>

        <select
          value={selectedStatus}
          onChange={(e) => setSelectedStatus(e.target.value)}
          className="h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-blue-200 px-3"
        >
          <option value="all">All Status</option>
          <option value="Planning">Planning</option>
          <option value="In Progress">In Progress</option>
          <option value="Completed">Completed</option>
        </select>
      </div>

      {/* Results Count */}
      <div className="flex items-center justify-between">
        <p className="text-sm text-gray-600">
          Showing {filteredProjects.length} of {projects.length} projects
        </p>
      </div>

      {/* Projects Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredProjects.map((project) => (
          <Card key={project.id} className="overflow-hidden rounded-[20px] border-0 shadow-sm hover:shadow-md transition-all">
            {/* Project Icon */}
            <div className="h-32 bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center text-6xl">
              {project.image}
            </div>

            <div className="p-6">
              {/* Header */}
              <div className="flex items-start justify-between mb-3">
                <div className="flex-1">
                  <h3 className="text-gray-900 font-semibold mb-1">{project.title}</h3>
                  <Badge className="bg-blue-100 text-blue-700 text-xs">{project.category}</Badge>
                </div>
              </div>

              {/* Description */}
              <p className="text-sm text-gray-600 mb-4 line-clamp-2">{project.description}</p>

              {/* Stats */}
              <div className="grid grid-cols-2 gap-3 mb-4">
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <Users className="w-4 h-4" />
                  <span>{project.participants}</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-600">
                  <Calendar className="w-4 h-4" />
                  <span className="text-xs">{project.deadline}</span>
                </div>
              </div>

              {/* Progress */}
              <div className="mb-4">
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs text-gray-600">Progress</span>
                  <span className="text-xs text-gray-600">{project.progress}%</span>
                </div>
                <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-blue-600 rounded-full transition-all"
                    style={{ width: `${project.progress}%` }}
                  ></div>
                </div>
              </div>

              {/* Rating */}
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <div className="flex items-center gap-1">
                    {[...Array(5)].map((_, i) => (
                      <Star
                        key={i}
                        className={`w-4 h-4 ${
                          i < Math.floor(project.rating)
                            ? 'fill-yellow-400 text-yellow-400'
                            : 'text-gray-300'
                        }`}
                      />
                    ))}
                  </div>
                  <span className="text-sm text-gray-600">{project.rating}</span>
                  <span className="text-xs text-gray-400">({project.ratingsCount})</span>
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-2">
                <Button 
                  onClick={() => onViewDetails(project.id)}
                  className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white"
                >
                  View Details
                </Button>
                <Button
                  onClick={() => handleOpenRatingModal(project.id)}
                  variant="outline"
                  className="rounded-xl"
                >
                  <Star className="w-4 h-4" />
                </Button>
              </div>
            </div>
          </Card>
        ))}
      </div>

      {/* Rating Modal */}
      <StudentModal
        isOpen={showRatingModal}
        onClose={() => {
          setShowRatingModal(false);
          setRating(0);
          setComment('');
          setSelectedProjectId(null);
        }}
        title={`Rate ${selectedProject?.title || 'Project'}`}
      >
        <div className="space-y-6 pt-4">
          {/* Star Rating */}
          <div className="text-center">
            <p className="text-sm text-gray-600 mb-4">How would you rate this project?</p>
            <div className="flex justify-center gap-2 mb-2">
              {[1, 2, 3, 4, 5].map((star) => (
                <button
                  key={star}
                  onClick={() => setRating(star)}
                  onMouseEnter={() => setHoveredRating(star)}
                  onMouseLeave={() => setHoveredRating(0)}
                  className="transition-transform hover:scale-110"
                >
                  <Star
                    className={`w-10 h-10 ${
                      star <= (hoveredRating || rating)
                        ? 'fill-yellow-400 text-yellow-400'
                        : 'text-gray-300'
                    }`}
                  />
                </button>
              ))}
            </div>
            {rating > 0 && (
              <p className="text-sm text-gray-600">
                {rating === 1 && 'Poor'}
                {rating === 2 && 'Fair'}
                {rating === 3 && 'Good'}
                {rating === 4 && 'Very Good'}
                {rating === 5 && 'Excellent'}
              </p>
            )}
          </div>

          {/* Comment */}
          <div>
            <label className="text-sm text-gray-600 mb-2 block">Comment (Optional)</label>
            <textarea
              placeholder="Share your thoughts about this project..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              rows={4}
              className="w-full px-3 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-blue-200"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-3 pt-2 border-t">
            <Button
              onClick={handleRateProject}
              disabled={rating === 0}
              className="flex-1 rounded-xl bg-blue-600 hover:bg-blue-700 text-white disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Submit Rating
            </Button>
            <Button
              onClick={() => {
                setShowRatingModal(false);
                setRating(0);
                setComment('');
              }}
              variant="outline"
              className="rounded-xl"
            >
              Cancel
            </Button>
          </div>

          {/* Points Info */}
          <div className="bg-blue-50 rounded-xl p-4 text-center">
            <p className="text-sm text-blue-600">
              🎉 You'll earn <strong>10 points</strong> for rating this project!
            </p>
          </div>
        </div>
      </StudentModal>
    </div>
  );
}
