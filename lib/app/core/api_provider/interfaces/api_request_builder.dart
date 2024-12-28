import 'package:apod/app/core/api_provider/interfaces/api_request.dart';

/// Abstract class representing a builder for constructing API requests.
///
/// This class defines a contract for creating instances of [ApiRequest]
/// by combining a base URI with additional request-specific details, such as
/// HTTP method, headers, and body content.
///
/// Example:
/// Create an `ApiRequest` by just adding the desired `path` and keeping
/// the default configuration of HTTP method and content type.
///
/// ```dart
/// class AppStateEndpoint implements ApiRequestBuilder {
///   @override
///   ApiRequest buildRequest(Uri baseUri) {
///     final uri = baseUri.appendingPath('appState');
///     return ApiRequest(baseUrl: uri);
///   }
/// }
/// ```
abstract class ApiRequestBuilder {
  /// Builds an [ApiRequest] using the specified [baseUri].
  ///
  /// The [baseUri] represents the base URL of the API endpoint. Implementations
  /// should use this URI and append any necessary path segments, query parameters,
  /// or other details to construct the complete request.
  ///
  /// Returns an [ApiRequest] representing the constructed API request.
  ///
  /// Example:
  /// ```dart
  /// final request = appStateEndpoint.buildRequest(Uri.parse('https://api.example.com/'));
  /// ```
  ApiRequest buildRequest(Uri baseUri);
}

extension UriProvider on Uri {
  /// Appends a local path to the existing URI path, ensuring the path is correctly formatted.
  ///
  /// The method combines the current URI's path with the provided [localPath], removing
  /// any redundant or empty path segments.
  ///
  /// Example:
  /// ```dart
  /// final uri = Uri.parse('https://api.example.com/');
  /// final newUri = uri.appendingPath('endpoint');
  /// // Result: 'https://api.example.com/endpoint'
  /// ```
  Uri appendingPath(String localPath) {
    final segments = ('$path/$localPath').split('/')
      ..removeWhere((it) => it.isEmpty);
    return replace(pathSegments: segments);
  }

  /// Adds or merges query parameters into the existing URI.
  ///
  /// The method combines the query parameters already in the URI with the provided
  /// [clientQuery], allowing you to dynamically add or update query parameters.
  ///
  /// Example:
  /// ```dart
  /// final uri = Uri.parse('https://api.example.com/');
  /// final newUri = uri.addingQueryParameters({'key': 'value'});
  /// // Result: 'https://api.example.com/?key=value'
  /// ```
  Uri addingQueryParameters(HttpHeaders clientQuery) {
    final allQueryParameters = clientQuery;
    if (queryParameters.isNotEmpty) {
      allQueryParameters.addAll(queryParameters);
    }

    return replace(queryParameters: allQueryParameters);
  }
}
