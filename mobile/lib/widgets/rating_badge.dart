import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final bool showStar;
  final double fontSize;
  final Color? backgroundColor;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.showStar = true,
    this.fontSize = 13.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showStar) ...[
          const Icon(
            Icons.star_rounded,
            color: AppColors.ratingStar,
            size: 16,
          ),
          const SizedBox(width: 3),
        ],
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.deepCharcoal,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 3),
          Text(
            reviewCount! >= 1000
                ? '(${(reviewCount! / 1000).toStringAsFixed(1)}k)'
                : '($reviewCount)',
            style: TextStyle(
              fontSize: fontSize - 1,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}
