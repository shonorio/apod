import 'package:flutter_test/flutter_test.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_request_builder.dart';

void main() {
  final baseUri = Uri.parse('https://api.nasa.gov');
  late PictureOfDayRequestBuilder builder;

  group(PictureOfDayRequestBuilder, () {
    test('builds basic request with only API key', () {
      // arrange
      builder = PictureOfDayRequestBuilder();
      // act
      final request = builder.buildRequest(baseUri);
      // assert
      expect(request.baseUrl.path, '/planetary/apod');
      expect(request.baseUrl.queryParameters['api_key'], isNotEmpty);
      expect(request.baseUrl.queryParameters['thumbs'], 'true');
      for (final it in ['date', 'count', 'start_date', 'end_date']) {
        expect(
          request.baseUrl.queryParameters.containsKey(it),
          false,
          reason: '"$it" value must be false',
        );
      }
    });

    test('includes date parameter when valid date is provided', () {
      // arrange
      final testDate = DateTime.now().subtract(const Duration(days: 1));
      builder = PictureOfDayRequestBuilder(date: testDate);
      // act
      final request = builder.buildRequest(baseUri);
      // assert
      expect(request.baseUrl.queryParameters['date'],
          testDate.toIso8601String().split('T')[0]);
    });

    test('ignores future dates', () {
      // arrange
      final futureDate = DateTime.now().add(const Duration(days: 1));
      builder = PictureOfDayRequestBuilder(date: futureDate);
      // act
      final request = builder.buildRequest(baseUri);
      // assert
      expect(request.baseUrl.queryParameters.containsKey('date'), isFalse);
    });

    group('count parameter', () {
      test('handles valid count', () {
        // arrange
        builder = PictureOfDayRequestBuilder(count: 5);
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(request.baseUrl.queryParameters['count'], '5');
        expect(request.baseUrl.queryParameters.containsKey('date'), isFalse);
      });

      test('clamps count to minimum 1', () {
        // arrange
        builder = PictureOfDayRequestBuilder(count: 0);
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(request.baseUrl.queryParameters['count'], '1');
      });

      test('clamps count to maximum 100', () {
        // arrange
        builder = PictureOfDayRequestBuilder(count: 101);
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(request.baseUrl.queryParameters['count'], '100');
      });
    });

    group('date range parameters', () {
      test('includes start_date and end_date when valid range provided', () {
        // arrange
        final endDate = DateTime.now().subtract(const Duration(days: 1));
        final startDate = endDate.subtract(const Duration(days: 5));

        builder = PictureOfDayRequestBuilder(
          startDate: startDate,
          endDate: endDate,
        );
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(request.baseUrl.queryParameters['start_date'],
            startDate.toIso8601String().split('T')[0]);
        expect(request.baseUrl.queryParameters['end_date'],
            endDate.toIso8601String().split('T')[0]);
        expect(request.baseUrl.queryParameters.containsKey('date'), isFalse);
        expect(request.baseUrl.queryParameters.containsKey('count'), isFalse);
      });

      test('ignores invalid date range (end before start)', () {
        // arrange
        final startDate = DateTime.now().subtract(const Duration(days: 1));
        final endDate = startDate.subtract(const Duration(days: 1));

        builder = PictureOfDayRequestBuilder(
          startDate: startDate,
          endDate: endDate,
        );
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(
            request.baseUrl.queryParameters.containsKey('start_date'), isFalse);
        expect(
            request.baseUrl.queryParameters.containsKey('end_date'), isFalse);
      });

      test('ignores future date range', () {
        // arrange
        final startDate = DateTime.now().add(const Duration(days: 1));
        final endDate = startDate.add(const Duration(days: 1));

        builder = PictureOfDayRequestBuilder(
          startDate: startDate,
          endDate: endDate,
        );
        // act
        final request = builder.buildRequest(baseUri);
        // assert
        expect(
            request.baseUrl.queryParameters.containsKey('start_date'), isFalse);
        expect(
            request.baseUrl.queryParameters.containsKey('end_date'), isFalse);
      });
    });
  });
}
