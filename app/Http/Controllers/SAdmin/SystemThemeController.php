<?php

namespace App\Http\Controllers\SAdmin;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SystemThemeController
{
    public function show(): JsonResponse
    {
        return response()->json([
            'theme' => $this->currentTheme(),
        ]);
    }

    public function update(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'theme' => ['required', 'in:system,kld'],
        ]);

        DB::table('system_settings')->updateOrInsert(
            ['key' => 'color_theme'],
            ['value' => $validated['theme']],
        );

        return back();
    }

    public function currentTheme(): string
    {
        try {
            return DB::table('system_settings')
                ->where('key', 'color_theme')
                ->value('value') === 'kld' ? 'kld' : 'system';
        } catch (\Throwable) {
            // Keep the application available if deployment has not run migrations yet.
            return 'system';
        }
    }
}
