<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user()->load(['reviews' => function($query) {
            $query->latest('date')->limit(10);
        }]);

        $reviews = $user->reviews;
        $totalReviews = $reviews->count();
        $averageRating = $totalReviews > 0 ? $reviews->avg('rating') : 0;

        return response()->json([
            'user' => $user,
            'stats' => [
                'total_reviews' => $totalReviews,
                'average_rating' => (float) number_format($averageRating, 1),
                'latest_reviews_count' => $totalReviews
            ]
        ]);
    }
}
