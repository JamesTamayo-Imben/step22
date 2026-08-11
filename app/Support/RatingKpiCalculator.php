<?php

namespace App\Support;

use Illuminate\Support\Collection;

class RatingKpiCalculator
{
    public static function calculateCsatRate(Collection $ratings): int
    {
        if ($ratings->count() === 0) {
            return 0;
        }

        $satisfied = $ratings->filter(function ($rating) {
            $average = (
                (float) ($rating->satisfaction_rating ?? 0) +
                (float) ($rating->engagement_rating ?? 0) +
                (float) ($rating->completeness_rating ?? 0)
            ) / 3;

            return round($average) >= 3;
        })->count();

        return (int) round(100 * $satisfied / $ratings->count());
    }
}
