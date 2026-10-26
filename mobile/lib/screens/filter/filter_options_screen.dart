import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../providers/food_providers.dart';

class FilterOptionsScreen extends ConsumerWidget {
  const FilterOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterStateProvider);
    final filterNotifier = ref.read(filterStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: () {
              filterNotifier.reset();
            },
            child: const Text(
              'Reset',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Price Range Section
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildFilterChip(
                        label: 'Under ₹50',
                        isSelected: filterState.pricePreset == 'Under ₹50',
                        onTap: () => filterNotifier.setPricePreset('Under ₹50', 0, 50),
                      ),
                      _buildFilterChip(
                        label: '₹50 – ₹100',
                        isSelected: filterState.pricePreset == '₹50 – ₹100',
                        onTap: () => filterNotifier.setPricePreset('₹50 – ₹100', 50, 100),
                      ),
                      _buildFilterChip(
                        label: '₹100 – ₹150',
                        isSelected: filterState.pricePreset == '₹100 – ₹150',
                        onTap: () => filterNotifier.setPricePreset('₹100 – ₹150', 100, 150),
                      ),
                      _buildFilterChip(
                        label: '₹150+',
                        isSelected: filterState.pricePreset == '₹150+',
                        onTap: () => filterNotifier.setPricePreset('₹150+', 150, 1000),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rating Section
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip(
                        label: '4.0+',
                        isSelected: filterState.minRating == 4.0,
                        onTap: () => filterNotifier.setRatingPreset(4.0),
                      ),
                      _buildFilterChip(
                        label: '4.5+',
                        isSelected: filterState.minRating == 4.5,
                        onTap: () => filterNotifier.setRatingPreset(4.5),
                      ),
                      _buildFilterChip(
                        label: '4.7+',
                        isSelected: filterState.minRating == 4.7,
                        onTap: () => filterNotifier.setRatingPreset(4.7),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Distance Section
                  const Text(
                    'Distance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: [
                      _buildFilterChip(
                        label: 'Within 1 km',
                        isSelected: filterState.maxDistanceKm == 1.0,
                        onTap: () => filterNotifier.setDistancePreset(1.0),
                      ),
                      _buildFilterChip(
                        label: 'Within 3 km',
                        isSelected: filterState.maxDistanceKm == 3.0,
                        onTap: () => filterNotifier.setDistancePreset(3.0),
                      ),
                      _buildFilterChip(
                        label: 'Within 5 km',
                        isSelected: filterState.maxDistanceKm == 5.0,
                        onTap: () => filterNotifier.setDistancePreset(5.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Other toggles
                  const Text(
                    'Other Preferences',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryOrange,
                    title: const Text('Open now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    value: filterState.isOpenNow,
                    onChanged: (_) => filterNotifier.toggleOpenNow(),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryOrange,
                    title: const Text('Veg only', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    value: filterState.vegOnly,
                    onChanged: (_) => filterNotifier.toggleVegOnly(),
                  ),
                ],
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: PrimaryButton(
                text: 'Apply Filters (${filterState.activeFiltersCount} Active)',
                onPressed: () {
                  context.push('/filtered-results');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryOrange : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryOrange : AppColors.cardBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
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
