import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/rating_badge.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/feedback_widgets.dart';
import '../../widgets/tasty_image.dart';
import '../../providers/food_providers.dart';

class DishDetailScreen extends ConsumerWidget {
  final int dishId;

  const DishDetailScreen({super.key, required this.dishId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishAsync = ref.watch(dishDetailsProvider(dishId));
    final savedState = ref.watch(savedFavoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: dishAsync.when(
        data: (dish) {
          final isSaved = savedState.isDishSaved(dish.id);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Hero Dish Image AppBar
                  SliverAppBar(
                    expandedHeight: 280,
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
                          onPressed: () => ref.read(savedFavoritesProvider.notifier).toggleDish(dish),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: TastyImage(
                        imageUrl: dish.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Dish Details Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dish Title & Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  dish.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deepCharcoal,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ),
                              Text(
                                dish.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Restaurant Name Subtitle
                          GestureDetector(
                            onTap: () => context.push('/restaurant/${dish.restaurantId}'),
                            child: Row(
                              children: [
                                Text(
                                  dish.restaurantName.isNotEmpty ? dish.restaurantName : 'Hotel Sri Murugan',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Badges Row
                          if (dish.badge != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.badgeBackground,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                dish.badge!,
                                style: const TextStyle(
                                  color: AppColors.badgeText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Description
                          Text(
                            dish.description ??
                                'Crispy dosa with flavorful potato masala. Served with fresh coconut chutney, tomato chutney and piping hot sambar.',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ingredients
                          if (dish.ingredients.isNotEmpty) ...[
                            const Text(
                              'Ingredients & Dietary',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: dish.ingredients.map((ing) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundLight,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.cardBorder),
                                  ),
                                  child: Text(ing, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          const Divider(color: AppColors.cardBorder),
                          const SizedBox(height: 16),

                          // Customer Reviews Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Customer Reviews',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepCharcoal,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => context.push('/add-review/${dish.id}'),
                                icon: const Icon(Icons.rate_review_outlined, size: 16, color: AppColors.primaryOrange),
                                label: const Text('Add Review', style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Rating summary & distribution bar chart
                          _buildRatingBreakdown(dish),
                          const SizedBox(height: 20),

                          // User Review Cards
                          if (dish.reviews.isNotEmpty)
                            ...dish.reviews.map((rev) => _buildReviewCard(rev)),

                          const SizedBox(height: 16),
                          // Price Disclaimer note
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textMuted),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Notice: Displayed prices are periodically verified and may slightly differ from current live prices on Swiggy or Zomato.',
                                    style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed Bottom CTA: Add to Cart / Order via Swiggy/Zomato
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: PrimaryButton(
                      text: 'Order via Swiggy / Zomato (${dish.formattedPrice})',
                      onPressed: () => context.push('/order-external?dishId=${dish.id}&restaurantId=${dish.restaurantId}'),
                    ),
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
            message: 'Failed to load dish details.',
            onRetry: () => ref.invalidate(dishDetailsProvider(dishId)),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBreakdown(dynamic dish) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Big rating number
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.ratingStar, size: 28),
                const SizedBox(width: 4),
                Text(
                  dish.dishRating > 0 ? dish.dishRating.toStringAsFixed(1) : '4.8',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.deepCharcoal),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${dish.dishReviewCount > 0 ? dish.dishReviewCount : 543} reviews',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(width: 24),

        // 5 to 1 Star Progress Bars
        Expanded(
          child: Column(
            children: [
              _buildDistributionRow(5, 82),
              _buildDistributionRow(4, 12),
              _buildDistributionRow(3, 4),
              _buildDistributionRow(2, 1),
              _buildDistributionRow(1, 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionRow(int stars, int pct) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 11, color: AppColors.ratingStar),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 6,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '$pct%',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic rev) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryOrangeLight,
                foregroundImage: rev.userAvatar != null ? NetworkImage(rev.userAvatar!) : null,
                onForegroundImageError: null,
                child: Text(
                  rev.userName.isNotEmpty ? rev.userName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rev.userName,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                    ),
                    Text(
                      rev.createdAt ?? 'Recent',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              RatingBadge(rating: rev.rating.toDouble(), showStar: true),
            ],
          ),
          if (rev.reviewText != null && rev.reviewText!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rev.reviewText!,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
