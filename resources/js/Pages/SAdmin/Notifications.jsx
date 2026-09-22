import { useEffect, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Bell, Star, AlertCircle, Calendar, FolderKanban, Award, TrendingUp, FileText, DollarSign, Check } from 'lucide-react';

const filters = [
  { id: 'all', label: 'All' },
  { id: 'project', label: 'Projects' },
  { id: 'meeting', label: 'Meetings' },
  { id: 'system', label: 'System' },
];

const getIcon = (icon) => {
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
};

const formatNotificationDate = (value) => {
  if (!value) return '—';

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;

  const month = date.toLocaleString('en-US', { month: 'short' });
  const day = date.getDate();
  const year = date.getFullYear();
  const hour = date.getHours() % 12 || 12;
  const minute = String(date.getMinutes()).padStart(2, '0');
  const meridiem = date.getHours() >= 12 ? 'PM' : 'AM';

  return `${month} ${day}, ${year} ${String(hour).padStart(2, '0')}:${minute} ${meridiem}`;
};

export default function NotificationsPage() {
  const { auth } = usePage().props;
  const [notifications, setNotifications] = useState([]);
  const [selectedFilter, setSelectedFilter] = useState('all');

  useEffect(() => {
    setNotifications(Array.isArray(auth?.notifications) ? auth.notifications.map((n) => ({
      ...n,
      isRead: Boolean(n.isRead ?? n.is_read ?? n.read_at),
      type: String(n.type || 'system').toLowerCase(),
    })) : []);
  }, [auth]);

  const filteredNotifications = selectedFilter === 'all'
    ? notifications
    : notifications.filter((n) => String(n.type || 'system').toLowerCase() === selectedFilter);

  const unreadCount = notifications.filter((n) => !n.isRead).length;

  const handleMarkAsRead = (id) => {
    router.post(`/sadmin/notifications/read/${id}`, {}, {
      preserveScroll: true,
      onSuccess: () => {
        setNotifications((current) => current.map((n) => (n.id === id ? { ...n, isRead: true } : n)));
        router.reload({ preserveScroll: true });
      },
    });
  };

  const handleMarkAllAsRead = () => {
    router.post('/sadmin/notifications/mark-all-read', {}, {
      preserveScroll: true,
      onSuccess: () => {
        setNotifications((current) => current.map((n) => ({ ...n, isRead: true })));
        router.reload({ preserveScroll: true });
      },
    });
  };

  return (
    <AuthenticatedLayout user={auth.user} header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Notifications</h2>}>
      <Head title="Notifications" />

      <div className="space-y-6 pb-6 px-4 py-8">
        <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
          <div>
            <h1 className="text-blue-600 text-2xl font-semibold">Notifications</h1>
            <p className="text-gray-500">
              {unreadCount > 0 ? `${unreadCount} unread notification${unreadCount > 1 ? 's' : ''}` : 'All caught up!'}
            </p>
          </div>

          {unreadCount > 0 && (
            <button
              type="button"
              onClick={handleMarkAllAsRead}
              className="px-4 py-2 rounded-xl border border-gray-300 text-gray-700 hover:bg-gray-50 transition-colors flex items-center gap-2 whitespace-nowrap"
            >
              <Check className="w-4 h-4" />
              Mark all as read
            </button>
          )}
        </div>

        <div className="relative flex items-center gap-2 overflow-x-auto pb-2 sm:pb-2">
          {selectedFilter && (
            <div className="pointer-events-none absolute right-0 top-0 hidden h-full w-12 bg-gradient-to-l from-gray-100 via-gray-200/60 to-transparent sm:block" />
          )}
          {filters.map((filter) => (
            <button
              key={filter.id}
              type="button"
              onClick={() => setSelectedFilter(filter.id)}
              className={`relative px-4 py-2 rounded-full w-[100px] whitespace-nowrap transition-all ${
                selectedFilter === filter.id
                  ? 'bg-gradient-to-r from-blue-600 to-blue-800 text-white shadow-md'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              {filter.label}
            </button>
          ))}
        </div>

        <div className="space-y-3">
          {filteredNotifications.length === 0 ? (
            <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
              <div className="text-center">
                <Bell className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                <p className="text-sm text-gray-500">No notifications found</p>
                <p className="text-xs text-gray-400 mt-1">No notifications match your filters</p>
              </div>
            </Card>
          ) : (
            filteredNotifications.map((notification) => (
              <Card
                key={notification.id}
                className={`rounded-[20px] border-0 shadow-sm p-4 transition-all hover:shadow-md cursor-pointer ${
                  !notification.isRead ? 'bg-blue-50 border-l-4 border-l-blue-600' : ''
                }`}
                onClick={() => {
                  if (!notification.isRead) {
                    handleMarkAsRead(notification.id);
                  }
                }}
              >
                <div className="flex gap-4">
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center flex-shrink-0 ${
                    !notification.isRead ? 'bg-white shadow-sm' : 'bg-gray-100'
                  }`}>
                    {getIcon(notification.icon)}
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-3 mb-1">
                      <h3 className="text-gray-900 font-semibold">{notification.title}</h3>
                      {!notification.isRead && (
                        <div className="w-2 h-2 bg-blue-600 rounded-full flex-shrink-0 mt-2" />
                      )}
                    </div>
                    <p className="text-sm text-gray-600 mb-2">{notification.message}</p>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-1.5 text-xs text-gray-500">
                        <span>{formatNotificationDate(notification.timestamp || notification.created_at)}</span>
                      </div>
                      {!notification.isRead && (
                        <span className="text-xs text-blue-600 hover:text-blue-700 font-medium transition-colors">
                          Mark as read
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </Card>
            ))
          )}
        </div>
      </div>
    </AuthenticatedLayout>
  );
}
