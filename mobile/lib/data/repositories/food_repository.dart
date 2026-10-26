import '../../models/town.dart';
import '../../models/category.dart';
import '../../models/restaurant.dart';
import '../../models/dish.dart';
import '../../models/review.dart';
import '../../models/notification_item.dart';
import '../../models/filter_state.dart';

abstract class FoodRepository {
  Future<List<Town>> getTowns();
  Future<List<FoodCategory>> getCategories();
  Future<List<Restaurant>> getRestaurants({int? townId, double? minRating, bool? isOpenNow});
  Future<Restaurant> getRestaurantById(int id);
  Future<List<Dish>> getRestaurantMenu(int restaurantId, {String? category});
  Future<List<Dish>> getDishes({int? townId, String? categorySlug, FilterState? filterState});
  Future<Dish> getDishById(int id);
  Future<List<Dish>> getRankings({required String categorySlug, required String mode, int? townId});
  Future<Map<String, dynamic>> search(String query, {int? townId, String? type});
  Future<List<Review>> getDishReviews(int dishId);
  Future<Review> addReview({required int dishId, required int rating, String? reviewText, String? imageUrl});
  Future<List<NotificationItem>> getNotifications();
}
