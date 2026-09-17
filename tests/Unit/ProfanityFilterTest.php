<?php

namespace Tests\Unit;

use App\Support\ProfanityFilter;
use PHPUnit\Framework\TestCase;

class ProfanityFilterTest extends TestCase
{
    public function test_it_detects_filipino_profanity(): void
    {
        $this->assertTrue(ProfanityFilter::contains('Hindi ito maayos, tangina.'));
    }

    public function test_it_detects_punctuation_and_case_variants(): void
    {
        $this->assertTrue(ProfanityFilter::contains('PUTANG-INA mo'));
    }

    public function test_it_allows_clean_text(): void
    {
        $this->assertFalse(ProfanityFilter::contains('The project was well organized.'));
    }
}