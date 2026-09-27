<?php

namespace Database\Seeders;

use App\Models\KanjiCard;
use Illuminate\Database\Seeder;

class KanjiCardSeeder extends Seeder
{
    public function run(): void
    {
        foreach (config('kanji') as $card) {
            KanjiCard::query()->updateOrCreate(
                ['character' => $card['character']],
                $card,
            );
        }
    }
}
