<?php

use App\Http\Controllers\Adviser\AdviserApprovalController;
use App\Http\Controllers\Adviser\AdviserDashboardController;
use App\Http\Controllers\Adviser\AdviserLedgerController;
use App\Http\Controllers\Adviser\AdviserNotificationController;
use App\Http\Controllers\Adviser\AdviserPermissionController;
use App\Http\Controllers\Adviser\AdviserRatingsController;
use App\Http\Controllers\Adviser\AdviserSystemLogsController;
use App\Http\Controllers\BlockchainController;
use App\Http\Controllers\CSG\CSGDashboardController;
use App\Http\Controllers\CSG\CSGProjectController;
use App\Http\Controllers\CSG\CSGRatingsController;
use App\Http\Controllers\CSG\LedgerEntryController;
use App\Http\Controllers\CSG\MeetingController;
use App\Http\Controllers\CSG\ProjectController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\Auth\PasswordController;
use App\Http\Controllers\SAdmin\SAdminDashboardController;
use App\Http\Controllers\SAdmin\SAdminArchivedItemsController;
use App\Http\Controllers\SAdmin\SAdminSystemLogsController;
use App\Http\Controllers\SAdmin\UserManagementController;
use App\Http\Controllers\User\UserProjectController;
use App\Models\User\Notification;
use Illuminate\Foundation\Application;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Route;
// use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
})->middleware('prevent_logged_in')->name('welcome');

Route::get('/contact', function () {
    return Inertia::render('ContactUs');
})->name('contact');

Route::get('/privacy', function () {
    return Inertia::render('PrivacyPolicy');
})->name('privacy');

Route::get('/terms', function () {
    return Inertia::render('TermsOfService');
})->name('terms');

Route::get('/features', function () {
    return Inertia::render('Features');
})->name('features');

Route::get('/user-guide', function () {
    return Inertia::render('UserGuide');
})->name('user-guide');

Route::get('/auth/register-teacher', function () {
    return Inertia::render('Auth/RegisterTeacher');
})->middleware('prevent_logged_in')->name('register.teacher');

Route::get('/auth/register-student', function () {
    return Inertia::render('Auth/RegisterStudent');
})->middleware('prevent_logged_in')->name('register.student');

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

