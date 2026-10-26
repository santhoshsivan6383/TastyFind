/**
 * MySQL Migration Script
 * Reads schema.sql and creates tables in the configured database.
 */

require('dotenv').config();
const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');

async function runMigration() {
  const host = process.env.DB_HOST || '127.0.0.1';
  const port = process.env.DB_PORT || 3306;
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD || '';
  const database = process.env.DB_NAME || 'tastyfind_db';

  console.log(`Connecting to MySQL at ${host}:${port}...`);
  try {
    const connection = await mysql.createConnection({
      host,
      port,
      user,
      password,
      multipleStatements: true
    });

    const schemaPath = path.join(__dirname, 'schema.sql');
    const sql = fs.readFileSync(schemaPath, 'utf8');

    console.log(`Executing schema definition from ${schemaPath}...`);
    await connection.query(sql);

    console.log(`Migration completed successfully! Database "${database}" is ready.`);
    await connection.end();
  } catch (err) {
    console.error(`Migration failed: ${err.message}`);
    console.log(`Note: If running without a local MySQL instance, the TastyFind app runs automatically using its built-in local store fallback.`);
    process.exit(1);
  }
}

if (require.main === module) {
  runMigration();
}

module.exports = { runMigration };
