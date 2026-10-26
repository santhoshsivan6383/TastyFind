import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/food_repository.dart';
import '../data/repositories/food_repository_impl.dart';
import '../data/mock_data.dart';
import '../models/town.dart';
import '../models/category.dart';
import '../models/restaurant.dart';
import '../models/dish.dart';
import '../models/notification_item.dart';
import '../models/filter_state.dart';

// Repository Provider
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl();
});

// Selected Town Provider (Default: Erode)
final selectedTownProvider = StateProvider<Town>((ref) {
  return MockData.towns.first;
});

// Towns List Provider
final townsListProvider = FutureProvider<List<Town>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getTowns();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<FoodCategory>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getCategories();
});

// Popular Dishes Provider
final popularDishesProvider = FutureProvider<List<Dish>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  final town = ref.watch(selectedTownProvider);
  return repo.getDishes(townId: town.id);
});

// Nearby Restaurants Provider
final nearbyRestaurantsProvider = FutureProvider<List<Restaurant>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  final town = ref.watch(selectedTownProvider);
  return repo.getRestaurants(townId: town.id);
});

// Restaurant Details Provider
final restaurantDetailsProvider = FutureProvider.family<Restaurant, int>((ref, id) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getRestaurantById(id);
});

// Restaurant Menu Provider
final restaurantMenuProvider = FutureProvider.family<List<Dish>, int>((ref, restaurantId) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getRestaurantMenu(restaurantId);
});

// Dish Details Provider
final dishDetailsProvider = FutureProvider.family<Dish, int>((ref, id) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getDishById(id);
});

// Dish Rankings Parameter Class
class RankingParams {
  final String categorySlug;
  final String mode; // 'top_rated' | 'best_value' | 'nearest'

  const RankingParams({required this.categorySlug, required this.mode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RankingParams &&
          runtimeType == other.runtimeType &&
          categorySlug == other.categorySlug &&
          mode == other.mode;

  @override
  int get hashCode => categorySlug.hashCode ^ mode.hashCode;
}

// Dish Rankings Provider (Bayesian Rankings)
final dishRankingsProvider = FutureProvider.family<List<Dish>, RankingParams>((ref, params) async {
  final repo = ref.watch(foodRepositoryProvider);
  final town = ref.watch(selectedTownProvider);
  return repo.getRankings(
    categorySlug: params.categorySlug,
    mode: params.mode,
    townId: town.id,
  );
});

// Filter Notifier
class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void setPricePreset(String preset, double min, double max) {
    if (state.pricePreset == preset) {
      state = state.copyWith(clearPrice: true);
    } else {
      state = state.copyWith(pricePreset: preset, minPrice: min, maxPrice: max);
    }
  }

  void setRatingPreset(double rating) {
    if (state.minRating == rating) {
      state = state.copyWith(clearRating: true);
    } else {
      state = state.copyWith(minRating: rating);
    }
  }

  void setDistancePreset(double distance) {
    if (state.maxDistanceKm == distance) {
      state = state.copyWith(clearDistance: true);
    } else {
      state = state.copyWith(maxDistanceKm: distance);
    }
  }

  void toggleOpenNow() {
    state = state.copyWith(isOpenNow: !state.isOpenNow);
  }

  void toggleVegOnly() {
    state = state.copyWith(vegOnly: !state.vegOnly);
  }

  void setSortMode(String mode) {
    state = state.copyWith(sortMode: mode);
  }

  void clearFilterChip(String type) {
    if (type == 'price') {
      state = state.copyWith(clearPrice: true);
    } else if (type == 'rating') {
      state = state.copyWith(clearRating: true);
    } else if (type == 'distance') {
      state = state.copyWith(clearDistance: true);
    }
  }

  void reset() {
    state = const FilterState();
  }
}

final filterStateProvider = StateNotifierProvider<FilterNotifier, FilterState>((ref) {
  return FilterNotifier();
});

// Filtered Dishes Provider
final filteredDishesProvider = FutureProvider<List<Dish>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  final town = ref.watch(selectedTownProvider);
  final filter = ref.watch(filterStateProvider);
  return repo.getDishes(townId: town.id, filterState: filter);
});

// Search Providers
final searchQueryProvider = StateProvider<String>((ref) => '');
final searchTabFilterProvider = StateProvider<String>((ref) => 'All'); // 'All' | 'Restaurants' | 'Dishes'

final searchResultsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    return {'dishes': <Dish>[], 'restaurants': <Restaurant>[]};
  }
  final repo = ref.watch(foodRepositoryProvider);
  final town = ref.watch(selectedTownProvider);
  return repo.search(query, townId: town.id);
});

// Saved Favorites State
class SavedState {
  final List<Restaurant> savedRestaurants;
  final List<Dish> savedDishes;

  const SavedState({this.savedRestaurants = const [], this.savedDishes = const []});

  bool isRestaurantSaved(int id) => savedRestaurants.any((r) => r.id == id);
  bool isDishSaved(int id) => savedDishes.any((d) => d.id == id);

  SavedState copyWith({
    List<Restaurant>? savedRestaurants,
    List<Dish>? savedDishes,
  }) {
    return SavedState(
      savedRestaurants: savedRestaurants ?? this.savedRestaurants,
      savedDishes: savedDishes ?? this.savedDishes,
    );
  }
}

class SavedNotifier extends StateNotifier<SavedState> {
  SavedNotifier()
      : super(
          SavedState(
            savedRestaurants: [MockData.restaurants[0], MockData.restaurants[1], MockData.restaurants[2]],
            savedDishes: [MockData.dishes[0]],
          ),
        );

  void toggleRestaurant(Restaurant restaurant) {
    final exists = state.isRestaurantSaved(restaurant.id);
    if (exists) {
      state = state.copyWith(
        savedRestaurants: state.savedRestaurants.where((r) => r.id != restaurant.id).toList(),
      );
    } else {
      state = state.copyWith(
        savedRestaurants: [...state.savedRestaurants, restaurant],
      );
    }
  }

  void toggleDish(Dish dish) {
    final exists = state.isDishSaved(dish.id);
    if (exists) {
      state = state.copyWith(
        savedDishes: state.savedDishes.where((d) => d.id != dish.id).toList(),
      );
    } else {
      state = state.copyWith(
        savedDishes: [...state.savedDishes, dish],
      );
    }
  }
}

final savedFavoritesProvider = StateNotifierProvider<SavedNotifier, SavedState>((ref) {
  return SavedNotifier();
});

// Notifications Provider
final notificationsListProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getNotifications();
});

// Theme Mode Provider (Light/Dark)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
