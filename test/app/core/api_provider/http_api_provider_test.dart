import 'dart:io';

import 'package:apod/app/core/api_provider/api_configuration.dart';
import 'package:apod/app/core/api_provider/errors/api_provider_exception.dart';
import 'package:apod/app/core/api_provider/http_api_provider.dart';
import 'package:apod/app/core/api_provider/interfaces/api_http_request_method.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_body.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockApiRequestBuilder extends Mock implements ApiRequestBuilder {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiConfiguration apiConfiguration;
  late ApiRequestBuilder getRequestBuilder;
  late Uri baseUri;
  const authority = 'example.org';
  const path = '/api';
  final getBodyResponse =
      File('test/data/stream_body_msg.json').readAsStringSync();

  setUpAll(() async {
    registerFallbackValue(Uri.http(authority, path));
    registerFallbackValue(http.Request('HEAD', Uri.http(authority, path)));
  });

  setUp(() async {
    baseUri = Uri.http(authority, path);
    apiConfiguration = ApiConfiguration(baseUri: baseUri);

    getRequestBuilder = MockApiRequestBuilder();
    when(() => getRequestBuilder.buildRequest(any())).thenReturn(
      ApiRequest(
        baseUrl:
            baseUri.appendingPath('/test').addingQueryParameters({'opt': '1'}),
        headers: {'client': 'header', 'empty': ''},
      ),
    );
  });

  group(HttpApiProvider, () {
    test(
      'must configure uri and header correct',
      () async {
        // arrange
        final inputStream = File('test/data/stream_body_msg.json').openRead();
        final http.Client apiClient = MockHttpClient();
        when(() => apiClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(inputStream, HttpStatus.ok));

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );
        // act
        await sut.request(getRequestBuilder);
        final captured = verify(() => apiClient.send(captureAny())).captured;

        // assert
        // Verify request builder
        expect(
          captured.first.url,
          Uri.http('example.org', 'api/test', {'opt': '1'}),
          reason: 'Concatenate path successfully',
        );
        expect(captured.first.method, 'GET');
        // Verify request header builder
        expect(
          captured.first.headers,
          containsPair('Content-Type', 'application/json; charset=utf-8'),
        );
      },
    );
    test(
      'do a successfully http GET for a valid request',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        final inputStream = File('test/data/stream_body_msg.json').openRead();

        when(() => apiClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(inputStream, HttpStatus.ok));

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );

        // act
        final httpResponse = await sut.request(getRequestBuilder);

        // Verify request builder
        // assert
        verify(() => getRequestBuilder.buildRequest(any())).called(1);
        final captured = verify(() => apiClient.send(captureAny())).captured;

        expect(captured.first.method, 'GET');

        expect(httpResponse.statusCode, HttpStatus.ok);
        expect(httpResponse.body, getBodyResponse);
      },
    );

    test(
      'do a successfully http POST for a valid request',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        final inputStream = File('test/data/stream_body_msg.json').openRead();
        final postBodyResponse =
            File('test/data/stream_body_msg.json').readAsStringSync();
        when(() => apiClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(inputStream, HttpStatus.ok));

        final postRequestBuilder = MockApiRequestBuilder();
        when(() => postRequestBuilder.buildRequest(any())).thenReturn(
          ApiRequest(
            baseUrl: baseUri.appendingPath('/post'),
            httpRequestMethod: ApiHttpRequestMethod.post,
            httpBody: ApiRequestJsonBody(data: {'key': 'value'}),
          ),
        );

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );

        // act
        final httpResponse = await sut.request(postRequestBuilder);

        // Verify request builder
        // assert
        verify(() => postRequestBuilder.buildRequest(any())).called(1);
        final captured = verify(() => apiClient.send(captureAny())).captured;

        expect(captured.first.method, 'POST');
        expect(httpResponse.statusCode, HttpStatus.ok);
        expect(httpResponse.body, postBodyResponse);
      },
    );

    test(
      'throw ApiProviderException for non 200 http code response',
      () async {
        final nonSuccessfulHttpCode = [400, 403, 422, 500, 502];

        for (final httpCode in nonSuccessfulHttpCode) {
          // arrange
          final inputStream = File('test/data/stream_body_msg.json').openRead();

          final http.Client apiClient = MockHttpClient();
          when(() => apiClient.send(any())).thenAnswer(
              (_) async => http.StreamedResponse(inputStream, httpCode));

          final sut = HttpApiProvider(
            client: apiClient,
            apiConfiguration: apiConfiguration,
          );

          // assert
          expect(
            () async => await sut.request(getRequestBuilder),
            throwsA(
              isA<ApiProviderException>().having(
                (error) => error.apiResponse.statusCode,
                'check status code',
                httpCode,
              ),
            ),
          );
        }
      },
    );

    test(
      'do a successfully http DELETE for a valid request',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        final inputStream = File('test/data/stream_body_msg.json').openRead();
        final deleteBodyResponse =
            File('test/data/stream_body_msg.json').readAsStringSync();
        when(() => apiClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(inputStream, HttpStatus.ok));

        final postRequestBuilder = MockApiRequestBuilder();
        when(() => postRequestBuilder.buildRequest(any())).thenReturn(
          ApiRequest(
            baseUrl: baseUri.appendingPath('/delete'),
            httpRequestMethod: ApiHttpRequestMethod.delete,
            httpBody: ApiRequestJsonBody(data: {'key': 'value'}),
          ),
        );

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );

        // act
        final httpResponse = await sut.request(postRequestBuilder);

        // Verify request builder
        // assert
        verify(() => postRequestBuilder.buildRequest(any())).called(1);
        final captured = verify(() => apiClient.send(captureAny())).captured;

        expect(captured.first.method, 'DELETE');
        expect(httpResponse.statusCode, HttpStatus.ok);
        expect(httpResponse.body, deleteBodyResponse);
      },
    );
    test(
      'do a successfully http PUT for a valid request',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        final inputStream = File('test/data/stream_body_msg.json').openRead();
        final deleteBodyResponse =
            File('test/data/stream_body_msg.json').readAsStringSync();
        when(() => apiClient.send(any())).thenAnswer(
            (_) async => http.StreamedResponse(inputStream, HttpStatus.ok));

        final postRequestBuilder = MockApiRequestBuilder();
        when(() => postRequestBuilder.buildRequest(any())).thenReturn(
          ApiRequest(
            baseUrl: baseUri.appendingPath('/put'),
            httpRequestMethod: ApiHttpRequestMethod.put,
            httpBody: ApiRequestJsonBody(data: {'key': 'value'}),
          ),
        );

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );
        // act
        final httpResponse = await sut.request(postRequestBuilder);

        // Verify request builder
        // assert
        verify(() => postRequestBuilder.buildRequest(any())).called(1);
        final captured = verify(() => apiClient.send(captureAny())).captured;

        expect(captured.first.method, 'PUT');
        expect(httpResponse.statusCode, HttpStatus.ok);
        expect(httpResponse.body, deleteBodyResponse);
      },
    );

    test(
      'throw ApiProviderInternalException for non SocketError',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        when(() => apiClient.send(any())).thenThrow(
          const OSError('galaxy_error', 42),
        );

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );
        // assert
        expect(
          () async => await sut.request(getRequestBuilder),
          throwsA(
            isA<ApiProviderInternalException>().having(
              (error) => error.message,
              'check error message',
              'OS Error: galaxy_error, errno = 42',
            ),
          ),
        );
      },
    );

    test(
      'throw NetworkReachabilityException for a SocketError',
      () async {
        // arrange
        final http.Client apiClient = MockHttpClient();
        when(() => apiClient.send(any())).thenThrow(
          const SocketException(
            'some error',
            osError: OSError('galaxy_error', 42),
          ),
        );

        final sut = HttpApiProvider(
          client: apiClient,
          apiConfiguration: apiConfiguration,
        );

        // assert
        expect(
          () async => await sut.request(getRequestBuilder),
          throwsA(
            isA<NetworkReachabilityException>().having(
              (error) => error.message,
              'check error message',
              'some error',
            ),
          ),
        );
      },
    );

    test('throws ApiProviderRateLimitException when rate limit exceeded',
        () async {
      // arrange
      final inputStream = File('test/data/stream_body_msg.json').openRead();
      final http.Client apiClient = MockHttpClient();
      when(() => apiClient.send(any()))
          .thenAnswer((_) async => http.StreamedResponse(
                inputStream,
                200,
                headers: {
                  'X-RateLimit-Limit': '1000',
                  'X-RateLimit-Remaining': '0',
                },
              ));

      final sut = HttpApiProvider(
        client: apiClient,
        apiConfiguration: apiConfiguration,
      );

      expect(
        () async => await sut.request(getRequestBuilder),
        throwsA(isA<ApiProviderRateLimitException>()),
      );
    });
  });
}