// ========== SUPER ADMIN ROUTES (Temporarily without middleware for testing) ==========
Route::middleware(['auth', 'verified', 'role:superadmin'])->group(function ()  {
    // Super Admin Dashboard
    Route::get('/sadmin', [SAdminDashboardController::class, 'index'])->name('sadmin.dashboard');
    Route::get('/sadmin/dashboard', [SAdminDashboardController::class, 'index'])->name('sadmin.dashboard.alias');

    // User Management
    Route::get('/sadmin/users', [UserManagementController::class, 'index'])->name('sadmin.users');
    Route::get('/sadmin/users/search', [UserManagementController::class, 'search'])->name('sadmin.users.search');
    Route::get('/sadmin/users/form-fields/{roleId}', [UserManagementController::class, 'getFormFields'])->name('sadmin.users.form-fields');
    Route::post('/sadmin/users', [UserManagementController::class, 'create'])->name('sadmin.users.create');
    Route::post('/sadmin/users/bulk-create', [UserManagementController::class, 'bulkCreate'])->name('sadmin.users.bulk-create');
    Route::post('/sadmin/users/store', [UserManagementController::class, 'store'])->name('sadmin.users.store');
    Route::patch('/sadmin/users/{user}/toggle-status', [UserManagementController::class, 'toggleStatus'])->name('sadmin.users.toggle-status');
    Route::post('/sadmin/users/{user}/reset-password', [UserManagementController::class, 'resetPassword'])->name('sadmin.users.reset-password');
    Route::patch('/sadmin/users/{user}/role', [UserManagementController::class, 'updateRole'])->name('sadmin.users.update-role');
    Route::patch('/sadmin/users/{user}/restore', [UserManagementController::class, 'restore'])->name('sadmin.users.restore');
    Route::delete('/sadmin/users/{user}', [UserManagementController::class, 'destroy'])->name('sadmin.users.destroy');

    // Role Permissions
    Route::get('/sadmin/roles', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'rolesPermissions'])->name('sadmin.roles');
    Route::post('/admin/role-permissions/assign-officer', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'assignOfficer'])->name('admin.role-permissions.assign-officer');
    Route::post('/admin/role-permissions/remove-officer', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'removeOfficer'])->name('admin.role-permissions.remove-officer');
    Route::post('/admin/role-permissions/set-council-term', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'setCouncilTerm'])->name('admin.role-permissions.set-council-term');
    Route::get('/admin/role-permissions/get-council-term', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'getCouncilTerm'])->name('admin.role-permissions.get-council-term');
    Route::post('/admin/role-permissions/assign-adviser', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'assignAdviser'])->name('admin.role-permissions.assign-adviser');
    Route::post('/admin/role-permissions/remove-adviser', [\App\Http\Controllers\SAdmin\SAdminDashboardController::class, 'removeAdviser'])->name('admin.role-permissions.remove-adviser');

    // Super Admin governance pages
    Route::get('/sadmin/archived-projects', [SAdminArchivedItemsController::class, 'index'])->name('sadmin.archived-projects');

    Route::get('/sadmin/ledger-entries', function () {
        return Inertia::render('SAdmin/_SimplePage', [
            'title' => 'Ledger Entries',
            'subtitle' => 'Review ledger entry records and related status history.',
        ]);
    })->name('sadmin.ledger-entries');

    Route::get('/sadmin/meetings', function () {
        return Inertia::render('SAdmin/_SimplePage', [
            'title' => 'Meetings',
            'subtitle' => 'View meeting records managed by councils and officers.',
        ]);
    })->name('sadmin.meetings');

    Route::get('/sadmin/system-logs', [SAdminSystemLogsController::class, 'index'])->name('sadmin.system-logs');
    Route::get('/sadmin/system-logs/export', [SAdminSystemLogsController::class, 'export'])->name('sadmin.system-logs.export');

    // Admin Pages
    Route::get('/sadmin/data-backup', function () {
        return Inertia::render('SAdmin/DataBackup');
    })->name('sadmin.data-backup');

    Route::get('/sadmin/organizations', function () {
        return Inertia::render('SAdmin/Organizations');
    })->name('sadmin.organizations');

    Route::get('/sadmin/settings', function () {
        return Inertia::render('SAdmin/SystemSettings');
    })->name('sadmin.settings');

    Route::get('/sadmin/audit-logs', function () {
        return Inertia::render('SAdmin/AuditLogs');
    })->name('sadmin.audit-logs');

    Route::get('/sadmin/engagement-rules', function () {
        return Inertia::render('SAdmin/EngagementRules');
    })->name('sadmin.engagement-rules');

    Route::get('/sadmin/master-data', function () {
        return Inertia::render('SAdmin/MasterData');
    })->name('sadmin.master-data');

    Route::get('/sadmin/global-reports', function () {
        return Inertia::render('SAdmin/GlobalReports');
    })->name('sadmin.global-reports');

    Route::get('/sadmin/notifications', function () {
        return Inertia::render('SAdmin/Notifications');
    })->name('sadmin.notifications');

    Route::get('/sadmin/profile', function (Request $request) {
        return Inertia::render('SAdmin/Profile', [
            'user' => $request->user(),
        ]);
    })->name('sadmin.profile');
});

