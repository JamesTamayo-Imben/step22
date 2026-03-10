import React, { useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import {
  Bell,
  AlertCircle,
  CheckCircle,
  Info,
  Trash2,
  Archive,
  MoreVertical,
  Search,
  Filter,
} from 'lucide-react';

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : type === 'error' ? '#ef4444' : '#f59e0b';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

export default function NotificationsPage() {
  const [notifications, setNotifications] = useState([
    {
      id: 1,
      type: 'error',
      title: 'Critical: Database Backup Failed',
      message: 'The automated database backup for March 10 failed. Please investigate immediately.',
      timestamp: '2 hours ago',
      read: false,
      category: 'System',
    },
    {
      id: 2,
      type: 'warning',
      title: 'High Memory Usage Detected',
      message: 'Server memory usage has exceeded 85%. Consider optimizing or scaling resources.',
      timestamp: '4 hours ago',
      read: false,
      category: 'Performance',
    },
    {
      id: 3,
      type: 'success',
      title: 'User Account Created',
      message: 'New user account "adviser@kld.edu.ph" has been successfully created.',
      timestamp: '1 day ago',
      read: true,
      category: 'User Management',
    },
    {
      id: 4,
      type: 'info',
      title: 'System Maintenance Scheduled',
      message: 'Scheduled maintenance window on March 15, 2026 from 2:00 AM to 4:00 AM.',
      timestamp: '2 days ago',
      read: true,
      category: 'System',
    },
    {
      id: 5,
      type: 'warning',
      title: 'SSL Certificate Expiring Soon',
      message: 'Your SSL certificate will expire in 30 days. Please renew it before it expires.',
      timestamp: '3 days ago',
      read: true,
      category: 'Security',
    },
    {
      id: 6,
      type: 'success',
      title: 'Role Permission Updated',
      message: 'Adviser role permissions have been successfully updated.',
      timestamp: '1 week ago',
      read: true,
      category: 'User Management',
    },
  ]);

  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('All');
  const [showUnread, setShowUnread] = useState(false);

  const categories = ['All', 'System', 'Performance', 'User Management', 'Security'];

  const filteredNotifications = notifications.filter((notif) => {
    const matchesSearch = notif.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          notif.message.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = filterCategory === 'All' || notif.category === filterCategory;
    const matchesReadStatus = !showUnread || !notif.read;
    return matchesSearch && matchesCategory && matchesReadStatus;
  });

  const unreadCount = notifications.filter((n) => !n.read).length;

  const handleMarkAsRead = (id) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, read: true } : n))
    );
    showToast('Marked as read', 'success');
  };

  const handleMarkAllAsRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
    showToast('All notifications marked as read', 'success');
  };

  const handleDelete = (id) => {
    setNotifications((prev) => prev.filter((n) => n.id !== id));
    showToast('Notification deleted', 'success');
  };

  const handleClearAll = () => {
    setNotifications([]);
    showToast('All notifications cleared', 'success');
  };

  const getIconAndColor = (type) => {
    switch (type) {
      case 'error':
        return { icon: AlertCircle, bg: 'bg-red-100', text: 'text-red-600' };
      case 'warning':
        return { icon: AlertCircle, bg: 'bg-yellow-100', text: 'text-yellow-600' };
      case 'success':
        return { icon: CheckCircle, bg: 'bg-green-100', text: 'text-green-600' };
      case 'info':
        return { icon: Info, bg: 'bg-blue-100', text: 'text-blue-600' };
      default:
        return { icon: Bell, bg: 'bg-gray-100', text: 'text-gray-600' };
    }
  };

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Notifications</h2>}>
      <Head title="Notifications" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">Notifications</h1>
                <p className="text-gray-500">System-wide notifications and alerts</p>
              </div>
              <div className="flex items-center gap-2">
                {unreadCount > 0 && (
                  <Button variant="outline" onClick={handleMarkAllAsRead} className="rounded-xl">
                    Mark All as Read
                  </Button>
                )}
                <Button variant="outline" onClick={handleClearAll} className="rounded-xl text-red-600 hover:bg-red-50">
                  <Trash2 className="w-4 h-4 mr-2" />
                  Clear All
                </Button>
              </div>
            </div>

            {/* Unread Badge */}
            {unreadCount > 0 && (
              <Card className="rounded-[20px] border-0 shadow-sm p-4 bg-blue-50 border-l-4 border-blue-600">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-semibold text-blue-900">
                      You have {unreadCount} unread notification{unreadCount > 1 ? 's' : ''}
                    </p>
                    <p className="text-xs text-blue-700 mt-1">Stay updated with the latest system events</p>
                  </div>
                  <Bell className="w-5 h-5 text-blue-600" />
                </div>
              </Card>
            )}

            {/* Search and Filter */}
            <Card className="rounded-[20px] border-0 shadow-sm p-6">
              <div className="space-y-4">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <Input
                    type="text"
                    placeholder="Search notifications..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-10 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-1 focus:ring-gray-200 focus:border-gray-300"
                  />
                </div>

                <div className="flex gap-2 overflow-x-auto pb-2">
                  {categories.map((cat) => (
                    <button
                      key={cat}
                      onClick={() => setFilterCategory(cat)}
                      className={`px-4 py-2 rounded-full text-sm whitespace-nowrap transition-all ${
                        filterCategory === cat
                          ? 'bg-blue-600 text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      {cat}
                    </button>
                  ))}
                </div>

                <label className="flex items-center gap-3 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={showUnread}
                    onChange={(e) => setShowUnread(e.target.checked)}
                    className="w-4 h-4 rounded border-gray-300"
                  />
                  <span className="text-sm text-gray-700">Show unread only</span>
                </label>
              </div>
            </Card>

            {/* Notifications List */}
            <div className="space-y-3">
              {filteredNotifications.length > 0 ? (
                filteredNotifications.map((notif) => {
                  const { icon: Icon, bg, text } = getIconAndColor(notif.type);
                  return (
                    <Card
                      key={notif.id}
                      className={`rounded-[20px] border-0 shadow-sm p-4 transition-all ${
                        !notif.read ? 'bg-blue-50' : 'bg-white hover:bg-gray-50'
                      }`}
                    >
                      <div className="flex items-start gap-4">
                        <div className={`w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0 ${bg}`}>
                          <Icon className={`w-5 h-5 ${text}`} />
                        </div>

                        <div className="flex-1 min-w-0">
                          <div className="flex items-start justify-between gap-2">
                            <div className="flex-1">
                              <h3 className="text-sm font-semibold text-gray-900">
                                {notif.title}
                                {!notif.read && (
                                  <span className="ml-2 inline-block w-2 h-2 bg-blue-600 rounded-full"></span>
                                )}
                              </h3>
                              <p className="text-sm text-gray-600 mt-1">{notif.message}</p>
                              <div className="flex items-center gap-3 mt-2">
                                <span className="text-xs text-gray-500">{notif.timestamp}</span>
                                <span className="inline-block px-2 py-0.5 text-xs bg-gray-100 text-gray-700 rounded-full">
                                  {notif.category}
                                </span>
                              </div>
                            </div>
                          </div>
                        </div>

                        <div className="flex items-center gap-2 flex-shrink-0">
                          {!notif.read && (
                            <button
                              onClick={() => handleMarkAsRead(notif.id)}
                              className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg transition-colors"
                              title="Mark as read"
                            >
                              <CheckCircle className="w-4 h-4" />
                            </button>
                          )}
                          <button
                            onClick={() => handleDelete(notif.id)}
                            className="p-2 text-red-600 hover:bg-red-100 rounded-lg transition-colors"
                            title="Delete"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    </Card>
                  );
                })
              ) : (
                <Card className="rounded-[20px] border-0 shadow-sm p-12 text-center">
                  <div className="flex flex-col items-center">
                    <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                      <Bell className="w-8 h-8 text-gray-400" />
                    </div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-1">No notifications</h3>
                    <p className="text-gray-500 mb-4">You're all caught up! No notifications match your filters.</p>
                    <Button
                      variant="outline"
                      onClick={() => {
                        setSearchTerm('');
                        setFilterCategory('All');
                        setShowUnread(false);
                      }}
                      className="rounded-xl"
                    >
                      Clear Filters
                    </Button>
                  </div>
                </Card>
              )}
            </div>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

