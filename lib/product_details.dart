import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopily/cart.dart';
import 'package:shopily/dashboard.dart';
import 'package:shopily/variables/buyer_vars.dart';

class ProductDetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String price;

  const ProductDetailScreen({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  bool _showAnimation = false;
  Offset _startPosition = Offset.zero;
  final GlobalKey _cartIconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showAnimation = false;
        });
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFlyingAnimation(BuildContext context) {
    // Get the position of the button
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);

    // Get cart icon position
    final RenderBox? cartBox =
        _cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset endPosition = cartBox != null
        ? cartBox.localToGlobal(Offset.zero)
        : Offset(MediaQuery.of(context).size.width - 100, 40);

    setState(() {
      _startPosition = buttonPosition;
      _showAnimation = true;
    });

    _positionAnimation = Tween<Offset>(
      begin: _startPosition,
      end: endPosition,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: widget.image,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                        child: Image.asset(
                          widget.image,
                          height: 500,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                key: _cartIconKey,
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black,
                                    ),
                                    Obx(() {
                                      final controller =
                                          Get.find<BuyerPurchaseController>();
                                      final itemCount = controller
                                          .buyerPurchases
                                          .where(
                                              (purchase) => !purchase.checkout)
                                          .length;
                                      if (itemCount == 0)
                                        return const SizedBox.shrink();
                                      return Positioned(
                                        right: -4,
                                        top: -4,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 16,
                                            minHeight: 16,
                                          ),
                                          child: Text(
                                            itemCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Quantity controls
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey[200],
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey[200],
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "\$${(int.parse(widget.price.replaceAll('\$', '')) * quantity).toString()}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Product description",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const Spacer(),
                        Builder(
                          builder: (buttonContext) => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                // Start flying animation
                                _startFlyingAnimation(buttonContext);

                                // Add item to cart after short delay
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  Get.find<BuyerPurchaseController>()
                                      .addBuyerPurchase(
                                    BuyerPurchase(
                                      buyerName: "John Doe",
                                      purchaseDate: DateTime.now(),
                                      purchasedItems: [
                                        {
                                          "title": widget.title,
                                          "price": widget.price,
                                          "quantity": quantity,
                                        },
                                      ],
                                      totalPrice: quantity *
                                          double.parse(widget.price
                                              .replaceAll('\$', '')),
                                      pimage: widget.image,
                                    ),
                                  );
                                });
                              },
                              child: const Text(
                                "Add To Cart",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Flying animation overlay
        if (_showAnimation)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: _positionAnimation.value.dx,
                top: _positionAnimation.value.dy,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const ColorOption({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.black : Colors.grey,
          width: 2,
        ),
      ),
    );
  }
}
