class FoodCategory {
  final int id;
  final String name;
  final String slug;
  final String? imageUrl;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'image_url': imageUrl,
  };
}
