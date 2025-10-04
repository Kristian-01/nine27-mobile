<?php

// app/Http/Controllers/Api/OrderController.php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Cart;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class OrderController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        try {
            $orders = Order::where('user_id', $request->user()->id)
                ->with('orderItems.product')
                ->orderBy('created_at', 'desc')
                ->paginate(10);

            return response()->json([
                'success' => true,
                'data' => $orders,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch orders',
            ], 500);
        }
    }

    public function show(Request $request, Order $order): JsonResponse
    {
        if ($order->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        try {
            $order->load('orderItems.product');

            return response()->json([
                'success' => true,
                'data' => $order,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Order not found',
            ], 404);
        }
    }

    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'billing_address' => 'required|array',
            'billing_address.name' => 'required|string',
            'billing_address.phone' => 'required|string',
            'billing_address.address' => 'required|string',
            'billing_address.city' => 'required|string',
            'billing_address.postal_code' => 'required|string',
            'shipping_address' => 'required|array',
            'shipping_address.name' => 'required|string',
            'shipping_address.phone' => 'required|string',
            'shipping_address.address' => 'required|string',
            'shipping_address.city' => 'required|string',
            'shipping_address.postal_code' => 'required|string',
            'payment_method' => 'required|string',
            // Optional client-provided items; if present, must be valid
            'items' => 'nullable|array|min:1',
            'items.*.product_id' => 'required_with:items|integer|exists:products,id',
            'items.*.quantity' => 'required_with:items|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            return DB::transaction(function () use ($request) {
                $user = $request->user();

                $requestItems = $request->input('items', []);
                $useRequestItems = is_array($requestItems) && count($requestItems) > 0;

                if ($useRequestItems) {
                    // Map quantities by product_id
                    $qtyById = [];
                    foreach ($requestItems as $it) {
                        $pid = (int) $it['product_id'];
                        $qty = (int) $it['quantity'];
                        $qtyById[$pid] = ($qtyById[$pid] ?? 0) + $qty;
                    }

                    $products = Product::whereIn('id', array_keys($qtyById))->get();
                    if ($products->count() !== count($qtyById)) {
                        return response()->json([
                            'success' => false,
                            'message' => 'Some products not found',
                        ], 400);
                    }

                    // Check stock and compute totals
                    $subtotal = 0;
                    foreach ($products as $product) {
                        $q = $qtyById[$product->id];
                        if ($product->stock < $q) {
                            return response()->json([
                                'success' => false,
                                'message' => "Insufficient stock for {$product->name}",
                            ], 400);
                        }
                        $subtotal += ($product->price * $q);
                    }

                    $taxAmount = $subtotal * 0.1; // 10% tax
                    $shippingAmount = $subtotal > 100 ? 0 : 10; // Free shipping over $100
                    $totalAmount = $subtotal + $taxAmount + $shippingAmount;

                    // Create order
                    $order = Order::create([
                        'user_id' => $user->id,
                        'subtotal' => $subtotal,
                        'tax_amount' => $taxAmount,
                        'shipping_amount' => $shippingAmount,
                        'total_amount' => $totalAmount,
                        'billing_address' => $request->billing_address,
                        'shipping_address' => $request->shipping_address,
                        'payment_method' => $request->payment_method,
                    ]);

                    // Create order items and update stock
                    foreach ($products as $product) {
                        $q = $qtyById[$product->id];
                        OrderItem::create([
                            'order_id' => $order->id,
                            'product_id' => $product->id,
                            'quantity' => $q,
                            'unit_price' => $product->price,
                            'total_price' => $product->price * $q,
                            'product_snapshot' => $product->toArray(),
                        ]);
                        $product->decrement('stock', $q);
                    }

                    $order->load('orderItems.product');

                    return response()->json([
                        'success' => true,
                        'message' => 'Order placed successfully',
                        'data' => $order,
                    ], 201);
                }

                // Fallback to server-side cart if no client-provided items
                $cartItems = Cart::where('user_id', $user->id)->with('product')->get();

                if ($cartItems->isEmpty()) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Cart is empty',
                    ], 400);
                }

                // Check stock availability
                foreach ($cartItems as $item) {
                    if ($item->product->stock < $item->quantity) {
                        return response()->json([
                            'success' => false,
                            'message' => "Insufficient stock for {$item->product->name}",
                        ], 400);
                    }
                }

                // Calculate totals
                $subtotal = $cartItems->sum('total_price');
                $taxAmount = $subtotal * 0.1; // 10% tax
                $shippingAmount = $subtotal > 100 ? 0 : 10; // Free shipping over $100
                $totalAmount = $subtotal + $taxAmount + $shippingAmount;

                // Create order
                $order = Order::create([
                    'user_id' => $user->id,
                    'subtotal' => $subtotal,
                    'tax_amount' => $taxAmount,
                    'shipping_amount' => $shippingAmount,
                    'total_amount' => $totalAmount,
                    'billing_address' => $request->billing_address,
                    'shipping_address' => $request->shipping_address,
                    'payment_method' => $request->payment_method,
                ]);

                // Create order items and update stock
                foreach ($cartItems as $item) {
                    OrderItem::create([
                        'order_id' => $order->id,
                        'product_id' => $item->product_id,
                        'quantity' => $item->quantity,
                        'unit_price' => $item->price,
                        'total_price' => $item->total_price,
                        'product_snapshot' => $item->product->toArray(),
                    ]);

                    // Update product stock
                    $item->product->decrement('stock', $item->quantity);
                }

                // Clear cart
                Cart::where('user_id', $user->id)->delete();

                $order->load('orderItems.product');

                return response()->json([
                    'success' => true,
                    'message' => 'Order placed successfully',
                    'data' => $order,
                ], 201);
            });
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to place order',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function cancel(Request $request, Order $order): JsonResponse
    {
        if ($order->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized',
            ], 403);
        }

        if ($order->status !== 'pending') {
            return response()->json([
                'success' => false,
                'message' => 'Cannot cancel order with current status',
            ], 400);
        }

        try {
            return DB::transaction(function () use ($order) {
                // Restore stock
                foreach ($order->orderItems as $item) {
                    $item->product->increment('stock', $item->quantity);
                }

                $order->update(['status' => 'cancelled']);

                return response()->json([
                    'success' => true,
                    'message' => 'Order cancelled successfully',
                    'data' => $order,
                ]);
            });
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to cancel order',
            ], 500);
        }
    }
}