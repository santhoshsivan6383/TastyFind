import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showTownPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final towns = ref.watch(townsListProvider);
        final current = ref.watch(selectedTownProvider);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Town',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                ),
                const SizedBox(height: 12),
                towns.when(
                  data: (list) => Column(
                    children: list.map((t) {
                      final isSelected = t.id == current.id;
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSelected ? AppColors.primaryOrange : AppColors.textPlaceholder,
                        ),
                        title: Text(
                          t.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.primaryOrange : AppColors.deepCharcoal,
                          ),
                        ),
                        trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primaryOrange) : null,
                        onTap: () {
                          ref.read(selectedTownProvider.notifier).state = t;
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Could not load towns'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTown = ref.watch(selectedTownProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final popularDishesAsync = ref.watch(popularDishesProvider);
    final restaurantsAsync = ref.watch(nearbyRestaurantsProvider);
    final savedState = ref.watch(savedFavoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Text(
              'TastyFind',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.deepCharcoal,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          // Town Selector Dropdown
          GestureDetector(
            onTap: () => _showTownPicker(context, ref),
            child: Container(
              margin: const EdgeInsets.only(right: 18),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryOrangeLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: AppColors.primaryOrange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    currentTown.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryOrange, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: RefreshIndicator(
        color: AppColors.primaryOrange,
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(popularDishesProvider);
          ref.invalidate(nearbyRestaurantsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              SearchBarWidget(
                readOnly: true,
                onTap: () => context.go('/search'),
              ),
              const SizedBox(height: 18),

              // Hero Craving Banner
              Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E222B), Color(0xFF2C3240)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(18)),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Craving something?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 170,
                            child: Text(
                              'Find the best dishes\nin ${currentTown.name}',
                              style: const TextStyle(
                                color: Color(0xFFD1D5DB),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Categories Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'What are you craving?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/search'),
                    child: const Text('See All', style: TextStyle(color: AppColors.primaryOrange, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              categoriesAsync.when(
                data: (categories) => SizedBox(
                  height: 94,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (ctx, i) {
                      final cat = categories[i];
                      return CategoryChipWidget(
                        category: cat,
                        onTap: () => context.push('/rankings/${cat.slug}'),
                      );
                    },
                  ),
                ),
                loading: () => const LoadingSkeleton(height: 90),
                error: (_, __) => const Text('Unable to load categories'),
              ),
              const SizedBox(height: 22),

              // Popular Dishes Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Dishes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepCharcoal,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/rankings/dosa'),
                    child: const Text('View All', style: TextStyle(color: AppColors.primaryOrange, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Horizontal Popular Cards
              popularDishesAsync.when(
                data: (dishes) => SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: dishes.take(4).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (ctx, i) {
                      final dish = dishes[i];
                      return GestureDetector(
                        onTap: () => context.push('/dish/${dish.id}'),
                        child: Container(
                          width: 160,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Container(
                                  height: 95,
                                  width: double.infinity,
                                  color: AppColors.backgroundLight,
                                  child: dish.imageUrl != null
                                      ? Image.network(dish.imageUrl!, fit: BoxFit.cover)
                                      : const Icon(Icons.fastfood, color: AppColors.textPlaceholder),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dish.name,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      dish.badge ?? 'Top rated in town',
                                      style: const TextStyle(fontSize: 11, color: AppColors.primaryOrange, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const LoadingSkeleton(height: 150),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 24),

              // Top Rated Nearby Restaurants
              const Text(
                'Top-Rated Nearby Restaurants',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepCharcoal,
                ),
              ),
              const SizedBox(height: 12),

              restaurantsAsync.when(
                data: (restaurants) => Column(
                  children: restaurants.map((r) {
                    final isSaved = savedState.isRestaurantSaved(r.id);
                    return RestaurantCard(
                      restaurant: r,
                      isSaved: isSaved,
                      onFavoriteToggle: () => ref.read(savedFavoritesProvider.notifier).toggleRestaurant(r),
                      onTap: () => context.push('/restaurant/${r.id}'),
                      onView: () => context.push('/restaurant/${r.id}'),
                    );
                  }).toList(),
                ),
                loading: () => const Column(
                  children: [
                    LoadingSkeleton(height: 90),
                    SizedBox(height: 12),
                    LoadingSkeleton(height: 90),
                  ],
                ),
                error: (err, _) => ErrorStateWidget(
                  message: 'Failed to load restaurants',
                  onRetry: () => ref.invalidate(nearbyRestaurantsProvider),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
