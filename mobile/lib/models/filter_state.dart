class FilterState {
  final double? minPrice;
  final double? maxPrice;
  final String? pricePreset; // 'Under ₹50' | '₹50 – ₹100' | '₹100 – ₹150' | '₹150+'
  final double? minRating; // 4.0 | 4.5 | 4.7
  final double? maxDistanceKm; // 1.0 | 3.0 | 5.0
  final bool isOpenNow;
  final bool vegOnly;
  final String sortMode; // 'top_rated' | 'best_value' | 'nearest'

  const FilterState({
    this.minPrice,
    this.maxPrice,
    this.pricePreset,
    this.minRating,
    this.maxDistanceKm,
    this.isOpenNow = false,
    this.vegOnly = false,
    this.sortMode = 'top_rated',
  });

  int get activeFiltersCount {
    int count = 0;
    if (pricePreset != null || minPrice != null || maxPrice != null) count++;
    if (minRating != null) count++;
    if (maxDistanceKm != null) count++;
    if (isOpenNow) count++;
    if (vegOnly) count++;
    return count;
  }

  bool get hasActiveFilters => activeFiltersCount > 0;

  FilterState copyWith({
    double? minPrice,
    double? maxPrice,
    String? pricePreset,
    double? minRating,
    double? maxDistanceKm,
    bool? isOpenNow,
    bool? vegOnly,
    String? sortMode,
    bool clearPrice = false,
    bool clearRating = false,
    bool clearDistance = false,
  }) {
    return FilterState(
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      pricePreset: clearPrice ? null : (pricePreset ?? this.pricePreset),
      minRating: clearRating ? null : (minRating ?? this.minRating),
      maxDistanceKm: clearDistance ? null : (maxDistanceKm ?? this.maxDistanceKm),
      isOpenNow: isOpenNow ?? this.isOpenNow,
      vegOnly: vegOnly ?? this.vegOnly,
      sortMode: sortMode ?? this.sortMode,
    );
  }

  factory FilterState.initial() => const FilterState();
}
