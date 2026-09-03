<?php
// app/Models/LedgerEntry.php

namespace App\Models\CSG;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

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

    public function getDisplayNote(): string
    {
        $note = (string) ($this->note ?? '');

        if ($note === '') {
            return '';
        }

        $decoded = json_decode($note, true);
        if (! is_array($decoded)) {
            return $note;
        }

        $sourceTitle = trim((string) ($decoded['transfer_source_project_title'] ?? ''));
        $destinationTitle = trim((string) ($decoded['transfer_destination_project_title'] ?? ''));

        if ($sourceTitle !== '' && $destinationTitle !== '') {
            return 'Transferred from completed project "' . $sourceTitle . '" to project "' . $destinationTitle . '"';
        }

        if ($destinationTitle !== '') {
            return 'Transferred to project "' . $destinationTitle . '"';
        }

        if ($sourceTitle !== '') {
            return 'Transferred from completed project "' . $sourceTitle . '"';
        }

        return $note;
    }

    /**
     * Resolve the proof path for this entry, including linked transfer-pair entries.
     */
    public function resolveLedgerProof(): ?string
    {
        if (! empty($this->ledger_proof)) {
            return $this->temporaryLedgerProofUrl($this->ledger_proof);
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
                    return $this->temporaryLedgerProofUrl($destinationProof);
                }
            }
        }

        if (in_array($this->type, ['Initial', 'Initial Transfer'], true)) {
            $initialProof = static::query()
                ->where('project_id', $this->project_id)
                ->whereIn('type', ['Initial', 'Initial Transfer'])
                ->where('archive', 0)
                ->orderBy('created_at')
                ->value('ledger_proof');

            return $this->temporaryLedgerProofUrl($initialProof);
        }

        return null;
    }

    private function temporaryLedgerProofUrl(?string $path): ?string
    {
        if (empty($path)) {
            return null;
        }

        $key = str_starts_with($path, 'storage/')
            ? substr($path, strlen('storage/'))
            : $path;

        return Storage::disk('supabase')->temporaryUrl($key, now()->addMinutes(15));
    }
}