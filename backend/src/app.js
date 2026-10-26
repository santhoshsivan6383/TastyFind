const express = require('express');
const cors = require('cors');
const apiRoutes = require('./routes/api');
const errorHandler = require('./middleware/errorHandler');

const app = express();

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logger for API calls
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    if (process.env.NODE_ENV !== 'test') {
      console.log(`[API] ${req.method} ${req.originalUrl} - ${res.statusCode} (${duration}ms)`);
    }
  });
  next();
});

// API Routes
app.use('/api', apiRoutes);

// Root fallback / Info
app.get('/', (req, res) => {
  res.json({
    app: 'TastyFind Food Discovery API',
    version: '1.0.0',
    documentation: '/api/health',
    endpoints: [
      '/api/health',
      '/api/towns',
      '/api/categories',
      '/api/dishes',
      '/api/restaurants',
      '/api/rankings',
      '/api/search',
      '/api/filters/options',
      '/api/users/me/saved'
    ]
  });
});

// Centralized error handling
app.use(errorHandler);

module.exports = app;
