<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ImportProductsCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'products:import {file : Path to the CSV file}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import products from CSV file into the database';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $filePath = $this->argument('file');
        
        if (!file_exists($filePath)) {
            $this->error("File not found: {$filePath}");
            return 1;
        }

        $this->info("Starting import from {$filePath}");
        
        try {
            // Open the CSV file
            $file = fopen($filePath, 'r');
            
            // Skip header rows (first 57 lines based on CSV analysis)
            for ($i = 0; $i < 57; $i++) {
                fgetcsv($file);
            }
            
            $importCount = 0;
            $errorCount = 0;
            
            // Process product data
            while (($data = fgetcsv($file)) !== false) {
                // Skip empty rows or section headers
                if (empty($data[0]) || count($data) < 3 || $data[0] === 'Total' || $data[0] === 'Inventory') {
                    continue;
                }
                
                // Extract product data
                $name = trim($data[0], '"');
                $stock = is_numeric($data[2]) ? (int)$data[2] : 0;
                $price = 0;
                
                // For items in the "Item" section, column 2 contains price
                if (is_numeric($data[2])) {
                    $price = (float)$data[2];
                }
                
                // Determine category based on product name or other attributes
                $category = $this->determineCategory($name);
                
                try {
                    // Insert into database
                    DB::table('products')->updateOrInsert(
                        ['name' => $name],
                        [
                            'description' => '',
                            'price' => $price,
                            'stock' => $stock,
                            'category' => $category,
                            'updated_at' => now(),
                            'created_at' => now(),
                        ]
                    );
                    
                    $importCount++;
                    $this->info("Imported: {$name}");
                } catch (\Exception $e) {
                    $this->error("Error importing product {$name}: " . $e->getMessage());
                    Log::error("Error importing product {$name}: " . $e->getMessage(), [
                        'product' => $name,
                        'price' => $price,
                        'stock' => $stock,
                        'category' => $category
                    ]);
                    $errorCount++;
                }
            }
            
            fclose($file);
            
            $this->info("Import completed: {$importCount} products imported, {$errorCount} errors");
            return 0;
        } catch (\Exception $e) {
            $this->error("Import failed: " . $e->getMessage());
            Log::error("Import failed: " . $e->getMessage());
            return 1;
        }
    }
    
    /**
     * Determine product category based on name or other attributes
     */
    private function determineCategory($name)
    {
        $lowerName = strtolower($name);
        
        if (strpos($lowerName, 'tablet') !== false || strpos($lowerName, 'capsule') !== false) {
            return 'Medication';
        } elseif (strpos($lowerName, 'syrup') !== false || strpos($lowerName, 'suspension') !== false) {
            return 'Liquid Medication';
        } elseif (strpos($lowerName, 'cream') !== false || strpos($lowerName, 'ointment') !== false) {
            return 'Topical';
        } elseif (strpos($lowerName, 'diaper') !== false || strpos($lowerName, 'wipes') !== false) {
            return 'Baby Care';
        } elseif (strpos($lowerName, 'shampoo') !== false || strpos($lowerName, 'soap') !== false) {
            return 'Personal Care';
        } elseif (strpos($lowerName, 'ml') !== false || strpos($lowerName, 'liter') !== false) {
            return 'Beverages';
        } else {
            return 'General';
        }
    }
}