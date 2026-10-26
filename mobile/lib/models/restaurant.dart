class OrderingLink {
  final int id;
  final int restaurantId;
  final String platform; // 'swiggy' | 'zomato'
  final String url;
  final String verificationStatus;

  const OrderingLink({
    required this.id,
    required this.restaurantId,
    required this.platform,
    required this.url,
    this.verificationStatus = 'verified',
  });

  factory OrderingLink.fromJson(Map<String, dynamic> json) {
    return OrderingLink(
      id: json['id'] as int? ?? 0,
      restaurantId: json['restaurant_id'] as int? ?? 0,
      platform: json['platform'] as String? ?? 'swiggy',
      url: json['url'] as String? ?? '',
      verificationStatus: json['verification_status'] as String? ?? 'verified',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurant_id': restaurantId,
    'platform': platform,
    'url': url,
    'verification_status': verificationStatus,
  };
}

class Restaurant {
  final int id;
  final int townId;
  final String name;
  final String? description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phone;
  final String openingHours;
  final bool isOpenNow;
  final String cuisineType;
  final double overallRating;
  final int overallReviewCount;
  final double minPrice;
  final double maxPrice;
  final String? coverImageUrl;
  final List<String> signatureDishes;
  final double? distanceKm;
  final List<OrderingLink> orderingLinks;
  final int dishCount;

  const Restaurant({
    required this.id,
    required this.townId,
    required this.name,
    this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.openingHours = '7:00 AM - 10:30 PM',
    this.isOpenNow = true,
    this.cuisineType = 'South Indian',
    this.overallRating = 0.0,
    this.overallReviewCount = 0,
    this.minPrice = 50.0,
    this.maxPrice = 120.0,
    this.coverImageUrl,
    this.signatureDishes = const [],
    this.distanceKm,
    this.orderingLinks = const [],
    this.dishCount = 0,
  });

  String get priceRangeFormatted => '₹${minPrice.toInt()} – ₹${maxPrice.toInt()}';

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    var rawLinks = json['ordering_links'];
    List<OrderingLink> parsedLinks = [];
    if (rawLinks is List) {
      parsedLinks = rawLinks.map((e) => OrderingLink.fromJson(e as Map<String, dynamic>)).toList();
    }

    var rawSig = json['signature_dishes'];
    List<String> parsedSig = [];
    if (rawSig is List) {
      parsedSig = rawSig.map((e) => e.toString()).toList();
    }

    return Restaurant(
      id: json['id'] as int,
      townId: json['town_id'] as int? ?? 1,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      phone: json['phone'] as String?,
      openingHours: json['opening_hours'] as String? ?? '7:00 AM - 10:30 PM',
      isOpenNow: json['is_open_now'] as bool? ?? true,
      cuisineType: json['cuisine_type'] as String? ?? 'South Indian',
      overallRating: (json['overall_rating'] as num?)?.toDouble() ?? 0.0,
      overallReviewCount: json['overall_review_count'] as int? ?? 0,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 50.0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 120.0,
      coverImageUrl: json['cover_image_url'] as String?,
      signatureDishes: parsedSig,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      orderingLinks: parsedLinks,
      dishCount: json['dish_count'] as int? ?? 0,
    );
  }
}
