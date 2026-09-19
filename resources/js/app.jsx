// ./resources/js/app.jsx
import '../css/app.css';
import './bootstrap';

import { createInertiaApp } from '@inertiajs/react';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createRoot } from 'react-dom/client';
import { useEffect, useState } from 'react';
import { router } from '@inertiajs/react';
import { SupabaseProvider } from './context/SupabaseContext';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

function RoleChangePrompt({ children }) {
    const [roleChanged, setRoleChanged] = useState(false);

    useEffect(() => {
        const rememberRole = (page) => {
            const user = page?.props?.auth?.user;
            const role = user?.role?.slug;

            if (!user?.id || !role) return;

            const storageKey = `step-user-role-${user.id}`;
            const previousRole = window.sessionStorage.getItem(storageKey);

            if (previousRole && previousRole !== role) {
                setRoleChanged(true);
            }

            window.sessionStorage.setItem(storageKey, role);
        };

        rememberRole(router.page);

        const removeListener = router.on('success', (event) => {
            rememberRole(event.detail.page);
        });

        let isMounted = true;
        const checkCurrentRole = async () => {
            try {
                const response = await fetch('/auth/current-role', {
                    credentials: 'same-origin',
                    headers: {
                        Accept: 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                    },
                    cache: 'no-store',
                });

                if (!response.ok || !isMounted) return;

                const data = await response.json();
                const user = router.page?.props?.auth?.user;
                const currentRole = data?.role;

                if (!user?.id || !currentRole) return;

                const storageKey = `step-user-role-${user.id}`;
                const previousRole = window.sessionStorage.getItem(storageKey);

                if (previousRole && previousRole !== currentRole) {
                    setRoleChanged(true);
                }

                window.sessionStorage.setItem(storageKey, currentRole);
            } catch {
                // Role polling is best effort and should not interrupt the app.
            }
        };

        const roleCheckInterval = window.setInterval(checkCurrentRole, 5000);

        return () => {
            isMounted = false;
            window.clearInterval(roleCheckInterval);
            removeListener();
        };
    }, []);

    return (
        <>
            {children}
            {roleChanged && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/50 px-4">
                    <div
                        role="alertdialog"
                        aria-modal="true"
                        aria-labelledby="role-change-title"
                        aria-describedby="role-change-description"
                        className="w-full max-w-md rounded-xl bg-white p-6 shadow-2xl"
                    >
                        <h2 id="role-change-title" className="text-lg font-semibold text-gray-900">
                            Your role has changed
                        </h2>
                        <p id="role-change-description" className="mt-2 text-sm text-gray-600">
                            Please reload the page to open the correct dashboard and prevent errors.
                        </p>
                        <button
                            type="button"
                            onClick={() => window.location.reload()}
                            className="mt-5 w-full rounded-lg bg-blue-600 px-4 py-2.5 text-sm font-medium text-white transition hover:bg-blue-700"
                        >
                            Reload page
                        </button>
                    </div>
                </div>
            )}
        </>
    );
}

createInertiaApp({
    title: (title) => (title ? `${title} - ${appName}` : appName),
    resolve: (name) =>
        resolvePageComponent(
            `./Pages/${name}.jsx`,
            import.meta.glob('./Pages/**/*.jsx')
        ),
    setup({ el, App, props }) {
        const root = createRoot(el);
        root.render(
            <SupabaseProvider>
                <RoleChangePrompt>
                    <App {...props} />
                </RoleChangePrompt>
            </SupabaseProvider>
        );
    },
});