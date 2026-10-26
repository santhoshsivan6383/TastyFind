import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tastyfind/widgets/rating_badge.dart';
import 'package:tastyfind/widgets/price_tag.dart';
import 'package:tastyfind/widgets/primary_button.dart';
import 'package:tastyfind/widgets/feedback_widgets.dart';

void main() {
  group('TastyFind Reusable Widget Tests', () {
    testWidgets('RatingBadge renders star, rating and formatted review count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingBadge(rating: 4.8, reviewCount: 1200),
          ),
        ),
      );

      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(1.2k)'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('PriceTag renders single price and price range format', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PriceTag(price: 70),
                PriceTag(price: 60, maxPrice: 90),
              ],
            ),
          ),
        ),
      );

      expect(find.text('₹70'), findsOneWidget);
      expect(find.text('₹60 – ₹90'), findsOneWidget);
    });

    testWidgets('PrimaryButton renders text and triggers callback', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              text: 'Order Now',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Order Now'), findsOneWidget);
      await tester.tap(find.text('Order Now'));
      expect(tapped, isTrue);
    });

    testWidgets('EmptyStateWidget renders message and triggers retry', (tester) async {
      bool buttonClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No results found',
              message: 'Try another category',
              buttonText: 'Reset',
              onButtonPressed: () {
                buttonClicked = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('Try another category'), findsOneWidget);
      await tester.tap(find.text('Reset'));
      expect(buttonClicked, isTrue);
    });
  });
}
