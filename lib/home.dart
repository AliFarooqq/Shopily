import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopily/product_details.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> carouselImages = [
    'assets/sbanner.png', // Replace with your image paths
    'assets/jkbanner.png',
    'assets/jbanner.png',
  ];

  // List of categories
  final List<Map<String, String>> jackets = [
    {"image": "assets/jack1.png", "title": "Brown Jacket", "price": "\$120"},
    {"image": "assets/jack2.png", "title": "Winter Jacket", "price": "\$150"},
    {"image": "assets/jack3.png", "title": "Black Jacket", "price": "\$130"},
    {"image": "assets/jack4.png", "title": "Leather Jacket", "price": "\$200"},
  ];

  final List<Map<String, String>> shirts = [
    {
      "image": "assets/shirt1.png",
      "title": "Blue Check shirt",
      "price": "\$50"
    },
    {"image": "assets/shirt2.png", "title": "White T-shirt", "price": "\$45"},
    {"image": "assets/shirt3.png", "title": "Blue shirt", "price": "\$50"},
    {"image": "assets/shirt4.png", "title": "Blue T-shirt", "price": "\$45"},
  ];

  final List<Map<String, String>> jeans = [
    {"image": "assets/jeans1.png", "title": "Blue Jeans", "price": "\$90"},
    {"image": "assets/jeans2.png", "title": "Black Jeans", "price": "\$95"},
    {"image": "assets/jeans3.png", "title": "Blue Jeans", "price": "\$70"},
    {"image": "assets/jeans4.png", "title": "Black Jeans", "price": "\$80"},
  ];

  List<Map<String, String>> displayedItems = [];
  String selectedCategory = "All";

  // Scroll controller for detecting scroll events
  final ScrollController _scrollController = ScrollController();

  // Key for AnimationLimiter to reset animations on category change
  final GlobalKey _animationLimiterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    displayedItems = [...jackets, ...shirts, ...jeans]; // Default to "All"
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  void updateDisplayedItems(String category) {
    setState(() {
      selectedCategory = category;
      if (category == "All") {
        displayedItems = [...jackets, ...shirts, ...jeans];
      } else if (category == "Jackets") {
        displayedItems = jackets;
      } else if (category == "Shirts") {
        displayedItems = shirts;
      } else if (category == "Jeans") {
        displayedItems = jeans;
      }

      // Reset the animation limiter key to trigger animations again
      _animationLimiterKey.currentState?.setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController, // Attach scroll controller
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              // Greeting and Icons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What are you looking for today?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.black),
                        onPressed: () {
                          // Navigate to favorites
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined,
                            color: Colors.black),
                        onPressed: () {
                          // Show notifications
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search clothes...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Carousel slider
              CarouselSlider(
                items: carouselImages.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
              ),
              SizedBox(height: 20),
              // Category selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryChip(
                    label: "All",
                    isSelected: selectedCategory == "All",
                    onTap: () => updateDisplayedItems("All"),
                  ),
                  CategoryChip(
                    label: "Jackets",
                    isSelected: selectedCategory == "Jackets",
                    onTap: () => updateDisplayedItems("Jackets"),
                  ),
                  CategoryChip(
                    label: "Shirts",
                    isSelected: selectedCategory == "Shirts",
                    onTap: () => updateDisplayedItems("Shirts"),
                  ),
                  CategoryChip(
                    label: "Jeans",
                    isSelected: selectedCategory == "Jeans",
                    onTap: () => updateDisplayedItems("Jeans"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Grid of items with animations
              AnimationLimiter(
                key: _animationLimiterKey, // Key to reset animations
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: displayedItems.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2, // Number of columns in the grid
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ItemCard(
                            image: displayedItems[index]['image']!,
                            title: displayedItems[index]['title']!,
                            price: displayedItems[index]['price']!,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ItemCard({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              image: image,
              title: title,
              price: price,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: image, // Unique tag for the Hero animation
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            price,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
