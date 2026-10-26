import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/rating_badge.dart';
import '../../widgets/price_tag.dart';
import '../../widgets/feedback_widgets.dart';
import '../../widgets/tasty_image.dart';
import '../../providers/food_providers.dart';
import '../../models/dish.dart';

class MenuDishListScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const MenuDishListScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<MenuDishListScreen> createState() => _MenuDishListScreenState();
}

class _MenuDishListScreenState extends ConsumerState<MenuDishListScreen> {
  String _selectedCategory = 'Dosa';
  final List<String> _menuCategories = ['Dosa', 'Idli', 'Vada', 'Others'];

  @override
  Widget build(BuildContext context) {
    final restaurantAsync = ref.watch(restaurantDetailsProvider(widget.restaurantId));
    final menuAsync = ref.watch(restaurantMenuProvider(widget.restaurantId));

    final restName = restaurantAsync.value?.name ?? 'Hotel Sri Murugan';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Menu - $restName'),
      ),
      body: Column(
        children: [
          // Category Tabs Filter Row
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _menuCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final cat = _menuCategories[i];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColors.primaryOrange,
                    backgroundColor: AppColors.surfaceWhite,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.deepCharcoal,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryOrange : AppColors.cardBorder,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Dish Items List
          Expanded(
            child: menuAsync.when(
              data: (dishes) {
                if (dishes.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No dishes found',
                    message: 'No dishes are listed in this menu category.',
                    buttonText: 'Return to restaurant',
                    onButtonPressed: () => context.pop(),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: dishes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) {
                    final dish = dishes[i];
                    return _buildMenuDishCard(dish);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryOrange),
              ),
              error: (err, _) => ErrorStateWidget(
                message: 'Failed to load restaurant menu.',
                onRetry: () => ref.invalidate(restaurantMenuProvider(widget.restaurantId)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuDishCard(Dish dish) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/dish/${dish.id}'),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dish thumbnail
                TastyImage(
                  imageUrl: dish.imageUrl,
                  width: 76,
                  height: 76,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 14),

                // Name, Rating, Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          RatingBadge(
                            rating: dish.dishRating > 0 ? dish.dishRating : 4.6,
                            reviewCount: dish.dishReviewCount > 0 ? dish.dishReviewCount : 210,
                          ),
                          if (dish.badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                        ],
                      ),
                    ],
                  ),
                ),

                // Price & Order CTA
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PriceTag(price: dish.currentPrice, fontSize: 16),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrangeLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
