import { useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { StudentModal } from '@/Components/ui/StudentModal';
import { 
  ArrowLeft, 
  Star, 
  Users, 
  Calendar, 
  DollarSign,
  FileText,
  CheckCircle,
  Clock,
  Download,
  Eye,
  TrendingUp,
  AlertCircle,
  Shield,
  Hash
} from 'lucide-react';

// Mock data
const projectData = {
  id: 1,
  title: 'Community Outreach Program',
  category: 'Social',
  status: 'In Progress',
  description: 'A comprehensive program to reach out to local communities and provide educational support to underprivileged children. This initiative includes tutoring sessions, donation drives, and community workshops.',
  rating: 4.8,
  ratingsCount: 45,
  progress: 75,
  participants: 150,
  deadline: 'Dec 15, 2024',
  budget: 50000,
  spent: 37500,
  image: '🤝',
  objectives: [
    'Provide educational support to 100+ children',
    'Conduct 20 community workshops',
    'Distribute learning materials to 5 communities',
    'Build partnerships with 10 local organizations'
  ],
  timeline: [
    { phase: 'Planning', duration: '2 weeks', status: 'completed' },
    { phase: 'Resource Mobilization', duration: '3 weeks', status: 'completed' },
    { phase: 'Implementation', duration: '8 weeks', status: 'in-progress' },
    { phase: 'Evaluation', duration: '2 weeks', status: 'pending' }
  ]
};

const ledgerEntries = [
  {
    id: 'TXN-2024-001',
    type: 'Income',
    amount: 50000,
    description: 'Initial Budget Allocation',
    version: 1,
    status: 'Approved',
    timestamp: '2024-11-01 10:30 AM',
    approvedBy: 'Dr. Maria Santos',
    hash: 'a7f8d9e2c3b4a5f6e7d8c9b0a1f2e3d4'
  },
  {
    id: 'TXN-2024-002',
    type: 'Expense',
    amount: 15000,
    description: 'Learning Materials Purchase',
    version: 1,
    status: 'Approved',
    timestamp: '2024-11-05 02:15 PM',
    approvedBy: 'Prof. Juan Dela Cruz',
    hash: 'b8e9f0a1d2c3b4a5f6e7d8c9b0a1f2e3'
  },
  {
    id: 'TXN-2024-003',
    type: 'Expense',
    amount: 8500,
    description: 'Transportation and Logistics',
    version: 1,
    status: 'Approved',
    timestamp: '2024-11-10 09:45 AM',
    approvedBy: 'Dr. Maria Santos',
    hash: 'c9f0a1b2e3d4c5b6a7f8e9d0c1b2a3f4'
  },
  {
    id: 'TXN-2024-004',
    type: 'Expense',
    amount: 12000,
    description: 'Workshop Venue and Equipment',
    version: 1,
    status: 'Approved',
    timestamp: '2024-11-15 11:20 AM',
    approvedBy: 'Prof. Juan Dela Cruz',
    hash: 'd0a1b2c3f4e5d6c7b8a9f0e1d2c3b4a5'
  },
  {
    id: 'TXN-2024-005',
    type: 'Expense',
    amount: 2000,
    description: 'Volunteer Recognition',
    version: 1,
    status: 'Pending',
    timestamp: '2024-11-20 03:30 PM',
    approvedBy: 'Pending Review',
    hash: 'e1b2c3d4a5f6e7d8c9b0a1f2e3d4c5b6'
  }
];

const proofDocuments = [
  {
    id: 'PROOF-001',
    fileName: 'Purchase_Receipt_Materials.pdf',
    linkedTransaction: 'TXN-2024-002',
    uploadDate: '2024-11-05',
    fileType: 'PDF',
    fileSize: '2.3 MB',
    hash: 'sha256:b8e9f0a1d2c3b4a5f6e7d8c9b0a1f2e3d4c5b6a7f8e9d0c1b2a3f4e5d6c7'
  },
  {
    id: 'PROOF-002',
    fileName: 'Transport_Invoice.jpg',
    linkedTransaction: 'TXN-2024-003',
    uploadDate: '2024-11-10',
    fileType: 'Image',
    fileSize: '1.8 MB',
    hash: 'sha256:c9f0a1b2e3d4c5b6a7f8e9d0c1b2a3f4e5d6c7b8a9f0e1d2c3b4a5f6e7d8'
  },
  {
    id: 'PROOF-003',
    fileName: 'Venue_Contract.pdf',
    linkedTransaction: 'TXN-2024-004',
    uploadDate: '2024-11-15',
    fileType: 'PDF',
    fileSize: '1.2 MB',
    hash: 'sha256:d0a1b2c3f4e5d6c7b8a9f0e1d2c3b4a5f6e7d8c9b0a1f2e3d4c5b6a7f8e9'
  },
  {
    id: 'PROOF-004',
    fileName: 'Equipment_Receipt.pdf',
    linkedTransaction: 'TXN-2024-004',
    uploadDate: '2024-11-15',
    fileType: 'PDF',
    fileSize: '950 KB',
    hash: 'sha256:e1b2c3d4a5f6e7d8c9b0a1f2e3d4c5b6a7f8e9d0c1b2a3f4e5d6c7b8a9f0'
  }
];

const statusHistory = [
  {
    id: 1,
    status: 'Completed',
    timestamp: '2024-11-03 02:00 PM',
    updatedBy: 'Sarah Chen (CSG Officer)',
    description: 'Planning phase completed. All objectives and timeline finalized.',
    color: 'green'
  },
  {
    id: 2,
    status: 'Execution',
    timestamp: '2024-11-08 10:30 AM',
    updatedBy: 'Sarah Chen (CSG Officer)',
    description: 'Resource mobilization completed. Moving to implementation phase.',
    color: 'blue'
  },
  {
    id: 3,
    status: 'In Progress',
    timestamp: '2024-11-12 09:15 AM',
    updatedBy: 'Michael Rodriguez (CSG President)',
    description: 'Implementation ongoing. First community workshop successfully conducted.',
    color: 'blue'
  },
  {
    id: 4,
    status: 'Verification',
    timestamp: '2024-11-18 04:45 PM',
    updatedBy: 'Dr. Maria Santos (Adviser)',
    description: 'Mid-project review conducted. Progress verified and approved.',
    color: 'purple'
  }
];

const ratingsData = [
  {
    id: 1,
    studentName: 'Emma Johnson',
    avatar: null,
    rating: 5,
    comment: 'Amazing initiative! The workshops were very helpful and well-organized. The team really cares about making a difference.',
    date: '2024-11-20',
    helpful: 12
  },
  {
    id: 2,
    studentName: 'James Smith',
    avatar: null,
    rating: 5,
    comment: 'This project has made a real impact in our community. Great work by the CSG team!',
    date: '2024-11-19',
    helpful: 8
  },
  {
    id: 3,
    studentName: 'Sofia Martinez',
    avatar: null,
    rating: 4,
    comment: 'Very good project with clear objectives. The execution could be improved in some areas but overall excellent work.',
    date: '2024-11-18',
    helpful: 6
  },
  {
    id: 4,
    studentName: 'Ryan Lee',
    avatar: null,
    rating: 5,
    comment: 'Participated as a volunteer and it was an amazing experience. The children were so happy!',
    date: '2024-11-17',
    helpful: 15
  },
  {
    id: 5,
    studentName: 'Olivia Brown',
    avatar: null,
    rating: 4,
    comment: 'Good initiative with positive outcomes. Looking forward to seeing more projects like this.',
    date: '2024-11-16',
    helpful: 4
  }
];

export default function StudentProjectDetails({ projectId, onBack }) {
  const [showRatingModal, setShowRatingModal] = useState(false);
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [hoveredRating, setHoveredRating] = useState(0);
  const [selectedProof, setSelectedProof] = useState(null);
  const [selectedLedger, setSelectedLedger] = useState(null);
  const [activeTab, setActiveTab] = useState('overview');

  const handleSubmitRating = () => {
    setShowRatingModal(false);
    setRating(0);
    setComment('');
  };

  const tabs = ['overview', 'ledger', 'proof', 'status', 'ratings'];

  return (
    <div className="space-y-6">
      {/* Back Button */}
      <button
        onClick={onBack}
        className="flex items-center gap-2 px-4 py-2 text-gray-700 hover:text-blue-600 rounded-xl transition-colors"
      >
        <ArrowLeft className="w-4 h-4" />
        Back to Projects
      </button>

      {/* Project Header */}
      <Card className="rounded-[20px] border-0 shadow-sm p-6">
        <div className="flex flex-col lg:flex-row gap-6">
          {/* Project Icon */}
          <div className="w-full lg:w-48 h-48 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl flex items-center justify-center text-8xl flex-shrink-0">
            {projectData.image}
          </div>

          {/* Project Info */}
          <div className="flex-1 space-y-4">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 mb-2">{projectData.title}</h1>
              <div className="flex flex-wrap gap-2 mb-3">
                <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">
                  {projectData.category}
                </Badge>
                <Badge 
                  className={`${
                    projectData.status === 'Completed' 
                      ? 'bg-green-100 text-green-700' 
                      : 'bg-blue-100 text-blue-700'
                  }`}
                >
                  {projectData.status}
                </Badge>
              </div>
              <p className="text-gray-600 leading-relaxed">{projectData.description}</p>
            </div>

            {/* Progress Bar */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm text-gray-600">Overall Progress</span>
                <span className="text-sm font-semibold text-gray-900">{projectData.progress}%</span>
              </div>
              <div className="w-full h-3 bg-gray-200 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-blue-600 rounded-full transition-all"
                  style={{ width: `${projectData.progress}%` }}
                />
              </div>
            </div>

            {/* Rating and Action */}
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 pt-2">
              <div className="flex items-center gap-3">
                <div className="flex items-center gap-1">
                  {[...Array(5)].map((_, i) => (
                    <Star
                      key={i}
                      className={`w-5 h-5 ${
                        i < Math.floor(projectData.rating) 
                          ? 'fill-yellow-400 text-yellow-400' 
                          : 'text-gray-300'
                      }`}
                    />
                  ))}
                </div>
                <span className="font-semibold text-gray-900">{projectData.rating}</span>
                <span className="text-sm text-gray-500">({projectData.ratingsCount} ratings)</span>
              </div>

              <button
                onClick={() => setShowRatingModal(true)}
                className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors"
              >
                <Star className="w-4 h-4" />
                Rate this Project
              </button>
            </div>
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6">
          <div className="bg-blue-50 rounded-xl p-4">
            <Users className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Participants</p>
            <p className="text-2xl font-bold text-gray-900">{projectData.participants}</p>
          </div>
          <div className="bg-blue-50 rounded-xl p-4">
            <Calendar className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Deadline</p>
            <p className="text-lg font-semibold text-gray-900">{projectData.deadline}</p>
          </div>
          <div className="bg-blue-50 rounded-xl p-4">
            <DollarSign className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Budget</p>
            <p className="text-2xl font-bold text-gray-900">₱{(projectData.budget / 1000).toFixed(0)}K</p>
          </div>
          <div className="bg-blue-50 rounded-xl p-4">
            <TrendingUp className="w-5 h-5 text-blue-600 mb-2" />
            <p className="text-sm text-gray-600">Spent</p>
            <p className="text-2xl font-bold text-gray-900">₱{(projectData.spent / 1000).toFixed(0)}K</p>
          </div>
        </div>
      </Card>

      {/* Tabs Section */}
      <div className="space-y-6">
        {/* Tab Navigation */}
        <div className="flex flex-wrap gap-2 bg-white rounded-xl p-2 shadow-sm border border-gray-100">
          {tabs.map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-4 py-2 rounded-lg font-medium transition-all capitalize ${
                activeTab === tab
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-600 hover:bg-gray-100'
              }`}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Tab Content */}
        {activeTab === 'overview' && (
          <div className="space-y-6">
            {/* Objectives */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Project Objectives</h2>
              <ul className="space-y-3">
                {projectData.objectives.map((objective, index) => (
                  <li key={index} className="flex items-start gap-3">
                    <CheckCircle className="w-5 h-5 text-green-600 flex-shrink-0 mt-0.5" />
                    <span className="text-gray-700">{objective}</span>
                  </li>
                ))}
              </ul>
            </Card>

            {/* Timeline */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Project Timeline</h2>
              <div className="space-y-4">
                {projectData.timeline.map((phase, index) => (
                  <div key={index} className="flex items-start gap-4">
                    <div className="flex flex-col items-center">
                      <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                        phase.status === 'completed' ? 'bg-green-100' :
                        phase.status === 'in-progress' ? 'bg-blue-100' :
                        'bg-gray-100'
                      }`}>
                        {phase.status === 'completed' ? (
                          <CheckCircle className="w-5 h-5 text-green-600" />
                        ) : phase.status === 'in-progress' ? (
                          <Clock className="w-5 h-5 text-blue-600" />
                        ) : (
                          <Clock className="w-5 h-5 text-gray-400" />
                        )}
                      </div>
                      {index < projectData.timeline.length - 1 && (
                        <div className="w-0.5 h-12 bg-gray-200 my-1"></div>
                      )}
                    </div>
                    <div className="flex-1 pb-4">
                      <h3 className="font-semibold text-gray-900">{phase.phase}</h3>
                      <p className="text-sm text-gray-600">{phase.duration}</p>
                      <Badge 
                        className={`mt-2 ${
                          phase.status === 'completed' ? 'bg-green-100 text-green-700' :
                          phase.status === 'in-progress' ? 'bg-blue-100 text-blue-700' :
                          'bg-gray-100 text-gray-600'
                        }`}
                      >
                        {phase.status === 'completed' ? 'Completed' :
                         phase.status === 'in-progress' ? 'In Progress' :
                         'Pending'}
                      </Badge>
                    </div>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {activeTab === 'ledger' && (
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold text-gray-900">Immutable Ledger</h2>
              <Badge className="bg-purple-100 text-purple-700">
                <Shield className="w-3 h-3 mr-1" />
                SHA256 Verified
              </Badge>
            </div>

            {/* Ledger Entries */}
            <div className="space-y-4 mb-6">
              {ledgerEntries.map((entry) => (
                <div key={entry.id} className="flex flex-col md:flex-row md:items-center justify-between gap-4 p-4 bg-gray-50 rounded-xl">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <span className="font-mono text-sm text-gray-700">{entry.id}</span>
                      <Badge 
                        className={entry.type === 'Income' 
                          ? 'bg-green-100 text-green-700' 
                          : 'bg-red-100 text-red-700'
                        }
                      >
                        {entry.type}
                      </Badge>
                    </div>
                    <p className="text-gray-700 mb-1">{entry.description}</p>
                    <p className="text-xs text-gray-500">{entry.timestamp}</p>
                  </div>
                  <div className="flex items-center gap-4">
                    <div className="text-right">
                      <p className="text-lg font-bold text-gray-900">₱{entry.amount.toLocaleString()}</p>
                      <Badge 
                        className={entry.status === 'Approved' 
                          ? 'bg-green-100 text-green-700 mt-1' 
                          : 'bg-yellow-100 text-yellow-700 mt-1'
                        }
                      >
                        {entry.status}
                      </Badge>
                    </div>
                    <button
                      onClick={() => setSelectedLedger(entry)}
                      className="p-2 hover:bg-gray-200 rounded-lg transition-colors"
                    >
                      <Eye className="w-5 h-5 text-blue-600" />
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Balance Summary */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="bg-green-50 rounded-xl p-4 border border-green-200">
                <p className="text-sm text-green-700 mb-1">Total Income</p>
                <p className="text-2xl font-bold text-green-900">
                  ₱{ledgerEntries.filter(e => e.type === 'Income').reduce((sum, e) => sum + e.amount, 0).toLocaleString()}
                </p>
              </div>
              <div className="bg-red-50 rounded-xl p-4 border border-red-200">
                <p className="text-sm text-red-700 mb-1">Total Expenses</p>
                <p className="text-2xl font-bold text-red-900">
                  ₱{ledgerEntries.filter(e => e.type === 'Expense').reduce((sum, e) => sum + e.amount, 0).toLocaleString()}
                </p>
              </div>
              <div className="bg-blue-50 rounded-xl p-4 border border-blue-200">
                <p className="text-sm text-blue-700 mb-1">Current Balance</p>
                <p className="text-2xl font-bold text-blue-900">
                  ₱{(
                    ledgerEntries.filter(e => e.type === 'Income' && e.status === 'Approved').reduce((sum, e) => sum + e.amount, 0) -
                    ledgerEntries.filter(e => e.type === 'Expense' && e.status === 'Approved').reduce((sum, e) => sum + e.amount, 0)
                  ).toLocaleString()}
                </p>
              </div>
            </div>
          </Card>
        )}

        {activeTab === 'proof' && (
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <h2 className="text-xl font-bold text-gray-900 mb-4">Proof of Transactions</h2>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {proofDocuments.map((proof) => (
                <div key={proof.id} className="rounded-xl p-4 border border-gray-200 shadow-sm hover:shadow-md transition-all">
                  <div className="space-y-3">
                    {/* File Icon */}
                    <div className="h-32 bg-gradient-to-br from-blue-100 to-blue-200 rounded-lg flex items-center justify-center">
                      <FileText className="w-12 h-12 text-blue-600" />
                    </div>

                    {/* File Info */}
                    <div>
                      <h3 className="text-sm font-semibold text-gray-900 truncate mb-1">{proof.fileName}</h3>
                      <p className="text-xs text-gray-500">{proof.fileType} • {proof.fileSize}</p>
                    </div>

                    {/* Linked Transaction */}
                    <div className="flex items-center gap-2">
                      <AlertCircle className="w-4 h-4 text-blue-600 flex-shrink-0" />
                      <span className="text-xs text-gray-600 font-mono truncate">{proof.linkedTransaction}</span>
                    </div>

                    {/* Upload Date */}
                    <p className="text-xs text-gray-500">Uploaded: {proof.uploadDate}</p>

                    {/* Actions */}
                    <div className="flex gap-2">
                      <button
                        onClick={() => setSelectedProof(proof)}
                        className="flex-1 px-3 py-2 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded-lg transition-colors flex items-center justify-center gap-1"
                      >
                        <Eye className="w-4 h-4" />
                        View
                      </button>
                      <button className="px-3 py-2 bg-gray-100 text-gray-600 hover:bg-gray-200 rounded-lg transition-colors">
                        <Download className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </Card>
        )}

        {activeTab === 'status' && (
          <Card className="rounded-[20px] border-0 shadow-sm p-6">
            <h2 className="text-xl font-bold text-gray-900 mb-6">Project Status Timeline</h2>
            
            <div className="space-y-6">
              {statusHistory.map((status, index) => (
                <div key={status.id} className="flex gap-4">
                  {/* Timeline */}
                  <div className="flex flex-col items-center">
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                      status.color === 'green' ? 'bg-green-100' :
                      status.color === 'blue' ? 'bg-blue-100' :
                      status.color === 'purple' ? 'bg-purple-100' :
                      'bg-gray-100'
                    }`}>
                      <CheckCircle className={`w-6 h-6 ${
                        status.color === 'green' ? 'text-green-600' :
                        status.color === 'blue' ? 'text-blue-600' :
                        status.color === 'purple' ? 'text-purple-600' :
                        'text-gray-600'
                      }`} />
                    </div>
                    {index < statusHistory.length - 1 && (
                      <div className="w-0.5 h-16 bg-gray-200"></div>
                    )}
                  </div>

                  {/* Content */}
                  <div className="flex-1 pb-6">
                    <div className="flex flex-wrap items-center gap-2 mb-2">
                      <Badge className={`${
                        status.color === 'green' ? 'bg-green-100 text-green-700' :
                        status.color === 'blue' ? 'bg-blue-100 text-blue-700' :
                        status.color === 'purple' ? 'bg-purple-100 text-purple-700' :
                        'bg-gray-100 text-gray-700'
                      }`}>
                        {status.status}
                      </Badge>
                      <span className="text-sm text-gray-500">{status.timestamp}</span>
                    </div>
                    <p className="text-sm font-semibold text-gray-700 mb-2">{status.updatedBy}</p>
                    <p className="text-gray-700">{status.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </Card>
        )}

        {activeTab === 'ratings' && (
          <div className="space-y-6">
            {/* Rating Summary */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="flex flex-col md:flex-row items-center justify-between gap-6">
                <div>
                  <div className="flex items-center gap-3 mb-2">
                    <span className="text-5xl font-bold text-gray-900">{projectData.rating}</span>
                    <div>
                      <div className="flex items-center gap-1 mb-1">
                        {[...Array(5)].map((_, i) => (
                          <Star
                            key={i}
                            className={`w-6 h-6 ${
                              i < Math.floor(projectData.rating) 
                                ? 'fill-yellow-400 text-yellow-400' 
                                : 'text-gray-300'
                            }`}
                          />
                        ))}
                      </div>
                      <p className="text-sm text-gray-600">{projectData.ratingsCount} ratings</p>
                    </div>
                  </div>
                </div>
                <button
                  onClick={() => setShowRatingModal(true)}
                  className="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors"
                >
                  <Star className="w-4 h-4" />
                  Rate this Project
                </button>
              </div>
            </Card>

            {/* Comments List */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <h2 className="text-xl font-bold text-gray-900 mb-6">Student Comments</h2>
              
              <div className="space-y-6">
                {ratingsData.map((review) => (
                  <div key={review.id} className="flex gap-4 pb-6 border-b last:border-0">
                    <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                      <span className="text-sm font-bold text-blue-700">
                        {review.studentName.split(' ').map(n => n[0]).join('')}
                      </span>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex flex-wrap items-center justify-between gap-2 mb-2">
                        <div>
                          <h3 className="font-semibold text-gray-900">{review.studentName}</h3>
                          <div className="flex items-center gap-2">
                            <div className="flex items-center gap-1">
                              {[...Array(5)].map((_, i) => (
                                <Star
                                  key={i}
                                  className={`w-4 h-4 ${
                                    i < review.rating 
                                      ? 'fill-yellow-400 text-yellow-400' 
                                      : 'text-gray-300'
                                  }`}
                                />
                              ))}
                            </div>
                            <span className="text-sm text-gray-500">{review.date}</span>
                          </div>
                        </div>
                      </div>
                      <p className="text-gray-700 mb-3">{review.comment}</p>
                      <button className="text-sm text-gray-500 hover:text-blue-600 transition-colors">
                        👍 Helpful ({review.helpful})
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}
      </div>

      {/* Rating Modal */}
      <StudentModal
        isOpen={showRatingModal}
        onClose={() => {
          setShowRatingModal(false);
          setRating(0);
          setComment('');
        }}
        title="Rate this Project"
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
            <label className="text-sm text-gray-600 mb-2 block">
              Comment (Optional)
            </label>
            <textarea
              placeholder="Share your thoughts about this project..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              rows="4"
              className="w-full px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-3">
            <button
              onClick={handleSubmitRating}
              disabled={rating === 0}
              className="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:bg-gray-300 text-white rounded-xl transition-colors font-medium"
            >
              Submit Rating
            </button>
            <button
              onClick={() => {
                setShowRatingModal(false);
                setRating(0);
                setComment('');
              }}
              className="px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors"
            >
              Cancel
            </button>
          </div>

          {/* Points Info */}
          <div className="bg-blue-50 rounded-xl p-4 text-center">
            <p className="text-sm text-blue-600">
              🎉 You'll earn <strong>10 points</strong> for rating this project!
            </p>
          </div>
        </div>
      </StudentModal>

      {/* Ledger Details Modal */}
      <StudentModal
        isOpen={!!selectedLedger}
        onClose={() => setSelectedLedger(null)}
        title="Ledger Entry Details"
      >
        {selectedLedger && (
          <div className="space-y-4 pt-4">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-xs text-gray-600 block mb-1">Transaction ID</label>
                <p className="text-sm font-semibold text-gray-900">{selectedLedger.id}</p>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Type</label>
                <Badge 
                  className={selectedLedger.type === 'Income' 
                    ? 'bg-green-100 text-green-700' 
                    : 'bg-red-100 text-red-700'
                  }
                >
                  {selectedLedger.type}
                </Badge>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Amount</label>
                <p className="text-sm font-semibold text-gray-900">₱{selectedLedger.amount.toLocaleString()}</p>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Status</label>
                <Badge 
                  className={selectedLedger.status === 'Approved' 
                    ? 'bg-green-100 text-green-700' 
                    : 'bg-yellow-100 text-yellow-700'
                  }
                >
                  {selectedLedger.status}
                </Badge>
              </div>
              <div className="col-span-2">
                <label className="text-xs text-gray-600 block mb-1">Description</label>
                <p className="text-sm text-gray-900">{selectedLedger.description}</p>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Version</label>
                <Badge className="bg-gray-100 text-gray-700">v{selectedLedger.version}</Badge>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Timestamp</label>
                <p className="text-sm text-gray-900">{selectedLedger.timestamp}</p>
              </div>
              <div className="col-span-2">
                <label className="text-xs text-gray-600 block mb-1">Approved By</label>
                <p className="text-sm text-gray-900">{selectedLedger.approvedBy}</p>
              </div>
              <div className="col-span-2">
                <label className="text-xs text-gray-600 block mb-2">Transaction Hash (SHA-256)</label>
                <p className="text-xs font-mono text-gray-600 truncate">{selectedLedger.hash}</p>
              </div>
            </div>
            
            <div className="flex gap-3 pt-2 border-t">
              <button
                onClick={() => setSelectedLedger(null)}
                className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors font-medium"
              >
                Close
              </button>
            </div>
          </div>
        )}
      </StudentModal>

      {/* Proof Details Modal */}
      <StudentModal
        isOpen={!!selectedProof}
        onClose={() => setSelectedProof(null)}
        title="Proof Document"
      >
        {selectedProof && (
          <div className="space-y-4 pt-4">
            {/* File Preview */}
            <div className="h-64 bg-gray-100 rounded-lg flex items-center justify-center">
              <div className="text-center">
                <FileText className="w-16 h-16 text-gray-400 mx-auto mb-3" />
                <p className="text-sm text-gray-600 mb-1">{selectedProof.fileName}</p>
                <p className="text-xs text-gray-500">{selectedProof.fileType} • {selectedProof.fileSize}</p>
              </div>
            </div>

            {/* File Details */}
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-xs text-gray-600 block mb-1">Linked Transaction</label>
                <p className="text-sm font-semibold text-gray-900">{selectedProof.linkedTransaction}</p>
              </div>
              <div>
                <label className="text-xs text-gray-600 block mb-1">Upload Date</label>
                <p className="text-sm text-gray-900">{selectedProof.uploadDate}</p>
              </div>
              <div className="col-span-2">
                <label className="text-xs text-gray-600 block mb-1">File Hash (SHA-256)</label>
                <p className="text-xs font-mono text-gray-600 truncate">{selectedProof.hash}</p>
              </div>
            </div>

            {/* Actions */}
            <div className="flex gap-3 pt-2 border-t">
              <button className="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors font-medium flex items-center justify-center gap-2">
                <Download className="w-4 h-4" />
                Download
              </button>
              <button
                onClick={() => setSelectedProof(null)}
                className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors font-medium"
              >
                Close
              </button>
            </div>
          </div>
        )}
      </StudentModal>
    </div>
  );
}
