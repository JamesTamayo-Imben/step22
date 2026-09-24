export function computeBudgetFromEntries(entries) {
  return (entries || []).reduce((sum, entry) => {
    const amount = Number(entry?.amount) || 0;
    const type = String(entry?.transactionType || entry?.type || '').toLowerCase();

    const isCredit = type.includes('initial')
      || ['income', 'donation', 'sponsorship'].includes(type);
    const isDebit = ['expense', 'asset'].includes(type)
      || (type.includes('transfer') && !type.includes('initial'));

    if (isCredit) return sum + amount;
    if (isDebit) return sum - amount;
    return sum;
  }, 0);
}

export function computeOrgBudgetFromLedger(entries) {
  return Math.max(0, computeOrgRawBalanceFromLedger(entries));
}

// The negative portion of the org-wide balance — i.e. how much more funding
// is needed to cover approved expenses across all projects. This is 0 when
// the org is not in deficit. Kept separate from computeOrgBudgetFromLedger so
// a shortfall never silently disappears from the dashboard — it should be
// shown as its own figure, not folded into (or hidden from) the total.
export function computeOrgShortfallFromLedger(entries) {
  return Math.max(0, -computeOrgRawBalanceFromLedger(entries));
}

function computeOrgRawBalanceFromLedger(entries) {
  const approved = (entries || []).filter(
    (entry) => (entry?.status === 'Approved' || entry?.approval_status === 'Approved') && !entry?.archive
  );

  const byProject = new Map();
  for (const entry of approved) {
    const projectId = String(entry?.projectId || entry?.project_id || '');
    if (!projectId) continue;

    if (!byProject.has(projectId)) {
      byProject.set(projectId, []);
    }
    byProject.get(projectId).push(entry);
  }

  let total = 0;
  for (const projectEntries of byProject.values()) {
    // Sum raw per-project balances (can be negative) so donations against a
    // deficit and offsetting positive balances on other projects both stay
    // visible in the running total.
    total += computeBudgetFromEntries(projectEntries);
  }

  return total;
}

export function projectBudgetMismatch(storedBudget, computedBudget, hasApprovedEntries = true) {
  if (!hasApprovedEntries) {
    return false;
  }

  return Math.abs(Number(storedBudget) - Number(computedBudget)) > 0.01;
}