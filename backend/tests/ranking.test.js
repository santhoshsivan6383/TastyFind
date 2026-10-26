const test = require('node:test');
const assert = require('node:assert/strict');
const {
  calculateDistance,
  calculateBayesianRating,
  calculateBestValueScore,
  rankDishes
} = require('../src/services/rankingService');

test('Haversine distance calculation', () => {
  // Erode center to a nearby location ~0.8 km
  const lat1 = 11.3410;
  const lon1 = 77.7172;
  const lat2 = 11.3480;
  const lon2 = 77.7210;
  const dist = calculateDistance(lat1, lon1, lat2, lon2);
  assert.ok(dist !== null, 'Distance should not be null');
  assert.ok(dist >= 0.7 && dist <= 1.2, `Calculated distance ${dist}km should be around 0.9km`);

  // Same point
  assert.equal(calculateDistance(lat1, lon1, lat1, lon1), 0.0);

  // Missing coordinates
  assert.equal(calculateDistance(null, 77.7, 11.3, 77.7), null);
});

test('Bayesian weighted rating calculation', () => {
  const benchmarkC = 4.2;
  const minThresholdM = 15;

  // Case 1: Dish with 1 review of 5.0 vs Dish with 500 reviews of 4.8
  const scoreFewReviews = calculateBayesianRating(5.0, 1, benchmarkC, minThresholdM);
  const scoreManyReviews = calculateBayesianRating(4.8, 500, benchmarkC, minThresholdM);

  // With 1 review: (1 / 16) * 5.0 + (15 / 16) * 4.2 = 0.3125 + 3.9375 = 4.25
  assert.ok(scoreFewReviews < scoreManyReviews, 'Dish with 1 review should be dampened toward prior benchmark');
  assert.equal(scoreFewReviews, 4.25);

  // With 500 reviews: close to 4.8
  assert.ok(scoreManyReviews >= 4.75 && scoreManyReviews <= 4.82);

  // Dish with 0 reviews
  assert.equal(calculateBayesianRating(0, 0, benchmarkC, minThresholdM), 0.0);
});

test('Best Value Score calculation', () => {
  // High rating (4.8) at low price (₹60) vs High rating (4.8) at high price (₹250)
  const affordableValue = calculateBestValueScore(4.8, 60, 70);
  const expensiveValue = calculateBestValueScore(4.8, 250, 70);

  assert.ok(affordableValue > expensiveValue, 'Affordable dish should have higher best-value score');
  assert.ok(affordableValue > 70, 'Affordable dish should score high');
});

test('rankDishes sorting modes', () => {
  const sampleDishes = [
    {
      id: 1,
      name: 'Masala Dosa A',
      dish_rating: 4.8,
      dish_review_count: 543,
      current_price: 70,
      restaurant_lat: 11.3410,
      restaurant_lng: 77.7172
    },
    {
      id: 2,
      name: 'Masala Dosa B (Cheap)',
      dish_rating: 4.6,
      dish_review_count: 612,
      current_price: 50,
      restaurant_lat: 11.3440,
      restaurant_lng: 77.7240
    },
    {
      id: 3,
      name: 'Masala Dosa C (Single Review 5 Star)',
      dish_rating: 5.0,
      dish_review_count: 1,
      current_price: 90,
      restaurant_lat: 11.3500,
      restaurant_lng: 77.7300
    }
  ];

  // Top Rated ranking
  const topRated = rankDishes(sampleDishes, { mode: 'top_rated' });
  assert.equal(topRated[0].name, 'Masala Dosa A', 'Established top dish should rank #1, not single-review dish');
  assert.equal(topRated[0].rank, 1);

  // Best Value ranking
  const bestValue = rankDishes(sampleDishes, { mode: 'best_value' });
  assert.equal(bestValue[0].name, 'Masala Dosa B (Cheap)', 'Lowest priced high-quality dish should rank #1 in best value');

  // Nearest ranking
  const nearest = rankDishes(sampleDishes, {
    mode: 'nearest',
    userLat: 11.3410,
    userLng: 77.7172
  });
  assert.equal(nearest[0].name, 'Masala Dosa A', 'Closest dish should rank #1');
});
