# TastyFind REST API Documentation

The TastyFind API server runs by default on `http://localhost:4000/api`.

All responses follow a standard envelope format:
```json
{
  "success": true,
  "data": { ... }
}
```

---

## Endpoints

### 1. Health Check
- **Endpoint**: `GET /api/health`
- **Description**: Returns service health status and timestamp.
- **Response**:
```json
{
  "status": "healthy",
  "service": "TastyFind API",
  "version": "1.0.0",
  "timestamp": "2026-10-26T10:45:00.000Z"
}
```

---

### 2. Towns
- **Endpoint**: `GET /api/towns`
- **Description**: Retrieves all supported towns.
- **Response**:
```json
{
  "success": true,
  "count": 5,
  "data": [
    { "id": 1, "name": "Erode", "state": "Tamil Nadu", "latitude": 11.341, "longitude": 77.7172 }
  ]
}
```

---

### 3. Categories
- **Endpoint**: `GET /api/categories`
- **Description**: Retrieves food craving categories (Dosa, Biryani, Parotta, etc.).
- **Response**:
```json
{
  "success": true,
  "count": 8,
  "data": [
    { "id": 1, "name": "Dosa", "slug": "dosa", "image_url": "https://..." }
  ]
}
```

---

### 4. Restaurants
- **Endpoint**: `GET /api/restaurants`
- **Query Parameters**:
  - `town_id` (integer, optional)
  - `min_rating` (number, optional)
  - `is_open_now` (boolean, optional)
  - `user_lat` (number, optional)
  - `user_lng` (number, optional)

- **Endpoint**: `GET /api/restaurants/:id`
- **Description**: Retrieves detailed restaurant profile including signature dishes and verified ordering links.

- **Endpoint**: `GET /api/restaurants/:id/menu`
- **Query Parameters**:
  - `category` (string, optional)

---

### 5. Dishes
- **Endpoint**: `GET /api/dishes`
- **Query Parameters**:
  - `town_id` (integer)
  - `category_slug` (string)
  - `vegetarian` (boolean)
  - `min_price` (number)
  - `max_price` (number)
  - `min_rating` (number)
  - `sort_by` (`price_asc` | `price_desc` | `rating`)

- **Endpoint**: `GET /api/dishes/:id`
- **Description**: Returns full dish details, ingredients, verified reviews, and 5-to-1 star rating percentage breakdown.

- **Endpoint**: `GET /api/dishes/:id/reviews`
- **Description**: Returns all approved customer reviews for the specified dish.

---

### 6. Dish Rankings (Bayesian Engine)
- **Endpoint**: `GET /api/rankings`
- **Query Parameters**:
  - `category` (string, default: `dosa`)
  - `town_id` (integer, default: `1`)
  - `mode` (`top_rated` | `best_value` | `nearest`)
  - `user_lat` (number, optional)
  - `user_lng` (number, optional)
- **Sample Response**:
```json
{
  "success": true,
  "category": "dosa",
  "mode": "top_rated",
  "count": 4,
  "algorithm": {
    "type": "Bayesian Weighted Rating with Best-Value Affordability Index",
    "formula": "WR = (v / (v + m)) * R + (m / (v + m)) * C",
    "parameter_m": 15,
    "benchmark_category_rating": 4.0
  },
  "data": [
    {
      "rank": 1,
      "id": 1,
      "name": "Masala Dosa",
      "restaurant_name": "Hotel Sri Murugan",
      "dish_rating": 4.8,
      "dish_review_count": 543,
      "bayesian_score": 4.78,
      "best_value_score": 88.5,
      "current_price": 70.0,
      "badge": "Best Overall",
      "highlight_quote": "Crispy dosa, amazing chutney"
    }
  ]
}
```

---

### 7. Search
- **Endpoint**: `GET /api/search`
- **Query Parameters**:
  - `q` (string, required query)
  - `town_id` (integer)
  - `type` (`all` | `restaurants` | `dishes`)

---

### 8. Filter Options & Presets
- **Endpoint**: `GET /api/filters/options`
- **Description**: Returns standardized presets for price, rating, distance, and sorting options.

---

### 9. Reviews Submission
- **Endpoint**: `POST /api/reviews`
- **Rate Limit**: Max 10 requests per minute per IP.
- **Request Body**:
```json
{
  "dish_id": 1,
  "rating": 5,
  "review_text": "Sensational crisp exterior with fresh coconut chutney!",
  "user_name": "Srinikethan"
}
```
- **Validation Rules**:
  - `rating`: required integer between 1 and 5.
  - `review_text`: optional string, maximum 1000 characters.

---

### 10. Saved Items / Wishlist
- **Endpoint**: `GET /api/users/me/saved?user_id=1`
- **Endpoint**: `POST /api/users/me/saved`
  - Body: `{ "user_id": 1, "entity_type": "dish", "entity_id": 1 }`
- **Endpoint**: `DELETE /api/users/me/saved`
  - Body: `{ "user_id": 1, "entity_type": "dish", "entity_id": 1 }`

---

### 11. Notifications
- **Endpoint**: `GET /api/notifications`
- **Description**: Retrieves review helpful notifications, price reduction updates, and restaurant news.
