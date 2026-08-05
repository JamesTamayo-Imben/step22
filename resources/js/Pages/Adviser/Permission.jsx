import React, { useEffect, useMemo, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
// import Modal from '@/Components/Modal';
import {
  Shield,
  Check,
  AlertCircle,
  RotateCcw,
  Save,
  Lock,
  Users,
  Search,
  UserPlus,
  CheckCircle,
  Repeat,
  Calendar,
  ClipboardList,
} from 'lucide-react';
import RolePermissionEditor from '@/Components/RolePermissionEditor';

function showToast(message, type = 'success') {
  const text = typeof message === 'string'
    ? message
    : message?.message || 'An unexpected error occurred';

  const id = `simple-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.textContent = text;
  document.body.appendChild(el);
  setTimeout(() => {
    const e = document.getElementById(id);
    if (e) e.remove();
  }, 2200);
}

function Modal({ open, onClose, title, description, children }) {
  useEffect(() => {
    if (open) {
      const originalStyle = window.getComputedStyle(document.body).overflow;
      document.body.style.overflow = 'hidden';
      return () => {
        document.body.style.overflow = originalStyle;
      };
    }
  }, [open]);

  if (!open) return null;

  return ReactDOM.createPortal(
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40"
      onClick={onClose}
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
          <button onClick={onClose} className="text-gray-500 hover:text-gray-700">✕</button>
        </div>
        <div className="overflow-y-auto p-6 pt-0">{children}</div>
      </div>
    </div>,
    document.body
  );
}

function Switch({ checked, onCheckedChange, disabled, className = '' }) {
  return (
    <button
      type="button"
      onClick={() => !disabled && onCheckedChange(!checked)}
      className={[
        'relative inline-flex h-6 w-11 items-center rounded-full transition-colors',
        checked ? 'bg-blue-600' : 'bg-gray-200',
        disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer',
        className,
      ].join(' ')}
      aria-pressed={checked}
      aria-disabled={disabled}
    >
      <span
        className={[
          'inline-block h-5 w-5 transform rounded-full bg-white transition-transform',
          checked ? 'translate-x-5' : 'translate-x-1',
        ].join(' ')}
      />
    </button>
  );
}

function Badge({ children, className = '' }) {
  return (
    <span className={['inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium', className].join(' ')}>
      {children}
    </span>
  );
}

function Select({ value, onValueChange, children, className = '' }) {
  return (
    <select
      value={value}
      onChange={(e) => onValueChange(e.target.value)}
      className={['w-full px-3 py-2 border border-gray-200 rounded-xl bg-white', className].join(' ')}
    >
      {children}
    </select>
  );
}

function SelectItem({ value, children }) {
  return <option value={value}>{children}</option>;
}

function Avatar({ children, className = '' }) {
  return <div className={['inline-flex items-center justify-center rounded-full overflow-hidden', className].join(' ')}>{children}</div>;
}

function AvatarFallback({ className = '', children, name }) {
  const initials = (children || (name || '?')
    .split(' ')
    .filter(Boolean)
    .slice(0, 2)
    .map((s) => s[0].toUpperCase())
    .join(''));

  return (
    <div className={['w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center text-xs font-medium', className].join(' ')}>
      {initials || '?'}
    </div>
  );
}

export function RolePermissionsPage() {
  const { users = [], csgOfficerCandidates = [], councilOfficers: initialCouncilOfficers = [], csgPermissionRole: initialCsgPermissionRole = null } = usePage().props;

  const [activeTab, setActiveTab] = useState('assign'); // 'assign' | 'permissions'
  const [csgPermissionRole, setCsgPermissionRole] = useState(initialCsgPermissionRole);

  const [isSetOfficerModalOpen, setIsSetOfficerModalOpen] = useState(false);
  const [isCouncilTermModalOpen, setIsCouncilTermModalOpen] = useState(false);
  const [councilStartDate, setCouncilStartDate] = useState('');
  const [councilEndDate, setCouncilEndDate] = useState('');
  const [positionSearchQuery, setPositionSearchQuery] = useState('');
  const [modalUserSearchQuery, setModalUserSearchQuery] = useState('');
  const [selectedPosition, setSelectedPosition] = useState('');
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedOfficer, setSelectedOfficer] = useState(null);
  const [isLoadingTerm, setIsLoadingTerm] = useState(true);
  const [isRemoveOfficerModalOpen, setIsRemoveOfficerModalOpen] = useState(false);
  const [officerToRemove, setOfficerToRemove] = useState(null);
  const [isRemoving, setIsRemoving] = useState(false);

  useEffect(() => {
    setCsgPermissionRole(initialCsgPermissionRole);
  }, [initialCsgPermissionRole]);

  useEffect(() => {
  const fetchCouncilTerm = async () => {
    setIsLoadingTerm(true);
    try {
      const response = await fetch('/adviser/role-permissions/get-council-term');
      const data = await response.json();
      
      if (response.ok) {
        setCouncilStartDate(data.startDate || '');
        setCouncilEndDate(data.endDate || '');
      } else {
        setCouncilStartDate('');
        setCouncilEndDate('');
      }
    } catch (error) {
      console.error('Failed to fetch council term:', error);
      setCouncilStartDate('');
      setCouncilEndDate('');
    } finally {
      setIsLoadingTerm(false);
    }
  };
  
  fetchCouncilTerm();
}, []);


  const [councilOfficers, setCouncilOfficers] = useState(initialCouncilOfficers);

const formatDate = (dateString) => {
  if (!dateString) return '';
  return new Date(dateString).toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  });
};

const positionHierarchy = {
  'President': 1,
  'Vice President for External Affairs': 2,
  'Vice President for Internal Affairs': 3,
  'Secretary': 4,
  'Treasurer': 5,
  'Auditor': 6,
  'PRO': 7,
  'Business Manager': 8,
};

const filteredCouncilOfficers = useMemo(() => {
  const q = (positionSearchQuery || '').toLowerCase();
  let filtered = councilOfficers;
  
  if (q) {
    filtered = councilOfficers.filter(officer =>
      officer.position.toLowerCase().includes(q)
    );
  }
  
  return [...filtered].sort((a, b) => {
    const posA = positionHierarchy[a.position] ?? 999;
    const posB = positionHierarchy[b.position] ?? 999;
    return posA - posB;
  });
}, [councilOfficers, positionSearchQuery]);

const isUserInCSG = (userId) => {
  return councilOfficers.some(officer => officer.userId === userId);
};


  const filteredUsers = useMemo(() => {
    const q = (modalUserSearchQuery || '').toLowerCase();
    if (!q) return csgOfficerCandidates;
    return csgOfficerCandidates.filter(user =>
      user.name.toLowerCase().includes(q) 
      ||
      String(user.studentId).toLowerCase().includes(q)
    );
  }, [csgOfficerCandidates, modalUserSearchQuery]);

  const selectedPositionName = selectedPosition || '';

  const openOfficerModal = (officer) => {
    setSelectedOfficer(officer);
    setSelectedPosition(officer.position);
    setSelectedUser(null);
    setModalUserSearchQuery('');
    setIsSetOfficerModalOpen(true);
  };

const handleSetCouncilTerm = async () => {
  if (!councilStartDate || !councilEndDate) {
    showToast('Please select both start and end dates', 'error');
    return;
  }

  if (new Date(councilStartDate) >= new Date(councilEndDate)) {
    showToast('Start date must be before end date', 'error');
    return;
  }

  router.post('/adviser/role-permissions/set-council-term', {
    startDate: councilStartDate,
    endDate: councilEndDate,
  }, {
    onSuccess: () => {
      showToast('Council term updated successfully');
      setIsCouncilTermModalOpen(false);
    },
    onError: (error) => {
      showToast(error?.message || 'Failed to set council term', 'error');
    }
  });
};

  

  const openCouncilTermModal = () => {
   
    setIsCouncilTermModalOpen(true);
  };

  const handleSetOfficer = () => {
    if (!selectedUser || !selectedPosition) {
      showToast('Please select a user to assign', 'error');
      return;
    }

    const selectedCandidate = csgOfficerCandidates.find(u => u.id === selectedUser);
    if (!selectedCandidate) return;

    router.post('/adviser/role-permissions/assign-officer', {
      position: selectedPosition,
      userId: selectedUser,
    }, {
      onSuccess: () => {
        setCouncilOfficers(prev =>
          prev.map(officer => {
            // Clear the user from any existing position
            if (officer.userId === selectedCandidate.id) {
              return { position: officer.position, name: null, userId: null, email: null };
            }
            // Assign to the new position
            if (officer.position === selectedPosition) {
              return { position: selectedPosition, name: selectedCandidate.name, userId: selectedCandidate.id, email: selectedCandidate.email };
            }
            return officer;
          })
        );
        showToast(`${selectedCandidate.name} has been assigned as ${selectedPositionName}`);
        setSelectedOfficer(null);
        setSelectedUser(null);
        setSelectedPosition('');
        setModalUserSearchQuery('');
        setIsSetOfficerModalOpen(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to assign officer', 'error');
      }
    });
  };

  const handleRemoveOfficer = (officer) => {
    setOfficerToRemove(officer);
    setIsRemoveOfficerModalOpen(true);
  };

  const confirmRemoveOfficer = () => {
    if (!officerToRemove) return;
    
    setIsRemoving(true);
    router.post('/adviser/role-permissions/remove-officer', {
      userId: officerToRemove.userId,
    }, {
      onSuccess: () => {
        setCouncilOfficers(prev =>
          prev.map(o => {
            if (o.userId === officerToRemove.userId) {
              return { position: o.position, name: null, userId: null, email: null };
            }
            return o;
          })
        );
        showToast(`${officerToRemove.name} has been removed as ${officerToRemove.position}`);
        setIsRemoveOfficerModalOpen(false);
        setOfficerToRemove(null);
        setIsRemoving(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to remove officer', 'error');
        setIsRemoving(false);
      }
    });
  };

  const tabs = [
    { id: 'assign', label: 'Assign Officers', icon: Users, description: 'Assign students to council positions' },
    { id: 'permissions', label: 'CSG Permissions', icon: ClipboardList, description: 'Configure what each CSG position can do' },
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-start justify-between">
        <div>
            <h1 className="text-2xl font-semibold text-gray-900">Roles & Permissions</h1>
            <p className="text-gray-500">Configure role-based access control</p>
        </div>
        <div className="flex flex-col sm:flex-row gap-3">
          <Button onClick={openCouncilTermModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
            <Calendar className="w-4 h-4 mr-2" />
            Set Council Term
          </Button>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 bg-white p-2 rounded-xl w-full sm:w-fit">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              type="button"
              onClick={() => setActiveTab(tab.id)}
              className={`flex items-center justify-center gap-2 px-5 py-2 rounded-xl text-sm font-medium transition-all flex-1 sm:flex-none ${
                isActive
                  ? 'text-white bg-blue-600'
                  : 'text-gray-500 hover:text-gray-700'
              }`}
            >
              <Icon className="w-4 h-4" />
              {tab.label}
            </button>
          );
        })}
      </div>

      {activeTab === 'assign' && (
      <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="text-gray-900 flex items-center">
  {/* <Users className="w-5 h-5 text-[#2563EB]" /> */}
  CSG Council Officers 
    <span className='text-sm text-blue-600 font-medium ml-2'>
      {formatDate(councilStartDate)} to {formatDate(councilEndDate)}
    </span>
</h2>
            <p className="text-sm text-gray-500 mt-1">Manage and assign council officer positions</p>
          </div>
        </div>

         <div className="md:col-span-2 relative">
                          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                          <Input
                            placeholder="Search position..."
                            value={positionSearchQuery}
                            onChange={(e) => setPositionSearchQuery(e.target.value)}
                            className="pl-10 h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white outline-none focus:ring-2 focus:ring-blue-200"
                          />
                        </div>
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  {filteredCouncilOfficers.length === 0 ? (
    <div className="col-span-full text-center py-8">
      <Search className="w-12 h-12 text-gray-300 mx-auto mb-2" />
      <p className="text-sm text-gray-500">No positions found matching "{positionSearchQuery}"</p>
      <p className="text-xs text-gray-400 mt-1">Try a different search term</p>
    </div>
  ) : (
    filteredCouncilOfficers.map((officer) => {
      const isVacant = !officer.name;

      return (
        <div
          key={officer.position}
          className={`p-4 rounded-xl border-2 transition-all ${
            isVacant ? 'border-dashed border-gray-300 bg-gray-50' : 'border-blue-200 bg-blue-50'
          }`}
        >
          <div className="flex items-start justify-between mb-3">
            <div className="flex items-center gap-2">
              {isVacant ? (
                <div className="w-10 h-10 rounded-lg bg-gray-200 flex items-center justify-center">
                  <UserPlus className="w-5 h-5 text-gray-400" />
                </div>
              ) : (
                <Avatar className="w-10 h-10">
                  <AvatarFallback className="bg-[#0065FF] text-white text-xs">
                    {users.find(u => u.id === officer.userId)?.avatar || '--'}
                  </AvatarFallback>
                </Avatar>
              )}
              <div>
                <h3 className={`text-sm ${isVacant ? 'text-gray-400' : 'text-gray-900'}`}>{officer.position}</h3>
                <Badge className={`text-xs ${isVacant ? 'bg-gray-200 text-gray-600' : 'bg-green-100 text-green-700'}`}>
                  {isVacant ? 'Vacant' : 'Assigned'}
                </Badge>
              </div>
            </div>
          </div>

          {isVacant ? (
            <div className="py-2">
              <p className="text-xs text-gray-400">No officer assigned</p>
              <p className="text-xs text-gray-400 ">No email available</p>
              <p className="text-xs text-gray-400">No student ID available</p>
              <div className="mt-3 border-t border-gray-200">
                <Button
                  onClick={() => openOfficerModal(officer)}
                  variant="outline"
                  size="sm"
                  className="mt-3 w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                >
                  <UserPlus className="w-3 h-3 mr-1" />
                  Assign Officer
                </Button>
              </div>
            </div>
          ) : (
            <div>
              <p className="text-sm text-gray-900 mb-1">{officer.name}</p>
              <p className="text-xs text-gray-500">{officer.email}</p>
              <p className="text-xs text-gray-500">Student ID: {officer.id}</p>
              <div className="grid grid-cols-2 gap-2 mt-3 pt-3 border-t border-gray-200">
                <Button
                  onClick={() => openOfficerModal(officer)}
                  variant="outline"
                  size="sm"
                  className="w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                >
                  <Repeat className="w-3 h-3 mr-1" />
                  Reassign Position
                </Button>
                <Button
                  onClick={() => handleRemoveOfficer(officer)}
                  variant="outline"
                  size="sm"
                  className="w-full text-xs border-red-500 bg-red-500 text-white hover:bg-red-600 hover:text-white"
                >
                  <AlertCircle className="w-3 h-3 mr-1" />
                  Remove Officer
                </Button>
              </div>
            </div>
          )}
        </div>
      );
    })
  )}
</div>
      </Card>
      )}

      {activeTab === 'permissions' && (
        <div className="space-y-4">
          <Card className="rounded-[20px] border-0 shadow-sm bg-white p-4">
            <div className="flex items-center gap-3">
              <Shield className="w-5 h-5 text-[#2563EB]" />
              <div>
                <p className="text-sm font-medium text-gray-900">CSG Role Permissions</p>
                <p className="text-xs text-gray-500">
                  Same permission controls as Super Admin — advisers can configure CSG position access only.
                </p>
              </div>
            </div>
          </Card>
          {csgPermissionRole ? (
            <RolePermissionEditor
              roleEntry={csgPermissionRole}
              saveUrl="/adviser/role-permissions/save-permissions"
              onSaved={(matrix) => {
                const next = Array.isArray(matrix)
                  ? matrix.find((r) => r.key === 'csg')
                  : matrix?.csgPermissionRole;
                if (next) setCsgPermissionRole(next);
              }}
            />
          ) : (
            <Card className="rounded-[20px] border-0 shadow-sm bg-white p-6 text-sm text-gray-500 text-center">
              CSG permission data is not available. Please contact the system administrator.
            </Card>
          )}
        </div>
      )}

     <Modal
  open={isSetOfficerModalOpen}
  onClose={() => {
    setIsSetOfficerModalOpen(false);
    setSelectedOfficer(null);
    setSelectedPosition('');
    setSelectedUser(null);
    setModalUserSearchQuery('');
  }}
  title={selectedPositionName ? `Assign ${selectedPositionName}` : 'Set CSG Officer'}
  description="Assign a student as a CSG officer position."
>
  <div className="space-y-4">
    <div className="flex items-center gap-3">
      <Users className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
      <div className="flex-1">
        <label className="text-sm text-gray-700 mb-2 block">CSG Position</label>
        <div className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 px-3 py-2 text-sm text-gray-700 flex items-center">
          {selectedPositionName || 'Select a card to assign a position'}
        </div>
      </div>
    </div>
    <div className="flex items-center gap-3">
      <UserPlus className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
      <div className="flex-1">
        <label className="text-sm text-gray-700 mb-2 block">Search User</label>
        <input 
          className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
          value={modalUserSearchQuery} 
          onChange={(e) => setModalUserSearchQuery(e.target.value)} 
          placeholder="Name or Student ID" 
          disabled={!selectedPosition}
        />
      </div>
    </div>

    <div className="space-y-2 max-h-[300px] overflow-y-auto">
      {filteredUsers.length > 0 ? (
        filteredUsers.map(user => (
          <button
            key={user.id}
            type="button"
            className={`w-full flex items-center gap-3 p-3 rounded-xl transition-all cursor-pointer ${
              selectedUser === user.id ? 'bg-blue-50 border-2 border-[#2563EB]' : 'bg-gray-50 border-2 border-transparent hover:border-blue-200'
            } ${!selectedPosition ? 'opacity-50 cursor-not-allowed' : ''}`}
            onClick={() => {
              if (selectedPosition) {
                setSelectedUser(user.id);
              }
            }}
            disabled={!selectedPosition}
          >
            <Avatar className="w-10 h-10">
              <AvatarFallback className={`text-xs ${selectedUser === user.id ? 'bg-[#2563EB] text-white' : 'bg-gray-300 text-gray-700'}`}>
                {user.avatar}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">{user.name}</p>
              <p className="text-xs text-gray-500">{user.email}</p>
              <p className="text-xs text-gray-400">ID: {user.studentId}</p>
            </div>
            {selectedUser === user.id 
  ? <CheckCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
  : isUserInCSG(user.id) && <CheckCircle className="w-5 h-5 text-blue-900 flex-shrink-0" />
}
          </button>
        ))
      ) : (
        <div className="text-center py-8">
          <Search className="w-12 h-12 text-gray-300 mx-auto mb-2" />
          <p className="text-sm text-gray-500">No users found</p>
          <p className="text-xs text-gray-400 mt-1">Try a different search term</p>
        </div>
      )}
    </div>
  </div>

  <div className="mt-6 flex justify-end gap-3">
    <Button
      onClick={() => {
        setIsSetOfficerModalOpen(false);
        setSelectedOfficer(null);
        setSelectedPosition(null);
        setSelectedUser(null);
        setModalUserSearchQuery('');
      }}
      variant="outline"
      className="border-gray-300 text-gray-700 hover:bg-gray-50"
    >
      Cancel
    </Button>
    <Button 
      onClick={handleSetOfficer} 
      className="bg-[#2563EB] hover:bg-blue-700 text-white"
      disabled={!selectedPosition || !selectedUser}
    >
      Set Officer
    </Button>
  </div>
</Modal>

      <Modal
        open={isCouncilTermModalOpen}
        onClose={() => setIsCouncilTermModalOpen(false)}
        title="Set Council Term"
        description="Set the start and end dates for the CSG council term. This will update all current CSG officers' term dates."
      >
        <div className="space-y-4 pt-4">
          <div>
            <label className="text-sm font-medium text-gray-700 mb-2 block">Council Start Date</label>
            <input
              type="date"
              value={councilStartDate}
              onChange={(e) => setCouncilStartDate(e.target.value)}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition px-3"
            />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700 mb-2 block">Council End Date</label>
            <input
              type="date"
              value={councilEndDate}
              onChange={(e) => setCouncilEndDate(e.target.value)}
              className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition px-3"
            />
          </div>
          {councilStartDate && councilEndDate && (
            <div className="p-3 bg-green-50 border border-green-200 rounded-lg">
              <p className="text-sm text-green-800">
                <span className="font-medium">Council Term:</span> {new Date(councilStartDate).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })} to {new Date(councilEndDate).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })}
              </p>
            </div>
          )}
          <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg">
            <p className="text-xs text-blue-800">
              <span className="font-medium">Note:</span> This will update the council term for all CSG members in the student_csg_officers table.
            </p>
          </div>
        </div>
        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => setIsCouncilTermModalOpen(false)}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Button>
          <Button
            onClick={handleSetCouncilTerm}
            className="bg-[#2563EB] hover:bg-blue-700 text-white"
            disabled={!councilStartDate || !councilEndDate}
          >
            <Calendar className="w-4 h-4 mr-2" />
            Set Council Term
          </Button>
        </div>
      </Modal>

      {/* Remove Officer Modal */}
      <Modal
        open={isRemoveOfficerModalOpen}
        onClose={() => {
          setIsRemoveOfficerModalOpen(false);
          setOfficerToRemove(null);
        }}
        title="Confirm Remove Officer"
        description="Are you sure you want to remove this officer from their position?"
      >
        <div className="space-y-4">
          {officerToRemove && (
            <>
              <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
                <p className="text-sm text-red-900">
                  <span className="font-medium">Officer:</span> {officerToRemove.name}
                </p>
                <p className="text-sm text-red-900 mt-1">
                  <span className="font-medium">Position:</span> {officerToRemove.position}
                </p>
                <p className="text-sm text-red-900 mt-1">
                  <span className="font-medium">Email:</span> {officerToRemove.email}
                </p>
              </div>
              <div className="p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
                <p className="text-xs text-yellow-800">
                  <span className="font-medium">Warning:</span> This action will revert the officer back to Member role and remove all officer privileges.
                </p>
              </div>
            </>
          )}
        </div>
        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsRemoveOfficerModalOpen(false);
              setOfficerToRemove(null);
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
            disabled={isRemoving}
          >
            Cancel
          </Button>
          <Button
            onClick={confirmRemoveOfficer}
            className="bg-red-600 hover:bg-red-700 text-white"
            disabled={isRemoving}
          >
            {isRemoving ? 'Removing...' : 'Remove Officer'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

export default function AdviserPermissionPage() {
  return (
    <AuthenticatedLayout>
      <Head title="Role Permissions" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <RolePermissionsPage />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}