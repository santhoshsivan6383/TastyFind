import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/app_colors.dart';
import '../../widgets/rating_badge.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class RestaurantDetailsScreen extends ConsumerWidget {
  final int restaurantId;

  const RestaurantDetailsScreen({super.key, required this.restaurantId});

  Future<void> _makePhoneCall(String? phone, BuildContext context) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot place call to $phone')),
        );
      }
    }
  }

  Future<void> _openDirections(double lat, double lng, BuildContext context) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open map directions')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantAsync = ref.watch(restaurantDetailsProvider(restaurantId));
    final savedState = ref.watch(savedFavoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: restaurantAsync.when(
        data: (restaurant) {
          final isSaved = savedState.isRestaurantSaved(restaurant.id);

          return CustomScrollView(
            slivers: [
              // Hero AppBar with Cover Photo
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: AppColors.deepCharcoal,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.deepCharcoal, size: 20),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isSaved ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                        color: isSaved ? AppColors.primaryOrange : AppColors.deepCharcoal,
                        size: 20,
                      ),
                      onPressed: () => ref.read(savedFavoritesProvider.notifier).toggleRestaurant(restaurant),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: restaurant.coverImageUrl != null
                      ? Image.network(
                          restaurant.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.deepCharcoal),
                        )
                      : Container(color: AppColors.deepCharcoal),
                ),
              ),

              // Restaurant Information Body
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant Name
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.deepCharcoal,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Rating, Distance & Review Count
                      Row(
                        children: [
                          RatingBadge(
                            rating: restaurant.overallRating,
                            reviewCount: restaurant.overallReviewCount,
                            fontSize: 14,
                          ),
                          if (restaurant.distanceKm != null) ...[
                            const SizedBox(width: 8),
                            const Text('•', style: TextStyle(color: AppColors.textMuted)),
                            const SizedBox(width: 8),
                            Text(
                              '${restaurant.distanceKm} km',
                              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Price range & Cuisine
                      Text(
                        '${restaurant.priceRangeFormatted} • ${restaurant.cuisineType}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Badges
                      Wrap(
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.badgeBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '★ Best Overall for Dosa',
                              style: TextStyle(
                                color: AppColors.badgeText,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Highly Rated',
                              style: TextStyle(
                                color: AppColors.deepCharcoal,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons: Direction, Call, Share
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.directions_outlined,
                              label: 'Direction',
                              onTap: () => _openDirections(restaurant.latitude, restaurant.longitude, context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.phone_outlined,
                              label: 'Call',
                              onTap: () => _makePhoneCall(restaurant.phone, context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.share_outlined,
                              label: 'Share',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sharing ${restaurant.name}')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Signature Dishes
                      if (restaurant.signatureDishes.isNotEmpty) ...[
                        const Text(
                          'Signature Dishes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: restaurant.signatureDishes.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final dishName = entry.value;
                            final isFirst = idx == 0;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isFirst ? AppColors.primaryOrangeLight : AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isFirst ? AppColors.primaryOrange : AppColors.cardBorder,
                                ),
                              ),
                              child: Text(
                                dishName,
                                style: TextStyle(
                                  color: isFirst ? AppColors.primaryOrange : AppColors.deepCharcoal,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // About Section
                      const Text(
                        'About',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        restaurant.description ??
                            'Famous for authentic preparation, freshly ground spices, and dedicated staff serving delicious traditional recipes.',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            restaurant.openingHours,
                            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Primary CTA: View Menu
                      PrimaryButton(
                        text: 'View Full Menu (${restaurant.dishCount > 0 ? restaurant.dishCount : 7} Dishes)',
                        onPressed: () => context.push('/restaurant/${restaurant.id}/menu'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorStateWidget(
            message: 'Failed to load restaurant details.',
            onRetry: () => ref.invalidate(restaurantDetailsProvider(restaurantId)),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.deepCharcoal),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.deepCharcoal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
