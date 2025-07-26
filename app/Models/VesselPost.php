<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class VesselPost extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia;

    protected $table = 'vessel_posts';
    protected $primaryKey = 'vp_id';

    protected $fillable = [
        'vp_id',
        'vp_user_id',
        'vp_vsl_code',
        'vp_pk_id',
        'vp_post_date',
        'vp_post_time',
        'vp_latitude',
        'vp_longitude',
        'vp_location_name',
        'vp_shift',
        'vp_note'
    ];

    protected $appends = ['vp_photo_vessel', 'vp_photo_selfie'];

    public function registerMediaConversions(?Media $media = null): void
    {
        $this
            ->addMediaConversion('thumb')
            ->width(100)
            ->height(100)
            ->sharpen(10)
            ->nonQueued()
            ->performOnCollections('photo_vessel', 'photo_selfie');
    }

    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('photo_vessel')->singleFile();

        $this->addMediaCollection('photo_selfie')->singleFile();
    }

    public function vessel()
    {
        return $this->belongsTo(Vessel::class, 'vp_vsl_code', 'vsl_code');
    }

    public function palka()
    {
        return $this->belongsTo(Palka::class, 'vp_pk_id', 'pk_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'vp_user_id', 'id');
    }

    public function getVpPhotoVesselAttribute()
    {
        return $this->getFirstMediaUrl('photo_vessel', 'thumb');
    }

    public function getVpPhotoSelfieAttribute()
    {
        return $this->getFirstMediaUrl('photo_selfie', 'thumb');
    }
}
