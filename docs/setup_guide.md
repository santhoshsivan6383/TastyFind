# TastyFind Setup & Operations Guide

## 1. System Requirements

- **Node.js**: v18.0.0 or later (v24.19+ recommended)
- **npm**: v9.0.0 or later
- **Flutter SDK**: 3.19.0 or later
- **Dart SDK**: 3.0.0 or later
- **MySQL**: 8.0 or later (Optional for local development; built-in high-fidelity memory store fallback is included)

---

## 2. Backend Setup & Run Instructions

### Step 1: Install Dependencies
Open a terminal in `backend/`:
```bash
cd backend
npm install
```

### Step 2: Configure Environment
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```
Default configuration:
```env
PORT=4000
NODE_ENV=development
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=tastyfind_db
USE_LOCAL_FALLBACK=true
```

### Step 3: Database Migration & Seeding (MySQL)
If your MySQL instance is running:
```bash
npm run db:migrate
npm run db:seed
```
*Note*: If MySQL is not running on port 3306, the backend automatically boots with its built-in in-memory storage seeded with all realistic demo records.

### Step 4: Run Automated Tests
```bash
npm test
```
This executes all 18 test suites testing the REST API endpoints, Bayesian ranking mathematics, Best Value scores, filter options, and review validations.

### Step 5: Start the API Server
```bash
npm start
# or development watch mode:
npm run dev
```
The server will start on `http://localhost:4000`. Test endpoint: `http://localhost:4000/api/health`.

---

## 3. Flutter Mobile Application Setup

### Step 1: Install Dependencies
Open a terminal in `mobile/`:
```bash
cd mobile
flutter pub get
```

### Step 2: Run Flutter Automated Tests
```bash
flutter test
```
Executes:
- Data model JSON serialization/deserialization tests.
- Reusable UI component widget tests (`RatingBadge`, `PriceTag`, `PrimaryButton`, `FeedbackWidgets`).
- Bayesian ranking sorting and tie-breaker tests.
- Multi-criteria filter state notifier tests.

### Step 3: Run the Mobile Application
- **Android Emulator**:
  ```bash
  flutter run -d emulator-5554
  ```
- **iOS Simulator**:
  ```bash
  flutter run -d iPhone
  ```
- **Chrome / Web**:
  ```bash
  flutter run -d chrome
  ```
- **Windows Desktop**:
  ```bash
  flutter run -d windows
  ```

---

## 4. Production & External Integrations Checklist

The following features operate with local fallbacks in development and require external credentials/approvals for production release:

| Feature | Local Dev Implementation | Production Requirement |
| :--- | :--- | :--- |
| **Swiggy Ordering** | Verified URL deep link (`https://www.swiggy.com/restaurants/...`) | Swiggy Affiliate / Partner Program API |
| **Zomato Ordering** | Verified URL deep link (`https://www.zomato.com/...`) | Zomato Partner Deeplink Agreement |
| **Live Geolocation** | Coordinate distance calculation with manual town selector | Platform location permissions & Google Places API Key |
| **Review Moderation** | Instant auto-approval with length & rate-limit validation | Automated profanity filter & Admin Moderation Queue |
| **Push Notifications**| In-app notification list | Firebase Cloud Messaging (FCM) & Apple APNs |
| **Persistent User Auth**| Local guest session with default Srinikethan profile | OAuth2 / Supabase Auth / Firebase Phone Auth |
