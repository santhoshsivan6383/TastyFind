import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_colors.dart';

class CategoryChipWidget extends StatelessWidget {
  final FoodCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChipWidget({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  IconData _getCategoryIcon(String slug) {
    switch (slug.toLowerCase()) {
      case 'dosa':
        return Icons.breakfast_dining_rounded;
      case 'biryani':
        return Icons.rice_bowl_rounded;
      case 'parotta':
        return Icons.bakery_dining_rounded;
      case 'burger':
        return Icons.lunch_dining_rounded;
      case 'pizza':
        return Icons.local_pizza_rounded;
      case 'shawarma':
        return Icons.kebab_dining_rounded;
      case 'fried-rice':
        return Icons.dinner_dining_rounded;
      case 'idli-vada':
        return Icons.donut_large_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryOrange : AppColors.primaryOrangeLight,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryOrange.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Icon(
              _getCategoryIcon(category.slug),
              color: isSelected ? Colors.white : AppColors.primaryOrange,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryOrange : AppColors.deepCharcoal,
            ),
          ),
        ],
      ),
    );
  }
}
