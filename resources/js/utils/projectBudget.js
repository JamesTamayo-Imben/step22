export function computeBudgetFromEntries(entries) {
  return (entries || []).reduce((sum, entry) => {
    const amount = Number(entry?.amount) || 0;
    const type = String(entry?.transactionType || entry?.type || '').toLowerCase();

    const isCredit = type.includes('initial')
      || ['income', 'donation', 'sponsorship'].includes(type);
    const isDebit = type === 'expense'
      || (type.includes('transfer') && !type.includes('initial'));

    if (isCredit) return sum + amount;
    if (isDebit) return sum - amount;
    return sum;
  }, 0);
}

export function computeOrgBudgetFromLedger(entries) {
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
