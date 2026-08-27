import React, { useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Archive, FolderArchive, ReceiptText, CalendarDays } from 'lucide-react';

export default function SAdminArchivedItemsPage({
  archivedProjects = [],
  archivedLedgerEntries = [],
  archivedMeetings = [],
}) {
  return (
    <AuthenticatedLayout>
      <Head title="Archived Items" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="mb-6">
            <h1 className="text-blue-600 text-2xl font-semibold">Archived Items</h1>
            <p className="text-gray-500">All archived projects, ledger entries, and meetings in one place.</p>
          </div>
          <div className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <Card className="rounded-[20px] border-0 shadow-sm p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Archived Projects</p>
                    <p className="text-2xl text-gray-900">{archivedProjects.length}</p>
                  </div>
                  <FolderArchive className="w-8 h-8 text-blue-600" />
                </div>
              </Card>
              <Card className="rounded-[20px] border-0 shadow-sm p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Archived Ledger Entries</p>
                    <p className="text-2xl text-gray-900">{archivedLedgerEntries.length}</p>
                  </div>
                  <ReceiptText className="w-8 h-8 text-indigo-600" />
                </div>
              </Card>
              <Card className="rounded-[20px] border-0 shadow-sm p-4">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-500">Archived Meetings</p>
                    <p className="text-2xl text-gray-900">{archivedMeetings.length}</p>
                  </div>
                  <CalendarDays className="w-8 h-8 text-emerald-600" />
                </div>
              </Card>
            </div>

            {/* Tabs */}
            <InlineArchivedTabs
              archivedProjects={archivedProjects}
              archivedLedgerEntries={archivedLedgerEntries}
              archivedMeetings={archivedMeetings}
            />
          </div>
        </div>
      </div>
    </AuthenticatedLayout>
  );
}

function EmptyState({ text }) {
  return (
    <div className="py-8 text-center text-gray-500">
      <Archive className="w-10 h-10 mx-auto mb-2 text-gray-300" />
      <p>{text}</p>
    </div>
  );
}

function Tabs({ defaultValue, children, className = '' }) {
  const [activeTab, setActiveTab] = useState(defaultValue);

  return (
    <div className={className}>
      {React.Children.map(children, (child) => {
        if (child.type === TabsList) {
          return React.cloneElement(child, { activeTab, setActiveTab });
        }
        if (child.type === TabsContent) {
          return React.cloneElement(child, { activeTab });
        }
        return child;
      })}
    </div>
  );
}

function TabsList({ children, activeTab, setActiveTab, className = '' }) {
  return (
    <div className={`flex gap-2 bg-white rounded-xl p-1 shadow-sm border-0 ${className}`}>
      {React.Children.map(children, (child) => React.cloneElement(child, { activeTab, setActiveTab }))}
    </div>
  );
}

function TabsTrigger({ value, children, activeTab, setActiveTab }) {
  return (
    <button
      type="button"
      onClick={() => setActiveTab(value)}
      className={`flex-1 px-4 py-2 text-sm font-medium rounded-lg transition-all ${
        activeTab === value ? 'bg-blue-600 text-white' : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
      }`}
    >
      {children}
    </button>
  );
}

function TabsContent({ value, children, activeTab }) {
  if (activeTab !== value) return null;
  return <div>{children}</div>;
}

function InlineArchivedTabs({ archivedProjects = [], archivedLedgerEntries = [], archivedMeetings = [] }) {
  return (
    <Tabs defaultValue="projects" className="space-y-6">
      <TabsList>
        <TabsTrigger value="projects">Project</TabsTrigger>
        <TabsTrigger value="ledger">Ledger Entries</TabsTrigger>
        <TabsTrigger value="meetings">Meeting</TabsTrigger>
      </TabsList>

      <TabsContent value="projects">
        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Archived Projects</h2>
          {archivedProjects.length === 0 ? (
            <EmptyState text="No archived projects found." />
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-blue-50 text-left">
                    <th className="px-4 py-3">Project</th>
                    <th className="px-4 py-3">Category</th>
                    <th className="px-4 py-3">Approval</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3">Archived By</th>
                    <th className="px-4 py-3">Archived At</th>
                  </tr>
                </thead>
                <tbody>
                  {archivedProjects.map((project) => (
                    <tr key={project.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-4 py-3 text-gray-900">{project.title}</td>
                      <td className="px-4 py-3 text-gray-700">{project.category}</td>
                      <td className="px-4 py-3 text-gray-700">{project.approvalStatus}</td>
                      <td className="px-4 py-3 text-gray-700">{project.status}</td>
                      <td className="px-4 py-3 text-gray-700">{project.archivedBy || 'Unknown'}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-600">{project.archivedAt || 'N/A'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </TabsContent>

      <TabsContent value="ledger">
        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Archived Ledger Entries</h2>
          {archivedLedgerEntries.length === 0 ? (
            <EmptyState text="No archived ledger entries found." />
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-indigo-50 text-left">
                    <th className="px-4 py-3">Entry ID</th>
                    <th className="px-4 py-3">Project</th>
                    <th className="px-4 py-3">Type</th>
                    <th className="px-4 py-3">Amount</th>
                    <th className="px-4 py-3">Approval</th>
                    <th className="px-4 py-3">Archived By</th>
                    <th className="px-4 py-3">Archived At</th>
                  </tr>
                </thead>
                <tbody>
                  {archivedLedgerEntries.map((entry) => (
                    <tr key={entry.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-4 py-3 font-mono text-xs text-gray-700">{entry.id}</td>
                      <td className="px-4 py-3 text-gray-900">{entry.projectTitle}</td>
                      <td className="px-4 py-3 text-gray-700">{entry.type}</td>
                      <td className="px-4 py-3 text-gray-700">PHP {Number(entry.amount || 0).toLocaleString()}</td>
                      <td className="px-4 py-3 text-gray-700">{entry.approvalStatus}</td>
                      <td className="px-4 py-3 text-gray-700">{entry.archivedBy || 'Unknown'}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-600">{entry.archivedAt || 'N/A'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </TabsContent>

      <TabsContent value="meetings">
        <Card className="rounded-[20px] border-0 shadow-sm p-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Archived Meetings</h2>
          {archivedMeetings.length === 0 ? (
            <EmptyState text="No archived meetings found." />
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-emerald-50 text-left">
                    <th className="px-4 py-3">Meeting</th>
                    <th className="px-4 py-3">Status</th>
                    <th className="px-4 py-3">Scheduled</th>
                    <th className="px-4 py-3">Archived By</th>
                    <th className="px-4 py-3">Archived At</th>
                  </tr>
                </thead>
                <tbody>
                  {archivedMeetings.map((meeting) => (
                    <tr key={meeting.id} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-4 py-3 text-gray-900">{meeting.title}</td>
                      <td className="px-4 py-3 text-gray-700">{meeting.status}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-600">{meeting.scheduledDate || 'N/A'}</td>
                      <td className="px-4 py-3 text-gray-700">{meeting.archivedBy || 'Unknown'}</td>
                      <td className="px-4 py-3 font-mono text-xs text-gray-600">{meeting.archivedAt || 'N/A'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Card>
      </TabsContent>
    </Tabs>
  );
}
