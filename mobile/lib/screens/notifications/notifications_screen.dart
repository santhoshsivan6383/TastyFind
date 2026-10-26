import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../widgets/feedback_widgets.dart';
import '../../providers/food_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'review_helpful':
        return AppColors.successGreen;
      case 'offer':
        return AppColors.primaryOrange;
      case 'price_update':
        return const Color(0xFF3B82F6);
      case 'new_restaurant':
        return const Color(0xFF8B5CF6);
      default:
        return AppColors.primaryOrange;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'review_helpful':
        return Icons.thumb_up_alt_rounded;
      case 'offer':
        return Icons.local_offer_rounded;
      case 'price_update':
        return Icons.trending_down_rounded;
      case 'new_restaurant':
        return Icons.storefront_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: notificationsAsync.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyStateWidget(
              title: 'No new notifications',
              message: 'You are all caught up! Updates regarding your reviews and price changes will appear here.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final notif = list[i];
              final color = _getNotificationColor(notif.type);
              final icon = _getNotificationIcon(notif.type);

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepCharcoal,
                                  ),
                                ),
                              ),
                              Text(
                                notif.timeAgo,
                                style: const TextStyle(fontSize: 11, color: AppColors.textPlaceholder),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.body,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
        error: (_, __) => const EmptyStateWidget(
          title: 'Notifications unavailable',
          message: 'Unable to connect to notification services.',
        ),
      ),
    );
  }
}
