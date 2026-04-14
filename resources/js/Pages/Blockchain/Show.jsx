import React from 'react';
import { Head } from '@inertiajs/react';
import Layout from '@/Layouts/Layout';

export default function Show({ project, chain, verification, integrity }) {
    return (
        <Layout>
            <Head title={`Blockchain - ${project.title}`} />

            <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                <div className="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div className="p-6 bg-white border-b border-gray-200">
                        <div className="flex justify-between items-center mb-6">
                            <div>
                                <h1 className="text-2xl font-bold text-gray-900">
                                    Blockchain Audit: {project.title}
                                </h1>
                                <p className="text-sm text-gray-600 mt-1">
                                    Project Status: {project.status} | Budget: ₱{parseFloat(project.amount).toLocaleString()}
                                </p>
                            </div>
                            <div className="text-right">
                                <div className={`inline-flex items-center px-3 py-1 rounded-full text-sm font-medium ${
                                    verification.isValid
                                        ? 'bg-green-100 text-green-800'
                                        : 'bg-red-100 text-red-800'
                                }`}>
                                    {verification.status === 'tampering_detected' ? (
                                        <>
                                            <svg className="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                                            </svg>
                                            Tampering Detected
                                        </>
                                    ) : verification.status === 'valid' ? (
                                        <>
                                            <svg className="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                                            </svg>
                                            Verified
                                        </>
                                    ) : (
                                        'Unknown'
                                    )}
                                </div>
                                <p className="text-xs text-gray-500 mt-1">{verification.message}</p>
                            </div>
                        </div>

                        {/* Integrity Stats */}
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                            <div className="bg-gray-50 p-4 rounded-lg">
                                <div className="text-sm font-medium text-gray-500">Total Blocks</div>
                                <div className="text-2xl font-bold text-gray-900">{integrity.totalBlocks}</div>
                            </div>
                            <div className="bg-gray-50 p-4 rounded-lg">
                                <div className="text-sm font-medium text-gray-500">Genesis Hash</div>
                                <div className="text-xs font-mono text-gray-900 break-all">{integrity.genesisHash?.substring(0, 16)}...</div>
                            </div>
                            <div className="bg-gray-50 p-4 rounded-lg">
                                <div className="text-sm font-medium text-gray-500">Latest Hash</div>
                                <div className="text-xs font-mono text-gray-900 break-all">{integrity.latestHash?.substring(0, 16)}...</div>
                            </div>
                        </div>

                        {/* Tampered Blocks Alert */}
                        {verification.tamperedBlocks && verification.tamperedBlocks.length > 0 && (
                            <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
                                <div className="flex">
                                    <div className="flex-shrink-0">
                                        <svg className="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                                            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                                        </svg>
                                    </div>
                                    <div className="ml-3">
                                        <h3 className="text-sm font-medium text-red-800">
                                            Tampered Ledger Entries Detected
                                        </h3>
                                        <div className="mt-2 text-sm text-red-700">
                                            <ul className="list-disc pl-5 space-y-1">
                                                {verification.tamperedBlocks.map((block, index) => (
                                                    <li key={index}>
                                                        <strong>Block #{block.blockIndex}</strong>
                                                        {block.ledgerId && (
                                                            <span> (Ledger ID: {block.ledgerId})</span>
                                                        )}
                                                        <ul className="list-disc pl-5 mt-1">
                                                            {block.issues.map((issue, i) => (
                                                                <li key={i} className="text-xs">{issue}</li>
                                                            ))}
                                                        </ul>
                                                    </li>
                                                ))}
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        )}

                        {/* Chain Blocks */}
                        <div className="space-y-4">
                            <h2 className="text-lg font-semibold text-gray-900">Blockchain</h2>
                            {chain.map((block, index) => (
                                <div key={block.id} className={`border rounded-lg p-4 ${
                                    verification.tamperedBlocks?.some(tb => tb.blockId === block.id)
                                        ? 'border-red-300 bg-red-50'
                                        : 'border-gray-200 bg-white'
                                }`}>
                                    <div className="flex justify-between items-start mb-2">
                                        <div>
                                            <span className="text-sm font-medium text-gray-900">
                                                Block #{block.block_index}
                                            </span>
                                            {block.data.type === 'project' && (
                                                <span className="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                                                    Project Genesis
                                                </span>
                                            )}
                                            {block.data.type === 'ledger' && (
                                                <span className="ml-2 inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800">
                                                    Ledger Entry
                                                </span>
                                            )}
                                        </div>
                                        <div className="text-xs text-gray-500">
                                            {new Date(block.created_at).toLocaleString()}
                                        </div>
                                    </div>

                                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                                        <div>
                                            <div className="font-medium text-gray-700">Previous Hash</div>
                                            <div className="font-mono text-xs text-gray-600 break-all">
                                                {block.prev_hash || 'None (Genesis)'}
                                            </div>
                                        </div>
                                        <div>
                                            <div className="font-medium text-gray-700">Block Hash</div>
                                            <div className="font-mono text-xs text-gray-600 break-all">
                                                {block.hash}
                                            </div>
                                        </div>
                                    </div>

                                    <div className="mt-3">
                                        <div className="font-medium text-gray-700 mb-1">Data Snapshot</div>
                                        <pre className="text-xs bg-gray-50 p-2 rounded overflow-x-auto">
                                            {JSON.stringify(block.data, null, 2)}
                                        </pre>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            </div>
        </Layout>
    );
}