import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/domain/errors/apod_server_exception.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_repository.dart';
import 'package:apod/app/features/apod/ui/apod_page.dart';
import 'package:apod/app/features/apod/ui/apod_page_controller.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_explanation_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_media_widget.dart';
import 'package:apod/app/features/apod/ui/widget/picture_of_day_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/json_util.dart';

class MockPictureOfDayRepository extends Mock
    implements PictureOfDayRepository {}

void main() {
  group(ApodPage, () {
    late ApodPageController controller;
    late PictureOfDayRepository repository;

    setUp(() {
      repository = MockPictureOfDayRepository();
      controller = ApodPageController(repository);
    });

    testWidgets(
      'shows loading indicator when start page',
      (tester) async {
        // arrange
        when(() => repository.call()).thenAnswer(
          (_) async => Success(
            PictureOfDayEntity.fromJson(
              JsonUtil.getJson(from: 'apod_server_single_object.json'),
            ),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act & assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(PictureOfDayMediaWidget), findsNothing);
        expect(find.byType(PictureOfDayTitleWidget), findsNothing);
        expect(find.byType(PictureOfDayExplanationWidget), findsNothing);
      },
    );

    testWidgets(
      'shows no internet connection error when has no connection',
      (tester) async {
        // arrange
        when(() => repository.call()).thenAnswer(
          (_) async => const Failure(NetworkException()),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act
        await tester.pump();

        // assert
        expect(find.text('Unable to connect to the internet'), findsOneWidget);
        expect(
          find.text('Please check your connection and try again.'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'shows rate limit error when rate limit exceeded',
      (tester) async {
        // arrange
        when(() => repository.call()).thenAnswer(
          (_) async => const Failure(RateLimitException()),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act
        await tester.pump();

        // assert
        expect(find.text('Rate limit exceeded'), findsOneWidget);
        expect(
            find.text(
                'You have made too many requests. Please wait a moment before trying again.'),
            findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'shows error state when server error occurs',
      (tester) async {
        // arrange
        when(() => repository.call()).thenAnswer(
          (_) async => const Failure(ServerSideException()),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act
        await tester.pump();

        // assert
        expect(find.text('Error'), findsOneWidget);
        expect(
          find.text('An error occurred. Please try again later.'),
          findsOneWidget,
        );
        expect(find.text('Retry'), findsOneWidget);
      },
    );

    testWidgets(
      'shows success state when data loads successfully',
      (tester) async {
        // arrange
        final pictureOfDay = PictureOfDayEntity.fromJson(
          JsonUtil.getJson(from: 'apod_server_single_object.json'),
        );
        when(() => repository.call())
            .thenAnswer((_) async => Success(pictureOfDay));

        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act
        await tester.pump(const Duration(seconds: 1));

        // assert
        expect(find.byType(PictureOfDayMediaWidget), findsOneWidget);
        expect(find.byType(PictureOfDayTitleWidget), findsOneWidget);
        expect(find.byType(PictureOfDayExplanationWidget), findsOneWidget);

        // verify specific content
        expect(
            find.text('Methane Bubbles Frozen in Lake Baikal'), findsOneWidget);
        expect(find.text('Copyright © Kristina Makeeva'), findsOneWidget);
        expect(
          find.textContaining(
              'What are these bubbles frozen into Lake Baikal?'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'allows scrolling when content overflows',
      (tester) async {
        // arrange
        final pictureOfDay = PictureOfDayEntity.fromJson(
          JsonUtil.getJson(from: 'apod_server_single_object.json'),
        );
        when(() => repository.call())
            .thenAnswer((_) async => Success(pictureOfDay));

        await tester.pumpWidget(
          MaterialApp(
            home: ApodPage(controller: controller),
          ),
        );

        // act
        await tester.pump(const Duration(seconds: 1));

        // assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);

        // verify that the page is scrollable
        final gesture = await tester.startGesture(const Offset(0, 300));
        await gesture.moveBy(const Offset(0, -300));
        await tester.pump();
      },
    );
  });
}
