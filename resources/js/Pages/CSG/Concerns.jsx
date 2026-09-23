import React, { useEffect, useMemo, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Badge } from '@/Components/ui/badge';
import { Search, Info, Star, ChevronLeft, ChevronRight } from 'lucide-react';

function Modal({ open, onClose, title, description, children }) {
  React.useEffect(() => {
    if (!open) return undefined;
    const originalStyle = window.getComputedStyle(document.body).overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      document.body.style.overflow = originalStyle;
    };
  }, [open]);

  if (!open) return null;

  return ReactDOM.createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
      role="dialog"
      aria-modal="true"
    >
      <div
        className="relative w-full max-w-2xl bg-white rounded-2xl shadow-lg flex flex-col max-h-[90vh]"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-start justify-between p-6 border-b">
          <div>
            <h3 className="text-lg font-semibold">{title}</h3>
            {description ? <p className="text-sm text-gray-500 mt-1">{description}</p> : null}
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700" aria-label="Close">
            ✕
          </button>
        </div>
        <div className="overflow-y-auto p-6 pt-0">{children}</div>
      </div>
    </div>,
    document.body
  );
}

const STATUS_OPTIONS = ['All Concerns', 'This Week', 'This Month', 'This Year'];

function matchesFilter(concern, searchQuery, statusFilter) {
  const query = searchQuery.trim().toLowerCase();
  const matchesSearch = !query || concern.concern?.toLowerCase().includes(query);

  if (statusFilter === 'all') {
    return matchesSearch;
  }

  const createdAt = concern.created_at ? new Date(concern.created_at) : null;
  if (!createdAt) {
    return matchesSearch;
  }

  const now = new Date();
  const diffMs = now - createdAt;

  const oneWeek = 7 * 24 * 60 * 60 * 1000;
  const oneMonth = 30 * 24 * 60 * 60 * 1000;
  const oneYear = 365 * 24 * 60 * 60 * 1000;

  const matchesStatus =
    (statusFilter === 'This Week' && diffMs <= oneWeek) ||
    (statusFilter === 'This Month' && diffMs <= oneMonth) ||
    (statusFilter === 'This Year' && diffMs <= oneYear);

  return matchesSearch && matchesStatus;
}

