/// Utility class for accessing environment variables specific to the application.
///
/// This class provides methods to fetch environment variables required
/// for application configuration, such as API tokens. It throws an exception
/// if a required variable is not found in the environment.
abstract class AppEnvironment {
  /// Retrieves the NASA API token from the environment.
  ///
  /// This method looks for the environment variable named `NASA_API_TOKEN`.
  /// If the variable is defined, it returns its value; otherwise, it throws
  /// an exception indicating the variable is missing.
  ///
  /// Example usage:
  /// ```dart
  /// final apiToken = AppEnvironment.nasaApiToken();
  /// ```
  ///
  /// Throws:
  /// - [Exception] if the `NASA_API_TOKEN` environment variable is not set.
  static String nasaApiToken() {
    const key = 'NASA_API_TOKEN';

    return const bool.hasEnvironment(key)
        ? const String.fromEnvironment(key)
        : throw Exception('Unable to find the environment key name: $key');
  }

  /// Retrieves the NASA API base URL from the environment.
  ///
  /// This method looks for the environment variable named `NASA_API_URL`.
  /// If the variable is defined, it parses and returns it as a [Uri];
  /// otherwise, it throws an exception indicating the variable is missing.
  ///
  /// Example usage:
  /// ```dart
  /// final apiUrl = AppEnvironment.nasaUri();
  /// ```
  ///
  /// Throws:
  /// - [Exception] if the `NASA_API_URL` environment variable is not set.
  static Uri nasaUri() {
    const key = 'NASA_API_URL';

    return const bool.hasEnvironment(key)
        ? Uri.parse(const String.fromEnvironment(key))
        : throw Exception('Unable to find the environment key name: $key');
  }
}
