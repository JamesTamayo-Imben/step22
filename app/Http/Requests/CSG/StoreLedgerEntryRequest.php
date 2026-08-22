<?php

namespace App\Http\Requests\CSG;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\CSG\LedgerEntry;

class StoreLedgerEntryRequest extends FormRequest
{
    public function authorize()
    {
        return $this->user()?->can('create', LedgerEntry::class);
    }

    public function rules()
    {
        return [
            'project_id' => 'required|exists:projects,id',
            'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
            'description' => 'required|string|max:1000',
            'amount' => 'required|numeric|min:0',
            'budget_breakdown' => 'nullable|json',
            'proof_file' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
            'ledger_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
            'approval_status' => 'nullable|string',
            'created_by' => 'nullable|exists:users,id',
        ];
    }
}
