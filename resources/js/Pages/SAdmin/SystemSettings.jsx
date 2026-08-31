import React, { useRef, useState } from 'react';
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout';
import { Head, usePage } from '@inertiajs/react';
import { Card } from '@/Components/ui/card';
import { Button } from '@/Components/ui/button';
import { showToast } from './components/ui';
import {
  AlertCircle, CheckCircle, ChevronLeft, ChevronRight, Download, Hash, Scan, Search, X,
} from 'lucide-react';

const GENESIS_PAGE_SIZE = 8;
const CHAIN_PAGE_SIZE = 20;

function hasIntegrityIssue(item) {
  return !item.verification?.isValid || item.budgetMismatch;
}

function timeAgo(isoString) {
  const seconds = Math.max(0, Math.floor((Date.now() - new Date(isoString).getTime()) / 1000));
  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes} min ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} hr ago`;
  return new Date(isoString).toLocaleDateString();
}

function formatReportDate(isoString) {
  if (!isoString) return 'Not available';
  const date = new Date(isoString);
  return Number.isNaN(date.getTime()) ? 'Not available' : date.toLocaleString();
}

function buildIncidentReport(chains, detectedAt) {
  const createdAt = new Date().toISOString();
  const affectedChains = chains.filter(hasIntegrityIssue);
  const sections = affectedChains.map((item, index) => {
    const tamperedBlocks = item.verification?.tamperedBlocks || [];
    const affectedBlocks = tamperedBlocks
      .map((issue) => item.chain.find((block) => block.block_index === issue.blockIndex))
      .filter(Boolean);
    const firstAffectedBlock = affectedBlocks[0];
    const issueLines = tamperedBlocks.flatMap((issue) => (
      issue.issues?.map((detail) => `- Block #${issue.blockIndex}: ${detail}`) || []
    ));

    if (item.budgetMismatch) {
      issueLines.push('- Project budget mismatch: stored budget differs from the approved ledger total.');
    }

    return `INCIDENT ${index + 1}
Project Chain Affected: ${item.project.title} (${item.project.id})
Specific Chain Segment: ${affectedBlocks.length ? affectedBlocks.map((block) => `Block #${block.block_index}`).join(', ') : 'Project budget reconciliation'}
Date of Tampering: ${formatReportDate(firstAffectedBlock?.created_at)}
Time of Detection: ${formatReportDate(detectedAt || createdAt)}
Current Status: ${item.verification?.isValid && item.budgetMismatch ? 'Budget mismatch detected' : 'Chain tampering detected'}
Issues Found:
${issueLines.length ? issueLines.join('\n') : '- Integrity discrepancy detected during verification.'}

Impact Assessment
- Project Deliverable: Budget records for this project require review.
- Project Timeline: The integrity of the recorded financial sequence cannot be confirmed until resolved.
- Audit Trail: The chain is no longer self-consistent for the affected segment.
`;
  });

  return `CONFIDENTIAL INCIDENT REPORT
REGARDING CHAIN OF CUSTODY TAMPERING

This report serves to formally notify the committee of a confirmed integrity breach concerning the operational chain of the STEP blockchain. Evidence indicates that unauthorized alterations or budget discrepancies were detected at a specific node within the chain, compromising the validity of the data and audit flow.

Report Created: ${formatReportDate(createdAt)}
Time of Detection: ${formatReportDate(detectedAt || createdAt)}
Total Chains Reviewed: ${chains.length}
Affected Chains: ${affectedChains.length}

