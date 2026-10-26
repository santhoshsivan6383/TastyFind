import 'package:flutter_test/flutter_test.dart';
import 'package:tastyfind/data/repositories/food_repository_impl.dart';

void main() {
  group('Ranking Algorithm Tests', () {
    late FoodRepositoryImpl repository;

    setUp(() {
      repository = FoodRepositoryImpl();
    });

    test('Rankings algorithm returns dishes sorted by Bayesian score in top_rated mode', () async {
      final rankings = await repository.getRankings(categorySlug: 'dosa', mode: 'top_rated');
      expect(rankings, isNotEmpty);
      expect(rankings.first.rank, 1);
      expect(rankings.first.badge, 'Best Overall');

      // Verify descending order of bayesian score
      for (int i = 0; i < rankings.length - 1; i++) {
        expect(
          rankings[i].bayesianScore >= rankings[i + 1].bayesianScore,
          isTrue,
          reason: 'Dish at $i should have >= bayesian score than ${i + 1}',
        );
      }
    });

    test('Rankings algorithm sorts by best_value_score in best_value mode', () async {
      final rankings = await repository.getRankings(categorySlug: 'dosa', mode: 'best_value');
      expect(rankings, isNotEmpty);
      expect(rankings.first.rank, 1);
      expect(rankings.first.badge, 'Best Value');

      for (int i = 0; i < rankings.length - 1; i++) {
        expect(
          rankings[i].bestValueScore >= rankings[i + 1].bestValueScore,
          isTrue,
        );
      }
    });

    test('Rankings algorithm sorts by distance in nearest mode', () async {
      final rankings = await repository.getRankings(categorySlug: 'dosa', mode: 'nearest');
      expect(rankings, isNotEmpty);
      for (int i = 0; i < rankings.length - 1; i++) {
        final dist1 = rankings[i].distanceKm ?? 99;
        final dist2 = rankings[i + 1].distanceKm ?? 99;
        expect(dist1 <= dist2, isTrue);
      }
    });
  });
}
