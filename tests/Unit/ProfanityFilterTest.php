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

    public function test_it_detects_punctuation_inserted_inside_profanity(): void
    {
        $this->assertTrue(ProfanityFilter::contains('p.u.t.a'));
        $this->assertTrue(ProfanityFilter::contains('f@ck'));
        $this->assertTrue(ProfanityFilter::contains('t.a.n.g.i.n.a'));
    }

    public function test_it_detects_symbol_only_input(): void
    {
        $this->assertTrue(ProfanityFilter::contains('.'));
        $this->assertTrue(ProfanityFilter::contains('@'));
        $this->assertTrue(ProfanityFilter::contains('!'));
        $this->assertFalse(ProfanityFilter::contains('   '));
    }

    public function test_it_allows_clean_text(): void
    {
        $this->assertFalse(ProfanityFilter::contains('The project was well organized.'));
    }
}