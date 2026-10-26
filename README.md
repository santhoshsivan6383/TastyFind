# TastyFind — Food Discovery Mobile App & API

> **"Find the best food in your town, not just popular ones."**

**TastyFind** is a dish-first mobile food discovery platform built with Flutter and Node.js. Unlike traditional apps that rank restaurants as a whole, TastyFind ranks **individual food dishes** (such as the finest Masala Dosa, Biryani, or Parotta in town) using an algorithmic **Bayesian Weighted Rating** and an affordability-adjusted **Best-Value Index**, allowing food lovers to compare prices, read dish-level customer reviews, and order directly through Swiggy or Zomato.

---

## Visual Design & Screen Catalog (18 Implemented Screens)

The application faithfully implements all 18 screens shown in the TastyFind mockup:

| # | Screen | Description |
| :---: | :--- | :--- |
| **1** | **Splash Screen** | Dark food photography, TastyFind location-pin logo, tagline, "Get Started" CTA, and login link. |
| **2** | **Onboarding** | Carousel of core features with Masala Dosa photography, smooth indicator dots, Skip, and Next actions. |
| **3** | **Location Permission** | Concentric radar map graphic, location access justification, "Allow Location" CTA, and manual town fallback. |
| **4** | **Home Screen** | Current town selector (`📍 Erode ⌄`), search bar, cravings banner, food categories, popular dishes, and nearby spots. |
| **5** | **Search Results** | Live search input with debouncing and clear action, [All / Restaurants / Dishes] filter tabs, top dishes & restaurants. |
| **6** | **Dish-Specific Rankings** | Ranked dishes for a category (e.g. Dosa), segmented modes: [Top Rated (Bayesian), Best Value, Nearest], badges, quotes, and "View Menu" buttons. |
| **7** | **Restaurant Details** | Hero cover photo, overall rating, South Indian cuisine tags, signature dishes chips, Direction / Call / Share actions, and full menu CTA. |
| **8** | **Menu / Dish List** | Restaurant menu categorized by food type ([Dosa, Idli, Vada, Others]), ratings, verified prices, and item addition. |
| **9** | **Dish Details** | Large hero dish photography, dish name, price tag, ingredients, 5-to-1 star rating percentage breakdown bars, verified customer reviews, and ordering CTA. |
| **10** | **Filter Options** | Multi-criteria filters: Price ranges (Under ₹50, ₹50–₹100, etc.), Ratings (4.0+, 4.5+), Distances (Within 1km, 3km), Veg-only, and Open-now. |
| **11** | **Filtered Results** | Active removable chips (`[₹50 - ₹100 ✕] [4.5+ ✕] [Within 3km ✕]`) updating matching dish cards in real-time with empty state handling. |
| **12** | **Order via Swiggy / Zomato** | Platform selection screen with verified brand buttons: Swiggy (Orange) and Zomato (Red), redirection disclaimer, and wishlist shortcut. |
| **13** | **Saved / Wishlist** | Dual tabs for [Saved Restaurants] and [Saved Dishes] with active orange heart bookmarks and quick removal. |
| **14** | **User Profile** | User avatar (Srinikethan), Edit Profile action, My Orders, Saved Restaurants, Reviews, Settings, and Help & Support links. |
| **15** | **Add Review** | Interactive 5-star rating selector, multiline review input with character validation, photo upload simulator, and submission handling. |
| **16** | **Order Redirect** | Phone mockup with green checkmark, neutral redirection disclaimer ("Opening Swiggy / Zomato..."), and return actions. |
| **17** | **Notifications** | Timeline of review helpfulness likes, 20% promotional discounts, price update alerts, and new restaurant additions. |
| **18** | **Settings** | Account preferences, town switcher, notification toggles, Dark Mode switch, FAQs, and contact links. |

---

## Technology Stack

- **Mobile Client**: Flutter 3.19+ / Dart 3 (Null Safety).
- **State Management**: Flutter Riverpod (`flutter_riverpod: ^2.5.1`).
- **Navigation**: Declarative GoRouter (`go_router: ^14.2.0`).
- **Networking**: Dio (`dio: ^5.4.3+1`) with request/response interceptors and fallback caching.
- **Backend API**: Node.js & Express 4.x.
- **Database**: MySQL 8.0 with automatic high-fidelity in-memory storage fallback.
- **External Launch**: `url_launcher: ^6.3.0` for Swiggy/Zomato deep linking, phone dialer, and Google Maps.

