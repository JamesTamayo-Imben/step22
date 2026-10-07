# Institute Student Government and Scoped Roles

## Purpose

Define the intended role and data boundaries for the Central Student Government
(CSG), SADU, and each institute's student government (SG) before implementation.
This document describes the target behavior; it does not claim that institute
SG support is already implemented.

## Intended hierarchy

- **Super Admin** manages system-wide setup and assignments. They can assign the
  SADU adviser and an SG adviser for each registered institute.
- **SADU adviser** has SADU-scoped access and can oversee the institute SG
  structure, according to permissions granted by the Super Admin.
- **CSG adviser and CSG council** have CSG-scoped access.
- **Institute SG adviser** can manage their own institute's SG membership,
  positions, and council roles, but cannot manage another institute's SG or
  CSG.
- **Institute SG council members** receive permissions for their own institute
  and their assigned position.
- All roles use the same application UI. The active role and organization scope
  determine which records and actions are visible and permitted.

The system should not create a separate copy of the application or hard-coded
role set for every institute. A user should be associated with an organization
scope and role; a user's access to an institute must not be inferred only from
what the frontend chooses to display.

## Institute list and number of SGs

The registered institute records in the `institute` table are the source of
truth for which institute SGs exist. The institute SG list must be queried from
the database, not hard-coded or maintained as a separate count.

- One non-archived institute record corresponds to one institute SG.
- Adding a registered institute makes it appear in the institute SG list.
- Archiving an institute removes it from active assignment choices while
  retaining its historical records.
- The UI should display the actual institute records (and, if useful, a count
  derived from those same records).
- An institute with no assigned adviser or council should still appear with an
  unassigned/empty state.

The seeded institute names in `MasterDataSeeder` are initial master data, not a
runtime limit on how many institute SGs the application can support.

## Position catalog and CSG separation

The existing `position` table is a global catalog: it has a position name but
no institute or organization scope. The seed data includes general council
positions as well as institute representative positions. As a result, it
cannot currently distinguish a CSG position from an institute SG position.

The target design must separate the catalogs:

- CSG-only positions belong to the CSG.
- Institute SG positions belong to exactly one institute and are administered
  for that institute.
- An institute adviser can only assign positions from that institute's
  position list.
- Position permission grants must be scoped consistently with the position
  and organization.
- Moving, removing, or archiving a position must not silently remove or
  reassign existing members; assignments need an explicit, auditable outcome.

**Representative-position decision before migration:** current seed data
contains positions such as `ICDI IS Representative` and `ICDI CS
Representative`. The request says to remove representative positions from the
non-CSG SG position list. Treat these as CSG representation positions, not
ordinary institute SG council positions, and keep them out of institute SG
catalogs. Before deleting or migrating any existing position/assignment rows,
confirm which representative roles are meant and whether existing holders and
history must be retained. Do not destructively delete catalog or assignment
data as part of a simple display change.

## Data model implications

The existing schema provides some useful foundations:

- `institute` holds institute records and an `archive` flag.
- `course` belongs to an institute.
- `teacher_adviser` already has an `institute_id`, suitable for identifying an
  adviser's institute affiliation.
- `position` is currently global and has no organization scope.
- `student_csg_officers` stores `is_csg` and a free-text `csg_position`, but no
  direct institute SG identifier.
- `users` has one `role_id`; it does not currently represent multiple
  organization-scoped memberships.

Implementation should introduce an explicit and enforceable organization scope
for adviser and officer permissions and for positions. A position catalog
should distinguish CSG positions from institute SG positions and associate
each institute position with its institute. Council member assignments should
also identify the institute SG they belong to. Do not rely on a position name,
course name, or client-supplied institute ID alone as the authorization
boundary.

The exact migration strategy (extending existing tables versus adding
membership/assignment tables) should be selected after checking existing
production data and preserving existing CSG assignments. Existing records
must be mapped before adding constraints or removing old fields.

## Authorization requirements

1. Resolve a user's role and organization scope on the server for every
   protected action.
2. A Super Admin can assign the SADU adviser and assign one or more designated
   advisers to each active institute SG.
3. An institute SG adviser can assign/remove members and assign positions only
   within their own institute SG.
4. CSG permissions do not grant institute SG write access, and institute SG
   permissions do not grant CSG write access.
5. SADU cross-institute access must be explicitly granted and limited to the
   intended oversight/administration actions.
6. Validate institute, role, position, and member relationships on the server;
   reject cross-scope IDs even if submitted directly to an endpoint.
7. Record important adviser, member, position, and role assignment changes in
   the audit trail.

## Existing behavior to account for

- Route middleware currently gates broad role slugs, including `superadmin`,
  `admin`/`admin-sadu`, and `csg`.
- `SAdminDashboardController` contains Super Admin assignment flows for CSG
  officers, advisers, and the SADU adviser.
- `RolePermissionService` supports role and CSG-position permission grants;
  those grants will need organization-aware scope for institute SGs.
- The current `assignOfficer` flow finds an existing officer by position name
  globally and updates `student_csg_officers.csg_position` and `is_csg`.
  Institute assignments must not reuse that global lookup behavior.
- There is currently no dedicated institute SG assignment page or adviser
  workflow described by this document.

## Acceptance criteria for implementation

- The institute SG list and its count come from active database institute
  records; there is no fixed institute count or institute-name list in the UI.
- Each active institute can have its own adviser and independently managed
  council membership and positions.
- An adviser for one institute cannot view or change another institute's
  protected SG data by changing a URL, request body, or identifier.
- CSG positions and CSG council membership remain distinct from institute SG
  positions and membership.
- SADU/CSG cross-institute visibility and write privileges follow explicit
  permissions rather than being implied by UI access.
- Existing CSG and representative assignments are migrated or retained
  deliberately, without losing their history.
- Tests cover dynamic institute listing, scoped assignment, unauthorized
  cross-institute access, and separation between CSG and institute positions.
