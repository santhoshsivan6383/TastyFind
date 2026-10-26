/**
 * MySQL Database Seeding Script
 * Populates towns, restaurants, categories, dishes, reviews, and links.
 */

require('dotenv').config();
const mysql = require('mysql2/promise');
const seedData = require('./seedData');

async function seedDatabase() {
  const host = process.env.DB_HOST || '127.0.0.1';
  const port = process.env.DB_PORT || 3306;
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD || '';
  const database = process.env.DB_NAME || 'tastyfind_db';

  console.log(`[Seed] Connecting to MySQL at ${host}:${port}/${database}...`);
  try {
    const connection = await mysql.createConnection({
      host,
      port,
      user,
      password,
      database
    });

    // 1. Seed Towns
    for (const town of seedData.towns) {
      await connection.query(
        'INSERT INTO towns (id, name, state, country, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name)',
        [town.id, town.name, town.state, town.country, town.latitude, town.longitude]
      );
    }
    console.log(`[Seed] Seeded ${seedData.towns.length} towns.`);

    // 2. Seed Categories
    for (const cat of seedData.categories) {
      await connection.query(
        'INSERT INTO categories (id, name, slug, image_url) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name)',
        [cat.id, cat.name, cat.slug, cat.image_url]
      );
    }
    console.log(`[Seed] Seeded ${seedData.categories.length} categories.`);

    // 3. Seed Restaurants
    for (const rest of seedData.restaurants) {
      await connection.query(
        `INSERT INTO restaurants 
         (id, town_id, name, description, address, latitude, longitude, phone, opening_hours, overall_rating, overall_review_count, min_price, max_price, cover_image_url)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE name=VALUES(name), overall_rating=VALUES(overall_rating)`,
        [
          rest.id, rest.town_id, rest.name, rest.description, rest.address,
          rest.latitude, rest.longitude, rest.phone, rest.opening_hours,
          rest.overall_rating, rest.overall_review_count, rest.min_price, rest.max_price, rest.cover_image_url
        ]
      );
    }
    console.log(`[Seed] Seeded ${seedData.restaurants.length} restaurants.`);

    // 4. Seed Dishes
    for (const dish of seedData.dishes) {
      await connection.query(
        `INSERT INTO dishes 
         (id, restaurant_id, category_id, name, description, current_price, currency, dish_rating, dish_review_count, image_url, vegetarian, availability_status, badge, highlight_quote)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE name=VALUES(name), dish_rating=VALUES(dish_rating)`,
        [
          dish.id, dish.restaurant_id, dish.category_id, dish.name, dish.description,
          dish.current_price, dish.currency, dish.dish_rating, dish.dish_review_count,
          dish.image_url, dish.vegetarian ? 1 : 0, dish.availability_status,
          dish.badge, dish.highlight_quote
        ]
      );
    }
    console.log(`[Seed] Seeded ${seedData.dishes.length} dishes.`);

    // 5. Seed Reviews
    for (const rev of seedData.reviews) {
      await connection.query(
        `INSERT INTO reviews (id, user_id, user_name, user_avatar, dish_id, rating, review_text, moderation_status, helpful_count)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE rating=VALUES(rating)`,
        [rev.id, rev.user_id, rev.user_name, rev.user_avatar, rev.dish_id, rev.rating, rev.review_text, rev.moderation_status, rev.helpful_count]
      );
    }
    console.log(`[Seed] Seeded ${seedData.reviews.length} reviews.`);

    // 6. Seed Ordering Links
    for (const link of seedData.orderingLinks) {
      await connection.query(
        `INSERT INTO restaurant_ordering_links (id, restaurant_id, platform, url, verification_status)
         VALUES (?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE url=VALUES(url)`,
        [link.id, link.restaurant_id, link.platform, link.url, link.verification_status]
      );
    }
    console.log(`[Seed] Seeded ${seedData.orderingLinks.length} ordering links.`);

    console.log(`[Seed] Database seeding completed successfully!`);
    await connection.end();
  } catch (err) {
    console.error(`[Seed] Seeding failed: ${err.message}`);
    process.exit(1);
  }
}

if (require.main === module) {
  seedDatabase();
}

module.exports = { seedDatabase };
