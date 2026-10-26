require('dotenv').config();
const app = require('./app');
const storage = require('./db/storage');

const PORT = process.env.PORT || 4000;

async function startServer() {
  // Initialize storage layer (MySQL or fallback memory store)
  await storage.init();

  const server = app.listen(PORT, () => {
    console.log(`===============================================`);
    console.log(` TastyFind REST API Server running on port ${PORT}`);
    console.log(` Health check: http://localhost:${PORT}/api/health`);
    console.log(` Mode: ${process.env.NODE_ENV || 'development'}`);
    console.log(`===============================================`);
  });

  // Graceful shutdown
  const shutdown = () => {
    console.log('Shutting down server...');
    server.close(() => {
      console.log('TastyFind server closed gracefully.');
      process.exit(0);
    });
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}

if (require.main === module) {
  startServer();
}

module.exports = { startServer };
