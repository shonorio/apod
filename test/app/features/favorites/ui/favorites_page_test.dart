import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:apod/app/features/favorites/ui/favorites_page.dart';
import 'package:apod/app/features/favorites/ui/favorites_page_controller.dart';
import 'package:apod/app/features/favorites/ui/widgets/favorites_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

      // assert
      expect(find.byType(FavoritesEmptyState), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      verify(() => repository.fetchFavorites()).called(1);
    });
  });
}

extension WhenFuture<T> on When<Future<T>> {
  void thenAnswerWith(T value) => thenAnswer((_) async => value);
}
