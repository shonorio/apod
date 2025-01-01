import 'package:apod/app/core/storage_provider/shared_preferences_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

class MockSharedPreferencesStore extends Mock
    implements SharedPreferencesStorePlatform {
  @override
  bool get isMock => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesStorage storage;
  late SharedPreferences sharedPreferences;
  late SharedPreferencesStorePlatform mockStore;

  setUp(() async {
    mockStore = MockSharedPreferencesStore();

    // Register the mock platform implementation
    SharedPreferencesStorePlatform.instance = mockStore;

    // Mock the `getAll` method
    when(() => mockStore.getAll()).thenAnswer((_) async => <String, Object>{
          'flutter.key_lindo': 'foo', // Ensure the proper prefix
        });

    // Mock the `setValue` method
    when(() => mockStore.setValue(any(), any(), any()))
        .thenAnswer((_) async => true); // Always return success

    sharedPreferences = await SharedPreferences.getInstance();
    storage = SharedPreferencesStorage();
  });

  group(SharedPreferencesStorage, () {
    test('create - should store a value', () async {
      // arrange
      final value = {'key': 'value', 'key2': true, 'key3': 3};
      when(() => mockStore.setValue(
              'String', 'ny_value', '{"key":"value","key2":true,"key3":3}'))
          .thenAnswer((_) async => true);

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
        final key1 = {'title': 'Picture 1', 'favorite': true, 'views': 42};
        final key2 = {'title': 'Picture 2', 'favorite': false, 'views': 42};
        await storage.create('00001', key1);
        await storage.create('00002', key2);
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
      when(() => mockStore.remove(any()))
          .thenAnswer((_) async => true); // Always return success

      await storage.create('key1', key1);
      // act
      final result = await storage.delete('key1');
      // assert
      expect(result, true);
      expect(sharedPreferences.getString('key1'), null);
    });
  });
}
