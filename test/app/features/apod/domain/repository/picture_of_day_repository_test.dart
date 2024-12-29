import 'package:apod/app/core/api_provider/errors/api_provider_exception.dart';
import 'package:apod/app/core/api_provider/interfaces/api_provider.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_builder.dart';
import 'package:apod/app/core/api_provider/interfaces/api_response.dart';
import 'package:apod/app/core/result/result.dart';
import 'package:apod/app/features/apod/domain/entity/picture_of_day_entity.dart';
import 'package:apod/app/features/apod/domain/errors/apod_server_exception.dart';
import 'package:apod/app/features/apod/domain/repository/picture_of_day_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/json_util.dart';

class MockApiProvider extends Mock implements ApiProvider {}

class ApiRequestBuilderFake extends Fake implements ApiRequestBuilder {}

void main() {
  late PictureOfDayRepository repository;
  late MockApiProvider mockApiProvider;

  const singleJsonFile = 'apod_server_single_object.json';

  setUp(() {
    mockApiProvider = MockApiProvider();
    repository = PictureOfDayRepository(apiProvider: mockApiProvider);
  });

  setUpAll(() {
    registerFallbackValue(ApiRequestBuilderFake());
  });

  group(PictureOfDayRepository, () {
    test(
        'should return Success with PictureOfDayEntity when request is successful',
        () async {
      // arrange
      final entity = PictureOfDayEntity.fromJson(
        JsonUtil.getJson(from: singleJsonFile),
      );
      when(() => mockApiProvider.request(any())).thenAnswer(
        (_) async => ApiResponse(
          statusCode: 200,
          body: JsonUtil.getContentFile(from: singleJsonFile),
        ),
      );
      // act
      final result = await repository()
          .getOrElse((_) => fail('test return Failure other than Success'));
      // assert
      expect(result, equals(entity));
    });

    test(
        'should return Failure with InvalidRequestException when request is invalid',
        () async {
      // arrange
      when(() => mockApiProvider.request(any())).thenThrow(
        ApiProviderRequestException(
          ApiResponse(
            statusCode: 400,
            body: JsonUtil.getContentFile(
                from: 'apod_server_invalid_request.json'),
          ),
        ),
      );
      // act
      final result = await repository();
      // assert
      expect(result.getError(), isA<InvalidRequestException>());
    });

    test(
        'should return Failure with RateLimitException when rate limit is exceeded',
        () async {
      // arrange
      when(() => mockApiProvider.request(any())).thenThrow(
        ApiProviderRateLimitException('Rate limit exceeded'),
      );
      // act
      final result = await repository();
      // assert
      expect(result.getError(), isA<RateLimitException>());
    });

    test(
        'should return Failure with ServerSideException when server error occurs',
        () async {
      // arrange
      when(() => mockApiProvider.request(any())).thenThrow(
        ApiProviderServerException(ApiResponse(statusCode: 500)),
      );
      // act
      final result = await repository();
      // assert
      expect(result.getError(), isA<ServerSideException>());
    });

    test(
        'should return Failure with NetworkException when network is unreachable',
        () async {
      // arrange
      when(() => mockApiProvider.request(any())).thenThrow(
        NetworkReachabilityException(
          'https://example.com',
          'Network is unreachable',
          500,
          '',
        ),
      );
      // act
      final result = await repository();
      // assert
      expect(result.getError(), isA<NetworkException>());
    });
  });
}
