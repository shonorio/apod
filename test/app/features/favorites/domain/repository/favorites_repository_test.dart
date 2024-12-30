import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/core/storage_provider/storage_provider.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/favorites/domain/repository/favorites_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/json_util.dart';

class MockStorageProvider extends Mock implements StorageProvider {}

void main() {
  late MockStorageProvider mockStorage;
  late FavoritesRepository repository;
  late PictureOfDayEntity testPicture;

  const singleJsonFile = 'apod_server_single_object.json';

  setUp(() {
    mockStorage = MockStorageProvider();
    repository = FavoritesRepository(mockStorage);
    testPicture = PictureOfDayEntity.fromJson(
      JsonUtil.getJson(from: singleJsonFile),
    );
  });

  group(FavoritesRepository, () {
    test('addFavorite success', () async {
      // arrange
      when(() => mockStorage.create(any(), any()))
          .thenAnswer((_) async => true);
      // act
      final result = await repository
          .addFavorite(testPicture)
          .getOrElse((_) => fail('test return Failure other than Success'));
      // assert
      expect(result, isTrue);
      verify(() => mockStorage.create('1735441200000', any())).called(1);
    });

    test('removeFavorite success', () async {
      // arrange
      when(() => mockStorage.delete(any())).thenAnswer((_) async => true);
      // act
      final result = await repository
          .removeFavorite(testPicture)
          .getOrElse((_) => fail('test return Failure other than Success'));
      // assert
      expect(result, isTrue);
      verify(() => mockStorage.delete('1735441200000')).called(1);
    });

    test('getFavorites returns empty list of favorites', () async {
      // arrange
      when(() => mockStorage.fetch()).thenAnswer((_) async => []);
      // act
      final result = await repository
          .getFavorites()
          .getOrElse((_) => fail('test return Failure other than Success'));
      // assert
      expect(result, isA<List<PictureOfDayEntity>>());
      expect(result.length, 0);
      verify(() => mockStorage.fetch()).called(1);
    });

    test('getFavorites returns list of favorites', () async {
      // arrange
      final testJson = {
        'date': '2024-01-01',
        'explanation': 'Test explanation',
        'title': 'Test title',
        'url': 'https://test.com',
        'media_type': 'image',
        'service_version': 'v1',
      };
      when(() => mockStorage.fetch()).thenAnswer((_) async => [testJson]);
      // act
      final result = await repository
          .getFavorites()
          .getOrElse((_) => fail('test return Failure other than Success'));
      // assert
      expect(result, isA<List<PictureOfDayEntity>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test title');
      verify(() => mockStorage.fetch()).called(1);
    });
  });
}
