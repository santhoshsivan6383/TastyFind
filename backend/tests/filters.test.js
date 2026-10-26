const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const app = require('../src/app');

test('Price range filter limits dishes correctly', async () => {
  const res = await request(app).get('/api/dishes?min_price=60&max_price=70');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  for (const dish of res.body.data) {
    assert.ok(dish.current_price >= 60, `Dish price ${dish.current_price} should be >= 60`);
    assert.ok(dish.current_price <= 70, `Dish price ${dish.current_price} should be <= 70`);
  }
});

test('Vegetarian filter isolates pure veg dishes', async () => {
  const res = await request(app).get('/api/dishes?vegetarian=true');
  assert.equal(res.status, 200);
  for (const dish of res.body.data) {
    assert.equal(dish.vegetarian, true);
  }
});

test('Filter options endpoint provides required presets', async () => {
  const res = await request(app).get('/api/filters/options');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.price_presets.length >= 4);
  assert.ok(res.body.data.rating_presets.length >= 3);
  assert.ok(res.body.data.distance_presets.length >= 3);
});
