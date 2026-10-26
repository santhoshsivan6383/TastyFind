/**
 * TastyFind Standalone Front-End App Simulator
 * Pure dummy-data implementation supporting all 18 screens and interactive flows.
 */

// Global State
const state = {
  currentScreen: 4, // Start on Home
  currentTown: 'Erode',
  selectedCategory: 'dosa',
  rankingMode: 'top_rated', // 'top_rated' | 'best_value' | 'nearest'
  selectedRestaurantId: 1,
  selectedDishId: 1,
  searchQuery: 'dosa',
  searchTab: 'All',
  filters: {
    pricePreset: '₹50 – ₹100',
    minPrice: 50,
    maxPrice: 100,
    minRating: 4.5,
    maxDistanceKm: 3.0,
    isOpenNow: false,
    vegOnly: true,
  },
  savedRestaurants: [1, 2, 3],
  savedDishes: [1],
  userReviews: [
    {
      userName: 'Priya S.',
      userAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
      rating: 5,
      timeAgo: '2 days ago',
      reviewText: 'Amazing taste! Best dosa in town with perfectly spiced potato masala.'
    }
  ]
};

// Front-End Dummy Dataset
const mockData = {
  towns: ['Erode', 'Coimbatore', 'Salem', 'Tirupur', 'Chennai'],
  categories: [
    { id: 1, name: 'Dosa', slug: 'dosa', icon: '🥞' },
    { id: 2, name: 'Biryani', slug: 'biryani', icon: '🍗' },
    { id: 3, name: 'Parotta', slug: 'parotta', icon: '🫓' },
    { id: 4, name: 'Burger', slug: 'burger', icon: '🍔' },
    { id: 5, name: 'Pizza', slug: 'pizza', icon: '🍕' },
    { id: 6, name: 'Shawarma', slug: 'shawarma', icon: '🌯' },
    { id: 7, name: 'Fried Rice', slug: 'fried-rice', icon: '🍚' },
    { id: 8, name: 'Idli & Vada', slug: 'idli-vada', icon: '🍩' },
  ],
  restaurants: [
    {
      id: 1,
      name: 'Hotel Sri Murugan',
      rating: 4.8,
      reviews: 1200,
      distance: 0.8,
      priceRange: '₹60 – ₹90',
      cuisine: 'South Indian',
      badge: 'Best Overall for Dosa',
      quote: 'Crispy dosa, amazing chutney',
      cover: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
      signature: ['Masala Dosa', 'Rava Dosa', 'Ghee Roast'],
      about: 'Famous for crispy dosas and authentic South Indian taste. Freshly made with high quality ingredients.'
    },
    {
      id: 2,
      name: 'Annapoorna Veg',
      rating: 4.5,
      reviews: 812,
      distance: 1.2,
      priceRange: '₹50 – ₹80',
      cuisine: 'Pure Vegetarian',
      badge: 'Value for Money',
      quote: 'Soft & tasty, Value for money.',
      cover: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
      signature: ['Masala Dosa', 'Special Ghee Dosa', 'Mini Tiffin'],
      about: 'Iconic vegetarian destination delivering rich traditional breakfast and authentic tiffin meals.'
    },
    {
      id: 3,
      name: 'Sri Ram Dosa Corner',
      rating: 4.6,
      reviews: 634,
      distance: 1.5,
      priceRange: '₹50 – ₹90',
      cuisine: 'South Indian Fast Food',
      badge: 'Great Value',
      quote: 'Authentic taste. Highly recommended!',
      cover: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
      signature: ['Masala Dosa', 'Onion Dosa', 'Butter Roast Dosa'],
      about: 'Beloved neighborhood gem dedicated exclusively to craft dosas with unique house-made chutneys.'
    },
    {
      id: 4,
      name: 'Hotel Sangeetha',
      rating: 4.4,
      reviews: 421,
      distance: 2.3,
      priceRange: '₹60 – ₹100',
      cuisine: 'South Indian',
      badge: 'Popular',
      quote: 'Crispy paper roast and filter coffee',
      cover: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
      signature: ['Paper Roast', 'Ghee Podi Idli'],
      about: 'Heritage dining hall serving crisp roast varieties, filter coffee, and hearty multi-cuisine tiffin.'
    }
  ],
  dishes: [
    {
      id: 1,
      restaurantId: 1,
      restaurantName: 'Hotel Sri Murugan',
      category: 'dosa',
      name: 'Masala Dosa',
      price: 70,
      rating: 4.8,
      reviews: 543,
      bayesianScore: 4.78,
      valueScore: 88.5,
      distance: 0.8,
      badge: 'Best Overall',
      quote: 'Crispy dosa, amazing chutney',
      image: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
      desc: 'Crispy dosa with flavorful potato masala. Served with fresh coconut chutney, tomato chutney and piping hot sambar.',
      ingredients: ['Fermented Rice Batter', 'Spiced Potato Masala', 'Pure Desi Ghee', 'Curry Leaves']
    },
    {
      id: 2,
      restaurantId: 2,
      restaurantName: 'Annapoorna Veg',
      category: 'dosa',
      name: 'Masala Dosa',
      price: 60,
      rating: 4.6,
      reviews: 612,
      bayesianScore: 4.59,
      valueScore: 91.5,
      distance: 1.2,
      badge: 'Value for Money',
      quote: 'Soft & tasty, Value for money.',
      image: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
      desc: 'Traditional Coimbatore-style masala dosa with mildly spiced potato filling.',
      ingredients: ['Rice Flour', 'Urad Dal', 'Onions', 'Potatoes']
    },
    {
      id: 3,
      restaurantId: 3,
      restaurantName: 'Sri Ram Dosa Corner',
      category: 'dosa',
      name: 'Masala Dosa',
      price: 65,
      rating: 4.5,
      reviews: 634,
      bayesianScore: 4.49,
      valueScore: 86.8,
      distance: 1.5,
      badge: 'Great Value',
      quote: 'Authentic taste. Highly recommended!',
      image: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
      desc: 'Crisp evening street-style masala dosa with spicy garlic red chutney spread.',
      ingredients: ['Rice Batter', 'Red Garlic Chutney', 'Potato Bhaji']
    },
    {
      id: 4,
      restaurantId: 4,
      restaurantName: 'Hotel Sangeetha',
      category: 'dosa',
      name: 'Ghee Paper Roast',
      price: 85,
      rating: 4.4,
      reviews: 421,
      bayesianScore: 4.39,
      valueScore: 78.4,
      distance: 2.3,
      badge: 'Popular',
      quote: 'Super light and crispy cone',
      image: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
      desc: 'Extra-long paper thin crispy cone dosa served with four distinctive homemade chutneys.',
      ingredients: ['Fine Rice Batter', 'Cow Ghee']
    }
  ],
  notifications: [
    { title: 'Your review was helpful!', body: 'Your review on Masala Dosa got 12 likes.', time: '2h ago', icon: '👍', color: '#10B981' },
    { title: 'New offer at your favourite place', body: 'Flat 20% off on all dosas at Annapoorna Veg.', time: '4h ago', icon: '🏷️', color: '#FF5E1F' },
    { title: 'Price updated', body: 'Masala Dosa at Hotel Sri Murugan is now ₹70 (was ₹80).', time: '1d ago', icon: '📉', color: '#3B82F6' },
    { title: 'New restaurant added', body: 'Sri Shakthi Dosa Corner is now available in your area.', time: '1d ago', icon: '🏪', color: '#8B5CF6' }
  ]
};

