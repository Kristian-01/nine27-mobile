<?php

// database/seeders/CategorySeeder.php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Pain Relief',
                'slug' => 'pain-relief',
                'description' => 'Medications for pain management and relief',
                'image_url' => 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
                'sort_order' => 1,
            ],
            [
                'name' => 'Cold & Flu',
                'slug' => 'cold-flu',
                'description' => 'Treatments for cold and flu symptoms',
                'image_url' => 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
                'sort_order' => 2,
            ],
            [
                'name' => 'Vitamins',
                'slug' => 'vitamins',
                'description' => 'Essential vitamins and supplements',
                'image_url' => 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=400',
                'sort_order' => 3,
            ],
            [
                'name' => 'First Aid',
                'slug' => 'first-aid',
                'description' => 'First aid supplies and emergency care',
                'image_url' => 'https://images.unsplash.com/photo-1603398938165-c6a91faa6f63?w=400',
                'sort_order' => 4,
            ],
            [
                'name' => 'Skin Care',
                'slug' => 'skin-care',
                'description' => 'Dermatological and skin care products',
                'image_url' => 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400',
                'sort_order' => 5,
            ],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}