// ========== ADVISER ROUTES (Only accessible by Admin/Adviser role) ==========
Route::middleware(['auth', 'verified', 'role:admin'])->group(function () {
    Route::get('/adviser', [AdviserDashboardController::class, 'index'])->name('adviser.dashboard');
    Route::get('/adviser/dashboard', [AdviserDashboardController::class, 'index'])->name('adviser.dashboard.alias');

    // Project Approvals
    Route::get('/adviser/approvals', [AdviserApprovalController::class, 'index'])->name('adviser.approvals');
    Route::post('/adviser/approvals/approve', [AdviserApprovalController::class, 'approve'])->name('adviser.approvals.approve');
    Route::post('/adviser/approvals/reject', [AdviserApprovalController::class, 'reject'])->name('adviser.approvals.reject');

    // Blockchain routes (accessible to advisers)
    Route::get('/blockchain/project/{projectId}', [BlockchainController::class, 'show'])->name('blockchain.show');
    Route::post('/blockchain/verify', [BlockchainController::class, 'verify'])->name('blockchain.verify');
    Route::get('/blockchain/project/{projectId}/export', [BlockchainController::class, 'export'])->name('blockchain.export');

    // Ledger Management
    Route::get('/adviser/ledger', [AdviserLedgerController::class, 'index'])->name('adviser.ledger');
    Route::post('/adviser/ledger/{id}/approve', [AdviserLedgerController::class, 'approve'])->name('adviser.ledger.approve');
    Route::post('/adviser/ledger/{id}/reject', [AdviserLedgerController::class, 'reject'])->name('adviser.ledger.reject');
    Route::post('/adviser/ledger/{id}/correction', [AdviserLedgerController::class, 'correction'])->name('adviser.ledger.correction');
    Route::post('/adviser/ledger/{id}/fix-tampered', [AdviserLedgerController::class, 'fixTampered'])->name('adviser.ledger.fix-tampered');
    Route::post('/adviser/ledger/fix-budget-mismatch', [AdviserLedgerController::class, 'fixBudgetMismatch'])->name('adviser.ledger.fix-budget-mismatch');

    // Role Permissions Management
    Route::get('/adviser/role-permissions', [AdviserPermissionController::class, 'index'])->name('adviser.role-permissions');
    Route::post('/adviser/role-permissions/assign-officer', [AdviserPermissionController::class, 'assignOfficer'])->name('adviser.role-permissions.assign-officer');
    Route::post('/adviser/role-permissions/remove-officer', [AdviserPermissionController::class, 'removeOfficer'])->name('adviser.role-permissions.remove-officer');
    Route::post('/adviser/role-permissions/update', [AdviserPermissionController::class, 'updatePermissions'])->name('adviser.role-permissions.update');
    Route::post('/adviser/role-permissions/set-council-term', [AdviserPermissionController::class, 'setCouncilTerm'])->name('adviser.role-permissions.set-council-term');
    Route::get('/adviser/role-permissions/get-council-term', [AdviserPermissionController::class, 'getCouncilTerm'])->name('adviser.role-permissions.get-council-term');

    // Ratings & Notifications
    Route::get('/adviser/ratings', [AdviserRatingsController::class, 'index'])->name('adviser.ratings');
    Route::get('/adviser/notifications', [AdviserNotificationController::class, 'index'])->name('adviser.notifications');
    Route::post('/adviser/notifications/read/{id}', [AdviserNotificationController::class, 'markRead'])->name('adviser.notifications.read');
    Route::post('/adviser/notifications/mark-all-read', [AdviserNotificationController::class, 'markAllRead'])->name('adviser.notifications.mark-all-read');

    // System Pages
    Route::get('/adviser/system-logs', [AdviserSystemLogsController::class, 'index'])->name('adviser.system-logs');
    Route::get('/adviser/system-logs/export', [AdviserSystemLogsController::class, 'export'])->name('adviser.system-logs.export');

    Route::get('/adviser/profile', function (Request $request) {
        return Inertia::render('Adviser/Profile', [
            'user' => $request->user(),
        ]);
    })->name('adviser.profile');

    Route::post('/adviser/change-password', function (Request $request) {
        $validated = $request->validate([
            'current_password' => ['required', 'current_password'],
            'new_password' => ['required', 'min:8', 'confirmed'],
        ]);

        $request->user()->update([
            'password' => Hash::make($validated['new_password']),
        ]);

        return response()->json(['message' => 'Password changed successfully'], 200);
    })->name('adviser.change-password');
});

// ========== CSG OFFICER ROUTES (Only accessible by CSG Officer role) ==========
Route::middleware(['auth', 'verified', 'role:csg'])->group(function () {
    Route::get('/csg', [CSGDashboardController::class, 'index'])->name('csg.dashboard');
    Route::get('/csg/dashboard', [CSGDashboardController::class, 'index'])->name('csg.dashboard.alias');

    // Projects Management
    Route::get('/csg/projects/{projectId?}', function ($projectId = null) {
        return Inertia::render('CSG/Projects', [
            'selectedProjectId' => $projectId
        ]);
    })->name('csg.projects');
    Route::post('/csg/projects', [CSGProjectController::class, 'store'])->name('csg.projects.store');
    Route::patch('/csg/projects/{id}', [CSGProjectController::class, 'update'])->name('csg.projects.update');
    Route::delete('/csg/projects/{id}', [CSGProjectController::class, 'destroy'])->name('csg.projects.destroy');
    Route::post('/csg/projects/{projectId}/ledger', [CSGProjectController::class, 'storeLedger'])->name('csg.projects.ledger.store');
    Route::patch('/csg/projects/{projectId}/ledger/{ledgerId}', [CSGProjectController::class, 'updateLedger'])->name('csg.projects.ledger.update');
    Route::delete('/csg/projects/{projectId}/ledger/{ledgerId}', [CSGProjectController::class, 'destroyLedger'])->name('csg.projects.ledger.destroy');

    // Ledger & Proof
    Route::get('/csg/ledger', function () {
        return Inertia::render('CSG/Ledger');
    })->name('csg.ledger');

    Route::get('/csg/proof', function () {
        return Inertia::render('CSG/Proof', [
            'proofDocuments' => Inertia::defer(fn() => app(\App\Http\Controllers\CSG\LedgerEntryController::class)->getProofDocuments()->getData()),
            'projects' => Inertia::defer(fn() => \App\Models\CSG\Project::where('archive', 0)->pluck('title')->toArray()),
            'transactions' => Inertia::defer(fn() => \App\Models\CSG\LedgerEntry::where('archive', 0)->pluck('id')->toArray()),
        ]);
    })->name('csg.proof');

    // Meetings & Ratings
    Route::get('/csg/meetings', function () {
        return Inertia::render('CSG/Meetings');
    })->name('csg.meetings');

    Route::get('/csg/ratings', [CSGRatingsController::class, 'index'])->name('csg.ratings');
    Route::get('/api/csg/ratings', [CSGRatingsController::class, 'getRatingsData'])->name('api.csg.ratings');

    // Notifications & Profile
    Route::get('/csg/notification', function () {
        return Inertia::render('CSG/Notification');
    })->name('csg.notification');

    Route::get('/csg/profile', function (Request $request) {
        return Inertia::render('CSG/Profile', [
            'user' => $request->user(),
        ]);
    })->name('csg.profile');

    Route::post('/csg/change-password', function (Request $request) {
        $validated = $request->validate([
            'current_password' => ['required', 'current_password'],
            'new_password' => ['required', 'min:8', 'confirmed'],
        ]);

        $request->user()->update([
            'password' => Hash::make($validated['new_password']),
        ]);

        return response()->json(['message' => 'Password changed successfully'], 200);
    })->name('csg.change-password');
});

