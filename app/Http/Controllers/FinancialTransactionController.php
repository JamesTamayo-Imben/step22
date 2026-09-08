<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\LedgerEntry; // Ensure this matches your model name [cite: 246]

class FinancialTransactionController extends Controller
{
    public function store(Request $request)
    {
        // 1. Validate the input and file [cite: 251]
        $request->validate([
            'amount' => 'required|numeric',
            'type' => 'required|in:Income,Expense,Canvas,Donation,Sponsorship',
            'description' => 'required|string',
            'ledger_proof' => 'required|file|mimes:jpg,jpeg,png,pdf|max:5120', // 5MB limit
        ]);

        if ($request->hasFile('ledger_proof')) {
            $file = $request->file('ledger_proof');

            // 2. Generate an Immutable Hash [cite: 603]
            // This ensures the file content cannot be altered without detection
            $fileHash = hash_file('sha256', $file->getRealPath());
            $extension = $file->getClientOriginalExtension();
            $fileName = $fileHash . '.' . $extension;

            // 3. Store the proof in private object storage
            $path = $file->storeAs('proofs', $fileName, 'supabase');

            // 4. Create the Ledger Entry [cite: 184, 246]
            $ledger = new LedgerEntry();
            $ledger->amount = $request->amount;
            $ledger->type = $request->type;
            $ledger->description = $request->description;
            $ledger->ledger_proof = $path;
            // If you added a column for the hash as planned in your docs:
            // $ledger->file_content_hash = $fileHash; 
            
            $ledger->save();

            return response()->json(['message' => 'Transaction and proof saved successfully!', 'data' => $ledger], 201);
        }
    }
}