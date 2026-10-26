import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dish_card.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class FilteredResultsScreen extends ConsumerWidget {
  const FilteredResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);
    final filterNotifier = ref.read(filterStateProvider.notifier);
    final filteredDishesAsync = ref.watch(filteredDishesProvider);
    final savedState = ref.watch(savedFavoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Filtered Dishes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push('/filters'),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active Filter Chips Bar
          if (filterState.hasActiveFilters)
            Container(
              color: AppColors.surfaceWhite,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (filterState.pricePreset != null)
                      _buildRemovableChip(
                        label: filterState.pricePreset!,
                        onRemove: () => filterNotifier.clearFilterChip('price'),
                      ),
                    if (filterState.minRating != null)
                      _buildRemovableChip(
                        label: '${filterState.minRating}+ ⭐',
                        onRemove: () => filterNotifier.clearFilterChip('rating'),
                      ),
                    if (filterState.maxDistanceKm != null)
                      _buildRemovableChip(
                        label: 'Within ${filterState.maxDistanceKm!.toInt()} km',
                        onRemove: () => filterNotifier.clearFilterChip('distance'),
                      ),
                    if (filterState.vegOnly)
                      _buildRemovableChip(
                        label: 'Veg only',
                        onRemove: () => filterNotifier.toggleVegOnly(),
                      ),
                    if (filterState.isOpenNow)
                      _buildRemovableChip(
                        label: 'Open now',
                        onRemove: () => filterNotifier.toggleOpenNow(),
                      ),
                  ],
                ),
              ),
            ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Matching Results List
          Expanded(
            child: filteredDishesAsync.when(
              data: (dishes) {
                if (dishes.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No dishes match your filters',
                    message: 'Try broadening your price range or distance criteria to see more dishes in your town.',
                    buttonText: 'Reset Filters',
                    onButtonPressed: () {
                      filterNotifier.reset();
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: dishes.length,
                  itemBuilder: (ctx, i) {
                    final dish = dishes[i];
                    final isSaved = savedState.isDishSaved(dish.id);
                    return DishCard(
                      dish: dish,
                      isSaved: isSaved,
                      onFavoriteToggle: () => ref.read(savedFavoritesProvider.notifier).toggleDish(dish),
                      onTap: () => context.push('/dish/${dish.id}'),
                      onViewMenu: () => context.push('/restaurant/${dish.restaurantId}/menu'),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryOrange),
              ),
              error: (err, _) => ErrorStateWidget(
                message: 'Failed to filter dishes.',
                onRetry: () => ref.invalidate(filteredDishesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemovableChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.primaryOrangeLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 16,
              color: AppColors.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
