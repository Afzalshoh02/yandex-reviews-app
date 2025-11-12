<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run()
    {
        User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => Hash::make('password'),
            'company_name' => 'Самое популярное кафе',
            'yandex_map_url' => 'https://yandex.ru/maps/org/samoye_populyarnoye_kafe/1010501395/reviews/',
            'rating' => 4.5,
            'reviews_count' => 127,
        ]);
    }
}
