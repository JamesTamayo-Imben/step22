**Role-based Dashboard Redirect Flow**

This document explains how users are redirected to their respective dashboards based on roles in this project, points to the exact files/parts involved, and suggests a practical approach to implement a "switch account / role mode" feature.

**1. Server-side dashboard redirect**
- File: `routes/web.php`
- Part: the `Route::get('/dashboard', function (Request $request) { ... })` handler near the top of the file.
- Behavior: server reads the authenticated user's role (`$request->user()->role->slug`) and uses a `match` to redirect to the proper route:
  - `superadmin` -> `route('sadmin.dashboard')` (`/sadmin`)
  - `admin`, `admin-sadu` -> `route('adviser.dashboard')` (`/adviser`)
  - `csg` -> `route('csg.dashboard')` (`/csg`)
  - `student`, `teacher` -> `route('user.dashboard')` (`/user`)
  - default -> render Inertia `Dashboard` page

**2. Client-side redirect during registration/login**
- File: `resources/js/hooks/useRegistrationFlow.js`
- Part: `redirectToDashboard(user)` function inside the hook
- Behavior: called after OTP verification or profile completion, it checks `user?.role?.name` and uses `window.location.href` to navigate, e.g. currently:
  - `student` -> `/dashboard/student`
  - `teacher` -> `/dashboard/adviser`
  - fallback -> `/user`
- Note: this mapping differs from server `/dashboard` mapping — align them to avoid confusion.

**3. Layout / UI wiring for correct dashboard**
- File: `resources/js/Layouts/AuthenticatedLayout.jsx`
- Part: the conditional sidebar render logic at the top of the component
- Behavior: the layout chooses which sidebar to render based on `window.location.pathname` prefix (`/adviser`, `/sadmin`, `/csg`) so the correct dashboard URL must be used for the correct sidebar to appear.

**4. Switch-account button (client UI)**
- File: `resources/js/Components/StudentNavbar.jsx`
- Part: profile dropdown & mobile drawer sections that render `Switch to Officer Mode` button
- Behavior: the button is shown only when `onSwitchRole` prop is provided and `userData?.canSwitch` is true; currently it just calls `onSwitchRole()` — the actual switching logic must be implemented in the parent.

**Recommended approach to implement "Switch Account / Role Mode"**

- Decision: determine whether "switch" means:
  1. The same authenticated user has multiple roles (e.g., Student + Officer), and you change the active role/mode; or
  2. The user temporarily impersonates or toggles to another related role (requires strict authorization checks).

- Backend endpoint (example)
  - `POST /switch-role`
  - Payload: `{ role: 'csg' }`
  - Server action:
    1. Validate user has permission to switch to `role` (check assigned roles or canSwitch flag).
    2. Save the chosen active role in session (e.g., `session(['active_role' => $role])`) or return an allowed dashboard URL in response.
    3. Return success and optionally the new dashboard path in JSON: `{ success: true, redirect: '/csg' }`.

- Frontend wiring (parent of `StudentNavbar`)
  - Implement `onSwitchRole = (role) => { router.post('/switch-role', { role }, { onSuccess: () => router.visit(roleToPath(role)) }) }`.
  - `roleToPath(role)` should use the same centralized mapping used by `routes/web.php` to avoid duplication.

- Centralize role->dashboard mapping
  - Example mapping object (JS / PHP must share the same logic conceptually):

```js
const ROLE_TO_PATH = {
  superadmin: '/sadmin',
  admin: '/adviser',
  'admin-sadu': '/adviser',
  csg: '/csg',
  student: '/user',
  teacher: '/user',
};
```

- Middleware / UI consistency
  - Keep server route middleware (`role:`) and front-end checks aligned; after switching, visit the new dashboard path so `AuthenticatedLayout` picks the right sidebar.

**Small example: backend controller stub (Laravel)**

```php
// app/Http/Controllers/AccountSwitchController.php
public function switchRole(Request $request)
{
    $request->validate(['role' => 'required|string']);
    $user = $request->user();

    // Example check: user must have assigned role or canSwitch flag
    if (! $user->canSwitchTo($request->role)) {
        return response()->json(['error' => 'Not allowed'], 403);
    }

    session(['active_role' => $request->role]);

    $path = match ($request->role) {
        'superadmin' => route('sadmin.dashboard', false),
        'admin', 'admin-sadu' => route('adviser.dashboard', false),
        'csg' => route('csg.dashboard', false),
        'student', 'teacher' => route('user.dashboard', false),
        default => route('user.dashboard', false),
    };

    return response()->json(['redirect' => $path]);
}
```

**Small example: frontend parent handler**

```js
// Parent component that renders StudentNavbar
import { router } from '@inertiajs/react';
const roleToPath = (r) => ({
  superadmin: '/sadmin',
  admin: '/adviser',
  'admin-sadu': '/adviser',
  csg: '/csg',
  student: '/user',
  teacher: '/user',
}[r] || '/user');

function handleSwitchRole(role) {
  router.post('/switch-role', { role }, {
    onSuccess: (page) => {
      const redirect = page.props?.redirect || roleToPath(role);
      router.visit(redirect);
    },
  });
}
```

**Notes & recommendations**
- Keep role->path mapping centralized (single source of truth) to avoid mismatches like those observed between `useRegistrationFlow.js` and `routes/web.php`.
- Prefer server-side session for active role (so middleware can respect it), combined with a short JSON response for smooth client navigation.
- Ensure strict authorization checks server-side (never trust client-sent role values without validation).

---

If you'd like, I can:
- create this file for you (I already did: `ROLE_DASHBOARD_FLOW.md`),
- add a `POST /switch-role` route and controller stub in `routes/web.php` and `app/Http/Controllers/AccountSwitchController.php`, and
- wire `onSwitchRole` into the existing navbar parent component.

Tell me which of those you'd like me to implement next.