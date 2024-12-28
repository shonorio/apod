/// Represents the configuration for making API requests.
///
/// This class stores the base URI that will be used as the starting point
/// for constructing full API request URLs. It provides a way to centralize
/// and manage the base URI for API calls within the application.
final class ApiConfiguration {
  /// Creates an instance of [ApiConfiguration] with the specified [baseUri].
  ///
  /// The [baseUri] represents the base URL for the API. It is used as
  /// the foundation for constructing full API endpoint URLs.
  ///
  /// Example usage:
  /// ```dart
  /// final apiConfig = ApiConfiguration(baseUri: Uri.parse('https://api.example.com/'));
  /// ```
  const ApiConfiguration({required this.baseUri});

  /// The base URI for the API.
  ///
  /// This URI is used as the starting point to construct full URLs for API requests.
  final Uri baseUri;
}
