<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('company_name')->nullable();
            $table->string('yandex_map_url')->nullable();
            $table->decimal('rating', 3, 1)->default(0);
            $table->integer('reviews_count')->default(0);
            $table->json('reviews')->nullable();
            $table->timestamp('reviews_synced_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['company_name', 'yandex_map_url', 'rating', 'reviews_count']);
        });
    }
};
