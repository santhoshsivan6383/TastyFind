import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../theme/app_colors.dart';
import 'rating_badge.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isSaved;
  final VoidCallback? onView;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    this.onFavoriteToggle,
    this.isSaved = false,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 76,
                    height: 76,
                    color: AppColors.backgroundLight,
                    child: restaurant.coverImageUrl != null
                        ? Image.network(
                            restaurant.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, _, __) => const Center(
                              child: Icon(Icons.restaurant, color: AppColors.textPlaceholder, size: 28),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.restaurant, color: AppColors.textPlaceholder, size: 28),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepCharcoal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onFavoriteToggle != null)
                            GestureDetector(
                              onTap: onFavoriteToggle,
                              child: Icon(
                                isSaved ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                color: isSaved ? AppColors.primaryOrange : AppColors.textPlaceholder,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          RatingBadge(
                            rating: restaurant.overallRating,
                            reviewCount: restaurant.overallReviewCount,
                          ),
                          if (restaurant.distanceKm != null) ...[
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                              '${restaurant.distanceKm} km',
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        restaurant.priceRangeFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onView != null) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onView,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
