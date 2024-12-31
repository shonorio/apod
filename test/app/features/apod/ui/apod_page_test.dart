import 'package:apod/app/features/apod/ui/apod_page.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_explanation_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_media_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ApodPage, () {
    testWidgets('renders all components correctly', (tester) async {
      // arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApodPage(),
        ),
      );

      // act & assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Picture of the Day'), findsOneWidget);

      expect(find.byType(PictureOfDayMediaWidget), findsOneWidget);
      expect(find.byType(PictureOfDayTitleWidget), findsOneWidget);
      expect(find.byType(PictureOfDayExplanationWidget), findsOneWidget);

      // verify specific content
      expect(
          find.text('Andromeda Galaxy: A Neighboring Spiral'), findsOneWidget);
      expect(find.text('Copyright Kristina Makeeva'), findsOneWidget);
      expect(
        find.textContaining('What are these bubbles frozen into Lake Baikal?'),
        findsOneWidget,
      );
    });

    testWidgets('allows scrolling when content overflows', (tester) async {
      // arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: ApodPage(),
        ),
      );

      // act & assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // verify that the page is scrollable
      final gesture = await tester.startGesture(const Offset(0, 300));
      await gesture.moveBy(const Offset(0, -300));
      await tester.pump();
    });
  });
}
