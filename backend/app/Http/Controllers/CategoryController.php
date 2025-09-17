<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index(Request $request)
    {
        $categories = Category::query()
            ->withCount('products')
            ->orderBy('name')
            ->get();

        return response()->json(['data => $categories']);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required','string','max:255'],
            'slug' => ['required','string','max:255','unique:categories,slug'],
            'description' => ['nullable','string'],
        ]);

        $category = Category::create($validated);

        return response()->json([
            'message' => 'Category created',
            'data' => $category,
        ], 201);
    }

    public function showBySlug(string $slug)
    {
        $category = Category::where('slug', $slug)
        ->firstOrFail();

        $products = $category->products()->orderByDesc('id')->get();

        return response()->json([
            'category' => $category,
            'products' => $products,
        ]);
    }

}