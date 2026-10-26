import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterTap;
  final VoidCallback? onClear;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool showFilterButton;
  final int activeFilterCount;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.hintText = 'Search for a dish (e.g. dosa, biryani...)',
    this.onChanged,
    this.onSubmitted,
    this.onFilterTap,
    this.onClear,
    this.readOnly = false,
    this.onTap,
    this.showFilterButton = false,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.deepCharcoal,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: AppColors.textPlaceholder,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
                suffixIcon: controller != null && controller!.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                        onPressed: onClear ?? () => controller?.clear(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        if (showFilterButton) ...[
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: activeFilterCount > 0 ? AppColors.primaryOrange : AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: activeFilterCount > 0 ? AppColors.primaryOrange : AppColors.cardBorder,
                  width: 1.2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: activeFilterCount > 0 ? Colors.white : AppColors.deepCharcoal,
                    size: 20,
                  ),
                  if (activeFilterCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
