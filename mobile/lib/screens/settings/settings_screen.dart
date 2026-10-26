import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../providers/food_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showTownPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final towns = ref.watch(townsListProvider);
        final current = ref.watch(selectedTownProvider);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Town',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                ),
                const SizedBox(height: 12),
                towns.when(
                  data: (list) => Column(
                    children: list.map((t) {
                      final isSelected = t.id == current.id;
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_rounded,
                          color: isSelected ? AppColors.primaryOrange : AppColors.textPlaceholder,
                        ),
                        title: Text(t.name, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                        trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primaryOrange) : null,
                        onTap: () {
                          ref.read(selectedTownProvider.notifier).state = t;
                          Navigator.pop(ctx);
                        },
                      );
                    }).toList(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Text('Could not load towns'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTown = ref.watch(selectedTownProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Section: Account
          _buildSectionHeader('Account'),
          _buildSettingsGroup([
            _buildTile(
              title: 'Edit Profile',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile editing mode active for Srinikethan')),
                );
              },
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'Change Mobile Number',
              subtitle: '+91 98765 43210',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP verification required for phone number update.')),
                );
              },
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'Privacy',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TastyFind values user privacy: Data is never sold or shared with scrapers.')),
                );
              },
            ),
          ]),
          const SizedBox(height: 24),

          // Section: App
          _buildSectionHeader('App'),
          _buildSettingsGroup([
            _buildTile(
              title: 'Location',
              trailingText: currentTown.name,
              onTap: () => _showTownPicker(context, ref),
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'Notifications',
              onTap: () => context.push('/notifications'),
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              title: const Text('Dark Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              value: isDark,
              activeThumbColor: AppColors.primaryOrange,
              onChanged: (val) {
                ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ]),
          const SizedBox(height: 24),

          // Section: Help & Support
          _buildSectionHeader('Help & Support'),
          _buildSettingsGroup([
            _buildTile(
              title: 'FAQ',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Frequently Asked Questions'),
                    content: const Text(
                      '• How are dishes ranked?\nWe use a Bayesian weighted algorithm considering reviews, benchmarks, and best-value scores.\n\n• Can I order directly?\nTastyFind redirects you to official Swiggy or Zomato partner listings for direct delivery.',
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                    ],
                  ),
                );
              },
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'Contact Us',
              subtitle: 'support@tastyfind.app',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support line: support@tastyfind.app')),
                );
              },
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'About TastyFind',
              trailingText: 'v1.0.0',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'TastyFind',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026 TastyFind Inc. Find the best food in your town.',
                );
              },
            ),
            const Divider(height: 1, indent: 16, color: AppColors.cardBorder),
            _buildTile(
              title: 'Terms & Privacy Policy',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('TastyFind standard terms and privacy policies applied.')),
                );
              },
            ),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.deepCharcoal),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted))
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(
              trailingText,
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
          ],
          const Icon(Icons.chevron_right_rounded, color: AppColors.textPlaceholder, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}