${affectedChains.length ? sections.join('\n') : `FINDING
No chain tampering or budget mismatch was detected during this scan.
Current Status: All reviewed chains are self-consistent.
`}
Prepared by: STEP Super Administrator
This document is confidential and intended for committee and authorized audit use only.
`;
}

function PaginationBar({ page, pageCount, onChange, rangeLabel }) {
  if (pageCount <= 1) return null;
  return (
    <div className="flex items-center justify-between gap-3 px-4 sm:px-5 py-3 border-t border-gray-100">
      <span className="text-xs text-gray-500">{rangeLabel}</span>
      <div className="flex items-center gap-1">
        <button
          type="button"
          onClick={() => onChange(page - 1)}
          disabled={page <= 1}
          aria-label="Previous page"
          className="p-1.5 rounded-lg text-gray-500 hover:bg-gray-100 disabled:opacity-40 disabled:hover:bg-transparent focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
        >
          <ChevronLeft className="w-4 h-4" />
        </button>
        <span className="text-xs text-gray-600 tabular-nums px-1 min-w-[5.5rem] text-center">
          Page {page} of {pageCount}
        </span>
        <button
          type="button"
          onClick={() => onChange(page + 1)}
          disabled={page >= pageCount}
          aria-label="Next page"
          className="p-1.5 rounded-lg text-gray-500 hover:bg-gray-100 disabled:opacity-40 disabled:hover:bg-transparent focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
        >
          <ChevronRight className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
}

export default function SystemSettingsPage() {
  const { blockchains = [] } = usePage().props;
  const [selectedId, setSelectedId] = useState(
    (blockchains.find((item) => hasIntegrityIssue(item)) || blockchains[0])?.project.id ?? null,
  );
  const [chains, setChains] = useState(blockchains);
  const [scanning, setScanning] = useState(false);
  const [scannedAt, setScannedAt] = useState(null);
  const [search, setSearch] = useState('');
  const [genesisPage, setGenesisPage] = useState(1);
  const [chainPage, setChainPage] = useState(1);
  const scanButtonRef = useRef(null);
  const detailHeadingRef = useRef(null);
  const announceRef = useRef(null);

  const selected = chains.find((item) => item.project.id === selectedId) || null;

  const selectChain = (item) => {
    setSelectedId(item.project.id);
    setChainPage(1);
    if (announceRef.current) {
      announceRef.current.textContent = `Showing chain for ${item.project.title}`;
    }
  };

  const onSearchChange = (event) => {
    setSearch(event.target.value);
    setGenesisPage(1);
  };

  const scanChain = async () => {
    setScanning(true);
    try {
      const response = await fetch('/sadmin/settings/blockchain/verify', { headers: { Accept: 'application/json' } });
      if (!response.ok) throw new Error('Scan failed');
      const result = await response.json();
      setChains((current) => current.map((chain) => ({
        ...chain,
        ...(result.results.find((item) => item.projectId === chain.project.id) || {}),
      })));
      setScannedAt(result.scannedAt);
      showToast('Chain scan completed', 'success');
    } catch (error) {
      showToast('Unable to scan the chain — check your connection and try again', 'error');
    } finally {
      setScanning(false);
      scanButtonRef.current?.focus();
    }
  };

  const downloadReport = () => {
    const report = buildIncidentReport(chains, scannedAt);
    const url = URL.createObjectURL(new Blob([report], { type: 'text/plain;charset=utf-8' }));
    const link = document.createElement('a');
    link.href = url;
    link.download = `step-confidential-incident-report-${new Date().toISOString().slice(0, 10)}.txt`;
    link.click();
    URL.revokeObjectURL(url);
    showToast('Integrity report downloaded', 'success');
  };

  const totalBlocks = chains.reduce((count, chain) => count + chain.chain.length, 0);
  const compromised = chains.filter(hasIntegrityIssue).length;
  const hasChains = chains.length > 0;

  // --- Genesis block list: search + pagination -----------------------------
  const query = search.trim().toLowerCase();
  const prioritizedChains = [...chains].sort((first, second) => Number(hasIntegrityIssue(second)) - Number(hasIntegrityIssue(first)));
  const filteredChains = query
    ? prioritizedChains.filter((item) => item.project.title.toLowerCase().includes(query)
        || item.genesis?.hash?.toLowerCase().includes(query))
    : prioritizedChains;
  const genesisPageCount = Math.max(1, Math.ceil(filteredChains.length / GENESIS_PAGE_SIZE));
  const safeGenesisPage = Math.min(genesisPage, genesisPageCount);
  const genesisStart = (safeGenesisPage - 1) * GENESIS_PAGE_SIZE;
  const pagedChains = filteredChains.slice(genesisStart, genesisStart + GENESIS_PAGE_SIZE);

  // --- Chain table: pagination, 20 blocks per page --------------------------
  const chainPageCount = selected ? Math.max(1, Math.ceil(selected.chain.length / CHAIN_PAGE_SIZE)) : 1;
  const safeChainPage = Math.min(chainPage, chainPageCount);
  const chainStart = (safeChainPage - 1) * CHAIN_PAGE_SIZE;
  const pagedBlocks = selected ? selected.chain.slice(chainStart, chainStart + CHAIN_PAGE_SIZE) : [];

  return (
    <AuthenticatedLayout header={<h2 className="text-xl font-semibold leading-tight text-gray-800">System Settings</h2>}>
      <Head title="System Settings" />
      <div className="py-8 px-4 lg:px-0 md:px-0">
        <div className="mx-auto max-w-7xl sm:px-6 lg:px-8">
          <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <div>
                <h1 className="text-2xl font-semibold text-gray-900">System blockchain</h1>
                <p className="text-gray-500">Inspect genesis blocks and verify every budget record.</p>
              </div>
              <div className="flex w-full sm:w-auto flex-col sm:flex-row gap-2">
                {/* <Button
                  ref={scanButtonRef}
                  onClick={scanChain}
                  disabled={scanning}
                  aria-busy={scanning}
                  className="rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-60 text-white w-full sm:w-auto"
                >
                  <Scan className={`w-4 h-4 mr-2 ${scanning ? 'animate-spin' : ''}`} />
                  {scanning ? 'Scanning…' : 'Scan chain'}
                </Button> */}
                <Button
                  onClick={downloadReport}
                  disabled={!hasChains}
                  variant="outline"
                  className="rounded-xl bg-blue-600 hover:bg-blue-700 disabled:opacity-60 text-white w-full sm:w-auto"
                >
                  <Download className="w-4 h-4 mr-2" />
                  Download report
                </Button>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <Card className="rounded-[20px] border-0 shadow-sm p-4">
                <p className="text-sm text-gray-500">Projects monitored</p>
                <p className="text-3xl font-semibold text-gray-900 tabular-nums">{chains.length}</p>
              </Card>
              <Card className="rounded-[20px] border-0 shadow-sm p-4">
                <p className="text-sm text-gray-500">Blocks recorded</p>
                <p className="text-3xl font-semibold text-gray-900 tabular-nums">{totalBlocks.toLocaleString()}</p>
              </Card>
              <Card className={`rounded-[20px] border-0 shadow-sm p-4 ${compromised ? 'bg-red-50 border border-red-200' : 'bg-emerald-50'}`}>
                <p className="text-sm text-gray-600">Integrity status</p>
                <p className={`text-3xl font-semibold ${compromised ? 'text-red-700' : 'text-emerald-700 border-emerald-200'}`}>
                  {compromised ? `${compromised} issue${compromised > 1 ? 's' : ''}` : 'Verified'}
                </p>
              </Card>
            </div>

            {/* Visually hidden live region announcing selection changes */}
            <div ref={announceRef} className="sr-only" role="status" aria-live="polite" />

            <div className="grid grid-cols-1 lg:grid-cols-[380px_minmax(0,1fr)] gap-6 items-start">
              {/* Left: genesis block list */}
              <Card className="rounded-[20px] border-0 shadow-sm overflow-hidden">
                <div className="p-5 border-b border-gray-100">
                  <h2 className="text-lg font-semibold text-gray-900">Genesis blocks</h2>
                  <p className="text-sm text-gray-500 mt-1">Select a project to inspect its chain.</p>
                  <div className="relative mt-3">
                    <Search className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" aria-hidden="true" />
                    <input
                      type="text"
                      value={search}
                      onChange={onSearchChange}
                      placeholder="Search by project or hash"
                      aria-label="Search genesis blocks"
                      className="w-full rounded-xl border border-gray-200 bg-gray-50 pl-9 pr-9 py-2 text-sm text-gray-900 placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:bg-white"
                    />
                    {search && (
                      <button
                        type="button"
                        onClick={() => { setSearch(''); setGenesisPage(1); }}
                        aria-label="Clear search"
                        className="absolute right-2 top-1/2 -translate-y-1/2 p-1 rounded-md text-gray-400 hover:text-gray-600 hover:bg-gray-100"
                      >
                        <X className="w-3.5 h-3.5" />
                      </button>
                    )}
                  </div>
                </div>

                {scannedAt && (
                  <div className="px-5 py-2 text-xs text-gray-500 border-b border-gray-100" title={new Date(scannedAt).toLocaleString()}>
                    Scanned {timeAgo(scannedAt)}
                  </div>
                )}

                <div className="divide-y divide-gray-100">
                  {filteredChains.length === 0 && (
                    <div className="p-10 text-center text-gray-500">
                      <Hash className="w-6 h-6 mx-auto mb-2 text-gray-300" />
                      {chains.length === 0
                        ? 'No active project chains found. Run a scan once a project has budget records.'
                        : `No projects match "${search}".`}
                    </div>
                  )}
                  {pagedChains.map((item) => {
                    const valid = item.verification?.isValid;
                    const budgetMismatch = item.budgetMismatch;
                    const integrityIssue = hasIntegrityIssue(item);
                    const isSelected = item.project.id === selectedId;
                    return (
                      <button
                        key={item.project.id}
                        onClick={() => selectChain(item)}
                        aria-current={isSelected}
                        aria-label={`Inspect chain for ${item.project.title}, ${integrityIssue ? 'integrity issue' : 'verified'}`}
                        className={`w-full text-left p-4 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 focus-visible:ring-inset transition flex items-center justify-between gap-3 border-l-4 ${
                          integrityIssue ? 'bg-red-50/70 border-red-500 hover:bg-red-50' : (isSelected ? 'bg-blue-50/70 border-blue-500' : 'border-transparent hover:bg-gray-50')
                        }`}
                      >
                        <div className="flex items-start gap-3 min-w-0">
                          <div className="mt-1 p-2 rounded-lg bg-blue-50 text-blue-600 shrink-0">
                            <Hash className="w-4 h-4" />
                          </div>
                          <div className="min-w-0">
                            <h3 className="font-semibold text-gray-900 truncate text-sm">{item.project.title}</h3>
                            <p className={`text-xs mt-1 truncate ${integrityIssue ? 'text-red-700 font-medium' : 'text-gray-500'}`}>
                              {integrityIssue ? (valid === false ? 'Tampered chain' : 'Budget mismatch') : `${item.chain.length} block${item.chain.length === 1 ? '' : 's'}`}
                              {integrityIssue && valid !== false && budgetMismatch ? ` · ${item.chain.length} block${item.chain.length === 1 ? '' : 's'}` : ''}
                            </p>
                          </div>
                        </div>
                        <div className="flex items-center gap-2 shrink-0">
                          {integrityIssue ? <AlertCircle className="w-4 h-4 text-red-600" /> : <CheckCircle className="w-4 h-4 text-emerald-600" />}
                          <ChevronRight className={`w-4 h-4 ${isSelected ? 'text-blue-500' : 'text-gray-300'}`} />
                        </div>
                      </button>
                    );
                  })}
                </div>

                <PaginationBar
                  page={safeGenesisPage}
                  pageCount={genesisPageCount}
                  onChange={setGenesisPage}
                  rangeLabel={
                    filteredChains.length
                      ? `${genesisStart + 1}–${Math.min(genesisStart + GENESIS_PAGE_SIZE, filteredChains.length)} of ${filteredChains.length}`
                      : '0 of 0'
                  }
                />
              </Card>

              {/* Right: selected chain detail */}
              <Card className="rounded-[20px] border-0 shadow-sm overflow-hidden lg:sticky lg:top-6">
                {!selected ? (
                  <div className="p-16 text-center text-gray-500">
                    <Hash className="w-8 h-8 mx-auto mb-3 text-gray-300" />
                    <p className="font-medium text-gray-700">No project selected</p>
                    <p className="text-sm mt-1">Choose a project from the list to see its genesis block, hashes, and verification status.</p>
                  </div>
                ) : (
                  <>
                    <div className="p-5 sm:p-6 border-b border-gray-100">
                      <p className="text-xs text-blue-600 font-semibold">Project chain</p>
                      <h2 ref={detailHeadingRef} tabIndex={-1} className="text-xl font-semibold text-gray-900 mt-1 focus:outline-none">
                        {selected.project.title}
                      </h2>
                      <p className="text-xs text-gray-500 mt-1 truncate">
                        Genesis:{' '}
                        <span className={selected.genesis?.hash ? 'font-mono' : 'italic'}>
                          {selected.genesis?.hash || 'no genesis block'}
                        </span>
                      </p>
                    </div>

                    <div className="overflow-auto max-h-[55vh]">
                      <table className="min-w-[640px] w-full text-sm">
                        <thead className="sticky top-0 z-10 bg-gray-50 text-left text-gray-500">
                          <tr>
                            <th className="px-4 sm:px-5 py-3 w-20">Block</th>
                            <th className="px-4 sm:px-5 py-3 w-32">Type</th>
                            <th className="px-4 sm:px-5 py-3">Record</th>
                            <th className="px-4 sm:px-5 py-3 w-[38%]">Hash</th>
                          </tr>
                        </thead>
                        <tbody className="divide-y divide-gray-100">
                          {pagedBlocks.map((block, index) => {
                            const blockTampered = selected.verification?.tamperedBlocks?.some((item) => item.blockIndex === block.block_index);
                            return <tr key={block.id} className={`align-top ${blockTampered ? 'bg-red-50' : ''}`}>
                              <td className="px-4 sm:px-5 py-4 font-semibold text-gray-900 tabular-nums">
                                <span className="relative">
                                  {index > 0 && (
                                    <span className="absolute -top-4 left-2 w-px h-4 bg-gray-200" aria-hidden="true" />
                                  )}
                                  #{block.block_index}
                                </span>
                              </td>
                              <td className="px-4 sm:px-5 py-4 text-gray-700">
                                {block.data?.type === 'project' ? 'Genesis' : block.data?.entry_type || 'Ledger'}
                              </td>
                              <td className="px-4 sm:px-5 py-4">
                                <div className="text-gray-900">{block.data?.description || selected.project.title}</div>
                                <div className="text-xs text-gray-500 mt-1">{block.data?.ledger_id || 'Project record'}</div>
                              </td>
                              <td className="px-4 sm:px-5 py-4">
                                <code className="block text-xs leading-5 break-all font-mono text-gray-500">{block.hash}</code>
                              </td>
                            </tr>;
                          })}
                        </tbody>
                      </table>
                      {!selected.chain.length && (
                        <div className="p-10 text-center text-gray-500">This project has no recorded chain.</div>
                      )}
                    </div>

                    <PaginationBar
                      page={safeChainPage}
                      pageCount={chainPageCount}
                      onChange={setChainPage}
                      rangeLabel={
                        selected.chain.length
                          ? `${chainStart + 1}–${Math.min(chainStart + CHAIN_PAGE_SIZE, selected.chain.length)} of ${selected.chain.length} blocks`
                          : '0 of 0 blocks'
                      }
                    />

                    <div
                      className={`p-4 border-t flex items-start gap-2 text-sm ${
                        hasIntegrityIssue(selected) ? 'text-red-700 bg-red-50' : 'text-emerald-700 bg-emerald-50'
                      }`}
                    >
                      {hasIntegrityIssue(selected) ? (
                        <AlertCircle className="w-4 h-4 mt-0.5 shrink-0" />
                      ) : (
                        <CheckCircle className="w-4 h-4 mt-0.5 shrink-0" />
                      )}
                      <span className="break-words">
                        {!selected.verification?.isValid && (selected.verification?.message || 'Blockchain integrity compromised')}
                        {selected.verification?.isValid && selected.budgetMismatch && 'Budget mismatch: stored project budget differs from approved ledger total.'}
                        {!hasIntegrityIssue(selected) && (selected.verification?.message || 'Blockchain is valid')}
                        {hasIntegrityIssue(selected) && (
                          <span className="block mt-1">Review the highlighted chain or budget discrepancy.</span>
                        )}
                      </span>
                    </div>
                  </>
                )}
              </Card>
            </div>
          </div>
        </div>
      </div>

    </AuthenticatedLayout>
  );
}