// UI Navigation Controller
function jumpToScreen(screenNumber) {
  state.currentScreen = parseInt(screenNumber, 10);
  document.getElementById('screenSelect').value = state.currentScreen;
  renderScreen();
}

function resetToHome() {
  jumpToScreen(4);
}

function toggleTheme() {
  document.body.classList.toggle('dark-theme');
}

function showBuildInfo() {
  alert('TastyFind Frontend Build:\n• Mode: Standalone Front-End Dummy Data\n• Target: Flutter 3.19+ (Android APK & iOS)\n• State: Local In-Memory Reactivity\n• Command: flutter build apk --release');
}

// Main Render Dispatcher
function renderScreen() {
  const container = document.getElementById('appContainer');
  switch (state.currentScreen) {
    case 1: container.innerHTML = renderScreen1Splash(); break;
    case 2: container.innerHTML = renderScreen2Onboarding(); break;
    case 3: container.innerHTML = renderScreen3Location(); break;
    case 4: container.innerHTML = renderScreen4Home(); break;
    case 5: container.innerHTML = renderScreen5Search(); break;
    case 6: container.innerHTML = renderScreen6Rankings(); break;
    case 7: container.innerHTML = renderScreen7Restaurant(); break;
    case 8: container.innerHTML = renderScreen8Menu(); break;
    case 9: container.innerHTML = renderScreen9DishDetail(); break;
    case 10: container.innerHTML = renderScreen10Filters(); break;
    case 11: container.innerHTML = renderScreen11FilteredResults(); break;
    case 12: container.innerHTML = renderScreen12OrderExternal(); break;
    case 13: container.innerHTML = renderScreen13Saved(); break;
    case 14: container.innerHTML = renderScreen14Profile(); break;
    case 15: container.innerHTML = renderScreen15AddReview(); break;
    case 16: container.innerHTML = renderScreen16OrderRedirect(); break;
    case 17: container.innerHTML = renderScreen17Notifications(); break;
    case 18: container.innerHTML = renderScreen18Settings(); break;
    default: container.innerHTML = renderScreen4Home(); break;
  }
}

// Screen 1: Splash Screen
function renderScreen1Splash() {
  return `
    <div style="flex:1; background:linear-gradient(rgba(0,0,0,0.65), rgba(0,0,0,0.92)), url('https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80') center/cover; display:flex; flex-direction:column; justify-content:flex-end; padding:24px; color:white;">
      <div style="margin:auto 0; text-align:center;">
        <div style="width:72px; height:72px; background:var(--primary-orange); border-radius:50%; margin:0 auto 16px; display:flex; align-items:center; justify-content:center; font-size:32px; box-shadow:0 8px 24px rgba(255,94,31,0.4);">🍲</div>
        <h1 style="font-size:30px; font-weight:800; letter-spacing:-0.5px;">TastyFind</h1>
        <p style="font-size:14px; color:#D1D5DB; margin-top:6px;">Find the best food in your town</p>
      </div>
      <button class="btn-primary" onclick="jumpToScreen(2)">Get Started</button>
      <p style="text-align:center; font-size:12px; color:#9CA3AF; margin-top:14px;">Already have an account? <span style="color:white; font-weight:700; text-decoration:underline; cursor:pointer;" onclick="jumpToScreen(4)">Log in</span></p>
    </div>
  `;
}

// Screen 2: Onboarding
function renderScreen2Onboarding() {
  return `
    <div class="screen-view" style="padding:20px; justify-content:space-between;">
      <div style="display:flex; justify-content:flex-end;">
        <span style="font-size:13px; font-weight:700; color:var(--text-muted); cursor:pointer;" onclick="jumpToScreen(3)">Skip</span>
      </div>
      <div style="text-align:center; margin:auto 0;">
        <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80" style="width:100%; height:200px; border-radius:18px; object-fit:cover; box-shadow:0 12px 24px rgba(0,0,0,0.08);">
        <h2 style="font-size:22px; font-weight:800; color:var(--deep-charcoal); margin:24px 0 10px; line-height:1.25;">Discover the best food, not just popular ones.</h2>
        <p style="font-size:13px; color:var(--text-muted); line-height:1.5;">We show you the highest rated dishes in your town, with real reviews, prices and ordering options.</p>
        <div style="display:flex; justify-content:center; gap:6px; margin-top:20px;">
          <div style="width:20px; height:6px; background:var(--primary-orange); border-radius:3px;"></div>
          <div style="width:6px; height:6px; background:#E2E8F0; border-radius:3px;"></div>
          <div style="width:6px; height:6px; background:#E2E8F0; border-radius:3px;"></div>
        </div>
      </div>
      <button class="btn-primary" onclick="jumpToScreen(3)">Next</button>
    </div>
  `;
}

// Screen 3: Location Permission
function renderScreen3Location() {
  return `
    <div class="screen-view" style="padding:24px; justify-content:space-between; text-align:center;">
      <div></div>
      <div>
        <div style="width:130px; height:130px; background:#F1F5F9; border-radius:50%; margin:0 auto 24px; display:flex; align-items:center; justify-content:center; border:2px solid #E2E8F0;">
          <div style="width:90px; height:90px; background:var(--primary-orange-light); border-radius:50%; display:flex; align-items:center; justify-content:center;">
            <div style="width:52px; height:52px; background:var(--primary-orange); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:24px; color:white; box-shadow:0 6px 16px rgba(255,94,31,0.4);">📍</div>
          </div>
        </div>
        <h2 style="font-size:22px; font-weight:800; color:var(--deep-charcoal); margin-bottom:8px;">Allow location access</h2>
        <p style="font-size:14px; color:var(--text-muted); line-height:1.4;">We'll show you the best food<br>near you.</p>
      </div>
      <div>
        <button class="btn-primary" onclick="jumpToScreen(4)">Allow Location</button>
        <p style="font-size:13px; font-weight:600; color:var(--text-muted); margin-top:14px; cursor:pointer;" onclick="jumpToScreen(4)">Maybe Later (Select Town)</p>
      </div>
    </div>
  `;
}