export default function ConcernsPage() {
  const { concerns = [] } = usePage().props;
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [currentPage, setCurrentPage] = useState(1);
  const [selectedConcern, setSelectedConcern] = useState(null);
  const itemsPerPage = 6;
  const [items, setItems] = useState(() =>
    Array.isArray(concerns) ? concerns.map((concern) => ({ ...concern, favorite: !!concern.favorite })) : []
  );

  useEffect(() => {
    if (Array.isArray(concerns)) {
      setItems(concerns.map((concern) => ({ ...concern, favorite: !!concern.favorite })));
    }
  }, [concerns]);

  useEffect(() => {
    setCurrentPage(1);
  }, [searchQuery, statusFilter, items]);

  const sortedItems = useMemo(() => {
    return [...items].sort((a, b) => {
      if (a.favorite !== b.favorite) {
        return a.favorite ? -1 : 1;
      }
      return new Date(b.created_at) - new Date(a.created_at);
    });
  }, [items]);

    const getFavoriteColor = (concern) => {
    switch (concern.favorite) {
      case true: return 'text-yellow-700 bg-yellow-100';
      case false: return 'text-gray-700 bg-gray-100';
    }
  };

  const filteredItems = useMemo(() => {
    return sortedItems.filter((concern) => matchesFilter(concern, searchQuery, statusFilter));
  }, [sortedItems, searchQuery, statusFilter]);

  const totalPages = Math.max(1, Math.ceil(filteredItems.length / itemsPerPage));
  const paginatedItems = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    return filteredItems.slice(startIndex, startIndex + itemsPerPage);
  }, [filteredItems, currentPage]);

  useEffect(() => {
    if (currentPage > totalPages) {
      setCurrentPage(totalPages);
    }
  }, [currentPage, totalPages]);

  const toggleFavorite = async (id) => {
    const item = items.find((entry) => entry.id === id);
    if (!item) {
      return;
    }

    const newState = !item.favorite;
    const token = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    try {
      const response = await fetch(`/api/concerns/${encodeURIComponent(id)}/favorite`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': token || '',
          Accept: 'application/json',
        },
        body: JSON.stringify({ favorite: newState }),
      });

      if (!response.ok) {
        throw new Error('Failed to update favorite');
      }

      setItems((current) =>
        current.map((entry) =>
          entry.id === id ? { ...entry, favorite: newState } : entry
        )
      );
    } catch (error) {
      console.error(error);
      alert('Could not update favorite status.');
    }
  };

  const openConcernDetails = (concern) => {
    setSelectedConcern(concern);
  };

  const closeConcernDetails = () => {
    setSelectedConcern(null);
  };

  return (
    <AuthenticatedLayout>
      <Head title="Concerns" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
              <h1 className="text-blue-600 text-2xl font-semibold">Student Reports and Concerns</h1>
              <p className="text-gray-500">View and monitor concerns. Favorite an item to pin it at the top of the list.</p>
            </div>
          </div>

          <Card className="rounded-[20px] border-0 shadow-sm p-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="relative md:col-span-1">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  placeholder="Search concerns..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full h-10 pl-9 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                />
              </div>
              <div>
                <select
                  value={statusFilter}
                  onChange={(e) => setStatusFilter(e.target.value)}
                  className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                >
                  <option value="all">All Concerns</option>
                  {STATUS_OPTIONS.map((option) => (
                    <option key={option} value={option}>
                      {option}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          </Card>
        </div>

        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8 mt-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {paginatedItems.length === 0 ? (
              <Card className="col-span-full rounded-[20px] border-0 shadow-sm p-12">
                <div className="text-center">
                  <Info className="w-12 h-12 text-gray-300 mx-auto mb-3" />
                  <p className="text-sm text-gray-500">No concerns found.</p>
                  <p className="text-xs text-gray-400 mt-1 mb-4">Submit a concern through the chatbot or feedback flow to see it here.</p>
                </div>
              </Card>
            ) : (
              paginatedItems.map((concern) => (
                <Card
                  key={concern.id}
                  className="rounded-[20px] border-0 shadow-sm p-4 hover:shadow-md transition-all cursor-pointer h-full min-h-[220px]"
                  onClick={() => openConcernDetails(concern)}
                  role="button"
                  tabIndex={0}
                  onKeyDown={(event) => {
                    if (event.key === 'Enter' || event.key === ' ') {
                      event.preventDefault();
                      openConcernDetails(concern);
                    }
                  }}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="min-w-0 flex-1">
                      <h3 className="font-semibold text-gray-900 truncate">Concern</h3>
                      <p className="text-[11px] text-gray-500 mt-1">Submitted {new Date(concern.created_at).toLocaleString()}</p>
                    </div>
                    <button
                      type="button"
                      onClick={(event) => {
                        event.stopPropagation();
                        toggleFavorite(concern.id);
                      }}
                      className="rounded-full border border-gray-200 bg-white p-2 text-gray-500 hover:text-yellow-500 hover:border-yellow-300 transition flex-shrink-0"
                      aria-label={concern.favorite ? 'Remove favorite' : 'Mark favorite'}
                    >
                      <Star className={`w-4 h-4 ${concern.favorite ? 'fill-yellow-400 text-yellow-400' : 'text-gray-400'}`} />
                    </button>
                  </div>

                  <div className="mt-3 mb-3 flex-1">
                    <p className="text-sm text-gray-700 whitespace-pre-line line-clamp-4 leading-5">{concern.concern}</p>
                    <p className="text-[11px] text-gray-400 mt-3">Student Name: {concern.name ? concern.name : 'Anonymous'}</p>
                  </div>

                  <div className="flex items-center justify-between gap-2 mt-auto pt-2 border-t border-gray-100">
                    <Badge className={`rounded-lg text-[10px] px-2 py-1 ${getFavoriteColor(concern)}`}>
                      {concern.favorite ? 'Favorited' : 'Normal'}
                    </Badge>
                    <span className="text-[11px] text-blue-600 underline">View details</span>
                  </div>
                </Card>
              ))
            )}
          </div>
          {filteredItems.length > itemsPerPage && totalPages > 1 && (
            <div className="mt-6 flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 rounded-lg">
              <div className="flex flex-1 justify-between sm:hidden">
                <Button
                  onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                  disabled={currentPage === 1}
                  className="relative inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Previous
                </Button>
                <Button
                  onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
                  disabled={currentPage === totalPages}
                  className="relative ml-3 inline-flex items-center rounded-xl border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Next
                </Button>
              </div>
              <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                <div>
                  <p className="text-sm text-gray-700">
                    Page <span className="font-medium">{currentPage}</span> of{' '}
                    <span className="font-medium">{totalPages}</span>
                  </p>
                </div>
                <div>
                  <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                    <Button
                      onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                      disabled={currentPage === 1}
                      className="relative inline-flex items-center rounded-l-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Previous</span>
                      <ChevronLeft className="h-5 w-5" />
                    </Button>

                    {[...Array(totalPages)].map((_, i) => {
                      const page = i + 1;
                      const isCurrentPage = page === currentPage;
                      if (
                        page === 1 ||
                        page === totalPages ||
                        (page >= currentPage - 1 && page <= currentPage + 1)
                      ) {
                        return (
                          <Button
                            key={page}
                            onClick={() => setCurrentPage(page)}
                            className={`relative inline-flex items-center border px-4 py-2 text-sm font-medium ${
                              isCurrentPage
                                ? 'z-10 bg-blue-600 text-white border-blue-600'
                                : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'
                            }`}
                          >
                            {page}
                          </Button>
                        );
                      }
                      if (page === currentPage - 2 || page === currentPage + 2) {
                        return (
                          <span
                            key={page}
                            className="relative inline-flex items-center border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700"
                          >
                            ...
                          </span>
                        );
                      }
                      return null;
                    })}

                    <Button
                      onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
                      disabled={currentPage === totalPages}
                      className="relative inline-flex items-center rounded-r-xl border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span className="sr-only">Next</span>
                      <ChevronRight className="h-5 w-5" />
                    </Button>
                  </nav>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      <Modal
        open={!!selectedConcern}
        onClose={closeConcernDetails}
        title="Concern Details"
        description="View the submitted concern and the time it was sent."
      >
        <div className="space-y-4 pt-6">
          <div>
            <p className="text-sm text-gray-500 mb-1">Submitted</p>
            <p className="text-sm text-gray-900">
              {selectedConcern?.created_at ? new Date(selectedConcern.created_at).toLocaleString() : 'Date not available'}
            </p>
          </div>

          <div>
            <p className="text-sm text-gray-500 mb-1">Student</p>
            <p className="text-sm text-gray-900">{selectedConcern?.name ? selectedConcern.name : 'Anonymous'}</p>
          </div>

          <div>
            <p className="text-sm text-gray-500 mb-1">Concern</p>
            <div className="rounded-xl border border-gray-200 bg-gray-50 p-4">
              <p className="whitespace-pre-line text-sm text-gray-700">{selectedConcern?.concern || 'No concern details available.'}</p>
            </div>
          </div>
        </div>
      </Modal>
    </AuthenticatedLayout>
  );
}
