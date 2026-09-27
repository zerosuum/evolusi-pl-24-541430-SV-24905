<?php

namespace Tests\Feature;

use App\Models\KanjiCard;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class KanjiApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_api_returns_kanji_cards_as_json(): void
    {
        KanjiCard::query()->create([
            'character' => '日',
            'meaning' => 'hari / matahari',
            'onyomi' => 'ニチ・ジツ',
            'kunyomi' => 'ひ',
            'example' => '日本 (にほん) — Jepang',
        ]);

        $response = $this->getJson('/api/kanji');

        $response
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.character', '日')
            ->assertJsonPath('data.0.meaning', 'hari / matahari');
    }
}
