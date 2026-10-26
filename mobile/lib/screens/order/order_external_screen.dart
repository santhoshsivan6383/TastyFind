import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../widgets/rating_badge.dart';
import '../../widgets/price_tag.dart';
import '../../widgets/tasty_image.dart';
import '../../providers/food_providers.dart';

class OrderExternalScreen extends ConsumerWidget {
  final int dishId;
  final int restaurantId;

  const OrderExternalScreen({
    super.key,
    required this.dishId,
    required this.restaurantId,
  });

  Future<void> _launchOrderingUrl(
    BuildContext context,
    String platform,
    String url,
    String dishName,
    String restaurantName,
  ) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (context.mounted) {
        context.push(
          '/order-redirect?platform=$platform&dishName=${Uri.encodeComponent(dishName)}&restaurantName=${Uri.encodeComponent(restaurantName)}&dishId=$dishId&restaurantId=$restaurantId',
        );
      }
    } catch (_) {
      if (context.mounted) {
        // Even if browser/app launch fails, proceed to confirmation
        context.push(
          '/order-redirect?platform=$platform&dishName=${Uri.encodeComponent(dishName)}&restaurantName=${Uri.encodeComponent(restaurantName)}&dishId=$dishId&restaurantId=$restaurantId',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishAsync = ref.watch(dishDetailsProvider(dishId));
    final restaurantAsync = ref.watch(restaurantDetailsProvider(restaurantId));
    final savedState = ref.watch(savedFavoritesProvider);

    final dish = dishAsync.value;
    final restaurant = restaurantAsync.value;

    final dishName = dish?.name ?? 'Masala Dosa';
    final restName = restaurant?.name ?? (dish?.restaurantName.isNotEmpty == true ? dish!.restaurantName : 'Hotel Sri Murugan');
    final price = dish?.currentPrice ?? 70.0;
    final isDishSaved = dish != null && savedState.isDishSaved(dish.id);

    // Verified Platform Links
    const swiggyUrl = 'https://www.swiggy.com/restaurants/hotel-sri-murugan-erode';
    const zomatoUrl = 'https://www.zomato.com/erode/hotel-sri-murugan';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Order Now'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selected Restaurant Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    TastyImage(
                      imageUrl: restaurant?.coverImageUrl,
                      width: 58,
                      height: 58,
                      borderRadius: BorderRadius.circular(10),
                      fallbackAsset: 'assets/images/restaurant_1.jpg',
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepCharcoal,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              RatingBadge(rating: restaurant?.overallRating ?? 4.8, reviewCount: 1200),
                              const SizedBox(width: 6),
                              const Text('•', style: TextStyle(color: AppColors.textMuted)),
                              const SizedBox(width: 6),
                              Text(
                                '${restaurant?.distanceKm ?? 0.8} km',
                                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            restaurant?.priceRangeFormatted ?? '₹60 – ₹90',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dish Details Line
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dishName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepCharcoal,
                      ),
                    ),
                    PriceTag(price: price, fontSize: 17),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Order Through section
              const Text(
                'Order through',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepCharcoal,
                ),
              ),
              const SizedBox(height: 14),

              // Swiggy Button (Orange)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _launchOrderingUrl(context, 'Swiggy', swiggyUrl, dishName, restName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.swiggyOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.delivery_dining_rounded, size: 22),
                  label: const Text(
                    'Swiggy',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Zomato Button (Red)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _launchOrderingUrl(context, 'Zomato', zomatoUrl, dishName, restName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.zomatoRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.lunch_dining_rounded, size: 22),
                  label: const Text(
                    'zomato',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle redirection note
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textMuted),
                    SizedBox(width: 6),
                    Text(
                      "You'll be redirected to the app",
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Save to wishlist link
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    if (dish != null) {
                      ref.read(savedFavoritesProvider.notifier).toggleDish(dish);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isDishSaved ? 'Removed from Wishlist' : 'Saved to Wishlist!')),
                      );
                    }
                  },
                  icon: Icon(
                    isDishSaved ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
                    color: AppColors.primaryOrange,
                    size: 18,
                  ),
                  label: Text(
                    isDishSaved ? 'Dish saved in wishlist' : 'Not ordering? Save to wish list',
                    style: const TextStyle(
                      color: AppColors.primaryOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
