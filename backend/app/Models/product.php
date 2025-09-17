<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Product extends Model
{
	use HasFactory;

	protected $fillable = [
		'name', 
		'slug', 
		'description', 
		'price', 
		'stock', '
		image_url',
	];

	public function categories()
	{
		return $this->belongsToMany(Category::class, 'product_category')
		->withTimestamps();
	}
}