import 'package:get/get.dart';

class BuyerPurchase {
  final String buyerName;
  final DateTime purchaseDate;
  final List<Map<String, dynamic>> purchasedItems; // List of items with prices
  final double totalPrice;
  final String pimage;
  bool checkout;

  BuyerPurchase({
    required this.buyerName,
    required this.purchaseDate,
    required this.purchasedItems,
    required this.totalPrice,
    required this.pimage,
    this.checkout = false,
  });
}

class BuyerPurchaseController extends GetxController {
  var buyerPurchases = <BuyerPurchase>[].obs;

  // Add a new purchase to the list
  void addBuyerPurchase(BuyerPurchase purchase) {
    buyerPurchases.add(purchase);
  }

  // Clear all purchases
  void clearPurchases() {
    buyerPurchases.clear();
  }

  // Mark the purchase as checked out
  void checkoutPurchase(int index) {
    buyerPurchases[index].checkout = true;
    update(); // Notify listeners to update the UI
  }
}
