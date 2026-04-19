<?php

namespace App\Http\Controllers\Adviser;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdviserSystemLogsController extends Controller
{
    /**
     * Display system logs with filtering and pagination
     */
    public function index(Request $request)
    {
        $query = AuditLog::with('user:id,name')
            ->where('archive', false)
            ->orderByDesc('created_at');

        // Search filter
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

        // Module filter
        if ($request->filled('module') && $request->input('module') !== 'all') {
            $query->where('module', $request->input('module'));
        }

        // Status filter
        if ($request->filled('status') && $request->input('status') !== 'all') {
            $query->where('status', $request->input('status'));
        }

        // Action type filter
        if ($request->filled('actionType') && $request->input('actionType') !== 'all') {
            $query->where('action_type', $request->input('actionType'));
        }

        // Get paginated results
        $logs = $query->paginate(10)->through(function (AuditLog $log) {
            return [
                'id' => $log->id,
                'timestamp' => $log->created_at->format('Y-m-d H:i:s'),
                'user' => $log->user?->name ?? 'System',
                'action' => $log->action,
                'module' => $log->module,
                'status' => $log->status ?? 'Success',
                'ipAddress' => $log->ip_address ?? 'N/A',
                'details' => $log->details,
                'browserInfo' => $log->browser_info,
            ];
        });

        // Get unique modules for filter dropdown
        $modules = AuditLog::where('archive', false)
            ->distinct()
            ->pluck('module')
            ->sort()
            ->values();

        return Inertia::render('Adviser/SystemLog', [
            'logs' => $logs,
            'modules' => $modules,
            'filters' => [
                'search' => $request->input('search', ''),
                'module' => $request->input('module', 'all'),
                'status' => $request->input('status', 'all'),
                'actionType' => $request->input('actionType', 'all'),
            ],
        ]);
    }

    /**
     * Export system logs as CSV
     */
    public function export(Request $request)
    {
        $query = AuditLog::with('user:id,name')
            ->where('archive', false)
            ->orderByDesc('created_at');

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
        $csvContent = "Timestamp,User,Action,Module,Status,IP Address,Details\n";
        
        foreach ($logs as $log) {
            $csvContent .= sprintf(
                '"%s","%s","%s","%s","%s","%s","%s"' . "\n",
                $log->created_at->format('Y-m-d H:i:s'),
                $log->user?->name ?? 'System',
                str_replace('"', '""', $log->action),
                $log->module,
                $log->status ?? 'Success',
                $log->ip_address ?? 'N/A',
                str_replace('"', '""', $log->details ?? '')
            );
        }

        return response($csvContent)
            ->header('Content-Type', 'text/csv')
            ->header('Content-Disposition', 'attachment; filename="system-logs-' . now()->format('Y-m-d-H-i-s') . '.csv"');
    }
}
