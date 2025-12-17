# Shopily - AI Coding Agent Instructions

## Project Overview
Shopily is a Flutter e-commerce mobile app for browsing and purchasing clothing items (jackets, shirts, jeans). The app uses **GetX** for state management and navigation, with a focus on visual polish through animations and carousels.

## Architecture & State Management

### GetX Global Controller Pattern
- **`BuyerPurchaseController`** is initialized globally in `main.dart` using `Get.put()` in `initState()`
- Access cart state anywhere with `Get.find<BuyerPurchaseController>()`
- Cart items use `.obs` (observable) lists that automatically update UI via `Obx()` widgets
- **Never create new controller instances** - always use `Get.find<>()`

### Navigation Flow
1. `SplashScreen` (3s auto-advance with fade animation)
2. `WelcomeScreen` (carousel intro with "Get Started" button)
3. `SignupScreen` → `LoginScreen` → `DashboardScreen`
4. `DashboardScreen` hosts bottom nav with 3 tabs: `HomeScreen`, `CartScreen`, `ProfileScreen`
5. `CartScreen` → `CheckoutScreen` (payment & delivery details)

### Screen Responsibilities
- **`HomeScreen`**: Dynamic greeting (Good Morning/Afternoon/Evening), favorites & notifications icons, product grid with category filtering (All/Jackets/Shirts/Jeans), search bar, banner carousel
- **`ProductDetailScreen`**: Hero animation from grid, quantity picker, cart icon with badge, "Add to Cart" button with flying animation
- **`CartScreen`**: Displays `BuyerPurchase` items with delete functionality, calculates total with `Obx()`, checkout navigates to `CheckoutScreen`
- **`CheckoutScreen`**: Delivery address input, order summary with delivery fee, payment method selection (6 options), place order button
- **`DashboardScreen`**: Manages `_selectedIndex` state for bottom navigation with cart badge

## Key Data Structures

### BuyerPurchase Model (`lib/variables/buyer_vars.dart`)
```dart
BuyerPurchase(
  buyerName: String,
  purchaseDate: DateTime,
  purchasedItems: List<Map<String, dynamic>>, // [{"title": "...", "price": "..."}]
  totalPrice: double,
  pimage: String,  // Asset path for product image
  checkout: bool   // Hides item in cart when true
)
```

## Critical Patterns & Conventions

### Asset Management
- All images in `assets/` root (no subfolders): `assets/shopily.png`, `assets/jack1.png`, etc.
- Reference as `Image.asset('assets/filename.png')` or `AssetImage('assets/filename.png')`
- Product data uses hardcoded lists of maps: `{"image": "assets/...", "title": "...", "price": "\$..."}`

### Animations
- **Hero animations**: Product grid → detail screen using image path as tag
- **Staggered grid animations**: `flutter_staggered_animations` package in `HomeScreen`
- **Carousel autoplay**: 3-second intervals for banners (`carousel_slider` package)
- **Flying cart animation**: When adding items to cart, a scaled-down product image flies from the "Add to Cart" button to the cart icon at the bottom with a smooth curve animation (800ms duration)
- Reset animations by updating `GlobalKey` state when category changes

### Cart Badge
- Bottom navigation cart icon displays a red circular badge showing the count of items in cart
- Badge updates reactively using `Obx()` wrapper to track `buyerPurchases` list
- Only counts items where `checkout == false`
- Badge automatically hides when cart is empty

### UI Styling Conventions
- Primary color: `Colors.brown` (buttons, accents)
- Background: `Colors.white` throughout
- Card shadows: `Colors.grey.withOpacity(0.3)`, `blurRadius: 10`
- Border radius: 10-15px for containers, 30px for search bar, 20px for product images
- Use `CircleAvatar` with transparent background for icon buttons over images

### Price Handling
- Prices stored as strings with `$` prefix: `"\$120"`
- Parse with `int.parse(price.replaceAll('\$', ''))` for calculations
- Display totals: `"\$$totalPrice"` (no decimal formatting)

## Development Workflows

### Running the App
```bash
flutter pub get              # Install dependencies
flutter run                  # Launch on connected device/emulator
flutter run -d chrome        # Web testing (if needed)
```

### Testing
- Default test in `test/widget_test.dart` is **outdated** (expects counter app)
- Update tests to match `SplashScreen` as entry point, not counter functionality
- No integration tests currently exist

### Code Quality
- Uses `flutter_lints` with default rules (see `analysis_options.yaml`)
- Fix all lint issues before committing: `flutter analyze`
- Format with: `flutter format lib/`

## Common Modifications

### Adding New Products
1. Add image to `assets/` folder
2. Update `pubspec.yaml` if adding new asset directories (currently uses `assets/` wildcard)
3. Add entry to product list in `HomeScreen`: `{"image": "assets/new.png", "title": "...", "price": "\$..."}`

### Adding Cart Items
```dart
final controller = Get.find<BuyerPurchaseController>();
controller.addBuyerPurchase(BuyerPurchase(
  buyerName: "User",
  purchaseDate: DateTime.now(),
  purchasedItems: [{"title": title, "price": price}],
  totalPrice: double.parse(price.replaceAll('\$', '')),
  pimage: imagePath,
));
```

### Category Filtering Pattern
See `HomeScreen.updateDisplayedItems()` - uses `setState()` to rebuild grid and reset animation key. Categories are hardcoded lists (`jackets`, `shirts`, `jeans`).

## External Dependencies
- **get**: 4.6.6 (state management, navigation)
- **carousel_slider**: 5.0.0 (banner carousels)
- **flutter_staggered_animations**: 1.1.0 (grid item animations)
- **cupertino_icons**: 1.0.8 (iOS-style icons)

## Known Limitations & TODOs
- No backend integration - all data is hardcoded
- No actual authentication logic (login/signup are UI-only)
- Cart checkout doesn't persist or process payments
- Profile screen functionality not implemented
- Search bar in `HomeScreen` is non-functional
- Price calculations assume integer dollar amounts (no cents)

## Important: When Making Changes
- **Always use GetX navigation**: `Get.to()`, `Get.back()` instead of `Navigator` methods for consistency
- **Preserve Hero tags**: Match image paths exactly between grid and detail screens
- **Test category switching**: Ensure animations reset properly via `_animationLimiterKey`
- **Verify cart reactivity**: Changes to `buyerPurchases` should auto-update totals via `Obx()`
