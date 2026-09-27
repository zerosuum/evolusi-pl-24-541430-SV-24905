<?php

use App\Http\Controllers\Api\KanjiCardController;
use Illuminate\Support\Facades\Route;

Route::get('/kanji', [KanjiCardController::class, 'index']);