// ========== STUDENT USER ROUTES (Only accessible by Student & Teacher roles) ==========
Route::middleware(['auth', 'verified', 'role:student,teacher'])->group(function () {
    Route::get('/user', [UserProjectController::class, 'dashboard'])->name('user.dashboard');
    Route::get('/user/dashboard', [UserProjectController::class, 'dashboard'])->name('user.dashboard.alias');

    // Projects
    Route::get('/user/projects', [UserProjectController::class, 'index'])->name('user.projects');
    Route::get('/user/projects/{id}', [UserProjectController::class, 'show'])->name('user.project-details');
    Route::post('/user/projects/{id}/ratings', [UserProjectController::class, 'upsertRating'])->name('user.project-rate');

    // Meetings & Events
    Route::get('/user/meetings', [UserProjectController::class, 'meetings'])->name('user.meetings');

    // Profile & Points
    Route::get('/user/profile', [UserProjectController::class, 'profile'])->name('user.profile');
    Route::get('/user/points', [UserProjectController::class, 'points'])->name('user.points');

    // Gamification
    Route::get('/user/badges', [UserProjectController::class, 'badges'])->name('user.badges');
    Route::get('/user/leaderboard', [UserProjectController::class, 'leaderboard'])->name('user.leaderboard');

    // Notifications
    Route::get('/user/notifications', [UserProjectController::class, 'notifications'])->name('user.notifications');
});


// ==================== API ROUTES ====================
Route::prefix('api')->group(function () {
    // Project Management Routes
    Route::prefix('projects')->group(function () {
        Route::get('/', [ProjectController::class, 'index']);
        Route::post('/', [ProjectController::class, 'store']);
        Route::get('/{id}', [ProjectController::class, 'show']);
        Route::put('/{id}', [ProjectController::class, 'update']);
        Route::delete('/{id}', [ProjectController::class, 'destroy']);
        Route::post('/{id}/archive', [ProjectController::class, 'archive']);
        Route::post('/{id}/submit', [ProjectController::class, 'submitForApproval']);
        Route::get('/{id}/ledger', [ProjectController::class, 'ledgerEntries']);
        Route::get('/{id}/ratings', [ProjectController::class, 'getRatings']);
        Route::get('/{id}/file', [ProjectController::class, 'getFile']);
        Route::delete('/{id}/file', [ProjectController::class, 'deleteFile']);
    });
    
    // Ledger Entry Management Routes
    Route::prefix('ledger-entries')->group(function () {
        Route::get('/', [LedgerEntryController::class, 'all']);
        Route::get('/project/{projectId}', [LedgerEntryController::class, 'index']);
        Route::get('/proof-documents', [LedgerEntryController::class, 'getProofDocuments']);
        Route::post('/', [LedgerEntryController::class, 'store']);
        Route::put('/{id}', [LedgerEntryController::class, 'update']);
        Route::delete('/{id}', [LedgerEntryController::class, 'destroy']);
        Route::post('/{id}/submit', [LedgerEntryController::class, 'submitForApproval']);
        Route::post('/{id}/proof', [LedgerEntryController::class, 'uploadProof']);
    });
    
    // Meeting Management Routes
    Route::prefix('meetings')->group(function () {
        Route::get('/', [MeetingController::class, 'all']);
        Route::get('/upcoming/count', [MeetingController::class, 'countUpcoming']);
        Route::get('/upcoming/list', [MeetingController::class, 'getUpcomingMeetings']);
        Route::post('/', [MeetingController::class, 'store']);
        Route::put('/{id}', [MeetingController::class, 'update']);
        Route::delete('/{id}', [MeetingController::class, 'destroy']);
        Route::post('/{id}/mark-as-done', [MeetingController::class, 'markAsDone']);
        Route::post('/{id}/archive', [MeetingController::class, 'toggleArchive']);
    });

    Route::get('/projects', [ProjectController::class, 'index']);
});

