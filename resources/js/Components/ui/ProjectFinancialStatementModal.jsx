import { createPortal } from 'react-dom';

const formatCurrency = (value) => {
  const amount = Number(value ?? 0);
  return new Intl.NumberFormat('en-PH', {
    style: 'currency',
    currency: 'PHP',
    maximumFractionDigits: 0,
  }).format(amount);
};

const formatDate = (value) => {
  if (!value) return '—';

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return value;

  return date.toLocaleDateString('en-PH', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

const normalizeStatus = (entry) => String(entry?.approval_status ?? entry?.approvalStatus ?? entry?.status ?? '').trim();
const normalizeType = (entry) => String(entry?.type ?? entry?.transactionType ?? 'Expense').trim();

function getTypeBadgeColor(type) {
  switch (type) {
    case 'Expense': return 'bg-red-100 text-red-700';
    case 'Income': return 'bg-green-100 text-green-700';
    case 'Initial':
    case 'Initial Transfer': return 'bg-indigo-100 text-indigo-700';
    case 'Transfer': return 'bg-yellow-100 text-yellow-700';
    case 'Donation': return 'bg-blue-100 text-blue-700';
    case 'Sponsorship': return 'bg-purple-100 text-purple-700';
    case 'Canvas': return 'bg-gray-100 text-gray-700';
    default: return 'bg-gray-100 text-gray-700';
  }
}

function parseBudgetBreakdown(budgetBreakdown) {
  if (!budgetBreakdown) return [];

  if (Array.isArray(budgetBreakdown)) return budgetBreakdown;

  if (typeof budgetBreakdown === 'string') {
    try {
      const parsed = JSON.parse(budgetBreakdown);
      return Array.isArray(parsed) ? parsed : [];
    } catch (error) {
      return [];
    }
  }

  if (typeof budgetBreakdown === 'object') {
    if (Array.isArray(budgetBreakdown.items)) return budgetBreakdown.items;
    if (budgetBreakdown.item || budgetBreakdown.name) return [budgetBreakdown];
  }

  return [];
}

function getBreakdownItems(entry) {
  const items = parseBudgetBreakdown(entry?.budget_breakdown ?? entry?.budgetBreakdown ?? entry?.budget_breakdown_json ?? entry?.breakdown ?? []);

  return items.map((item, index) => {
    const name = item.item || item.name || item.category || item.label || `Item ${index + 1}`;
    const qty = Number(item.qty ?? item.quantity ?? 1) || 1;
    const unitPrice = Number(item.unitPrice ?? item.unit_price ?? item.rate ?? item.price ?? 0) || 0;
    const amount = Number(item.amount ?? item.value ?? qty * unitPrice ?? 0) || 0;

    return {
      name,
      amount,
      qty,
      unitPrice,
    };
  });
}

function toAscii(value) {
  return String(value ?? '')
    .normalize('NFKD')
    .replace(/[^\x20-\x7E]/g, '');
}

function wrapText(value, width) {
  const words = toAscii(value).split(/\s+/).filter(Boolean);
  const lines = [];
  let line = '';

  words.forEach((word) => {
    if (word.length > width) {
      if (line) lines.push(line);
      line = '';
      for (let index = 0; index < word.length; index += width) {
        lines.push(word.slice(index, index + width));
      }
      return;
    }

    if (line && `${line} ${word}`.length > width) {
      lines.push(line);
      line = word;
    } else {
      line = line ? `${line} ${word}` : word;
    }
  });

  if (line) lines.push(line);
  return lines.length ? lines : [''];
}

function buildFinancialStatementPdf(project, groups, totalIncome, totalExpenses, net) {
  const dateWidth = 13;
  const typeWidth = 20;
  const amountWidth = 15;
  const breakdownWidth = 64;
  const formatColumn = (value, width) => toAscii(value).slice(0, width).padEnd(width);
  const header = `${formatColumn('Date', dateWidth)} ${formatColumn('Type', typeWidth)} ${formatColumn('Amount', amountWidth)} Breakdown`;
  const lines = [
    'PROJECT FINANCIAL SUMMARY',
    `Project: ${toAscii(project.title || 'Untitled Project')}`,
    `Approved transaction total: PHP ${entriesTotal(groups).toFixed(2)}`,
    `Approved income: PHP ${totalIncome.toFixed(2)} | Approved expenses: PHP ${totalExpenses.toFixed(2)} | Net: PHP ${net.toFixed(2)}`,
    '',
  ];

  if (!groups.length) {
    lines.push('No approved transactions found for this project.');
  } else {
    groups.forEach(({ type, entries, total }) => {
      lines.push(
        `${type} — Subtotal: PHP ${total.toFixed(2)}`,
        header,
        '-'.repeat(dateWidth + typeWidth + amountWidth + breakdownWidth + 3),
      );
      entries.forEach((entry) => {
        const breakdownItems = getBreakdownItems(entry);
        const breakdownLines = breakdownItems.length
          ? breakdownItems.flatMap((item) => wrapText(`- ${item.name}: PHP ${Number(item.amount || 0).toFixed(2)}`, breakdownWidth))
          : ['No breakdown recorded'];
        const date = formatDate(entry.created_at || entry.createdAt || entry.date);
        const amount = `PHP ${Number(entry.amount || 0).toFixed(2)}`;

        breakdownLines.forEach((breakdownLine, index) => {
          lines.push(
            `${formatColumn(index === 0 ? date : '', dateWidth)} ` +
            `${formatColumn(index === 0 ? type : '', typeWidth)} ` +
            `${formatColumn(index === 0 ? amount : '', amountWidth)} ` +
            breakdownLine,
          );
        });
      });
      lines.push('');
    });
  }

  const pageLines = [];
  for (let index = 0; index < lines.length; index += 58) {
    pageLines.push(lines.slice(index, index + 58));
  }

  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [] /Count 0 >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>',
  ];
  const pageIds = [];

  pageLines.forEach((page) => {
    const contentLines = [
      'BT',
      '/F1 8 Tf',
      '0 g',
      '40 750 Td',
      '11 TL',
      ...page.map((line) => `(${line.replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)')}) Tj T*`),
      'ET',
    ];
    const content = contentLines.join('\n');
    const contentId = objects.push(`<< /Length ${content.length} >>\nstream\n${content}\nendstream`);
    pageIds.push(objects.push(
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 3 0 R >> >> /Contents ${contentId} 0 R >>`,
    ));
  });

  objects[1] = `<< /Type /Pages /Kids [${pageIds.map((id) => `${id} 0 R`).join(' ')}] /Count ${pageIds.length} >>`;

  let pdf = '%PDF-1.4\n';
  const offsets = [0];
  objects.forEach((object, index) => {
    offsets[index + 1] = pdf.length;
    pdf += `${index + 1} 0 obj\n${object}\nendobj\n`;
  });

  const xrefOffset = pdf.length;
  pdf += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`;
  offsets.slice(1).forEach((offset) => {
    pdf += `${String(offset).padStart(10, '0')} 00000 n \n`;
  });
  pdf += `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefOffset}\n%%EOF`;

  return new Blob([pdf], { type: 'application/pdf' });
}

function entriesTotal(groups) {
  return groups.reduce((sum, group) => sum + group.total, 0);
}

export default function ProjectFinancialStatementModal({ project, entries = [], isOpen, onClose }) {
  if (!isOpen || !project) return null;

  const approvedEntries = (entries || []).filter((entry) => {
    const status = normalizeStatus(entry).toLowerCase();
    return status === 'approved';
  });

  const totalIncome = approvedEntries
    .filter((entry) => normalizeType(entry).toLowerCase() === 'income')
    .reduce((sum, entry) => sum + Number(entry.amount || 0), 0);

  const totalExpenses = approvedEntries
    .filter((entry) => normalizeType(entry).toLowerCase() === 'expense')
    .reduce((sum, entry) => sum + Number(entry.amount || 0), 0);

  const net = totalIncome - totalExpenses;
  const transactionGroups = Object.values(approvedEntries.reduce((groups, entry) => {
    const type = normalizeType(entry) || 'Expense';
    if (!groups[type]) groups[type] = { type, entries: [], total: 0 };
    groups[type].entries.push(entry);
    groups[type].total += Number(entry.amount || 0);
    return groups;
  }, {}));
  const approvedTransactionTotal = entriesTotal(transactionGroups);

  const summaryByCategory = approvedEntries.reduce((acc, entry) => {
    const breakdownItems = getBreakdownItems(entry);
    if (!breakdownItems.length) {
      acc.General = (acc.General || 0) + Number(entry.amount || 0);
      return acc;
    }

    breakdownItems.forEach((item) => {
      const category = item.name || 'General';
      acc[category] = (acc[category] || 0) + Number(item.amount || 0);
    });

    return acc;
  }, {});

  const downloadPdf = () => {
    const url = URL.createObjectURL(buildFinancialStatementPdf(project, transactionGroups, totalIncome, totalExpenses, net));
    const link = document.createElement('a');
    const filename = toAscii(project.title || 'project')
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-|-$/g, '') || 'project';

    link.href = url;
    link.download = `${filename}-financial-summary.pdf`;
    document.body.appendChild(link);
    link.click();
    link.remove();
    window.setTimeout(() => URL.revokeObjectURL(url), 1000);
  };

  return createPortal(
    <div className="fixed inset-0 z-[1200] flex items-center justify-center bg-black/60 p-2 sm:p-4" onClick={onClose}>
      <div className="relative flex max-h-[95vh] w-full max-w-6xl flex-col overflow-hidden rounded-2xl bg-white shadow-2xl" onClick={(event) => event.stopPropagation()}>
        <div className="flex shrink-0 flex-col gap-3 border-b border-gray-200 px-4 py-4 sm:flex-row sm:items-center sm:justify-between sm:px-5">
          <div className="min-w-0">
            <p className="text-xs font-semibold uppercase tracking-[0.2em] text-blue-600">Project Financial Summary</p>
            <h2 className="mt-1 break-words text-lg font-bold text-gray-900 sm:text-xl">{project.title || 'Project Financial Summary'}</h2>
          </div>
        </div>

        <div className="min-h-0 flex-1 overflow-y-auto p-3 sm:p-6">
            <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
              <div className="rounded-xl border border-gray-200 bg-gray-50 p-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-gray-500">Project Budget</p>
                <p className="mt-2 text-2xl font-bold text-gray-900">{formatCurrency(project.budget ?? project.total_budget ?? 0)}</p>
              </div>
              <div className="rounded-xl border border-gray-200 bg-green-50 p-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-green-700">Approved Income</p>
                <p className="mt-2 text-2xl font-bold text-green-700">{formatCurrency(totalIncome)}</p>
              </div>
              <div className="rounded-xl border border-gray-200 bg-red-50 p-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-red-700">Approved Expense</p>
                <p className="mt-2 text-2xl font-bold text-red-700">{formatCurrency(totalExpenses)}</p>
              </div>
              <div className="rounded-xl border border-gray-200 bg-blue-50 p-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-blue-700">Net</p>
                <p className={`mt-2 text-2xl font-bold ${net >= 0 ? 'text-blue-700' : 'text-red-700'}`}>{formatCurrency(net)}</p>
              </div>
              <div className="rounded-xl border border-gray-200 bg-slate-50 p-4 sm:col-span-2 xl:col-span-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-gray-500">Total Approved Transactions</p>
                <p className="mt-2 text-2xl font-bold text-gray-900">{formatCurrency(approvedTransactionTotal)}</p>
              </div>
            </div>

            <div className="mt-6 hidden overflow-hidden rounded-xl border border-gray-200 lg:block">
              <div className="overflow-x-auto">
                <table className="w-full min-w-[900px] text-left text-sm">
                  <thead className="bg-slate-100">
                    <tr>
                      <th className="w-36 whitespace-nowrap px-4 py-3 font-semibold text-gray-700">Date</th>
                      <th className="w-36 whitespace-nowrap px-4 py-3 font-semibold text-gray-700">Type</th>
                      <th className="px-4 py-3 font-semibold text-gray-700">Description</th>
                      <th className="px-4 py-3 font-semibold text-gray-700">Amount</th>
                      <th className="px-4 py-3 font-semibold text-gray-700">Budget Breakdown</th>
                    </tr>
                  </thead>
                  <tbody>
                    {transactionGroups.length ? transactionGroups.flatMap(({ type: groupType, entries: groupEntries, total }) => [
                      <tr key={`group-${groupType}`} className="border-t-2 border-slate-300 bg-slate-50">
                        <th colSpan="5" className="px-4 py-2 text-left font-semibold text-gray-900">
                          {groupType} — Subtotal: {formatCurrency(total)}
                        </th>
                      </tr>,
                      ...groupEntries.map((entry) => {
                      const breakdownItems = getBreakdownItems(entry);
                      const type = normalizeType(entry);

                      return (
                        <tr key={entry.id || `${entry.description}-${entry.amount}-${entry.created_at}`} className="border-t border-gray-200 align-top">
                          <td className="whitespace-nowrap px-4 py-3 text-gray-600">{formatDate(entry.created_at || entry.createdAt || entry.date)}</td>
                          <td className="px-4 py-3">
                            <span className={`inline-flex whitespace-nowrap rounded-full px-2.5 py-1 text-xs font-semibold ${getTypeBadgeColor(type)}`}>
                              {type || 'Expense'}
                            </span>
                          </td>
                          <td className="px-4 py-3 text-gray-800">{entry.description || entry.note || 'No description provided'}</td>
                          <td className={`px-4 py-3 font-semibold ${type.toLowerCase() === 'income' ? 'text-green-700' : 'text-red-700'}`}>
                            {formatCurrency(entry.amount || 0)}
                          </td>
                          <td className="px-4 py-3">
                            {breakdownItems.length ? (
                              <div className="space-y-1">
                                {breakdownItems.map((item, index) => (
                                  <div key={`${item.name}-${index}`} className="flex justify-between gap-3 text-xs text-gray-700">
                                    <span>{item.name}</span>
                                    <span className="font-medium">{formatCurrency(item.amount)}</span>
                                  </div>
                                ))}
                              </div>
                            ) : (
                              <span className="text-xs text-gray-500">No breakdown recorded</span>
                            )}
                          </td>
                        </tr>
                      );
                    }),
                    ]) : (
                      <tr>
                        <td className="px-4 py-6 text-center text-gray-500" colSpan="5">
                          No approved transactions found for this project.
                        </td>
                      </tr>
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            <div className="mt-6 space-y-4 lg:hidden">
              {transactionGroups.length ? transactionGroups.map(({ type: groupType, entries: groupEntries, total }) => (
                <section key={`mobile-group-${groupType}`} className="space-y-3">
                  <h3 className="rounded-lg bg-slate-100 px-3 py-2 text-sm font-semibold text-gray-900">
                    {groupType} — Subtotal: {formatCurrency(total)}
                  </h3>
                  {groupEntries.map((entry) => {
                    const breakdownItems = getBreakdownItems(entry);
                    const type = normalizeType(entry);

                    return (
                      <article key={entry.id || `${entry.description}-${entry.amount}-${entry.created_at}`} className="min-w-0 rounded-xl border border-gray-200 p-3">
                        <div className="flex flex-wrap items-center justify-between gap-2">
                          <time className="text-sm font-medium text-gray-600">
                            {formatDate(entry.created_at || entry.createdAt || entry.date)}
                          </time>
                          <span className={`inline-flex max-w-full whitespace-normal break-words rounded-full px-2.5 py-1 text-xs font-semibold ${getTypeBadgeColor(type)}`}>
                            {type || 'Expense'}
                          </span>
                        </div>
                        <p className="mt-3 break-words text-sm text-gray-800">{entry.description || entry.note || 'No description provided'}</p>
                        <p className={`mt-2 font-semibold ${type.toLowerCase() === 'income' ? 'text-green-700' : 'text-red-700'}`}>
                          {formatCurrency(entry.amount || 0)}
                        </p>
                        <div className="mt-3 border-t border-gray-100 pt-3">
                          <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-gray-500">Budget Breakdown</p>
                          {breakdownItems.length ? (
                            <div className="space-y-2">
                              {breakdownItems.map((item, index) => (
                                <div key={`${item.name}-${index}`} className="flex min-w-0 items-start justify-between gap-3 text-xs text-gray-700">
                                  <span className="min-w-0 break-words">{item.name}</span>
                                  <span className="shrink-0 font-medium">{formatCurrency(item.amount)}</span>
                                </div>
                              ))}
                            </div>
                          ) : (
                            <span className="text-xs text-gray-500">No breakdown recorded</span>
                          )}
                        </div>
                      </article>
                    );
                  })}
                </section>
              )) : (
                <p className="rounded-xl border border-gray-200 px-4 py-6 text-center text-sm text-gray-500">
                  No approved transactions found for this project.
                </p>
              )}
            </div>

            <div className="mt-6 grid gap-4 lg:grid-cols-2">
              <div className="rounded-xl border border-gray-200 bg-slate-50 p-4">
                <h3 className="text-sm font-semibold uppercase tracking-wide text-gray-700">Budget Breakdown Summary</h3>
                <div className="mt-3 space-y-2">
                  {Object.entries(summaryByCategory).length ? Object.entries(summaryByCategory).map(([category, value]) => (
                    <div key={category} className="flex items-center justify-between gap-3 text-sm text-gray-700">
                      <span>{category}</span>
                      <span className="font-semibold">{formatCurrency(value)}</span>
                    </div>
                  )) : (
                    <p className="text-sm text-gray-500">No budget breakdown details available.</p>
                  )}
                </div>
              </div>

              <div className="rounded-xl border border-gray-200 bg-slate-50 p-4">
                <h3 className="text-sm font-semibold uppercase tracking-wide text-gray-700">Project Summary</h3>
                <div className="mt-3 space-y-2 text-sm text-gray-700">
                  <div className="flex items-center justify-between">
                    <span>Approved transactions</span>
                    <span className="font-semibold">{approvedEntries.length}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Total approved transaction amounts</span>
                    <span className="font-semibold">{formatCurrency(approvedTransactionTotal)}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Project budget</span>
                    <span className="font-semibold">{formatCurrency(project.budget ?? project.total_budget ?? 0)}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Approved income</span>
                    <span className="font-semibold text-green-700">{formatCurrency(totalIncome)}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Approved expenses</span>
                    <span className="font-semibold text-red-700">{formatCurrency(totalExpenses)}</span>
                  </div>
                  <div className="flex items-center justify-between border-t border-gray-200 pt-2">
                    <span>Net (income minus expenses)</span>
                    <span className={`font-bold ${net >= 0 ? 'text-blue-700' : 'text-red-700'}`}>{formatCurrency(net)}</span>
                  </div>
                </div>
              </div>

            </div>
        </div>

        <div className="z-10 flex shrink-0 flex-col gap-2 border-t border-gray-200 bg-white/95 px-4 py-3 backdrop-blur sm:flex-row sm:justify-end sm:px-6">
            <button
              type="button"
              onClick={onClose}
              className="w-full rounded-xl border border-gray-300 px-4 py-3 text-sm font-medium text-gray-700 hover:bg-gray-50 sm:w-auto"
            >
              Close
            </button>
            <button
              type="button"
              onClick={downloadPdf}
              className="w-full rounded-xl bg-blue-600 px-4 py-3 text-sm font-semibold text-white shadow-md hover:bg-blue-700 sm:w-auto"
            >
              Download PDF
            </button>
        </div>
      </div>
    </div>,
    document.body,
  );
}
