import 'package:apod/app/core/api_provider/interfaces/api_request_builder.dart';
import 'package:apod/app/core/api_provider/interfaces/api_response.dart';

/// Abstract class representing a provider for making API requests.
///
/// This class defines a contract for implementing API request handling
/// and returning a response.
abstract class ApiProvider {
  /// Sends an API request using the provided [requestBuilder].
  ///
  /// The [requestBuilder] contains the details necessary to construct
  /// and execute the API request.
  ///
  /// Returns an [ApiResponse] containing the result of the request.
  ///
  /// Implementations should handle any network operations, serialization,
  /// and error handling necessary to fulfill the request.
  Future<ApiResponse> request(ApiRequestBuilder requestBuilder);
}
