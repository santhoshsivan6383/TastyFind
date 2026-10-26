import 'restaurant.dart';
import 'review.dart';

class Dish {
  final int id;
  final int restaurantId;
  final int categoryId;
  final String name;
  final String? description;
  final double currentPrice;
  final String currency;
  final double dishRating;
  final int dishReviewCount;
  final double bayesianScore;
  final double bestValueScore;
  final String? imageUrl;
  final bool vegetarian;
  final String availabilityStatus;
  final String? badge; // 'Best Overall' | 'Best Seller' | 'Great Value' | 'Top Rated'
  final String? highlightQuote;
  final String? priceVerifiedAt;
  final List<String> ingredients;

  // Populated contextual fields
  final String restaurantName;
  final String restaurantAddress;
  final double? restaurantLat;
  final double? restaurantLng;
  final double? restaurantRating;
  final String categoryName;
  final String categorySlug;
  final double? distanceKm;
  final int? rank;
  final List<OrderingLink> orderingLinks;
  final List<Review> reviews;
  final Map<int, int> ratingDistribution;

  const Dish({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.currentPrice,
    this.currency = 'INR',
    this.dishRating = 0.0,
    this.dishReviewCount = 0,
    this.bayesianScore = 0.0,
    this.bestValueScore = 0.0,
    this.imageUrl,
    this.vegetarian = true,
    this.availabilityStatus = 'available',
    this.badge,
    this.highlightQuote,
    this.priceVerifiedAt,
    this.ingredients = const [],
    this.restaurantName = '',
    this.restaurantAddress = '',
    this.restaurantLat,
    this.restaurantLng,
    this.restaurantRating,
    this.categoryName = '',
    this.categorySlug = '',
    this.distanceKm,
    this.rank,
    this.orderingLinks = const [],
    this.reviews = const [],
    this.ratingDistribution = const {5: 82, 4: 12, 3: 4, 2: 1, 1: 1},
  });

  String get formattedPrice => '₹${currentPrice.toInt()}';

  factory Dish.fromJson(Map<String, dynamic> json) {
    var rawIng = json['ingredients'];
    List<String> parsedIng = [];
    if (rawIng is List) {
      parsedIng = rawIng.map((e) => e.toString()).toList();
    }

    var rawLinks = json['ordering_links'];
    List<OrderingLink> parsedLinks = [];
    if (rawLinks is List) {
      parsedLinks = rawLinks.map((e) => OrderingLink.fromJson(e as Map<String, dynamic>)).toList();
    }

    var rawReviews = json['reviews'];
    List<Review> parsedReviews = [];
    if (rawReviews is List) {
      parsedReviews = rawReviews.map((e) => Review.fromJson(e as Map<String, dynamic>)).toList();
    }

    Map<int, int> parsedDist = {5: 82, 4: 12, 3: 4, 2: 1, 1: 1};
    if (json['rating_distribution'] is Map) {
      final map = json['rating_distribution'] as Map;
      parsedDist = {
        5: (map['5'] ?? map[5] ?? 82) as int,
        4: (map['4'] ?? map[4] ?? 12) as int,
        3: (map['3'] ?? map[3] ?? 4) as int,
        2: (map['2'] ?? map[2] ?? 1) as int,
        1: (map['1'] ?? map[1] ?? 1) as int,
      };
    }

    return Dish(
      id: json['id'] as int,
      restaurantId: json['restaurant_id'] as int? ?? 1,
      categoryId: json['category_id'] as int? ?? 1,
      name: json['name'] as String,
      description: json['description'] as String?,
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      dishRating: (json['dish_rating'] as num?)?.toDouble() ?? 0.0,
      dishReviewCount: json['dish_review_count'] as int? ?? 0,
      bayesianScore: (json['bayesian_score'] as num?)?.toDouble() ?? 0.0,
      bestValueScore: (json['best_value_score'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      vegetarian: json['vegetarian'] as bool? ?? true,
      availabilityStatus: json['availability_status'] as String? ?? 'available',
      badge: json['badge'] as String?,
      highlightQuote: json['highlight_quote'] as String?,
      priceVerifiedAt: json['price_verified_at'] as String?,
      ingredients: parsedIng,
      restaurantName: json['restaurant_name'] as String? ?? '',
      restaurantAddress: json['restaurant_address'] as String? ?? '',
      restaurantLat: (json['restaurant_lat'] as num?)?.toDouble(),
      restaurantLng: (json['restaurant_lng'] as num?)?.toDouble(),
      restaurantRating: (json['restaurant_rating'] as num?)?.toDouble(),
      categoryName: json['category_name'] as String? ?? '',
      categorySlug: json['category_slug'] as String? ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      rank: json['rank'] as int?,
      orderingLinks: parsedLinks,
      reviews: parsedReviews,
      ratingDistribution: parsedDist,
    );
  }
}
