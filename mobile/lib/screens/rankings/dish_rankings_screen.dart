import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dish_card.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class DishRankingsScreen extends ConsumerStatefulWidget {
  final String categorySlug;

  const DishRankingsScreen({super.key, required this.categorySlug});

  @override
  ConsumerState<DishRankingsScreen> createState() => _DishRankingsScreenState();
}

class _DishRankingsScreenState extends ConsumerState<DishRankingsScreen> {
  String _selectedMode = 'top_rated'; // 'top_rated' | 'best_value' | 'nearest'

  @override
  Widget build(BuildContext context) {
    final params = RankingParams(categorySlug: widget.categorySlug, mode: _selectedMode);
    final rankingsAsync = ref.watch(dishRankingsProvider(params));
    final savedState = ref.watch(savedFavoritesProvider);

    final title = widget.categorySlug.isNotEmpty
        ? widget.categorySlug[0].toUpperCase() + widget.categorySlug.substring(1)
        : 'Rankings';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter options',
            onPressed: () => context.push('/filters'),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          // Ranking Modes Segmented Bar
          Container(
            color: AppColors.surfaceWhite,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Row(
              children: [
                _buildModePill('Top Rated', 'top_rated'),
                const SizedBox(width: 10),
                _buildModePill('Best Value', 'best_value'),
                const SizedBox(width: 10),
                _buildModePill('Nearest', 'nearest'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Ranked Dishes List
          Expanded(
            child: rankingsAsync.when(
              data: (dishes) {
                if (dishes.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No rankings found',
                    message: 'No restaurants in this area currently offer verified dishes in this category.',
                    buttonText: 'Explore other categories',
                    onButtonPressed: () => context.go('/home'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                message: 'Failed to load dish rankings.',
                onRetry: () => ref.invalidate(dishRankingsProvider(params)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModePill(String label, String modeKey) {
    final isSelected = _selectedMode == modeKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = modeKey;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
