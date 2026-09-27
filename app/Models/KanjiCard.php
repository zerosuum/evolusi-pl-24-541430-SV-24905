<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KanjiCard extends Model
{
    protected $fillable = [
        'character',
        'meaning',
        'onyomi',
        'kunyomi',
        'example',
    ];
}
