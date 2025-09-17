
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
		Schema::create('payments', function (Blueprint $table) {
			$table->id();
			$table->foreignId('order_id')->constrained('orders')->cascadeOnDelete();
			$table->decimal('amount', 12, 2);
			$table->string('method')->nullable();
			$table->string('status')->default('pending');
			$table->string('transaction_id')->nullable();
			$table->timestamp('paid_at')->nullable();
			$table->timestamps();

			$table->index('order_id');
			$table->index('transaction_id');
		});
	}

	/**
	 * Reverse the migrations.
	 */
	public function down(): void
	{
		Schema::dropIfExists('payments');
	}
};
