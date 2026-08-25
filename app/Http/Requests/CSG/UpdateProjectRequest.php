<?php

namespace App\Http\Requests\CSG;

use Illuminate\Foundation\Http\FormRequest;
use App\Models\CSG\Project;

class UpdateProjectRequest extends FormRequest
{
    public function authorize()
    {
        $id = $this->route('id') ?? $this->route('project');
        if (!$id) return false;

        $project = Project::find($id);
        if (!$project) return false;

        return $this->user()?->can('update', $project);
    }

    public function rules()
    {
        return [
            'title' => 'sometimes|required|string|max:255',
            'description' => 'sometimes|required|string',
            'objective' => 'sometimes|required|string',
            'venue' => 'sometimes|required|string',
            'category' => 'sometimes|required|string',
            'budget' => 'sometimes|nullable|numeric|min:0',
            'has_budget' => 'nullable|in:0,1,true,false',
            'budget_source' => 'nullable|in:none,past_project',
            'transfer_from_project_id' => 'nullable|string|exists:projects,id',
            'transfer_amount' => 'nullable|numeric|min:0',
            'proposed_by' => 'sometimes|required|string',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'project_proof' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:10240',
        ];
    }
}
