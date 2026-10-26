import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav_bar.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // User Avatar & Name Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryOrangeLight,
                    foregroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
                    ),
                    onForegroundImageError: null,
                    child: Icon(Icons.person_rounded, color: AppColors.primaryOrange, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Srinikethan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepCharcoal,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Food Explorer • Erode',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Edit Profile is available in Settings')),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 14, color: AppColors.primaryOrange),
                              SizedBox(width: 4),
                              Text(
                                'Edit Profile',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Navigation Menu
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    subtitle: 'External orders & saved order history',
                    onTap: () => context.push('/saved'),
                  ),
                  const Divider(height: 1, indent: 54, color: AppColors.cardBorder),
                  _buildMenuItem(
                    icon: Icons.bookmark_border_rounded,
                    title: 'Saved Restaurants',
                    subtitle: 'Quick access to your preferred spots',
                    onTap: () => context.go('/saved'),
                  ),
                  const Divider(height: 1, indent: 54, color: AppColors.cardBorder),
                  _buildMenuItem(
                    icon: Icons.rate_review_outlined,
                    title: 'My Reviews',
                    subtitle: 'Ratings & photos you have contributed',
                    onTap: () => context.push('/add-review/1'),
                  ),
                  const Divider(height: 1, indent: 54, color: AppColors.cardBorder),
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Price alerts & restaurant updates',
                    onTap: () => context.push('/notifications'),
                  ),
                  const Divider(height: 1, indent: 54, color: AppColors.cardBorder),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Preferences, theme & town selection',
                    onTap: () => context.push('/settings'),
                  ),
                  const Divider(height: 1, indent: 54, color: AppColors.cardBorder),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    subtitle: 'FAQs, contact team & privacy policy',
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Guest note
            const Text(
              'TastyFind v1.0.0 • Erode Edition\nBrowse dishes freely as a guest.',
              style: TextStyle(fontSize: 11, color: AppColors.textPlaceholder, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.deepCharcoal, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textPlaceholder, size: 20),
      onTap: onTap,
    );
  }
}
