<?php

namespace App\Http\Controllers\SAdmin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Inertia\Inertia;

class SAdminSystemLogsController extends Controller
{
    private function logsQuery()
    {
        return AuditLog::with('user:id,name,role_id')
            ->where('archive', false);
    }

    public function index(Request $request)
    {
        $query = $this->logsQuery()->orderByDesc('created_at');

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

        if ($request->filled('actionType') && $request->input('actionType') !== 'all') {
            $query->where('action_type', $request->input('actionType'));
        }

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

        $modules = $this->logsQuery()
            ->distinct()
            ->pluck('module')
            ->sort()
            ->values();

        return Inertia::render('SAdmin/SystemLog', [
            'logs' => $logs,
            'modules' => $modules,
            'filters' => [
                'search' => $request->input('search', ''),
                'module' => $request->input('module', 'all'),
                'status' => $request->input('status', 'all'),
                'actionType' => $request->input('actionType', 'all'),
            ],
            'basePath' => '/sadmin/system-logs',
        ]);
    }

    public function export(Request $request)
    {
        $query = $this->logsQuery()->orderByDesc('created_at');

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

        if ($request->filled('actionType') && $request->input('actionType') !== 'all') {
            $query->where('action_type', $request->input('actionType'));
        }

        $logs = $query->get();

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
            ->header('Content-Disposition', 'attachment; filename="sadmin-system-logs-' . now()->format('Y-m-d-H-i-s') . '.csv"');
    }
}
