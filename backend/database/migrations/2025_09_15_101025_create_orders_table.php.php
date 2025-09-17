
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
	/**
	 * Run the migrations.
	 */
	public function up(): void
	{
		Schema::create('orders', function (Blueprint $table) {
			$table->id();
			$table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
			$table->enum('status', ['pending','paid','shipped','delivered','cancelled'])->default('pending');
			$table->decimal('total', 12, 2)->default(0);
			$table->string('payment_status')->nullable();
			$table->string('payment_ref')->nullable();
			$table->foreignId('billing_address_id')->nullable()->constrained('addresses')->nullOnDelete();
			$table->foreignId('shipping_address_id')->nullable()->constrained('addresses')->nullOnDelete();
			$table->timestamps();

			$table->index('user_id');
			$table->index('status');
		});
	}

	/**
	 * Reverse the migrations.
	 */
	public function down(): void
	{
		Schema::dropIfExists('orders');
	}
};

