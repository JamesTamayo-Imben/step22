<?php

namespace App\Http\Requests\CSG;

use Illuminate\Foundation\Http\FormRequest;

class UpdateLedgerEntryRequest extends FormRequest
{
    public function authorize()
    {
        // Controller performs model-level authorization where needed
        return true;
    }

    public function rules()
    {
        return [
            'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
            'description' => 'required|string|max:1000',
            'amount' => 'required|numeric|min:0',
            'budget_breakdown' => 'nullable|json',
            'updated_by' => 'nullable|exists:users,id',
            'ledger_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
        ];
    }
}