// Screen 4: Home Screen
function renderScreen4Home() {
  return `
    <div class="screen-view">
      <!-- Header -->
      <div class="screen-header">
        <div class="screen-title">
          <span style="background:var(--primary-orange); color:white; width:28px; height:28px; border-radius:50%; display:inline-flex; align-items:center; justify-content:center; font-size:14px;">🍲</span>
          TastyFind
        </div>
        <div class="town-badge" onclick="jumpToScreen(18)">📍 ${state.currentTown} ▾</div>
      </div>

      <div style="padding:14px 16px;">
        <!-- Search bar -->
        <div class="search-bar-box" onclick="jumpToScreen(5)">
          <span>🔍</span>
          <input type="text" placeholder="Search for a dish (e.g. dosa, biryani...)" readonly>
        </div>

        <!-- Banner -->
        <div style="margin-top:16px; background:linear-gradient(135deg, #1C1F26, #2E3545); border-radius:18px; padding:16px; color:white; display:flex; justify-content:space-between; align-items:center; box-shadow:0 8px 20px rgba(0,0,0,0.06);">
          <div>
            <div style="font-size:16px; font-weight:800;">Craving something?</div>
            <div style="font-size:12px; color:#CBD5E1; margin-top:4px;">Find the best dishes<br>in ${state.currentTown}</div>
          </div>
          <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200&q=80" style="width:70px; height:70px; border-radius:14px; object-fit:cover;">
        </div>

        <!-- Categories -->
        <div style="margin-top:20px;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
            <span style="font-size:15px; font-weight:800; color:var(--deep-charcoal);">What are you craving?</span>
            <span style="font-size:12px; font-weight:700; color:var(--primary-orange); cursor:pointer;" onclick="jumpToScreen(5)">See All</span>
          </div>
          <div style="display:flex; gap:14px; overflow-x:auto; padding-bottom:6px;">
            ${mockData.categories.map(c => `
              <div style="display:flex; flex-direction:column; align-items:center; gap:4px; cursor:pointer;" onclick="selectCategory('${c.slug}')">
                <div style="width:52px; height:52px; background:var(--primary-orange-light); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:22px;">${c.icon}</div>
                <span style="font-size:11px; font-weight:700; color:var(--deep-charcoal);">${c.name}</span>
              </div>
            `).join('')}
          </div>
        </div>

        <!-- Popular Dishes Carousel -->
        <div style="margin-top:20px;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
            <span style="font-size:15px; font-weight:800; color:var(--deep-charcoal);">Popular Dishes</span>
            <span style="font-size:12px; font-weight:700; color:var(--primary-orange); cursor:pointer;" onclick="jumpToScreen(6)">View All</span>
          </div>
          <div style="display:flex; gap:12px; overflow-x:auto;">
            <div style="min-width:140px; background:white; border-radius:14px; border:1px solid var(--card-border); padding:8px; cursor:pointer;" onclick="openDish(1)">
              <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200&q=80" style="width:100%; height:80px; border-radius:10px; object-fit:cover;">
              <div style="font-size:13px; font-weight:700; margin-top:6px;">Dosa</div>
              <div style="font-size:11px; color:var(--primary-orange); font-weight:600;">Best in town</div>
            </div>
            <div style="min-width:140px; background:white; border-radius:14px; border:1px solid var(--card-border); padding:8px; cursor:pointer;" onclick="selectCategory('biryani')">
              <img src="https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200&q=80" style="width:100%; height:80px; border-radius:10px; object-fit:cover;">
              <div style="font-size:13px; font-weight:700; margin-top:6px;">Biryani</div>
              <div style="font-size:11px; color:var(--primary-orange); font-weight:600;">Top rated</div>
            </div>
          </div>
        </div>

        <!-- Top-Rated Nearby Restaurants -->
        <div style="margin-top:22px;">
          <div style="font-size:15px; font-weight:800; color:var(--deep-charcoal); margin-bottom:12px;">Top-Rated Nearby Restaurants</div>
          ${mockData.restaurants.slice(0, 3).map(r => `
            <div class="restaurant-card" onclick="openRestaurant(${r.id})">
              <img src="${r.cover}" class="card-thumb">
              <div class="card-body">
                <div class="card-name">${r.name}</div>
                <div class="card-meta">
                  <span class="rating-badge"><span class="rating-star">★</span> ${r.rating}</span>
                  <span>•</span>
                  <span>${r.distance} km</span>
                </div>
                <div class="price-text">${r.priceRange}</div>
              </div>
              <button style="align-self:center; background:var(--primary-orange); color:white; border:none; padding:6px 14px; border-radius:16px; font-size:11px; font-weight:700; cursor:pointer;">View</button>
            </div>
          `).join('')}
        </div>
      </div>

      ${renderBottomNav(0)}
    </div>
  `;
}

