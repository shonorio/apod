import 'dart:io';
import 'package:apod/app/core/api_provider/api_configuration.dart';
import 'package:apod/app/core/api_provider/errors/api_provider_exception.dart';
import 'package:apod/app/core/api_provider/interfaces/api_content_type.dart';
import 'package:apod/app/core/api_provider/interfaces/api_http_request_method.dart';
import 'package:apod/app/core/api_provider/interfaces/api_provider.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_builder.dart';
import 'package:apod/app/core/api_provider/interfaces/api_response.dart';
import 'package:http/http.dart' as http;

/// A concrete implementation of [ApiProvider] that uses the [http.Client] to send requests.
///
/// This class sends HTTP requests using the provided `http.Client` and the configuration
/// set by the `ApiConfiguration` instance. It handles serializing requests, managing headers,
/// and parsing responses, including handling common error cases.
///
/// Example usage:
/// ```dart
/// final apiProvider = HttpApiProvider(
///   client: http.Client(),
///   apiConfiguration: ApiConfiguration(baseUri: Uri.parse('https://api.example.com/')),
/// );
/// final response = await apiProvider.request(someApiRequestBuilder);
/// ```
final class HttpApiProvider implements ApiProvider {
  /// Creates an instance of [HttpApiProvider].
  ///
  /// The [client] parameter is the HTTP client used to send requests.
  /// The [apiConfiguration] parameter provides the base URI for API requests.
  HttpApiProvider({
    required http.Client client,
    required ApiConfiguration apiConfiguration,
  })  : _httpClient = client,
        _apiConfiguration = apiConfiguration;

  final http.Client _httpClient;
  final ApiConfiguration _apiConfiguration;

  static const _successfulResponse = {200, 201, 202, 204};
  static const _invalidRequest = {400, 404, 422};
  static const _serverExceptions = {500, 501, 505};
  static const _serverTimeout = {502, 503, 504};

  /// Sends an API request using the provided [requestBuilder].
  ///
  /// The [requestBuilder] creates an [ApiRequest] using the base URI and any other request
  /// details. This method will serialize the request, execute it, and parse the response.
  ///
  /// If the request fails due to network issues, a [NetworkReachabilityException] is thrown.
  /// If the server responds with an error status code, an appropriate exception is thrown
  /// based on the HTTP status code (e.g., [ApiProviderRequestException], [ApiProviderServerException]).
  ///
  /// Returns the parsed [ApiResponse] if the request is successful.
  @override
  Future<ApiResponse> request(ApiRequestBuilder requestBuilder) async {
    final request = requestBuilder.buildRequest(_apiConfiguration.baseUri);

    try {
      final response = await _execute(request, _buildHeader(request));
      return _parseResponse(response);
    } catch (e) {
      if (e is SocketException) {
        throw NetworkReachabilityException(
          request.baseUrl.toString(),
          e.message,
          e.osError?.errorCode,
          e.osError?.message,
        );
      }

      throw ApiProviderInternalException(e.toString());
    }
  }

  /// Executes the HTTP request using the provided [request] and [headers].
  ///
  /// The [request] contains the details of the API request, and [headers] is a map of headers
  /// to be included in the request. The method returns a [StreamedResponse] containing the
  /// server's response.
  Future<http.StreamedResponse> _execute(
    ApiRequest request,
    HttpHeaders headers,
  ) {
    final client = _httpClient;
    final myRequest =
        http.Request(request.httpRequestMethod.stringify, request.baseUrl)
          ..headers.addAll(headers)
          ..body = request.httpBody.body();

    return client.send(myRequest);
  }

  /// Builds the headers for the API request.
  ///
  /// This method generates the required headers, including the content type
  /// and any additional headers provided in the [request]. The headers are returned
  /// as a map of strings.
  HttpHeaders _buildHeader(ApiRequest request) {
    final headers = <String, String>{}
      ..addAll(
        {
          'Content-Type': request.contentType.stringify,
          'Accept-Encoding': 'gzip',
          ...request.headers ?? {}
        },
      )
      ..removeWhere((key, value) => value.isEmpty);

    return headers;
  }

  Future<ApiResponse> _parseResponse(http.StreamedResponse response) async {
    return response.stream.bytesToString().then((body) {
      final httpStatusCode = response.statusCode;
      final apiResponse = ApiResponse(
        body: body,
        statusCode: httpStatusCode,
      );

      if (_successfulResponse.contains(httpStatusCode)) {
        return apiResponse;
      } else if (_invalidRequest.contains(httpStatusCode)) {
        throw ApiProviderRequestException(apiResponse);
      } else if (_serverExceptions.contains(httpStatusCode)) {
        throw ApiProviderServerException(apiResponse);
      } else if (_serverTimeout.contains(httpStatusCode)) {
        throw ApiProviderServerTimeout(apiResponse);
      } else {
        throw ApiProviderException(apiResponse);
      }
    });
  }
}

/// Extension on [ApiHttpRequestMethod] to convert it to its string representation.
///
/// This extension helps to convert the HTTP request method enum into the string
/// values used in HTTP requests (e.g., 'GET', 'POST', 'PUT', 'DELETE').
extension _ApiHttpRequestMethodStringify on ApiHttpRequestMethod {
  String get stringify => switch (this) {
        ApiHttpRequestMethod.get => 'GET',
        ApiHttpRequestMethod.post => 'POST',
        ApiHttpRequestMethod.put => 'PUT',
        ApiHttpRequestMethod.delete => 'DELETE',
      };
}

/// Extension on [ApiContentType] to convert it to its string representation.
///
/// This extension helps to convert the content type enum into the string
/// values used in HTTP requests (e.g., 'application/json').
extension _ApiContentTypeStringify on ApiContentType {
  String get stringify => switch (this) {
        ApiContentType.json => 'application/json; charset=utf-8',
      };
}
