import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopily/variables/buyer_vars.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPaymentMethod = 'Credit Card';
  final TextEditingController locationController = TextEditingController(
    text: '123 Main Street, New York, NY 10001',
  );

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Debit Card', 'icon': Icons.credit_card},
    {'name': 'PayPal', 'icon': Icons.account_balance_wallet},
    {'name': 'Apple Pay', 'icon': Icons.apple},
    {'name': 'Google Pay', 'icon': Icons.payment},
    {'name': 'Cash on Delivery', 'icon': Icons.money},
  ];

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerPurchaseController>();
    final activeItems =
        controller.buyerPurchases.where((p) => !p.checkout).toList();
    final totalPrice = activeItems.fold<int>(
      0,
      (sum, purchase) => sum + purchase.totalPrice.toInt(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Location Section
              const Text(
                'Delivery To:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.brown),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: locationController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter delivery address',
                        ),
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.brown, size: 20),
                      onPressed: () {
                        // Edit location logic
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Order Summary Section
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Items', style: TextStyle(fontSize: 14)),
                        Text('${activeItems.length}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(fontSize: 14)),
                        Text('\$$totalPrice',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee',
                            style: TextStyle(fontSize: 14)),
                        Text('\$10', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${totalPrice + 10}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Method Section
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ...paymentMethods.map((method) {
                final isSelected = selectedPaymentMethod == method['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = method['name'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.brown.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? Colors.brown : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          method['icon'],
                          color: isSelected ? Colors.brown : Colors.grey[600],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            method['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.brown : Colors.black,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.brown),
                      ],
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Place order logic
                    for (var purchase in controller.buyerPurchases) {
                      if (!purchase.checkout) {
                        purchase.checkout = true;
                      }
                    }
                    controller.buyerPurchases.refresh();

                    Get.snackbar(
                      'Success',
                      'Order placed successfully! Payment method: $selectedPaymentMethod',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(10),
                    );

                    // Navigate back to dashboard home screen
                    Future.delayed(const Duration(milliseconds: 1500), () {
                      Get.until((route) => route.isFirst);
                    });
                  },
                  child: const Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
