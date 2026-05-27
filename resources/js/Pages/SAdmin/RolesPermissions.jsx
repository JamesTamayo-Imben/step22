import React, { useEffect, useMemo, useState } from 'react';
import ReactDOM from 'react-dom';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage, router } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { Input } from '@/Components/ui/input';
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
} from 'lucide-react';

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
  const { users = [], csgOfficerCandidates = [], adviserCandidates = [], councilOfficers: initialCouncilOfficers = [], councilAdviser: initialCouncilAdviser = [], csgPositions: initialCsgPositions = [] } = usePage().props;

  const [isSetOfficerModalOpen, setIsSetOfficerModalOpen] = useState(false);
  const [isSetAdviserModalOpen, setIsSetAdviserModalOpen] = useState(false);
  const [isCouncilTermModalOpen, setIsCouncilTermModalOpen] = useState(false);
  const [isRemoveOfficerModalOpen, setIsRemoveOfficerModalOpen] = useState(false);
  const [isRemoveAdviserModalOpen, setIsRemoveAdviserModalOpen] = useState(false);
  const [councilStartDate, setCouncilStartDate] = useState('');
  const [councilEndDate, setCouncilEndDate] = useState('');
  const [searchQuery, setSearchQuery] = useState('');
  const [adviserSearchQuery, setAdviserSearchQuery] = useState('');
  const [selectedPosition, setSelectedPosition] = useState('');
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedAdviserUser, setSelectedAdviserUser] = useState(null);
  const [selectedOfficer, setSelectedOfficer] = useState(null);
  const [selectedAdviser, setSelectedAdviser] = useState(null);
  const [officerToRemove, setOfficerToRemove] = useState(null);
  const [adviserToRemove, setAdviserToRemove] = useState(null);
  const [isLoadingTerm, setIsLoadingTerm] = useState(true);
  const [isRemoving, setIsRemoving] = useState(false);

  const [councilOfficers, setCouncilOfficers] = useState(initialCouncilOfficers);
  const [councilAdviser, setCouncilAdviser] = useState(initialCouncilAdviser);
  const [csgPositions, setCSGPositions] = useState(initialCsgPositions);

  useEffect(() => {
    const fetchCouncilTerm = async () => {
      setIsLoadingTerm(true);
      try {
        const response = await fetch('/admin/role-permissions/get-council-term');
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

  const formatDate = (dateString) => {
    if (!dateString) return '';
    return new Date(dateString).toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'short', 
      day: 'numeric' 
    });
  };

//if the student is already part of csg make its checkcircle icon color blue
const isUserInCSG = (userId) => {
  return councilOfficers.some(officer => officer.userId === userId);
};


  const filteredUsers = useMemo(() => {
    const q = (searchQuery || '').toLowerCase();
    if (!q) return csgOfficerCandidates;
    return csgOfficerCandidates.filter(user =>
      user.name.toLowerCase().includes(q) 
      ||
      String(user.studentId).toLowerCase().includes(q)
    );
  }, [csgOfficerCandidates, searchQuery]);

  const filteredAdviserUsers = useMemo(() => {
    const q = (adviserSearchQuery || '').toLowerCase();
    if (!q) return adviserCandidates;
    return adviserCandidates.filter(user =>
      user.name.toLowerCase().includes(q) 
      ||
      String(user.teacherId).toLowerCase().includes(q)
    );
  }, [adviserCandidates, adviserSearchQuery]);

  const selectedPositionName = csgPositions.find(pos => String(pos.id) === String(selectedPosition))?.name || '';

  const openOfficerModal = (officer) => {
    setSelectedOfficer(officer);
    setSelectedPosition(officer.position);
    setSelectedUser(null);
    setSearchQuery('');
    setIsSetOfficerModalOpen(true);
  };

  const openAdviserModal = (adviser) => {
    setSelectedAdviser(adviser);
    setSelectedPosition(adviser.position);
    setSelectedAdviserUser(null);
    setAdviserSearchQuery('');
    setIsSetAdviserModalOpen(true);
  };

  const openCouncilTermModal = () => {
    setCouncilStartDate('');
    setCouncilEndDate('');
    setIsCouncilTermModalOpen(true);
  };

  const handleSetOfficer = () => {
    if (!selectedUser || !selectedPosition) {
      showToast('Please select a user to assign', 'error');
      return;
    }

    const selectedCandidate = csgOfficerCandidates.find(u => u.id === selectedUser);
    if (!selectedCandidate) return;

    router.post('/admin/role-permissions/assign-officer', {
      position: selectedPosition,
      userId: selectedUser,
    }, {
      onSuccess: () => {
        setCouncilOfficers(prev =>
          prev.map(officer => {
            if (officer.userId === selectedCandidate.id) {
              return { position: officer.position, name: null, userId: null, email: null };
            }
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
        setSearchQuery('');
        setIsSetOfficerModalOpen(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to assign officer', 'error');
      }
    });
  };

  const handleSetAdviser = () => {
    if (!selectedAdviserUser || !selectedPosition) {
      showToast('Please select an adviser to assign', 'error');
      return;
    }

    const selectedCandidate = adviserCandidates.find(u => u.id === selectedAdviserUser);
    if (!selectedCandidate) return;

    router.post('/admin/role-permissions/assign-adviser', {
      position: selectedPosition,
      teacherId: selectedAdviserUser,
    }, {
      onSuccess: () => {
        setCouncilAdviser(prev =>
          prev.map(adviser => {
            if (adviser.userId === selectedCandidate.id) {
              return { position: adviser.position, name: null, userId: null, email: null };
            }
            if (adviser.position === selectedPosition) {
              return { position: selectedPosition, name: selectedCandidate.name, userId: selectedCandidate.id, email: selectedCandidate.email };
            }
            return adviser;
          })
        );
        showToast(`${selectedCandidate.name} has been assigned as adviser`);
        setSelectedAdviser(null);
        setSelectedAdviserUser(null);
        setSelectedPosition('');
        setAdviserSearchQuery('');
        setIsSetAdviserModalOpen(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to assign adviser', 'error');
      }
    });
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

    const newStartDate = councilStartDate;
    const newEndDate = councilEndDate;

    try {
      const response = await fetch('/admin/role-permissions/set-council-term', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        body: JSON.stringify({
          startDate: councilStartDate,
          endDate: councilEndDate,
        }),
      });

      const data = await response.json();

      if (response.ok) {
        setCouncilStartDate(newStartDate);
        setCouncilEndDate(newEndDate);
        
        showToast(data.message || 'Council term updated successfully');
        setIsCouncilTermModalOpen(false);
        
        setTimeout(() => {
          router.reload({ only: ['councilOfficers', 'councilAdviser'] });
        }, 500);
      } else {
        showToast(data.message || 'Failed to set council term', 'error');
      }
    } catch (error) {
      showToast(error.message || 'Failed to set council term', 'error');
    }
  };

  const handleRemoveOfficer = (officer) => {
    setOfficerToRemove(officer);
    setIsRemoveOfficerModalOpen(true);
  };

  const handleRemoveAdviser = (adviser) => {
    setAdviserToRemove(adviser);
    setIsRemoveAdviserModalOpen(true);
  };

  const confirmRemoveOfficer = () => {
    if (!officerToRemove) return;
    
    setIsRemoving(true);
    router.post('/admin/role-permissions/remove-officer', {
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

  const confirmRemoveAdviser = () => {
    if (!adviserToRemove) return;
    
    setIsRemoving(true);
    router.post('/admin/role-permissions/remove-adviser', {
      teacherId: adviserToRemove.userId,
    }, {
      onSuccess: () => {
        setCouncilAdviser(prev =>
          prev.map(a => {
            if (a.userId === adviserToRemove.userId) {
              return { position: a.position, name: null, userId: null, email: null };
            }
            return a;
          })
        );
        showToast(`${adviserToRemove.name} has been removed as ${adviserToRemove.position}`);
        setIsRemoveAdviserModalOpen(false);
        setAdviserToRemove(null);
        setIsRemoving(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to remove adviser', 'error');
        setIsRemoving(false);
      }
    });
  };

  return (
    <div className="space-y-6">
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">Roles & Permissions</h1>
          <p className="text-gray-500">Configure role-based access control</p>
        </div>
        {/* <div className="flex flex-col sm:flex-row gap-3">
          <Button onClick={openCouncilTermModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
            <Calendar className="w-4 h-4 mr-2" />
            Set Council Term
          </Button>
        </div> */}
      </div>

      {/* Advisers Card */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="text-gray-900 flex items-center">STEP Administrators</h2>
            <p className="text-sm text-gray-500 mt-1">Manage and assign adviser roles</p>
          </div>
        </div>

       
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
         {/* CSG Adviser */}
         {councilAdviser.map((adviser) => {
            const isVacant = !adviser.name;

            return (
              <div
                key={adviser.position}
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
                        <AvatarFallback className="bg-[#0065FF] text-white text-xs" name={adviser.name} />
                      </Avatar>
                    )}
                    <div>
                      <h3 className={`text-sm ${isVacant ? 'text-gray-400' : 'text-gray-900'}`}>{adviser.position}</h3>
                      <Badge className={`text-xs ${isVacant ? 'bg-gray-200 text-gray-600' : 'bg-green-100 text-green-700'}`}>
                        {isVacant ? 'Vacant' : 'Assigned'}
                      </Badge>
                    </div>
                  </div>
                </div>

                {isVacant ? (
                  <div className="py-2">
                    <p className="text-xs text-gray-400">No adviser assigned</p>
                    <p className="text-xs text-gray-400">No email available</p>
                    <p className="text-xs text-gray-400">No Teacher ID available</p>
                    <div className="mt-3 border-t border-gray-200">
                      <Button
                        onClick={() => openAdviserModal(adviser)}
                        variant="outline"
                        size="sm"
                        className="mt-3 w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                      >
                        <UserPlus className="w-3 h-3 mr-1" />
                        Assign Adviser
                      </Button>
                    </div>
                  </div>
                ) : (
                  <div>
                    <p className="text-sm text-gray-900 mb-1">{adviser.name}</p>
                    <p className="text-xs text-gray-500">{adviser.email}</p>
                    <p className="text-xs text-gray-500">Teacher ID: {adviser.id}</p>
                    <div className="grid grid-cols-2 gap-2 mt-3 pt-3 border-t border-gray-200">
                      <Button
                        onClick={() => openAdviserModal(adviser)}
                        variant="outline"
                        size="sm"
                        className="w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                      >
                        <Repeat className="w-3 h-3 mr-1" />
                        Reassign Adviser
                      </Button>
                      <Button
                        onClick={() => handleRemoveAdviser(adviser)}
                        variant="outline"
                        size="sm"
                        className="w-full text-xs border-red-500 bg-red-500 text-white hover:bg-red-600 hover:text-white"
                      >
                        <AlertCircle className="w-3 h-3 mr-1" />
                        Remove Adviser
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            );
          })}

          {/* SADU adviser */}
           {councilAdviser.map((adviser) => {
            const isVacant = !adviser.name;

            return (
              <div
                key={adviser.position}
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
                        <AvatarFallback className="bg-[#0065FF] text-white text-xs" name={adviser.name} />
                      </Avatar>
                    )}
                    <div>
                      <h3 className={`text-sm ${isVacant ? 'text-gray-400' : 'text-gray-900'}`}>{adviser.position}</h3>
                      <Badge className={`text-xs ${isVacant ? 'bg-gray-200 text-gray-600' : 'bg-green-100 text-green-700'}`}>
                        {isVacant ? 'Vacant' : 'Assigned'}
                      </Badge>
                    </div>
                  </div>
                </div>

                {isVacant ? (
                  <div className="py-2">
                    <p className="text-xs text-gray-400">No SADU adviser assigned</p>
                    <p className="text-xs text-gray-400">No email available</p>
                    <p className="text-xs text-gray-400">No Teacher ID available</p>
                    <div className="mt-3 border-t border-gray-200">
                      <Button
                        onClick={() => openAdviserModal(adviser)}
                        variant="outline"
                        size="sm"
                        className="mt-3 w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                      >
                        <UserPlus className="w-3 h-3 mr-1" />
                        Assign Adviser
                      </Button>
                    </div>
                  </div>
                ) : (
                  <div>
                    <p className="text-sm text-gray-900 mb-1">{adviser.name}</p>
                    <p className="text-xs text-gray-500">{adviser.email}</p>
                    <p className="text-xs text-gray-500">Teacher ID: {adviser.id}</p>
                    <div className="grid grid-cols-2 gap-2 mt-3 pt-3 border-t border-gray-200">
                      <Button
                        onClick={() => openAdviserModal(adviser)}
                        variant="outline"
                        size="sm"
                        className="w-full text-xs border-[#2563EB] text-[#2563EB] hover:bg-[#2563EB] hover:text-white"
                      >
                        <Repeat className="w-3 h-3 mr-1" />
                        Reassign Adviser
                      </Button>
                      <Button
                        onClick={() => handleRemoveAdviser(adviser)}
                        variant="outline"
                        size="sm"
                        className="w-full text-xs border-red-500 bg-red-500 text-white hover:bg-red-600 hover:text-white"
                      >
                        <AlertCircle className="w-3 h-3 mr-1" />
                        Remove Adviser
                      </Button>
                    </div>
                  </div>
                )}
              </div>
            );
          })}
        </div>

        
      </Card>

      {/* CSG Council Officers Card */}
      <Card className="p-6 rounded-[20px] border-0 shadow-sm bg-white">
        <div className="flex items-start justify-between mb-4">
          <div>
          <div className="flex  items-start justify-between gap-2">
            <h2 className="text-gray-900 flex items-center">
              CSG Council Officers 
              <span className='text-sm text-blue-600 font-medium ml-2'>
                {formatDate(councilStartDate)} to {formatDate(councilEndDate)}
              </span>
            </h2>
           {/* <div className="flex flex-col sm:flex-row gap-3">
          <Button onClick={openCouncilTermModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
            <Calendar className="w-4 h-4 mr-2" />
            Council Position
          </Button>
        </div> */}
          </div>
            <p className="text-sm text-gray-500 mt-1">Manage and assign council officer positions</p>
          </div>
           <div className="flex flex-col sm:flex-row gap-3">
          <Button onClick={openCouncilTermModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
            <Users className="w-4 h-4 mr-2" />
            Council Position
          </Button>
          <Button className="bg-[#2563EB] hover:bg-blue-700 text-white">
            <Calendar className="w-4 h-4 mr-2" />
            Council Position
          </Button>
        </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {councilOfficers.map((officer) => {
            const position = csgPositions.find(p => p.id === officer.position);
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
                        <AvatarFallback className="bg-[#0065FF] text-white text-xs" name={officer.name} />
                      </Avatar>
                    )}
                    <div>
                      <h3 className={`text-sm ${isVacant ? 'text-gray-400' : 'text-gray-900'}`}>{position?.name}</h3>
                      <Badge className={`text-xs ${isVacant ? 'bg-gray-200 text-gray-600' : 'bg-green-100 text-green-700'}`}>
                        {isVacant ? 'Vacant' : 'Assigned'}
                      </Badge>
                    </div>
                  </div>
                </div>

                {isVacant ? (
                  <div className="py-2">
                    <p className="text-xs text-gray-400">No officer assigned</p>
                    <p className="text-xs text-gray-400">No email available</p>
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
          })}
        </div>
      </Card>

      {/* Assign Officer Modal */}
      <Modal
        open={isSetOfficerModalOpen}
        onClose={() => {
          setIsSetOfficerModalOpen(false);
          setSelectedOfficer(null);
          setSelectedPosition('');
          setSelectedUser(null);
          setSearchQuery('');
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
                value={searchQuery} 
                onChange={(e) => setSearchQuery(e.target.value)} 
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
                    <AvatarFallback className={`text-xs ${selectedUser === user.id ? 'bg-[#2563EB] text-white' : 'bg-gray-300 text-gray-700'}`} name={user.name} />
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
              setSearchQuery('');
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

      {/* Assign Adviser Modal */}
      <Modal 
        open={isSetAdviserModalOpen} 
        onClose={() => {
          setIsSetAdviserModalOpen(false);
          setSelectedAdviser(null);
          setSelectedPosition('');
          setSelectedAdviserUser(null);
          setAdviserSearchQuery('');
        }}
        title="Assign Adviser"
        description="Assign an adviser to this position"
      >
        <div className="space-y-4">
          <div className="flex items-center gap-3">
            <Users className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
            <div className="flex-1">
              <label className="text-sm text-gray-700 mb-2 block">Adviser Position</label>
              <div className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 px-3 py-2 text-sm text-gray-700 flex items-center">
                {selectedPosition || 'Select a card to assign adviser'}
              </div>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <UserPlus className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
            <div className="flex-1">
              <label className="text-sm text-gray-700 mb-2 block">Search Adviser</label>
              <input 
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                value={adviserSearchQuery} 
                onChange={(e) => setAdviserSearchQuery(e.target.value)} 
                placeholder="Name or Teacher ID" 
                disabled={!selectedPosition}
              />
            </div>
          </div>

          <div className="space-y-2 max-h-[300px] overflow-y-auto">
            {filteredAdviserUsers.length > 0 ? (
              filteredAdviserUsers.map(user => (
                <button
                  key={user.id}
                  type="button"
                  className={`w-full flex items-center gap-3 p-3 rounded-xl transition-all cursor-pointer ${
                    selectedAdviserUser === user.id ? 'bg-blue-50 border-2 border-[#2563EB]' : 'bg-gray-50 border-2 border-transparent hover:border-blue-200'
                  } ${!selectedPosition ? 'opacity-50 cursor-not-allowed' : ''}`}
                  onClick={() => {
                    if (selectedPosition) {
                      setSelectedAdviserUser(user.id);
                    }
                  }}
                  disabled={!selectedPosition}
                >
                  <Avatar className="w-10 h-10">
                    <AvatarFallback className={`text-xs ${selectedAdviserUser === user.id ? 'bg-[#2563EB] text-white' : 'bg-gray-300 text-gray-700'}`} name={user.name} />
                  </Avatar>
                  <div className="flex-1 text-left">
                    <p className="text-sm text-gray-900 font-medium">{user.name}</p>
                    <p className="text-xs text-gray-500">{user.email}</p>
                    <p className="text-xs text-gray-400">ID: {user.teacherId}</p>
                  </div>
                  {selectedAdviserUser === user.id && <CheckCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0" />}
                </button>
              ))
            ) : (
              <div className="text-center py-8">
                <Search className="w-12 h-12 text-gray-300 mx-auto mb-2" />
                <p className="text-sm text-gray-500">No advisers found</p>
                <p className="text-xs text-gray-400 mt-1">Try a different search term</p>
              </div>
            )}
          </div>
        </div>

        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsSetAdviserModalOpen(false);
              setSelectedAdviser(null);
              setSelectedPosition(null);
              setSelectedAdviserUser(null);
              setAdviserSearchQuery('');
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Button>
          <Button 
            onClick={handleSetAdviser} 
            className="bg-[#2563EB] hover:bg-blue-700 text-white"
            disabled={!selectedPosition || !selectedAdviserUser}
          >
            Assign Adviser
          </Button>
        </div>
      </Modal>

      {/* Council Term Modal */}
      <Modal
        open={isCouncilTermModalOpen}
        onClose={() => {
          setIsCouncilTermModalOpen(false);
          setCouncilStartDate('');
          setCouncilEndDate('');
        }}
        title="Set Council Term"
        description="Set the start and end dates for the CSG council term."
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
        </div>
        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsCouncilTermModalOpen(false);
              setCouncilStartDate('');
              setCouncilEndDate('');
            }}
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

      {/* Remove Officer Confirmation Modal */}
      <Modal
        open={isRemoveOfficerModalOpen}
        onClose={() => {
          if (!isRemoving) {
            setIsRemoveOfficerModalOpen(false);
            setOfficerToRemove(null);
          }
        }}
        title="Remove Officer"
        description={`Are you sure you want to remove ${officerToRemove?.name} as ${officerToRemove?.position}?`}
      >
        <div className="space-y-4">
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm text-red-800 font-medium">Warning: This action cannot be undone</p>
                <p className="text-sm text-red-700 mt-1">
                  This will revert {officerToRemove?.name}'s role back to <strong>Student</strong> and remove all CSG officer permissions.
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-gray-50 p-3 rounded-lg">
            <p className="text-sm text-gray-600">
              <span className="font-medium">Position:</span> {officerToRemove?.position}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Name:</span> {officerToRemove?.name}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Email:</span> {officerToRemove?.email}
            </p>
          </div>
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
            {isRemoving ? 'Removing...' : 'Yes, Remove Officer'}
          </Button>
        </div>
      </Modal>

      {/* Remove Adviser Confirmation Modal */}
      <Modal
        open={isRemoveAdviserModalOpen}
        onClose={() => {
          if (!isRemoving) {
            setIsRemoveAdviserModalOpen(false);
            setAdviserToRemove(null);
          }
        }}
        title="Remove Adviser"
        description={`Are you sure you want to remove ${adviserToRemove?.name} as ${adviserToRemove?.position}?`}
      >
        <div className="space-y-4">
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm text-red-800 font-medium">Warning: This action cannot be undone</p>
                <p className="text-sm text-red-700 mt-1">
                  This will revert {adviserToRemove?.name}'s role back to <strong>Teacher</strong> and remove all adviser permissions.
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-gray-50 p-3 rounded-lg">
            <p className="text-sm text-gray-600">
              <span className="font-medium">Position:</span> {adviserToRemove?.position}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Name:</span> {adviserToRemove?.name}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Email:</span> {adviserToRemove?.email}
            </p>
          </div>
        </div>

        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsRemoveAdviserModalOpen(false);
              setAdviserToRemove(null);
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
            disabled={isRemoving}
          >
            Cancel
          </Button>
          <Button 
            onClick={confirmRemoveAdviser}
            className="bg-red-600 hover:bg-red-700 text-white"
            disabled={isRemoving}
          >
            {isRemoving ? 'Removing...' : 'Yes, Remove Adviser'}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

export default function SAdminRolesPermissionsPage() {
  return (
    <AuthenticatedLayout>
      <Head title="Roles & Permissions" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <RolePermissionsPage />
        </div>
      </div>
    </AuthenticatedLayout>
  );
}