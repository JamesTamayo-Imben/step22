import { useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { Input } from '@/Components/ui/input';
import { StudentModal } from '@/Components/ui/StudentModal';
import { Calendar, Clock, MapPin, Users, FileText, CheckCircle2, Search } from 'lucide-react';

export default function StudentMeetingsPage({ onNavigate, meetingsUpcoming = [], meetingsPast = [] }) {
  const [selectedMeeting, setSelectedMeeting] = useState(null);
  const [activeTab, setActiveTab] = useState('upcoming');
  const [searchQuery, setSearchQuery] = useState('');
  const [timeFilter, setTimeFilter] = useState('all');

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
    const loc = (location || '').toLowerCase();
    if (loc.includes('zoom') || loc.includes('online')) {
      return '🌐';
    }
    return '📍';
  };

  const getTimeRange = (filter) => {
    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    const startOfWeek = (() => {
      const d = new Date(startOfToday);
      const day = d.getDay();
      const diff = (day + 6) % 7; // Monday start
      d.setDate(d.getDate() - diff);
      d.setHours(0,0,0,0);
      return d;
    })();

    if (filter === 'this_week') {
      const end = new Date(startOfWeek);
      end.setDate(end.getDate() + 6);
      end.setHours(23,59,59,999);
      return [startOfWeek, end];
    }

    if (filter === 'next_week') {
      const start = new Date(startOfWeek);
      start.setDate(start.getDate() + 7);
      start.setHours(0,0,0,0);
      const end = new Date(start);
      end.setDate(end.getDate() + 6);
      end.setHours(23,59,59,999);
      return [start, end];
    }

    if (filter === 'next_month') {
      const start = new Date(now.getFullYear(), now.getMonth() + 1, 1);
      start.setHours(0,0,0,0);
      const end = new Date(now.getFullYear(), now.getMonth() + 2, 0);
      end.setHours(23,59,59,999);
      return [start, end];
    }

    return [null, null];
  };

  const inTimeRange = (m, filter) => {
    if (!filter || filter === 'all') return true;
    const dateStr = m.date || m.scheduled_date || '';
    if (!dateStr) return false;
    const d = new Date(dateStr);
    if (isNaN(d)) return false;
    const [start, end] = getTimeRange(filter);
    if (!start || !end) return false;
    return d >= start && d <= end;
  };

  const normalize = (s) => (s || '').toString().toLowerCase();

  const meetingsUpcomingFiltered = meetingsUpcoming.filter(m => inTimeRange(m, timeFilter)).filter(m => {
    const q = (searchQuery || '').trim().toLowerCase();
    if (!q) return true;
    return normalize(m.title).includes(q) || normalize(m.description).includes(q) || normalize(m.location).includes(q);
  });

  const meetingsPastFiltered = meetingsPast.filter(m => inTimeRange(m, timeFilter)).filter(m => {
    const q = (searchQuery || '').trim().toLowerCase();
    if (!q) return true;
    return normalize(m.title).includes(q) || normalize(m.description).includes(q) || normalize(m.location).includes(q);
  });

  return (
    <div className="space-y-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="text-gray-900 text-2xl font-semibold mb-2">Meetings</h1>
        <p className="text-gray-500">View upcoming and past CSG meetings</p>
      </div>

      {/* Filters */}
                  <Card className="rounded-[20px] border-0 shadow-sm p-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                          {/* Search */}
                          <div className="lg:col-span-1 relative">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                            <Input
                              placeholder="Search by Meeting Title..."
                              value={searchQuery}
                              onChange={(e) => setSearchQuery(e.target.value)}
                              className="w-full pl-9 rounded-xl border border-gray-200 bg-white focus:ring-2 focus:ring-blue-200 focus:border-blue-300"
                            />
                          </div>
      
                          {/* Time range filter */}
                          <div className="lg:col-span-1">
                            <label className="sr-only">Time filter</label>
                            <select
                              value={timeFilter}
                              onChange={(e) => setTimeFilter(e.target.value)}
                              className="w-full h-10 rounded-xl border border-gray-200 bg-white px-3 text-sm focus:ring-2 focus:ring-blue-200 focus:border-blue-300"
                            >
                              <option value="all">All Meetings</option>
                              <option value="this_week">This Week</option>
                              <option value="next_week">Next Week</option>
                              <option value="next_month">Next Month</option>
                            </select>
                          </div> 
                    </div>
                  </Card>

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
            {meetingsUpcomingFiltered.length}
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
            {meetingsPastFiltered.length}
          </span>
        </button>
      </div>

      {/* Upcoming Meetings */}
      {activeTab === 'upcoming' && (
        <div className="space-y-4">
          {meetingsUpcomingFiltered.length === 0 ? (
            <Card className="p-8 rounded-[20px] border-0 shadow-sm text-center text-gray-600">
              <div className="text-center py-4">
                                 <Calendar className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                                 <p className="text-sm text-gray-500">No upcoming meetings found</p>
                                 <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
                               </div>
              </Card>
          ) : (
          <>
          {meetingsUpcomingFiltered.map((meeting) => (
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
                      <h3 className="text-gray-900 font-semibold mb-2">
  {meeting.title}{' '}
  <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-200">Schedule</Badge>
</h3>
                     
                    </div>
                  </div>

                  {/* <p className="text-sm text-gray-600 mb-4">{meeting.description}</p> */}

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
          </>
          )}
        </div>
      )}

      {/* Past Meetings */}
      {activeTab === 'past' && (
        <div className="space-y-4">
          {meetingsPastFiltered.length === 0 && (
            <Card className="p-8 rounded-[20px] border-0 shadow-sm text-center text-gray-600">
              <div className="text-center py-4">
                <Calendar className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                <p className="text-sm text-gray-500">No past meetings to show.</p>
                <p className="text-xs text-gray-400 mt-1">Check back later for updates.</p>
              </div>
            </Card>
          )}
          {meetingsPastFiltered.map((meeting) => (
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
                      <h3 className="text-gray-900 font-semibold gap-2 mb-2">{meeting.title}

                        <Badge className="bg-gray-100 text-gray-700 hover:bg-gray-200">Completed</Badge>
                      </h3>
                      <div className="flex gap-2">
                        
                        {meeting.attended && (
                          <Badge className="bg-green-100 text-green-700 hover:bg-green-200 flex items-center gap-1">
                            <CheckCircle2 className="w-3 h-3" />
                            Attended
                          </Badge>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* <p className="text-sm text-gray-600 mb-4">{meeting.description}</p> */}

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
                    className="flex-1 md:flex-none px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl transition-colors font-medium"
                  >
                    View Details
                  </button>
                  {/* {meeting.minutesAvailable && (
                    <button className="flex-1 md:flex-none px-4 py-2 border border-gray-300 text-gray-700 hover:bg-gray-50 rounded-xl transition-colors font-medium flex items-center justify-center gap-2">
                      <FileText className="w-4 h-4" />
                      Minutes
                    </button>
                  )} */}
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
                <div className="bg-gray-50 rounded-xl p-4">
                  <p className="text-gray-600 text-sm">
                    {selectedMeeting.description}
                  </p>
                </div>
              </div>
            ) : (
              <div>
                <h3 className="text-gray-900 font-semibold mb-3">Meeting Agenda</h3>
                <div className="bg-gray-50 rounded-xl p-4">
                  <p className="text-gray-600 text-sm">
                    {selectedMeeting.description}
                  </p>
                </div>
                <h3 className="text-gray-900 font-semibold mb-3">Meeting Documentation</h3>
                {selectedMeeting.minutes_file_url ? (
                  <div className="bg-white border border-gray-200 rounded-xl p-4">
                    <p className="text-sm text-gray-600 mb-2">Uploaded documentation</p>
                    <div className="flex items-center justify-between gap-3">
                      <div>
                        <p className="font-medium text-gray-900">{selectedMeeting.minutes_file_name || selectedMeeting.meeting_proof?.split('/').pop() || 'Document'}</p>
                        <p className="text-xs text-gray-500">Click the button below to view or download</p>
                      </div>
                      <button
                        onClick={() => window.open(selectedMeeting.minutes_file_url, '_blank')}
                        className="inline-flex items-center gap-2 rounded-xl bg-blue-600 px-3 py-2 text-sm font-medium text-white hover:bg-blue-700 transition-colors"
                      >
                        <FileText className="w-4 h-4" />
                        View Document
                      </button>
                    </div>
                  </div>
                ) : (
                  <div className="bg-gray-50 rounded-xl p-4 text-sm text-gray-500">
                    No meeting documentation uploaded yet.
                  </div>
                )}
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
