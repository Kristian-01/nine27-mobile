<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Add processed_at to orders
        if (!Schema::hasColumn('orders', 'processed_at')) {
            Schema::table('orders', function (Blueprint $table) {
                $table->timestamp('processed_at')->nullable()->after('status');
            });
        }

        // Add avatar to users
        if (!Schema::hasColumn('users', 'avatar')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('avatar')->nullable()->after('address');
            });
        }

        // Create order_status_logs table
        if (!Schema::hasTable('order_status_logs')) {
            Schema::create('order_status_logs', function (Blueprint $table) {
                $table->id();
                $table->foreignId('order_id')->constrained('orders')->onDelete('cascade');
                $table->string('status'); // e.g., pending, processing, shipped, delivered, cancelled
                $table->text('note')->nullable();
                $table->timestamp('changed_at')->useCurrent();
                $table->timestamps();

                $table->index(['order_id', 'status']);
            });
        }
    }

    public function down(): void
    {
        // Drop order_status_logs table
        if (Schema::hasTable('order_status_logs')) {
            Schema::dropIfExists('order_status_logs');
        }

        // Remove avatar from users
        if (Schema::hasColumn('users', 'avatar')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('avatar');
            });
        }

        // Remove processed_at from orders
        if (Schema::hasColumn('orders', 'processed_at')) {
            Schema::table('orders', function (Blueprint $table) {
                $table->dropColumn('processed_at');
            });
        }
    }
};
