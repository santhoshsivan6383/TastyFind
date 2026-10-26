const storage = require('../db/storage');
const rankingService = require('../services/rankingService');

// Town Controller
exports.getTowns = async (req, res, next) => {
  try {
    const towns = await storage.getTowns();
    res.json({ success: true, count: towns.length, data: towns });
  } catch (err) {
    next(err);
  }
};

// Category Controller
exports.getCategories = async (req, res, next) => {
  try {
    const categories = await storage.getCategories();
    res.json({ success: true, count: categories.length, data: categories });
  } catch (err) {
    next(err);
  }
};

// Restaurant Controller
exports.getRestaurants = async (req, res, next) => {
  try {
    const { town_id, min_rating, is_open_now, user_lat, user_lng } = req.query;
    let restaurants = await storage.getRestaurants({ town_id, min_rating, is_open_now });

    if (user_lat && user_lng) {
      restaurants = restaurants.map(r => ({
        ...r,
        distance_km: rankingService.calculateDistance(Number(user_lat), Number(user_lng), r.latitude, r.longitude)
      }));
    }

    res.json({ success: true, count: restaurants.length, data: restaurants });
  } catch (err) {
    next(err);
  }
};

exports.getRestaurantById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const restaurant = await storage.getRestaurantById(id);
    if (!restaurant) {
      return res.status(404).json({ success: false, message: 'Restaurant not found' });
    }
    res.json({ success: true, data: restaurant });
  } catch (err) {
    next(err);
  }
};

exports.getRestaurantMenu = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { category } = req.query;
    const menuDishes = await storage.getRestaurantMenu(id, category);
    res.json({ success: true, count: menuDishes.length, data: menuDishes });
  } catch (err) {
    next(err);
  }
};

// Dish Controller
exports.getDishes = async (req, res, next) => {
  try {
    const {
      town_id,
      category_id,
      category_slug,
      vegetarian,
      min_price,
      max_price,
      min_rating,
      user_lat,
      user_lng,
      sort_by
    } = req.query;

    let dishes = await storage.getDishes({
      town_id,
      category_id,
      category_slug,
      vegetarian,
      min_price,
      max_price,
      min_rating
    });

    // Decorate distance if user coordinates provided
    if (user_lat && user_lng) {
      dishes = dishes.map(d => ({
        ...d,
        distance_km: rankingService.calculateDistance(Number(user_lat), Number(user_lng), d.restaurant_lat, d.restaurant_lng)
      }));
    }

    // Sort if requested
    if (sort_by === 'price_asc') {
      dishes.sort((a, b) => a.current_price - b.current_price);
    } else if (sort_by === 'price_desc') {
      dishes.sort((a, b) => b.current_price - a.current_price);
    } else if (sort_by === 'rating') {
      dishes.sort((a, b) => b.dish_rating - a.dish_rating);
    }

    res.json({ success: true, count: dishes.length, data: dishes });
  } catch (err) {
    next(err);
  }
};

exports.getDishById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const dish = await storage.getDishById(id);
    if (!dish) {
      return res.status(404).json({ success: false, message: 'Dish not found' });
    }
    res.json({ success: true, data: dish });
  } catch (err) {
    next(err);
  }
};

// Rankings Controller using Bayesian Algorithm
exports.getRankings = async (req, res, next) => {
  try {
    const {
      category = 'dosa',
      town_id = 1,
      mode = 'top_rated',
      user_lat,
      user_lng,
      vegetarian,
      min_price,
      max_price
    } = req.query;

    const dishes = await storage.getDishes({
      town_id,
      category_slug: category,
      vegetarian,
      min_price,
      max_price
    });

    const ranked = rankingService.rankDishes(dishes, {
      mode,
      userLat: user_lat ? Number(user_lat) : undefined,
      userLng: user_lng ? Number(user_lng) : undefined
    });

    res.json({
      success: true,
      category,
      mode,
      count: ranked.length,
      algorithm: {
        type: 'Bayesian Weighted Rating with Best-Value Affordability Index',
        formula: 'WR = (v / (v + m)) * R + (m / (v + m)) * C',
        parameter_m: 15,
        benchmark_category_rating: ranked.length > 0 ? ranked[0].benchmark_c : 4.2
      },
      data: ranked
    });
  } catch (err) {
    next(err);
  }
};

