<?php

namespace Tests\Unit;

use App\Support\RatingKpiCalculator;
use Illuminate\Support\Collection;
use PHPUnit\Framework\TestCase;

class RatingKpiCalculatorTest extends TestCase
{
    public function test_it_uses_the_average_of_all_three_sub_ratings_for_csat(): void
    {
        $ratings = new Collection([
            (object) ['satisfaction_rating' => 2, 'completeness_rating' => 4, 'engagement_rating' => 4],
            (object) ['satisfaction_rating' => 4, 'completeness_rating' => 4, 'engagement_rating' => 2],
        ]);

        $this->assertSame(100, RatingKpiCalculator::calculateCsatRate($ratings));
    }

    public function test_it_returns_zero_when_there_are_no_ratings(): void
    {
        $this->assertSame(0, RatingKpiCalculator::calculateCsatRate(new Collection()));
    }
}
