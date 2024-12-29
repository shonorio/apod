import 'package:apod/app/core/storage_provider/shared_preferences_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferencesStorage storage;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    // Initialize shared preferences for testing
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    storage = SharedPreferencesStorage(sharedPreferences);
  });

  group(SharedPreferencesStorage, () {
    test('create - should store a value', () async {
      // act
      final result = await storage.create('test_key', 'test_value');
      // assert
      expect(result, true);
      expect(sharedPreferences.getString('test_key'), 'test_value');
    });

    group('fetch', () {
      test('with specific id - should return single value', () async {
        // arrange
        await sharedPreferences.setString('test_key', 'test_value');
        // act
        final result = await storage.fetch(id: 'test_key');
        // assert
        expect(result, ['test_value']);
      });

      test('with specific id - should return empty list if key not found',
          () async {
        // act
        final result = await storage.fetch(id: 'non_existent_key');
        // assert
        expect(result, isEmpty);
      });

      test('without id - should return all values', () async {
        // arrange
        await sharedPreferences.setString('key1', 'value1');
        await sharedPreferences.setString('key2', 'value2');
        // act
        final result = await storage.fetch();
        // assert
        expect(result, containsAll(['value1', 'value2']));
        expect(result.length, 2);
      });
    });

    test('delete - should remove value', () async {
      // arrange
      await sharedPreferences.setString('test_key', 'test_value');
      // act
      final result = await storage.delete('test_key');
      // assert
      expect(result, true);
      expect(sharedPreferences.getString('test_key'), null);
    });
  });
}
