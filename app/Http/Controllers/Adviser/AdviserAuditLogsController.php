<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdviserAuditLogsController extends Controller
{
    private function normalizeModule(?string $module): ?string
    {
        if ($module === null) {
            return null;
        }

        return match (strtolower($module)) {
            'projects', 'project' => 'project',
            'ledgers', 'ledger' => 'ledger',
            'meetings', 'meeting' => 'meeting',
            default => strtolower($module),
        };
    }

    private function normalizeActionType(?string $actionType): ?string
    {
        if ($actionType === null) {
            return null;
        }

        return match (strtolower($actionType)) {
            'archive' => 'archive',
            'restore' => 'restore',
            'alert' => 'alert',
            'view' => 'view',
            default => strtolower($actionType),
        };
    }

    private function csgLogsQuery()
    {
        return AuditLog::with('user:id,name,role_id')
            ->where('archive', false)
            ->whereHas('user.role', function ($query) {
                // $query->where('slug', 'csg');
            });
    }

    /**
     * Display audit logs with filtering and pagination
     */
    public function index(Request $request)
    {
        $query = $this->csgLogsQuery()->orderByDesc('created_at');

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('action', 'like', "%{$search}%")
                    ->orWhere('details', 'like', "%{$search}%")
                    ->orWhereHas('user', function ($q) use ($search) {
                        $q->where('name', 'like', "%{$search}%");
                    });
            });
        }

        if ($request->filled('module') && $request->input('module') !== 'all') {
            $module = $this->normalizeModule($request->input('module'));
            $query->whereIn('module', array_values(array_unique([$module, $request->input('module')])));
        }

        if ($request->filled('status') && $request->input('status') !== 'all') {
            $query->where('status', $request->input('status'));
        }

        if ($request->filled('actionType') && $request->input('actionType') !== 'all') {
            $actionType = $this->normalizeActionType($request->input('actionType'));
            $query->whereIn('action_type', array_values(array_unique([$actionType, $request->input('actionType')])));
        }

        $logs = $query->paginate(5)->through(function (AuditLog $log) {
            return [
                'id' => $log->id,
                'timestamp' => $log->created_at->format('F j, Y - g:iA'),
                'user' => $log->user?->name ?? 'System',
                'action' => $log->action,
                'actionType' => $log->action_type ?? 'unknown',
                'module' => $this->normalizeModule($log->module) ?? $log->module,
                'status' => $log->status ?? 'Success',
                'ipAddress' => $log->ip_address ?? 'N/A',
                'details' => $log->details,
                'browserInfo' => $log->browser_info,
                'actionableId' => $log->actionable_id,
                'actionableType' => $log->actionable_type,
            ];
        });

        $modules = $this->csgLogsQuery()
            ->get()
            ->map(fn (AuditLog $log) => $this->normalizeModule($log->module) ?? $log->module)
            ->filter()
            ->unique()
            ->sort()
            ->values();

        $summary = [
            'total' => $this->csgLogsQuery()->count(),
            'success' => $this->csgLogsQuery()->where('status', 'Success')->count(),
            'warning' => $this->csgLogsQuery()->where('status', 'Warning')->count(),
            'failed' => $this->csgLogsQuery()->where('status', 'Failed')->count(),
        ];

        return Inertia::render('Adviser/AuditLogs', [
            'logs' => $logs,
            'modules' => $modules,
            'summary' => $summary,
            'filters' => [
                'search' => $request->input('search', ''),
                'module' => $request->input('module', 'all'),
                'status' => $request->input('status', 'all'),
                'actionType' => $request->input('actionType', 'all'),
            ],
        ]);
    }

    /**
     * Export audit logs as CSV
     */
    public function export(Request $request)
    {
        $query = $this->csgLogsQuery()->orderByDesc('created_at');

        // Apply same filters as index
        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('action', 'like', "%{$search}%")
                    ->orWhere('details', 'like', "%{$search}%")
                    ->orWhereHas('user', function ($q) use ($search) {
                        $q->where('name', 'like', "%{$search}%");
                    });
            });
        }

        if ($request->filled('module') && $request->input('module') !== 'all') {
            $query->where('module', $request->input('module'));
        }

        if ($request->filled('status') && $request->input('status') !== 'all') {
            $query->where('status', $request->input('status'));
        }

        $logs = $query->get();

        // Generate CSV
        $csvContent = "Timestamp,User,Action,Module,Action Type,Actionable Type,Actionable ID,Status,IP Address,Browser Info,Details\n";
        
        foreach ($logs as $log) {
            $csvContent .= sprintf(
                '"%s","%s","%s","%s","%s","%s","%s","%s","%s","%s","%s"' . "\n",
                $log->created_at->format('F j, Y - g:iA'),
                $log->user?->name ?? 'System',
                str_replace('"', '""', $log->action),
                $this->normalizeModule($log->module) ?? $log->module,
                $log->action_type ?? 'unknown',
                $log->actionable_type ?? 'N/A',
                $log->actionable_id ?? 'N/A',
                $log->status ?? 'Success',
                $log->ip_address ?? 'N/A',
                str_replace('"', '""', (string) ($log->browser_info ?? 'N/A')),
                str_replace('"', '""', $log->details ?? '')
            );
        }

        return response($csvContent)
            ->header('Content-Type', 'text/csv')
            ->header('Content-Disposition', 'attachment; filename="adviser-audit-logs-' . now()->format('Y-m-d-H-i-s') . '.csv"');
    }
}
