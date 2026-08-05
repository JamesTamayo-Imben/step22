<?php

namespace App\Http\Controllers\CSG;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\LedgerEntry;
use App\Models\Project;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CSGProjectController extends Controller
{
    public function index()
    {
        // Only pass empty array initially, load via deferred props
        return Inertia::render('CSG/Projects', [
            'projects' => Inertia::defer(fn() => $this->getProjectsData()),
        ]);
    }

    private function getProjectsData()
    {
        return Project::query()->where('archive', 0)->latest('created_at')->get();
    }

    public function store(Request $request)
    {
        if (!Auth::user()?->hasPermission('projects.create')) {
            abort(403, 'You do not have permission to create projects.');
        }

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
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
            'archive' => 0,
        ]);

        $this->writeAudit(
            action: 'Project Created',
            module: 'projects',
            actionType: 'create',
            details: 'Created project "' . $project->title . '"',
            actionableId: $project->id,
            actionableType: 'project'
        );

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

        $validated['updated_by'] = Auth::id();
        $project->update($validated);

        $this->writeAudit(
            action: 'Project Updated',
            module: 'projects',
            actionType: 'update',
            details: 'Updated project "' . $project->title . '"',
            actionableId: $project->id,
            actionableType: 'project'
        );

        return response()->json(['success' => true, 'project' => $project]);
    }

    public function destroy(string $id)
    {
        $project = Project::query()->findOrFail($id);
        $project->update([
            'archive' => 1,
            'updated_by' => Auth::id(),
        ]);

        $this->writeAudit(
            action: 'Project Archived',
            module: 'projects',
            actionType: 'delete',
            details: 'Archived project "' . $project->title . '"',
            actionableId: $project->id,
            actionableType: 'project'
        );

        return response()->json(['success' => true]);
    }

    public function storeLedger(Request $request, string $projectId)
    {
        $project = Project::query()->where('archive', 0)->findOrFail($projectId);

        $validated = $request->validate([
            'type' => ['required', 'in:Income,Expense,Canvas,Donation,Sponsorship'],
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
            'created_by' => Auth::id(),
            'updated_by' => Auth::id(),
        ]);

        $this->writeAudit(
            action: 'Ledger Entry Created',
            module: 'ledger',
            actionType: 'create',
            details: 'Created ' . $entry->type . ' entry for project "' . $project->title . '" (' . $entry->amount . ')',
            actionableId: $entry->id,
            actionableType: 'ledger_entry'
        );

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

        $validated['updated_by'] = Auth::id();
        $entry->update($validated);

        $this->writeAudit(
            action: 'Ledger Entry Updated',
            module: 'ledger',
            actionType: 'update',
            details: 'Updated ledger entry for project ID ' . $projectId,
            actionableId: $entry->id,
            actionableType: 'ledger_entry'
        );

        return response()->json(['success' => true, 'entry' => $entry]);
    }

    public function destroyLedger(string $projectId, string $ledgerId)
    {
        $entry = LedgerEntry::query()
            ->where('project_id', $projectId)
            ->findOrFail($ledgerId);
        $entryDescription = $entry->description;
        $entry->delete();

        $this->writeAudit(
            action: 'Ledger Entry Deleted',
            module: 'ledger',
            actionType: 'delete',
            details: 'Deleted ledger entry "' . ($entryDescription ?? 'N/A') . '" from project ID ' . $projectId,
            actionableId: $ledgerId,
            actionableType: 'ledger_entry'
        );

        return response()->json(['success' => true]);
    }

    private function writeAudit(
        string $action,
        string $module,
        string $actionType,
        string $details,
        ?string $actionableId = null,
        ?string $actionableType = null
    ): void {
        AuditLog::create([
            'id' => (string) Str::uuid(),
            'user_id' => Auth::id(),
            'actionable_id' => $actionableId,
            'actionable_type' => $actionableType,
            'action' => $action,
            'module' => $module,
            'action_type' => $actionType,
            'status' => 'Success',
            'details' => $details,
            'ip_address' => request()->ip(),
            'browser_info' => substr((string) request()->userAgent(), 0, 500),
            'archive' => 0,
        ]);
    }
}
