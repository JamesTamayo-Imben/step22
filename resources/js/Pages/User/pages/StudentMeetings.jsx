import { useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { StudentModal } from '@/Components/ui/StudentModal';
import { Calendar, Clock, MapPin, Users, FileText, CheckCircle2 } from 'lucide-react';

const upcomingMeetings = [
  {
    id: 1,
    title: 'General Assembly',
    date: '2024-11-28',
    time: '2:00 PM - 4:00 PM',
    location: 'Main Auditorium',
    description: 'Quarterly general assembly to discuss upcoming initiatives and gather student feedback.',
    attendees: 250,
    type: 'Assembly',
    status: 'Scheduled',
  },
  {
    id: 2,
    title: 'Budget Presentation',
    date: '2024-12-02',
    time: '10:00 AM - 12:00 PM',
    location: 'Room 301',
    description: 'Presentation of the annual budget allocation and financial transparency report.',
    attendees: 80,
    type: 'Presentation',
    status: 'Scheduled',
  },
  {
    id: 3,
    title: 'Project Kickoff Meeting',
    date: '2024-12-05',
    time: '3:00 PM - 5:00 PM',
    location: 'Online (Zoom)',
    description: 'Kickoff meeting for the Community Outreach Program with all stakeholders.',
    attendees: 45,
    type: 'Project',
    status: 'Scheduled',
  },
  {
    id: 4,
    title: 'Student Forum',
    date: '2024-12-10',
    time: '1:00 PM - 3:00 PM',
    location: 'Student Center',
    description: 'Open forum for students to raise concerns and suggestions.',
    attendees: 120,
    type: 'Forum',
    status: 'Scheduled',
  },
];

const pastMeetings = [
  {
    id: 5,
    title: 'Mid-Semester Review',
    date: '2024-11-15',
    time: '2:00 PM - 4:00 PM',
    location: 'Conference Room A',
    description: 'Review of projects and initiatives from the first half of the semester.',
    attendees: 95,
    type: 'Review',
    status: 'Completed',
    minutesAvailable: true,
    attended: true,
  },
  {
    id: 6,
    title: 'Sports Fest Planning',
    date: '2024-11-10',
    time: '10:00 AM - 12:00 PM',
    location: 'Sports Complex',
    description: 'Planning meeting for the annual sports festival.',
    attendees: 60,
    type: 'Planning',
    status: 'Completed',
    minutesAvailable: true,
    attended: true,
  },
  {
    id: 7,
    title: 'Sustainability Workshop',
    date: '2024-11-05',
    time: '3:00 PM - 5:00 PM',
    location: 'Science Building',
    description: 'Workshop on campus sustainability initiatives and green practices.',
    attendees: 75,
    type: 'Workshop',
    status: 'Completed',
    minutesAvailable: true,
    attended: false,
  },
  {
    id: 8,
    title: 'Tech Summit Debrief',
    date: '2024-11-12',
    time: '4:00 PM - 5:30 PM',
    location: 'IT Lab',
    description: 'Debrief session following the successful Tech Innovation Summit.',
    attendees: 40,
    type: 'Debrief',
    status: 'Completed',
    minutesAvailable: true,
    attended: true,
  },
];

export default function StudentMeetingsPage({ onNavigate }) {
  const [selectedMeeting, setSelectedMeeting] = useState(null);
  const [activeTab, setActiveTab] = useState('upcoming');

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  const formatFullDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };

  const getMeetingIcon = (location) => {
    if (location.toLowerCase().includes('zoom') || location.toLowerCase().includes('online')) {
      return '🌐';
    }
    return '📍';
  };

  return (
    <div className="space-y-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="text-gray-900 text-2xl font-semibold mb-2">Meetings</h1>
        <p className="text-gray-500">View upcoming and past CSG meetings</p>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 bg-white rounded-xl p-2 shadow-sm border border-gray-100">
        <button
          onClick={() => setActiveTab('upcoming')}
          className={`flex-1 px-4 py-2 rounded-lg font-medium transition-all ${
            activeTab === 'upcoming'
              ? 'bg-blue-600 text-white'
              : 'text-gray-600 hover:bg-gray-100'
          }`}
        >
          Upcoming
          <span className={`ml-2 text-xs px-2 py-0.5 rounded-full ${
            activeTab === 'upcoming'
              ? 'bg-white/20 text-white'
              : 'bg-gray-100 text-gray-700'
          }`}>
            {upcomingMeetings.length}
          </span>
        </button>
        <button
          onClick={() => setActiveTab('past')}
          className={`flex-1 px-4 py-2 rounded-lg font-medium transition-all ${
            activeTab === 'past'
              ? 'bg-blue-600 text-white'
              : 'text-gray-600 hover:bg-gray-100'
          }`}
        >
          Past Meetings
          <span className={`ml-2 text-xs px-2 py-0.5 rounded-full ${
            activeTab === 'past'
              ? 'bg-white/20 text-white'
              : 'bg-gray-100 text-gray-700'
          }`}>
            {pastMeetings.length}
          </span>
        </button>
      </div>

      {/* Upcoming Meetings */}
      {activeTab === 'upcoming' && (
        <div className="space-y-4">
          {upcomingMeetings.map((meeting) => (
            <Card key={meeting.id} className="p-6 rounded-[20px] border-0 shadow-sm hover:shadow-md transition-all">
              <div className="flex flex-col md:flex-row gap-4">
                {/* Date Box */}
                <div className="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl flex flex-col items-center justify-center text-white shadow-md">
                  <p className="text-xs">{formatDate(meeting.date).split(' ')[0]}</p>
                  <p className="text-2xl font-bold">{formatDate(meeting.date).split(' ')[1]}</p>
                </div>

                {/* Meeting Info */}
                <div className="flex-1">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-gray-900 font-semibold mb-2">{meeting.title}</h3>
                      <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">{meeting.type}</Badge>
                    </div>
                  </div>

                  <p className="text-sm text-gray-600 mb-4">{meeting.description}</p>

                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm text-gray-600">
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-blue-600" />
                      <span>{meeting.time}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <MapPin className="w-4 h-4 text-blue-600" />
                      <span>{meeting.location}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Users className="w-4 h-4 text-blue-600" />
                      <span>{meeting.attendees} expected</span>
                    </div>
                  </div>
                </div>

                {/* Action */}
                <div className="flex md:flex-col gap-2">
                  <button
                    onClick={() => setSelectedMeeting(meeting)}
                    className="flex-1 md:flex-none px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors font-medium"
                  >
                    View Details
                  </button>
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* Past Meetings */}
      {activeTab === 'past' && (
        <div className="space-y-4">
          {pastMeetings.map((meeting) => (
            <Card key={meeting.id} className="p-6 rounded-[20px] border-0 shadow-sm hover:shadow-md transition-all">
              <div className="flex flex-col md:flex-row gap-4">
                {/* Date Box */}
                <div className="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-gray-600 to-gray-700 rounded-xl flex flex-col items-center justify-center text-white shadow-md">
                  <p className="text-xs">{formatDate(meeting.date).split(' ')[0]}</p>
                  <p className="text-2xl font-bold">{formatDate(meeting.date).split(' ')[1]}</p>
                </div>

                {/* Meeting Info */}
                <div className="flex-1">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h3 className="text-gray-900 font-semibold mb-2">{meeting.title}</h3>
                      <div className="flex gap-2">
                        <Badge className="bg-gray-100 text-gray-700 hover:bg-gray-200">{meeting.type}</Badge>
                        {meeting.attended && (
                          <Badge className="bg-green-100 text-green-700 hover:bg-green-200 flex items-center gap-1">
                            <CheckCircle2 className="w-3 h-3" />
                            Attended
                          </Badge>
                        )}
                      </div>
                    </div>
                  </div>

                  <p className="text-sm text-gray-600 mb-4">{meeting.description}</p>

                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 text-sm text-gray-600">
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-gray-600" />
                      <span>{meeting.time}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <MapPin className="w-4 h-4 text-gray-600" />
                      <span>{meeting.location}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Users className="w-4 h-4 text-gray-600" />
                      <span>{meeting.attendees} attended</span>
                    </div>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex md:flex-col gap-2">
                  <button
                    onClick={() => setSelectedMeeting(meeting)}
                    className="flex-1 md:flex-none px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors font-medium"
                  >
                    View Details
                  </button>
                  {meeting.minutesAvailable && (
                    <button className="flex-1 md:flex-none px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors font-medium flex items-center justify-center gap-2">
                      <FileText className="w-4 h-4" />
                      Minutes
                    </button>
                  )}
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* Meeting Details Modal */}
      <StudentModal
        isOpen={!!selectedMeeting}
        onClose={() => setSelectedMeeting(null)}
        title={selectedMeeting?.title || 'Meeting Details'}
      >
        {selectedMeeting && (
          <div className="space-y-6 pt-4">
            {/* Meeting Header */}
            <div className="flex items-start gap-4">
              <div className="w-20 h-20 bg-gradient-to-br from-blue-600 to-blue-700 rounded-xl flex flex-col items-center justify-center text-white shadow-md flex-shrink-0">
                <p className="text-xs">{formatDate(selectedMeeting.date).split(' ')[0]}</p>
                <p className="text-2xl font-bold">{formatDate(selectedMeeting.date).split(' ')[1]}</p>
              </div>
              <div className="flex-1">
                <div className="flex gap-2 mb-2">
                  <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">{selectedMeeting.type}</Badge>
                  {selectedMeeting.attended && (
                    <Badge className="bg-green-100 text-green-700 hover:bg-green-200 flex items-center gap-1">
                      <CheckCircle2 className="w-3 h-3" />
                      You Attended
                    </Badge>
                  )}
                </div>
                <p className="text-gray-600">{selectedMeeting.description}</p>
              </div>
            </div>

            {/* Meeting Details Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="bg-gray-50 rounded-xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <Calendar className="w-5 h-5 text-blue-600" />
                  <p className="text-sm text-gray-600">Date</p>
                </div>
                <p className="text-gray-900 font-medium">{formatFullDate(selectedMeeting.date)}</p>
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <Clock className="w-5 h-5 text-blue-600" />
                  <p className="text-sm text-gray-600">Time</p>
                </div>
                <p className="text-gray-900 font-medium">{selectedMeeting.time}</p>
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <MapPin className="w-5 h-5 text-blue-600" />
                  <p className="text-sm text-gray-600">Location</p>
                </div>
                <p className="text-gray-900 font-medium">{selectedMeeting.location}</p>
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <Users className="w-5 h-5 text-blue-600" />
                  <p className="text-sm text-gray-600">Attendees</p>
                </div>
                <p className="text-gray-900 font-medium">
                  {selectedMeeting.attendees} {selectedMeeting.status === 'Completed' ? 'attended' : 'expected'}
                </p>
              </div>
            </div>

            {/* Agenda (for upcoming) or Summary (for past) */}
            {selectedMeeting.status === 'Scheduled' ? (
              <div>
                <h3 className="text-gray-900 font-semibold mb-3">Meeting Agenda</h3>
                <div className="space-y-2">
                  <div className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                    <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs flex-shrink-0 font-medium">
                      1
                    </div>
                    <div>
                      <p className="text-sm text-gray-900 font-medium">Welcome & Opening Remarks</p>
                      <p className="text-xs text-gray-500">5 minutes</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                    <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs flex-shrink-0 font-medium">
                      2
                    </div>
                    <div>
                      <p className="text-sm text-gray-900 font-medium">Main Discussion</p>
                      <p className="text-xs text-gray-500">45 minutes</p>
                    </div>
                  </div>
                  <div className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                    <div className="w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs flex-shrink-0 font-medium">
                      3
                    </div>
                    <div>
                      <p className="text-sm text-gray-900 font-medium">Q&A Session</p>
                      <p className="text-xs text-gray-500">30 minutes</p>
                    </div>
                  </div>
                </div>
              </div>
            ) : (
              <div>
                <h3 className="text-gray-900 font-semibold mb-3">Meeting Summary</h3>
                <div className="bg-gray-50 rounded-xl p-4">
                  <p className="text-gray-600 text-sm">
                    The meeting was successfully conducted with strong participation from attendees. 
                    Key decisions were made regarding project timelines and resource allocation.
                    {selectedMeeting.minutesAvailable && ' Official minutes are available for download.'}
                  </p>
                </div>
              </div>
            )}

            {/* Actions */}
            <div className="flex gap-3 pt-2 border-t">
              {selectedMeeting.minutesAvailable && (
                <button className="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors font-medium flex items-center justify-center gap-2">
                  <FileText className="w-4 h-4" />
                  Download Minutes
                </button>
              )}
              <button
                onClick={() => setSelectedMeeting(null)}
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
