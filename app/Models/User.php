<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'company_name',
        'yandex_map_url',
        'rating',
        'reviews_count',
        'reviews',
        'reviews_synced_at',

    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'rating' => 'float',
    ];

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function getRatingAttribute($value)
    {
        return $value ? (float) $value : 0.0;
    }
}
