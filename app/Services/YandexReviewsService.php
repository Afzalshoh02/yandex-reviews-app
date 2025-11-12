<?php

namespace App\Services;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use Illuminate\Support\Facades\Log;
use Symfony\Component\DomCrawler\Crawler;

class YandexReviewsService
{
    private $client;

    public function __construct()
    {
        $this->client = new Client([
            'timeout' => 30,
            'verify' => false,
            'headers' => [
                'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                'Accept-Language' => 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3',
                'Accept-Encoding' => 'gzip, deflate, br',
                'Connection' => 'keep-alive',
                'Upgrade-Insecure-Requests' => '1',
            ]
        ]);
    }

    public function fetchReviews($yandexMapUrl)
    {
        try {
            Log::info('Fetching reviews from: ' . $yandexMapUrl);

            $response = $this->client->get($yandexMapUrl);
            $html = $response->getBody()->getContents();

            return $this->parseHtml($html);

        } catch (RequestException $e) {
            Log::error('Request failed: ' . $e->getMessage());
            throw new \Exception('Не удалось загрузить страницу: ' . $e->getMessage());
        } catch (\Exception $e) {
            Log::error('Parsing failed: ' . $e->getMessage());
            throw new \Exception('Ошибка при обработке страницы: ' . $e->getMessage());
        }
    }

    private function parseHtml($html)
    {
        $crawler = new Crawler($html);

        $totalRating = $this->parseTotalRating($crawler);

        $totalReviews = $this->parseTotalReviews($crawler);

        $reviews = $this->parseReviews($crawler);

        if (empty($reviews)) {
            throw new \Exception('Не удалось найти отзывы на странице. Возможно, структура страницы изменилась или содержимое загружается динамически. Рекомендуется использовать headless browser для полного рендеринга.');
        }

        if ($totalRating == 0 && !empty($reviews)) {
            $ratings = array_column($reviews, 'rating');
            $totalRating = array_sum($ratings) / count($ratings);
        }

        return [
            'rating' => $totalRating,
            'reviews_count' => $totalReviews,
            'reviews' => array_slice($reviews, 0, 10)
        ];
    }

    private function parseTotalRating(Crawler $crawler)
    {
        try {
            $selectors = [
                '[class*="rating-value"]',
                '.business-summary-rating-badge__rating-text',
                '.business-rating-badge-view__rating-text',
                '.card-rating-score',
                '[itemprop="ratingValue"]',
                '.orgpage-header-view__rating-text',
                '.rating-badge__text',
                '.business-header-rating__rating-text'
            ];

            foreach ($selectors as $selector) {
                if ($crawler->filter($selector)->count() > 0) {
                    $ratingText = $crawler->filter($selector)->first()->text();
                    $rating = (float) str_replace(',', '.', trim($ratingText));
                    if ($rating > 0) {
                        return $rating;
                    }
                }
            }

            return 0;

        } catch (\Exception $e) {
            Log::warning('Failed to parse total rating: ' . $e->getMessage());
            return 0;
        }
    }

    private function parseTotalReviews(Crawler $crawler)
    {
        try {
            $selectors = [
                '[class*="review-count"]',
                '.business-review-rating-badge__review-count',
                '.business-reviews-block-view__header-counter',
                '.tabs-select-view__count',
                '[itemprop="reviewCount"]',
                '.business-header-rating__reviews-count',
                '.rating-badge__count'
            ];

            foreach ($selectors as $selector) {
                if ($crawler->filter($selector)->count() > 0) {
                    $countText = $crawler->filter($selector)->first()->text();
                    preg_match('/\d+/', $countText, $matches);
                    if (isset($matches[0])) {
                        return (int) $matches[0];
                    }
                }
            }

            return 0;

        } catch (\Exception $e) {
            Log::warning('Failed to parse total reviews: ' . $e->getMessage());
            return 0;
        }
    }

    private function parseReviews(Crawler $crawler)
    {
        $reviews = [];

        try {
            $reviewSelectors = [
                '.business-reviews-card-view__review',
                '.business-review',
                '.review-item',
                '[class*="review-view"]',
                '.business-reviews-view__review',
                '.business-reviews-card-view__item',
                '.review-card'
            ];

            foreach ($reviewSelectors as $reviewSelector) {
                $reviewNodes = $crawler->filter($reviewSelector);

                if ($reviewNodes->count() > 0) {
                    Log::info("Found {$reviewNodes->count()} reviews with selector: {$reviewSelector}");

                    $reviews = $reviewNodes->each(function (Crawler $node) {
                        return $this->parseSingleReview($node);
                    });

                    $reviews = array_filter($reviews);

                    if (!empty($reviews)) {
                        break;
                    }
                }
            }

        } catch (\Exception $e) {
            Log::error('Error parsing reviews: ' . $e->getMessage());
        }

        return $reviews;
    }

