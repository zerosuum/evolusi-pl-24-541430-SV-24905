<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('kanji_cards', function (Blueprint $table) {
            $table->id();
            $table->string('character', 10)->unique();
            $table->string('meaning');
            $table->string('onyomi')->nullable();
            $table->string('kunyomi')->nullable();
            $table->string('example')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('kanji_cards');
    }
};
