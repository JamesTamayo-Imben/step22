import React, { useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { Plus, Search, Filter, Edit, Trash2, Eye } from 'lucide-react';

export function Button({ children, className = "", variant = "default", ...props }) {
  const baseStyles = "inline-flex items-center justify-center px-4 py-2 font-medium rounded-lg transition-colors";
  const variants = {
    default: "bg-gray-900 text-white hover:bg-gray-800",
    outline: "border border-gray-300 text-gray-900 hover:bg-gray-50",
    primary: "bg-green-600 text-white hover:bg-green-700",
  };
  return (
    <button className={`${baseStyles} ${variants[variant]} ${className}`} {...props}>
      {children}
    </button>
  );
}

const mockProjects = [
  { id: 1, title: 'Community Outreach Program', status: 'In Progress', budget: '₱25,000', spent: '₱18,500', progress: 74, deadline: 'Dec 15, 2024', category: 'Community Outreach', members: 12 },
  { id: 2, title: 'Annual Sports Fest', status: 'Planning', budget: '₱35,000', spent: '₱5,200', progress: 15, deadline: 'Jan 20, 2025', category: 'Sports & Recreation', members: 8 },
  { id: 3, title: 'Academic Seminar Series', status: 'In Progress', budget: '₱15,000', spent: '₱12,300', progress: 82, deadline: 'Dec 10, 2024', category: 'Academic', members: 5 },
  { id: 4, title: 'Cultural Festival', status: 'Planning', budget: '₱40,000', spent: '₱2,100', progress: 5, deadline: 'Feb 14, 2025', category: 'Cultural', members: 20 },
  { id: 5, title: 'Wellness Week', status: 'Completed', budget: '₱8,500', spent: '₱8,450', progress: 100, deadline: 'Nov 30, 2024', category: 'Wellness', members: 6 },
];

export default function ProjectsPage() {
  const [projects, setProjects] = useState(mockProjects);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const filteredProjects = projects.filter((project) => {
    const matchesSearch = project.title.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || project.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusColor = (status) => {
    switch (status) {
      case 'In Progress':
        return 'bg-blue-100 text-blue-700';
      case 'Planning':
        return 'bg-yellow-100 text-yellow-700';
      case 'Completed':
        return 'bg-green-100 text-green-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <div className="space-y-6 max-w-7xl mx-auto px-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-gray-900 text-2xl font-semibold">Projects</h1>
          <p className="text-gray-500">Manage all organization projects and tasks</p>
        </div>
        <Button variant="primary" className="rounded-xl">
          <Plus className="w-4 h-4 mr-2" />
          New Project
        </Button>
      </div>

      {/* Search and Filter */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex gap-4 flex-col md:flex-row">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-3 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search projects..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-green-200"
            />
          </div>
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-xl bg-gray-50 focus:bg-white outline-none"
          >
            <option value="all">All Status</option>
            <option value="Planning">Planning</option>
            <option value="In Progress">In Progress</option>
            <option value="Completed">Completed</option>
          </select>
        </div>
      </Card>

      {/* Projects Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredProjects.map((project) => (
          <Card key={project.id} className="p-6 rounded-[20px] border-0 shadow-sm bg-white hover:shadow-md transition-shadow">
            <div className="flex items-start justify-between mb-4">
              <div>
                <h3 className="text-gray-900 font-semibold">{project.title}</h3>
                <p className="text-xs text-gray-500 mt-1">{project.category}</p>
              </div>
              <Badge className={getStatusColor(project.status)}>{project.status}</Badge>
            </div>

            <div className="space-y-4">
              {/* Budget */}
              <div className="space-y-2">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-gray-600">Budget</span>
                  <span className="text-gray-900 font-medium">{project.spent} / {project.budget}</span>
                </div>
                <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-green-600 rounded-full"
                    style={{ width: `${(parseFloat(project.spent.replace('₱', '').replace(',', '')) / parseFloat(project.budget.replace('₱', '').replace(',', ''))) * 100}%` }}
                  ></div>
                </div>
              </div>

              {/* Progress */}
              <div className="space-y-2">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-gray-600">Progress</span>
                  <span className="text-gray-900 font-medium">{project.progress}%</span>
                </div>
                <div className="w-full h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-blue-600 rounded-full"
                    style={{ width: `${project.progress}%` }}
                  ></div>
                </div>
              </div>

              {/* Metadata */}
              <div className="grid grid-cols-2 gap-2 py-4 border-t border-gray-200">
                <div>
                  <p className="text-xs text-gray-500">Deadline</p>
                  <p className="text-sm text-gray-900">{project.deadline}</p>
                </div>
                <div>
                  <p className="text-xs text-gray-500">Members</p>
                  <p className="text-sm text-gray-900">{project.members}</p>
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-2 pt-2">
                <button className="flex-1 flex items-center justify-center gap-2 px-3 py-2 text-sm text-blue-600 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
                  <Eye className="w-4 h-4" />
                  View
                </button>
                <button className="flex-1 flex items-center justify-center gap-2 px-3 py-2 text-sm text-gray-600 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                  <Edit className="w-4 h-4" />
                  Edit
                </button>
              </div>
            </div>
          </Card>
        ))}
      </div>

      {filteredProjects.length === 0 && (
        <Card className="p-12 rounded-[20px] border-0 shadow-sm bg-white text-center">
          <p className="text-gray-500 mb-4">No projects found</p>
          <Button variant="primary" className="rounded-xl">
            <Plus className="w-4 h-4 mr-2" />
            Create Your First Project
          </Button>
        </Card>
      )}
    </div>
  );
}
