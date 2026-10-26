// Realistic sample & demo data clearly marked for TastyFind local development

const towns = [
  { id: 1, name: 'Erode', state: 'Tamil Nadu', country: 'India', latitude: 11.3410, longitude: 77.7172 },
  { id: 2, name: 'Coimbatore', state: 'Tamil Nadu', country: 'India', latitude: 11.0168, longitude: 76.9558 },
  { id: 3, name: 'Salem', state: 'Tamil Nadu', country: 'India', latitude: 11.6643, longitude: 78.1460 },
  { id: 4, name: 'Tirupur', state: 'Tamil Nadu', country: 'India', latitude: 11.1085, longitude: 77.3411 },
  { id: 5, name: 'Chennai', state: 'Tamil Nadu', country: 'India', latitude: 13.0827, longitude: 80.2707 }
];

const categories = [
  { id: 1, name: 'Dosa', slug: 'dosa', image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400&q=80' },
  { id: 2, name: 'Biryani', slug: 'biryani', image_url: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400&q=80' },
  { id: 3, name: 'Parotta', slug: 'parotta', image_url: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=400&q=80' },
  { id: 4, name: 'Burger', slug: 'burger', image_url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80' },
  { id: 5, name: 'Pizza', slug: 'pizza', image_url: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80' },
  { id: 6, name: 'Shawarma', slug: 'shawarma', image_url: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=400&q=80' },
  { id: 7, name: 'Fried Rice', slug: 'fried-rice', image_url: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&q=80' },
  { id: 8, name: 'Idli & Vada', slug: 'idli-vada', image_url: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=400&q=80' }
];

const restaurants = [
  {
    id: 1,
    town_id: 1,
    name: 'Hotel Sri Murugan',
    description: 'Famous for crispy dosas and authentic South Indian taste. Freshly made with high quality ingredients.',
    address: '42 Brough Road, Near Clock Tower, Erode',
    latitude: 11.3410,
    longitude: 77.7172,
    phone: '+91 424 225 1890',
    opening_hours: '6:30 AM - 10:30 PM',
    is_open_now: true,
    cuisine_type: 'South Indian',
    overall_rating: 4.80,
    overall_review_count: 1200,
    min_price: 60.00,
    max_price: 90.00,
    cover_image_url: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800&q=80',
    signature_dishes: ['Masala Dosa', 'Rava Dosa', 'Ghee Roast']
  },
  {
    id: 2,
    town_id: 1,
    name: 'Annapoorna Veg',
    description: 'Iconic vegetarian destination delivering rich traditional breakfast and authentic tiffin meals.',
    address: '15 Gandhiji Road, Railway Station Area, Erode',
    latitude: 11.3440,
    longitude: 77.7240,
    phone: '+91 424 221 4455',
    opening_hours: '7:00 AM - 10:00 PM',
    is_open_now: true,
    cuisine_type: 'Pure Vegetarian',
    overall_rating: 4.50,
    overall_review_count: 812,
    min_price: 50.00,
    max_price: 80.00,
    cover_image_url: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800&q=80',
    signature_dishes: ['Masala Dosa', 'Special Ghee Dosa', 'Mini Tiffin']
  },
  {
    id: 3,
    town_id: 1,
    name: 'Sri Ram Dosa Corner',
    description: 'Beloved neighborhood gem dedicated exclusively to craft dosas with unique house-made chutneys.',
    address: '88 Mettur Road, Municipal Colony, Erode',
    latitude: 11.3480,
    longitude: 77.7210,
    phone: '+91 424 226 7788',
    opening_hours: '5:00 PM - 11:00 PM',
    is_open_now: true,
    cuisine_type: 'South Indian Fast Food',
    overall_rating: 4.60,
    overall_review_count: 634,
    min_price: 50.00,
    max_price: 90.00,
    cover_image_url: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800&q=80',
    signature_dishes: ['Masala Dosa', 'Onion Dosa', 'Butter Roast Dosa']
  },
  {
    id: 4,
    town_id: 1,
    name: 'Hotel Sangeetha',
    description: 'Heritage dining hall serving crisp roast varieties, filter coffee, and hearty multi-cuisine tiffin.',
    address: '104 Perundurai Road, Erode',
    latitude: 11.3520,
    longitude: 77.7310,
    phone: '+91 424 227 3322',
    opening_hours: '7:00 AM - 10:30 PM',
    is_open_now: true,
    cuisine_type: 'South Indian',
    overall_rating: 4.40,
    overall_review_count: 421,
    min_price: 60.00,
    max_price: 100.00,
    cover_image_url: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&q=80',
    signature_dishes: ['Paper Roast', 'Ghee Podi Idli']
  },
  {
    id: 5,
    town_id: 1,
    name: 'Saravana Bhavan',
    description: 'Traditional standard for pure vegetarian feasts, golden dosas, and fragrant filter coffee.',
    address: '12 EVN Road, Near Bus Stand, Erode',
    latitude: 11.3460,
    longitude: 77.7190,
    phone: '+91 424 222 9900',
    opening_hours: '6:00 AM - 10:00 PM',
    is_open_now: true,
    cuisine_type: 'South Indian Vegetarian',
    overall_rating: 4.30,
    overall_review_count: 421,
    min_price: 70.00,
    max_price: 120.00,
    cover_image_url: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
    signature_dishes: ['Special Masala Dosa', 'Curd Vada']
  },
  {
    id: 6,
    town_id: 1,
    name: 'Thalappakatti Biryani',
    description: 'World-renowned Seeraga Samba mutton and chicken biryani cooked with secret hill spices.',
    address: '67 Sathy Road, Erode',
    latitude: 11.3390,
    longitude: 77.7280,
    phone: '+91 424 228 1144',
    opening_hours: '11:00 AM - 11:00 PM',
    is_open_now: true,
    cuisine_type: 'Biryani & Non-Veg',
    overall_rating: 4.70,
    overall_review_count: 950,
    min_price: 180.00,
    max_price: 360.00,
    cover_image_url: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800&q=80',
    signature_dishes: ['Mutton Biryani', 'Chicken 65']
  }
];

const dishes = [
  // Hotel Sri Murugan (id: 1)
  {
    id: 1,
    restaurant_id: 1,
    category_id: 1, // Dosa
    name: 'Masala Dosa',
    description: 'Crispy dosa with flavorful potato masala. Served with fresh coconut chutney, tomato chutney and piping hot sambar.',
    current_price: 70.00,
    currency: 'INR',
    dish_rating: 4.80,
    dish_review_count: 543,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: 'Best Seller',
    highlight_quote: 'Crispy dosa, amazing chutney',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Fermented Rice & Urad Dal Batter', 'Spiced Mashed Potatoes', 'Mustard Seeds', 'Curry Leaves', 'Pure Ghee']
  },
  {
    id: 2,
    restaurant_id: 1,
    category_id: 1,
    name: 'Plain Dosa',
    description: 'Golden crisp crepe made from naturally fermented batter, served with 3 signature chutneys.',
    current_price: 60.00,
    currency: 'INR',
    dish_rating: 4.60,
    dish_review_count: 210,
    image_url: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Light and perfectly crisped',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Fermented Rice & Dal Batter', 'Ghee']
  },
  {
    id: 3,
    restaurant_id: 1,
    category_id: 1,
    name: 'Ghee Roast Dosa',
    description: 'Extra aromatic, deep golden crispy roast roasted generously with pure melted village ghee.',
    current_price: 80.00,
    currency: 'INR',
    dish_rating: 4.70,
    dish_review_count: 398,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: 'Popular',
    highlight_quote: 'Rich aroma of pure ghee',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Fermented Rice Batter', 'Artisanal Desi Ghee', 'Special Spices']
  },
  {
    id: 4,
    restaurant_id: 1,
    category_id: 1,
    name: 'Rava Dosa',
    description: 'Crispy net-like semolina dosa studded with crushed pepper, cumin seeds, and fresh green chilies.',
    current_price: 70.00,
    currency: 'INR',
    dish_rating: 4.50,
    dish_review_count: 156,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Crispy lattice texture with cracked pepper',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Semolina (Rava)', 'Rice Flour', 'Cumin', 'Black Pepper', 'Curry Leaves']
  },
  {
    id: 5,
    restaurant_id: 1,
    category_id: 1,
    name: 'Podi Dosa',
    description: 'Topped with spiced gun powder (idli podi) and roasted with hot ghee till crackling crisp.',
    current_price: 75.00,
    currency: 'INR',
    dish_rating: 4.60,
    dish_review_count: 142,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Spicy punch of house roasted podi',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Rice Batter', 'Lentil Gunpowder (Podi)', 'Pure Ghee']
  },
  // Annapoorna Veg (id: 2)
  {
    id: 6,
    restaurant_id: 2,
    category_id: 1,
    name: 'Masala Dosa',
    description: 'Traditional Coimbatore-style masala dosa with mildly spiced potato filling and mint coconut chutney.',
    current_price: 60.00,
    currency: 'INR',
    dish_rating: 4.60,
    dish_review_count: 612,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: 'Value for Money',
    highlight_quote: 'Soft & tasty, Value for money.',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Rice Flour', 'Urad Dal', 'Onions', 'Potatoes', 'Green Chillies']
  },
  {
    id: 7,
    restaurant_id: 2,
    category_id: 1,
    name: 'Special Ghee Dosa',
    description: 'Thin golden dosa infused with country butter and roasted on a heavy cast-iron tawa.',
    current_price: 75.00,
    currency: 'INR',
    dish_rating: 4.50,
    dish_review_count: 240,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Generous ghee and crisp edges',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Fermented Batter', 'Butter', 'Ghee']
  },
  // Sri Ram Dosa Corner (id: 3)
  {
    id: 8,
    restaurant_id: 3,
    category_id: 1,
    name: 'Masala Dosa',
    description: 'Crisp evening street-style masala dosa with spicy garlic red chutney spread and mashed spiced potatoes.',
    current_price: 65.00,
    currency: 'INR',
    dish_rating: 4.50,
    dish_review_count: 634,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: 'Great Value',
    highlight_quote: 'Authentic taste. Highly recommended!',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Rice Batter', 'Red Garlic Chutney', 'Potato Bhaji', 'Ghee']
  },
  {
    id: 9,
    restaurant_id: 3,
    category_id: 1,
    name: 'Onion Roast Dosa',
    description: 'Stuffed with sweet caramelized shallots, fresh coriander, and crisp curry leaves.',
    current_price: 70.00,
    currency: 'INR',
    dish_rating: 4.60,
    dish_review_count: 220,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Shallots caramelized to perfection',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Rice Batter', 'Shallots (Small Onions)', 'Green Chillies']
  },
  // Hotel Sangeetha (id: 4)
  {
    id: 10,
    restaurant_id: 4,
    category_id: 1,
    name: 'Ghee Paper Roast Dosa',
    description: 'Extra-long paper thin crispy cone dosa served with four distinctive homemade chutneys.',
    current_price: 85.00,
    currency: 'INR',
    dish_rating: 4.40,
    dish_review_count: 421,
    image_url: 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=600&q=80',
    vegetarian: true,
    availability_status: 'available',
    badge: null,
    highlight_quote: 'Super light and crispy cone',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Fine Rice Batter', 'Cow Ghee']
  },
  // Thalappakatti Biryani (id: 6)
  {
    id: 11,
    restaurant_id: 6,
    category_id: 2, // Biryani
    name: 'Thalappakatti Chicken Biryani',
    description: 'Authentic Dindigul style fragrant Seeraga Samba rice cooked with tender country chicken cuts and freshly ground spices.',
    current_price: 240.00,
    currency: 'INR',
    dish_rating: 4.80,
    dish_review_count: 720,
    image_url: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
    vegetarian: false,
    availability_status: 'available',
    badge: 'Top Rated',
    highlight_quote: 'Rich aroma of Seeraga Samba and succulent meat',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Seeraga Samba Rice', 'Country Chicken', 'Curd', 'Ghee', 'Fresh Mint', 'Dindigul Spice Blend']
  },
  {
    id: 12,
    restaurant_id: 6,
    category_id: 2,
    name: 'Thalappakatti Mutton Biryani',
    description: 'Slow-cooked mutton pieces infused into short grain aromatic rice with caramelized onions and whole spices.',
    current_price: 340.00,
    currency: 'INR',
    dish_rating: 4.90,
    dish_review_count: 850,
    image_url: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
    vegetarian: false,
    availability_status: 'available',
    badge: 'Best Seller',
    highlight_quote: 'Melt-in-mouth tender mutton pieces',
    price_verified_at: '2026-10-25T10:00:00Z',
    ingredients: ['Mutton', 'Seeraga Samba Rice', 'Cloves', 'Cardamom', 'Ghee']
  }
];

const reviews = [
  {
    id: 1,
    user_id: 1,
    user_name: 'Priya S.',
    user_avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
    dish_id: 1, // Masala Dosa Hotel Sri Murugan
    rating: 5,
    review_text: 'Amazing taste! Best dosa in town with perfectly spiced potato masala and heavenly coconut chutney.',
    image_url: null,
    moderation_status: 'approved',
    helpful_count: 12,
    created_at: '2026-10-24T12:00:00Z'
  },
  {
    id: 2,
    user_id: 2,
    user_name: 'Karthik R.',
    user_avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80',
    dish_id: 1,
    rating: 5,
    review_text: 'Crispiest ghee-roasted exterior with fresh coconut and tomato chutney. Best in Erode hands down.',
    image_url: null,
    moderation_status: 'approved',
    helpful_count: 8,
    created_at: '2026-10-21T15:30:00Z'
  },
  {
    id: 3,
    user_id: 3,
    user_name: 'Ananya M.',
    user_avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&q=80',
    dish_id: 1,
    rating: 4,
    review_text: 'Really authentic South Indian flavor, great value for ₹70. Sambar was hot and flavorful.',
    image_url: null,
    moderation_status: 'approved',
    helpful_count: 5,
    created_at: '2026-10-19T09:15:00Z'
  },
  {
    id: 4,
    user_id: 4,
    user_name: 'Vignesh P.',
    user_avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80',
    dish_id: 8, // Sri Ram Dosa Corner
    rating: 5,
    review_text: 'Authentic taste. The red garlic spread elevates this ordinary dosa to extraordinary level!',
    image_url: null,
    moderation_status: 'approved',
    helpful_count: 14,
    created_at: '2026-10-23T18:00:00Z'
  },
  {
    id: 5,
    user_id: 5,
    user_name: 'Suresh Kumar',
    user_avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&q=80',
    dish_id: 11, // Thalappakatti Biryani
    rating: 5,
    review_text: 'The Seeraga Samba aroma hits you instantly. Perfectly cooked chicken and tender grain separation.',
    image_url: null,
    moderation_status: 'approved',
    helpful_count: 22,
    created_at: '2026-10-22T13:45:00Z'
  }
];

const orderingLinks = [
  {
    id: 1,
    restaurant_id: 1,
    platform: 'swiggy',
    url: 'https://www.swiggy.com/restaurants/hotel-sri-murugan-erode',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  },
  {
    id: 2,
    restaurant_id: 1,
    platform: 'zomato',
    url: 'https://www.zomato.com/erode/hotel-sri-murugan',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  },
  {
    id: 3,
    restaurant_id: 2,
    platform: 'swiggy',
    url: 'https://www.swiggy.com/restaurants/annapoorna-veg-erode',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  },
  {
    id: 4,
    restaurant_id: 2,
    platform: 'zomato',
    url: 'https://www.zomato.com/erode/annapoorna-veg',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  },
  {
    id: 5,
    restaurant_id: 3,
    platform: 'swiggy',
    url: 'https://www.swiggy.com/restaurants/sri-ram-dosa-corner-erode',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  },
  {
    id: 6,
    restaurant_id: 3,
    platform: 'zomato',
    url: 'https://www.zomato.com/erode/sri-ram-dosa-corner',
    verification_status: 'verified',
    last_verified_at: '2026-10-25T10:00:00Z'
  }
];

const savedItems = [
  { id: 1, user_id: 1, entity_type: 'restaurant', entity_id: 1, created_at: '2026-10-20T10:00:00Z' },
  { id: 2, user_id: 1, entity_type: 'restaurant', entity_id: 2, created_at: '2026-10-21T11:00:00Z' },
  { id: 3, user_id: 1, entity_type: 'restaurant', entity_id: 3, created_at: '2026-10-22T12:00:00Z' },
  { id: 4, user_id: 1, entity_type: 'dish', entity_id: 1, created_at: '2026-10-23T14:00:00Z' }
];

const notifications = [
  {
    id: 1,
    title: 'Your review was helpful!',
    body: 'Your review on Masala Dosa got 12 likes.',
    type: 'review_helpful',
    time_ago: '2h ago',
    created_at: '2026-10-26T08:00:00Z',
    is_read: false
  },
  {
    id: 2,
    title: 'New offer at your favourite place',
    body: 'Flat 20% off on all dosas at Annapoorna Veg.',
    type: 'offer',
    time_ago: '4h ago',
    created_at: '2026-10-26T06:00:00Z',
    is_read: false
  },
  {
    id: 3,
    title: 'Price updated',
    body: 'Masala Dosa at Hotel Sri Murugan is now ₹70 (was ₹80).',
    type: 'price_update',
    time_ago: '1d ago',
    created_at: '2026-10-25T10:00:00Z',
    is_read: true
  },
  {
    id: 4,
    title: 'New restaurant added',
    body: 'Sri Shakthi Dosa Corner is now available in your area.',
    type: 'new_restaurant',
    time_ago: '1d ago',
    created_at: '2026-10-25T09:00:00Z',
    is_read: true
  }
];

module.exports = {
  towns,
  categories,
  restaurants,
  dishes,
  reviews,
  orderingLinks,
  savedItems,
  notifications
};
