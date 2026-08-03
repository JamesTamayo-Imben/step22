<?php

namespace App\Models\User;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LedgerEntry extends Model
{
    use HasFactory;

    protected $table = 'ledger_entries';
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
        'approval_status',
        'note',
        'approved_by',
        'created_by',
        'updated_by',
        'approved_at',
        'rejected_at',
        'archive',
    ];

    protected $casts = [
        'archive' => 'integer',
        'amount' => 'decimal:2',
        'budget_breakdown' => 'json',
        'approved_at' => 'datetime',
        'rejected_at' => 'datetime',
    ];

    public function project(): BelongsTo
    {
        return $this->belongsTo(Project::class, 'project_id', 'id');
    }

    public function approver(): BelongsTo
    {
        return $this->belongsTo(\App\Models\User::class, 'approved_by', 'id');
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(\App\Models\User::class, 'created_by', 'id');
    }

    public function updater(): BelongsTo
    {
        return $this->belongsTo(\App\Models\User::class, 'updated_by', 'id');
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

        if (in_array($this->type, ['Initial', 'Initial Transfer'], true)) {
            return static::query()
                ->where('project_id', $this->project_id)
                ->whereIn('type', ['Initial', 'Initial Transfer'])
                ->where('archive', 0)
                ->orderBy('created_at')
                ->value('ledger_proof');
        }

        return null;
    }
}
