<?php

namespace App\Services;

use App\Models\Role;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class CsgOnlineStatusService
{
  /**
   * Mark the current session as online (archive = 1).
   */
  public function markOnline(string $sessionId): void
  {
    DB::table('sessions')
      ->where('id', $sessionId)
      ->update(['archive' => 1]);
  }

  /**
   * Mark all sessions for a user as offline (archive = 0).
   */
  public function markOffline(?string $userId): void
  {
    if (!$userId) {
      return;
    }

    DB::table('sessions')
      // ->where('user_id', $userId)
      ->update(['archive' => 0]);
  }

  /**
   * User IDs that currently have an active online session.
   * Requires archive = 1 and recent last_activity to avoid stale sessions.
   */
  public function getOnlineUserIds(): array
  {
    $cutoff = now()->subMinutes((int) config('session.lifetime', 120))->timestamp;

    return DB::table('sessions')
      ->where('archive', 1)
      ->whereNotNull('user_id')
      ->where('last_activity', '>=', $cutoff)
      ->distinct()
      ->pluck('user_id')
      ->all();
  }

  /**
   * All CSG officers with online/offline status for the sidebar indicator.
   *
   * @return array<int, array{id: string, name: string, position: string, avatar: string, archive: int}>
   */
  public function getOfficersStatus(): array
  {
    $csgRoleId = Role::query()->where('slug', 'csg')->value('id');

    if (!$csgRoleId) {
      return [];
    }

    $onlineUserIds = $this->getOnlineUserIds();

    return User::query()
      ->where('role_id', $csgRoleId)
      ->where('archive', false)
      ->with('student')
      ->orderBy('name')
      ->get()
      ->map(function (User $user) use ($onlineUserIds) {
        $isOnline = in_array($user->id, $onlineUserIds, true);

        return [
          'id' => $user->id,
          'name' => $user->name,
          'position' => $user->student?->csg_position ?: 'CSG Officer',
          'avatar' => $this->initials($user->name),
          'archive' => $isOnline ? 1 : 0,
        ];
      })
      ->values()
      ->all();
  }

  private function initials(?string $name): string
  {
    if (!$name) {
      return 'U';
    }

    $parts = preg_split('/\s+/', trim($name)) ?: [];

    return strtoupper(collect($parts)->take(2)->map(fn ($part) => $part[0] ?? '')->join(''));
  }
}
