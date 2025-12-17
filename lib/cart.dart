import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopily/checkout_screen.dart';
import 'package:shopily/variables/buyer_vars.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final controller = Get.find<BuyerPurchaseController>();
                final buyerPurchases = controller.buyerPurchases;

                // Filter out checked out items
                final activeItems =
                    buyerPurchases.where((p) => !p.checkout).toList();

                // Show empty cart message if no items
                if (activeItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: activeItems.length,
                  itemBuilder: (context, index) {
                    final purchase = activeItems[index];

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(purchase.pimage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Title and Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    purchase.purchasedItems.isNotEmpty &&
                                            purchase.purchasedItems[0]
                                                    ['title'] !=
                                                null
                                        ? purchase.purchasedItems[0]['title']
                                        : 'No Title',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    purchase.purchasedItems.isNotEmpty &&
                                            purchase.purchasedItems[0]
                                                    ['price'] !=
                                                null
                                        ? "${purchase.purchasedItems[0]['price']}"
                                        : 'No Price',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (purchase.purchasedItems.isNotEmpty &&
                                      purchase.purchasedItems[0]['quantity'] !=
                                          null)
                                    Text(
                                      "Qty: ${purchase.purchasedItems[0]['quantity']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Remove Button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                final actualIndex =
                                    buyerPurchases.indexOf(purchase);
                                controller.buyerPurchases.removeAt(actualIndex);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            // Total Price Section
            Obx(() {
              final controller = Get.find<BuyerPurchaseController>();
              final buyerPurchases = controller.buyerPurchases;
              final totalPrice = buyerPurchases.fold<int>(
                0,
                (sum, purchase) =>
                    sum + (purchase.checkout ? 0 : purchase.totalPrice.toInt()),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "\$$totalPrice",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  final controller = Get.find<BuyerPurchaseController>();
                  final activeItems = controller.buyerPurchases
                      .where((p) => !p.checkout)
                      .toList();

                  if (activeItems.isEmpty) {
                    Get.snackbar(
                      'Cart Empty',
                      'Please add items to cart before checkout',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(10),
                    );
                    return;
                  }

                  // Navigate to checkout screen
                  Get.to(() => CheckoutScreen());
                },
                child: const Text(
                  "Checkout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
