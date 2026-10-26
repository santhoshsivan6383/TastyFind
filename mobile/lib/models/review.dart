class Review {
  final int id;
  final int userId;
  final String userName;
  final String? userAvatar;
  final int dishId;
  final int rating;
  final String? reviewText;
  final String? imageUrl;
  final String moderationStatus;
  final int helpfulCount;
  final String? createdAt;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.dishId,
    required this.rating,
    this.reviewText,
    this.imageUrl,
    this.moderationStatus = 'approved',
    this.helpfulCount = 0,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 1,
      userName: json['user_name'] as String? ?? 'Food Explorer',
      userAvatar: json['user_avatar'] as String?,
      dishId: json['dish_id'] as int? ?? 0,
      rating: json['rating'] as int? ?? 5,
      reviewText: json['review_text'] as String?,
      imageUrl: json['image_url'] as String?,
      moderationStatus: json['moderation_status'] as String? ?? 'approved',
      helpfulCount: json['helpful_count'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'user_name': userName,
    'user_avatar': userAvatar,
    'dish_id': dishId,
    'rating': rating,
    'review_text': reviewText,
    'image_url': imageUrl,
    'moderation_status': moderationStatus,
    'helpful_count': helpfulCount,
  };
}
