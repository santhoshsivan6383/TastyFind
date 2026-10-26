const express = require('express');
const router = express.Router();
const rateLimit = require('express-rate-limit');
const controllers = require('../controllers/apiControllers');

// Specific rate limiter for review submission to prevent spam & abuse
const reviewSubmissionLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10, // Max 10 reviews per minute per IP
  message: {
    success: false,
    message: 'Too many reviews submitted from this IP, please try again after a minute.'
  },
  standardHeaders: true,
  legacyHeaders: false
});

// Health check
router.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'TastyFind API',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// Towns & Categories
router.get('/towns', controllers.getTowns);
router.get('/categories', controllers.getCategories);

// Restaurants
router.get('/restaurants', controllers.getRestaurants);
router.get('/restaurants/:id', controllers.getRestaurantById);
router.get('/restaurants/:id/menu', controllers.getRestaurantMenu);

// Dishes
router.get('/dishes', controllers.getDishes);
router.get('/dishes/:id', controllers.getDishById);
router.get('/dishes/:id/reviews', controllers.getReviewsByDishId);

// Rankings & Search
router.get('/rankings', controllers.getRankings);
router.get('/search', controllers.search);
router.get('/filters/options', controllers.getFilterOptions);

// Reviews (with rate limiting and input validation)
router.post('/reviews', reviewSubmissionLimiter, controllers.addReview);

// Saved Items / Wishlist
router.get('/users/me/saved', controllers.getSavedItems);
router.post('/users/me/saved', controllers.addSavedItem);
router.delete('/users/me/saved', controllers.removeSavedItem);
router.delete('/users/me/saved/:id', controllers.removeSavedItem);

// Notifications
router.get('/notifications', controllers.getNotifications);

module.exports = router;
