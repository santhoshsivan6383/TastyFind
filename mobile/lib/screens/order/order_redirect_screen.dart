import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';

class OrderRedirectScreen extends ConsumerWidget {
  final String platform;
  final String dishName;
  final String restaurantName;
  final int dishId;
  final int restaurantId;

  const OrderRedirectScreen({
    super.key,
    required this.platform,
    required this.dishName,
    required this.restaurantName,
    required this.dishId,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Phone mockup graphic with green checkmark
              Center(
                child: Container(
                  width: 140,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner phone screen
                      Container(
                        width: 116,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: AppColors.successGreenLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.successGreen,
                              size: 42,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headline
              const Text(
                "You're all set!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepCharcoal,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Opening $platform...',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),

              // Neutral note
              Text(
                "You'll be redirected to $platform to complete your order.",
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Continue Button
              PrimaryButton(
                text: 'Continue',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 14),

              // Secondary Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Return to TastyFind', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  ),
                  const Text('•', style: TextStyle(color: AppColors.cardBorder)),
                  TextButton(
                    onPressed: () => context.push('/restaurant/$restaurantId'),
                    child: const Text('View Restaurant', style: TextStyle(color: AppColors.primaryOrange, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
