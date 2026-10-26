import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// TastyImage is a bulletproof image widget that safely loads either local assets
/// or remote network images with graceful local fallbacks, smooth loading states,
/// and border clipping. It guarantees that the UI never breaks or shows empty boxes.
class TastyImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String fallbackAsset;
  final Widget? placeholder;

  const TastyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackAsset = 'assets/images/food_placeholder.jpg',
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final url = imageUrl?.trim();

    if (url == null || url.isEmpty) {
      imageWidget = _buildFallback();
    } else if (url.startsWith('assets/')) {
      imageWidget = Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else if (url.startsWith('http://') || url.startsWith('https://')) {
      imageWidget = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          if (placeholder != null) return placeholder!;
          return Container(
            width: width,
            height: height,
            color: AppColors.backgroundLight,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange.withValues(alpha: 0.5)),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      // Local asset without prefix
      imageWidget = Image.asset(
        'assets/images/$url',
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Image.asset(
      fallbackAsset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) {
        return Container(
          width: width,
          height: height,
          color: AppColors.primaryOrangeLight,
          child: const Center(
            child: Icon(
              Icons.fastfood_rounded,
              color: AppColors.primaryOrange,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
