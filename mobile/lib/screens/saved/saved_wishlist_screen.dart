import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/dish_card.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class SavedWishlistScreen extends ConsumerStatefulWidget {
  const SavedWishlistScreen({super.key});

  @override
  ConsumerState<SavedWishlistScreen> createState() => _SavedWishlistScreenState();
}

class _SavedWishlistScreenState extends ConsumerState<SavedWishlistScreen> {
  int _activeTabIndex = 0; // 0: Restaurants, 1: Dishes

  @override
  Widget build(BuildContext context) {
    final savedState = ref.watch(savedFavoritesProvider);
    final savedNotifier = ref.read(savedFavoritesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      appBar: AppBar(
        title: const Text('Saved'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Segmented Tabs: [Restaurants] | [Dishes]
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabPill('Restaurants (${savedState.savedRestaurants.length})', 0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTabPill('Dishes (${savedState.savedDishes.length})', 1),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Content List
          Expanded(
            child: _activeTabIndex == 0
                ? (savedState.savedRestaurants.isEmpty
                    ? EmptyStateWidget(
                        title: 'No saved restaurants',
                        message: 'Bookmark your favorite dining spots to quickly access menus and directions.',
                        buttonText: 'Explore Restaurants',
                        onButtonPressed: () => context.go('/home'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        itemCount: savedState.savedRestaurants.length,
                        itemBuilder: (ctx, i) {
                          final r = savedState.savedRestaurants[i];
                          return RestaurantCard(
                            restaurant: r,
                            isSaved: true,
                            onFavoriteToggle: () => savedNotifier.toggleRestaurant(r),
                            onTap: () => context.push('/restaurant/${r.id}'),
                            onView: () => context.push('/restaurant/${r.id}'),
                          );
                        },
                      ))
                : (savedState.savedDishes.isEmpty
                    ? EmptyStateWidget(
                        title: 'No saved dishes',
                        message: 'Tap the heart icon on any dish ranking to save it for your next craving.',
                        buttonText: 'Browse Top Dishes',
                        onButtonPressed: () => context.push('/rankings/dosa'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        itemCount: savedState.savedDishes.length,
                        itemBuilder: (ctx, i) {
                          final dish = savedState.savedDishes[i];
                          return DishCard(
                            dish: dish,
                            isSaved: true,
                            onFavoriteToggle: () => savedNotifier.toggleDish(dish),
                            onTap: () => context.push('/dish/${dish.id}'),
                            onViewMenu: () => context.push('/restaurant/${dish.restaurantId}/menu'),
                          );
                        },
                      )),
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(String text, int index) {
    final isSelected = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.cardBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.deepCharcoal,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
