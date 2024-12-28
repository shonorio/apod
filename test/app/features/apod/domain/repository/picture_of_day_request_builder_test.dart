import 'package:flutter_test/flutter_test.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_request_builder.dart';
import 'package:apod/app/core/app_configuration/app_environment.dart';

void main() {
  final baseUri = Uri.parse('https://api.nasa.gov');

  group(PictureOfDayRequestBuilder, () {
    test(
      'builds request with only API key when no parameters provided',
      () {
        // Arrange
        final builder = PictureOfDayRequestBuilder();
        // Act
        final request = builder.buildRequest(baseUri);
        // Assert
        expect(
          request.baseUrl.queryParameters['api_key'],
          AppEnvironment.nasaApiToken(),
        );
        expect(
          request.baseUrl.queryParameters['thumbs'],
          'true',
        );

        for (var it in ['date', 'count', 'start_date', 'end_date']) {
          expect(
            request.baseUrl.queryParameters.containsKey(it),
            false,
            reason: '"$it" value must be false',
          );
        }
      },
    );

    test(
      'builds request with specific date',
      () {
        // Arrange
        final date = DateTime(2024, 3, 14);
        final builder = PictureOfDayRequestBuilder(date: date);
        // Act
        final request = builder.buildRequest(baseUri);
        // Assert
        expect(request.baseUrl.toString(), contains('date=2024-03-14'));
      },
    );

    test(
      'builds request with count parameter',
      () {
        // Arrange
        const expectedCount = 5;
        final builder = PictureOfDayRequestBuilder(count: expectedCount);
        // Act
        final request = builder.buildRequest(baseUri);
        // Assert
        expect(request.baseUrl.toString(), contains('count=$expectedCount'));
        expect(request.baseUrl.toString(), isNot(contains('date=')));
      },
    );

    test(
      'date parameter is removed when count is provided',
      () {
        // Arrange
        final date = DateTime(2024, 3, 14);
        final builder = PictureOfDayRequestBuilder(
          date: date,
          count: 5,
        );
        // Act
        final request = builder.buildRequest(baseUri);
        // Assert
        expect(
          request.baseUrl.toString(),
          contains('count=5'),
        );
        expect(
          request.baseUrl.queryParameters.containsKey('date'),
          false,
        );
      },
    );

    test(
      'builds request with date range',
      () {
        // Arrange
        final startDate = DateTime(2024, 3, 1);
        final endDate = DateTime(2024, 3, 14);
        final builder = PictureOfDayRequestBuilder(
          startDate: startDate,
          endDate: endDate,
          // date: DateTime.now(),
          // count: 5,
        );
        // Act
        final request = builder.buildRequest(baseUri);
        // Assert
        expect(request.baseUrl.toString(), contains('start_date=2024-03-01'));
        expect(request.baseUrl.toString(), contains('end_date=2024-03-14'));
        expect(request.baseUrl.queryParameters.containsKey('date'), false);
        expect(request.baseUrl.queryParameters.containsKey('count'), false);
      },
    );

    test('count and date parameters are removed when date range is provided',
        () {
      // Arrange
      final date = DateTime(2024, 3, 14);
      final startDate = DateTime(2024, 3, 1);
      final endDate = DateTime(2024, 3, 14);
      final builder = PictureOfDayRequestBuilder(
        date: date,
        count: 5,
        startDate: startDate,
        endDate: endDate,
      );
      // Act
      final request = builder.buildRequest(baseUri);
      // Assert
      expect(request.baseUrl.toString(), contains('start_date=2024-03-01'));
      expect(request.baseUrl.toString(), contains('end_date=2024-03-14'));
      expect(request.baseUrl.queryParameters.containsKey('date'), false);
      expect(request.baseUrl.queryParameters.containsKey('count'), false);
    });
  });
}
