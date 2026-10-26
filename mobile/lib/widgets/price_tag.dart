import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final double? maxPrice;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;

  const PriceTag({
    super.key,
    required this.price,
    this.maxPrice,
    this.fontSize = 15.0,
    this.fontWeight = FontWeight.w700,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final text = maxPrice != null
        ? '₹${price.toInt()} – ₹${maxPrice!.toInt()}'
        : '₹${price.toInt()}';

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppColors.deepCharcoal,
        letterSpacing: -0.2,
      ),
    );
  }
}
