import 'package:apod/app/features/favorites/ui/widgets/favorites_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(FavoritesEmptyState, () {
    testWidgets('displays correct elements', (tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: FavoritesEmptyState(),
        ),
      );

      // Verify the icon
      final iconFinder = find.byIcon(Icons.favorite_border);
      expect(iconFinder, findsOneWidget);
      final icon = tester.widget<Icon>(iconFinder);
      expect(icon.size, 64);
      expect(icon.color, Colors.grey);

      // Verify the main text
      expect(find.text('No favorites yet'), findsOneWidget);

      // Verify the subtitle text
      expect(
        find.text('Your favorite astronomy pictures will appear here'),
        findsOneWidget,
      );

      // Verify text alignment
      final subtitleText = tester.widget<Text>(
        find.text('Your favorite astronomy pictures will appear here'),
      );
      expect(subtitleText.textAlign, TextAlign.center);
    });
  });
}
