import React, { useEffect, useMemo, useState } from 'react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import {
  Shield,
  Check,
  AlertCircle,
  RotateCcw,
  Save,
  Lock,
  Users,
} from 'lucide-react';

function Switch({ checked, onCheckedChange, disabled, className = '' }) {
  return (
    <button
      type="button"
      onClick={(e) => {
        e.stopPropagation();
        if (!disabled) onCheckedChange(!checked);
      }}
      className={[
        'relative inline-flex h-6 w-11 items-center rounded-full transition-colors',
        checked ? 'bg-[#22c55e]' : 'bg-[#111827]',
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

function showToast(message, type = 'success') {
  const text = typeof message === 'string' ? message : message?.message || 'An unexpected error occurred';
  const id = `perm-toast-${Date.now()}`;
  const el = document.createElement('div');
  el.id = id;
  el.className = 'fixed right-4 bottom-6 z-50 px-4 py-2 rounded shadow text-white';
  el.style.background = type === 'success' ? '#0ea5e9' : '#ef4444';
  el.textContent = text;
  document.body.appendChild(el);
  setTimeout(() => document.getElementById(id)?.remove(), 2200);
}

function cloneMatrix(matrix) {
  return JSON.parse(JSON.stringify(matrix || []));
}

function enabledIdsFromSections(sections = []) {
  return sections.flatMap((s) => s.permissions).filter((p) => p.enabled).map((p) => p.id);
}

function applyEnabledIdsToSections(sections = [], enabledIds = []) {
  const set = new Set(enabledIds.map(String));
  return sections.map((section) => ({
    ...section,
    permissions: section.permissions.map((p) => ({
      ...p,
      enabled: set.has(String(p.id)),
    })),
  }));
}

function permissionStateKey(entry) {
  if (!entry) return '';
  const isCsg = entry.slug === 'csg' || entry.key === 'csg';
  if (isCsg && Array.isArray(entry.positions)) {
    return JSON.stringify(
      entry.positions.map((pos) => ({
        id: pos.id,
        enabled: enabledIdsFromSections(pos.sections),
      }))
    );
  }
  return JSON.stringify(enabledIdsFromSections(entry.sections));
}

/**
 * Shared hierarchical permission editor with draft toggles.
 * Save / Restore Default only apply after review.
 */
export default function RolePermissionEditor({
  roleEntry,
  saveUrl = '/admin/role-permissions/save-permissions',
  onSaved,
  titlePrefix = '',
}) {
  const [draft, setDraft] = useState(() => cloneMatrix(roleEntry ? [roleEntry] : []));
  const [savedSnapshot, setSavedSnapshot] = useState(() => cloneMatrix(roleEntry ? [roleEntry] : []));
  const [selectedPositionId, setSelectedPositionId] = useState('');
  const [isSaving, setIsSaving] = useState(false);
  const [isRestoring, setIsRestoring] = useState(false);

  useEffect(() => {
    const next = cloneMatrix(roleEntry ? [roleEntry] : []);
    setDraft(next);
    setSavedSnapshot(cloneMatrix(next));
  }, [
    roleEntry?.id,
    roleEntry?.slug,
    permissionStateKey(roleEntry),
    JSON.stringify(roleEntry?.positions?.map((p) => p.id)),
    JSON.stringify(roleEntry?.defaultPermissionIds),
  ]);

  const current = draft[0] || null;
  const positions = current?.positions || [];
  const isCsg = current?.slug === 'csg' || current?.key === 'csg';

  useEffect(() => {
    if (!isCsg) {
      setSelectedPositionId('');
      return;
    }
    if (!positions.length) {
      setSelectedPositionId('');
      return;
    }
    const valid = positions.some((p) => String(p.id) === String(selectedPositionId));
    if (!valid) {
      setSelectedPositionId(String(positions[0].id));
    }
  }, [isCsg, positions, selectedPositionId]);

  const activeSections = useMemo(() => {
    if (!current) return [];
    if (isCsg && positions.length) {
      const pos = positions.find((p) => String(p.id) === String(selectedPositionId));
      return pos?.sections || [];
    }
    return current.sections || [];
  }, [current, isCsg, positions, selectedPositionId]);

  const defaultIds = useMemo(() => {
    if (isCsg) {
      const pos = positions.find((p) => String(p.id) === String(selectedPositionId));
      return pos?.defaultPermissionIds || current?.defaultPermissionIds || [];
    }
    return current?.defaultPermissionIds || [];
  }, [current, isCsg, positions, selectedPositionId]);

  const enabledCount = activeSections.reduce((sum, s) => sum + s.permissions.filter((p) => p.enabled).length, 0);
  const totalCount = activeSections.reduce((sum, s) => sum + s.permissions.length, 0);
  const positionName = positions.find((p) => String(p.id) === String(selectedPositionId))?.name || '';

  const isDirty = useMemo(() => {
    const saved = savedSnapshot[0];
    if (!current || !saved) return false;
    if (isCsg) {
      const draftPos = (current.positions || []).find((p) => String(p.id) === String(selectedPositionId));
      const savedPos = (saved.positions || []).find((p) => String(p.id) === String(selectedPositionId));
      return JSON.stringify(enabledIdsFromSections(draftPos?.sections)) !== JSON.stringify(enabledIdsFromSections(savedPos?.sections));
    }
    return JSON.stringify(enabledIdsFromSections(current.sections)) !== JSON.stringify(enabledIdsFromSections(saved.sections));
  }, [current, savedSnapshot, isCsg, selectedPositionId]);

  const handleToggle = (permissionId) => {
    if (isCsg && !selectedPositionId) {
      showToast('Select a CSG position first', 'error');
      return;
    }

    setDraft((prev) =>
      prev.map((role) => {
        if (isCsg) {
          return {
            ...role,
            positions: (role.positions || []).map((pos) => {
              if (String(pos.id) !== String(selectedPositionId)) return pos;
              return {
                ...pos,
                sections: pos.sections.map((section) => ({
                  ...section,
                  permissions: section.permissions.map((p) =>
                    String(p.id) === String(permissionId) ? { ...p, enabled: !p.enabled } : p
                  ),
                })),
              };
            }),
          };
        }

        return {
          ...role,
          sections: role.sections.map((section) => ({
            ...section,
            permissions: section.permissions.map((p) =>
              String(p.id) === String(permissionId) ? { ...p, enabled: !p.enabled } : p
            ),
          })),
        };
      })
    );
  };

  const handleRestoreDefaults = () => {
    if (isCsg && !selectedPositionId) {
      showToast('Select a CSG position first', 'error');
      return;
    }

    setIsRestoring(true);
    try {
      setDraft((prev) =>
        prev.map((role) => {
          if (isCsg) {
            return {
              ...role,
              positions: (role.positions || []).map((pos) => {
                if (String(pos.id) !== String(selectedPositionId)) return pos;
                return {
                  ...pos,
                  sections: applyEnabledIdsToSections(pos.sections, defaultIds),
                };
              }),
            };
          }
          return {
            ...role,
            sections: applyEnabledIdsToSections(role.sections, defaultIds),
          };
        })
      );
      showToast('Defaults loaded — review then Save Changes');
    } finally {
      setIsRestoring(false);
    }
  };

  const handleSave = async () => {
    if (isCsg && !selectedPositionId) {
      showToast('Select a CSG position first', 'error');
      return;
    }

    setIsSaving(true);
    try {
      const permissionIds = enabledIdsFromSections(activeSections);
      const csrf = document.querySelector('meta[name="csrf-token"]')?.content;
      const response = await fetch(saveUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'X-CSRF-TOKEN': csrf || '',
        },
        body: JSON.stringify({
          roleId: current.id,
          permissionIds,
          positionId: isCsg ? selectedPositionId : null,
        }),
      });
      const data = await response.json();
      if (!response.ok) {
        throw new Error(data.message || 'Failed to save permissions');
      }

      const nextSnapshot = cloneMatrix(draft);
      setSavedSnapshot(nextSnapshot);

      if (data.matrix && onSaved) {
        onSaved(data.matrix);
      }
      showToast(data.message || 'Permissions saved successfully');
    } catch (error) {
      showToast(error.message || 'Failed to save permissions', 'error');
    } finally {
      setIsSaving(false);
    }
  };

  if (!current) {
    return (
      <Card className="rounded-[20px] border-0 shadow-sm bg-white p-6 text-sm text-gray-500 text-center">
        No permission data available.
      </Card>
    );
  }

  const heading = isCsg && positionName
    ? `CSG — ${positionName} Permissions`
    : `${titlePrefix}${current.name} Permissions`;

  return (
    <Card className="rounded-[18px] border border-[#e5e7eb] bg-[#f7f7f7] p-0 shadow-sm">
      <div className="border-b border-[#e5e7eb] px-6 py-5">
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1">
            <h2 className="text-[22px] font-semibold text-[#111827]">{heading}</h2>
            <p className="mt-1 text-[15px] text-[#6b7280]">
              {current.isEditable
                ? 'Full system access with all permissions'
                : 'This role has fixed permissions and cannot be modified'}
            </p>
          </div>
          {/* {current.isEditable && (
            <div className="flex items-center gap-3">
              <Button
                type="button"
                variant="outline"
                onClick={handleRestoreDefaults}
                disabled={isRestoring || isSaving}
                className="border border-[#d1d5db] bg-white text-[#374151] hover:bg-[#f3f4f6]"
              >
                <RotateCcw className="w-4 h-4 mr-2" />
                Reset to Default
              </Button>
              <Button
                type="button"
                onClick={handleSave}
                disabled={isSaving || !isDirty}
                className="bg-blue-600 hover:bg-blue-700 text-white disabled:opacity-50"
              >
                <Save className="w-4 h-4 mr-2" />
                {isSaving ? 'Saving...' : 'Save Changes'}
              </Button>
            </div>
          )} */}
        </div>
        {current.isEditable && (
            <div className="flex mt-4 items-center gap-3">
              <Button
                type="button"
                variant="outline"
                onClick={handleRestoreDefaults}
                disabled={isRestoring || isSaving}
                className="border border-[#d1d5db] bg-white text-[#374151] hover:bg-[#f3f4f6]"
              >
                <RotateCcw className="w-4 h-4 mr-2" />
                Reset to Default
              </Button>
              <Button
                type="button"
                onClick={handleSave}
                disabled={isSaving || !isDirty}
                className="bg-blue-600 hover:bg-blue-700 text-white disabled:opacity-50"
              >
                <Save className="w-4 h-4 mr-2" />
                {isSaving ? 'Saving...' : 'Save Changes'}
              </Button>
            </div>
          )}
      </div>

      <div className="flex items-center justify-between px-6 py-5">
        <div className="text-[15px] font-medium text-[#111827]">
          {isCsg && positionName ? `${positionName} Permissions` : 'Permissions'}
        </div>
        <div className="inline-flex items-center gap-2 rounded-full bg-blue-50 px-3 py-1 text-sm font-medium text-blue-700">
          <span>{enabledCount}</span>
          <span className="text-[#a78bfa]">/</span>
          <span>{totalCount}</span>
        </div>
      </div>

      {isCsg && (
        <div className="px-6 pb-4">
          <div className="rounded-2xl border border-[#e5e7eb] bg-white p-4">
            <div className="flex flex-col gap-3 md:flex-row md:items-center">
              <Users className="w-5 h-5 text-blue-700 flex-shrink-0" />
              <div className="flex-1">
                <label className="text-sm text-gray-700 mb-2 block">CSG member / position</label>
                <Select
                  value={selectedPositionId}
                  onValueChange={setSelectedPositionId}
                  className="w-full h-10 rounded-xl border border-[#e5e7eb] bg-white"
                >
                  {positions.length === 0 ? (
                    <SelectItem value="">No positions available</SelectItem>
                  ) : (
                    positions.map((position) => (
                      <SelectItem key={position.id} value={String(position.id)}>
                        {position.name}
                      </SelectItem>
                    ))
                  )}
                </Select>
              </div>
            </div>
          </div>
        </div>
      )}

      {isCsg && !selectedPositionId ? (
        <div className="px-6 pb-6">
          <div className="rounded-xl border border-gray-200 bg-gray-50 p-6 text-center text-sm text-gray-500">
            Select a CSG position to configure permissions.
          </div>
        </div>
      ) : (
        <div className="space-y-5 px-6 pb-6">
          {activeSections.map((section) => (
            <div key={section.category} className="rounded-[18px] border border-[#e5e7eb] bg-white p-4">
              <h3 className="text-[18px] font-semibold text-[#111827] mb-4">{section.category}</h3>
              <div className="space-y-3">
                {section.permissions.map((permission) => (
                  <div
                    key={permission.id}
                    role={current.isEditable ? 'button' : undefined}
                    tabIndex={current.isEditable ? 0 : undefined}
                    onClick={() => current.isEditable && handleToggle(permission.id)}
                    onKeyDown={(e) => {
                      if (current.isEditable && (e.key === 'Enter' || e.key === ' ')) {
                        e.preventDefault();
                        handleToggle(permission.id);
                      }
                    }}
                    className={`flex items-center justify-between rounded-xl border border-[#e5e7eb] bg-[#f8fafc] px-4 py-3 transition-colors ${
                      current.isEditable ? 'hover:bg-[#f1f5f9] cursor-pointer' : 'opacity-75'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`flex h-6 w-6 items-center justify-center rounded-md ${permission.enabled ? 'bg-[#dcfce7] text-[#16a34a]' : 'bg-[#e5e7eb] text-[#6b7280]'}`}>
                        {permission.enabled ? <Check className="w-4 h-4" /> : <span className="text-xs">✕</span>}
                      </div>
                      <span className="text-[15px] font-medium text-[#374151]">
                        {permission.label}
                        {['admin', 'admin-sadu'].includes(current.slug) && section.category === 'Projects' && permission.label === 'View' && (
                          <span className="ml-2 text-xs font-normal text-gray-500">(cannot view approved projects, but can still approve or reject if permitted)</span>
                        )}
                        {['admin', 'admin-sadu'].includes(current.slug) && section.category === 'Ledger' && permission.label === 'View' && (
                          <span className="ml-2 text-xs font-normal text-gray-500">(cannot view ledger entries, but can still approve or reject if permitted)</span>
                        )}
                      </span>
                      {!current.isEditable && <Lock className="w-3 h-3 text-gray-400" />}
                    </div>
                    <Switch
                      checked={!!permission.enabled}
                      onCheckedChange={() => handleToggle(permission.id)}
                      disabled={!current.isEditable}
                    />
                  </div>
                ))}
              </div>
            </div>
          ))}

          <div className="rounded-xl border border-[#e5e7eb] bg-[#f8fafc] p-4 text-sm text-gray-600">
            {current.isEditable ? 'Toggles stay local until you click Save Changes. Restore Default reloads the recommended set for review.' : 'This role is protected and cannot be edited.'}
          </div>
        </div>
      )}
    </Card>
  );
}
