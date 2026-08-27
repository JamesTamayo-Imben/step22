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
  ClipboardList,
  ChevronDown,
} from 'lucide-react';
import RolePermissionEditor from '@/Components/RolePermissionEditor';

const ROLE_OPTIONS = [
  { key: 'superadmin', label: 'Super Admin' },
  { key: 'admin', label: 'Council Adviser' },
  { key: 'admin-sadu', label: 'SADU Admin' },
  { key: 'csg', label: 'CSG' },
  { key: 'teacher', label: 'Teacher/Professor' },
  { key: 'student', label: 'Ordinary Students' },
];

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
  const {
    users = [],
    csgOfficerCandidates = [],
    adviserCandidates = [],
    councilOfficers: initialCouncilOfficers = [],
    councilAdviser: initialCouncilAdviser = [],
    councilSaduAdviser: initialCouncilSaduAdviser = [],
    rolePermissionMatrix: initialMatrix = [],
    superAdmins = [],
    studentCount = 0,
    teacherCount = 0,
  } = usePage().props;

  const [selectedRoleKey, setSelectedRoleKey] = useState('admin');
  const [viewMode, setViewMode] = useState('assign'); // 'assign' | 'permissions'
  const [roleMatrix, setRoleMatrix] = useState(initialMatrix);
  const [roleDropdownOpen, setRoleDropdownOpen] = useState(false);

  const [isSetOfficerModalOpen, setIsSetOfficerModalOpen] = useState(false);
  const [isSetAdviserModalOpen, setIsSetAdviserModalOpen] = useState(false);
  const [isSetSaduAdviserModalOpen, setIsSetSaduAdviserModalOpen] = useState(false);
  const [isCouncilTermModalOpen, setIsCouncilTermModalOpen] = useState(false);
  const [addCouncilPositionModalOpen, setAddCouncilPosition] = useState(false);
  const [isRemoveOfficerModalOpen, setIsRemoveOfficerModalOpen] = useState(false);
  const [isRemoveAdviserModalOpen, setIsRemoveAdviserModalOpen] = useState(false);
  const [isRemoveSaduAdviserModalOpen, setIsRemoveSaduAdviserModalOpen] = useState(false);
  const [newPositionName, setNewPositionName] = useState('');
  const [isAddingPosition, setIsAddingPosition] = useState(false);
  const [isLoadingPositions, setIsLoadingPositions] = useState(false);
  const [allPositions, setAllPositions] = useState([]);
  const [editingPositionId, setEditingPositionId] = useState(null);
  const [editingPositionName, setEditingPositionName] = useState('');
  const [isDeletingPositionId, setIsDeletingPositionId] = useState(null);
  const [councilStartDate, setCouncilStartDate] = useState('');
  const [councilEndDate, setCouncilEndDate] = useState('');
  const [positionSearchQuery, setPositionSearchQuery] = useState('');
  const [modalUserSearchQuery, setModalUserSearchQuery] = useState('');
  const [adviserSearchQuery, setAdviserSearchQuery] = useState('');
  const [saduAdviserSearchQuery, setSaduAdviserSearchQuery] = useState('');
  const [selectedPosition, setSelectedPosition] = useState('');
  const [selectedUser, setSelectedUser] = useState(null);
  const [selectedAdviserUser, setSelectedAdviserUser] = useState(null);
  const [selectedSaduAdviserUser, setSelectedSaduAdviserUser] = useState(null);
  const [selectedOfficer, setSelectedOfficer] = useState(null);
  const [selectedAdviser, setSelectedAdviser] = useState(null);
  const [selectedSaduAdviser, setSelectedSaduAdviser] = useState(null);
  const [officerToRemove, setOfficerToRemove] = useState(null);
  const [adviserToRemove, setAdviserToRemove] = useState(null);
  const [saduAdviserToRemove, setSaduAdviserToRemove] = useState(null);
  const [isLoadingTerm, setIsLoadingTerm] = useState(true);
  const [isRemoving, setIsRemoving] = useState(false);

  const [councilOfficers, setCouncilOfficers] = useState(initialCouncilOfficers);
  const [councilAdviser, setCouncilAdviser] = useState(initialCouncilAdviser);
  const [councilSaduAdviser, setCouncilSaduAdviser] = useState(initialCouncilSaduAdviser);

  useEffect(() => {
    setRoleMatrix(initialMatrix);
  }, [initialMatrix]);

  useEffect(() => {
    const onDocClick = () => setRoleDropdownOpen(false);
    if (roleDropdownOpen) {
      document.addEventListener('click', onDocClick);
      return () => document.removeEventListener('click', onDocClick);
    }
  }, [roleDropdownOpen]);

  const selectedRoleOption = ROLE_OPTIONS.find((r) => r.key === selectedRoleKey) || ROLE_OPTIONS[0];
  const currentPermissionRole = roleMatrix.find((r) => r.key === selectedRoleKey) || null;

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

  useEffect(() => {
    const loadCouncilPositions = async () => {
      setIsLoadingPositions(true);
      try {
        const response = await fetch('/admin/role-permissions/positions');
        const data = await response.json();

        if (!response.ok) {
          showToast(data.message || 'Failed to load positions', 'error');
          return;
        }

        const positions = data.positions || [];
        setAllPositions(positions);
        
        setCouncilOfficers(positions.map((pos) => {
          const assigned = initialCouncilOfficers.find((officer) =>
            officer.positionId === pos.id || officer.position === pos.name
          );

          if (assigned) {
            return {
              ...assigned,
              positionId: pos.id,
              position: pos.name,
            };
          }

          return {
            positionId: pos.id,
            position: pos.name,
            name: '',
            userId: '',
            email: '',
          };
        }));
      } catch (error) {
        console.error('Failed to fetch positions:', error);
        showToast('Failed to load positions', 'error');
      } finally {
        setIsLoadingPositions(false);
      }
    };

    loadCouncilPositions();
  }, [initialCouncilOfficers]);

  const formatDate = (dateString) => {
    if (!dateString) return '';
    return new Date(dateString).toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'short', 
      day: 'numeric' 
    });
  };

  // Define position hierarchy to maintain consistent order
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

  const isUserInCSG = (userId) => {
    return councilOfficers.some(officer => officer.userId === userId);
  };

  const isTeacherAdviser = (teacherId) => {
    return councilAdviser.some(adviser => adviser.userId === teacherId);
  };

  const isTeacherSaduAdmin = (teacherId) => {
    return councilSaduAdviser.some(adviser => adviser.userId === teacherId);
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

  const filteredAdviserUsers = useMemo(() => {
    const q = (adviserSearchQuery || '').toLowerCase();
    if (!q) return adviserCandidates;
    return adviserCandidates.filter(user =>
      user.name.toLowerCase().includes(q) 
      ||
      String(user.teacherId).toLowerCase().includes(q)
    );
  }, [adviserCandidates, adviserSearchQuery]);

  const filteredSaduAdviserUsers = useMemo(() => {
    const q = (saduAdviserSearchQuery || '').toLowerCase();
    if (!q) return adviserCandidates;
    return adviserCandidates.filter(user =>
      user.name.toLowerCase().includes(q) 
      ||
      String(user.teacherId).toLowerCase().includes(q)
    );
  }, [adviserCandidates, saduAdviserSearchQuery]);

  //search position
const searchPosition = useMemo(() => {
  const q = (positionSearchQuery || '').toLowerCase();
  return allPositions.filter(pos =>
    pos.name.toLowerCase().includes(q)
  );
}, [allPositions, positionSearchQuery]);

// Add this new memo
const filteredCouncilOfficers = useMemo(() => {
  const q = (positionSearchQuery || '').toLowerCase();
  let filtered = councilOfficers;
  
  if (q) {
    filtered = councilOfficers.filter(officer =>
      officer.position.toLowerCase().includes(q)
    );
  }
  
  // Sort by position hierarchy
  return [...filtered].sort((a, b) => {
    const posA = positionHierarchy[a.position] ?? 999;
    const posB = positionHierarchy[b.position] ?? 999;
    return posA - posB;
  });
}, [councilOfficers, positionSearchQuery]);
  

  const selectedPositionName = selectedPosition || '';

  const openOfficerModal = (officer) => {
    setSelectedOfficer(officer);
    setSelectedPosition(officer.position);
    setSelectedUser(null);
    setModalUserSearchQuery('');
    setIsSetOfficerModalOpen(true);
  };

  const openAdviserModal = (adviser) => {
    setSelectedAdviser(adviser);
    setSelectedPosition(adviser.position);
    setSelectedAdviserUser(null);
    setAdviserSearchQuery('');
    setIsSetAdviserModalOpen(true);
  };

  const openSaduAdviserModal = (adviser) => {
    setSelectedSaduAdviser(adviser);
    setSelectedPosition(adviser.position);
    setSelectedSaduAdviserUser(null);
    setSaduAdviserSearchQuery('');
    setIsSetSaduAdviserModalOpen(true);
  };

  const openCouncilTermModal = () => {
    setIsCouncilTermModalOpen(true);
  };

  const openAddCouncilPositionModal = () => {
    setNewPositionName('');
    setAddCouncilPosition(true);
  };

  const handleSetOfficer = () => {
    if (!selectedUser || !selectedPosition) {
      showToast('Please select a user to assign', 'error');
      return;
    }

    const selectedCandidate = csgOfficerCandidates.find(u => u.id === selectedUser);
    if (!selectedCandidate) return;

    setIsRemoving(true);
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
        setModalUserSearchQuery('');
        setIsSetOfficerModalOpen(false);
        setIsRemoving(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to assign officer', 'error');
        setIsRemoving(false);
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

  setIsRemoving(true);
  router.post('/admin/role-permissions/assign-adviser', {
    position: selectedPosition,
    teacherId: selectedAdviserUser,
  }, {
    onSuccess: () => {
      // Remove from both adviser and SADU adviser, then add to new position
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
      // Also clear from SADU adviser
      setCouncilSaduAdviser(prev =>
        prev.map(adviser =>
          adviser.userId === selectedCandidate.id
            ? { position: adviser.position, name: null, userId: null, email: null }
            : adviser
        )
      );
      showToast(`${selectedCandidate.name} has been assigned as adviser`);
      setSelectedAdviser(null);
      setSelectedAdviserUser(null);
      setSelectedPosition('');
      setAdviserSearchQuery('');
      setIsSetAdviserModalOpen(false);
      setIsRemoving(false);
    },
    onError: (error) => {
      showToast(error?.message || 'Failed to assign adviser', 'error');
      setIsRemoving(false);
    }
  });
};

const handleSetSaduAdviser = () => {
  if (!selectedSaduAdviserUser || !selectedPosition) {
    showToast('Please select a SADU Admin to assign', 'error');
    return;
  }

  const selectedCandidate = adviserCandidates.find(u => u.id === selectedSaduAdviserUser);
  if (!selectedCandidate) return;

  setIsRemoving(true);
  router.post('/admin/role-permissions/assign-sadu-adviser', {
    position: selectedPosition,
    teacherId: selectedSaduAdviserUser,
  }, {
    onSuccess: () => {
      // Remove from both SADU adviser and adviser, then add to new position
      setCouncilSaduAdviser(prev =>
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
      // Also clear from adviser
      setCouncilAdviser(prev =>
        prev.map(adviser =>
          adviser.userId === selectedCandidate.id
            ? { position: adviser.position, name: null, userId: null, email: null }
            : adviser
        )
      );
      showToast(`${selectedCandidate.name} has been assigned as SADU Admin`);
      setSelectedSaduAdviser(null);
      setSelectedSaduAdviserUser(null);
      setSelectedPosition('');
      setSaduAdviserSearchQuery('');
      setIsSetSaduAdviserModalOpen(false);
      setIsRemoving(false);
    },
    onError: (error) => {
      showToast(error?.message || 'Failed to assign SADU Admin', 'error');
      setIsRemoving(false);
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

  const handleRemoveSaduAdviser = (adviser) => {
    setSaduAdviserToRemove(adviser);
    setIsRemoveSaduAdviserModalOpen(true);
  };

  const handlePositionSort = (positions) => {
    const positionOrder = allPositions.map(pos => pos.name);
    return positions.sort((a, b) => positionOrder.indexOf(a.position) - positionOrder.indexOf(b.position));
  };

  const confirmRemoveOfficer = () => {
    if (!officerToRemove) return;

    setIsRemoving(true);
    router.post('/admin/role-permissions/remove-officer', {
      userId: officerToRemove.userId
    }, {
      onSuccess: () => {
        setCouncilOfficers(prev =>
          prev.map(o =>
            o.userId === officerToRemove.userId
              ? { ...o, name: null, userId: null, email: null }
              : o
          )
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
      teacherId: adviserToRemove.userId
    }, {
      onSuccess: () => {
        setCouncilAdviser(prev =>
          prev.map(a =>
            a.userId === adviserToRemove.userId
              ? { ...a, name: null, userId: null, email: null }
              : a
          )
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

  const confirmRemoveSaduAdviser = () => {
    if (!saduAdviserToRemove) return;

    setIsRemoving(true);
    router.post('/admin/role-permissions/remove-sadu-adviser', {
      teacherId: saduAdviserToRemove.userId
    }, {
      onSuccess: () => {
        setCouncilSaduAdviser(prev =>
          prev.map(a =>
            a.userId === saduAdviserToRemove.userId
              ? { ...a, name: null, userId: null, email: null }
              : a
          )
        );
        showToast(`${saduAdviserToRemove.name} has been removed as ${saduAdviserToRemove.position}`);
        setIsRemoveSaduAdviserModalOpen(false);
        setSaduAdviserToRemove(null);
        setIsRemoving(false);
      },
      onError: (error) => {
        showToast(error?.message || 'Failed to remove SADU Admin', 'error');
        setIsRemoving(false);
      }
    });
  };

  const handleAddCouncilPosition = async () => {
    const trimmedName = newPositionName.trim();
    if (!trimmedName) {
      showToast('Please enter a position name', 'error');
      return;
    }

    setIsAddingPosition(true);
    try {
      const response = await fetch('/admin/role-permissions/add-council-position', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        body: JSON.stringify({
          positionName: trimmedName,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        showToast(data.message || data.errors?.positionName?.[0] || 'Failed to add position', 'error');
        return;
      }

      const addedPosition = data.position;
      if (addedPosition) {
        setCouncilOfficers(prev => [
          ...prev,
          {
            positionId: addedPosition.id,
            position: addedPosition.name,
            name: '',
            userId: '',
            email: '',
          },
        ]);
      }

      showToast(data.message || 'Position added successfully');
      setNewPositionName('');
      setAddCouncilPosition(false);
    } catch (error) {
      showToast(error.message || 'Failed to add position', 'error');
    } finally {
      setIsAddingPosition(false);
    }
  };

  const handleEditCouncilPosition = async (id) => {
    const trimmedName = editingPositionName.trim();
    if (!trimmedName) {
      showToast('Please enter a position name', 'error');
      return;
    }

    setIsAddingPosition(true);
    try {
      const response = await fetch(`/admin/role-permissions/edit-council-position/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
        body: JSON.stringify({
          positionName: trimmedName,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        showToast(data.message || 'Failed to update position', 'error');
        return;
      }

      const updatedPosition = data.position;
      if (updatedPosition) {
        setAllPositions(prev =>
          prev.map(pos => pos.id === id ? { ...pos, name: updatedPosition.name } : pos)
        );
        setCouncilOfficers(prev =>
          prev.map(officer =>
            officer.positionId === id ? { ...officer, position: updatedPosition.name } : officer
          )
        );
      }

      showToast(data.message || 'Position updated successfully');
      setEditingPositionId(null);
      setEditingPositionName('');
    } catch (error) {
      showToast(error.message || 'Failed to update position', 'error');
    } finally {
      setIsAddingPosition(false);
    }
  };

  const handleDeleteCouncilPosition = async (id) => {
    setIsDeletingPositionId(id);
    try {
      const response = await fetch(`/admin/role-permissions/delete-council-position/${id}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.content || '',
        },
      });

      const data = await response.json();

      if (!response.ok) {
        showToast(data.message || 'Failed to delete position', 'error');
        return;
      }

      setAllPositions(prev => prev.filter(pos => pos.id !== id));
      setCouncilOfficers(prev => prev.filter(officer => officer.positionId !== id));

      showToast(data.message || 'Position deleted successfully');
    } catch (error) {
      showToast(error.message || 'Failed to delete position', 'error');
    } finally {
      setIsDeletingPositionId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-start justify-between gap-4">
        <div>
          <h1 className="text-blue-600 text-2xl font-semibold tracking-tight">Roles & Permissions</h1>
          <p className="mt-1 text-[15px] text-[#6b7280]">Configure role-based access control</p>
        </div>
        <div className="flex items-center gap-2 rounded-xl border border-[#e5e7eb] bg-white p-1 shadow-sm">
          {[
            { key: 'permissions', label: 'Permissions' },
            { key: 'assign', label: 'Assign Users' },
          ].map((tab) => (
            <button
              key={tab.key}
              type="button"
              onClick={() => setViewMode(tab.key)}
              className={`rounded-lg px-4 py-2 text-sm font-medium transition-colors ${
                viewMode === tab.key
                  ? 'bg-blue-600 text-white shadow-sm'
                  : 'text-[#374151] hover:bg-[#f3f4f6]'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-[290px_minmax(0,1fr)]">
        <aside className="rounded-[18px] border border-[#e5e7eb] bg-white p-3">
          <div className="space-y-3">
            {ROLE_OPTIONS.map((option) => {
              const isSelected = selectedRoleKey === option.key;
              const roleLabel = option.key === 'superadmin'
                ? 'Full system access with all permissions'
                : option.key === 'admin'
                  ? 'Approval authority and oversight capabilities'
                  : option.key === 'admin-sadu'
                    ? 'Operational oversight and coordination'
                    : option.key === 'csg'
                      ? 'Project and financial management'
                      : 'Student engagement and participation';

              const permissionCount = option.key === 'superadmin'
                ? 27
                : option.key === 'admin'
                  ? 9
                  : option.key === 'admin-sadu'
                    ? 9
                    : option.key === 'csg'
                      ? 18
                      : 6;

              return (
                <button
                  key={option.key}
                  type="button"
                  onClick={() => setSelectedRoleKey(option.key)}
                  className={`w-full rounded-[16px] border p-4 text-left transition-all ${
                    isSelected
                      ? 'border-blue-700 bg-white shadow-sm'
                      : 'border-transparent bg-transparent hover:border-[#d1d5db] hover:bg-white/70'
                  }`}
                >
                  <div className="flex items-center justify-between gap-3">
                    <span className={`text-[15px] font-semibold ${isSelected ? 'text-blue-700' : 'text-[#374151]'}`}>
                      {option.label}
                    </span>
                    {isSelected && (
                      <span className="inline-flex h-5 w-5 items-center justify-center rounded-full border border-[#22c55e] bg-[#dcfce7] text-[11px] text-[#16a34a]">
                        ✓
                      </span>
                    )}
                  </div>
                  <p className="mt-2 text-[14px] leading-5 text-[#6b7280]">{roleLabel}</p>
                  <div className="mt-3 inline-flex items-center gap-2 rounded-full bg-[#f3eff] px-2.5 py-1 text-[12px] font-medium text-blue-600">
                    <span>{permissionCount}</span>
                    <span>permissions</span>
                  </div>
                </button>
              );
            })}
          </div>
        </aside>

        <div className="rounded-[18px] border border-[#e5e7eb] bg-white shadow-sm">
          {viewMode === 'permissions' ? (
            <RolePermissionEditor
              key={selectedRoleKey}
              roleEntry={currentPermissionRole}
              saveUrl="/admin/role-permissions/save-permissions"
              onSaved={(matrix) => setRoleMatrix(matrix)}
            />
          ) : (
            <div className="p-6 rounded-[18px] space-y-6">
              {selectedRoleKey === 'superadmin' && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-xl font-semibold text-[#111827]">Super Admin</h2>
                      <p className="text-sm text-[#6b7280]">Full system access accounts</p>
                    </div>
                    <span className="rounded-full bg-[#eff6ff] px-3 py-1 text-sm font-medium text-blue-600">
                      {superAdmins.length} account(s)
                    </span>
                  </div>
                  <div className="grid gap-4 grid-cols-1 md:grid-cols-2">
                    {superAdmins.map((admin) => (
                      <div key={admin.id} className="rounded-xl border border-[#dbeafe] bg-[#eff6ff] p-4">
                        <div className="flex items-center gap-3">
                          <Avatar className="w-10 h-10">
                            <AvatarFallback className="bg-[#2563EB] text-white text-xs" name={admin.name} />
                          </Avatar>
                          <div>
                            <p className="font-medium text-[#111827]">{admin.name}</p>
                            <span className="rounded-full bg-[#dcfce7] px-2 py-0.5 text-[11px] font-medium text-[#15803d]">
                              {admin.status || 'Active'}
                            </span>
                          </div>
                        </div>
                        <p className="mt-3 text-sm text-[#6b7280]">Admin email: {admin.email}</p>
                        <p className="mt-1 text-sm text-[#6b7280]">Admin ID: {admin.id}</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {selectedRoleKey === 'admin' && (
                <div className="space-y-4">
                  <div>
                    <h2 className="text-xl font-semibold text-[#111827]">Council Adviser</h2>
                    <p className="text-sm text-[#6b7280]">Manage and assign council adviser role</p>
                  </div>
                  <div className="grid gap-4 grid-cols-2">
                    {councilAdviser.map((adviser) => {
                      const isVacant = !adviser.name;
                      return (
                        <div key={adviser.position} className={`rounded-xl border p-4 ${isVacant ? 'border-dashed border-[#d1d5db] bg-[#f9fafb]' : 'border-[#dbeafe] bg-[#eff6ff]'}`}>
                          <div className="flex items-center gap-3">
                            {isVacant ? (
                              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-[#e5e7eb] text-[#6b7280]">
                                <UserPlus className="h-5 w-5" />
                              </div>
                            ) : (
                              <Avatar className="w-10 h-10">
                                <AvatarFallback className="bg-[#2563EB] text-white text-xs" name={adviser.name} />
                              </Avatar>
                            )}
                            <div>
                              <p className={`font-medium ${isVacant ? 'text-[#9ca3af]' : 'text-[#111827]'}`}>{adviser.position}</p>
                              <span className={`rounded-full px-2 py-0.5 text-[11px] font-medium ${isVacant ? 'bg-[#e5e7eb] text-[#6b7280]' : 'bg-[#dcfce7] text-[#15803d]'}`}>
                                {isVacant ? 'Vacant' : 'Assigned'}
                              </span>
                            </div>
                          </div>
                          <div className="mt-4 space-y-2 text-sm text-[#6b7280]">
                            {isVacant ? (
                              <>
                                <p>No adviser assigned</p>
                                <p>No email available</p>
                              </>
                            ) : (
                              <>
                                <p>{adviser.name}</p>
                                <p>{adviser.email}</p>
                                <p>Teacher ID: {adviser.id}</p>
                              </>
                            )}
                          </div>
                          <div className="mt-4 grid-cols-2 gap-2">
                            <Button
                              onClick={() => openAdviserModal(adviser)}
                              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white"
                            >
                              {isVacant ? 'Assign Adviser' : 'Reassign Adviser'}
                            </Button>
                            <Button
                              onClick={() => handleRemoveAdviser(adviser)}
                              className="w-full bg-white border border-red-500 text-red-500 hover:bg-red-700 hover:text-white mt-2"
                            >
                              Remove
                            </Button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              {selectedRoleKey === 'admin-sadu' && (
                <div className="space-y-4">
                  <div>
                    <h2 className="text-xl font-semibold text-[#111827]">SADU Admin</h2>
                    <p className="text-sm text-[#6b7280]">Manage and assign SADU Admin role</p>
                  </div>
                  <div className="grid gap-4 grid-cols-2">
                    {councilSaduAdviser.map((adviser) => {
                      const isVacant = !adviser.name;
                      return (
                        <div key={adviser.position} className={`rounded-xl border p-4 ${isVacant ? 'border-dashed border-[#d1d5db] bg-[#f9fafb]' : 'border-[#dbeafe] bg-[#eff6ff]'}`}>
                          <div className="flex items-center gap-3">
                            {isVacant ? (
                              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-[#e5e7eb] text-[#6b7280]">
                                <UserPlus className="h-5 w-5" />
                              </div>
                            ) : (
                              <Avatar className="w-10 h-10">
                                <AvatarFallback className="bg-[#2563EB] text-white text-xs" name={adviser.name} />
                              </Avatar>
                            )}
                            <div>
                              <p className={`font-medium ${isVacant ? 'text-[#9ca3af]' : 'text-[#111827]'}`}>{adviser.position}</p>
                              <span className={`rounded-full px-2 py-0.5 text-[11px] font-medium ${isVacant ? 'bg-[#e5e7eb] text-[#6b7280]' : 'bg-[#dcfce7] text-[#15803d]'}`}>
                                {isVacant ? 'Vacant' : 'Assigned'}
                              </span>
                            </div>
                          </div>
                          <div className="mt-4 space-y-2 text-sm text-[#6b7280]">
                            {isVacant ? (
                              <>
                                <p>No SADU Admin assigned</p>
                                <p>No email available</p>
                              </>
                            ) : (
                              <>
                                <p>{adviser.name}</p>
                                <p>{adviser.email}</p>
                                <p>Teacher ID: {adviser.id}</p>
                              </>
                            )}
                          </div>
                          <div className="mt-4">
                            <Button
                              onClick={() => openSaduAdviserModal(adviser)}
                              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white"
                            >
                              {isVacant ? 'Assign SADU Admin' : 'Reassign SADU Admin'}
                            </Button>
                              <Button
                              onClick={() => handleRemoveSaduAdviser(adviser)}
                              className="w-full bg-white border border-red-500 text-red-500 hover:bg-red-700 hover:text-white mt-2"
                            >
                              Remove
                            </Button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              {selectedRoleKey === 'csg' && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between gap-4">
                    <div>
                      <h2 className="text-xl font-semibold text-[#111827]">CSG Council Officers</h2>
                      <p className="text-sm text-[#6b7280]">Manage and assign council officer positions</p>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button onClick={openCouncilTermModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
                        Council Term
                      </Button>
                      <Button onClick={openAddCouncilPositionModal} className="bg-[#2563EB] hover:bg-blue-700 text-white">
                        Council Position
                      </Button>
                    </div>
                  </div>
                  <div className="grid gap-4 sm:grid-cols-1 xl:grid-cols-2">
                    {filteredCouncilOfficers.map((officer) => {
                      const isVacant = !officer.name;
                      return (
                        <div key={officer.positionId || officer.position} className={`rounded-xl border p-4 ${isVacant ? 'border-dashed border-[#d1d5db] bg-[#f9fafb]' : 'border-[#dbeafe] bg-[#eff6ff]'}`}>
                          <div className="flex items-center gap-3">
                            {isVacant ? (
                              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-[#e5e7eb] text-[#6b7280]">
                                <UserPlus className="h-5 w-5" />
                              </div>
                            ) : (
                              <Avatar className="w-10 h-10">
                                <AvatarFallback className="bg-[#2563EB] text-white text-xs" name={officer.name} />
                              </Avatar>
                            )}
                            <div>
                              <p className={`font-medium ${isVacant ? 'text-[#9ca3af]' : 'text-[#111827]'}`}>{officer.position}</p>
                              <span className={`rounded-full px-2 py-0.5 text-[11px] font-medium ${isVacant ? 'bg-[#e5e7eb] text-[#6b7280]' : 'bg-[#dcfce7] text-[#15803d]'}`}>
                                {isVacant ? 'Vacant' : 'Assigned'}
                              </span>
                            </div>
                          </div>
                          <div className="mt-4 space-y-2 text-sm text-[#6b7280]">
                            {isVacant ? (
                              <>
                                <p>No officer assigned</p>
                                <p>No email available</p>
                                <p>No student ID available</p>
                              </>
                            ) : (
                              <>
                                <p>{officer.name}</p>
                                <p>{officer.email}</p>
                                <p>Student ID: {officer.id}</p>
                              </>
                            )}
                          </div>
                          <div className="mt-4">
                            <Button
                              onClick={() => openOfficerModal(officer)}
                              className="w-full bg-[#2563EB] hover:bg-blue-700 text-white"
                            >
                              {isVacant ? 'Assign Officer' : 'Reassign Position'}
                            </Button>
                              <Button
                              onClick={() => handleRemoveOfficer(officer)}
                              className="w-full bg-white border border-red-500 text-red-500 hover:bg-red-700 hover:text-white mt-2"
                            >
                              Remove
                            </Button>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              {selectedRoleKey === 'teacher' && (
                <div className="rounded-xl border border-[#dbeafe] bg-[#eff6ff] p-6">
                  <h2 className="text-xl font-semibold text-[#111827]">Ordinary Teachers</h2>
                  <p className="mt-2 text-sm text-[#6b7280]">Teachers have engagement access. Use Permissions to configure what they can do.</p>
                  <div className="mt-4 inline-flex rounded-full bg-[#dbeafe] px-3 py-1 text-sm font-medium text-[#1d4ed8]">
                    {teacherCount} teacher(s)
                  </div>
                </div>
              )}

              {selectedRoleKey === 'student' && (
                <div className="rounded-xl border border-[#dbeafe] bg-[#eff6ff] p-6">
                  <h2 className="text-xl font-semibold text-[#111827]">Ordinary Students</h2>
                  <p className="mt-2 text-sm text-[#6b7280]">Students have engagement access. Use Permissions to configure what they can do.</p>
                  <div className="mt-4 inline-flex rounded-full bg-[#dbeafe] px-3 py-1 text-sm font-medium text-[#1d4ed8]">
                    {studentCount} student(s)
                  </div>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Add Council Position Modal */
        <Modal
          open={addCouncilPositionModalOpen}
          onClose={() => {
            setAddCouncilPosition(false);
            setNewPositionName('');
            setEditingPositionId(null);
            setEditingPositionName('');
          }}
          title="Manage Council Positions"
          description="Add new positions or edit/delete existing positions."
        >
          <div className="space-y-6">
            {/* Add New Position Section */}
            <div className="border-b pb-6">
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Add New Position</h3>
              <div className="flex items-start gap-3">
                <Users className="w-5 h-5 text-[#2563EB] flex-shrink-0 mt-2" />
                <div className="flex-1">
                  <label htmlFor="new-position-name" className="text-sm text-gray-700 mb-2 block">Position Name</label>
                  <Input
                    id="new-position-name"
                    value={newPositionName}
                    onChange={(e) => setNewPositionName(e.target.value)}
                    placeholder="e.g. President, Secretary, Auditor"
                    className="rounded-xl"
                  />
                  <p className="text-xs text-gray-400 mt-2">
                    This will be saved to the position table and shown in the council officers list.
                  </p>
                </div>
              </div>
              <div className="flex justify-end gap-2 mt-4">
                <Button 
                  onClick={handleAddCouncilPosition} 
                  className="bg-[#2563EB] hover:bg-blue-700 text-white"
                  disabled={!newPositionName.trim() || isAddingPosition}
                >
                  {isAddingPosition ? 'Adding...' : 'Add Position'}
                </Button>
              </div>
            </div>

            {/* Existing Positions Section */}
            <div>
              <h3 className="text-sm font-semibold text-gray-900 mb-3">Existing Positions</h3>
              <div className="space-y-2 max-h-[300px] overflow-y-auto">
                {allPositions.length > 0 ? (
                  allPositions.map(position => (
                    <div
                      key={position.id}
                      className="flex items-center justify-between p-3 bg-gray-50 rounded-xl border border-gray-200"
                    >
                      {editingPositionId === position.id ? (
                        <div className="flex-1 flex items-center gap-2">
                          <Input
                            value={editingPositionName}
                            onChange={(e) => setEditingPositionName(e.target.value)}
                            placeholder="Position name"
                            className="rounded-lg flex-1"
                          />
                          <Button
                            size="sm"
                            className="bg-green-600 hover:bg-green-700 text-white"
                            onClick={() => handleEditCouncilPosition(position.id)}
                            disabled={isAddingPosition}
                          >
                            Save
                          </Button>
                          <Button
                            size="sm"
                            variant="outline"
                            className="border-gray-300"
                            onClick={() => {
                              setEditingPositionId(null);
                              setEditingPositionName('');
                            }}
                            disabled={isAddingPosition}
                          >
                            Cancel
                          </Button>
                        </div>
                      ) : (
                        <>
                          <p className="text-sm text-gray-900 font-medium">{position.name}</p>
                          <div className="flex items-center gap-2">
                            <Button
                              size="sm"
                              variant="outline"
                              className="border-blue-300 text-blue-600 hover:bg-blue-50"
                              onClick={() => {
                                setEditingPositionId(position.id);
                                setEditingPositionName(position.name);
                              }}
                              disabled={isAddingPosition}
                            >
                              Edit
                            </Button>
                            <Button
                              size="sm"
                              className="bg-red-600 hover:bg-red-700 text-white"
                              onClick={() => handleDeleteCouncilPosition(position.id)}
                              disabled={isDeletingPositionId === position.id || isAddingPosition}
                            >
                              {isDeletingPositionId === position.id ? 'Deleting...' : 'Delete'}
                            </Button>
                          </div>
                        </>
                      )}
                    </div>
                  ))
                ) : (
                  <div className="text-center py-8">
                    <Search className="w-12 h-12 text-gray-300 mx-auto mb-2" />
                    <p className="text-sm text-gray-500">No positions found</p>
                    <p className="text-xs text-gray-400 mt-1">Add a position to get started</p>
                  </div>
                )}
              </div>
            </div>
          </div>

        <div className="mt-6 flex justify-end gap-3 border-t pt-6">
          <Button
            onClick={() => {
              setAddCouncilPosition(false);
              setNewPositionName('');
              setEditingPositionId(null);
              setEditingPositionName('');
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
            disabled={isAddingPosition}
          >
            Close
          </Button>
        </div>
        </Modal>
}
      {/* Assign Officer Modal */}
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
                  {selectedAdviserUser === user.id
                    ? <CheckCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
                    : isTeacherSaduAdmin(user.id) && <CheckCircle className="w-5 h-5 text-blue-900 flex-shrink-0" />
                  }
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

      {/* Assign SADU Adviser Modal */}
      <Modal 
        open={isSetSaduAdviserModalOpen} 
        onClose={() => {
          setIsSetSaduAdviserModalOpen(false);
          setSelectedSaduAdviser(null);
          setSelectedPosition('');
          setSelectedSaduAdviserUser(null);
          setSaduAdviserSearchQuery('');
        }}
        title="Assign SADU Admin"
        description="Assign a SADU Admin to this position"
      >
        <div className="space-y-4">
          <div className="flex items-center gap-3">
            <Users className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
            <div className="flex-1">
              <label className="text-sm text-gray-700 mb-2 block">SADU Admin Position</label>
              <div className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 px-3 py-2 text-sm text-gray-700 flex items-center">
                {selectedPosition || 'Select a card to assign SADU Admin'}
              </div>
            </div>
          </div>
          <div className="flex items-center gap-3">
            <UserPlus className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
            <div className="flex-1">
              <label className="text-sm text-gray-700 mb-2 block">Search SADU Admin</label>
              <input 
                className="w-full h-10 rounded-xl border border-gray-300 bg-gray-50 focus:bg-white focus:border-gray-300 focus:ring-2 focus:ring-gray-200 outline-none transition"
                value={saduAdviserSearchQuery} 
                onChange={(e) => setSaduAdviserSearchQuery(e.target.value)} 
                placeholder="Name or Teacher ID" 
                disabled={!selectedPosition}
              />
            </div>
          </div>

          <div className="space-y-2 max-h-[300px] overflow-y-auto">
            {filteredSaduAdviserUsers.length > 0 ? (
              filteredSaduAdviserUsers.map(user => (
                <button
                  key={user.id}
                  type="button"
                  className={`w-full flex items-center gap-3 p-3 rounded-xl transition-all cursor-pointer ${
                    selectedSaduAdviserUser === user.id ? 'bg-blue-50 border-2 border-[#2563EB]' : 'bg-gray-50 border-2 border-transparent hover:border-blue-200'
                  } ${!selectedPosition ? 'opacity-50 cursor-not-allowed' : ''}`}
                  onClick={() => {
                    if (selectedPosition) {
                      setSelectedSaduAdviserUser(user.id);
                    }
                  }}
                  disabled={!selectedPosition}
                >
                  <Avatar className="w-10 h-10">
                    <AvatarFallback className={`text-xs ${selectedSaduAdviserUser === user.id ? 'bg-[#2563EB] text-white' : 'bg-gray-300 text-gray-700'}`} name={user.name} />
                  </Avatar>
                  <div className="flex-1 text-left">
                    <p className="text-sm text-gray-900 font-medium">{user.name}</p>
                    <p className="text-xs text-gray-500">{user.email}</p>
                    <p className="text-xs text-gray-400">ID: {user.teacherId}</p>
                  </div>
                  {selectedSaduAdviserUser === user.id
                    ? <CheckCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
                    : isTeacherAdviser(user.id) && <CheckCircle className="w-5 h-5 text-blue-900 flex-shrink-0" />
                  }
                </button>
              ))
            ) : (
              <div className="text-center py-8">
                <Search className="w-12 h-12 text-gray-300 mx-auto mb-2" />
                <p className="text-sm text-gray-500">No SADU Admins found</p>
                <p className="text-xs text-gray-400 mt-1">Try a different search term</p>
              </div>
            )}
          </div>
        </div>

        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsSetSaduAdviserModalOpen(false);
              setSelectedSaduAdviser(null);
              setSelectedPosition(null);
              setSelectedSaduAdviserUser(null);
              setSaduAdviserSearchQuery('');
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Button>
          <Button 
            onClick={handleSetSaduAdviser} 
            className="bg-[#2563EB] hover:bg-blue-700 text-white"
            disabled={!selectedPosition || !selectedSaduAdviserUser}
          >
            Assign SADU Admin
          </Button>
        </div>
      </Modal>

      {/* Council Term Modal */}
      <Modal
        open={isCouncilTermModalOpen}
        onClose={() => setIsCouncilTermModalOpen(false)}
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

      {/* Remove SADU Adviser Confirmation Modal */}
      <Modal
        open={isRemoveSaduAdviserModalOpen}
        onClose={() => {
          if (!isRemoving) {
            setIsRemoveSaduAdviserModalOpen(false);
            setSaduAdviserToRemove(null);
          }
        }}
        title="Remove SADU Admin"
        description={`Are you sure you want to remove ${saduAdviserToRemove?.name} as ${saduAdviserToRemove?.position}?`}
      >
        <div className="space-y-4">
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <div>
                <p className="text-sm text-red-800 font-medium">Warning: This action cannot be undone</p>
                <p className="text-sm text-red-700 mt-1">
                  This will revert {saduAdviserToRemove?.name}'s role back to <strong>Teacher</strong> and remove all SADU Admin permissions.
                </p>
              </div>
            </div>
          </div>
          
          <div className="bg-gray-50 p-3 rounded-lg">
            <p className="text-sm text-gray-600">
              <span className="font-medium">Position:</span> {saduAdviserToRemove?.position}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Name:</span> {saduAdviserToRemove?.name}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              <span className="font-medium">Email:</span> {saduAdviserToRemove?.email}
            </p>
          </div>
        </div>

        <div className="mt-6 flex justify-end gap-3">
          <Button
            onClick={() => {
              setIsRemoveSaduAdviserModalOpen(false);
              setSaduAdviserToRemove(null);
            }}
            variant="outline"
            className="border-gray-300 text-gray-700 hover:bg-gray-50"
            disabled={isRemoving}
          >
            Cancel
          </Button>
          <Button 
            onClick={confirmRemoveSaduAdviser}
            className="bg-red-600 hover:bg-red-700 text-white"
            disabled={isRemoving}
          >
            {isRemoving ? 'Removing...' : 'Yes, Remove SADU Admin'}
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