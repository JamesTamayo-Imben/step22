import React, { useEffect, useState } from 'react';

export default function AssetActionFields({ mode, onModeChange, usages, onUsagesChange }) {
  const [assets, setAssets] = useState([]);

  useEffect(() => {
    fetch(`/api/ledger-entries/assets?mode=${mode}`, { headers: { Accept: 'application/json' } })
      .then((response) => response.json())
      .then((data) => setAssets(Array.isArray(data) ? data : []))
      .catch(() => setAssets([]));
  }, [mode]);

  return (
    <div className="rounded-xl border border-blue-100 bg-blue-50 p-4 space-y-3">
      <label className="block text-sm text-gray-700 mb-1">Asset action</label>
      <select
        value={mode}
        onChange={(event) => onModeChange(event.target.value)}
        className="w-full h-10 px-3 border border-gray-200 rounded-xl bg-white"
      >
        <option value="purchase">Purchase/add new asset</option>
        <option value="use">Use existing asset</option>
      </select>
      {mode === 'use' && (
        <div className="space-y-2">
          <p className="text-sm text-gray-700">Select assets to use</p>
          {assets.length === 0 && <p className="text-xs text-gray-500">No reusable assets are currently available.</p>}
          {assets.filter((asset) => (mode === 'return' ? asset.returnable_quantity > 0 : asset.available_quantity > 0)).map((asset) => {
            const usage = usages.find((item) => item.asset_id === asset.id);
            const selectableQuantity = mode === 'return' ? asset.returnable_quantity : asset.available_quantity;
            return (
              <div key={asset.id} className="flex items-center gap-2 rounded-lg bg-white p-2">
                <input
                  type="checkbox"
                  checked={Boolean(usage)}
                  onChange={(event) => onUsagesChange(event.target.checked
                    ? [...usages, { asset_id: asset.id, asset_name: asset.name, quantity: 1 }]
                    : usages.filter((item) => item.asset_id !== asset.id))}
                />
                <span className="flex-1 text-sm">{asset.name} ({selectableQuantity} {mode === 'return' ? 'in use' : 'available'})</span>
                {usage && (
                  <input
                    type="number"
                    min="1"
                    max={selectableQuantity}
                    value={usage.quantity}
                    onChange={(event) => onUsagesChange(usages.map((item) => item.asset_id === asset.id ? { ...item, quantity: event.target.value } : item))}
                    className="w-20 h-8 rounded border border-gray-200 px-2"
                  />
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
