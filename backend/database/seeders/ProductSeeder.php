<?php

// database/seeders/ProductSeeder.php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Category;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $products = [
            [
                'name' => 'Ibuprofen 200mg',
                'slug' => 'ibuprofen-200mg',
                'description' => 'Fast-acting pain relief and anti-inflammatory medication',
                'price' => 8.99,
                'compare_price' => 12.99,
                'stock' => 150,
                'sku' => 'IBU-200-001',
                'image_url' => 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400',
                'manufacturer' => 'PharmaCorp',
                'unit' => 'tablet',
                'category_slug' => 'pain-relief',
            ],
            [
                'name' => 'Acetaminophen 500mg',
                'slug' => 'acetaminophen-500mg',
                'description' => 'Effective pain reliever and fever reducer',
                'price' => 6.49,
                'stock' => 200,
                'sku' => 'ACE-500-001',
                'image_url' => 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
                'manufacturer' => 'MediGen',
                'unit' => 'tablet',
                'category_slug' => 'pain-relief',
            ],
            [
                'name' => 'Vitamin C 1000mg',
                'slug' => 'vitamin-c-1000mg',
                'description' => 'High-potency vitamin C for immune support',
                'price' => 12.99,
                'stock' => 300,
                'sku' => 'VIT-C-1000',
                'image_url' => 'https://images.unsplash.com/photo-1550572017-edd951b55104?w=400',
                'manufacturer' => 'VitaLife',
                'unit' => 'tablet',
                'category_slug' => 'vitamins',
            ],
            [
                'name' => 'Cough Syrup',
                'slug' => 'cough-syrup',
                'description' => 'Natural cough suppressant and throat soother',
                'price' => 9.99,
                'stock' => 80,
                'sku' => 'COUGH-SYR-001',
                'image_url' => 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
                'manufacturer' => 'ColdCare',
                'unit' => 'ml',
                'category_slug' => 'cold-flu',
            ],
            [
                'name' => 'Adhesive Bandages',
                'slug' => 'adhesive-bandages',
                'description' => 'Sterile adhesive bandages for wound care',
                'price' => 4.99,
                'stock' => 500,
                'sku' => 'BAND-ADH-001',
                'image_url' => 'https://images.unsplash.com/photo-1603398938165-c6a91faa6f63?w=400',
                'manufacturer' => 'FirstAid Pro',
                'unit' => 'piece',
                'category_slug' => 'first-aid',
            ],
        ];

        foreach ($products as $productData) {
            $categorySlug = $productData['category_slug'];
            unset($productData['category_slug']);

            $product = Product::create($productData);
            
            $category = Category::where('slug', $categorySlug)->first();
            if ($category) {
                $product->categories()->attach($category->id);
            }
        }
    }
}