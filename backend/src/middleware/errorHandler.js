// Centralized Express Error Handler

module.exports = function errorHandler(err, req, res, next) {
  const statusCode = err.status || err.statusCode || 500;
  console.error(`[Error] ${req.method} ${req.originalUrl}:`, err.message);

  res.status(statusCode).json({
    success: false,
    message: err.message || 'Internal server error occurred',
    errors: err.errors || null,
    stack: process.env.NODE_ENV === 'development' ? err.stack : undefined
  });
};
