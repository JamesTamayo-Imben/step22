<?php

namespace App\Http\Requests\CSG;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\CSG\Project;

class StoreProjectRequest extends FormRequest
{
    public function authorize()
    {
        return $this->user()?->can('create', Project::class);
    }

    public function rules()
    {
        return [
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'objective' => 'required|string',
            'venue' => 'required|string',
            'category' => 'required|string',
            'budget' => 'nullable|numeric|min:0',
            'has_budget' => 'nullable|in:0,1,true,false',
            'is_active' => 'nullable|in:0,1,true,false',
            'budget_source' => 'nullable|in:none,past_project',
            'transfer_from_project_id' => 'nullable|string|exists:projects,id',
            'transfer_amount' => 'nullable|numeric|min:0',
            'proposed_by' => 'required|string',
            'status' => 'nullable|string',
            'approval_status' => 'nullable|string',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
            'is_initial' => 'nullable|in:0,1',
        ];
    }
}
