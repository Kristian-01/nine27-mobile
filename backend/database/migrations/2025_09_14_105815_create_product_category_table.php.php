
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
	public function up(): void
	{
		Schema::table('users', function (Blueprint $table) {
			$table->index('email');
		});

		Schema::table('products', function (Blueprint $table) {
			$table->index('slug');
		});

		Schema::table('categories', function (Blueprint $table) {
			$table->index('slug');
		});
	}

	public function down(): void
	{
		Schema::table('users', function (Blueprint $table) {
			$table->dropIndex(['email']);
		});

		Schema::table('products', function (Blueprint $table) {
			$table->dropIndex(['slug']);
		});

		Schema::table('categories', function (Blueprint $table) {
			$table->dropIndex(['slug']);
		});
	}
};

