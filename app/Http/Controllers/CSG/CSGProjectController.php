<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\LedgerEntry;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CSGProjectController extends Controller
{
    public function index()
    {
        $projects = Project::query()->where('archive', 0)->latest('created_at')->get();

        return Inertia::render('CSG/Projects', [
            'projects' => $projects,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'category' => ['nullable', 'string', 'max:100'],
            'budget' => ['nullable', 'numeric', 'min:0'],
            'start_date' => ['nullable', 'date'],
            'end_date' => ['nullable', 'date'],
        ]);

        $project = Project::create([
            'id' => (string) Str::uuid(),
            'title' => $validated['title'],
            'description' => $validated['description'] ?? null,
            'category' => $validated['category'] ?? null,
            'budget' => $validated['budget'] ?? 0,
            'start_date' => $validated['start_date'] ?? null,
            'end_date' => $validated['end_date'] ?? null,
            'status' => 'Draft',
            'approval_status' => 'Draft',
            'created_by' => auth()->id(),
            'updated_by' => auth()->id(),
            'archive' => 0,
        ]);

        return response()->json(['success' => true, 'project' => $project], 201);
    }

    public function update(Request $request, string $id)
    {
        $project = Project::query()->where('archive', 0)->findOrFail($id);

        $validated = $request->validate([
            'title' => ['sometimes', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'category' => ['nullable', 'string', 'max:100'],
            'budget' => ['nullable', 'numeric', 'min:0'],
            'start_date' => ['nullable', 'date'],
            'end_date' => ['nullable', 'date'],
            'status' => ['nullable', 'string', 'max:50'],
            'approval_status' => ['nullable', 'string', 'max:50'],
        ]);

        $validated['updated_by'] = auth()->id();
        $project->update($validated);

        return response()->json(['success' => true, 'project' => $project]);
    }

    public function destroy(string $id)
    {
        $project = Project::query()->findOrFail($id);
        $project->update([
            'archive' => 1,
            'updated_by' => auth()->id(),
        ]);

        return response()->json(['success' => true]);
    }

    public function storeLedger(Request $request, string $projectId)
    {
        $project = Project::query()->where('archive', 0)->findOrFail($projectId);

        $validated = $request->validate([
            'type' => ['required', 'in:Income,Expense'],
            'amount' => ['required', 'numeric', 'min:0'],
            'budget_breakdown' => ['required', 'integer', 'min:1'],
            'description' => ['required', 'string'],
            'category' => ['nullable', 'string', 'max:100'],
            'ledger_proof' => ['nullable', 'string', 'max:500'],
            'approval_status' => ['nullable', 'in:Draft,Pending Adviser Approval,Approved,Rejected'],
            'note' => ['nullable', 'string'],
        ]);

        $entry = LedgerEntry::create([
            'id' => (string) Str::uuid(),
            'project_id' => $project->id,
            'type' => $validated['type'],
            'amount' => $validated['amount'],
            'budget_breakdown' => $validated['budget_breakdown'],
            'description' => $validated['description'],
            'category' => $validated['category'] ?? null,
            'ledger_proof' => $validated['ledger_proof'] ?? null,
            'approval_status' => $validated['approval_status'] ?? 'Draft',
            'note' => $validated['note'] ?? null,
            'created_by' => auth()->id(),
            'updated_by' => auth()->id(),
        ]);

        return response()->json(['success' => true, 'entry' => $entry], 201);
    }

    public function updateLedger(Request $request, string $projectId, string $ledgerId)
    {
        $entry = LedgerEntry::query()
            ->where('project_id', $projectId)
            ->findOrFail($ledgerId);

        $validated = $request->validate([
            'type' => ['sometimes', 'in:Income,Expense'],
            'amount' => ['sometimes', 'numeric', 'min:0'],
            'budget_breakdown' => ['sometimes', 'integer', 'min:1'],
            'description' => ['sometimes', 'string'],
            'category' => ['nullable', 'string', 'max:100'],
            'ledger_proof' => ['nullable', 'string', 'max:500'],
            'approval_status' => ['nullable', 'in:Draft,Pending Adviser Approval,Approved,Rejected'],
            'note' => ['nullable', 'string'],
        ]);

        $validated['updated_by'] = auth()->id();
        $entry->update($validated);

        return response()->json(['success' => true, 'entry' => $entry]);
    }

    public function destroyLedger(string $projectId, string $ledgerId)
    {
        $entry = LedgerEntry::query()
            ->where('project_id', $projectId)
            ->findOrFail($ledgerId);
        $entry->delete();

        return response()->json(['success' => true]);
    }
}
