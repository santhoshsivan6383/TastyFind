import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../providers/food_providers.dart';

class LocationPermissionScreen extends ConsumerWidget {
  const LocationPermissionScreen({super.key});

  void _showManualTownSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final townsAsync = ref.watch(townsListProvider);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Your Town',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.deepCharcoal),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose where you want to discover the best dishes',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                townsAsync.when(
                  data: (towns) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: towns.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final town = towns[i];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined, color: AppColors.primaryOrange),
                        title: Text(town.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(town.state),
                        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                        onTap: () {
                          ref.read(selectedTownProvider.notifier).state = town;
                          Navigator.pop(ctx);
                          context.go('/home');
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => ListTile(
                    title: const Text('Erode'),
                    onTap: () {
                      Navigator.pop(ctx);
                      context.go('/home');
                    },
                  ),
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
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Concentric map radar illustration
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                  ),
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryOrangeLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66FF5E1F),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 38),

              // Title
              const Text(
                'Allow location access',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepCharcoal,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                "We'll show you the best food\nnear you.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Allow Location CTA
              PrimaryButton(
                text: 'Allow Location',
                onPressed: () {
                  // Simulate granting location permission
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Location permission granted: Discovering dishes near Erode!'),
                      backgroundColor: AppColors.successGreen,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  context.go('/home');
                },
              ),
              const SizedBox(height: 16),

              // Maybe Later manual selection
              TextButton(
                onPressed: () => _showManualTownSelector(context, ref),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
