import { useState, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Badge } from '@/Components/ui/badge';
import { Button } from '@/Components/ui/button';
import { Bell, AlertCircle, Star, Calendar, FolderKanban, Award, TrendingUp, FileText, DollarSign, Check, Filter, ChevronLeft, ChevronRight, Send } from 'lucide-react';

const filters = [
  { id: 'all', label: 'All' },
  { id: 'project', label: 'Projects' },
  { id: 'meeting', label: 'Meetings' },
  // { id: 'badge', label: 'Badges' },
  // { id: 'points', label: 'Points' },
  // { id: 'rating', label: 'Ratings' },
  { id: 'system', label: 'System' },
];

function getIcon(icon) {
  switch (icon) {
    case 'star':
      return <Star className="w-5 h-5 text-yellow-600" />;
    case 'calendar':
      return <Calendar className="w-5 h-5 text-blue-600" />;
    case 'project':
      return <FolderKanban className="w-5 h-5 text-blue-600" />;
    case 'badge':
      return <Award className="w-5 h-5 text-purple-600" />;
    case 'points':
      return <TrendingUp className="w-5 h-5 text-green-600" />;
    case 'file':
      return <FileText className="w-5 h-5 text-gray-600" />;
    case 'dollar':
      return <DollarSign className="w-5 h-5 text-blue-600" />;
    default:
      return <AlertCircle className="w-5 h-5 text-red-600" />;
  }
}

const ITEMS_PER_PAGE = 10;

