<?php

namespace App\Http\Controllers;

use App\Services\YandexReviewsService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class SettingsController extends Controller
{
    private $yandexService;

    public function __construct(YandexReviewsService $yandexService)
    {
        $this->yandexService = $yandexService;
    }
    public function saveUrl(Request $request)
    {
        $request->validate([
            'yandex_map_url' => 'required|url'
        ]);

        $user = Auth::user();
        $user->yandex_map_url = $request->yandex_map_url;
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Ссылка сохранена!',
            'yandex_map_url' => $user->yandex_map_url
        ]);
    }
    public function update(Request $request)
    {
        $request->validate([
            'company_name' => 'nullable|string|max:255',
            'yandex_map_url' => 'required|url',
        ]);

        $user = $request->user();

        try {
            $reviewsData = $this->yandexService->fetchReviews($request->yandex_map_url);

            $user->update([
                'company_name' => $request->company_name,
                'yandex_map_url' => $request->yandex_map_url,
                'rating' => $reviewsData['rating'],
                'reviews_count' => $reviewsData['reviews_count'],
            ]);

            $user->reviews()->delete();
            foreach ($reviewsData['reviews'] as $reviewData) {
                $user->reviews()->create($reviewData);
            }

            return response()->json([
                'message' => 'Настройки успешно сохранены и отзывы загружены',
                'user' => $user->fresh('reviews'),
                'stats' => [
                    'loaded_reviews' => count($reviewsData['reviews']),
                    'total_rating' => $reviewsData['rating'],
                    'total_reviews' => $reviewsData['reviews_count']
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Settings update error: ' . $e->getMessage());

            $user->update($request->only('company_name', 'yandex_map_url'));

            return response()->json([
                'message' => 'Настройки сохранены, но не удалось загрузить отзывы: ' . $e->getMessage(),
                'user' => $user->fresh()
            ], 422);
        }
    }

    public function syncReviews(Request $request)
    {
        $request->validate([
            'yandex_map_url' => 'required|url'
        ]);

        $user = Auth::user();
        $url = $request->yandex_map_url;

        try {
            $service = new \App\Services\YandexReviewsService();
            $data = $service->fetchReviews($url);

            $user->yandex_map_url = $url;
            $user->rating = $data['rating'] ?? 0;
            $user->reviews_count = $data['reviews_count'] ?? 0;
            $user->reviews = $data['reviews'] ?? [];
            $user->reviews_synced_at = now();
            $user->save();

            return response()->json([
                'success' => true,
                'message' => 'Отзывы синхронизированы!',
                'data' => $data
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 400);
        }
    }
}
