<?php

namespace App\Http\Requests\CSG;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\CSG\LedgerEntry;

class UploadLedgerProofRequest extends FormRequest
{
    public function authorize()
    {
        $id = $this->route('id') ?? $this->route('ledger');
        if (!$id) return false;

        $entry = LedgerEntry::find($id);
        if (!$entry) return false;

        return $this->user()?->can('uploadProof', $entry);
    }

    public function rules()
    {
        return [
            'proof_file' => 'required|file|mimes:pdf,jpg,jpeg,png|max:10240',
        ];
    }
}
