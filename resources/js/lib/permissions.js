/**
 * Check auth.permissions shared via Inertia for a module.action slug.
 * @param {string[]|undefined|null} permissions
 * @param {string} slug e.g. 'projects.create'
 */
export function canPermission(permissions, slug) {
  if (!Array.isArray(permissions) || !slug) return false;
  return permissions.includes(slug);
}

export function useCanPermission(slug) {
  // Lightweight helper for pages that already call usePage()
  return (permissions) => canPermission(permissions, slug);
}
