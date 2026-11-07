// =============================================================================
// Project: PC16 Milestone 2 - Dart Logic Practical & OOP Master Integration
// Author: John Carlo Macabangon
// Course: BSIT - Mobile Development with Lab (National Teachers College)
// Description: Unifies fundamentals, error handling, encapsulation, 
//              inheritance, polymorphism, abstract contracts, mixins, and 
//              asynchronous operations into a robust IT Hardware Management system.
// =============================================================================

import 'dart:async';

// -----------------------------------------------------------------------------
// MIXIN: Reusable capability ('Discountable') shared outside the main hierarchy
// Why: Keeps discounting logic modular and DRY (Don't Repeat Yourself).
// -----------------------------------------------------------------------------
mixin Discountable {
  double calculateDiscountedPrice(double originalPrice, double discountRate) {
    // Validates rate bounds to maintain safe financial calculation integrity
    if (discountRate < 0 || discountRate > 1.0) {
      print("Warning: Invalid discount rate applied.");
      return originalPrice;
    }
    return originalPrice - (originalPrice * discountRate);
  }
}

// -----------------------------------------------------------------------------
// ABSTRACT CLASS: 'Auditable' interface contract
// Why: Enforces system-wide security and database compliance protocols.
// -----------------------------------------------------------------------------
abstract class Auditable {
  String auditCompliance();
}

// -----------------------------------------------------------------------------
// BASE CLASS: 'HardwareComponent'
// Why: Serves as the foundational template modeling standard inventory items.
// -----------------------------------------------------------------------------
class HardwareComponent {
  String brand;
  String model;
  double _price; // Encapsulated private field for data security

  // Constructor with shorthand field initialization
  HardwareComponent(this.brand, this.model, this._price);

  // Getter for safe read access to encapsulated price
  double get price => _price;

  // Setter with logic validation to prevent zero or negative price anomalies
  set price(double newPrice) {
    if (newPrice > 0) {
      _price = newPrice;
    } else {
      print("Error: Component price must be greater than zero.");
    }
  }

  // Base behavior method designed for method overriding (Polymorphism)
  void displayDetails() {
    print("Base Hardware: $brand $model | Price: PHP ${_price.toStringAsFixed(2)}");
  }
}

// -----------------------------------------------------------------------------
// DERIVED CLASS: 'Processor' (Inherits HardwareComponent, implements Auditable)
// Why: Specializes inventory tracking specifically for central processing units.
// -----------------------------------------------------------------------------
class Processor extends HardwareComponent implements Auditable {
  int coreCount;
  double clockSpeedGhz;

  Processor(String brand, String model, double price, this.coreCount, this.clockSpeedGhz)
      : super(brand, model, price);

  // POLYMORPHISM: Overrides base method to display specific CPU attributes
  @override
  void displayDetails() {
    print("Processor [CPU]: $brand $model | Cores: $coreCount | Clock: ${clockSpeedGhz}GHz | Price: PHP ${_price.toStringAsFixed(2)}");
  }

  // Mandatory implementation of the abstract Auditable contract
  @override
  String auditCompliance() {
    return "Compliance [CPU]: Verified secure hardware virtualization & safety standards.";
  }

  // ASYNCHRONOUS METHOD: Simulates non-blocking cloud server synchronization
  // Why: Prevents app freezing during heavy remote database commits.
  Future<String> saveRecordToCloudAsync(String quantityStr) async {
    print(" -> [Async Sync Started]: Packaging batch record for $brand $model...");
    
    // ERROR HANDLING & LOGIC: Try/catch block parsing string inputs safely
    try {
      int parsedQty = int.parse(quantityStr);
      if (parsedQty < 0) throw Exception("Quantity cannot be negative.");

      // Simulating a 2-second network latency delay without blocking main thread
      await Future.delayed(Duration(seconds: 2));

      double batchTotal = _price * parsedQty;
      return " -> [Async Sync Complete]: Synced $brand $model ($parsedQty units). Total Valuation: PHP ${batchTotal.toStringAsFixed(2)}";
      
    } catch (e) {
      return "Error Handled Gracefully: Failed to parse stock quantity string ('$quantityStr'). Details: $e";
    }
  }
}

// -----------------------------------------------------------------------------
// ACCESSORY CLASS: Incorporates the Discountable mixin
// Why: Manages peripheral promotions without bloating the core hardware tree.
// -----------------------------------------------------------------------------
class Accessory with Discountable {
  String itemName;
  double basePrice;

  Accessory(this.itemName, this.basePrice);

  void displayPromoPricing() {
    double promoCost = calculateDiscountedPrice(basePrice, 0.15); // 15% discount
    print("Accessory Promo: $itemName | Regular: PHP ${basePrice.toStringAsFixed(2)} | Promo Cost: PHP ${promoCost.toStringAsFixed(2)}");
  }
}

// -----------------------------------------------------------------------------
// MAIN ENTRY POINT: Execution flow coordination
// -----------------------------------------------------------------------------
void main() async {
  print('=============================================================');
  print('    PC16 Milestone 2: Integrated IT Inventory System         ');
  print('=============================================================\n');

  // 1. Instantiate Object Hierarchy
  Processor primaryCpu = Processor("AMD", "Ryzen 5 5600", 6500.00, 6, 3.7);
  Accessory promoItem = Accessory("Mechanical Keyboard", 1800.00);

  // 2. Demonstrate Polymorphism & Contracts
  print('--- Component Inspection & Compliance Audit ---');
  primaryCpu.displayDetails();
  print(primaryCpu.auditCompliance());

  print('');
  promoItem.displayPromoPricing();

  // 3. Demonstrate Asynchronous Operations & Non-Blocking Execution Flow
  print('\n--- Asynchronous Database Transaction Test ---');
  
  // Trigger async future (non-blocking)
  Future<String> transactionFuture = primaryCpu.saveRecordToCloudAsync("12");

  // Prove non-blocking concurrency: this statement executes immediately while async runs
  print(" [Main Thread UI]: System remains responsive, rendering user logs while cloud sync executes...");

  // Await and resolve the asynchronous result
  String transactionResult = await transactionFuture;
  print(transactionResult);

  print('\n=============================================================');
  print('        Milestone 2 Practical Execution Complete             ');
  print('=============================================================');
}
