/**
 * TastyFind Ranking Service
 * Implements Bayesian Weighted Rating, Best-Value Score, and Haversine Distance Calculation.
 */

// Earth radius in kilometers for Haversine formula
const EARTH_RADIUS_KM = 6371;

/**
 * Calculates the Haversine distance between two coordinates in kilometers.
 * @param {number} lat1 
 * @param {number} lon1 
 * @param {number} lat2 
 * @param {number} lon2 
 * @returns {number|null} Distance in kilometers rounded to 1 decimal place, or null if coordinates invalid
 */
function calculateDistance(lat1, lon1, lat2, lon2) {
  if (lat1 === undefined || lat1 === null || lon1 === undefined || lon1 === null ||
      lat2 === undefined || lat2 === null || lon2 === undefined || lon2 === null) {
    return null;
  }

  const dLat = (lat2 - lat1) * (Math.PI / 180);
  const dLon = (lon2 - lon1) * (Math.PI / 180);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * (Math.PI / 180)) *
      Math.cos(lat2 * (Math.PI / 180)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = EARTH_RADIUS_KM * c;

  return Math.round(distance * 10) / 10;
}

/**
 * Calculates Bayesian Weighted Rating for a dish.
 * Formula: WR = (v / (v + m)) * R + (m / (v + m)) * C
 * 
 * @param {number} r - Average rating of the dish (R)
 * @param {number} v - Number of reviews for the dish (v)
 * @param {number} c - Benchmark average rating across the category/town (C)
 * @param {number} m - Minimum review threshold parameter (m, default 15)
 * @returns {number} Weighted Bayesian rating between 0 and 5, rounded to 2 decimal places
 */
function calculateBayesianRating(r, v, c = 4.2, m = 15) {
  if (!v || v <= 0 || !r || r <= 0) {
    // Dishes with no reviews have 0 weighted rating, no fabricated rating
    return 0.0;
  }
  const weighted = (v / (v + m)) * r + (m / (v + m)) * c;
  return Math.round(weighted * 100) / 100;
}

/**
 * Calculates a transparent Best-Value score considering quality (Bayesian rating) relative to price.
 * Higher score indicates superior culinary rating per rupee spent.
 * 
 * @param {number} bayesianRating 
 * @param {number} price 
 * @param {number} baselinePrice - Category average or median price (default: 70)
 * @returns {number} Score from 0 to 100
 */
function calculateBestValueScore(bayesianRating, price, baselinePrice = 70) {
  if (!price || price <= 0 || !bayesianRating || bayesianRating <= 0) {
    return 0.0;
  }
  // Ratio of baseline to actual price, dampened to avoid extreme skew on ultra-cheap items
  const priceAffordabilityFactor = Math.sqrt(baselinePrice / Math.max(price, 20));
  const qualityFactor = bayesianRating / 5.0;
  const rawScore = qualityFactor * priceAffordabilityFactor * 85;
  return Math.round(Math.min(100, Math.max(0, rawScore)) * 10) / 10;
}

/**
 * Ranks an array of dishes based on ranking mode.
 * Modes: 'top_rated' | 'best_value' | 'nearest'
 * 
 * @param {Array} dishes 
 * @param {Object} options
 * @param {string} options.mode - 'top_rated' | 'best_value' | 'nearest'
 * @param {number} [options.userLat]
 * @param {number} [options.userLng]
 * @param {number} [options.m] - Minimum reviews threshold for Bayesian rating
 * @param {number} [options.categoryAvgRating]
 * @returns {Array} Sorted and decorated dishes with rank, scores, and badges
 */
function rankDishes(dishes, options = {}) {
  const {
    mode = 'top_rated',
    userLat,
    userLng,
    m = 15,
    categoryAvgRating
  } = options;

  // Default benchmark average rating C across category and town (default: 4.0)
  let benchmarkC = categoryAvgRating !== undefined ? categoryAvgRating : 4.0;


  // Calculate category baseline price
  const validPrices = dishes.map(d => Number(d.current_price)).filter(p => p > 0);
  const baselinePrice = validPrices.length > 0
    ? validPrices.reduce((a, b) => a + b, 0) / validPrices.length
    : 70;

  // Augment each dish with calculated metrics
  const scoredDishes = dishes.map(dish => {
    const r = Number(dish.dish_rating) || 0;
    const v = Number(dish.dish_review_count) || 0;
    const price = Number(dish.current_price) || 0;

    const bayesianRating = calculateBayesianRating(r, v, benchmarkC, m);
    const bestValueScore = calculateBestValueScore(bayesianRating, price, baselinePrice);

    let distance = null;
    if (userLat !== undefined && userLng !== undefined && dish.restaurant_lat && dish.restaurant_lng) {
      distance = calculateDistance(userLat, userLng, dish.restaurant_lat, dish.restaurant_lng);
    } else if (dish.distance_km !== undefined) {
      distance = dish.distance_km;
    }

    return {
      ...dish,
      bayesian_score: bayesianRating,
      best_value_score: bestValueScore,
      distance_km: distance,
      benchmark_c: Math.round(benchmarkC * 100) / 100
    };
  });

  // Sort according to mode
  scoredDishes.sort((a, b) => {
    if (mode === 'best_value') {
      return b.best_value_score - a.best_value_score;
    } else if (mode === 'nearest') {
      if (a.distance_km === null && b.distance_km === null) return 0;
      if (a.distance_km === null) return 1;
      if (b.distance_km === null) return -1;
      return a.distance_km - b.distance_km;
    } else {
      // Default: top_rated (Bayesian Weighted Rating)
      // If Bayesian score differs, sort by score descending
      if (b.bayesian_score !== a.bayesian_score) {
        return b.bayesian_score - a.bayesian_score;
      }
      // Tie breaker: review count then raw rating
      if ((b.dish_review_count || 0) !== (a.dish_review_count || 0)) {
        return (b.dish_review_count || 0) - (a.dish_review_count || 0);
      }
      return (b.dish_rating || 0) - (a.dish_rating || 0);
    }
  });

  // Assign 1-indexed ranks and badges
  return scoredDishes.map((dish, index) => {
    let computedBadge = dish.badge;
    if (!computedBadge) {
      if (index === 0 && mode === 'top_rated') {
        computedBadge = 'Best Overall';
      } else if (index === 0 && mode === 'best_value') {
        computedBadge = 'Best Value';
      } else if (dish.best_value_score >= 80) {
        computedBadge = 'Great Value';
      } else if (dish.bayesian_score >= 4.5 && (dish.dish_review_count || 0) >= 300) {
        computedBadge = 'Top Rated';
      }
    }

    return {
      rank: index + 1,
      ...dish,
      badge: computedBadge
    };
  });
}

module.exports = {
  calculateDistance,
  calculateBayesianRating,
  calculateBestValueScore,
  rankDishes
};