    private function parseSingleReview(Crawler $node)
    {
        try {
            $author = $this->parseAuthor($node);
            $text = $this->parseReviewText($node);
            $rating = $this->parseReviewRating($node);
            $date = $this->parseReviewDate($node);

            if (empty(trim($text))) {
                return null;
            }

            return [
                'author_name' => $author ?: 'Аноним',
                'rating' => $rating,
                'text' => trim($text),
                'date' => $date,
                'original_data' => [
                    'author' => $author,
                    'rating' => $rating,
                    'text' => $text,
                    'date' => $date
                ]
            ];

        } catch (\Exception $e) {
            Log::warning('Failed to parse single review: ' . $e->getMessage());
            return null;
        }
    }

    private function parseAuthor(Crawler $node)
    {
        $authorSelectors = [
            '.business-review-view__author',
            '.review-author',
            '.user-name',
            '[class*="author-name"]',
            '.business-review-view__author .link__text',
            '.review-view__author-name',
            '.user-link__name'
        ];

        foreach ($authorSelectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                return trim($node->filter($selector)->first()->text());
            }
        }

        return 'Аноним';
    }

    private function parseReviewText(Crawler $node)
    {
        $textSelectors = [
            '.business-review-view__body',
            '.review-text',
            '.business-review-view__text',
            '.review-content',
            '[class*="review-text"]',
            '.business-review-view__body-text',
            '.review-view__text'
        ];

        foreach ($textSelectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                return trim($node->filter($selector)->first()->text());
            }
        }

        return '';
    }
    private function getRatingFromAriaLabel(Crawler $node)
    {
        $selectors = [
            '[aria-label*="из 5"]',
            '[aria-label*="оценка"]',
            '[class*="rating"]',
            '.business-review-view__rating',
            '.i-stars'
        ];

        foreach ($selectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                $element = $node->filter($selector)->first();
                $ariaLabel = $element->attr('aria-label') ?? '';
                if ($ariaLabel && preg_match('/(\d+(?:[.,]\d+)?)\s*из\s*5/', $ariaLabel, $matches)) {
                    return (float) str_replace(',', '.', $matches[1]);
                }
            }
        }

        return 0;
    }

    private function getRatingFromDataAttr(Crawler $node)
    {
        $selectors = [
            '[data-rating]',
            '[data-score]',
            '[data-value]'
        ];

        foreach ($selectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                $element = $node->filter($selector)->first();
                $rating = $element->attr('data-rating') ??
                    $element->attr('data-score') ??
                    $element->attr('data-value');
                if ($rating && is_numeric($rating)) {
                    return (float) $rating;
                }
            }
        }

        return 0;
    }

    private function getRatingFromText(Crawler $node)
    {
        $selectors = [
            '.business-rating-badge-view__rating',
            '.review-rating',
            '[class*="rating-value"]'
        ];

        foreach ($selectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                $text = $node->filter($selector)->first()->text();
                if (preg_match('/(\d+(?:[.,]\d+)?)/', $text, $matches)) {
                    return (float) str_replace(',', '.', $matches[1]);
                }
            }
        }

        return 0;
    }

    private function countFilledStars(Crawler $node)
    {
        $starSelectors = [
            '.i-stars__rating',
            '.mini-stars-group',
            '[class*="stars"]'
        ];

        foreach ($starSelectors as $selector) {
            if ($node->filter($selector)->count() > 0) {
                $container = $node->filter($selector)->first();
                $filled = $container->filter('[class*="_filled"], .i-star_filled, .filled')->count();
                if ($filled > 0 && $filled <= 5) {
                    return (float) $filled;
                }
            }
        }

        return 0;
    }
    private function parseReviewRating(Crawler $node)
    {
        try {
            if ($node->filter('meta[itemprop="ratingValue"]')->count() > 0) {
                $rating = (float) $node->filter('meta[itemprop="ratingValue"]')->first()->attr('content');
                if ($rating >= 1 && $rating <= 5) {
                    return $rating;
                }
            }

            if ($node->filter('.business-rating-badge-view__stars')->count() > 0) {
                $aria = $node->filter('.business-rating-badge-view__stars')->first()->attr('aria-label') ?? '';
                if (preg_match('/(\d+(?:[.,]\d+)?)\s*(?:Из|из)\s*5/i', $aria, $m)) {
                    return (float) str_replace(',', '.', $m[1]);
                }
            }

            $full = $node->filter('.business-rating-badge-view__star._full')->count();
            if ($full >= 1 && $full <= 5) {
                return (float) $full;
            }

            return 0;

        } catch (\Exception $e) {
            Log::warning('Rating parse error: ' . $e->getMessage());
            return 0;
        }
    }

    private function parseReviewDate(Crawler $node)
    {
        try {
            if ($node->filter('meta[itemprop="datePublished"]')->count() > 0) {
                $isoDate = $node->filter('meta[itemprop="datePublished"]')->first()->attr('content');
                $date = new \DateTime($isoDate);
                return $date->format('Y-m-d H:i:s');
            }

            $dateSelectors = [
                '.business-review-view__date span',
                '.business-review-view__date',
                '.review-date'
            ];

            foreach ($dateSelectors as $selector) {
                if ($node->filter($selector)->count() > 0) {
                    $dateText = trim($node->filter($selector)->first()->text());
                    return $this->parseRelativeDate($dateText);
                }
            }

            return now()->format('Y-m-d H:i:s');

        } catch (\Exception $e) {
            Log::warning('Date parse error: ' . $e->getMessage());
            return now()->format('Y-m-d H:i:s');
        }
    }
    private function parseRelativeDate($dateString)
    {
        $dateString = trim($dateString);
        $now = now();

        if (mb_strtolower($dateString) === 'сегодня') {
            return $now->format('Y-m-d H:i:s');
        }
        if (mb_strtolower($dateString) === 'вчера') {
            return $now->subDay()->format('Y-m-d H:i:s');
        }

        $months = [
            'января' => '01', 'февраля' => '02', 'марта' => '03',
            'апреля' => '04', 'мая' => '05', 'июня' => '06',
            'июля' => '07', 'августа' => '08', 'сентября' => '09',
            'октября' => '10', 'ноября' => '11', 'декабря' => '12'
        ];

        foreach ($months as $ru => $num) {
            if (str_contains($dateString, $ru)) {
                $day = preg_replace('/\D+/', '', $dateString);
                $year = $now->year;
                $month = $num;

                $testDate = \DateTime::createFromFormat('Y-m-d', "$year-$month-$day");
                if ($testDate > $now) {
                    $year--;
                }

                return "$year-$month-" . str_pad($day, 2, '0', STR_PAD_LEFT) . " 00:00:00";
            }
        }

        return $now->format('Y-m-d H:i:s');
    }
    private function parseDateString($dateString)
    {
        $months = [
            'января' => '01', 'февраля' => '02', 'марта' => '03',
            'апреля' => '04', 'мая' => '05', 'июня' => '06',
            'июля' => '07', 'августа' => '08', 'сентября' => '09',
            'октября' => '10', 'ноября' => '11', 'декабря' => '12'
        ];

        $dateString = mb_strtolower(trim($dateString));

        if ($dateString === 'сегодня') {
            return now()->format('Y-m-d H:i:s');
        } elseif ($dateString === 'вчера') {
            return now()->subDay()->format('Y-m-d H:i:s');
        } elseif (str_contains($dateString, 'дней назад') || str_contains($dateString, 'дня назад')) {
            preg_match('/\d+/', $dateString, $matches);
            if (isset($matches[0])) {
                return now()->subDays($matches[0])->format('Y-m-d H:i:s');
            }
        }

        foreach ($months as $ruMonth => $numMonth) {
            if (str_contains($dateString, $ruMonth)) {
                $dateString = str_replace($ruMonth, $numMonth, $dateString);
                $dateString = preg_replace('/[^\d\s\.]/', '', $dateString);
                $date = \DateTime::createFromFormat('d m Y', trim($dateString));
                if ($date) {
                    return $date->format('Y-m-d H:i:s');
                }
            }
        }

        $formats = ['d.m.Y', 'd-m-Y', 'Y-m-d'];
        foreach ($formats as $format) {
            $date = \DateTime::createFromFormat($format, $dateString);
            if ($date) {
                return $date->format('Y-m-d H:i:s');
            }
        }

        return now()->format('Y-m-d H:i:s');
    }
}
