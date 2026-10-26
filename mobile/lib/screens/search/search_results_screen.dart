import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';
import '../../models/dish.dart';
import '../../models/restaurant.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController(text: 'dosa');


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchQueryProvider.notifier).state = 'dosa';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(searchTabFilterProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final savedState = ref.watch(savedFavoritesProvider);
    final filterState = ref.watch(filterStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      appBar: AppBar(
        titleSpacing: 18,
        title: SearchBarWidget(
          controller: _searchController,
          showFilterButton: true,
          activeFilterCount: filterState.activeFiltersCount,
          onFilterTap: () => context.push('/filters'),
          onChanged: (val) {
            ref.read(searchQueryProvider.notifier).state = val;
          },
          onClear: () {
            _searchController.clear();
            ref.read(searchQueryProvider.notifier).state = '';
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs: [All], [Restaurants], [Dishes]
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: ['All', 'Restaurants', 'Dishes'].map((tab) {
                final isSelected = activeTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(tab),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(searchTabFilterProvider.notifier).state = tab;
                    },
                    selectedColor: AppColors.primaryOrange,
                    backgroundColor: AppColors.surfaceWhite,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.deepCharcoal,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryOrange : AppColors.cardBorder,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Main Results View
          Expanded(
            child: searchResultsAsync.when(
              data: (data) {
                final dishes = (data['dishes'] as List<Dish>?) ?? [];
                final restaurants = (data['restaurants'] as List<Restaurant>?) ?? [];

                if (dishes.isEmpty && restaurants.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No results found',
                    message: 'Try searching for another dish like "Biryani", "Parotta", or "Dosa".',
                    buttonText: 'Reset Search',
                    onButtonPressed: () {
                      _searchController.text = 'dosa';
                      ref.read(searchQueryProvider.notifier).state = 'dosa';
                    },
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                  children: [
                    // Top Dishes Section
                    if ((activeTab == 'All' || activeTab == 'Dishes') && dishes.isNotEmpty) ...[
                      const Text(
                        'Top Dishes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 125,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dishes.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (ctx, i) {
                            final dish = dishes[i];
                            return GestureDetector(
                              onTap: () => context.push('/dish/${dish.id}'),
                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.cardBorder),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                                      child: Container(
                                        height: 80,
                                        width: double.infinity,
                                        color: AppColors.backgroundLight,
                                        child: dish.imageUrl != null
                                            ? Image.network(dish.imageUrl!, fit: BoxFit.cover)
                                            : const Icon(Icons.fastfood, color: AppColors.textPlaceholder),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: Text(
                                        dish.name,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Top Restaurants Section
                    if ((activeTab == 'All' || activeTab == 'Restaurants') && restaurants.isNotEmpty) ...[
                      const Text(
                        'Top Restaurants',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...restaurants.map((r) {
                        final isSaved = savedState.isRestaurantSaved(r.id);
                        return RestaurantCard(
                          restaurant: r,
                          isSaved: isSaved,
                          onFavoriteToggle: () => ref.read(savedFavoritesProvider.notifier).toggleRestaurant(r),
                          onTap: () => context.push('/restaurant/${r.id}'),
                          onView: () => context.push('/restaurant/${r.id}'),
                        );
                      }),
                    ],
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryOrange),
              ),
              error: (err, _) => ErrorStateWidget(
                message: 'Failed to perform search.',
                onRetry: () => ref.invalidate(searchResultsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
