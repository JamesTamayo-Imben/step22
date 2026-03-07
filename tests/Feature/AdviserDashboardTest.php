<?php

namespace Tests\Feature;

use Tests\TestCase;

class AdviserDashboardTest extends TestCase
{
    /** @test */
    public function adviser_route_loads()
    {
        $response = $this->get('/adviser');

        $response->assertStatus(200);
    }
}
