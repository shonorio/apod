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
      // arrange
      final value = {'key': 'value', 'key2': true, 'key3': 3};
      // act
      final result = await storage.create('test_key', value);
      // assert
      expect(result, true);
      expect(sharedPreferences.getString('test_key'),
          '{"key":"value","key2":true,"key3":3}');
    });

    group('fetch', () {
      test('with specific id - should return single value', () async {
        // arrange
        final value = {'key': 'value', 'key2': true, 'key3': 3};
        await sharedPreferences.setString(
            'test_key', '{"key":"value","key2":true,"key3":3}');
        // act
        final result = await storage.fetch(id: 'test_key');
        // assert
        expect(result, [value]);
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
        final key1 = {'key': 'value_1', 'key2': true, 'key3': 1};
        final key2 = {'key': 'value_2', 'key2': false, 'key3': 2};
        await storage.create('key1', key1);
        await storage.create('key2', key2);
        // act
        final result = await storage.fetch();
        // assert
        expect(result, equals([key1, key2]));
        expect(result.length, 2);
      });
    });

    test('delete - should remove value', () async {
      // arrange
      final key1 = {'key': 'value_1', 'key2': true, 'key3': 1};
      await storage.create('key1', key1);
      // act
      final result = await storage.delete('key1');
      // assert
      expect(result, true);
      expect(sharedPreferences.getString('key1'), null);
    });
  });
}
