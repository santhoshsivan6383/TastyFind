import 'package:flutter/material.dart';
import '../models/dish.dart';
import '../theme/app_colors.dart';
import 'rating_badge.dart';
import 'tasty_image.dart';

class DishCard extends StatelessWidget {
  final Dish dish;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isSaved;
  final VoidCallback? onViewMenu;

  const DishCard({
    super.key,
    required this.dish,
    required this.onTap,
    this.onFavoriteToggle,
    this.isSaved = false,
    this.onViewMenu,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dish thumbnail with optional rank badge
                Stack(
                  children: [
                    TastyImage(
                      imageUrl: dish.imageUrl,
                      width: 86,
                      height: 86,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    if (dish.rank != null)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '#${dish.rank}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Center Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Restaurant / Dish Name & Favorite Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              dish.restaurantName.isNotEmpty ? dish.restaurantName : dish.name,
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
                              child: Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Icon(
                                  isSaved ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                  color: isSaved ? AppColors.primaryOrange : AppColors.textPlaceholder,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Rating & Distance Row
                      Row(
                        children: [
                          RatingBadge(
                            rating: dish.dishRating > 0 ? dish.dishRating : 4.5,
                            reviewCount: dish.dishReviewCount > 0 ? dish.dishReviewCount : null,
                          ),
                          if (dish.distanceKm != null) ...[
                            const SizedBox(width: 6),
                            const Text('•', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                              '${dish.distanceKm} km',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Price range
                      Text(
                        '₹${dish.currentPrice.toInt()} – ₹${(dish.currentPrice * 1.3).toInt()}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      // Badge if any (e.g. Best Overall)
                      if (dish.badge != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.badgeBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            dish.badge!,
                            style: const TextStyle(
                              color: AppColors.badgeText,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],

                      // Highlight quote
                      if (dish.highlightQuote != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          '"${dish.highlightQuote}"',
                          style: const TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Right action: View Menu button
                if (onViewMenu != null) ...[
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: onViewMenu,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'View Menu',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
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
