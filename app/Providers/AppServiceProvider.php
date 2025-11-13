<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Отключаем проверку mix-manifest в production
        if ($this->app->environment('production')) {
            $this->app->bind('mix', function () {
                return new class {
                    public function __invoke($path, $manifestDirectory = '')
                    {
                        return asset($path);
                    }

                    public function __call($method, $parameters)
                    {
                        return asset($parameters[0] ?? '');
                    }
                };
            });
        }
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        if (env('FORCE_HTTPS', false)) {
            URL::forceScheme('https');
        }
    }
}
