import 'package:apod/app/core/api_provider/interfaces/api_response.dart';

/// Base class for exceptions thrown by the `ApiProvider`.
///
/// This exception contains the API response that caused the error.
final class ApiProviderException extends Error {
  /// Creates an instance of `ApiProviderException`.
  ///
  /// The [apiResponse] parameter provides details about the response
  /// that caused the exception.
  ApiProviderException(this.apiResponse);

  /// The API response associated with the exception.
  final ApiResponse apiResponse;
}

/// Exception thrown when there is an issue with the API request.
final class ApiProviderRequestException extends ApiProviderException {
  /// Creates an instance of `ApiProviderRequestException`.
  ///
  /// Inherits the [apiResponse] from the base class.
  ApiProviderRequestException(super.apiResponse);
}

/// Exception thrown when the server does not respond within the expected time.
final class ApiProviderServerTimeout extends ApiProviderException {
  /// Creates an instance of `ApiProviderServerTimeout`.
  ///
  /// Inherits the [apiResponse] from the base class.
  ApiProviderServerTimeout(super.apiResponse);
}

/// Exception thrown when the server returns an error response.
final class ApiProviderServerException extends ApiProviderException {
  /// Creates an instance of `ApiProviderServerException`.
  ///
  /// Inherits the [apiResponse] from the base class.
  ApiProviderServerException(super.apiResponse);
}

/// Exception thrown when an internal error occurs in the `ApiProvider`.
///
/// This exception contains a detailed error message.
final class ApiProviderInternalException extends Error {
  /// Creates an instance of `ApiProviderInternalException`.
  ///
  /// The [message] parameter provides details about the error.
  ApiProviderInternalException(this.message);

  /// Detailed error message.
  final String message;
}

/// Exception thrown when there is an issue with network reachability.
///
/// This exception contains information about the failed URI,
/// an error message, and optionally OS-specific error details.
final class NetworkReachabilityException extends Error {
  /// Creates an instance of `NetworkReachabilityException`.
  ///
  /// The [uri] parameter specifies the network resource being accessed.
  /// The [message] provides a description of the error.
  /// Optional parameters include [osErrorCode] and [osErrorMessage]
  /// for OS-specific error details.
  NetworkReachabilityException(
    this.uri,
    this.message,
    this.osErrorCode,
    this.osErrorMessage,
  );

  /// The URI associated with the network error.
  final String uri;

  /// Description of the network error.
  final String message;

  /// OS-specific error code, if available.
  final int? osErrorCode;

  /// OS-specific error message, if available.
  final String? osErrorMessage;
}
