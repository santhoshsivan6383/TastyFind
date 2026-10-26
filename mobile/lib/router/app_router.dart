import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/location/location_permission_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/search/search_results_screen.dart';
import '../screens/rankings/dish_rankings_screen.dart';
import '../screens/restaurant/restaurant_details_screen.dart';
import '../screens/menu/menu_dish_list_screen.dart';
import '../screens/dish/dish_detail_screen.dart';
import '../screens/filter/filter_options_screen.dart';
import '../screens/filter/filtered_results_screen.dart';
import '../screens/order/order_external_screen.dart';
import '../screens/order/order_redirect_screen.dart';
import '../screens/saved/saved_wishlist_screen.dart';
import '../screens/profile/user_profile_screen.dart';
import '../screens/review/add_review_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/settings/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Screen 1: Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Screen 2: Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Screen 3: Location Permission
    GoRoute(
      path: '/location-permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),

    // Screen 4: Home Screen
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Screen 5: Search Results
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchResultsScreen(),
    ),

    // Screen 6: Dish-Specific Rankings
    GoRoute(
      path: '/rankings/:category',
      builder: (context, state) {
        final category = state.pathParameters['category'] ?? 'dosa';
        return DishRankingsScreen(categorySlug: category);
      },
    ),

    // Screen 7: Restaurant Details
    GoRoute(
      path: '/restaurant/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
        return RestaurantDetailsScreen(restaurantId: id);
      },
    ),

    // Screen 8: Restaurant Menu / Dish List
    GoRoute(
      path: '/restaurant/:id/menu',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
        return MenuDishListScreen(restaurantId: id);
      },
    ),

    // Screen 9: Dish Details
    GoRoute(
      path: '/dish/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
        return DishDetailScreen(dishId: id);
      },
    ),

    // Screen 10: Filter Options
    GoRoute(
      path: '/filters',
      builder: (context, state) => const FilterOptionsScreen(),
    ),

    // Screen 11: Filtered Results
    GoRoute(
      path: '/filtered-results',
      builder: (context, state) => const FilteredResultsScreen(),
    ),

    // Screen 12: Order via Swiggy or Zomato
    GoRoute(
      path: '/order-external',
      builder: (context, state) {
        final dishId = int.tryParse(state.uri.queryParameters['dishId'] ?? '1') ?? 1;
        final restaurantId = int.tryParse(state.uri.queryParameters['restaurantId'] ?? '1') ?? 1;
        return OrderExternalScreen(dishId: dishId, restaurantId: restaurantId);
      },
    ),

    // Screen 13: Saved / Wishlist
    GoRoute(
      path: '/saved',
      builder: (context, state) => const SavedWishlistScreen(),
    ),

    // Screen 14: User Profile
    GoRoute(
      path: '/profile',
      builder: (context, state) => const UserProfileScreen(),
    ),

    // Screen 15: Add Review
    GoRoute(
      path: '/add-review/:dishId',
      builder: (context, state) {
        final dishId = int.tryParse(state.pathParameters['dishId'] ?? '1') ?? 1;
        return AddReviewScreen(dishId: dishId);
      },
    ),

    // Screen 16: Order Redirect Confirmation
    GoRoute(
      path: '/order-redirect',
      builder: (context, state) {
        final platform = state.uri.queryParameters['platform'] ?? 'Swiggy';
        final dishName = Uri.decodeComponent(state.uri.queryParameters['dishName'] ?? 'Masala Dosa');
        final restaurantName = Uri.decodeComponent(state.uri.queryParameters['restaurantName'] ?? 'Hotel Sri Murugan');
        final dishId = int.tryParse(state.uri.queryParameters['dishId'] ?? '1') ?? 1;
        final restaurantId = int.tryParse(state.uri.queryParameters['restaurantId'] ?? '1') ?? 1;

        return OrderRedirectScreen(
          platform: platform,
          dishName: dishName,
          restaurantName: restaurantName,
          dishId: dishId,
          restaurantId: restaurantId,
        );
      },
    ),

    // Screen 17: Notifications
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),

    // Screen 18: Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
