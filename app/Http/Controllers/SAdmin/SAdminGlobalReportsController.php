<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\Role;
use App\Models\User;
use App\Models\User\LedgerEntry;
use App\Models\User\Project;
use App\Models\User\Rating;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class SAdminGlobalReportsController extends Controller
{
    public function index()
    {
        $totalUsers = User::query()->where('archive', false)->count();
        $activeUsers = User::query()->where('archive', false)->where('status', 'active')->count();
        $newUsersThisMonth = User::query()
            ->where('archive', false)
            ->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();

        $roles = Role::query()->where('archive', false)->get(['id', 'name']);
        $byRole = [];
        foreach ($roles as $role) {
            $byRole[$role->name] = User::query()
                ->where('archive', false)
                ->where('role_id', $role->id)
                ->count();
        }

        $monthlyActive = [];
        for ($i = 5; $i >= 0; $i--) {
            $date = now()->subMonths($i);
            $count = User::query()
                ->where('archive', false)
                ->whereMonth('created_at', $date->month)
                ->whereYear('created_at', $date->year)
                ->count();

            $monthlyActive[] = [
                'month' => $date->format('M'),
                'count' => $count,
            ];
        }

        $totalProjects = Project::query()->where('archive', false)->count();
        $approvedProjects = Project::query()->where('archive', false)->where('approval_status', 'Approved')->count();
        $pendingProjects = Project::query()->where('archive', false)->whereIn('approval_status', ['Pending Adviser Approval', 'Pending Approval', 'Draft'])->count();
        $rejectedProjects = Project::query()->where('archive', false)->where('approval_status', 'Rejected')->count();

        $avgApprovalDays = 0.0;
        $approvedProjectsForTiming = Project::query()
            ->where('archive', false)
            ->whereNotNull('approved_at')
            ->whereNotNull('created_at')
            ->get(['created_at', 'approved_at']);

        if ($approvedProjectsForTiming->isNotEmpty()) {
            $averageSeconds = $approvedProjectsForTiming->average(function ($project) {
                if (! $project->created_at || ! $project->approved_at) {
                    return 0;
                }

                return $project->created_at->diffInSeconds($project->approved_at, false);
            });

            if ($averageSeconds !== null && $averageSeconds > 0) {
                $avgApprovalDays = round((float) $averageSeconds / 86400, 1);
            }
        }

        $staticProjectCategories = ['Social', 'Sports', 'Environmental', 'Technology', 'Cultural', 'Education', 'Health'];

        $categoryTotals = Project::query()
            ->where('archive', false)
            ->selectRaw('category, COUNT(*) as total')
            ->groupBy('category')
            ->orderByDesc('total')
            ->get()
            ->mapWithKeys(fn ($row) => [($row->category ?: 'Uncategorized') => (int) $row->total])
            ->all();

        $categoryTotals = collect($staticProjectCategories)
            ->mapWithKeys(fn ($category) => [$category => (int) ($categoryTotals[$category] ?? 0)])
            ->merge(collect($categoryTotals)->reject(fn ($count, $category) => in_array($category, $staticProjectCategories, true)))
            ->all();

        $projectSuccessRate = $totalProjects > 0 ? round(($approvedProjects / $totalProjects) * 100, 1) : 0.0;

        $totalLedgerEntries = LedgerEntry::query()->where('archive', false)->count();
        $incomeTypes = ['Income', 'Donation', 'Sponsorship', 'Initial', 'Initial Transfer'];
        $expenseTypes = ['Expense', 'Transfer', 'Canvas'];

        $totalIncome = (float) LedgerEntry::query()
            ->where('archive', false)
            ->whereIn('type', $incomeTypes)
            ->sum('amount');

        $totalExpense = (float) LedgerEntry::query()
            ->where('archive', false)
            ->whereIn('type', $expenseTypes)
            ->sum('amount');

        $balance = $totalIncome - $totalExpense;
        $approvedLedgerEntries = LedgerEntry::query()->where('archive', false)->where('approval_status', 'Approved')->count();
        $pendingLedgerEntries = LedgerEntry::query()->where('archive', false)->where('approval_status', 'Pending Adviser Approval')->count();
        $entriesWithProof = LedgerEntry::query()
            ->where('archive', false)
            ->whereNotNull('ledger_proof')
            ->where('ledger_proof', '!=', '')
            ->count();

        $proofCompliance = $totalLedgerEntries > 0 ? round(($entriesWithProof / $totalLedgerEntries) * 100, 1) : 0.0;
        $avgAccuracy = $proofCompliance;

        $totalRatings = Rating::query()->where('archive', false)->count();
        $averageRating = Rating::query()
            ->where('archive', false)
            ->whereNotNull('satisfaction_rating')
            ->avg('satisfaction_rating');

        return Inertia::render('SAdmin/GlobalReports', [
            'reports' => [
                'totalUsers' => $totalUsers,
                'activeUsers' => $activeUsers,
                'newUsersThisMonth' => $newUsersThisMonth,
                'byRole' => $byRole,
                'monthlyActive' => $monthlyActive,

                'totalProjects' => $totalProjects,
                'approvedProjects' => $approvedProjects,
                'pendingProjects' => $pendingProjects,
                'rejectedProjects' => $rejectedProjects,
                'avgApprovalTime' => $avgApprovalDays,
                'byCategory' => $categoryTotals,
                'successRate' => $projectSuccessRate,

                'totalLedgerEntries' => $totalLedgerEntries,
                'totalIncome' => $totalIncome,
                'totalExpense' => $totalExpense,
                'balance' => $balance,
                'approvedLedgerEntries' => $approvedLedgerEntries,
                'pendingLedgerEntries' => $pendingLedgerEntries,
                'avgAccuracy' => $avgAccuracy,
                'proofCompliance' => $proofCompliance,

                'totalRatings' => $totalRatings,
                'avgRating' => $averageRating !== null ? round((float) $averageRating, 2) : 0.0,
            ],
        ]);
    }
}