// Search Controller
exports.search = async (req, res, next) => {
  try {
    const { q = '', town_id = 1, type = 'all' } = req.query;
    const results = await storage.search(q, town_id, type);
    res.json({ success: true, data: results });
  } catch (err) {
    next(err);
  }
};

// Reviews Controller
exports.getReviewsByDishId = async (req, res, next) => {
  try {
    const { id } = req.params;
    const reviews = await storage.getReviewsByDishId(id);
    res.json({ success: true, count: reviews.length, data: reviews });
  } catch (err) {
    next(err);
  }
};

exports.addReview = async (req, res, next) => {
  try {
    const { dish_id, rating, review_text, image_url, user_name } = req.body;

    if (!dish_id) {
      return res.status(400).json({ success: false, message: 'dish_id is required' });
    }
    const numRating = Number(rating);
    if (isNaN(numRating) || numRating < 1 || numRating > 5) {
      return res.status(400).json({ success: false, message: 'Rating must be an integer between 1 and 5' });
    }
    if (review_text && review_text.length > 1000) {
      return res.status(400).json({ success: false, message: 'Review text exceeds maximum limit of 1000 characters' });
    }

    const review = await storage.addReview({
      dish_id,
      rating: numRating,
      review_text,
      image_url,
      user_name
    });

    res.status(201).json({
      success: true,
      message: 'Review submitted successfully',
      data: review
    });
  } catch (err) {
    next(err);
  }
};

// Saved / Wishlist Controller
exports.getSavedItems = async (req, res, next) => {
  try {
    const userId = req.query.user_id || 1;
    const saved = await storage.getSavedItems(userId);
    res.json({ success: true, data: saved });
  } catch (err) {
    next(err);
  }
};

exports.addSavedItem = async (req, res, next) => {
  try {
    const { user_id = 1, entity_type, entity_id } = req.body;
    if (!entity_type || !['restaurant', 'dish'].includes(entity_type)) {
      return res.status(400).json({ success: false, message: 'entity_type must be "restaurant" or "dish"' });
    }
    if (!entity_id) {
      return res.status(400).json({ success: false, message: 'entity_id is required' });
    }

    const saved = await storage.addSavedItem(user_id, entity_type, entity_id);
    res.status(201).json({ success: true, message: 'Added to saved items', data: saved });
  } catch (err) {
    next(err);
  }
};

exports.removeSavedItem = async (req, res, next) => {
  try {
    const { user_id = 1, entity_type, entity_id } = req.body;
    if (!entity_type || !entity_id) {
      return res.status(400).json({ success: false, message: 'entity_type and entity_id are required' });
    }

    const removed = await storage.removeSavedItem(user_id, entity_type, entity_id);
    res.json({ success: true, message: 'Removed from saved items', data: removed });
  } catch (err) {
    next(err);
  }
};

// Filter Options Controller
exports.getFilterOptions = async (req, res, next) => {
  try {
    res.json({
      success: true,
      data: {
        price_presets: [
          { label: 'Under ₹50', min: 0, max: 50 },
          { label: '₹50 – ₹100', min: 50, max: 100 },
          { label: '₹100 – ₹150', min: 100, max: 150 },
          { label: '₹150+', min: 150, max: 1000 }
        ],
        rating_presets: [
          { label: '4.0+', min_rating: 4.0 },
          { label: '4.5+', min_rating: 4.5 },
          { label: '4.7+', min_rating: 4.7 }
        ],
        distance_presets: [
          { label: 'Within 1 km', max_distance_km: 1.0 },
          { label: 'Within 3 km', max_distance_km: 3.0 },
          { label: 'Within 5 km', max_distance_km: 5.0 }
        ],
        sort_modes: [
          { id: 'top_rated', label: 'Top Rated (Bayesian)' },
          { id: 'best_value', label: 'Best Value' },
          { id: 'nearest', label: 'Nearest' }
        ],
        toggles: [
          { key: 'is_open_now', label: 'Open now' },
          { key: 'vegetarian', label: 'Veg only' }
        ]
      }
    });
  } catch (err) {
    next(err);
  }
};

// Notification Controller
exports.getNotifications = async (req, res, next) => {
  try {
    const notifications = await storage.getNotifications();
    res.json({ success: true, count: notifications.length, data: notifications });
  } catch (err) {
    next(err);
  }
};