export default function AdviserNotificationsPage({ notificationsData = [], unreadNotificationsCount = 0 }) {
  const [notifications, setNotifications] = useState(notificationsData);
  const [selectedFilter, setSelectedFilter] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [notice, setNotice] = useState({ title: '', message: '' });
  const [expandedMessages, setExpandedMessages] = useState({});

  useEffect(() => {
    setNotifications(Array.isArray(notificationsData) ? notificationsData : []);
    setCurrentPage(1);
  }, [notificationsData]);


  const filteredNotifications = selectedFilter === 'all'
    ? notifications
    : notifications.filter((n) => n.type === selectedFilter);

  const unreadCount = notifications.filter((n) => !n.isRead).length;
  const totalPages = Math.ceil(filteredNotifications.length / ITEMS_PER_PAGE);

   useEffect(() => {
    if (currentPage > totalPages) setCurrentPage(totalPages);
  }, [totalPages]);

  const paginatedNotifications = filteredNotifications.slice(
    (currentPage - 1) * ITEMS_PER_PAGE,
    currentPage * ITEMS_PER_PAGE
  );

  const markAsRead = (id) => {
    router.post(route('adviser.notifications.read', id), {}, {
      preserveScroll: true,
      onSuccess: () => {
        setNotifications(notifications.map((n) => (n.id === id ? { ...n, isRead: true } : n)));
        router.reload({ preserveScroll: true });
      },
    });
  };

  const markAllAsRead = () => {
    router.post(route('adviser.notifications.mark-all-read'), {}, {
      preserveScroll: true,
      onSuccess: () => {
        setNotifications(notifications.map((n) => ({ ...n, isRead: true })));
        router.reload({ preserveScroll: true });
      },
    });
  };

  const publishNotice = (event) => {
    event.preventDefault();
    router.post(route('adviser.notifications.store'), notice, {
      preserveScroll: true,
      onSuccess: () => setNotice({ title: '', message: '' }),
    });
  };

  return (
    <AuthenticatedLayout>
      <Head title="Adviser Notifications" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-blue-600 text-2xl font-semibold">Notifications</h1>
              <p className="text-gray-500">
                System-wide notices (
                {unreadNotificationsCount}
                {' '}
                unread)
              </p>
            </div>
            {unreadNotificationsCount > 0 && (
              <button
                type="button"
                onClick={markAllAsRead}
                className="px-4 py-2 rounded-xl border border-gray-300 text-gray-700 hover:bg-gray-50 transition-colors flex items-center gap-2"
              >
                <Check className="w-4 h-4" />
                Mark all as read
              </button>
            )}
          </div>

          <div className="bg-white mx-auto p-2 rounded-xl flex items-center gap-2 overflow-x-auto pb-2">
            {/* <Filter className="w-4 h-4 text-gray-500 flex-shrink-0" /> */}
            {filters.map((filter) => (
             <button
  key={filter.id}
  type="button"
  onClick={() => {
    setSelectedFilter(filter.id);
    setCurrentPage(1);
  }}
  className={`px-4 py-2 rounded-xl w-[200px]  py-2 whitespace-nowrap transition-all  ${
                  selectedFilter === filter.id
                    ? 'bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-md'
                    : 'bg-white text-gray-700 hover:bg-gray-200'
                }`}
>
  {filter.label}
</button>
            ))}
          </div> 

          <form onSubmit={publishNotice} className="bg-white rounded-xl p-4 shadow-sm space-y-3">
            <div className="flex items-center gap-2">
      
              <h2 className="font-semibold text-gray-900">Publish a notice</h2>
            </div>
            <input
              value={notice.title}
              onChange={(event) => setNotice({ ...notice, title: event.target.value })}
              placeholder="Notice title"
              required
              maxLength={150}
              className="w-full rounded-lg border-gray-300"
            />
            <textarea
              value={notice.message}
              onChange={(event) => setNotice({ ...notice, message: event.target.value })}
              placeholder="Write a calm update, such as: Project ABC is under investigation. Please do not panic."
              required
              maxLength={5000}
              rows={3}
              className="w-full rounded-lg border-gray-300"
            />
            <Button type="submit" className="bg-blue-600 hover:bg-blue-700 text-white rounded-xl px-4 py-2">
              Publish to all users
            </Button>
          </form>
          

          <div className="space-y-3">
            {paginatedNotifications.length === 0 ? (
              <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
                   <div className="text-center">
                              <Bell className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                              <p className="text-sm text-gray-500">No notifications found</p>
                              <p className="text-xs text-gray-400 mt-1">No notifications match your filters</p>
                            </div>
              </Card>
            ) : (
              paginatedNotifications.map((n) => {
                const messageText = n.message || '—';
                const expanded = Boolean(expandedMessages[n.id]);
                const longText = messageText.trim().length > 80 || messageText.split(/\s+/).filter(Boolean).length > 8;
                const showReadMore = longText;

                return (
                  <Card
                    key={n.id}
                    onClick={() => !n.isRead && markAsRead(n.id)}
                    onKeyDown={(event) => {
                      if (!n.isRead && (event.key === 'Enter' || event.key === ' ')) {
                        event.preventDefault();
                        markAsRead(n.id);
                      }
                    }}
                    role={n.isRead ? undefined : 'button'}
                    tabIndex={n.isRead ? undefined : 0}
                    className={`rounded-[20px] border p-4 shadow-sm transition-all gap-0 ${!n.isRead ? 'bg-white border-blue-100 shadow-blue-100/50 cursor-pointer hover:bg-blue-50/50' : 'bg-gray-50/70 border-gray-200 opacity-80'}`}
                  >
                    <div className="flex items-start justify-between gap-3 w-full">
                      <div className="flex items-start gap-3 min-w-0 flex-1">
                        <div className="relative w-10 h-10 rounded-full bg-gray-100 border flex items-center justify-center flex-shrink-0">
                          {!n.isRead && (
                            <span className="absolute -top-0 -left-0 h-2.5 w-2.5 rounded-full bg-blue-600" aria-label="Unread notification" />
                          )}
                          {getIcon(n.icon)}
                        </div>

                        <div className="min-w-0 flex-1">
                          <h3 className="text-sm font-semibold text-gray-900 break-words">{n.title}</h3>
                        </div>
                      </div>

                      <div className="flex items-center justify-end text-xs text-gray-500 shrink-0">
                        <span>{n.timestamp}</span>
                      </div>
                    </div>

                    <div className="flex flex-col items-start pl-[52px]">
                      <p
                        className="text-sm text-gray-600 whitespace-pre-wrap break-words overflow-wrap-anywhere w-full"
                        style={expanded ? {
                          display: 'block',
                          overflow: 'visible',
                          maxHeight: 'none',
                        } : {
                          display: '-webkit-box',
                          overflow: 'hidden',
                          maxHeight: '5.4rem',
                          WebkitLineClamp: 1,
                          WebkitBoxOrient: 'vertical',
                        }}
                      >
                        {messageText}
                      </p>

                      {showReadMore && (
                        <button
                          type="button"
                          onClick={(event) => {
                            event.stopPropagation();
                            setExpandedMessages((prev) => ({ ...prev, [n.id]: !expanded }));
                          }}
                          className="mt-2 text-xs font-medium text-blue-600 hover:text-blue-700"
                        >
                          {expanded ? 'Show less' : 'More...'}
                        </button>
                      )}

                      {!n.isRead && (
                        <div className="mt-3 ml-auto">
                          <button
                            type="button"
                            onClick={(event) => {
                              event.stopPropagation();
                              markAsRead(n.id);
                            }}
                            className="text-blue-600 hover:underline font-medium text-xs"
                          >
                            Mark read
                          </button>
                        </div>
                      )}
                    </div>
                  </Card>
                );
              })
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
      <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Notifications pagination">
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
      </div>
    </AuthenticatedLayout>
  );
}
