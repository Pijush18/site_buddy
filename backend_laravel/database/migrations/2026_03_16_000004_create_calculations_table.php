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
        Schema::create('calculations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('project_id')->constrained()->onDelete('cascade');
            $table->string('type'); // e.g., beam_design, slab_design
            $table->json('input_data');
            $table->json('result_data');
            $table->string('device_id')->nullable(); // For identifying client device
            $table->timestamp('synced_at')->nullable();
            $table->timestamps();
            
            // Index for efficient sync lookups
            $table->index(['user_id', 'device_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('calculations');
    }
};