---

## Repository Structure

```
food optimizer/
├── mobile/                      # Flutter Mobile Application
│   ├── pubspec.yaml             # Flutter dependencies & assets
│   ├── analysis_options.yaml    # Linter rules
│   ├── lib/
│   │   ├── main.dart            # App entry point (ProviderScope)
│   │   ├── app.dart             # MaterialApp.router with themes
│   │   ├── theme/               # Design tokens (AppColors, AppTypography, AppTheme)
│   │   ├── router/              # GoRouter configuration for all 18 screens
│   │   ├── models/              # Dart data models (Town, Dish, Restaurant, etc.)
│   │   ├── data/                # ApiClient, FoodRepository & MockData fallback
│   │   ├── providers/           # Riverpod state providers & notifiers
│   │   ├── widgets/             # Reusable UI components (DishCard, RatingBadge, etc.)
│   │   └── screens/             # 18 Modular screen implementations
│   └── test/                    # Unit, algorithm & widget tests
│
├── backend/                     # Node.js & Express REST API
│   ├── package.json             # Backend dependencies & test scripts
│   ├── .env.example             # Environment configuration template
│   ├── src/
│   │   ├── server.js            # Express server bootstrap
│   │   ├── app.js               # CORS, JSON & router configuration
│   │   ├── routes/api.js        # REST API endpoints & rate limiters
│   │   ├── controllers/         # API controllers
│   │   ├── services/            # RankingService (Bayesian & Best Value algorithms)
│   │   └── db/
│   │       ├── schema.sql       # MySQL database schema definition
│   │       ├── migrate.js       # Database migration script
│   │       ├── seed.js          # MySQL database seeding script
│   │       ├── seedData.js      # Relational seed records
│   │       └── storage.js       # Unified MySQL & fallback memory storage engine
│   └── tests/                   # Automated API & algorithm test suites
│
└── docs/                        # Architecture & Technical Documentation
    ├── architecture.md          # Architecture overview & component diagrams
    ├── api_documentation.md     # Complete REST API endpoint reference
    ├── ranking_algorithm.md     # Mathematical derivation of Bayesian & Best Value algorithms
    └── setup_guide.md           # Step-by-step setup and execution instructions
```

---

## Dish Ranking Mathematics

TastyFind uses a **Bayesian Weighted Rating** algorithm to prevent low-sample anomalies:

$$WR = \left(\frac{v}{v + m}\right) \times R + \left(\frac{m}{v + m}\right) \times C$$

Where:
- **$R$**: Arithmetic mean rating of the individual dish.
- **$v$**: Number of customer reviews for that dish.
- **$m$**: Configurable minimum-review threshold ($m = 15$).
- **$C$**: Benchmark rating prior across the category and town ($C = 4.0$).

And a transparent **Best-Value Index**:
$$\text{Value Score} = \left(\frac{WR}{5.0}\right) \times \sqrt{\frac{P_{\text{baseline}}}{\max(P_{\text{dish}}, 20)}} \times 85$$

---

## Quick Start Instructions

### 1. Run the Backend API
```bash
cd backend
npm install
npm test      # Executes 18 automated test suites
npm start     # Starts REST API on port 4000
```

### 2. Run the Mobile App
```bash
cd mobile
flutter pub get
flutter test   # Executes widget and model tests
flutter run    # Starts on Android, iOS, Web, or Desktop
```

---

## Implemented Features vs. Production Integrations

| Feature | Implemented In Repository | Production Requirements |
| :--- | :--- | :--- |
| **All 18 Screens** | Full navigation, responsive UI, rich design tokens | Production graphics / CDNs |
| **Bayesian Rankings** | WR, Best Value, Haversine Distance | Live dynamic benchmark tuning |
| **Filtering & Search** | Instant multi-parameter filter state & debouncing | Backend Elasticsearch / Meilisearch (optional) |
| **Reviews Submission** | Rate-limited POST `/api/reviews` with validation | Admin Moderation Dashboard & Profanity Filter |
| **Ordering Links** | Swiggy & Zomato verified URL deep linking | Swiggy / Zomato Partner Affiliate Program |
| **Saved Wishlist** | Dual-tab local persistence with Riverpod | User Account Cloud Sync |
