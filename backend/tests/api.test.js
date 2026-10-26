const test = require('node:test');
const assert = require('node:assert/strict');
const request = require('supertest');
const app = require('../src/app');

test('GET /api/health returns 200 and healthy status', async () => {
  const res = await request(app).get('/api/health');
  assert.equal(res.status, 200);
  assert.equal(res.body.status, 'healthy');
});

test('GET /api/towns returns list of towns', async () => {
  const res = await request(app).get('/api/towns');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  assert.ok(res.body.data.some(t => t.name === 'Erode'));
});

test('GET /api/categories returns food categories', async () => {
  const res = await request(app).get('/api/categories');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  assert.ok(res.body.data.some(c => c.slug === 'dosa'));
});

test('GET /api/restaurants returns restaurants', async () => {
  const res = await request(app).get('/api/restaurants');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  assert.ok(res.body.data.some(r => r.name === 'Hotel Sri Murugan'));
});

test('GET /api/restaurants/:id returns full restaurant details and menu count', async () => {
  const res = await request(app).get('/api/restaurants/1');
  assert.equal(res.status, 200);
  assert.equal(res.body.data.name, 'Hotel Sri Murugan');
  assert.ok(res.body.data.ordering_links.length > 0);
});

test('GET /api/dishes returns dishes with filters', async () => {
  const res = await request(app).get('/api/dishes?category_slug=dosa');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  assert.ok(res.body.data.every(d => d.category_slug === 'dosa'));
});

test('GET /api/dishes/:id returns dish with reviews and rating distribution', async () => {
  const res = await request(app).get('/api/dishes/1');
  assert.equal(res.status, 200);
  assert.equal(res.body.data.name, 'Masala Dosa');
  assert.ok(res.body.data.rating_distribution);
  assert.ok(res.body.data.rating_distribution[5] > 0);
});

test('GET /api/rankings returns Bayesian ranked dishes', async () => {
  const res = await request(app).get('/api/rankings?category=dosa&mode=top_rated');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.length > 0);
  assert.equal(res.body.data[0].rank, 1);
  assert.ok(res.body.data[0].bayesian_score > 0);
});

test('GET /api/search returns matches for "dosa"', async () => {
  const res = await request(app).get('/api/search?q=dosa');
  assert.equal(res.status, 200);
  assert.ok(res.body.data.dishes.length > 0 || res.body.data.restaurants.length > 0);
});

test('POST /api/reviews validates rating input', async () => {
  // Invalid rating
  const invalidRes = await request(app)
    .post('/api/reviews')
    .send({ dish_id: 1, rating: 6, review_text: 'Invalid' });
  assert.equal(invalidRes.status, 400);

  // Valid rating
  const validRes = await request(app)
    .post('/api/reviews')
    .send({ dish_id: 1, rating: 5, review_text: 'Sensational crispy texture!' });
  assert.equal(validRes.status, 201);
  assert.equal(validRes.body.data.rating, 5);
});

test('Saved items API supports GET, POST, and DELETE', async () => {
  // Add dish to saved
  const postRes = await request(app)
    .post('/api/users/me/saved')
    .send({ entity_type: 'dish', entity_id: 2 });
  assert.equal(postRes.status, 201);

  // Retrieve saved items
  const getRes = await request(app).get('/api/users/me/saved');
  assert.equal(getRes.status, 200);
  assert.ok(getRes.body.data.dishes.some(d => d.id === 2));

  // Remove saved item
  const delRes = await request(app)
    .delete('/api/users/me/saved')
    .send({ entity_type: 'dish', entity_id: 2 });
  assert.equal(delRes.status, 200);
});
