import 'dart:convert';

import 'package:apod/app/core/types/json.dart';

/// Represents the response from an API request.
///
/// This class encapsulates the HTTP status code and the response body
/// returned by the server, along with a method to parse the body as JSON.
final class ApiResponse {
  /// Creates an instance of [ApiResponse].
  ///
  /// - [statusCode]: The HTTP status code returned by the server.
  /// - [body]: The optional response body as a string. Defaults to `null`.
  const ApiResponse({
    required this.statusCode,
    this.body,
  });

  /// The HTTP response body, represented as a string.
  ///
  /// This may be `null` if the response does not contain a body.
  final String? body;

  /// The HTTP status code returned by the server.
  final int statusCode;

  /// Parses the response body as JSON and returns it as a [Json] object.
  ///
  /// If the body is `null` or cannot be parsed as valid JSON, an empty JSON
  /// object (`{}`) is returned.
  ///
  /// Throws a [FormatException] if the body contains invalid JSON.
  Json toJson() => jsonDecode(body ?? '{}') as Json;
}
