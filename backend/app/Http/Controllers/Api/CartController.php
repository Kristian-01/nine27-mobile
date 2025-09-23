<?php

// app/Http/Controllers/Api/CartController.php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class CartController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $cartItems = Cart::where('user_id', $request->user()->id)
                ->with('product')
                ->get();

            $total = $cartItems->sum('total_price');

            return response()->json([
                'success' => true,
                'data' => [
                    'items' => $cartItems,
                    'total' => $total,
                    'count' => $cartItems->count(),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch cart items',
            ], 500);
        }
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $product = Product::findOrFail($request->product_id);

            if (!$product->is_active) {
                return response()->json([
                    'success' => false,
                    'message' => 'Product is not available',
                ], 400);
            }

            if ($product->stock < $request->quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock available',
                ], 400);
            }

            $cartItem = Cart::updateOrCreate(
                [
                    'user_id' => $request->user()->id,
                    'product_id' => $request->product_id,
                ],
                [
                    'quantity' => $request->quantity,
                    'price' => $product->price,
                ]
            );

            $cartItem->load('product');

            return response()->json([
                'success' => true,
                'message' => 'Product added to cart',
                'data' => $cartItem,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to add product to cart',
            ], 500);
        }
    }

    public function update(Request $request, Cart $cart): JsonResponse
    {
        if ($cart->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $product = $cart->product;

            if ($product->stock < $request->quantity) {
                return response()->json([
                    'success' => false,
                    'message' => 'Insufficient stock available',
                ], 400);
            }

            $cart->update([
                'quantity' => $request->quantity,
                'price' => $product->price, // Update price in case it changed
            ]);

            $cart->load('product');

            return response()->json([
                'success' => true,
                'message' => 'Cart item updated',
                'data' => $cart,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update cart item',
            ], 500);
        }
    }

    public function destroy(Request $request, Cart $cart): JsonResponse
    {
        if ($cart->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        try {
            $cart->delete();

            return response()->json([
                'success' => true,
                'message' => 'Item removed from cart',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to remove item from cart',
            ], 500);
        }
    }

    public function clear(Request $request): JsonResponse
    {
        try {
            Cart::where('user_id', $request->user()->id)->delete();

            return response()->json([
                'success' => true,
                'message' => 'Cart cleared',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to clear cart',
            ], 500);
        }
    }
}