// Screen 5: Search Results
function renderScreen5Search() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <button class="btn-back" onclick="jumpToScreen(4)">←</button>
        <div style="flex:1;">
          <div class="search-bar-box" style="height:38px;">
            <span>🔍</span>
            <input type="text" value="${state.searchQuery}" id="searchInput" oninput="handleSearch(this.value)">
            <span style="cursor:pointer;" onclick="clearSearch()">✕</span>
          </div>
        </div>
        <button style="background:none; border:none; font-size:18px; margin-left:8px; cursor:pointer;" onclick="jumpToScreen(10)">⚙️</button>
      </div>

      <!-- Tabs: All, Restaurants, Dishes -->
      <div style="display:flex; gap:8px; padding:10px 16px; background:white; border-bottom:1px solid var(--card-border);">
        ${['All', 'Restaurants', 'Dishes'].map(tab => `
          <button style="padding:6px 14px; border-radius:18px; border:1px solid ${state.searchTab === tab ? 'var(--primary-orange)' : 'var(--card-border)'}; background:${state.searchTab === tab ? 'var(--primary-orange)' : 'white'}; color:${state.searchTab === tab ? 'white' : 'var(--deep-charcoal)'}; font-size:12px; font-weight:700; cursor:pointer;" onclick="setSearchTab('${tab}')">${tab}</button>
        `).join('')}
      </div>

      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${(state.searchTab === 'All' || state.searchTab === 'Dishes') ? `
          <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Top Dishes</div>
          <div style="display:flex; gap:10px; overflow-x:auto; margin-bottom:18px;">
            ${mockData.dishes.map(d => `
              <div style="min-width:110px; background:white; border-radius:12px; border:1px solid var(--card-border); padding:6px; cursor:pointer;" onclick="openDish(${d.id})">
                <img src="${d.image}" style="width:100%; height:70px; border-radius:8px; object-fit:cover;">
                <div style="font-size:11px; font-weight:700; margin-top:4px;">${d.name}</div>
              </div>
            `).join('')}
          </div>
        ` : ''}

        ${(state.searchTab === 'All' || state.searchTab === 'Restaurants') ? `
          <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Top Restaurants</div>
          ${mockData.restaurants.map(r => `
            <div class="restaurant-card" onclick="openRestaurant(${r.id})">
              <img src="${r.cover}" class="card-thumb">
              <div class="card-body">
                <div class="card-name">${r.name}</div>
                <div class="card-meta">
                  <span class="rating-badge"><span class="rating-star">★</span> ${r.rating} (${r.reviews})</span>
                  <span>•</span>
                  <span>${r.distance} km</span>
                </div>
                <div class="price-text">${r.priceRange}</div>
              </div>
              <button style="align-self:center; background:var(--primary-orange); color:white; border:none; padding:6px 14px; border-radius:16px; font-size:11px; font-weight:700; cursor:pointer;">View</button>
            </div>
          `).join('')}
        ` : ''}
      </div>

      ${renderBottomNav(1)}
    </div>
  `;
}

// Screen 6: Dish-Specific Rankings
function renderScreen6Rankings() {
  const sortedDishes = [...mockData.dishes];
  if (state.rankingMode === 'best_value') {
    sortedDishes.sort((a, b) => b.valueScore - a.valueScore);
  } else if (state.rankingMode === 'nearest') {
    sortedDishes.sort((a, b) => a.distance - b.distance);
  } else {
    sortedDishes.sort((a, b) => b.bayesianScore - a.bayesianScore);
  }

  const categoryTitle = state.selectedCategory.charAt(0).toUpperCase() + state.selectedCategory.slice(1);

  return `
    <div class="screen-view">
      <div class="screen-header">
        <div style="display:flex; align-items:center;">
          <button class="btn-back" onclick="jumpToScreen(4)">←</button>
          <span class="screen-title">${categoryTitle}</span>
        </div>
        <button style="background:none; border:none; font-size:18px; cursor:pointer;" onclick="jumpToScreen(10)">⚙️</button>
      </div>

      <!-- Segmented Ranking Modes -->
      <div class="pill-bar">
        <div class="mode-pill ${state.rankingMode === 'top_rated' ? 'active' : ''}" onclick="setRankingMode('top_rated')">Top Rated</div>
        <div class="mode-pill ${state.rankingMode === 'best_value' ? 'active' : ''}" onclick="setRankingMode('best_value')">Best Value</div>
        <div class="mode-pill ${state.rankingMode === 'nearest' ? 'active' : ''}" onclick="setRankingMode('nearest')">Nearest</div>
      </div>

      <!-- Ranked List -->
      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${sortedDishes.map((d, index) => `
          <div class="dish-card" onclick="openDish(${d.id})">
            <div style="position:relative;">
              <img src="${d.image}" class="card-thumb">
              <span style="position:absolute; top:4px; left:4px; background:rgba(0,0,0,0.75); color:white; font-size:10px; font-weight:800; padding:2px 5px; border-radius:4px;">#${index + 1}</span>
            </div>
            <div class="card-body">
              <div style="display:flex; justify-content:space-between; align-items:flex-start;">
                <div class="card-name">${d.restaurantName}</div>
                <span style="color:${state.savedDishes.includes(d.id) ? 'var(--primary-orange)' : '#CBD5E1'}; font-size:16px;" onclick="event.stopPropagation(); toggleDishSave(${d.id})">♥</span>
              </div>
              <div class="card-meta">
                <span class="rating-badge"><span class="rating-star">★</span> ${d.rating} (${d.reviews})</span>
                <span>•</span>
                <span>${d.distance} km</span>
              </div>
              <div class="price-text">₹${d.price} - ₹${d.price + 20}</div>
              ${d.badge ? `<div class="badge-tag">${d.badge}</div>` : ''}
              <div class="card-quote">"${d.quote}"</div>
            </div>
            <button style="align-self:flex-end; background:var(--primary-orange); color:white; border:none; padding:6px 10px; border-radius:14px; font-size:11px; font-weight:700; cursor:pointer;" onclick="event.stopPropagation(); openRestaurantMenu(${d.restaurantId})">View Menu</button>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// Screen 7: Restaurant Details
function renderScreen7Restaurant() {
  const rest = mockData.restaurants.find(r => r.id === state.selectedRestaurantId) || mockData.restaurants[0];
  const isSaved = state.savedRestaurants.includes(rest.id);

  return `
    <div class="screen-view">
      <div style="position:relative; height:200px;">
        <img src="${rest.cover}" style="width:100%; height:100%; object-fit:cover;">
        <button class="btn-back" style="position:absolute; top:12px; left:12px; background:white; width:34px; height:34px; border-radius:50%; display:flex; align-items:center; justify-content:center; box-shadow:0 2px 6px rgba(0,0,0,0.2);" onclick="jumpToScreen(6)">←</button>
        <button style="position:absolute; top:12px; right:12px; background:white; width:34px; height:34px; border-radius:50%; border:none; cursor:pointer; color:${isSaved ? 'var(--primary-orange)' : 'var(--deep-charcoal)'}; font-size:16px;" onclick="toggleRestaurantSave(${rest.id})">♥</button>
      </div>

      <div style="padding:18px 16px; background:white; border-radius:20px 20px 0 0; margin-top:-16px; position:relative; flex:1; overflow-y:auto;">
        <h2 style="font-size:20px; font-weight:800; color:var(--deep-charcoal);">${rest.name}</h2>
        <div style="display:flex; align-items:center; gap:6px; margin:6px 0; font-size:13px; color:var(--text-muted);">
          <span style="font-weight:700; color:var(--deep-charcoal);"><span style="color:var(--rating-star);">★</span> ${rest.rating} (${rest.reviews})</span>
          <span>•</span>
          <span>${rest.distance} km</span>
        </div>
        <div style="font-size:13px; font-weight:600; color:var(--text-secondary); margin-bottom:12px;">${rest.priceRange} • ${rest.cuisine}</div>

        <div style="display:flex; gap:8px; margin-bottom:18px;">
          <span class="badge-tag">★ Best Overall for Dosa</span>
          <span style="background:#F1F5F9; color:var(--deep-charcoal); font-size:10px; font-weight:700; padding:2px 8px; border-radius:4px;">Highly Rated</span>
        </div>

        <!-- Action row -->
        <div style="display:flex; justify-content:space-around; background:var(--bg-light); border-radius:14px; padding:12px; margin-bottom:20px; border:1px solid var(--card-border);">
          <div style="text-align:center; font-size:11px; font-weight:700; cursor:pointer;">🧭<br>Direction</div>
          <div style="text-align:center; font-size:11px; font-weight:700; cursor:pointer;">📞<br>Call</div>
          <div style="text-align:center; font-size:11px; font-weight:700; cursor:pointer;">↗️<br>Share</div>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:8px;">Signature Dishes</div>
        <div style="display:flex; gap:8px; margin-bottom:18px;">
          ${rest.signature.map((s, i) => `
            <span style="background:${i === 0 ? 'var(--primary-orange-light)' : 'var(--bg-light)'}; color:${i === 0 ? 'var(--primary-orange)' : 'var(--deep-charcoal)'}; border:1px solid ${i === 0 ? 'var(--primary-orange)' : 'var(--card-border)'}; font-size:12px; font-weight:700; padding:6px 12px; border-radius:16px;">${s}</span>
          `).join('')}
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:6px;">About</div>
        <p style="font-size:13px; color:var(--text-secondary); line-height:1.45; margin-bottom:24px;">${rest.about}</p>

        <button class="btn-primary" onclick="openRestaurantMenu(${rest.id})">View Full Menu</button>
      </div>
    </div>
  `;
}

// Screen 8: Restaurant Menu / Dish List
function renderScreen8Menu() {
  const rest = mockData.restaurants.find(r => r.id === state.selectedRestaurantId) || mockData.restaurants[0];
  const menuDishes = [
    { name: 'Masala Dosa', price: 70, rating: 4.8, count: 543, badge: 'Best Seller' },
    { name: 'Plain Dosa', price: 60, rating: 4.6, count: 210 },
    { name: 'Ghee Roast Dosa', price: 80, rating: 4.7, count: 398 },
    { name: 'Rava Dosa', price: 70, rating: 4.5, count: 156 },
    { name: 'Podi Dosa', price: 75, rating: 4.6, count: 142 }
  ];

  return `
    <div class="screen-view">
      <div class="screen-header">
        <button class="btn-back" onclick="jumpToScreen(7)">←</button>
        <span class="screen-title">Menu - ${rest.name}</span>
      </div>

      <div class="pill-bar">
        <div class="mode-pill active">Dosa</div>
        <div class="mode-pill">Idli</div>
        <div class="mode-pill">Vada</div>
        <div class="mode-pill">Others</div>
      </div>

      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${menuDishes.map((item, idx) => `
          <div class="dish-card" onclick="openDish(${idx === 0 ? 1 : 2})">
            <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200&q=80" class="card-thumb">
            <div class="card-body">
              <div class="card-name">${item.name}</div>
              <div class="card-meta">
                <span class="rating-badge"><span class="rating-star">★</span> ${item.rating} (${item.count})</span>
                ${item.badge ? `<span class="badge-tag" style="margin-left:6px;">${item.badge}</span>` : ''}
              </div>
            </div>
            <div style="display:flex; flex-direction:column; align-items:flex-end; justify-content:center; gap:6px;">
              <span class="price-text">₹${item.price}</span>
              <span style="background:var(--primary-orange-light); color:var(--primary-orange); width:28px; height:28px; border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:16px;">+</span>
            </div>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// Screen 9: Dish Detail
function renderScreen9DishDetail() {
  const dish = mockData.dishes.find(d => d.id === state.selectedDishId) || mockData.dishes[0];

  return `
    <div class="screen-view" style="background:white;">
      <div style="position:relative; height:240px;">
        <img src="${dish.image}" style="width:100%; height:100%; object-fit:cover;">
        <button class="btn-back" style="position:absolute; top:12px; left:12px; background:white; width:34px; height:34px; border-radius:50%; display:flex; align-items:center; justify-content:center; box-shadow:0 2px 6px rgba(0,0,0,0.2);" onclick="jumpToScreen(6)">←</button>
        <button style="position:absolute; top:12px; right:12px; background:white; width:34px; height:34px; border-radius:50%; border:none; cursor:pointer; color:var(--primary-orange); font-size:16px;" onclick="toggleDishSave(${dish.id})">♥</button>
      </div>

      <div style="padding:18px 16px; flex:1; overflow-y:auto; padding-bottom:90px;">
        <div style="display:flex; justify-content:space-between; align-items:flex-start;">
          <h2 style="font-size:22px; font-weight:800; color:var(--deep-charcoal);">${dish.name}</h2>
          <span style="font-size:20px; font-weight:800; color:var(--primary-orange);">₹${dish.price}</span>
        </div>
        <div style="font-size:13px; font-weight:600; color:var(--text-muted); margin:4px 0 10px;">${dish.restaurantName} • ₹${dish.price}</div>
        <span class="badge-tag">${dish.badge}</span>

        <p style="font-size:13px; color:var(--text-secondary); line-height:1.45; margin:14px 0;">${dish.desc}</p>

        <!-- Customer Reviews -->
        <div style="border-top:1px solid var(--card-border); padding-top:16px; margin-top:16px;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
            <span style="font-size:15px; font-weight:800; color:var(--deep-charcoal);">Customer Reviews</span>
            <span style="font-size:12px; font-weight:700; color:var(--primary-orange); cursor:pointer;" onclick="jumpToScreen(15)">+ Add Review</span>
          </div>

          <!-- Breakdown bars -->
          <div style="display:flex; gap:16px; align-items:center; margin-bottom:16px;">
            <div style="text-align:center;">
              <div style="font-size:26px; font-weight:800; color:var(--deep-charcoal);"><span style="color:var(--rating-star);">★</span> ${dish.rating}</div>
              <div style="font-size:11px; color:var(--text-muted);">${dish.reviews} ratings</div>
            </div>
            <div style="flex:1; font-size:10px; color:var(--text-muted); display:flex; flex-direction:column; gap:3px;">
              <div style="display:flex; align-items:center; gap:6px;">5★ <div style="flex:1; height:6px; background:#E2E8F0; border-radius:3px; overflow:hidden;"><div style="width:82%; height:100%; background:var(--primary-orange);"></div></div> 82%</div>
              <div style="display:flex; align-items:center; gap:6px;">4★ <div style="flex:1; height:6px; background:#E2E8F0; border-radius:3px; overflow:hidden;"><div style="width:12%; height:100%; background:var(--primary-orange);"></div></div> 12%</div>
              <div style="display:flex; align-items:center; gap:6px;">3★ <div style="flex:1; height:6px; background:#E2E8F0; border-radius:3px; overflow:hidden;"><div style="width:4%; height:100%; background:var(--primary-orange);"></div></div> 4%</div>
            </div>
          </div>

          <!-- User Review -->
          <div style="background:var(--bg-light); border-radius:12px; padding:12px; border:1px solid var(--card-border);">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
              <span style="font-size:12px; font-weight:700; color:var(--deep-charcoal);">Priya S.</span>
              <span style="font-size:10px; color:var(--text-muted);">2 days ago</span>
            </div>
            <div style="color:var(--rating-star); font-size:11px; margin-bottom:4px;">★★★★★</div>
            <p style="font-size:12px; color:var(--text-secondary); line-height:1.4;">Amazing taste! Best dosa in town with flavorful potato masala.</p>
          </div>
        </div>
      </div>

      <!-- Sticky Order CTA -->
      <div style="position:absolute; bottom:0; left:0; right:0; background:white; padding:14px 16px; border-top:1px solid var(--card-border); box-shadow:0 -4px 12px rgba(0,0,0,0.06);">
        <button class="btn-primary" onclick="jumpToScreen(12)">Add to Cart (₹${dish.price})</button>
      </div>
    </div>
  `;
}

// Screen 10: Filter Options
function renderScreen10Filters() {
  return `
    <div class="screen-view" style="padding:16px; justify-content:space-between; background:white;">
      <div>
        <div class="screen-header" style="padding:0 0 12px; margin-bottom:12px;">
          <button class="btn-back" onclick="jumpToScreen(6)">←</button>
          <span class="screen-title">Filters</span>
          <span style="font-size:13px; font-weight:600; color:var(--text-muted); cursor:pointer;" onclick="resetFilters()">Reset</span>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Price Range</div>
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-bottom:18px;">
          <button class="mode-pill">Under ₹50</button>
          <button class="mode-pill active">₹50 – ₹100</button>
          <button class="mode-pill">₹100 – ₹150</button>
          <button class="mode-pill">₹150+</button>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Rating</div>
        <div style="display:flex; gap:8px; margin-bottom:18px;">
          <button class="mode-pill">4.0+</button>
          <button class="mode-pill active">4.5+</button>
          <button class="mode-pill">4.7+</button>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Distance</div>
        <div style="display:flex; gap:8px; margin-bottom:18px;">
          <button class="mode-pill">Within 1 km</button>
          <button class="mode-pill active">Within 3 km</button>
          <button class="mode-pill">Within 5 km</button>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:10px;">Other Preferences</div>
        <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 0; border-bottom:1px solid var(--card-border);">
          <span style="font-size:13px; font-weight:600;">Open now</span>
          <input type="checkbox">
        </div>
        <div style="display:flex; justify-content:space-between; align-items:center; padding:10px 0;">
          <span style="font-size:13px; font-weight:600;">Veg only</span>
          <input type="checkbox" checked>
        </div>
      </div>

      <button class="btn-primary" onclick="jumpToScreen(11)">Apply Filters (3 Active)</button>
    </div>
  `;
}

// Screen 11: Filtered Results
function renderScreen11FilteredResults() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <div style="display:flex; align-items:center;">
          <button class="btn-back" onclick="jumpToScreen(6)">←</button>
          <span class="screen-title">Dosa</span>
        </div>
        <button style="background:none; border:none; font-size:18px; cursor:pointer;" onclick="jumpToScreen(10)">⚙️</button>
      </div>

      <!-- Active chips -->
      <div style="display:flex; gap:8px; padding:10px 16px; background:white; border-bottom:1px solid var(--card-border); overflow-x:auto;">
        <span style="background:var(--primary-orange-light); color:var(--primary-orange); border:1px solid var(--primary-orange); padding:4px 10px; border-radius:14px; font-size:11px; font-weight:700;">₹50 – ₹100 ✕</span>
        <span style="background:var(--primary-orange-light); color:var(--primary-orange); border:1px solid var(--primary-orange); padding:4px 10px; border-radius:14px; font-size:11px; font-weight:700;">4.5+ ✕</span>
        <span style="background:var(--primary-orange-light); color:var(--primary-orange); border:1px solid var(--primary-orange); padding:4px 10px; border-radius:14px; font-size:11px; font-weight:700;">Within 3 km ✕</span>
      </div>

      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${mockData.restaurants.map(r => `
          <div class="restaurant-card" onclick="openRestaurant(${r.id})">
            <img src="${r.cover}" class="card-thumb">
            <div class="card-body">
              <div class="card-name">${r.name}</div>
              <div class="card-meta">
                <span class="rating-badge"><span class="rating-star">★</span> ${r.rating} (${r.reviews})</span>
                <span>•</span>
                <span>${r.distance} km</span>
              </div>
              <div class="price-text">${r.priceRange}</div>
              ${r.badge ? `<div class="badge-tag" style="margin-top:4px;">${r.badge}</div>` : ''}
            </div>
            <span style="font-size:18px; color:var(--primary-orange); align-self:flex-start;">♥</span>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// Screen 12: Order via Swiggy or Zomato
function renderScreen12OrderExternal() {
  return `
    <div class="screen-view" style="padding:16px; justify-content:space-between; background:var(--bg-light);">
      <div>
        <div class="screen-header" style="background:transparent; padding:0 0 14px; border:none;">
          <button class="btn-back" onclick="jumpToScreen(9)">←</button>
          <span class="screen-title">Order Now</span>
        </div>

        <div style="background:white; border-radius:16px; border:1px solid var(--card-border); padding:14px; display:flex; gap:12px; margin-bottom:14px;">
          <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?w=200&q=80" style="width:50px; height:50px; border-radius:10px; object-fit:cover;">
          <div>
            <div style="font-size:14px; font-weight:700;">Hotel Sri Murugan</div>
            <div style="font-size:11px; color:var(--text-muted); margin-top:2px;">★ 4.8 (1.2k) • 0.8 km</div>
            <div style="font-size:11px; color:var(--text-muted);">₹60 – ₹90</div>
          </div>
        </div>

        <div style="background:white; border-radius:12px; border:1px solid var(--card-border); padding:12px 14px; display:flex; justify-content:space-between; align-items:center; margin-bottom:24px;">
          <span style="font-size:14px; font-weight:700;">Masala Dosa</span>
          <span style="font-size:15px; font-weight:800;">₹70</span>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:12px;">Order through</div>
        
        <button style="width:100%; height:50px; background:var(--swiggy-orange); color:white; border:none; border-radius:14px; font-size:16px; font-weight:800; margin-bottom:12px; cursor:pointer;" onclick="launchOrder('Swiggy')">
          Swiggy
        </button>

        <button style="width:100%; height:50px; background:var(--zomato-red); color:white; border:none; border-radius:14px; font-size:18px; font-weight:800; font-style:italic; margin-bottom:10px; cursor:pointer;" onclick="launchOrder('Zomato')">
          zomato
        </button>

        <div style="text-align:center; font-size:11px; color:var(--text-muted); margin-top:6px;">ℹ️ You'll be redirected to the app</div>
      </div>

      <div style="text-align:center;">
        <span style="font-size:13px; font-weight:700; color:var(--primary-orange); cursor:pointer;" onclick="alert('Masala Dosa saved to Wishlist!')">🔖 Not ordering? Save to wish list</span>
      </div>
    </div>
  `;
}

// Screen 13: Saved / Wishlist
function renderScreen13Saved() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <span class="screen-title">Saved</span>
      </div>

      <div class="pill-bar">
        <div class="mode-pill active">Restaurants (3)</div>
        <div class="mode-pill" onclick="alert('Dishes tab selected')">Dishes (1)</div>
      </div>

      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${mockData.restaurants.slice(0, 3).map(r => `
          <div class="restaurant-card" onclick="openRestaurant(${r.id})">
            <img src="${r.cover}" class="card-thumb">
            <div class="card-body">
              <div class="card-name">${r.name}</div>
              <div class="card-meta">
                <span class="rating-badge"><span class="rating-star">★</span> ${r.rating}</span>
                <span>•</span>
                <span>${r.distance} km</span>
              </div>
              <div style="font-size:11px; color:var(--text-muted); font-style:italic;">${r.quote}</div>
            </div>
            <span style="font-size:18px; color:var(--primary-orange); align-self:center;">♥</span>
          </div>
        `).join('')}
      </div>

      ${renderBottomNav(2)}
    </div>
  `;
}

// Screen 14: User Profile
function renderScreen14Profile() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <span class="screen-title">Profile</span>
      </div>

      <div style="padding:16px; flex:1; overflow-y:auto;">
        <div style="background:white; border-radius:16px; border:1px solid var(--card-border); padding:16px; display:flex; align-items:center; gap:14px; margin-bottom:18px;">
          <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80" style="width:58px; height:58px; border-radius:50%; object-fit:cover;">
          <div>
            <div style="font-size:16px; font-weight:800;">Srinikethan</div>
            <div style="font-size:12px; color:var(--primary-orange); font-weight:700; margin-top:2px; cursor:pointer;" onclick="jumpToScreen(18)">Edit Profile</div>
          </div>
        </div>

        <div style="background:white; border-radius:16px; border:1px solid var(--card-border); overflow:hidden;">
          <div style="padding:14px 16px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--card-border); cursor:pointer;" onclick="jumpToScreen(13)">
            <span style="font-size:13px; font-weight:700;">🛍️ My Orders</span> <span>›</span>
          </div>
          <div style="padding:14px 16px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--card-border); cursor:pointer;" onclick="jumpToScreen(13)">
            <span style="font-size:13px; font-weight:700;">🔖 Saved Restaurants</span> <span>›</span>
          </div>
          <div style="padding:14px 16px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--card-border); cursor:pointer;" onclick="jumpToScreen(15)">
            <span style="font-size:13px; font-weight:700;">⭐ Reviews</span> <span>›</span>
          </div>
          <div style="padding:14px 16px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid var(--card-border); cursor:pointer;" onclick="jumpToScreen(18)">
            <span style="font-size:13px; font-weight:700;">⚙️ Settings</span> <span>›</span>
          </div>
          <div style="padding:14px 16px; display:flex; justify-content:space-between; align-items:center; cursor:pointer;" onclick="jumpToScreen(18)">
            <span style="font-size:13px; font-weight:700;">❓ Help & Support</span> <span>›</span>
          </div>
        </div>
      </div>

      ${renderBottomNav(3)}
    </div>
  `;
}

// Screen 15: Add Review
function renderScreen15AddReview() {
  return `
    <div class="screen-view" style="padding:16px; background:white; justify-content:space-between;">
      <div>
        <div class="screen-header" style="background:transparent; padding:0 0 14px; border:none;">
          <button class="btn-back" onclick="jumpToScreen(9)">←</button>
          <span class="screen-title">Add Review</span>
        </div>

        <div style="background:var(--bg-light); border-radius:14px; border:1px solid var(--card-border); padding:10px 12px; display:flex; gap:12px; margin-bottom:20px;">
          <img src="https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200&q=80" style="width:48px; height:48px; border-radius:8px; object-fit:cover;">
          <div>
            <div style="font-size:14px; font-weight:700;">Masala Dosa</div>
            <div style="font-size:11px; color:var(--text-muted);">Hotel Sri Murugan</div>
          </div>
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:8px;">Rating</div>
        <div style="font-size:32px; color:var(--rating-star); margin-bottom:18px; cursor:pointer;">
          ★★★★★
        </div>

        <div style="font-size:14px; font-weight:800; margin-bottom:8px;">Your Review (optional)</div>
        <textarea style="width:100%; height:90px; border-radius:12px; border:1px solid var(--card-border); padding:10px; font-size:13px; outline:none; resize:none; margin-bottom:18px;" placeholder="Share your experience..."></textarea>

        <div style="font-size:14px; font-weight:800; margin-bottom:8px;">Add Photos (0/5)</div>
        <div style="width:80px; height:80px; border:1px dashed var(--card-border); border-radius:12px; display:flex; flex-direction:column; align-items:center; justify-content:center; color:var(--text-muted); cursor:pointer;" onclick="alert('Photo attached!')">
          <span style="font-size:22px;">📷</span>
          <span style="font-size:10px; margin-top:2px;">Upload</span>
        </div>
      </div>

      <button class="btn-primary" onclick="submitReview()">Submit</button>
    </div>
  `;
}

// Screen 16: Order Redirect Confirmation
function renderScreen16OrderRedirect() {
  return `
    <div class="screen-view" style="padding:24px; justify-content:space-between; text-align:center; background:white;">
      <div></div>
      <div>
        <div style="width:110px; height:150px; background:#F8FAFC; border:2px solid #E2E8F0; border-radius:20px; margin:0 auto 24px; display:flex; align-items:center; justify-content:center; box-shadow:0 8px 20px rgba(0,0,0,0.04);">
          <div style="width:50px; height:50px; background:var(--success-green-light); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:26px; color:var(--success-green);">✓</div>
        </div>
        <h2 style="font-size:22px; font-weight:800; color:var(--deep-charcoal); margin-bottom:6px;">You're all set!</h2>
        <div style="font-size:14px; font-weight:600; color:var(--text-muted); margin-bottom:10px;">Opening Swiggy...</div>
        <p style="font-size:12px; color:var(--text-secondary); line-height:1.4;">You'll be redirected to Swiggy to<br>complete your order.</p>
      </div>
      <div>
        <button class="btn-primary" onclick="jumpToScreen(4)">Continue</button>
        <p style="font-size:12px; font-weight:700; color:var(--text-muted); margin-top:14px; cursor:pointer;" onclick="jumpToScreen(7)">Return to TastyFind</p>
      </div>
    </div>
  `;
}

// Screen 17: Notifications
function renderScreen17Notifications() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <button class="btn-back" onclick="jumpToScreen(18)">←</button>
        <span class="screen-title">Notifications</span>
      </div>

      <div style="padding:14px 16px; flex:1; overflow-y:auto;">
        ${mockData.notifications.map(n => `
          <div style="background:white; border-radius:14px; border:1px solid var(--card-border); padding:12px; display:flex; gap:12px; margin-bottom:10px;">
            <div style="width:34px; height:34px; border-radius:50%; background:${n.color}22; display:flex; align-items:center; justify-content:center; font-size:16px;">${n.icon}</div>
            <div style="flex:1;">
              <div style="font-size:13px; font-weight:700; color:var(--deep-charcoal);">${n.title}</div>
              <div style="font-size:11px; color:var(--text-secondary); margin:2px 0 4px; line-height:1.35;">${n.body}</div>
              <div style="font-size:10px; color:var(--text-muted);">${n.time}</div>
            </div>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// Screen 18: Settings
function renderScreen18Settings() {
  return `
    <div class="screen-view">
      <div class="screen-header">
        <button class="btn-back" onclick="jumpToScreen(4)">←</button>
        <span class="screen-title">Settings</span>
      </div>

      <div style="padding:16px; flex:1; overflow-y:auto;">
        <div style="font-size:12px; font-weight:700; color:var(--text-muted); margin-bottom:6px;">Account</div>
        <div style="background:white; border-radius:14px; border:1px solid var(--card-border); overflow:hidden; margin-bottom:16px;">
          <div style="padding:12px 14px; border-bottom:1px solid var(--card-border); font-size:13px; font-weight:600; cursor:pointer;">Edit Profile</div>
          <div style="padding:12px 14px; border-bottom:1px solid var(--card-border); font-size:13px; font-weight:600; cursor:pointer;">Change Mobile Number</div>
          <div style="padding:12px 14px; font-size:13px; font-weight:600; cursor:pointer;">Privacy</div>
        </div>

        <div style="font-size:12px; font-weight:700; color:var(--text-muted); margin-bottom:6px;">App</div>
        <div style="background:white; border-radius:14px; border:1px solid var(--card-border); overflow:hidden; margin-bottom:16px;">
          <div style="padding:12px 14px; border-bottom:1px solid var(--card-border); font-size:13px; font-weight:600; display:flex; justify-content:space-between; cursor:pointer;" onclick="switchTown()">
            <span>Location</span>
            <span style="color:var(--primary-orange);">${state.currentTown} ›</span>
          </div>
          <div style="padding:12px 14px; border-bottom:1px solid var(--card-border); font-size:13px; font-weight:600; display:flex; justify-content:space-between; cursor:pointer;" onclick="jumpToScreen(17)">
            <span>Notifications</span>
            <span>›</span>
          </div>
          <div style="padding:12px 14px; font-size:13px; font-weight:600; display:flex; justify-content:space-between; align-items:center;">
            <span>Dark Mode</span>
            <input type="checkbox" onchange="toggleTheme()">
          </div>
        </div>

        <div style="font-size:12px; font-weight:700; color:var(--text-muted); margin-bottom:6px;">Help & Support</div>
        <div style="background:white; border-radius:14px; border:1px solid var(--card-border); overflow:hidden;">
          <div style="padding:12px 14px; border-bottom:1px solid var(--card-border); font-size:13px; font-weight:600; cursor:pointer;" onclick="alert('FAQs: TastyFind ranks individual dishes by Bayesian score.')">FAQ</div>
          <div style="padding:12px 14px; font-size:13px; font-weight:600; cursor:pointer;" onclick="alert('Contact: support@tastyfind.app')">Contact Us</div>
        </div>
      </div>
    </div>
  `;
}

// Helpers
function renderBottomNav(activeIndex) {
  return `
    <nav class="bottom-nav">
      <div class="nav-item ${activeIndex === 0 ? 'active' : ''}" onclick="jumpToScreen(4)">
        <span class="nav-icon">🏠</span>
        <span>Home</span>
      </div>
      <div class="nav-item ${activeIndex === 1 ? 'active' : ''}" onclick="jumpToScreen(5)">
        <span class="nav-icon">🔍</span>
        <span>Search</span>
      </div>
      <div class="nav-item ${activeIndex === 2 ? 'active' : ''}" onclick="jumpToScreen(13)">
        <span class="nav-icon">♥</span>
        <span>Saved</span>
      </div>
      <div class="nav-item ${activeIndex === 3 ? 'active' : ''}" onclick="jumpToScreen(14)">
        <span class="nav-icon">👤</span>
        <span>Profile</span>
      </div>
    </nav>
  `;
}

function selectCategory(slug) {
  state.selectedCategory = slug;
  jumpToScreen(6);
}

function setRankingMode(mode) {
  state.rankingMode = mode;
  renderScreen();
}

function openDish(dishId) {
  state.selectedDishId = dishId;
  jumpToScreen(9);
}

function openRestaurant(restId) {
  state.selectedRestaurantId = restId;
  jumpToScreen(7);
}

function openRestaurantMenu(restId) {
  state.selectedRestaurantId = restId;
  jumpToScreen(8);
}

function toggleDishSave(dishId) {
  const idx = state.savedDishes.indexOf(dishId);
  if (idx > -1) {
    state.savedDishes.splice(idx, 1);
  } else {
    state.savedDishes.push(dishId);
  }
  renderScreen();
}

function toggleRestaurantSave(restId) {
  const idx = state.savedRestaurants.indexOf(restId);
  if (idx > -1) {
    state.savedRestaurants.splice(idx, 1);
  } else {
    state.savedRestaurants.push(restId);
  }
  renderScreen();
}

function handleSearch(query) {
  state.searchQuery = query;
  renderScreen();
}

function clearSearch() {
  state.searchQuery = '';
  renderScreen();
}

function setSearchTab(tab) {
  state.searchTab = tab;
  renderScreen();
}

function resetFilters() {
  alert('Filters reset to default.');
}

function launchOrder(platform) {
  jumpToScreen(16);
}

function submitReview() {
  alert('Thank you! Your dish review has been submitted.');
  jumpToScreen(9);
}

function switchTown() {
  const nextTown = state.currentTown === 'Erode' ? 'Coimbatore' : 'Erode';
  state.currentTown = nextTown;
  alert(`Location changed to ${nextTown}!`);
  renderScreen();
}

// Initial bootstrap
window.onload = function() {
  renderScreen();
};
