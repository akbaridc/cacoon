<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class StoryView extends Model
{
    use HasFactory;

    protected $table = 'story_views';
    protected $primaryKey = 'sv_id';

    protected $fillable = [
        'sv_id',
        'sv_vp_id',
        'sv_user_id',
        'sv_viewed_at',
    ];

    public function post() {
        return $this->belongsTo(VesselPost::class, 'sv_vp_id', 'vp_id');
    }

    public function viewer() {
        return $this->belongsTo(User::class, 'sv_user_id', 'id');
    }
}
