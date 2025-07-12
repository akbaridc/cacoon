<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens, HasRoles;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'nik',
        'token',
        'token_text',
        'is_active',
        'token_expires_at',
        'avatar',
        'is_organic'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'token_text',
        'token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'token_expires_at' => 'datetime',
            'is_active' => 'boolean',
        ];
    }

    /**
     * Get the employee associated with the user.
     */
    public function employee()
    {
        return $this->hasOne(Employee::class, 'nik', 'nik');
    }

    /**
     * Check if the user's token is still valid
     */
    public function isTokenValid(): bool
    {
        if (!$this->token || !$this->token_expires_at) {
            return false;
        }

        return $this->token_expires_at->isFuture();
    }
}
