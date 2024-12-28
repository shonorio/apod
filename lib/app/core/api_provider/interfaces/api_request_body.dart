import 'dart:convert';

import 'package:apod/app/core/types/json.dart';

/// Base class representing the body of an API request.
///
/// Subclasses should provide specific implementations to handle different
/// content types and serialization formats. This class defines the contract
/// for serializing the request body into a string format suitable for sending
/// in an API request.
sealed class ApiRequestBody {
  /// Returns the serialized representation of the request body as a string.
  ///
  /// Subclasses should implement this method to serialize their specific
  /// content type. For example, a subclass for JSON would serialize the
  /// body as a JSON string.
  String body();
}

/// Implementation of [ApiRequestBody] for JSON content.
///
/// This class encapsulates a JSON payload and provides a method to
/// serialize the data into a string format suitable for use in an API request.
///
/// Example usage:
/// ```dart
/// final jsonBody = ApiRequestJsonBody(data: {'key': 'value'});
/// final bodyString = jsonBody.body(); // Returns the serialized JSON string
/// ```
final class ApiRequestJsonBody implements ApiRequestBody {
  /// Creates an instance of [ApiRequestJsonBody] with the given [data].
  ///
  /// The [data] parameter represents the JSON payload to be sent in the
  /// request body. The data should be a [Json] object (typically a Map).
  ApiRequestJsonBody({required this.data});

  /// The JSON data to be sent in the request body.
  final Json data;

  /// Serializes the JSON data into a string.
  ///
  /// Uses [jsonEncode] to convert the [data] into a JSON string suitable
  /// for sending in an API request body.
  @override
  String body() => jsonEncode(data);
}

/// Implementation of [ApiRequestBody] for empty content.
///
/// This class represents an empty body for an API request, typically used
/// when no data needs to be sent in the request (e.g., for GET or DELETE requests).
final class ApiRequestEmptyBody implements ApiRequestBody {
  const ApiRequestEmptyBody();

  /// Returns an empty string representing the empty request body.
  ///
  /// This is used when there is no content to send in the request body.
  @override
  String body() => '';
}
