/// Enum representing the HTTP methods used in API requests.
///
/// This can be used to specify the type of HTTP operation being performed.
enum ApiHttpRequestMethod {
  /// HTTP GET method, typically used to retrieve data from a server.
  get,

  /// HTTP POST method, typically used to send data to a server to create a resource.
  post,

  /// HTTP DELETE method, typically used to remove a resource from a server.
  delete,

  /// HTTP PUT method, typically used to update or replace a resource on a server.
  put,
}
