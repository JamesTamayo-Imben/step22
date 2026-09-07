<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class MasterDataSeeder extends Seeder
{
    public function run(): void
    {
        $now = now();
        $institutes = [
            'ICDI', 'IBS', 'IE', 'IFS', 'IGDS', 'IM', 'CCJ', 'ISM',
        ];

        $instituteIds = [];
        foreach ($institutes as $name) {
            $institute = DB::table('institute')->where('name', $name)->first();
            $id = $institute?->id ?? (string) Str::uuid();

            DB::table('institute')->updateOrInsert(
                ['id' => $id],
                ['name' => $name, 'description' => null, 'archive' => false, 'updated_at' => $now, 'created_at' => $institute?->created_at ?? $now]
            );

            $instituteIds[$name] = $id;
        }

        foreach (['BSIS', 'BSCS', 'BSPSY', 'BSCE', 'BSM', 'BSN', 'BSocSc'] as $name) {
            $existing = DB::table('course')
                ->where('name', $name)
                ->where('institute_id', $instituteIds['ICDI'])
                ->first();

            DB::table('course')->updateOrInsert(
                ['id' => $existing?->id ?? (string) Str::uuid()],
                [
                    'institute_id' => $instituteIds['ICDI'],
                    'name' => $name,
                    'description' => null,
                    'archive' => false,
                    'updated_at' => $now,
                    'created_at' => $existing?->created_at ?? $now,
                ]
            );
        }

        $positions = [
            'President',
            'Vice President for Internal Affairs',
            'Vice President for External Affairs',
            'Secretary',
            'Treasurer',
            'Auditor',
            'Business Manager',
            'Press Relations Officer',
            'Student Liaison',
            'ICDI IS Representative',
            'ICDI CS Representative',
            'IGDS SW Representative',
            'IOM Representative',
            'ION Representative',
        ];

        foreach ($positions as $positionName) {
            $existing = DB::table('position')->where('position_name', $positionName)->first();

            DB::table('position')->updateOrInsert(
                ['id' => $existing?->id ?? Str::lower(Str::random(32))],
                [
                    'position_name' => $positionName,
                    'updated_at' => $existing?->updated_at ?? $now,
                    'created_at' => $existing?->created_at ?? $now,
                ]
            );
        }
    }
}