// Legacy non-api route prefix (for backward compatibility)
Route::prefix('projects')->group(function () {
    Route::get('/', [ProjectController::class, 'index']);
    Route::get('/{id}', [ProjectController::class, 'show']);
    Route::get('/{id}/ledger', [ProjectController::class, 'ledgerEntries']);
    Route::post('/', [ProjectController::class, 'store']);
    Route::put('/{id}', [ProjectController::class, 'update']);
    Route::delete('/{id}', [ProjectController::class, 'destroy']);
    Route::post('/{id}/archive', [ProjectController::class, 'archive']);
    Route::get('/{id}/file', [ProjectController::class, 'getFile']);
    Route::delete('/{id}/file', [ProjectController::class, 'deleteFile']);
});

// Auth routes


// Route::post('/sadmin/notifications/read/{id}', function ($id) {
//     Notification::where('id', $id)->update(['is_read' => 1, 'read_at' => now()]);
//     return back();
// });

// Route::post('/sadmin/notifications/archive/{id}', function ($id) {
//     Notification::where('id', $id)->update(['archive' => 1]);
//     return back();
// });

// Route::post('/sadmin/notifications/mark-all-read', function () {
//     Notification::where('user_id', auth()->id())->update(['is_read' => 1, 'read_at' => now()]);
//     return back();
// });
Route::middleware('auth')->group(function () {
    Route::post('/sadmin/notifications/read/{id}', function ($id) {
        // Use the Model to ensure string ID handling
        \App\Models\Notification::where('id', $id)->update([
            'is_read' => 1, 
            'read_at' => now()
        ]);
        return back();
    });

    Route::post('/sadmin/notifications/archive/{id}', function ($id) {
        \App\Models\Notification::where('id', $id)->update(['archive' => 1]);
        return back();
    });

    Route::post('/sadmin/notifications/mark-all-read', function () {
        \App\Models\Notification::where('user_id', Auth::id())
            ->where('is_read', 0)
            ->update(['is_read' => 1, 'read_at' => now()]);
        return back();
    });

    // Student notification read/unread (mark as read)
    Route::post('/user/notifications/read/{id}', function ($id) {
        \App\Models\Notification::where('id', $id)
            ->where(function ($q) {
                $q->where('user_id', Auth::id())->orWhereNull('user_id');
            })
            ->where('archive', 0)
            ->update([
                'is_read' => 1,
                'read_at' => now(),
            ]);

        return back();
    });

    Route::post('/user/notifications/mark-all-read', function () {
        \App\Models\Notification::where('archive', 0)
            ->where(function ($q) {
                $q->where('user_id', Auth::id())->orWhereNull('user_id');
            })
            ->where('is_read', 0)
            ->update([
                'is_read' => 1,
                'read_at' => now(),
            ]);

        return back();
    });
});

// Route::middleware('auth')->group(function () {
//     Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
//     Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
//      Route::patch('/profile/phone', [ProfileController::class, 'updatePhone'])->name('profile.phone.update'); // Add this line
//     Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
// Route::put('password', [PasswordController::class, 'update'])->name('password.update');});

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::patch('/profile/phone', [ProfileController::class, 'updatePhone'])->name('profile.phone.update'); // Add this line
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::put('password', [PasswordController::class, 'update'])->name('password.update');
});

// Secret superadmin login route (Easter egg)
Route::middleware('guest')->group(function () {
    Route::get('sadmin/login', function () {
        return Inertia::render('Auth/SuperAdminLogin');
    })->name('sadmin.login');
});

require __DIR__.'/auth.php';

// Logout route
Route::post('/logout', function () {
    auth()->guard()->logout();
    return redirect('/');
})->name('logout');
