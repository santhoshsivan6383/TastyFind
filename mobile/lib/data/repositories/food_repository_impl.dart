import 'dart:math';
import '../api_client.dart';
import '../mock_data.dart';
import 'food_repository.dart';
import '../../models/town.dart';
import '../../models/category.dart';
import '../../models/restaurant.dart';
import '../../models/dish.dart';
import '../../models/review.dart';
import '../../models/notification_item.dart';
import '../../models/filter_state.dart';

class FoodRepositoryImpl implements FoodRepository {
  /// TOGGLE FOR BACKEND API INTEGRATION:
  /// Set to `false` to use 100% self-contained front-end dummy data (offline & standalone).
  /// Set to `true` when connecting to the Node.js/MySQL backend API in the future.
  static const bool useRemoteApi = false;

  final ApiClient apiClient;

  // Local mutable copy of dishes and reviews for in-app state updates
  final List<Dish> _localDishes = List.from(MockData.dishes);
  final List<Review> _localReviews = List.from(MockData.sampleReviews);

  FoodRepositoryImpl({ApiClient? client}) : apiClient = client ?? ApiClient();

  @override
  Future<List<Town>> getTowns() async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/towns');
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => Town.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }
    return MockData.towns;
  }

  @override
  Future<List<FoodCategory>> getCategories() async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/categories');
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => FoodCategory.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }
    return MockData.categories;
  }

  @override
  Future<List<Restaurant>> getRestaurants({int? townId, double? minRating, bool? isOpenNow}) async {
    if (useRemoteApi) {
      try {
        final queryParams = <String, dynamic>{};
        if (townId != null) queryParams['town_id'] = townId;
        if (minRating != null) queryParams['min_rating'] = minRating;
        if (isOpenNow != null) queryParams['is_open_now'] = isOpenNow;

        final response = await apiClient.dio.get('/restaurants', queryParameters: queryParams);
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }

    var list = MockData.restaurants;
    if (townId != null) {
      list = list.where((r) => r.townId == townId).toList();
    }
    if (minRating != null) {
      list = list.where((r) => r.overallRating >= minRating).toList();
    }
    if (isOpenNow != null && isOpenNow) {
      list = list.where((r) => r.isOpenNow).toList();
    }
    return list;
  }

  @override
  Future<Restaurant> getRestaurantById(int id) async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/restaurants/$id');
        if (response.statusCode == 200 && response.data['success'] == true) {
          return Restaurant.fromJson(response.data['data'] as Map<String, dynamic>);
        }
      } catch (_) {}
    }
    return MockData.restaurants.firstWhere(
      (r) => r.id == id,
      orElse: () => MockData.restaurants.first,
    );
  }

  @override
  Future<List<Dish>> getRestaurantMenu(int restaurantId, {String? category}) async {
    if (useRemoteApi) {
      try {
        final queryParams = <String, dynamic>{};
        if (category != null) queryParams['category'] = category;
        final response = await apiClient.dio.get('/restaurants/$restaurantId/menu', queryParameters: queryParams);
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => Dish.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }

    var dishes = _localDishes.where((d) => d.restaurantId == restaurantId).toList();
    if (category != null && category.toLowerCase() != 'all' && category.toLowerCase() != 'others') {
      dishes = dishes.where((d) => d.categoryName.toLowerCase().contains(category.toLowerCase())).toList();
    }
    return dishes;
  }

  @override
  Future<List<Dish>> getDishes({int? townId, String? categorySlug, FilterState? filterState}) async {
    if (useRemoteApi) {
      try {
        final queryParams = <String, dynamic>{};
        if (townId != null) queryParams['town_id'] = townId;
        if (categorySlug != null) queryParams['category_slug'] = categorySlug;
        if (filterState != null) {
          if (filterState.minPrice != null) queryParams['min_price'] = filterState.minPrice;
          if (filterState.maxPrice != null) queryParams['max_price'] = filterState.maxPrice;
          if (filterState.minRating != null) queryParams['min_rating'] = filterState.minRating;
          if (filterState.vegOnly) queryParams['vegetarian'] = true;
        }

        final response = await apiClient.dio.get('/dishes', queryParameters: queryParams);
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => Dish.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }

    var results = List<Dish>.from(_localDishes);
    if (categorySlug != null) {
      results = results.where((d) => d.categorySlug.toLowerCase() == categorySlug.toLowerCase()).toList();
    }
    if (filterState != null) {
      if (filterState.minPrice != null) {
        results = results.where((d) => d.currentPrice >= filterState.minPrice!).toList();
      }
      if (filterState.maxPrice != null) {
        results = results.where((d) => d.currentPrice <= filterState.maxPrice!).toList();
      }
      if (filterState.minRating != null) {
        results = results.where((d) => d.dishRating >= filterState.minRating!).toList();
      }
      if (filterState.vegOnly) {
        results = results.where((d) => d.vegetarian).toList();
      }
      if (filterState.maxDistanceKm != null) {
        results = results.where((d) => (d.distanceKm ?? 0.8) <= filterState.maxDistanceKm!).toList();
      }
    }
    return results;
  }

  @override
  Future<Dish> getDishById(int id) async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/dishes/$id');
        if (response.statusCode == 200 && response.data['success'] == true) {
          return Dish.fromJson(response.data['data'] as Map<String, dynamic>);
        }
      } catch (_) {}
    }

    final dish = _localDishes.firstWhere(
      (d) => d.id == id,
      orElse: () => _localDishes.first,
    );

    final dishReviews = _localReviews.where((r) => r.dishId == dish.id).toList();

    return Dish(
      id: dish.id,
      restaurantId: dish.restaurantId,
      categoryId: dish.categoryId,
      name: dish.name,
      description: dish.description,
      currentPrice: dish.currentPrice,
      currency: dish.currency,
      dishRating: dish.dishRating,
      dishReviewCount: dish.dishReviewCount > 0 ? dish.dishReviewCount : dishReviews.length,
      bayesianScore: dish.bayesianScore,
      bestValueScore: dish.bestValueScore,
      imageUrl: dish.imageUrl,
      vegetarian: dish.vegetarian,
      availabilityStatus: dish.availabilityStatus,
      badge: dish.badge,
      highlightQuote: dish.highlightQuote,
      priceVerifiedAt: dish.priceVerifiedAt,
      ingredients: dish.ingredients,
      restaurantName: dish.restaurantName,
      restaurantAddress: dish.restaurantAddress,
      restaurantLat: dish.restaurantLat,
      restaurantLng: dish.restaurantLng,
      restaurantRating: dish.restaurantRating,
      categoryName: dish.categoryName,
      categorySlug: dish.categorySlug,
      distanceKm: dish.distanceKm,
      rank: dish.rank,
      orderingLinks: MockData.defaultOrderingLinks,
      reviews: dishReviews.isNotEmpty ? dishReviews : MockData.sampleReviews,
      ratingDistribution: dish.ratingDistribution,
    );
  }

  @override
  Future<List<Dish>> getRankings({required String categorySlug, required String mode, int? townId}) async {
    if (useRemoteApi) {
      try {
        final queryParams = {
          'category': categorySlug,
          'mode': mode,
          if (townId != null) 'town_id': townId,
          'user_lat': 11.3410,
          'user_lng': 77.7172,
        };
        final response = await apiClient.dio.get('/rankings', queryParameters: queryParams);
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => Dish.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }

    // In-Memory Bayesian Ranking Algorithm
    var items = _localDishes.where((d) => d.categorySlug.toLowerCase() == categorySlug.toLowerCase()).toList();
    if (items.isEmpty) {
      items = _localDishes.take(4).toList();
    }

    if (mode == 'best_value') {
      items.sort((a, b) => b.bestValueScore.compareTo(a.bestValueScore));
    } else if (mode == 'nearest') {
      items.sort((a, b) => (a.distanceKm ?? 99).compareTo(b.distanceKm ?? 99));
    } else {
      // Default: top_rated (Bayesian score descending)
      items.sort((a, b) {
        if (b.bayesianScore != a.bayesianScore) {
          return b.bayesianScore.compareTo(a.bayesianScore);
        }
        return b.dishReviewCount.compareTo(a.dishReviewCount);
      });
    }

    return items.asMap().entries.map((entry) {
      final index = entry.key;
      final dish = entry.value;
      return Dish(
        id: dish.id,
        restaurantId: dish.restaurantId,
        categoryId: dish.categoryId,
        name: dish.name,
        description: dish.description,
        currentPrice: dish.currentPrice,
        currency: dish.currency,
        dishRating: dish.dishRating,
        dishReviewCount: dish.dishReviewCount,
        bayesianScore: dish.bayesianScore,
        bestValueScore: dish.bestValueScore,
        imageUrl: dish.imageUrl,
        vegetarian: dish.vegetarian,
        availabilityStatus: dish.availabilityStatus,
        badge: index == 0 ? (mode == 'best_value' ? 'Best Value' : 'Best Overall') : dish.badge,
        highlightQuote: dish.highlightQuote,
        priceVerifiedAt: dish.priceVerifiedAt,
        ingredients: dish.ingredients,
        restaurantName: dish.restaurantName,
        restaurantAddress: dish.restaurantAddress,
        restaurantLat: dish.restaurantLat,
        restaurantLng: dish.restaurantLng,
        restaurantRating: dish.restaurantRating,
        categoryName: dish.categoryName,
        categorySlug: dish.categorySlug,
        distanceKm: dish.distanceKm,
        rank: index + 1,
        orderingLinks: MockData.defaultOrderingLinks,
        reviews: dish.reviews,
        ratingDistribution: dish.ratingDistribution,
      );
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> search(String query, {int? townId, String? type}) async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/search', queryParameters: {
          'q': query,
          if (townId != null) 'town_id': townId,
          if (type != null) 'type': type,
        });
        if (response.statusCode == 200 && response.data['success'] == true) {
          final data = response.data['data'] as Map<String, dynamic>;
          final dishes = (data['dishes'] as List).map((e) => Dish.fromJson(e as Map<String, dynamic>)).toList();
          final restaurants = (data['restaurants'] as List).map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();
          return {'dishes': dishes, 'restaurants': restaurants};
        }
      } catch (_) {}
    }

    final q = query.toLowerCase().trim();
    final matchingDishes = _localDishes.where((d) =>
      d.name.toLowerCase().contains(q) ||
      (d.description != null && d.description!.toLowerCase().contains(q)) ||
      d.categorySlug.toLowerCase().contains(q) ||
      d.categoryName.toLowerCase().contains(q)
    ).toList();

    final matchingRestaurants = MockData.restaurants.where((r) =>
      r.name.toLowerCase().contains(q) ||
      (r.description != null && r.description!.toLowerCase().contains(q)) ||
      r.signatureDishes.any((s) => s.toLowerCase().contains(q))
    ).toList();

    return {'dishes': matchingDishes, 'restaurants': matchingRestaurants};
  }

  @override
  Future<List<Review>> getDishReviews(int dishId) async {
    final reviews = _localReviews.where((r) => r.dishId == dishId).toList();
    return reviews.isNotEmpty ? reviews : MockData.sampleReviews;
  }

  @override
  Future<Review> addReview({required int dishId, required int rating, String? reviewText, String? imageUrl}) async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.post('/reviews', data: {
          'dish_id': dishId,
          'rating': rating,
          'review_text': reviewText,
          'image_url': imageUrl,
          'user_name': 'Srinikethan'
        });
        if (response.statusCode == 201 && response.data['success'] == true) {
          return Review.fromJson(response.data['data'] as Map<String, dynamic>);
        }
      } catch (_) {}
    }

    final newReview = Review(
      id: Random().nextInt(1000) + 100,
      userId: 1,
      userName: 'Srinikethan',
      dishId: dishId,
      rating: rating,
      reviewText: reviewText ?? '',
      imageUrl: imageUrl,
      moderationStatus: 'approved',
      helpfulCount: 0,
      createdAt: 'Just now',
    );

    _localReviews.insert(0, newReview);
    return newReview;
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    if (useRemoteApi) {
      try {
        final response = await apiClient.dio.get('/notifications');
        if (response.statusCode == 200 && response.data['success'] == true) {
          final list = response.data['data'] as List;
          return list.map((e) => NotificationItem.fromJson(e as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
    }
    return MockData.notifications;
  }
}
