import 'package:apod/app/core/api_provider/interfaces/api_content_type.dart';
import 'package:apod/app/core/api_provider/interfaces/api_http_request_method.dart';
import 'package:apod/app/core/api_provider/interfaces/api_request_body.dart';

/// A type alias for HTTP headers, represented as a map of string key-value pairs.
///
/// The keys represent header names, and the values represent their corresponding values.
typedef HttpHeaders = Map<String, String>;

/// Represents an API request, encapsulating all necessary details to make a network call.
///
/// This class provides a structured way to define an API request, including the endpoint URL,
/// HTTP method, content type, body, and headers.
final class ApiRequest {
  /// Creates an instance of [ApiRequest].
  ///
  /// - [baseUrl]: The base URL of the API request.
  /// - [httpBody]: The body of the request, represented by an [ApiRequestBody].
  /// - [httpRequestMethod]: The HTTP method for the request (e.g., GET, POST). Defaults to [ApiHttpRequestMethod.get].
  /// - [contentType]: The content type of the request. Defaults to [ApiContentType.json].
  /// - [headers]: Optional HTTP headers to include with the request.
  const ApiRequest({
    required this.baseUrl,
    this.httpBody = const ApiRequestEmptyBody(),
    this.httpRequestMethod = ApiHttpRequestMethod.get,
    this.contentType = ApiContentType.json,
    this.headers,
  });

  /// The base URL of the API request.
  final Uri baseUrl;

  /// The HTTP method for the request, such as GET, POST, DELETE, or PUT.
  final ApiHttpRequestMethod httpRequestMethod;

  /// The content type of the request, typically used to specify data format (e.g., JSON).
  final ApiContentType contentType;

  /// The body of the request, containing the data to be sent.
  final ApiRequestBody httpBody;

  /// Optional headers to include with the request.
  ///
  /// Headers are represented as key-value pairs where the key is the header name
  /// and the value is the header value.
  final HttpHeaders? headers;
}
