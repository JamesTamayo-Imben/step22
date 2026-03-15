<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Institute;
use Illuminate\Http\JsonResponse;

class InstituteController extends Controller
{
    /**
     * Get all institutes
     */
    public function index(): JsonResponse
    {
        $institutes = Institute::all(['id', 'name']);
        return response()->json($institutes);
    }

    /**
     * Get institute by ID
     */
    public function show($id): JsonResponse
    {
        $institute = Institute::find($id);
        
        if (!$institute) {
            return response()->json(['error' => 'Institute not found'], 404);
        }

        return response()->json($institute);
    }
}
