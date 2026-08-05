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
    if (!current?.isEditable) {
      showToast('This role cannot be modified', 'error');
      return;
    }
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
    if (!current?.isEditable) {
      showToast('This role cannot be modified', 'error');
      return;
    }
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
    if (!current?.isEditable) {
      showToast('This role cannot be modified', 'error');
      return;
    }
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
    <Card className="rounded-[20px] border-0 shadow-sm bg-white p-6">
      <div className="flex items-center justify-between mb-6 pb-4 border-b border-gray-200">
        <div className="flex-1">
          <h2 className="text-gray-900 flex items-center gap-2">
            <Shield className="w-5 h-5 text-[#2563EB]" />
            {heading}
          </h2>
          <p className="text-sm text-gray-500 mt-1">
            {current.isEditable
              ? 'Toggle permissions, then review and Save Changes. Disabled actions are blocked in the system.'
              : 'This role has fixed permissions and cannot be modified'}
          </p>
          {isDirty && current.isEditable && (
            <p className="text-xs text-amber-600 mt-1">You have unsaved changes</p>
          )}
        </div>
        <div className="text-right">
          <div className="flex items-baseline gap-1 justify-end">
            <span className="text-2xl text-[#2563EB]">{enabledCount}</span>
            <span className="text-gray-400">/</span>
            <span className="text-lg text-gray-500">{totalCount}</span>
          </div>
          <p className="text-xs text-gray-500">Active Permissions</p>
        </div>
      </div>

      {isCsg && (
        <div className="mb-6 p-4 bg-blue-50 rounded-xl border border-blue-200">
          <div className="flex flex-col gap-3 md:flex-row md:items-center">
            <Users className="w-5 h-5 text-[#2563EB] flex-shrink-0" />
            <div className="flex-1">
              <label className="text-sm text-gray-700 mb-2 block">CSG member / position</label>
              <Select
                value={selectedPositionId}
                onValueChange={setSelectedPositionId}
                className="w-full h-10 rounded-xl border border-gray-300 bg-white"
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
      )}

      {isCsg && !selectedPositionId ? (
        <div className="rounded-xl border border-gray-200 bg-gray-50 p-6 text-center text-sm text-gray-500">
          Select a CSG position to configure permissions.
        </div>
      ) : (
        <div className="space-y-6">
          {activeSections.map((section) => (
            <div key={section.category}>
              <h3 className="text-sm text-gray-900 mb-3 flex items-center gap-2">
                <div className="w-1 h-4 bg-[#2563EB] rounded" />
                {section.category}
              </h3>
              <div className="space-y-3 ml-3">
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
                    className={`flex items-center justify-between p-3 rounded-xl transition-colors ${
                      current.isEditable ? 'hover:bg-gray-50 cursor-pointer' : 'bg-gray-50 opacity-75'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${permission.enabled ? 'bg-green-100' : 'bg-gray-100'}`}>
                        {permission.enabled ? <Check className="w-4 h-4 text-green-600" /> : <span className="text-gray-400 text-sm">✕</span>}
                      </div>
                      <span className={`text-sm ${permission.enabled ? 'text-gray-900' : 'text-gray-500'}`}>
                        {permission.label}
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

          {current.isEditable && (
            <div className="flex flex-wrap justify-end gap-2 pt-2">
              <Button
                type="button"
                variant="outline"
                onClick={handleRestoreDefaults}
                disabled={isRestoring || isSaving}
                className="border-gray-300"
              >
                <RotateCcw className="w-4 h-4 mr-2" />
                Restore Default
              </Button>
              <Button
                type="button"
                onClick={handleSave}
                disabled={isSaving || !isDirty}
                className="bg-[#2563EB] hover:bg-blue-700 text-white disabled:opacity-50"
              >
                <Save className="w-4 h-4 mr-2" />
                {isSaving ? 'Saving...' : 'Save Changes'}
              </Button>
            </div>
          )}

          <div className={`mt-2 p-4 rounded-xl border ${current.isEditable ? 'bg-blue-50 border-blue-200' : 'bg-gray-50 border-gray-200'}`}>
            <div className="flex items-start gap-3">
              {current.isEditable ? (
                <AlertCircle className="w-5 h-5 text-[#2563EB] flex-shrink-0 mt-0.5" />
              ) : (
                <Lock className="w-5 h-5 text-gray-500 flex-shrink-0 mt-0.5" />
              )}
              <div>
                <p className="text-sm text-gray-900 mb-1">
                  {current.isEditable ? 'Review before applying' : 'Protected Role'}
                </p>
                <p className="text-xs text-gray-600 leading-relaxed">
                  {current.isEditable
                    ? 'Toggles stay local until you click Save Changes. Restore Default reloads the recommended set for review.'
                    : 'Super Admin permissions are locked to protect system governance.'}
                </p>
              </div>
            </div>
          </div>
        </div>
      )}
    </Card>
  );
}
