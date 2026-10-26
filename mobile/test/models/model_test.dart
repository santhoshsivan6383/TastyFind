import 'package:flutter_test/flutter_test.dart';
import 'package:tastyfind/models/town.dart';
import 'package:tastyfind/models/category.dart';
import 'package:tastyfind/models/restaurant.dart';
import 'package:tastyfind/models/dish.dart';
import 'package:tastyfind/models/filter_state.dart';

void main() {
  group('Data Models JSON Deserialization Tests', () {
    test('Town model parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Erode',
        'state': 'Tamil Nadu',
        'country': 'India',
        'latitude': 11.3410,
        'longitude': 77.7172,
      };
      final town = Town.fromJson(json);
      expect(town.id, 1);
      expect(town.name, 'Erode');
      expect(town.state, 'Tamil Nadu');
      expect(town.latitude, 11.3410);
    });

    test('FoodCategory parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Dosa',
        'slug': 'dosa',
        'image_url': 'https://example.com/dosa.jpg',
      };
      final cat = FoodCategory.fromJson(json);
      expect(cat.id, 1);
      expect(cat.slug, 'dosa');
      expect(cat.name, 'Dosa');
    });

    test('Restaurant model computes formatted price range and parses links', () {
      final json = {
        'id': 1,
        'name': 'Hotel Sri Murugan',
        'address': '42 Brough Road',
        'overall_rating': 4.8,
        'overall_review_count': 1200,
        'min_price': 60,
        'max_price': 90,
        'signature_dishes': ['Masala Dosa', 'Rava Dosa'],
        'ordering_links': [
          {'id': 1, 'platform': 'swiggy', 'url': 'https://swiggy.com/murugan'}
        ],
      };
      final rest = Restaurant.fromJson(json);
      expect(rest.name, 'Hotel Sri Murugan');
      expect(rest.priceRangeFormatted, '₹60 – ₹90');
      expect(rest.signatureDishes.length, 2);
      expect(rest.orderingLinks.length, 1);
      expect(rest.orderingLinks.first.platform, 'swiggy');
    });

    test('Dish model handles Bayesian score and formatted price', () {
      final json = {
        'id': 1,
        'restaurant_id': 1,
        'category_id': 1,
        'name': 'Masala Dosa',
        'current_price': 70.0,
        'dish_rating': 4.8,
        'dish_review_count': 543,
        'bayesian_score': 4.78,
        'best_value_score': 88.5,
        'badge': 'Best Seller',
      };
      final dish = Dish.fromJson(json);
      expect(dish.name, 'Masala Dosa');
      expect(dish.formattedPrice, '₹70');
      expect(dish.dishRating, 4.8);
      expect(dish.badge, 'Best Seller');
    });

    test('FilterState computes activeFiltersCount and copyWith correctly', () {
      const state = FilterState(
        minPrice: 50,
        maxPrice: 100,
        pricePreset: '₹50 – ₹100',
        minRating: 4.5,
        vegOnly: true,
      );
      expect(state.activeFiltersCount, 3);
      expect(state.hasActiveFilters, isTrue);

      final cleared = state.copyWith(clearPrice: true);
      expect(cleared.pricePreset, isNull);
      expect(cleared.activeFiltersCount, 2);
    });
  });
}
