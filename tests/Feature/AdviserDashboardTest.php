<?php

namespace Tests\Feature;

use Tests\TestCase;

class AdviserDashboardTest extends TestCase
{
    public function test_adviser_route_requires_authentication(): void
    {
        $response = $this->get('/adviser');

        $response->assertRedirect('/login');
    }
}
