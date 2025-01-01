import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:apod/app/features/favorites/ui/favorites_page.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_empty_state.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/json_util.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  group(FavoritesPage, () {
    late FavoritesRepository repository;
    late FavoritesPageController controller;

    setUp(() {
      repository = MockFavoritesRepository();
      controller = FavoritesPageController(repository);
    });

    testWidgets('shows empty state when no favorites exist', (tester) async {
      // arrange
      when(() => repository.fetchFavorites()).thenAnswerWith(Success([]));
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: FavoritesPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      // assert
      expect(find.byType(FavoritesEmptyState), findsOneWidget);
      expect(find.byType(FavoritesListItems), findsNothing);
      expect(find.text('Favorites'), findsOneWidget);
      verify(() => repository.fetchFavorites()).called(1);
    });
    testWidgets('shows list of favorites when they exist', (tester) async {
      // arrange
      final favorites =
          JsonUtil.getJsonList(from: 'favorites_list_of_items.json')
              .map((e) => PictureOfDayEntity.fromJson(e))
              .toList();

      when(() => repository.fetchFavorites())
          .thenAnswerWith(Success(favorites));

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: FavoritesPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();

      // assert
      expect(find.text('Leaving Earth'), findsOneWidget);
      expect(find.text('Sunspot at Sunset'), findsOneWidget);
      expect(find.text('NGC 5189: An Unusually Complex Planetary Nebula'),
          findsOneWidget);
      expect(find.byType(FavoritesEmptyState), findsNothing);
      expect(find.byType(FavoritesListItems), findsOneWidget);
      verify(() => repository.fetchFavorites()).called(1);
    });

    testWidgets('can dismiss a favorite item', (tester) async {
      // arrange
      final favorites =
          JsonUtil.getJsonList(from: 'favorites_list_of_items.json')
              .map((e) => PictureOfDayEntity.fromJson(e))
              .toList();

      when(() => repository.fetchFavorites())
          .thenAnswerWith(Success(favorites));
      when(() => repository.removeFavorite(favorites.first))
          .thenAnswerWith(const Success(true));

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: FavoritesPage(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      // Verify the initial list.
      expect(find.byType(ListTile), findsNWidgets(3));

      // Perform a dismiss action on the first item.
      await tester.drag(
        find.byType(Dismissible).first,
        const Offset(-500, 0), // Drag left to dismiss.
      );
      await tester.pumpAndSettle();

      // assert
      verify(() => repository.removeFavorite(favorites.first)).called(1);
      expect(find.byType(ListTile), findsNWidgets(2));
    });
  });
}

extension WhenFuture<T> on When<Future<T>> {
  void thenAnswerWith(T value) => thenAnswer((_) async => value);
}
