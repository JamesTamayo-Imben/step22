<?php
// app/Models/LedgerEntry.php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;

class LedgerEntry extends Model
{
    protected $table = 'ledger_entries';
    protected $primaryKey = 'id';
    public $incrementing = false;
    protected $keyType = 'string';
    
    protected $fillable = [
        'id',
        'project_id',
        'type',
        'amount',
        'budget_breakdown',
        'description',
        'category',
        'ledger_proof',
        'file_content_hash',
        'approval_status',
        'note',
        'approved_by',
        'created_by',
        'updated_by',
        'approved_at',
        'rejected_at',
        'archive',
        'created_at',
        'updated_at',
    ];
    
    protected $casts = [
        'amount' => 'decimal:2',
        'budget_breakdown' => 'array',
        'approved_at' => 'datetime',
        'rejected_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'archive' => 'integer',
    ];
    
    public function scopeActive($query)
    {
        return $query->where('archive', 0);
    }

    public function scopeArchived($query)
    {
        return $query->where('archive', 1);
    }

    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }

    /**
     * Resolve the proof path for this entry, including linked transfer-pair entries.
     */
    public function resolveLedgerProof(): ?string
    {
        if (! empty($this->ledger_proof)) {
            return $this->ledger_proof;
        }

        if ($this->category === 'Transfer' && $this->type === 'Expense') {
            $noteData = json_decode($this->note ?? '', true);
            $destinationProjectId = is_array($noteData)
                ? ($noteData['transfer_destination_project_id'] ?? null)
                : null;

            if ($destinationProjectId) {
                $destinationProof = static::query()
                    ->where('project_id', $destinationProjectId)
                    ->where('category', 'Transfer')
                    ->where('type', 'Initial')
                    ->where('archive', 0)
                    ->value('ledger_proof');

                if ($destinationProof) {
                    return $destinationProof;
                }
            }
        }

        if ($this->type === 'Initial') {
            return static::query()
                ->where('project_id', $this->project_id)
                ->where('type', 'Initial')
                ->where('archive', 0)
                ->orderBy('created_at')
                ->value('ledger_proof');
        }

        return null;
    }
}