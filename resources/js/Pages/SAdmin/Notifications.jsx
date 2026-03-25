import React, { useState, useEffect } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
import {
  Bell,
  AlertCircle,
  CheckCircle,
  Info,
  Trash2,
  Search,
} from 'lucide-react';

function showToast(message, type = 'success') {
  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white transition-all';
  el.style.background = type === 'success' ? '#0ea5e9' : type === 'error' ? '#ef4444' : '#f59e0b';
  el.textContent = message;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

export default function NotificationsPage() {
  // 1. Get real data from our Laravel Middleware Connection
  const { auth } = usePage().props;
  const initialNotifications = auth.notifications || [];

  const [searchTerm, setSearchTerm] = useState('');
  const [filterCategory, setFilterCategory] = useState('All');
  const [showUnread, setShowUnread] = useState(false);

  // Categories based on your DB "type" column
  const categories = ['All', 'alert', 'info', 'success', 'warning'];

  const filteredNotifications = initialNotifications.filter((notif) => {
    const matchesSearch = notif.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          notif.message?.toLowerCase().includes(searchTerm.toLowerCase());
    // const matchesCategory = filterCategory === 'All' || notif.type === filterCategory;
    // Change this to match exactly what you typed in the SQL 'type' column
const categories = ['All', 'alert', 'info', 'success', 'warning', 'System'];
    const matchesReadStatus = !showUnread || notif.is_read === 0;
    return matchesSearch && matchesCategory && matchesReadStatus;
  });

  const unreadCount = initialNotifications.filter((n) => n.is_read === 0).length;

  // 2. Real Logic: Mark as Read in Database
  const handleMarkAsRead = (id) => {
    router.post(`/sadmin/notifications/read/${id}`, {}, {
      preserveScroll: true,
      onSuccess: () => showToast('Marked as read', 'success'),
    });
  };

  const handleMarkAllAsRead = () => {
    router.post('/sadmin/notifications/mark-all-read', {}, {
      onSuccess: () => showToast('All notifications marked as read', 'success'),
    });
  };

  // 3. Real Logic: Archive (instead of hard delete)
  const handleDelete = (id) => {
    router.post(`/sadmin/notifications/archive/${id}`, {}, {
      preserveScroll: true,
      onSuccess: () => showToast('Notification archived', 'success'),
    });
  };

  const getIconAndColor = (type) => {
    switch (type) {
      case 'alert':
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
    <AuthenticatedLayout 
        user={auth.user}
        header={<h2 className="text-xl font-semibold leading-tight text-gray-800">Notifications</h2>}
    >
      <Head title="Notifications" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">Notifications</h1>
                {/* <p className="text-gray-500">System-wide alerts for {auth.user.name}</p> */}
                <p className="text-gray-500">System-wide alerts for {auth.user?.name || 'Admin'}</p>
              </div>
              <div className="flex items-center gap-2">
                {unreadCount > 0 && (
                  <Button variant="outline" onClick={handleMarkAllAsRead} className="rounded-xl">
                    Mark All Read
                  </Button>
                )}
              </div>
            </div>

            {/* Unread Badge */}
            {unreadCount > 0 && (
              <Card className="rounded-[20px] border-0 shadow-sm p-4 bg-blue-50 border-l-4 border-blue-600">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm font-semibold text-blue-900">
                      You have {unreadCount} new notification{unreadCount > 1 ? 's' : ''}
                    </p>
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
                    placeholder="Search by title or message..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-10 h-10 rounded-xl border border-gray-300 bg-gray-50"
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
                      {cat.charAt(0).toUpperCase() + cat.slice(1)}
                    </button>
                  ))}
                </div>
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
                        notif.is_read === 0 ? 'bg-blue-50 border-l-2 border-blue-400' : 'bg-white hover:bg-gray-50'
                      }`}
                    >
                      <div className="flex items-start gap-4">
                        <div className={`w-10 h-10 rounded-lg flex items-center justify-center flex-shrink-0 ${bg}`}>
                          <Icon className={`w-5 h-5 ${text}`} />
                        </div>

                        <div className="flex-1 min-w-0">
                          <h3 className="text-sm font-semibold text-gray-900">
                            {notif.title}
                            {notif.is_read === 0 && (
                              <span className="ml-2 inline-block w-2 h-2 bg-blue-600 rounded-full"></span>
                            )}
                          </h3>
                          <p className="text-sm text-gray-600 mt-1">{notif.message}</p>
                          <div className="flex items-center gap-3 mt-2">
                            <span className="text-xs text-gray-500">
                                {new Date(notif.created_at).toLocaleDateString()}
                            </span>
                            <span className="inline-block px-2 py-0.5 text-xs bg-gray-100 text-gray-700 rounded-full italic">
                              {notif.type}
                            </span>
                          </div>
                        </div>

                        <div className="flex items-center gap-2">
                          {notif.is_read === 0 && (
                            <button
                              onClick={() => handleMarkAsRead(notif.id)}
                              className="p-2 text-blue-600 hover:bg-blue-100 rounded-lg"
                              title="Mark as read"
                            >
                              <CheckCircle className="w-4 h-4" />
                            </button>
                          )}
                          <button
                            onClick={() => handleDelete(notif.id)}
                            className="p-2 text-red-600 hover:bg-red-100 rounded-lg"
                            title="Archive"
                          >
                            <Trash2 className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    </Card>
                  );
                })
              ) : (
                <div className="text-center py-12">
                   <Bell className="w-12 h-12 text-gray-300 mx-auto mb-4" />
                   <p className="text-gray-500">No notifications found.</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}