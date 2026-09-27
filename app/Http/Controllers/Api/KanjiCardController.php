<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KanjiCard;
use Illuminate\Http\JsonResponse;

class KanjiCardController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'data' => KanjiCard::query()
                ->orderBy('id')
                ->get(),
        ]);
    }
}
